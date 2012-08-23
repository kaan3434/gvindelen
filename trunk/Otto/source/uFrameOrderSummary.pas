unit uFrameOrderSummary;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrameBase1, ImgList, PngImageList, ActnList, FIBDatabase,
  pFIBDatabase, ExtCtrls, JvExExtCtrls, JvExtComponent, JvPanel,
  TBXStatusBars, TB2Dock, TB2Toolbar, TBX, GridsEh,
  DBGridEh, StdCtrls, JvExStdCtrls, JvCheckBox, JvGroupBox, DB, FIBDataSet,
  pFIBDataSet, NativeXml, TB2Item, DBGridEhGrouping, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase,
  IdMessageClient, IdSMTPBase, IdSMTP;

type
  TFrameOrderSummary = class(TFrameBase1)
    pnlTopOnFinal: TJvPanel;
    pnlClientOnFinal: TJvPanel;
    grBoxClientOfFinal: TJvGroupBox;
    lblClientFIO: TLabel;
    lbl5: TLabel;
    lblPhonesOnFinal: TLabel;
    lbl6: TLabel;
    lbl7: TLabel;
    lbl8: TLabel;
    txtClientFioOnFinal: TStaticText;
    txtAdressOnFinal: TStaticText;
    txtClientPhoneOnFinal: TStaticText;
    txtClientGsmOnFinal: TStaticText;
    txtClientEmailOnFinal: TStaticText;
    txtAccountRest: TStaticText;
    pnlOrderOnFinal: TJvPanel;
    grBoxSummaryOrder: TJvGroupBox;
    lblOrderCode: TLabel;
    chkUseRest: TJvCheckBox;
    txtOrderCode: TStaticText;
    grBoxSummaryOrderItems: TJvGroupBox;
    grdOrderFullSpecification: TDBGridEh;
    qryOrderFullSpecification: TpFIBDataSet;
    dsOrderFullSpecifications: TDataSource;
    actSetStateDraft: TAction;
    actSetStateApproved: TAction;
    btn1: TTBXItem;
    btn2: TTBXItem;
    actStore: TAction;
    btn3: TTBXItem;
    mmoNote: TMemo;
    smtpOrderCode: TIdSMTP;
    procedure actSetStateDraftExecute(Sender: TObject);
    procedure actSetStateApprovedExecute(Sender: TObject);
    procedure actStoreExecute(Sender: TObject);
    procedure actStoreUpdate(Sender: TObject);
  private
    function GetOrderId: Integer;
    function FullAdress: String;
    { Private declarations }
  public
    { Public declarations }
    ndOrder: TXmlNode;
    ndClient: TXmlNode;
    ndAdress: TXmlNode;
    ndPlace: TXmlNode;
    ndAccount: TXmlNode;
    procedure InitData; override;
    procedure FreeData; override;
    procedure OpenTables; override;
    procedure Read; override;
    property OrderId: Integer read GetOrderId;
  end;

var
  FrameOrderSummary: TFrameOrderSummary;

implementation

uses
  udmOtto, GvNativeXml, GvStr;

{$R *.dfm}

{ TFrameOrderSummary }

procedure TFrameOrderSummary.FreeData;
begin
  inherited;

end;

procedure TFrameOrderSummary.InitData;
begin
  inherited;
end;

function TFrameOrderSummary.FullAdress: String;
begin
  result:= GetXmlAttr(ndAdress, 'POSTINDEX', '', '. ') +
    GetXmlAttr(ndPlace, 'PLACE_NAME', ' '+ndPlace.ReadAttributeString('PLACETYPE_SIGN', 'г')+'. ') +
    GetXmlAttr(ndPlace, 'AREA_NAME', ' ', ' р-н. ') +
    GetXmlAttr(ndPlace, 'REGION_NAME', ' ', ' обл.') +
    GetXmlAttr(ndAdress, 'STREET_NAME', ndAdress.ReadAttributeString('STREETTYPE_SIGN', ', ул.')+' ')+
    GetXmlAttr(ndAdress, 'HOUSE', ', ')+
    GetXmlAttr(ndAdress, 'BUILDING', ', корп. ')+
    GetXmlAttr(ndAdress, 'FLAT', ', кв. ');
  result:= ReplaceAll(Result, '  ', ' ');
end;

procedure TFrameOrderSummary.Read;
var
  RestEur: Variant;
begin
  txtClientFioOnFinal.Caption:= GetXmlAttr(ndClient, 'LAST_NAME')+
    GetXmlAttr(ndClient, 'FIRST_NAME', ' ')+
    GetXmlAttr(ndClient, 'MID_NAME', ' ');

  txtClientPhoneOnFinal.Caption:= GetXmlAttr(ndClient, 'STATIC_PHONE');
  txtClientGsmOnFinal.Caption:= GetXmlAttr(ndClient, 'MOBILE_PHONE');
  txtClientEmailOnFinal.Caption:= GetXmlAttr(ndClient, 'EMAIL');
  txtAdressOnFinal.Caption:= FullAdress;
  RestEur:= GetXmlAttrAsMoney(ndAccount, 'REST_EUR');
  chkUseRest.Enabled:= RestEur <> 0;
  chkUseRest.Checked:= RestEur < 0;
  txtAccountRest.Caption:= GetXmlAttr(ndAccount, 'REST_EUR', '', ' EUR');
  txtOrderCode.Caption:= GetXmlAttr(ndOrder, 'ORDER_CODE');
  qryOrderFullSpecification.OpenWP([OrderId]);
