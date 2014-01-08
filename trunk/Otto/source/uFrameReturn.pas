unit uFrameReturn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrameBase1, StdCtrls, ExtCtrls, ImgList, PngImageList,
  ActnList, FIBDatabase, pFIBDatabase, TBXStatusBars, TB2Dock, TB2Toolbar,
  TBX, JvExStdCtrls, JvGroupBox, Mask, JvExMask, JvMaskEdit,
  DBCtrlsEh, GvXml, TB2Item, JvValidators, JvErrorIndicator,
  JvComponentBase;

type
  TFrameMoneyBack = class(TFrameBase1)
    grpBankMovement: TJvGroupBox;
    edBankAccount: TLabeledEdit;
    grpCommon: TJvGroupBox;
    edBelPostBarCode: TLabeledEdit;
    edClientAccount: TLabeledEdit;
    edBankName: TLabeledEdit;
    edBankUNP: TLabeledEdit;
    edBankMFO: TLabeledEdit;
    edPersonalNum: TLabeledEdit;
    edPassportNum: TLabeledEdit;
    edtPassportIssued: TDBDateTimeEditEh;
    lblPasportIssued: TLabel;
    edPassportIssuer: TLabeledEdit;
    rgMoneyBackKind: TRadioGroup;
    chkPayByFirm: TCheckBox;
    btnMakeReturn: TTBXItem;
    actCreateReturn: TAction;
    rgArtReturnKind: TRadioGroup;
    procedure rgMoneyBackKindClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure actCreateReturnExecute(Sender: TObject);
    procedure rgArtReturnKindClick(Sender: TObject);
  private
    function GetOrderId: Integer;
    function Valid: Boolean;
    { Private declarations }
  public
    ndOrder: TGvXmlNode;
    ndClient: TGvXmlNode;
    ndOrderMoneys: TGvXmlNode;
//    ndMoneyBack: TGvXmlNode;
    property OrderId: Integer read GetOrderId;
  end;


implementation

{$R *.dfm}
uses
  GvXmlUtils, udmOtto, GvStr;

function TFrameMoneyBack.GetOrderId: Integer;
begin
  Result:= ndOrder.Attr['ID'].AsIntegerDef(0);
end;

{procedure TFrameMoneyBack.Read;
var
  ReturnKind: string;
begin
  edBelPostBarCode.Text:= GetXmlAttr(ndOrder, 'BELPOST_BAR_CODE');
  rgMoneyBackKind.ItemIndex:= WordNo(GetXmlAttr(ndOrder, 'MONEYBACK_KIND'), 'LEAVE;BELPOST;BANK', ';');

  edPassportNum.Text:= GetXmlAttr(ndClient, 'PASSPORT_NUM');
  edtPassportIssued.Value:= GetXmlAttrValue(ndClient, 'PASSPORT_ISSUED');
  edPassportIssuer.Text:= GetXmlAttr(ndClient, 'PASSPORT_ISSUER');

  edBankAccount.Text:= GetXmlAttr(ndClient, 'BANK_ACCOUNT_NUM');
  edClientAccount.Text:= GetXmlAttr(ndClient, 'BANK_CLIENT_ACCOUNT');
  edBankName.Text:= GetXmlAttr(ndClient, 'BANK_NAME');
  edBankMFO.Text:= GetXmlAttr(ndClient, 'BANK_MFO');
  edBankUNP.Text:= GetXmlAttr(ndClient, 'BANK_UNP');
  edPersonalNum.Text:= GetXmlAttr(ndClient, 'PERSONAL_NUM');
end;
}
procedure TFrameMoneyBack.rgMoneyBackKindClick(Sender: TObject);
begin
  grpBankMovement.Enabled:= rgMoneyBackKind.ItemIndex = 2;
end;

