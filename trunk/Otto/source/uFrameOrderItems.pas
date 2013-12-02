unit uFrameOrderItems;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, PngImageList, ActnList, FIBDatabase,
  pFIBDatabase, TBXStatusBars, TB2Dock, TB2Toolbar, TBX, 
  MemTableDataEh, Db, FIBDataSet, pFIBDataSet, MemTableEh, ExtCtrls,
  JvExExtCtrls, JvImage, GridsEh, DBGridEh, NativeXml, JvComponentBase,
  JvProgressComponent, TB2Item, StdCtrls, JvExStdCtrls, JvGroupBox,
  JvEmbeddedForms, JvFormAutoSize, uFrameBase1, DBGridEhGrouping,
  ToolCtrlsEh, DBGridEhToolCtrls, DBAxisGridsEh;

type
  TFrameOrderItems = class(TFrameBase1)
    mtblOrderItems: TMemTableEh;
    fldOrderItems_ORDERITEM_ID: TIntegerField;
    fldOrderItems_MAGAZINE_ID: TIntegerField;
    fldOrderItems_ARTICLE_CODE: TStringField;
    fldOrderItems_DIMENSION: TStringField;
    fldOrderItems_PRICE_EUR: TFloatField;
    fldOrderItems_WEIGHT: TIntegerField;
    fldOrderItems_NAME_RUS: TStringField;
    fldOrderItems_KIND_RUS: TStringField;
    fldOrderItems_STATUS_ID: TIntegerField;
    fldOrderItems_STATUS_NAME: TStringField;
    fldOrderItems_COUNT_WEIGHT: TIntegerField;
    fldOrderItems_STATUS_SIGN: TStringField;
    fldOrderItems_STATE_ID: TIntegerField;
    fldOrderItems_STATE_NAME: TStringField;
    dsOrderItems: TDataSource;
    qryStatuses: TpFIBDataSet;
    actCheckAvailable: TAction;
    btnCheckAvailable: TTBXItem;
    fldOrderItems_ORDER_ID: TIntegerField;
    grBoxOrderItems: TJvGroupBox;
    grdOrderItems: TDBGridEh;
    actCancelRequest: TAction;
    actReturnRequest: TAction;
    btn1: TTBXItem;
    btn2: TTBXItem;
    actDublicate: TAction;
    btn3: TTBXItem;
    actApprove: TAction;
    btn4: TTBXItem;
    fldOrderItems_ORDERITEM_INDEX: TIntegerField;
    actSetStatus: TAction;
    subSetStatuses: TTBXSubmenuItem;
    qryNextStatus: TpFIBDataSet;
    fldOrderItemsFLAG_SIGN_LIST: TStringField;
    fldOrderItems_COST_EUR: TFloatField;
    fldOrderItems_AMOUNT: TIntegerField;
    subDiscard: TTBXSubmenuItem;
    actDiscard: TAction;
    btnDiscard: TTBXItem;
    procedure ProgressCheckAvailShow(Sender: TObject);
    procedure actCheckAvailableExecute(Sender: TObject);
    procedure grdOrderItemsColEnter(Sender: TObject);
    procedure mtblOrderItemsSetFieldValue(MemTable: TCustomMemTableEh;
      Field: TField; var Value: Variant);
    procedure mtblOrderItemsBeforeEdit(DataSet: TDataSet);
    procedure mtblOrderItemsBeforeInsert(DataSet: TDataSet);
    procedure mtblOrderItemsBeforePost(DataSet: TDataSet);
    procedure actCancelRequestExecute(Sender: TObject);
    procedure actCancelRequestUpdate(Sender: TObject);
    procedure actReturnRequestExecute(Sender: TObject);
    procedure actReturnRequestUpdate(Sender: TObject);
    procedure actCheckAvailableUpdate(Sender: TObject);
    procedure grdOrderItemsEnter(Sender: TObject);
    procedure actDublicateExecute(Sender: TObject);
    procedure actApproveExecute(Sender: TObject);
    procedure actApproveUpdate(Sender: TObject);
    procedure grdOrderItemsGetCellParams(Sender: TObject;
      Column: TColumnEh; AFont: TFont; var Background: TColor;
      State: TGridDrawState);
    procedure actSetStatusExecute(Sender: TObject);
    procedure mtblOrderItemsAfterScroll(DataSet: TDataSet);
    procedure mtblOrderItemsAfterInsert(DataSet: TDataSet);
    procedure grdOrderItemsKeyPress(Sender: TObject; var Key: Char);
    procedure actDiscardUpdate(Sender: TObject);
    procedure actDiscardExecute(Sender: TObject);
  private
    { Private declarations }
    FQryStatuses: Pointer;
    function GetOrderId: Integer;
  public
    { Public declarations }
    ndOrder: TXmlNode;
    ndOrderItems: TXmlNode;
    ndOrderItem: TXmlNode;
    procedure InitData; override;
    procedure FreeData; override;
    procedure OpenTables; override;
    procedure Read; override;
    procedure Write; override;
    property OrderId: Integer read GetOrderId;
  end;

