unit uFrameOrderSummary;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrameBase1, ImgList, PngImageList, ActnList, FIBDatabase,
  pFIBDatabase, ExtCtrls, JvExExtCtrls, JvExtComponent, JvPanel,
  TBXStatusBars, TB2Dock, TB2Toolbar, TBX, GridsEh,
  DBGridEh, StdCtrls, JvExStdCtrls, JvCheckBox, JvGroupBox, DB, FIBDataSet,
  pFIBDataSet, GvXml, TB2Item, DBGridEhGrouping, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase,
  IdMessageClient, IdSMTPBase, IdSMTP, ToolCtrlsEh, DBGridEhToolCtrls,
  DBAxisGridsEh;

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
    lblBonus: TLabel;
    txtBonusName: TStaticText;
    procedure actSetStateDraftExecute(Sender: TObject);
    procedure actSetStateApprovedExecute(Sender: TObject);
    procedure actStoreExecute(Sender: TObject);
    procedure actStoreUpdate(Sender: TObject);
  private
    function GetOrderId: Integer;
//    function FullAdress: String;
    { Private declarations }
  public
    { Public declarations }
    ndOrder: TGvXmlNode;
    ndClient: TGvXmlNode;
    ndAdress: TGvXmlNode;
    ndPlace: TGvXmlNode;
    ndAccount: TGvXmlNode;
    ndBonus: TGvXmlNode;
    ndProduct: TGvXmlNode;
    property OrderId: Integer read GetOrderId;
  end;

var
  FrameOrderSummary: TFrameOrderSummary;

implementation

uses
  udmOtto, GvXmlUtils, GvStr;

{$R *.dfm}

{ TFrameOrderSummary }

{function TFrameOrderSummary.FullAdress: String;
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
}

{procedure TFrameOrderSummary.Read;
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
  chkUseRest.Visible:= GetXmlAttrValue(ndProduct, 'PRODUCT_CODE') = 1;
  chkUseRest.Enabled:= RestEur <> 0;
  chkUseRest.Checked:= RestEur < 0;
  txtAccountRest.Caption:= GetXmlAttr(ndAccount, 'REST_EUR', '', ' EUR');
  txtOrderCode.Caption:= GetXmlAttr(ndOrder, 'ORDER_CODE');
  qryOrderFullSpecification.OpenWP([OrderId]);
end;
}
procedure TFrameOrderSummary.actSetStateDraftExecute(Sender: TObject);
const
  StatusSignNew = 'DRAFT';
begin
  trnWrite.SetSavePoint('OnSetStatus'+StatusSignNew);
  try
    ndOrder['NOTE']:= mmoNote.Text;
    ndOrder['NEW.STATUS_SIGN']:= StatusSignNew;
    dmOtto.ActionExecute(trnWrite, ndOrder);
    trnWrite.Commit;
    trnRead.Commit;
    TForm(Owner).Close;
    ShowMessage('Заявка сохранена как черновик');
  except
    ShowMessageFmt('Невозможно установить статус %s', [StatusSignNew]);
    ndOrder['NEW.STATUS_SIGN']:= null;
    trnWrite.RollBackToSavePoint('OnSetStatus'+StatusSignNew);
  end;
end;

function TFrameOrderSummary.GetOrderId: Integer;
begin
  Result:= ndOrder.Attr['ID'].AsIntegerDef(0);
end;

procedure TFrameOrderSummary.actSetStateApprovedExecute(Sender: TObject);
const
  StatusSignNew = 'APPROVED';
var
  OrderCode: string;
  ndOrderMoney: TGvXmlNode;
  PatternMessage: String;
begin
  ndOrder['NOTE']:= mmoNote.Text;
  if not ndOrder.HasAttribute('ADRESS_ID')then
  begin
    ShowMessage('Не указан адрес клиента');
    Exit;
  end;
  ndOrder.Attr['BYR2EUR'].AsMoney:= dmOtto.SettingGet(trnRead, 'BYR2EUR');
  if not ndOrder.HasAttribute('ORDER_CODE') then
    ndOrder['ORDER_CODE']:= dmOtto.GetNextCounterValue('PRODUCT', 'ORDER_CODE', ndOrder['PRODUCT_ID']);
  Caption:= txtOrderCode.Caption;

  if chkUseRest.Checked then
  begin
    ndOrderMoney:= ndOrder.AddChild('ORDERMONEY');
    ndOrderMoney['ID']:= dmOtto.GetNewObjectId('ORDERMONEY');
    BatchMoveFields(ndOrderMoney, ndOrder,
      'ORDER_ID=ID');
    BatchMoveFields(ndOrderMoney, ndAccount,
      'ACCOUNT_ID=ID;AMOUNT_EUR=REST_EUR');
    if ndAccount.Attr['REST_EUR'].AsMoneyDef(0) <> 0 then
      dmOtto.ActionExecute(trnWrite, 'ACCOUNT', 'ACCOUNT_CREDITORDER',
        XmlAttrs2Attr(ndAccount, 'ID;AMOUNT_EUR=REST_EUR',
        XmlAttrs2Attr(ndOrder, 'ORDER_ID=ID;ORDER_CODE',
        Value2Attr('Перенос остатка на заявку при оформлении', 'NOTES'))))
  end;
  trnWrite.SetSavePoint('OnSetStatus'+StatusSignNew);
  try
    ndOrder['NEW.STATUS_SIGN']:= StatusSignNew;
    dmOtto.ActionExecute(trnWrite, ndOrder);
//    if GetXmlAttrValue(ndOrder, 'SOURCE') = 'Internet' then
//    begin
//      PatternMessage:= dmOtto.SettingGet(trnRead, 'ORDER_CODE_EMAIL_TEMPLATE');
//      PatternMessage:= FillPattern(PatternMessage, ndOrder);
//    end;
    trnWrite.Commit;
    trnRead.Commit;
    TForm(Owner).Close;
    ShowMessage('Заявка '+ndOrder['ORDER_CODE']+' сохранена и переведена в статус "Оформлена"');
  except
    ShowMessageFmt('Невозможно установить статус %s', [StatusSignNew]);
    ndOrder['NEW.STATUS_SIGN']:= null;
    trnWrite.RollBackToSavePoint('OnSetStatus'+StatusSignNew);
  end;
//  dmOtto.SendEmail(GetXmlAttr(ndClient, 'EMAIL'), 'Номер присвоенной заявки', PatternMessage);
end;

procedure TFrameOrderSummary.actStoreExecute(Sender: TObject);
begin
  try
    trnWrite.Commit;
    trnRead.Commit;
    TForm(Owner).Close;
    ShowMessage('Заявка '+ndOrder['ORDER_CODE']+' сохранена');
  except
    trnWrite.RollBack;
  end;
end;

procedure TFrameOrderSummary.actStoreUpdate(Sender: TObject);
begin
  actStore.Enabled:= dmOtto.FlagExists(ndOrder, 'EDITABLE');
end;

end.
