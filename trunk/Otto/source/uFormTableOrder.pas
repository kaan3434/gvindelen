unit uFormTableOrder;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uBaseNSIForm, FIBDatabase, pFIBDatabase,
  ImgList, PngImageList, ActnList, DB, FIBDataSet, pFIBDataSet, GridsEh,
  DBGridEh, StdCtrls, JvExStdCtrls, JvGroupBox, ExtCtrls, JvExExtCtrls,
  JvExtComponent, JvPanel, TB2Item, TBX, TB2Dock, TB2Toolbar, ComCtrls,
  NativeXml, GvNativeXml, EhLibFIB, DBGridEhGrouping, frxClass,
  frxFIBComponents, frxExportPDF;

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
    actAssignPayment: TAction;
    btnAssignPayment: TTBXItem;
    subSetStatuses: TTBXSubmenuItem;
    qryNextStatus: TpFIBDataSet;
    actSetStatus: TAction;
    actDeleteOrder: TAction;
    btnDeleteOrder: TTBXItem;
    actBalanceOrder: TAction;
    btnBalanceOrder: TTBXItem;
    frxPDFExport: TfrxPDFExport;
    frxInvoice: TfrxReport;
    frxFIBComponents1: TfrxFIBComponents;
    tsClientAttrs: TTabSheet;
    grdClientAttrs: TDBGridEh;
    qryClientAttrs: TpFIBDataSet;
    dsClientAttrs: TDataSource;
    tsNote: TTabSheet;
    mmoNote: TMemo;
    procedure actFilterApprovedExecute(Sender: TObject);
    procedure actFilterAcceptRequestExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure grdMainDblClick(Sender: TObject);
    procedure actMakeInvoiceExecute(Sender: TObject);
    procedure actAssignPaymentExecute(Sender: TObject);
    procedure qryMainAfterScroll(DataSet: TDataSet);
    procedure actSetStatusExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actDeleteOrderUpdate(Sender: TObject);
    procedure actDeleteOrderExecute(Sender: TObject);
    procedure actBalanceOrderUpdate(Sender: TObject);
    procedure actBalanceOrderExecute(Sender: TObject);
    procedure grdMainFillSTFilterListValues(Sender: TCustomDBGridEh;
      Column: TColumnEh; Items: TStrings; var Processed: Boolean);
    procedure frxInvoiceAfterPrintReport(Sender: TObject);
    procedure grdMainGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure trnReadAfterStart(Sender: TObject);
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
  udmOtto, uFormWizardOrder, uMain, uDlgPayment, GvStr, GvVariant, GvColor;

{$R *.dfm}

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
  trnRead.StartTransaction;
  tlBarNsiActions.Visible:= dmOtto.isAdminRole;
end;

procedure TFormTableOrders.grdMainDblClick(Sender: TObject);
begin
  TFormWizardOrder.CreateDB(Self, qryMain['order_id']).Show;
end;

procedure TFormTableOrders.actMakeInvoiceExecute(Sender: TObject);
var
  InvoiceFileName: string;
  Xml: TNativeXml;
  ndOrder, ndProduct: TXmlNode;
  OrderId, InvoiceEUR, InvoiceBYR: Variant;

procedure PushInvoiceMoney(ndOrder: TXmlNode; Index: Integer = 0);
begin
  if AttrExists(ndOrder, 'INVOICE_EUR_'+IntTostr(Index+1)) then
    PushInvoiceMoney(ndOrder, Index + 1);
  BatchMoveFields2(ndOrder, ndOrder,
    Format('INVOICE_EUR_%u=INVOICE_EUR_%u;INVOICE_BYR_%u=INVOICE_BYR_%u;',
           [Index+1, Index, Index+1, Index]));
end;