var
  FrameOrderItems: TFrameOrderItems;

implementation

{$R *.dfm}

Uses
  GvNativeXml, udmOtto, GvStr, GvColor, GvVariant;
{ TFrameOrderItems }

procedure TFrameOrderItems.FreeData;
begin
  inherited;
  qryStatuses:= RestoreComponent(qryStatuses, FqryStatuses);
end;

procedure TFrameOrderItems.InitData;
begin
  inherited;
  qryStatuses:= StoreComponent(qryStatuses, FqryStatuses);
end;

function TFrameOrderItems.GetOrderId: Integer;
begin
  Result:= ndOrder.ReadAttributeInteger('ID', 0)
end;

procedure TFrameOrderItems.Write;
var
  OrderItemId, i: Integer;
begin
  inherited;
  if mtblOrderItems.State <> dsBrowse then
    mtblOrderItems.Post;
  mtblOrderItems.Tag:= 1;
  try
    Saved:= False;
    For i:= 0 to ndOrderItems.NodeCount - 1 do
    begin
      ndOrderItem:= ndOrderItems[i];
      OrderItemId:= GetXmlAttrValue(ndOrderItem, 'ID');
      mtblOrderItems.Locate('ORDERITEM_ID', OrderItemId, []);
      BatchMoveFields2(ndOrderItem, mtblOrderItems,
        'KIND_RUS;STATE_ID;WEIGHT;STATUS_FLAG_LIST=FLAG_SIGN_LIST;MAGAZINE_ID', false);
      BatchMoveFields2(ndOrderItem, mtblOrderItems,
        'ARTICLE_CODE;DIMENSION;PRICE_EUR;COST_EUR;NAME_RUS;STATUS_ID', true);
      dmOtto.ActionExecute(trnWrite, ndOrderItem);
      dmOtto.ObjectGet(ndOrderItem, OrderItemId, trnWrite);
    end;
    Saved:= True;
  finally
    mtblOrderItems.Tag:= 0;
  end;
end;

procedure TFrameOrderItems.Read;
begin
  mtblOrderItems.Tag:= 1;
  try
    BatchMoveXMLNodes2Dataset(mtblOrderItems, ndOrderItems,
      'ORDERITEM_ID=ID;ORDER_ID;MAGAZINE_ID;ARTICLE_CODE;DIMENSION;'+
      'PRICE_EUR;WEIGHT;NAME_RUS;KIND_RUS;STATUS_ID;STATE_ID;FLAG_SIGN_LIST=STATUS_FLAG_LIST;'+
      'AMOUNT;COST_EUR;ORDERITEM_INDEX',
      cmReplace);
    if mtblOrderItems.State <> dsBrowse then
      mtblOrderItems.Post;
  finally
    mtblOrderItems.Tag:= 0;
  end;
  mtblOrderItemsAfterScroll(mtblOrderItems);
end;

