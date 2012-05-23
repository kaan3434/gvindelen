unit uFrameReturn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrameBase1, StdCtrls, ExtCtrls, ImgList, PngImageList,
  ActnList, FIBDatabase, pFIBDatabase, TBXStatusBars, TB2Dock, TB2Toolbar,
  TBX, JvExStdCtrls, JvGroupBox, Mask, JvExMask, JvMaskEdit,
  DBCtrlsEh, NativeXml, TB2Item, JvValidators, JvErrorIndicator,
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
    rgReturnKind: TRadioGroup;
    edBonus: TDBNumberEditEh;
    lblBonus: TLabel;
    chkPayByFirm: TCheckBox;
    btnMakeReturn: TTBXItem;
    actCreateReturn: TAction;
    vldFrame: TJvValidators;
    vldIndicator: TJvErrorIndicator;
    JvRequiredFieldValidator1: TJvRequiredFieldValidator;
    jvrngvldtr1: TJvRangeValidator;
    JvRequiredFieldValidator2: TJvRequiredFieldValidator;
    JvRequiredFieldValidator3: TJvRequiredFieldValidator;
    JvRequiredFieldValidator4: TJvRequiredFieldValidator;
    JvRequiredFieldValidator5: TJvRequiredFieldValidator;
    JvRequiredFieldValidator6: TJvRequiredFieldValidator;
    JvRequiredFieldValidator7: TJvRequiredFieldValidator;
    JvRequiredFieldValidator8: TJvRequiredFieldValidator;
    JvRequiredFieldValidator9: TJvRequiredFieldValidator;
    JvRequiredFieldValidator10: TJvRequiredFieldValidator;
    procedure rgReturnKindClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure actCreateReturnExecute(Sender: TObject);
  private
    function GetOrderId: Integer;
    { Private declarations }
  public
    ndOrder: TXmlNode;
    ndClient: TXmlNode;
    ndOrderMoneys: TXmlNode;
    ndMoneyBack: TXmlNode;
    procedure InitData; override;
    procedure FreeData; override;
    procedure OpenTables; override;
    procedure Read; override;
    procedure Write; override;
    procedure UpdateCaptions; override;
    property OrderId: Integer read GetOrderId;
  end;


implementation

{$R *.dfm}
uses
  GvNativeXml, udmOtto, GvStr;

procedure TFrameMoneyBack.FreeData;
begin
  inherited;

end;

function TFrameMoneyBack.GetOrderId: Integer;
begin
  Result:= ndOrder.ReadAttributeInteger('ID', 0)
end;

procedure TFrameMoneyBack.InitData;
begin
  inherited;

end;

procedure TFrameMoneyBack.OpenTables;
begin
  inherited;

end;

procedure TFrameMoneyBack.Read;
var
  ReturnKind: string;
begin
  edBelPostBarCode.Text:= GetXmlAttr(ndOrder, 'BELPOST_BAR_CODE');
  rgReturnKind.ItemIndex:= WordNo(GetXmlAttr(ndOrder, 'MONEYBACK_KIND'), 'LEAVE;BELPOST;BANK', ';');

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

procedure TFrameMoneyBack.rgReturnKindClick(Sender: TObject);
begin
  grpBankMovement.Enabled:= rgReturnKind.ItemIndex = 2;
end;

procedure TFrameMoneyBack.UpdateCaptions;
begin
  inherited;

end;

procedure TFrameMoneyBack.Write;
var
  ReturnKind: string;
begin
  trnWrite.SetSavePoint('OnMoneyBack');
  try
    SetXmlAttr(ndOrder, 'MONEYBACK_KIND', ExtractWord(rgReturnKind.ItemIndex+1, 'LEAVE;BELPOST;BANK', ';'));
    SetXmlAttr(ndOrder, 'BELPOST_BAR_CODE', edBelPostBarCode.Text);
    SetXmlAttr(ndOrder, 'BONUS_EUR', edBonus.text);

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

procedure TFrameMoneyBack.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key=vk_Return then
    Key:= 0;
end;

procedure TFrameMoneyBack.actCreateReturnExecute(Sender: TObject);
var
  MoneyEur: Double;
  Valid: Boolean;
begin
  inherited;
  Write;
  Valid:= vldFrame.Validate('COMMON');
  if rgReturnKind.ItemIndex = 2 then
    Valid:= Valid and vldFrame.Validate('BANK');
  if Valid then
  try
    SetXmlAttr(ndOrder, 'NEW.STATUS_SIGN', 'HAVERETURN');
    dmOtto.ActionExecute(trnWrite, ndOrder);
    dmOtto.ObjectGet(ndOrder, OrderId, trnWrite);
    if GetXmlAttrValue(ndOrder, 'MONEYBACK_KIND') = 'LEAVE' then
    begin
      MoneyEur:= trnWrite.DefaultDatabase.QueryValue(
        'select cost_eur from v_order_summary os where os.order_id = :order_id',
        0, [GetXmlAttrValue(ndOrder, 'ID')]);
      dmOtto.ActionExecute(trnWrite, 'ACCOUNT', 'ACCOUNT_DEBITORDER',
        XmlAttrs2Vars(ndOrder, 'ID=ACCOUNT_ID;ORDER_ID=ID',
        Value2Vars(MoneyEur, 'AMOUNT_EUR')));
    end;
    trnWrite.Commit;
    trnRead.Commit;
    ShowMessage('������� ��������');
    TForm(Owner).Close;
  except
    trnWrite.Rollback;
  end;
end;

end.
