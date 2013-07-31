unit uFormTableClients;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uBaseNSIForm, FIBDatabase, pFIBDatabase,
  ImgList, PngImageList, ActnList, DB, FIBDataSet, pFIBDataSet, GridsEh,
  DBGridEh, StdCtrls, JvExStdCtrls, JvGroupBox, ExtCtrls, JvExExtCtrls,
  JvExtComponent, JvPanel, TB2Item, TBX, TB2Dock, TB2Toolbar, ComCtrls,
  DBGridEhGrouping, Menus, FIBQuery, pFIBQuery, pFIBStoredProc,
  ToolCtrlsEh, DBGridEhToolCtrls, DBAxisGridsEh;

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
    tsAdresses: TTabSheet;
    grdAdresses: TDBGridEh;
    qryAdresses: TpFIBDataSet;
    dsAdresses: TDataSource;
    spAccountRecalcRest: TpFIBStoredProc;
    actMoneyBack: TAction;
    btnMoneyBack: TTBXItem;
    procedure FormCreate(Sender: TObject);
    procedure actAccountManualDebitExecute(Sender: TObject);
    procedure actAccountManualCreditExecute(Sender: TObject);
    procedure trnReadAfterStart(Sender: TObject);
    procedure grdMainRowDetailPanelShow(Sender: TCustomDBGridEh;
      var CanShow: Boolean);
    procedure grdMainRowDetailPanelHide(Sender: TCustomDBGridEh;
      var CanHide: Boolean);
    procedure actAccOpersEditExecute(Sender: TObject);
    procedure qryMainBeforeScroll(DataSet: TDataSet);
    procedure actMoneyBackExecute(Sender: TObject);
    procedure actMoneyBackUpdate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormTableClients: TFormTableClients;

implementation

uses
  udmOtto, NativeXml, GvNativeXml, uDlgPayment, uFormWizardMoneyBack3;

{$R *.dfm}

procedure TFormTableClients.FormCreate(Sender: TObject);
begin
  inherited;
  trnRead.StartTransaction;
  tlBarNsiActions.Visible:= dmOtto.isAdminRole;
end;

procedure TFormTableClients.actAccountManualDebitExecute(Sender: TObject);
var
  AccountId: Integer;
  Amount_Eur: Double;
  Byr2Eur: Integer;
  Xml: TNativeXml;
  ndClient: TXmlNode;
  DlgManualPayment: TDlgManualPayment;
  Annotate: string;
  bm: TBookmark;
begin
  DlgManualPayment:= TDlgManualPayment.Create(self);
  qryMain.DisableControls;
  bm:= qryMain.GetBookmark;
  try
    DlgManualPayment.Caption:= 'Ğó÷íîå çà÷èñëåíèå íà ñ÷åò';
    if DlgManualPayment.ShowModal = mrOk then
    begin
      Amount_Eur:= DlgManualPayment.edtAmountEur.Value;
      Byr2Eur:= DlgManualPayment.edtByr2Eur.Value;
      Xml:= TNativeXml.CreateName('CLIENT');
      Annotate:= DlgManualPayment.memAnnotate.Lines.Text;
      ndClient:= Xml.Root;
      try
        trnWrite.StartTransaction;
        dmOtto.ObjectGet(ndClient, qryMain['CLIENT_ID'], trnWrite);
        try
        if GetXmlAttrValue(ndClient, 'ACCOUNT_ID') = null then
          begin
            // Ñîçäàåì ñ÷åò
            AccountId:= dmOtto.GetNewObjectId('ACCOUNT');
            dmOtto.ActionExecute(trnWrite, 'ACCOUNT', 'ACCOUNT_CREATE', '', AccountId);
            SetXmlAttr(ndClient, 'ACCOUNT_ID', AccountId);
            dmOtto.ActionExecute(trnWrite, ndClient);
          end
          else
            AccountId:= qryMain['ACCOUNT_ID'];
          dmOtto.ActionExecute(trnWrite, 'ACCOUNT','ACCOUNT_MANUALDEBIT',
            Value2Vars(Amount_EUR, 'AMOUNT_EUR',
            Value2Vars(Byr2Eur, 'BYR2EUR',
            Value2Vars(Annotate, 'ANNOTATE'))), AccountId);
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
    trnRead.Commit;
    trnRead.StartTransaction;
  finally
    DlgManualPayment.Free;
    qryMain.GotoBookmark(bm);
    qryMain.FreeBookmark(bm);
    qryMain.EnableControls;
  end;