procedure TFrameOrderItems.ProgressCheckAvailShow(Sender: TObject);
var
  PluginExec: procedure (URL, RootNodeName: WideString; var aParams: WideString); stdcall;
  PluginName: String;
  URL: WideString;
  handle: THandle;
  XmlText: UTF8String;
  WXml: WideString;
  xmlAvail: TNativeXml;
  i: Integer;
  nDimension: string;
  OrderItemId: Integer;
begin
  ProgressCheckAvail.ProgressMax:= ndOrderItems.NodeCount;
  ProgressCheckAvail.ProgressPosition:= 0;

  ndOrder.Document.XmlFormat:= xfReadable;
  ndOrder.Document.SaveToFile('Order.xml');
  for i:= 0 to ndOrderItems.NodeCount - 1 do
  begin
    ndOrderItem:= ndOrderItems[i];
    OrderItemId:= GetXmlAttrValue(ndOrderItem, 'ID');
    if FlagPresent('DELETEABLE', ndOrderItem, 'STATUS_FLAG_LIST') then
    begin
      nDimension:= GetXmlAttrValue(ndOrderItem, 'DIMENSION');
      ProgressCheckAvail.ProgressStepIt;

      PluginName:= 'otto_check_available';
      Url:= dmOtto.dbOtto.QueryValue('select o_value from plugin_value(:plugin_sign, :param_sign)',
          0, [PluginName, 'URL']);

      handle := LoadLibrary('request_xml.plg');
      xmlAvail:= TNativeXml.Create;
      try
        try
          if handle > 0 then
          try
            @PluginExec := GetProcAddress(handle,'Execute');
            XmlText:= ndOrderItem.WriteToString;
            WXml:= XmlText;
            PluginExec(url, 'availability', WXml);
            if WXml <> '' then
              xmlAvail.ReadFromString(WXml);
          finally
            FreeLibrary(handle);
          end;
          BatchMoveFields2(ndOrderItem, xmlAvail.Root, 'AVAILABLE=available;AVAILABILITY_CODE=availability_code');
          if AttrExists(ndOrderItem, 'AVAILABLE') then
          begin
            Case GetXmlAttrValue(ndOrderItem, 'AVAILABLE') of
             0: begin
                  SetXmlAttr(ndOrderItem, 'NEW.STATE_SIGN', 'UNAVAILABLE');
                  SetXmlAttr(ndOrderItem, 'NEW.STATUS_SIGN', 'SOLD');
                end;
             1: SetXmlAttr(ndOrderItem, 'NEW.STATE_SIGN', 'AVAILABLE');
             2: SetXmlAttr(ndOrderItem, 'NEW.STATE_SIGN', 'DELAY3WEEK');
             21: SetXmlAttr(ndOrderItem, 'NEW.STATE_SIGN', 'DELAY3WEEK');
            end;
          end;
        finally
          xmlAvail.Free;
        end;
      except
      end;

      dmOtto.ActionExecute(trnWrite, ndOrderItem);
      dmOtto.ObjectGet(ndOrderItem, OrderItemId, trnWrite);
    end
  end;
end;

procedure TFrameOrderItems.actCheckAvailableExecute(Sender: TObject);
begin
  Write;
  ProgressCheckAvail.Execute;
  Read;
end;

procedure TFrameOrderItems.grdOrderItemsColEnter(Sender: TObject);
var
  Column: TColumnEh;
begin
  Column:= grdOrderItems.Columns[grdOrderItems.col-1];
  dmOtto.SetKeyLayout(Column.Tag);
end;

procedure TFrameOrderItems.mtblOrderItemsBeforeEdit(DataSet: TDataSet);
begin
  if DataSet.Tag = 1 then Exit;
  if not FlagPresent('EDITABLE', ndOrderItem, 'STATUS_FLAG_LIST') then
    Abort;
end;

procedure TFrameOrderItems.mtblOrderItemsBeforeInsert(DataSet: TDataSet);
begin
  if DataSet.Tag = 1 then Exit;
  if not FlagPresent('APPENDABLE', ndOrder, 'STATUS_FLAG_LIST') then
    Abort;
end;

