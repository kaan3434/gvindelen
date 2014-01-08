unit uFrameMoneyBack3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrameBase1, ExtCtrls, Mask, DBCtrlsEh, StdCtrls, JvExStdCtrls,
  JvGroupBox, ImgList, PngImageList, ActnList, FIBDatabase, pFIBDatabase,
  TBXStatusBars, TB2Dock, TB2Toolbar, TBX, TB2Item, GvXml;

type
  TFrameMoneyBack3 = class(TFrameBase1)
    grpCommon: TJvGroupBox;
    lblPasportIssued: TLabel;
    edPassportNum: TLabeledEdit;
    edtPassportIssued: TDBDateTimeEditEh;
    edPassportIssuer: TLabeledEdit;
    rgMoneyBackKind: TRadioGroup;
    grpBankMovement: TJvGroupBox;
    edBankAccount: TLabeledEdit;
    edClientAccount: TLabeledEdit;
    edBankName: TLabeledEdit;
    edBankUNP: TLabeledEdit;
    edBankMFO: TLabeledEdit;
    edPersonalNum: TLabeledEdit;
    btnMoneyBack: TTBXItem;
    actMoneyBack: TAction;
    chkPayByFirm: TCheckBox;
    procedure actMoneyBackExecute(Sender: TObject);
    procedure rgMoneyBackKindClick(Sender: TObject);
  private
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    { Private declarations }
  public
    { Public declarations }
    ndClient: TGvXmlNode;
    function Valid: Boolean;
  end;


implementation

uses
  udmOtto, GvStr, GvXmlUtils;

{$R *.dfm}

{procedure TFrameMoneyBack3.Read;
var
  ReturnKind: string;
begin
  edPassportNum.Text:= GetXmlAttr(ndClient, 'PASSPORT_NUM');
  edtPassportIssued.Value:= GetXmlAttrValue(ndClient, 'PASSPORT_ISSUED');
  edPassportIssuer.Text:= GetXmlAttr(ndClient, 'PASSPORT_ISSUER');

  edBankAccount.Text:= GetXmlAttr(ndClient, 'BANK_ACCOUNT_NUM');
  edClientAccount.Text:= GetXmlAttr(ndClient, 'BANK_CLIENT_ACCOUNT');
  edBankName.Text:= GetXmlAttr(ndClient, 'BANK_NAME');
  edBankMFO.Text:= GetXmlAttr(ndClient, 'BANK_MFO');
  edBankUNP.Text:= GetXmlAttr(ndClient, 'BANK_UNP');
  edPersonalNum.Text:= GetXmlAttr(ndClient, 'PERSONAL_NUM');
end;}


{procedure TFrameMoneyBack3.Write;
var
  ReturnKind: string;
begin
  trnWrite.SetSavePoint('OnMoneyBack');
  try
    SetXmlAttr(ndClient, 'PASSPORT_NUM', edPassportNum.Text);
    SetXmlAttr(ndClient, 'PASSPORT_ISSUED', edtPassportIssued.Value);
    SetXmlAttr(ndClient, 'PASSPORT_ISSUER', edPassportIssuer.Text);

    SetXmlAttr(ndClient, 'BANK_ACCOUNT_NUM', edBankAccount.Text);
    SetXmlAttr(ndClient, 'BANK_CLIENT_ACCOUNT', edClientAccount.Text);
    SetXmlAttr(ndClient, 'BANK_NAME', edBankName.Text);
    SetXmlAttr(ndClient, 'BANK_MFO', edBankMFO.Text);
    SetXmlAttr(ndClient, 'BANK_UNP', edBankUNP.Text);
    SetXmlAttr(ndClient, 'PERSONAL_NUM', edPersonalNum.Text);

    dmOtto.ActionExecute(trnWrite, ndClient);
    dmOtto.ObjectGet(ndClient, GetXmlAttrValue(ndClient, 'ID'), trnWrite);

  except
    trnWrite.RollBackToSavePoint('OnMoneyBack');
    raise;
  end;
end;}

procedure TFrameMoneyBack3.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key=vk_Return then
    Key:= 0;
end;

function TFrameMoneyBack3.Valid: Boolean;
var
  Msgs: TStringList;
begin
  Msgs:= TStringList.Create;
  try
    if Length(edPassportNum.Text) <> 9 then
      Msgs.Add('Неправильно введен номер паспорта');
    if edtPassportIssued.Value = null then
      Msgs.Add('Отсутсвует дата выдачи паспорта');
    if edPassportIssuer.Text = '' then
      Msgs.Add('Отсутсвует орган, выдавший паспорт');
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

procedure TFrameMoneyBack3.actMoneyBackExecute(Sender: TObject);
begin
  inherited;
  Write;
  if Valid then
  try
    dmOtto.ActionExecute(trnWrite, 'MONEYBACK', 'MONEYBACK_CREATE',
      XmlAttrs2Attr(ndClient, 'ACCOUNT_ID',
      Value2Attr(Byte(chkPayByFirm.Checked), 'PAYBYFIRM',
      Value2Attr(ExtractWord(rgMoneyBackKind.ItemIndex+1, 'BELPOST;BANK', ';'), 'KIND'))));

    trnWrite.Commit;
    ShowMessage('Возврат оформлен');
    TForm(Owner).Close;
  except
    trnWrite.Rollback;
  end;
end;

procedure TFrameMoneyBack3.rgMoneyBackKindClick(Sender: TObject);
begin
  inherited;
  grpBankMovement.Enabled:= rgMoneyBackKind.ItemIndex = 1;
end;

end.