end;

procedure TFormTableClients.actAccountManualCreditExecute(Sender: TObject);
var
  Amount_Eur: Double;
  Byr2Eur: Integer;
  Xml: TNativeXml;
  ndClient: TXmlNode;
  DlgManualPayment: TDlgManualPayment;
  Annotate: string;
  bm : TBookmark;
begin
  DlgManualPayment:= TDlgManualPayment.Create(self);
  qryMain.DisableControls;
  bm:= qryMain.GetBookmark;
  try
    DlgManualPayment.Caption:= 'Ğó÷íîå ñïèñàíèå ñî ñ÷åòà';
    if DlgManualPayment.ShowModal = mrOk then
    begin
      Amount_Eur:= DlgManualPayment.edtAmountEur.Value;
      Byr2Eur:= DlgManualPayment.edtByr2Eur.Value;
      Annotate:= DlgManualPayment.memAnnotate.Lines.Text;
      Xml:= TNativeXml.CreateName('CLIENT');
      ndClient:= Xml.Root;
      try
        trnWrite.StartTransaction;
        dmOtto.ObjectGet(ndClient, qryMain['CLIENT_ID'], trnWrite);
        try
          dmOtto.ActionExecute(trnWrite, 'ACCOUNT','ACCOUNT_MANUALCREDIT',
            Value2Vars(Amount_EUR, 'AMOUNT_EUR',
            Value2Vars(Byr2Eur, 'BYR2EUR',
            Value2Vars(Annotate, 'ANNOTATE'))), qryMain['ACCOUNT_ID']);
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
    trnRead.Commit;
    trnRead.StartTransaction;
  finally
    DlgManualPayment.Free;
    qryMain.GotoBookmark(bm);
    qryMain.FreeBookmark(bm);
    qryMain.EnableControls;
  end;
end;

procedure TFormTableClients.trnReadAfterStart(Sender: TObject);
begin
  inherited;
  qryMain.Open;
end;

procedure TFormTableClients.grdMainRowDetailPanelShow(
  Sender: TCustomDBGridEh; var CanShow: Boolean);
begin
  inherited;
  qryAdresses.Open;
  qryClientOrders.Open;
  qryAccountMovements.Open;
end;

procedure TFormTableClients.grdMainRowDetailPanelHide(
  Sender: TCustomDBGridEh; var CanHide: Boolean);
begin
  inherited;
  qryAdresses.Close;
  qryClientOrders.Close;
  qryAccountMovements.Close;
end;

procedure TFormTableClients.actAccOpersEditExecute(Sender: TObject);
begin
  trnWrite.StartTransaction;
  dsAccountMovements.AutoEdit:= true;
end;

procedure TFormTableClients.qryMainBeforeScroll(DataSet: TDataSet);
var
  mr: Word;
begin
  if trnWrite.Active then
  begin
    mr:= MessageDlg('Ñîõğàíèòü èçìåíåíèÿ?', mtConfirmation, mbYesNoCancel, 0);
    if mr = mrYes then
    begin
      with spAccountRecalcRest do
      begin
        ParamByName('I_ACCOUNT_ID').AsInteger:= DataSet['Account_Id'];
        ExecProc;
      end;
      trnWrite.Commit;
    end
    else
    if mr = mrNo then
      trnWrite.Rollback
    else
      DataSet.Cancel;
  end;

end;

procedure TFormTableClients.actMoneyBackExecute(Sender: TObject);
begin
  TFormWizardBase1.CreateDB(Self, qryMain['client_id']).Show;
end;

procedure TFormTableClients.actMoneyBackUpdate(Sender: TObject);
begin
  actMoneyBack.Enabled:= qryMain['REST_EUR'] > 0;
end;

end.