begin
  OrderId:= qryMain['ORDER_ID'];
  Xml:= TNativeXml.CreateName('ORDER');
  ndOrder:= Xml.Root;
  ndProduct:= ndOrder.NodeNew('PRODUCT');
  try
    dmOtto.ObjectGet(ndOrder, OrderId, trnWrite);
    dmOtto.ObjectGet(ndProduct, GetXmlAttrValue(ndOrder, 'PRODUCT_ID'), trnWrite);
    InvoiceFileName:= Format('inv_%s.pdf', [GetXmlAttrValue(ndOrder, 'ORDER_CODE')]);
    ForceDirectories(Path['Invoices']);
    frxPDFExport.FileName:= Path['Invoices']+InvoiceFileName;
    frxInvoice.LoadFromFile(GetXmlAttr(ndProduct, 'PARTNER_NUMBER', Path['FastReport']+'invoice_', '.fr3'));
    frxInvoice.Variables.Variables['OrderId']:= Format('''%u''', [Integer(OrderId)]);
    frxInvoice.PrepareReport(true);
    frxInvoice.Export(frxPDFExport);
    // Переносим сумму извещения на заявку
    InvoiceEUR:= trnWrite.DefaultDatabase.QueryValue(
      'select cost_eur from v_order_summary where order_id = :order_id',
      0, [OrderId], trnWrite);
    InvoiceBYR:= trnWrite.DefaultDatabase.QueryValue(
      'select cost_byr from v_order_summary where order_id = :order_id',
      0, [OrderId], trnWrite);
    SetXmlAttrAsMoney(ndOrder, 'NEW.INVOICE_EUR', InvoiceEUR);
    SetXmlAttrAsMoney(ndOrder, 'NEW.INVOICE_BYR', InvoiceBYR);
    if AttrExists(ndOrder, 'INVOICE_EUR_0') or AttrExists(ndOrder, 'INVOICE_BYR_0') then
    begin
      if (GetXmlAttrAsMoney(ndOrder, 'NEW.INVOICE_EUR') <> GetXmlAttrAsMoney(ndOrder, 'INVOICE_EUR_0')) or
         (GetXmlAttrAsMoney(ndOrder, 'NEW.INVOICE_BYR') <> GetXmlAttrAsMoney(ndOrder, 'INVOICE_BYR_0')) then
        PushInvoiceMoney(ndOrder);
    end;
    BatchMoveFields2(ndOrder, ndOrder,
      'INVOICE_EUR_0=NEW.INVOICE_EUR;INVOICE_BYR_0=NEW.INVOICE_BYR');
    SetXmlAttr(ndOrder, 'NEW.STATE_SIGN', 'INVOICED');
    dmOtto.ActionExecute(trnWrite, ndOrder);
    frxInvoice.ShowPreparedReport;
  finally
    Xml.Free;
  end;
end;

procedure TFormTableOrders.actAssignPaymentExecute(Sender: TObject);
var
  AccountId: Integer;
  Amount_BYR: Double;
  Byr2Eur: Integer;
  Xml: TNativeXml;
  ndOrder, ndClient: TXmlNode;
  DlgManualPayment: TDlgManualPayment;
  Annotate: string;