end;

procedure TFrameOrderSummary.actSetStateDraftExecute(Sender: TObject);
const
  StatusSignNew = 'DRAFT';
begin
  trnWrite.SetSavePoint('OnSetStatus'+StatusSignNew);
  try
    SetXmlAttr(ndOrder, 'NOTE', mmoNote.Text);
    SetXmlAttr(ndOrder, 'NEW.STATUS_SIGN', StatusSignNew);
    dmOtto.ActionExecute(trnWrite, ndOrder);
    trnWrite.Commit;
    trnRead.Commit;
    TForm(Owner).Close;
    ShowMessage('Заявка сохранена как черновик');
  except
    ShowMessageFmt('Невозможно установить статус %s', [StatusSignNew]);
    SetXmlAttr(ndOrder, 'NEW.STATUS_SIGN', null);
    trnWrite.RollBackToSavePoint('OnSetStatus'+StatusSignNew);
  end;
end;

function TFrameOrderSummary.GetOrderId: Integer;
begin
  Result:= ndOrder.ReadAttributeInteger('ID', 0)
end;

procedure TFrameOrderSummary.actSetStateApprovedExecute(Sender: TObject);
const
  StatusSignNew = 'APPROVED';
var
  OrderCode: string;
  ndOrderMoney: TXmlNode;
  PatternMessage: String;
begin
  SetXmlAttr(ndOrder, 'NOTE', mmoNote.Text);
  if GetXmlAttrValue(ndOrder, 'ADRESS_ID') = null then
  begin
    ShowMessage('Не указан адрес клиента');
    Exit;
  end;
  SetXmlAttr(ndOrder, 'BYR2EUR', dmOtto.SettingGet(trnRead, 'BYR2EUR'));
  if not AttrExists(ndOrder, 'ORDER_CODE') then
  begin
    OrderCode:= dmOtto.GetNextCounterValue('PRODUCT', 'ORDER_CODE', GetXmlAttrValue(ndOrder, 'PRODUCT_ID'));
    SetXmlAttr(ndOrder, 'ORDER_CODE', OrderCode);
  end;
  Caption:= txtOrderCode.Caption;

  if chkUseRest.Checked then
  begin
    ndOrderMoney:= ndOrder.NodeNew('ORDERMONEY');
    SetXmlAttr(ndOrderMoney, 'ID', dmOtto.GetNewObjectId('ORDERMONEY'));
    BatchMoveFields2(ndOrderMoney, ndOrder,
      'ORDER_ID=ID');
    BatchMoveFields2(ndOrderMoney, ndAccount,
      'ACCOUNT_ID=ID;AMOUNT_EUR=REST_EUR');
    if GetXmlAttrValue(ndAccount, 'REST_EUR', 0) <> 0 then
      dmOtto.ActionExecute(trnWrite, 'ACCOUNT', 'ACCOUNT_CREDITORDER',
        XmlAttrs2Vars(ndAccount, 'ID;AMOUNT_EUR=REST_EUR',
        XmlAttrs2Vars(ndOrder, 'ORDER_ID=ID;ORDER_CODE')))
  end;
  trnWrite.SetSavePoint('OnSetStatus'+StatusSignNew);
  try
    SetXmlAttr(ndOrder, 'NEW.STATUS_SIGN', StatusSignNew);
    dmOtto.ActionExecute(trnWrite, ndOrder);
//    if GetXmlAttrValue(ndOrder, 'SOURCE') = 'Internet' then
//    begin
//      PatternMessage:= dmOtto.SettingGet(trnRead, 'ORDER_CODE_EMAIL_TEMPLATE');
//      PatternMessage:= FillPattern(PatternMessage, ndOrder);
//    end;
    trnWrite.Commit;
    trnRead.Commit;
    TForm(Owner).Close;
    ShowMessage(GetXmlAttr(ndOrder, 'ORDER_CODE', 'Заявка ', ' сохранена и переведена в статус "Оформлена"'));
  except
    ShowMessageFmt('Невозможно установить статус %s', [StatusSignNew]);
    SetXmlAttr(ndOrder, 'NEW.STATUS_SIGN', null);
    trnWrite.RollBackToSavePoint('OnSetStatus'+StatusSignNew);
  end;
//  dmOtto.SendEmail(GetXmlAttr(ndClient, 'EMAIL'), 'Номер присвоенной заявки', PatternMessage);
end;

procedure TFrameOrderSummary.OpenTables;
begin
  inherited;
  qryOrderFullSpecification.Close;
  if trnWrite.Active then
    qryOrderFullSpecification.Transaction:= trnWrite
  else
    qryOrderFullSpecification.Transaction:= trnRead;
  qryOrderFullSpecification.OpenWP([OrderId]);
end;

procedure TFrameOrderSummary.actStoreExecute(Sender: TObject);
begin
  try
    trnWrite.Commit;
    trnRead.Commit;
    TForm(Owner).Close;
    ShowMessage(GetXmlAttr(ndOrder, 'ORDER_CODE', 'Заявка ', ' сохранена'));
  except
    trnWrite.RollBack;
  end;
end;

procedure TFrameOrderSummary.actStoreUpdate(Sender: TObject);
begin
  actStore.Enabled:= dmOtto.FlagExists(ndOrder, 'EDITABLE');
end;

end.