procedure TFrameOrderItems.OpenTables;
begin
  inherited;
  mtblOrderItems.Open;
  qryNextStatus.open;
end;

procedure TFrameOrderItems.mtblOrderItemsBeforePost(DataSet: TDataSet);
begin
  if DataSet['ARTICLE_CODE']=null then
    abort;

  ndOrderItem:= ndOrderItems.NodeByAttributeValue('ORDERITEM', 'ID', DataSet['ORDERITEM_ID']);
  if ndOrderItem = nil then
  begin
    ndOrderItem:= ndOrderItems.NodeNew('ORDERITEM');
    BatchMoveFields2(ndOrderItem, DataSet,
      'ID=ORDERITEM_ID;MAGAZINE_ID="1";ARTICLE_CODE;DIMENSION;'+
      'PRICE_EUR;COST_EUR;NAME_RUS;STATUS_ID', true);
    BatchMoveFields2(ndOrderItem, DataSet,
      'STATUS_SIGN;KIND_RUS;STATE_ID;WEIGHT', false);
  end;
  SetXmlAttr(ndOrderItem, 'ORDER_ID', OrderId);

  if DataSet['WEIGHT'] = null then
  try
    SetXmlAttr(ndOrderItem, 'WEIGHT', DataSet['WEIGHT']);
  except
  end;
end;

procedure TFrameOrderItems.actCancelRequestExecute(Sender: TObject);
begin
  ndOrderItem:= ndOrderItems.NodeByAttributeValue('ORDERITEM','ID', mtblOrderItems['ORDERITEM_ID']);
  if ndOrderItem <> nil then
  begin
    if Pos(',DELETEABLE,', mtblOrderItems['FLAG_SIGN_LIST']) > 0 then
    begin
      mtblOrderItems.Delete;
      trnWrite.ExecSQLImmediate(Format(
        'delete from orderitems where orderitem_id = %u',
        [Integer(GetXmlAttrValue(ndOrderItem, 'ID'))]));
      ndOrderItem.Delete;
    end
    else
    begin
      SetXmlAttr(ndOrderItem, 'NEW.STATUS_SIGN', 'CANCELREQUEST');
      ndOrderItem.ValueAsBool:= True;
      dmOtto.ActionExecute(trnWrite, ndOrderItem);
      dmOtto.ObjectGet(ndOrderItem, mtblOrderItems['ORDERITEM_ID'], trnWrite);
      Read;
    end;
  end;
end;

procedure TFrameOrderItems.actCancelRequestUpdate(Sender: TObject);
var
  OrderFlagList, ItemFlagList: string;
  Cancelable: boolean;
begin
  if not mtblOrderItems.Eof then
  begin
    OrderFlagList:= dmOtto.GetFlagListById(GetXmlAttrValue(ndOrder, 'STATUS_ID'));
    ItemFlagList:= mtblOrderItems.FieldByName('FLAG_SIGN_LIST').AsString;
    Cancelable:= (Pos(',CANCELABLE,', OrderFlagList) > 0)
      and (Pos(',DELETEABLE,', ItemFlagList)+Pos(',CANCELABLE,', ItemFlagList) > 0);
  end
  else
    Cancelable:= false;
  actCancelRequest.Enabled:= Cancelable;
end;

procedure TFrameOrderItems.actReturnRequestExecute(Sender: TObject);
var
  OrderItemId: Variant;
  bm: TBookmark;
begin
  OrderItemId:= mtblOrderItems['ORDERITEM_ID'];
  bm:= mtblOrderItems.GetBookmark;
  try
    Write;
    try
      ndOrderItem:= ndOrderItems.NodeByAttributeValue('ORDERITEM','ID', OrderItemId);
      if ndOrderItem <> nil then
      begin
        SetXmlAttr(ndOrderItem, 'NEW.STATUS_SIGN', 'RETURNING');
        dmOtto.ActionExecute(trnWrite, ndOrderItem);
        dmOtto.ObjectGet(ndOrderItem, OrderItemId, trnWrite);
      end;
    finally
      read;
    end
  finally
    mtblOrderItems.GotoBookmark(bm);
    mtblOrderItems.FreeBookmark(bm);
  end;