begin
  DlgManualPayment:= TDlgManualPayment.Create(self);
  Xml:= TNativeXml.CreateName('ORDER');
  ndOrder:= Xml.Root;
  try
    dmOtto.ObjectGet(ndOrder, qryMain['ORDER_ID'], trnRead);
    ndClient:= ndOrder.NodeNew('CLIENT');
    dmOtto.ObjectGet(ndClient, qryMain['CLIENT_ID'], trnRead);

    DlgManualPayment.Caption:= 'Ручное зачисление на заявку';
    DlgManualPayment.lblAmountEur.Caption:= 'Сумма, BYR';
    DlgManualPayment.edtAmountEur.DecimalPlaces:= 0;
    DlgManualPayment.edtAmountEur.DisplayFormat:= '### ### ##0';
    DlgManualPayment.edtByr2Eur.Value:= GetXmlAttrValue(ndOrder, 'BYR2EUR');
    if DlgManualPayment.ShowModal = mrOk then
    begin
      Amount_BYR:= DlgManualPayment.edtAmountEur.Value;
      Byr2Eur:= DlgManualPayment.edtByr2Eur.Value;
      Annotate:= DlgManualPayment.memAnnotate.Lines.Text;
      trnWrite.StartTransaction;
      try
        if GetXmlAttrValue(ndClient, 'ACCOUNT_ID') = null then
        begin
          // Создаем счет
          AccountId:= dmOtto.GetNewObjectId('ACCOUNT');
          dmOtto.ActionExecute(trnWrite, 'ACCOUNT', 'ACCOUNT_CREATE', '', AccountId);
          SetXmlAttr(ndClient, 'ACCOUNT_ID', AccountId);
          dmOtto.ActionExecute(trnWrite, ndClient);
          SetXmlAttr(ndOrder, 'ACCOUNT_ID', AccountId);
          dmOtto.ActionExecute(trnWrite, ndOrder);
        end;
        dmOtto.ActionExecute(trnWrite, 'ACCOUNT', 'ACCOUNT_PAYMENTIN',
          XmlAttrs2Vars(ndOrder, 'ORDER_ID=ID;ID=ACCOUNT_ID',
          Value2Vars(Amount_BYR, 'AMOUNT_BYR',
          Value2Vars(Annotate, 'ANNOTATE'))));
        trnWrite.Commit;
      except
        on E:Exception do
          begin
            trnWrite.Rollback;
            ShowMessage(E.Message);
          end
      end;
    end;
    trnRead.Commit;
    trnRead.StartTransaction;
  finally
    Xml.Free;
    DlgManualPayment.Free;
  end;
end;

procedure TFormTableOrders.qryMainAfterScroll(DataSet: TDataSet);
var
  btnSetStatus: TTBXItem;
  CompName: string;
  i: Integer;
begin
  if DataSet.ControlsDisabled then Exit;
  mmoNote.Text:= qryMain.FieldByName('Note').AsString;
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

procedure TFormTableOrders.actSetStatusExecute(Sender: TObject);
var
  StatusId: Integer;
  StatusSign: String;
  OrderId: variant;
  bm: TBookmark;
begin
  OrderId:= qryMain['ORDER_ID'];
  qryMain.DisableControls;

  try
    if not trnWrite.Active then trnWrite.StartTransaction;
    try
      trnWrite.SetSavePoint('SetStatus');
      StatusId:= TAction(Sender).ActionComponent.Tag;
      StatusSign:= qryStatuses.Lookup('STATUS_ID', StatusId, 'STATUS_SIGN');
      dmOtto.ActionExecute(trnWrite, 'ORDER', '', Value2Vars(StatusSign, 'NEW.STATUS_SIGN'), OrderId);
    except
      trnWrite.RollBackToSavePoint('SetStatus');
    end;
  finally
    qryMain.Close;
    qryMain.Open;
    qryMain.EnableControls;
  end;
end;

procedure TFormTableOrders.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  if trnWrite.Active then trnWrite.Commit;
end;

procedure TFormTableOrders.actDeleteOrderUpdate(Sender: TObject);
var
  FlagList: variant;
begin
  FlagList:= qryStatuses.Lookup('STATUS_ID', qryMain['STATUS_ID'], 'FLAG_SIGN_LIST');
  actDeleteOrder.Enabled:= IsWordPresent('DELETEABLE', nvl(FlagList,''), ',');
end;

procedure TFormTableOrders.actDeleteOrderExecute(Sender: TObject);
var
  OrderCode: variant;
  bm: TBookmark;
begin
  if MessageDlg('Удалить заявку?', mtConfirmation, [mbOK,mbCancel], 0) = mrOk then
  begin
    trnWrite.StartTransaction;
    try
      bm:= qryMain.GetBookmark;
      qryMain.DisableControls;
      try
        OrderCode:= trnWrite.DefaultDatabase.QueryValueAsStr(
          'delete from orders where order_id = :order_id returning order_code',
          0, [qryMain['Order_Id']]);
        trnWrite.Commit;
        ShowMessage(Format('Заявка %s удалена', [OrderCode]));
      finally
        qryMain.GotoBookmark(bm);
        qryMain.FreeBookmark(bm);
        qryMain.EnableControls;
      end;
    except
      trnWrite.RollBack;
      ShowMessage('Ошибка при удалении заявки');
    end;
  end;

