unit uFormTableClients;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uBaseNSIForm, DBGridEhGrouping, FIBDatabase, pFIBDatabase,
  ImgList, PngImageList, ActnList, DB, FIBDataSet, pFIBDataSet, GridsEh,
  DBGridEh, StdCtrls, JvExStdCtrls, JvGroupBox, ExtCtrls, JvExExtCtrls,
  JvExtComponent, JvPanel, TB2Item, TBX, TB2Dock, TB2Toolbar, ComCtrls;

type
  TFormTableClients = class(TBaseNSIForm)
    pcClientDetail: TPageControl;
    tsClientOrders: TTabSheet;
    tsClientAccountMovements: TTabSheet;
    grdClientOrders: TDBGridEh;
    grdAccountMovements: TDBGridEh;
    qryAccountMovements: TpFIBDataSet;
    dsAccountMovements: TDataSource;
    qryClientOrders: TpFIBDataSet;
    dsClientOrders: TDataSource;
    actAccountManualDebit: TAction;
    actAccountManualCredit: TAction;
    btnAccountUserDebit: TTBXItem;
    btnAccountUserCredit: TTBXItem;
    procedure FormCreate(Sender: TObject);
    procedure actAccountManualDebitExecute(Sender: TObject);
    procedure actAccountManualCreditExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormTableClients: TFormTableClients;

implementation

uses
  udmOtto, NativeXml, GvNativeXml, uDlgPayment;

{$R *.dfm}

procedure TFormTableClients.FormCreate(Sender: TObject);
begin
  inherited;
  trnNSI.StartTransaction;
  qryMain.Open;
  qryAccountMovements.Open;
  qryClientOrders.Open;
end;

procedure TFormTableClients.actAccountManualDebitExecute(Sender: TObject);
var
  AccountId: Integer;
  Amount_Eur: Double;
  Byr2Eur: Integer;
  Xml: TNativeXml;
  ndClient: TXmlNode;
  DlgManualPayment: TDlgManualPayment;
begin
  DlgManualPayment:= TDlgManualPayment.Create(self);
  try
    DlgManualPayment.Caption:= 'Ручное зачисление на счет';
    if DlgManualPayment.ShowModal = mrOk then
    begin
      Amount_Eur:= DlgManualPayment.edtAmountEur.Value;
      Byr2Eur:= DlgManualPayment.edtByr2Eur.Value;
      Xml:= TNativeXml.CreateName('CLIENT');
      ndClient:= Xml.Root;
      try
        trnWrite.StartTransaction;
        dmOtto.ObjectGet(ndClient, qryMain['CLIENT_ID'], trnWrite);
        try
        if GetXmlAttrValue(ndClient, 'ACCOUNT_ID') = null then
          begin
            // Создаем счет
            AccountId:= dmOtto.GetNewObjectId('ACCOUNT');
            dmOtto.ActionExecute(trnWrite, 'ACCOUNT', 'ACCOUNT_CREATE', '', AccountId);
            SetXmlAttr(ndClient, 'ACCOUNT_ID', AccountId);
            dmOtto.ActionExecute(trnWrite, ndClient);
          end
          else
            AccountId:= qryMain['ACCOUNT_ID'];
          dmOtto.ActionExecute(trnWrite, 'ACCOUNT','ACCOUNT_MANUALDEBIT',
            Value2Vars(Amount_EUR, 'AMOUNT_EUR',
            Value2Vars(Byr2Eur, 'BYR2EUR')), AccountId);
          trnWrite.Commit;
        except
          on E:Exception do
            begin
              trnWrite.Rollback;
              ShowMessage(E.Message);
            end
        end;
      finally
        Xml.Free;
      end;
    end;
    qryMain.CloseOpen(True);
    qryAccountMovements.CloseOpen(True);
  finally
    DlgManualPayment.Free;
  end;
end;

procedure TFormTableClients.actAccountManualCreditExecute(Sender: TObject);
var
  AccountId: Integer;
  Amount_Eur: Double;
  Byr2Eur: Integer;
  Xml: TNativeXml;
  ndClient: TXmlNode;
  DlgManualPayment: TDlgManualPayment;
begin
  DlgManualPayment:= TDlgManualPayment.Create(self);
  try
    DlgManualPayment.Caption:= 'Ручное списание со счета';
    if DlgManualPayment.ShowModal = mrOk then
    begin
      Amount_Eur:= DlgManualPayment.edtAmountEur.Value;
      Byr2Eur:= DlgManualPayment.edtByr2Eur.Value;
      Xml:= TNativeXml.CreateName('CLIENT');
      ndClient:= Xml.Root;
      try
        trnWrite.StartTransaction;
        dmOtto.ObjectGet(ndClient, qryMain['CLIENT_ID'], trnWrite);
        try
        if GetXmlAttrValue(ndClient, 'ACCOUNT_ID') = null then
          begin
            // Создаем счет
            AccountId:= dmOtto.GetNewObjectId('ACCOUNT');
            dmOtto.ActionExecute(trnWrite, 'ACCOUNT', 'ACCOUNT_CREATE', '', AccountId);
            SetXmlAttr(ndClient, 'ACCOUNT_ID', AccountId);
            dmOtto.ActionExecute(trnWrite, ndClient);
          end
          else
            AccountId:= qryMain['ACCOUNT_ID'];
          dmOtto.ActionExecute(trnWrite, 'ACCOUNT','ACCOUNT_MANUALCREDIT',
            Value2Vars(Amount_EUR, 'AMOUNT_EUR',
            Value2Vars(Byr2Eur, 'BYR2EUR')), AccountId);
          trnWrite.Commit;
        except
          on E:Exception do
            begin
              trnWrite.Rollback;
              ShowMessage(E.Message);
            end
        end;
      finally
        Xml.Free;
      end;
    end;
    qryMain.CloseOpen(True);
    qryAccountMovements.CloseOpen(True);
  finally
    DlgManualPayment.Free;
  end;
end;

end.