end;

procedure TFrameOrderItems.actDiscardUpdate(Sender: TObject);
var
  ndOrderItem: TXmlNode;
begin
  ndOrderItem:= ndOrderItems.NodeByAttributeValue('ORDERITEM', 'ID', mtblOrderItems['OrderItem_Id']);
  if Assigned(ndOrderItem) then
    actDiscard.Enabled:= xmlAttrIn(ndOrderItem, 'STATUS_SIGN', 'DELIVERING,DELIVERED')
  else
    actDiscard.Enabled:= False;
end;

procedure TFrameOrderItems.actDiscardExecute(Sender: TObject);
var
  OrderItemId: Variant;
  bm: TBookmark;
begin
  OrderItemId:= mtblOrderItems['ORDERITEM_ID'];
  bm:= mtblOrderItems.GetBookmark;
  try
    Write;
    try
      ndOrderItem:= ndOrderItems.NodeByAttributeValue('ORDERITEM','ID', OrderItemId);
      if ndOrderItem <> nil then
      begin
        SetXmlAttr(ndOrderItem, 'NEW.STATUS_SIGN', 'DISCARDED');
        dmOtto.ActionExecute(trnWrite, ndOrderItem);
        dmOtto.ObjectGet(ndOrderItem, OrderItemId, trnWrite);
      end;
    finally
      read;
    end
  finally
    mtblOrderItems.GotoBookmark(bm);
    mtblOrderItems.FreeBookmark(bm);
  end;
end;


procedure TFrameOrderItems.actReturnRequestUpdate(Sender: TObject);
begin
  ndOrderItem:= ndOrderItems.NodeByAttributeValue('ORDERITEM', 'ID', mtblOrderItems['OrderItem_Id']);
  if Assigned(ndOrderItem) then
    actReturnRequest.Enabled:= xmlAttrIn(ndOrderItem, 'STATUS_SIGN', 'DELIVERING,DELIVERED')
  else
    actReturnRequest.Enabled:= False;
end;

procedure TFrameOrderItems.actCheckAvailableUpdate(Sender: TObject);
begin
  actCheckAvailable.Enabled:= XmlAttrIn(ndOrder, 'STATUS_SIGN', 'NEW,DRAFT,APPROVED,ACCEPTREQUEST,ACCEPTED');
end;

procedure TFrameOrderItems.grdOrderItemsEnter(Sender: TObject);
begin
  inherited;
  grdOrderItems.Col:= 0;
end;

procedure TFrameOrderItems.actDublicateExecute(Sender: TObject);
begin
  ndOrderItem:= ndOrderItems.NodeNew('ORDERITEM');
  SetXmlAttr(ndOrderItem, 'ID', dmOtto.GetNewObjectId('ORDERITEM'));
  BatchMoveFields2(ndOrderItem, mtblOrderItems,
    'ORDER_ID;MAGAZINE_ID;ARTICLE_CODE;DIMENSION;PRICE_EUR;COST_EUR;NAME_RUS;'+
    'STATUS_SIGN;KIND_RUS;WEIGHT');
  mtblOrderItems.Append;
  BatchMoveFields2(mtblOrderItems, ndOrderItem,
    'ORDERITEM_ID=ID;ORDER_ID;MAGAZINE_ID;ARTICLE_CODE;DIMENSION;PRICE_EUR;COST_EUR;NAME_RUS;'+
    'STATUS_SIGN;KIND_RUS;WEIGHT');
  mtblOrderItems.Post;
  Write;
  Read;
end;

procedure TFrameOrderItems.actApproveExecute(Sender: TObject);
var
  OrderItemId: variant;
begin
  OrderItemId:= mtblOrderItems['ORDERITEM_ID'];
  Write;
  try
    ndOrderItem:= ndOrderItems.NodeByAttributeValue('ORDERITEM','ID', OrderItemId);
    if ndOrderItem <> nil then
    begin
      SetXmlAttr(ndOrderItem, 'NEW.STATUS_SIGN', 'APPROVED');
      dmOtto.ActionExecute(trnWrite, ndOrderItem);
      dmOtto.ObjectGet(ndOrderItem, OrderItemId, trnWrite);
    end;
  finally
    Read;
  end;