end;

procedure TFormTableOrders.actBalanceOrderUpdate(Sender: TObject);
var
  FlagList: variant;
begin
  FlagList:= qryStatuses.Lookup('STATUS_ID', qryMain['STATUS_ID'], 'FLAG_SIGN_LIST');
  actBalanceOrder.Enabled:= IsWordPresent('BALANCEABLE', nvl(FlagList,''), ',') and (qryMain['COST_EUR']<>0);
end;

procedure TFormTableOrders.actBalanceOrderExecute(Sender: TObject);
var
  AccountId, AmountEur: Variant;
  bm: TBookmark;
begin
  qryMain.DisableControls;
  bm:= qryMain.GetBookmark;
  if not trnWrite.Active then
    trnWrite.StartTransaction;
  try
    trnWrite.SetSavePoint('BeforeBalanceOrder');
    try
      dmOtto.ActionExecute(trnWrite, 'ACCOUNT', 'ACCOUNT_DEBITORDER',
        DataSet2Vars(qryMain, 'AMOUNT_EUR=COST_EUR;ORDER_ID'), qryMain['ACCOUNT_ID']);
      ShowMessage('Заявка сбалансирована');
    except
      on E: Exception do
      begin
        trnWrite.RollBackToSavePoint('BeforeBalanceOrder');
        ShowMessage(e.Message);
      end;
    end;
  finally
    qryMain.GotoBookmark(bm);
    qryMain.FreeBookmark(bm);
    qryMain.EnableControls;
  end;
end;

procedure TFormTableOrders.grdMainFillSTFilterListValues(
  Sender: TCustomDBGridEh; Column: TColumnEh; Items: TStrings;
  var Processed: Boolean);
var
  SQL: string;
begin
  inherited;
  if Column.FieldName = 'STATUS_NAME' then
    SQL:= 'select s.status_name '+
          ' from statuses s '+
          ' where s.object_sign = ''ORDER'' '+
          ' and coalesce(s.isstate, 0) = 0'
  else
  if Column.FieldName = 'USER_SIGN' then
    SQL:= 'select distinct o.user_sign from orders o where o.user_sign is not null'
  else
    SQL:= '';
  if SQL<>'' then
    dmOtto.FillComboStrings(Items, nil, SQL, trnRead);
end;

procedure TFormTableOrders.frxInvoiceAfterPrintReport(Sender: TObject);
var
  Xml: TNativeXml;
  ndOrder: TXmlNode;
  OrderId: Variant;
begin
  Xml:= TNativeXml.CreateName('ORDER');
  ndOrder:= Xml.Root;
  try
    OrderId:= ReplaceAll(frxInvoice.Variables.Variables['OrderId'], '''', '');
    dmOtto.ObjectGet(ndOrder, OrderId, trnWrite);
    SetXmlAttr(ndOrder, 'NEW.STATE_SIGN', 'INVOICEPRINTED');
    dmOtto.ActionExecute(trnWrite, ndOrder);
  except
    xml.Free
  end;
end;

procedure TFormTableOrders.grdMainGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
var
  StatusSign: string;
begin
  inherited;
  if State = [] then
  begin
    StatusSign:= grdMain.DataSource.DataSet['STATUS_SIGN'];
    if IsWordPresent(StatusSign, 'ANULLED,CANCELLED', ',') then
      AFont.Color:= clGray;
  end;
end;

procedure TFormTableOrders.trnReadAfterStart(Sender: TObject);
begin
  inherited;
  qryMain.DisableControls;
  try
    qryMain.Open;
    qryOrderAttrs.Open;
    qryOrderItems.Open;
    qryOrderTaxs.Open;
    qryStatuses.Open;
    qryAccountMovements.Open;
    qryHistory.Open;
    qryNextStatus.Open;
    qryClientAttrs.Open;
  finally
    qryMain.EnableControls;
  end;
end;

end.
