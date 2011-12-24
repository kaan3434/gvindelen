unit uFormTableOrder;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uBaseNSIForm, DBGridEhGrouping, FIBDatabase, pFIBDatabase,
  ImgList, PngImageList, ActnList, DB, FIBDataSet, pFIBDataSet, GridsEh,
  DBGridEh, StdCtrls, JvExStdCtrls, JvGroupBox, ExtCtrls, JvExExtCtrls,
  JvExtComponent, JvPanel, TB2Item, TBX, TB2Dock, TB2Toolbar, ComCtrls,
  NativeXml, GvNativeXml, EhLibFIB;

type
  TFormTableOrders = class(TBaseNSIForm)
    pcDetailInfo: TPageControl;
    tsOrderAttrs: TTabSheet;
    tsOrderItems: TTabSheet;
    tsOrderTaxs: TTabSheet;
    qryOrderAttrs: TpFIBDataSet;
    dsOrderAttrs: TDataSource;
    grdOrderProperties: TDBGridEh;
    grdOrderItems: TDBGridEh;
    qryOrderItems: TpFIBDataSet;
    qryOrderTaxs: TpFIBDataSet;
    dsOrderItems: TDataSource;
    dsOrderTaxs: TDataSource;
    grdOrderTaxs: TDBGridEh;
    actSendOrders: TAction;
    actFilterApproved: TAction;
    actFilterAcceptRequest: TAction;
    ts1: TTabSheet;
    qryStatuses: TpFIBDataSet;
    grdAccountMovements: TDBGridEh;
    qryAccountMovements: TpFIBDataSet;
    dsAccountMovements: TDataSource;
    tsHistory: TTabSheet;
    grdHistory: TDBGridEh;
    qryHistory: TpFIBDataSet;
    dsHistory: TDataSource;
    actMakeInvoice: TAction;
    btnMakeInvoice: TTBXItem;
    procedure actSendOrdersExecute(Sender: TObject);
    procedure actFilterApprovedExecute(Sender: TObject);
    procedure actFilterAcceptRequestExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure grdMainDblClick(Sender: TObject);
    procedure actMakeInvoiceExecute(Sender: TObject);
  private
    procedure ApplyFilter(aStatusSign: string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormTableOrders: TFormTableOrders;

implementation

uses
  udmOtto, GvStr, uFormWizardOrder, uMain;

{$R *.dfm}

procedure TFormTableOrders.actSendOrdersExecute(Sender: TObject);

function GetPlace(ndPlace: TXmlNode; MaxLen: integer): string;
begin
  if GetXmlAttrValue(ndPlace, 'PLACETYPE_CODE', '4') = 4 then
    Result:= Translit(GetXmlAttr(ndPlace, 'PLACE_NAME'))
  else
    Result:= Translit(GetXmlAttr(ndPlace, 'PLACETYPE_NAME', ' ', '.') +
                     GetXmlAttr(ndPlace, 'PLACE_NAME', ' '));
end;

function GetAdress(ndAdress: TXmlNode; MaxLen: integer): string;
var
  Part1, Part2: string;
begin
   if GetXmlAttrValue(ndAdress, 'STREETTYPE_CODE', '1') > 1 then
     Part1:= Translit(GetXmlAttr(ndAdress, 'STREETTYPE_NAME', ' ', '. ') +
                      GetXmlAttr(ndAdress, 'STREET_NAME'))
   else
     Part1:= Translit(GetXmlAttr(ndAdress, 'STREET_NAME'));

   Part2:= Translit(GetXmlAttr(ndAdress, 'HOUSE', ', ') +
                    GetXmlAttr(ndAdress, 'BUILDING', '/') +
                    GetXmlAttr(ndAdress, 'FLAT', '-'));
   Result:= Part1 + Part2;
   if Length(Result) <= MaxLen then Exit;
   Result:= Copy(Part1, 1, MaxLen-Length(Part2)-1)+'.'+Part2;
end;

procedure MakeXMLOrderApproved(ndProduct: TXmlNode);
var
  Orders, OrderItems: string;
  OrderId, OrderItemId: variant;
  ndOrders, ndOrder, ndOrderItems, ndOrderItem, ndClient, ndAdress,
  ndPlace: TXmlNode;
begin
  ndOrders:= ndProduct.NodeNew('ORDERS');
  Orders:= dmOtto.dbOtto.QueryValue(
    'select list(o.order_id) '+
    'from orders o '+
    'inner join statuses s on (s.status_id = o.status_id) '+
    'where s.status_sign = ''APPROVED'' '+
    'group by o.status_id', 0);
  while Orders <> '' do
  begin
    orderId:= TakeFront5(Orders, ',');
    ndOrder:= ndOrders.NodeNew('ORDER');
    ndClient:= ndOrder.NodeNew('CLIENT');
    ndAdress:= ndOrder.NodeNew('ADRESS');
    ndPlace:= ndAdress.NodeNew('PLACE');
    ndOrderItems:= ndOrder.NodeNew('ORDERITEMS');
    dmOtto.ObjectGet(ndOrder, OrderId, trnNSI);
    dmOtto.ObjectGet(ndProduct, GetXmlAttrValue(ndOrder, 'PRODUCT_ID'), trnNSI);
    dmOtto.ObjectGet(ndClient, GetXmlAttrValue(ndOrder, 'CLIENT_ID'), trnNSI);
    dmOtto.ObjectGet(ndAdress, GetXmlAttrValue(ndOrder, 'ADRESS_ID'), trnNSI);
    dmOtto.ObjectGet(ndPlace, GetXmlAttrValue(ndAdress, 'PLACE_ID'), trnNSI);
    OrderItems:= dmOtto.dbOtto.QueryValue(
      'select list(oi.orderitem_id) '+
      'from orderitems oi '+
      'inner join statuses s on (s.status_id = oi.status_id) '+
      'where s.status_sign = ''APPROVED'' '+
      ' and oi.order_id = :order_id '+
      'group by oi.order_id', 0, [OrderId]);
    while OrderItems<>'' do
    begin
      OrderItemId:= TakeFront5(OrderItems, ',');
      ndOrderItem:= ndOrderItems.NodeNew('ORDERITEM');
      dmOtto.ObjectGet(ndOrderItem, OrderItemId, trnNSI);
    end;
  end;
end;

function FillHead(ndProduct, ndOrder: TXmlNode): string;
var
  ndClient, ndAdress, ndPlace: TXmlNode;
  Line: TStringList;
begin
  ndClient:= ndOrder.NodeByName('CLIENT');
  ndAdress:= ndOrder.NodeByName('ADRESS');
  ndPlace:= ndAdress.NodeByName('PLACE');
  Line:= TStringList.Create;
  try
    Line.Add(GetXmlAttrValue(ndProduct, 'PARTNER_NUMBER'));
    Line.Add(FilterString(GetXmlAttrValue(ndOrder, 'ORDER_CODE'), '0123456789'));
//    Line.Add(GetXmlAttrValue(ndOrder, 'CLIENT_ID'));
    Line.Add('100');
    Line.Add('1');
    Line.Add(Translit(GetXmlAttr(ndClient, 'LAST_NAME')));
    Line.Add(Translit(GetXmlAttr(ndClient, 'FIRST_NAME'))+' '+
             Translit(Copy(GetXmlAttr(ndClient, 'MID_NAME'), 1, 1)+'.'));
    Line.Add('');
    Line.Add(GetAdress(ndAdress, 32));
    Line.Add(GetXmlAttr(ndPlace, 'AREA_NAME', '', ' р-н'));
    Line.Add(GetXmlAttr(ndAdress, 'POSTINDEX'));
    Line.Add(GetPlace(ndPlace, 24));
    if GetXmlAttr(ndClient, 'STATUS_SIGN') = 'APPROVED' then
      Line.Add('N')
    else
      Line.Add('U');
    Result:= ReplaceAll(Line.Text, #13#10, ';');
  finally
    Line.Free;
  end;
end;

function FillItem(ndProduct, ndOrder, ndOrderItem: TXmlNode): string;
var
  Line: TStringList;
  Dimension: string;
begin
  Line:= TStringList.Create;
  try
    Line.Add(GetXmlAttrValue(ndProduct, 'PARTNER_NUMBER'));
    Line.Add(GetXmlAttrValue(ndOrder, 'CLIENT_ID'));
    Line.Add('200');
    Line.Add(FilterString(GetXmlAttrValue(ndOrder, 'ORDER_CODE'), '0123456789'));
//    Line.Add(GetXmlAttrValue(ndOrder, 'ORDER_CODE'));
    Line.Add(GetXmlAttrValue(ndOrderItem, 'ARTICLE_CODE'));
    Dimension:= GetXmlAttrValue(ndOrderItem, 'DIMENSION');
    if FilterString(Dimension, '0123456789') <> Dimension then
      Dimension:= dmOtto.Recode('ARTICLE', 'DIMENSION_ENCODE', Dimension);
    Line.Add(Dimension);
    Line.Add(GetXmlAttrValue(ndOrderItem, 'AMOUNT'));
    Line.Add(GetXmlAttrValue(ndOrderItem, 'COST_EUR'));
    Line.Add(GetXmlAttr(ndOrderItem, 'PAGE_NO'));
    Line.Add(GetXmlAttr(ndOrderItem, 'POSITION_SIGN'));
    Line.Add('');
    Line.Add('0');
    Result:= ReplaceAll(Line.Text, #13#10, ';');
  finally
    Line.Free;
  end
end;

var
  XmlOrders: TNativeXml;
  ndProduct, ndOrders, ndOrder, ndOrderItems, ndOrderItem: TXmlNode;
  st: string;
  slHead, slItems, Line: TStringList;
  i, j: Integer;
  FileName: string;
begin
  if MessageDlg('—формировать файл с за€вками?', mtConfirmation, mbOkCancel, 0) = mrOk then
  begin
    XmlOrders:= TNativeXml.CreateName('PRODUCT');
    try
      ndProduct:= XmlOrders.Root;
      MakeXMLOrderApproved(ndProduct);
      XmlOrders.XmlFormat:= xfReadable;
      XmlOrders.SaveToFile('SendOrders.xml');

      slHead:= TStringList.Create;
      try
        slItems:= TStringList.Create;
        try
          ndOrders:= ndProduct.NodeByName('ORDERS');
          For i:= 0 to ndOrders.NodeCount - 1 do
          begin
            ndOrder:= ndOrders[i];
            slHead.Add(FillHead(ndProduct, ndOrder));
            ndOrderItems:= ndOrder.NodeByName('ORDERITEMS');
            for j:= 0 to ndOrderItems.NodeCount - 1 do
            begin
              ndOrderItem:= ndOrderItems[j];
              slItems.Add(FillItem(ndProduct, ndOrder, ndOrderItem));
            end;
          end;
          slHead.AddStrings(slItems);
        finally
          slItems.Free;
        end;
        slHead.Text:= ReplaceAll(slHead.Text, ';'#13#10, #13#10);
        FileName:= dmOtto.dbOtto.QueryValue(
          'select o_filename from message_2_get_filename(:partnet_number, :portion_no)',
          0, [GetXmlAttrValue(ndProduct, 'PARTNER_NUMBER'), 1], trnNSI);
        slHead.SaveToFile(Path['Messages.Out']+FileName);
        try
          for i:= 0 to ndOrders.NodeCount - 1 do
          begin
            ndOrder:= ndOrders[i];
            dmOtto.ActionExecute(trnNSI, ndOrder, 'ACCEPTREQUEST');
          end;
          trnNSI.Commit;
        except
          trnNSI.Rollback;
        end;
        qryMain.CloseOpen(true);
      finally
        slHead.Free;
      end;
    finally
      XmlOrders.Free;
    end;
  end;
end;

procedure TFormTableOrders.ApplyFilter(aStatusSign: string);
var
  StatusName: string;
  Column: TColumnEh;
begin
  StatusName:= qryStatuses.Lookup('OBJECT_SIGN;STATUS_SIGN',VarArrayOf(['ORDER', aStatusSign]), 'STATUS_NAME');
  Column:= grdMain.FieldColumns['STATUS_NAME'];
  Column.STFilter.ExpressionStr:= '='+StatusName;
  grdMain.ApplyFilter;
end;

procedure TFormTableOrders.actFilterApprovedExecute(Sender: TObject);
begin
  ApplyFilter('APPROVED');
end;

procedure TFormTableOrders.actFilterAcceptRequestExecute(Sender: TObject);
begin
  ApplyFilter('ACCEPTREQUEST');
end;

procedure TFormTableOrders.FormCreate(Sender: TObject);
begin
  inherited;
  trnNSI.StartTransaction;
  qryMain.Open;
  qryOrderAttrs.Open;
  qryOrderItems.Open;
  qryOrderTaxs.Open;
  qryStatuses.Open;
  qryAccountMovements.Open;
  qryHistory.Open;
end;

procedure TFormTableOrders.grdMainDblClick(Sender: TObject);
begin
  TFormWizardOrder.CreateDB(Self, qryMain['order_id']).Show;
end;

procedure TFormTableOrders.actMakeInvoiceExecute(Sender: TObject);
begin
  MainForm.PrintInvoice(trnWrite, qryMain['ORDER_ID']);
end;

end.