end;



procedure TFrameOrderItems.actApproveUpdate(Sender: TObject);
begin
  actApprove.Enabled:= mtblOrderItems['STATUS_SIGN'] = 'NEW';
end;

procedure TFrameOrderItems.grdOrderItemsGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if Column.ReadOnly then
    Background:= GvColor.Lighter(clSilver, 50)
  else
    Background:= clWindow;
end;

procedure TFrameOrderItems.actSetStatusExecute(Sender: TObject);
var
  StatusId: Integer;
  StatusSign: String;
  OrderItemId: variant;
begin
  OrderItemId:= mtblOrderItems['ORDERITEM_ID'];
  Write;
  try
    ndOrderItem:= ndOrderItems.NodeByAttributeValue('ORDERITEM','ID', OrderItemId);
    if ndOrderItem <> nil then
    begin
      StatusId:= TAction(Sender).ActionComponent.Tag;
      StatusSign:= qryStatuses.Lookup('STATUS_ID', StatusId, 'STATUS_SIGN');
      SetXmlAttr(ndOrderItem, 'NEW.STATUS_SIGN', StatusSign);
      dmOtto.ActionExecute(trnWrite, ndOrderItem);
      dmOtto.ObjectGet(ndOrderItem, OrderItemId, trnWrite);
    end;
  finally
    read;
  end
end;

procedure TFrameOrderItems.mtblOrderItemsAfterScroll(DataSet: TDataSet);
var
  btnSetStatus: TTBXItem;
  CompName: string;
  i: Integer;
begin
  for i:= 0 to subSetStatuses.Count - 1 do
    subSetStatuses.Items[i].Visible:= False;
  if qryNextStatus.Active then
  begin
    qryNextStatus.First;
    while not qryNextStatus.Eof do
    begin
      CompName:= Format('btnSetStatus_%s', [qryNextStatus['STATUS_SIGN']]);
      btnSetStatus:= TTBXItem(subSetStatuses.FindComponent(CompName));
      if btnSetStatus = nil then
      begin
        btnSetStatus:= TTBXItem.Create(subSetStatuses);
        btnSetStatus.Action:= actSetStatus;
        btnSetStatus.Name:= CompName;
        btnSetStatus.Tag:= qryNextStatus['STATUS_ID'];
        btnSetStatus.Caption:= qryNextStatus['STATUS_NAME'];
        subSetStatuses.Add(btnSetStatus);
      end
      else
        btnSetStatus.Visible:= True;
      qryNextStatus.Next;
    end;
  end;
end;

procedure TFrameOrderItems.mtblOrderItemsSetFieldValue(
  MemTable: TCustomMemTableEh; Field: TField; var Value: Variant);
begin
  if MemTable.Tag = 1 then Exit;
  if (Field.FieldName = 'PRICE_EUR') and IsNotNull(Value) then
  begin
    MemTable['COST_EUR']:= MemTable['AMOUNT']*Value;
  end
end;

procedure TFrameOrderItems.mtblOrderItemsAfterInsert(DataSet: TDataSet);
begin
  if DataSet.Tag = 1 then Exit;
  DataSet['ORDERITEM_ID']:= dmOtto.GetNewObjectId('ORDERITEM');
  DataSet['STATUS_ID']:= dmOtto.GetDefaultStatusId('ORDERITEM');
  DataSet['FLAG_SIGN_LIST']:= dmOtto.GetFlagListById(DataSet['STATUS_ID']);
  DataSet['AMOUNT']:= 1;
end;

procedure TFrameOrderItems.grdOrderItemsKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  with grdOrderItems do
  begin
    if Columns[Col].FieldName = 'DIMENSION' then
      if not (Key in ['0'..'9', 'A'..'Z']) then Key:= #0;
  end;
end;


end.