{procedure TFrameMoneyBack.Write;
var
  ReturnKind: string;
begin
  trnWrite.SetSavePoint('OnMoneyBack');
  try
    SetXmlAttr(ndOrder, 'MONEYBACK_KIND', ExtractWord(rgMoneyBackKind.ItemIndex+1, 'LEAVE;BELPOST;BANK', ';'));
    SetXmlAttr(ndOrder, 'BELPOST_BAR_CODE', edBelPostBarCode.Text);

    SetXmlAttr(ndClient, 'PASSPORT_NUM', edPassportNum.Text);
    SetXmlAttr(ndClient, 'PASSPORT_ISSUED', edtPassportIssued.Value);
    SetXmlAttr(ndClient, 'PASSPORT_ISSUER', edPassportIssuer.Text);

    SetXmlAttr(ndClient, 'BANK_ACCOUNT_NUM', edBankAccount.Text);
    SetXmlAttr(ndClient, 'BANK_CLIENT_ACCOUNT', edClientAccount.Text);
    SetXmlAttr(ndClient, 'BANK_NAME', edBankName.Text);
    SetXmlAttr(ndClient, 'BANK_MFO', edBankMFO.Text);
    SetXmlAttr(ndClient, 'BANK_UNP', edBankUNP.Text);
    SetXmlAttr(ndClient, 'PERSONAL_NUM', edPersonalNum.Text);

    dmOtto.ActionExecute(trnWrite, ndOrder);
    dmOtto.ObjectGet(ndOrder, OrderId, trnWrite);

    dmOtto.ActionExecute(trnWrite, ndClient);
    dmOtto.ObjectGet(ndClient, GetXmlAttrValue(ndOrder, 'CLIENT_ID'), trnWrite);
  except
    trnWrite.RollBackToSavePoint('OnMoneyBack');
    raise;
  end;
end;
}
procedure TFrameMoneyBack.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key=vk_Return then
    Key:= 0;
end;

function TFrameMoneyBack.Valid: Boolean;
var
  Msgs: TStringList;
begin
  Msgs:= TStringList.Create;
  try
    if rgArtReturnKind.ItemIndex = -1 then
      Msgs.Add('Не узазан Вид возврата');
    if Length(edPassportNum.Text) <> 9 then
      Msgs.Add('Неправильно введен номер паспорта');
    if edtPassportIssued.Value = null then
      Msgs.Add('Отсутсвует дата выдачи паспорта');
    if edPassportIssuer.Text = '' then
      Msgs.Add('Отсутсвует орган, выдавший паспорт');
    if (rgArtReturnKind.ItemIndex in [1..2]) and (edBelPostBarCode.Text = '') then
      Msgs.Add('Отсутсвует номер почтового отправления');
    if rgMoneyBackKind.ItemIndex = -1 then
      Msgs.Add('Не указано действие с остатком');
    if rgMoneyBackKind.ItemIndex = 2 then
    begin
      if Length(edBankAccount.Text) <> 13 then
        Msgs.Add('Не верно указан номер счета в банке');
      if edClientAccount.Text = '' then
        Msgs.Add('Не указан счет клиента');
      if edBankName.Text = '' then
        Msgs.Add('Не указано наименование банка');
      if edBankMFO.Text = '' then
        Msgs.Add('Не указано МФО банка');
      if edBankUNP.Text = '' then
        Msgs.Add('Не указано УНП банка');
      if Length(edPersonalNum.Text) <> 14 then
        Msgs.Add('Не указан личный номер клиента');
    end;
    Result:= Msgs.Count = 0;
    if Msgs.Count> 0 then
      ShowMessage(Msgs.Text);
  finally
    Msgs.Free;
  end;
end;

procedure TFrameMoneyBack.actCreateReturnExecute(Sender: TObject);
var
  MoneyEur: Double;
begin
  inherited;
  Write;
  if Valid then
  try
    dmOtto.ActionExecute(trnWrite, 'ORDER', 'ORDER_RETURN',
      XmlAttrs2Attr(ndOrder, 'MONEYBACK_KIND;BONUS_EUR',
      Value2Attr(Byte(chkPayByFirm.Checked), 'PAYBYFIRM')),
        OrderId);
    dmOtto.ObjectGet(ndOrder, OrderId, trnWrite);

    trnWrite.Commit;
    ShowMessage('Возврат оформлен');
    TForm(Owner).Close;
  except
    trnWrite.Rollback;
  end;
end;

procedure TFrameMoneyBack.rgArtReturnKindClick(Sender: TObject);
begin
  edBelPostBarCode.Enabled:= rgArtReturnKind.ItemIndex in [1..2];
end;

end.
