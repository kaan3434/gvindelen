unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ImgList, TB2Item, TBX, TB2Dock, TB2Toolbar,
  TBXStatusBars, GvVars, PngImageList, DB, FIBDataSet, pFIBDataSet, 
  JvComponentBase, JvFormAutoSize, Menus, StdActns,
  FIBDatabase, pFIBDatabase, JvDSADialogs, frxClass, frxExportPDF,
  frxFIBComponents, ExtCtrls, DBGridEh,
  JvEmbeddedForms, JvProgressComponent, frxRich, pFIBScripter,
  JvBaseDlg,
  gsFileVersionInfo, JvLogFile, JvProgressDialog,
  frxExportXML,
  ComCtrls, TBXExtItems, frxExportXLS, frxDCtrl, gvXml;

type
  TMainForm = class(TForm)
    dckTop: TTBXDock;
    sbMain: TTBXStatusBar;
    tbrMain: TTBXToolbar;
    alMain: TActionList;
    actImportMessages: TAction;
    actParseOrder: TAction;
    btnParseOrder: TTBXItem;
    imgListMainMenu: TPngImageList;
    actArticleUpdate: TAction;
    actOrderCreate: TAction;
    btnOrderCreate: TTBXItem;
    actParseOrderXml: TAction;
    btnParseOrderXml: TTBXItem;
    actNSICatalogs: TAction;
    actNSISettings: TAction;
    tbSubMenuTables: TTBXSubmenuItem;
    btnTableClients: TTBXItem;
    imgListTables: TPngImageList;
    imgListNSI: TPngImageList;
    actTableClients: TAction;
    actTableOrders: TAction;
    btn1: TTBXItem;
    sMenu1: TTBXSubmenuItem;
    mm1: TMainMenu;
    File1: TMenuItem;
    FileNewItem: TMenuItem;
    FileOpenItem: TMenuItem;
    FileCloseItem: TMenuItem;
    FileSaveItem: TMenuItem;
    FileSaveAsItem: TMenuItem;
    N1: TMenuItem;
    FileExitItem: TMenuItem;
    Edit1: TMenuItem;
    CutItem: TMenuItem;
    CopyItem: TMenuItem;
    PasteItem: TMenuItem;
    Window1: TMenuItem;
    WindowCascadeItem: TMenuItem;
    WindowTileItem: TMenuItem;
    WindowTileItem2: TMenuItem;
    WindowMinimizeItem: TMenuItem;
    WindowArrangeItem: TMenuItem;
    Help1: TMenuItem;
    HelpAboutItem: TMenuItem;
    actList1: TActionList;
    actFileNew1: TAction;
    actFileOpen1: TAction;
    wndwclsFileClose1: TWindowClose;
    actFileSave1: TAction;
    actFileSaveAs1: TAction;
    actFileExit1: TAction;
    edtct1: TEditCut;
    edtcpy1: TEditCopy;
    edtpst1: TEditPaste;
    wndwcscd1: TWindowCascade;
    wndwtlhrzntl1: TWindowTileHorizontal;
    wndwtlvrtcl1: TWindowTileVertical;
    wndwmnmzl1: TWindowMinimizeAll;
    wndwrngAll: TWindowArrange;
    actHelpAbout1: TAction;
    trnWrite: TpFIBTransaction;
    actProcessMessages: TAction;
    subImportActions: TTBXSubmenuItem;
    btn4: TTBXItem;
    btn5: TTBXItem;
    btn6: TTBXItem;
    actProcessProtocol: TAction;
    actProcessLiefer: TAction;
    actProcessPackList: TAction;
    actProcessConsignment: TAction;
    btn7: TTBXItem;
    actPrintInvoices: TAction;
    btn3: TTBXItem;
    trnRead: TpFIBTransaction;
    actImportPayments: TAction;
    btn8: TTBXItem;
    btn9: TTBXItem;
    tmrImportMessages: TTimer;
    actInstallPatch: TAction;
    scrptUpdate: TpFIBScripter;
    btn10: TTBXItem;
    actExportOrders: TAction;
    btn11: TTBXItem;
    actSetByr2Eur: TAction;
    verInfo: TgsFileVersionInfo;
    log1: TJvLogFile;
    imgListAlerts: TPngImageList;
    actExportSMSRejected: TAction;
    btn12: TTBXItem;
    actExportCancellation: TAction;
    btn13: TTBXItem;
    actExportPayment: TAction;
    btn14: TTBXItem;
    actExportPackList: TAction;
    btn15: TTBXItem;
    actBackup: TAction;
    actRestore: TAction;
    subMenuSystem: TTBXSubmenuItem;
    btnBackup: TTBXItem;
    btnRestore: TTBXItem;
    btnPatch: TTBXItem;
    dlgOpenRestore: TOpenDialog;
    actProcessArtN: TAction;
    btn2: TTBXItem;
    btnCancellation: TTBXItem;
    actProcessCancellation: TAction;
    pbMain: TProgressBar;
    actReturn: TAction;
    btnReturn: TTBXItem;
    actProcessInfo2Pay: TAction;
    actExportToSite: TAction;
    btnExportToSite: TTBXItem;
    subExportActions: TTBXSubmenuItem;
    btnImportInfo2Pay: TTBXItem;
    actExportPrePacklist: TAction;
    btnPrePackList: TTBXItem;
    btnCleanUp: TTBXItem;
    actDBClean: TAction;
    actMoneyBackBank: TAction;
    btnMoneyReturn: TTBXItem;
    actMoneyBackBelpost: TAction;
    btnMoneyReturnPost: TTBXItem;
    actMoneyBackAccount: TAction;
    actReestrReturns: TAction;
    btn16: TTBXItem;
    barInfo: TTBXToolbar;
    lblBYR2EUR: TTBXLabelItem;
    actExportReturn: TAction;
    btnExportReturns: TTBXItem;
    trnTimer: TpFIBTransaction;
    subMenuReports: TTBXSubmenuItem;
    btnStatByPeriod: TTBXItem;
    actReportByPeriod: TAction;
    subReturns: TTBXSubmenuItem;
    btnNonDelivered: TTBXItem;
    actOrderUnclaimed: TAction;
    actPacklistByPeriod: TAction;
    btn17: TTBXItem;
    actUnclaimed: TAction;
    btnUnclaimed: TTBXItem;
    actProcessKomnR: TAction;
    btnParseInfoKomnr: TTBXItem;
    actProcessArt: TAction;
    btnInfoArt: TTBXItem;
    actProcessPaymentBaltPost: TAction;
    btnProcessPaymentBaltPost: TTBXItem;
    actExportDealerData: TAction;
    btnExportDealerData: TTBXItem;
    btnAdressList: TTBXItem;
    actAdressList: TAction;
    actActionCodes: TAction;
    N2: TMenuItem;
    N3: TMenuItem;
    procedure actParseOrderXmlExecute(Sender: TObject);
    procedure actOrderCreateExecute(Sender: TObject);
    procedure actNSICatalogsExecute(Sender: TObject);
    procedure actNSISettingsExecute(Sender: TObject);
    procedure actTableOrdersExecute(Sender: TObject);
    procedure actTableClientsExecute(Sender: TObject);
    procedure actProcessProtocolExecute(Sender: TObject);
    procedure actProcessLieferExecute(Sender: TObject);
    procedure actProcessConsignmentExecute(Sender: TObject);
    procedure actProcessPackListExecute(Sender: TObject);
    procedure actPrintInvoicesExecute(Sender: TObject);
    procedure actExportSMSRejectedExecute(Sender: TObject);
    procedure actExportCancellationExecute(Sender: TObject);
    procedure actImportPaymentsExecute(Sender: TObject);
    procedure tmrImportMessagesTimer(Sender: TObject);
    procedure actExportOrdersExecute(Sender: TObject);
    procedure actSetByr2EurExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actInstallPatchExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure scrptUpdateExecuteError(Sender: TObject; StatementNo,
      Line: Integer; Statement: TStrings; SQLCode: Integer;
      const Msg: string; var doRollBack, Stop: Boolean);
    procedure actExportPaymentExecute(Sender: TObject);
    procedure actExportPackListExecute(Sender: TObject);
    procedure actBackupExecute(Sender: TObject);
    procedure actRestoreExecute(Sender: TObject);
    procedure actProcessArtNExecute(Sender: TObject);
    procedure actProcessCancellationExecute(Sender: TObject);
    procedure alMainUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure actReturnExecute(Sender: TObject);
    procedure actProcessInfo2PayExecute(Sender: TObject);
    procedure actExportToSiteExecute(Sender: TObject);
    procedure actExportPrePacklistExecute(Sender: TObject);
    procedure actDBCleanExecute(Sender: TObject);
    procedure actMoneyBackBankExecute(Sender: TObject);
    procedure actMoneyBackBelpostExecute(Sender: TObject);
    procedure actMoneyBackAccountExecute(Sender: TObject);
    procedure actReestrReturnsExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure actExportReturnExecute(Sender: TObject);
    procedure actReportByPeriodExecute(Sender: TObject);
    procedure actOrderUnclaimedExecute(Sender: TObject);
    procedure actPacklistByPeriodExecute(Sender: TObject);
    procedure btnUnclaimedClick(Sender: TObject);
    procedure actProcessKomnRExecute(Sender: TObject);
    procedure actProcessArtExecute(Sender: TObject);
    procedure actProcessPaymentBaltPostExecute(Sender: TObject);
    procedure actExportDealerDataExecute(Sender: TObject);
    procedure actAdressListExecute(Sender: TObject);
    procedure actActionCodesExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure PrintPackList(aTransaction: TpFIBTransaction; Packlist_No: Integer;
      aFileName: string);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}
uses
  GvFile, GvStr, udmOtto, FIBQuery, 
  uBaseNSIForm,
  uFormTableOrder, uFormTableClients, uParseProtocol, uParseLiefer,
  uParseConsignment, pFIBQuery, uParsePayments,
  uFormWizardOrder, uSetByr2Eur, uExportSMSReject,
  uExportCancellation, uExportOrder, uExportInvoices, uExportPackList,
  uParseArtN, uParseCancellation, uFormWizardReturn, uParseInfo2Pay,
  uExportToSite, uExportPrePackList, uMoneyBack, uReportReturnedOrderItems,
  uExportReturns, uParseInfoKomnr, uParseArt, uParsePaymentsBP,
  uExportDealerData, uFormActions;

procedure TMainForm.actParseOrderXmlExecute(Sender: TObject);
var
  MessageId: integer;
begin
  MessageId := dmOtto.MessageBusy(1);
  if MessageId > 0 then
  try
    TFormWizardOrder.CreateMessage(self, MessageId).Show;
    Exit;
  except
    on E: Exception do
    begin
      if MessageDlg(E.Message + #13#10'Забраковать заявку?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        dmOtto.MessageError(trnWrite, MessageId);
    end;
  end;

  MessageId := dmOtto.MessageBusy(12);
  if MessageId > 0 then
  try
    TFormWizardOrder.CreateMessage(self, MessageId).Show;
    exit;
  except
    on E: Exception do
    begin
      if MessageDlg(E.Message + #13#10'Забраковать заявку?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        dmOtto.MessageError(trnWrite, MessageId);
    end;
  end
end;

procedure TMainForm.actOrderCreateExecute(Sender: TObject);
begin
  TFormWizardOrder.CreateBlank(Self).Show;
end;

procedure TMainForm.actNSICatalogsExecute(Sender: TObject);
begin
  with TBaseNSIForm.Create(self) do
  begin
    qryMain.SelectSQL.Text := 'select * from catalogs order by catalog_id';
    qryMain.Open;
    Show;
  end;
end;

procedure TMainForm.actNSISettingsExecute(Sender: TObject);
begin
  with TBaseNSIForm.Create(self) do
  begin
    qryMain.SelectSQL.Text := 'select * from settings order by 1';
    qryMain.Open;
    Show;
  end;
end;

procedure TMainForm.actTableOrdersExecute(Sender: TObject);
begin
  with TFormTableOrders.Create(Self) do
    Show;
end;

procedure TMainForm.actTableClientsExecute(Sender: TObject);
begin
  with TFormTableClients.Create(Self) do
    Show;
end;

procedure TMainForm.actProcessProtocolExecute(Sender: TObject);
var
  vMessageId: Integer;
begin
  repeat
    vMessageId := dmOtto.MessageBusy(3);
    if vMessageId > 0 then
    begin
      ProcessProtocol(vMessageId, trnWrite);
      Application.ProcessMessages;
    end;
  until vMessageId = 0;
  dmOtto.MessageRelease(3);
end;

procedure TMainForm.actProcessLieferExecute(Sender: TObject);
var
  vMessageId: Integer;
begin
  repeat
    vMessageId := dmOtto.MessageBusy(4);
    if vMessageId > 0 then
    begin
      ProcessLiefer(vMessageId, trnWrite);
      Application.ProcessMessages;
    end;
  until vMessageId = 0;
  dmOtto.MessageRelease(4);
end;

procedure TMainForm.actProcessConsignmentExecute(Sender: TObject);
var
  vMessageId: Integer;
begin
  repeat
    vMessageId := dmOtto.MessageBusy(6);
    if vMessageId > 0 then
    begin
      ProcessConsignment(vMessageId, trnWrite);
      Application.ProcessMessages;
    end;
  until vMessageId = 0;
  dmOtto.MessageRelease(6);
end;

procedure TMainForm.actProcessPackListExecute(Sender: TObject);
begin
  //  repeat
  //    MessageId:= dmOtto.MessageBusy(5);
  //    if MessageId > 0 then
  //      ProcessPacklist(MessageId, trnMain);
  //  until MessageId = 0;
end;


procedure TMainForm.PrintPackList(aTransaction: TpFIBTransaction;
  Packlist_No: Integer; aFileName: string);
begin
  with dmOtto do
  begin
    frxExportXLS.DefaultPath := Path['DbfPackLists'];
    frxExportXLS.FileName := aFileName;
    frxReport.LoadFromFile(Path['FastReport'] + 'packlistpi3.fr3');
    frxReport.Variables.Variables['PackList_No'] := Format('''%u''', [Packlist_No]);
    frxReport.PrepareReport(true);
    frxReport.Export(frxExportXLS);
  end;
end;


procedure TMainForm.actPrintInvoicesExecute(Sender: TObject);
var
  OrderIdArr: array of variant;
  i: Integer;
begin
  trnWrite.StartTransaction;
  with dmOtto.qryTempRead do
  begin
    Transaction := trnWrite;
    SQL.Text := 'select order_id from v_order_invoiceable order by order_id';
    ExecQuery;
    try
      while not Eof do
      begin
//        dmOtto.ActionExecute(trnWrite, 'ORDER', 'ORDER_INVOICE', '', Fields[0].AsInteger);
//        PrintInvoice(trnWrite, Fields[0].AsInteger);
        Next;
      end;
    finally
      Close;
    end;
    trnWrite.Commit;
  end;
end;

procedure TMainForm.actImportPaymentsExecute(Sender: TObject);
var
  vMessageId: Integer;
begin
  repeat
    vMessageId := dmOtto.MessageBusy(7);
    if vMessageId > 0 then
    begin
      ProcessPayment(vMessageId, trnWrite);
      Application.ProcessMessages;
    end;
  until vMessageId = 0;
  dmOtto.MessageRelease(7);
end;

procedure TMainForm.actProcessArtNExecute(Sender: TObject);
var
  vMessageId: Integer;
begin
  repeat
    vMessageId := dmOtto.MessageBusy(9);
    if vMessageId > 0 then
    begin
      ProcessArtN(vMessageId, trnWrite);
      Application.ProcessMessages;
    end;
  until vMessageId = 0;
  dmOtto.MessageRelease(9);
end;

procedure TMainForm.actProcessCancellationExecute(Sender: TObject);
var
  vMessageId: Integer;
begin
  repeat
    vMessageId := dmOtto.MessageBusy(8);
    if vMessageId > 0 then
    begin
      ProcessCancellation(vMessageId, trnWrite);
      Application.ProcessMessages;
    end;
  until vMessageId = 0;
  dmOtto.MessageRelease(8);
end;

procedure TMainForm.actProcessInfo2PayExecute(Sender: TObject);
var
  vMessageId: Integer;
begin
  repeat
    vMessageId := dmOtto.MessageBusy(10);
    if vMessageId > 0 then
    begin
      ProcessInfo2Pay(vMessageId, trnWrite);
      Application.ProcessMessages;
    end;
  until vMessageId = 0;
  dmOtto.MessageRelease(10);
end;



procedure TMainForm.tmrImportMessagesTimer(Sender: TObject);
var
  sl: TStringList;
  i: Integer;
  MessageCount: integer;
  MessageId: Variant;
  StatusSign, FileName: string;
begin
  if not dmOtto.dbOtto.Connected then Exit;
  sl := TStringList.Create;
  trnTimer.StartTransaction;
  try
    ListFileName(sl, Path['Messages.In'] + '*.*', true);
    with dmOtto.spTemp do
    begin
      Transaction := trnTimer;
      StoredProcName := 'MESSAGE_CREATE';
      Params.ClearValues;
      MessageCount := 0;
      for i := 0 to sl.Count - 1 do
      begin
        // проверяем зарегистрирован ли файл
        MessageId := trnTimer.DefaultDatabase.QueryValue(
          'select m.message_id from messages m where lower(m.file_name) = lower(:file_name)',
          0, [ExtractFileName(sl[i])], trnTimer);
        // Если зарегистрирован, проверяем статус обработки
        if MessageId <> null then
        begin
          StatusSign := trnTimer.DefaultDatabase.QueryValue(
            'select s.status_sign from messages m' +
            ' inner join statuses s on (s.status_id = m.status_id)' +
            ' where m.message_id = :message_id',
            0, [MessageId], trnTimer);
          if StatusSign = 'SUCCESS' then
            GvFile.MoveFile(sl[i], Path['Messages.Processed'] + FormatDateTime('YYYY.MM.DD\', Date));
        end
        else
        begin
          trnTimer.SetSavePoint('CreateMessage');
          FileName := AnsiToUtf8(Copy(sl[i], Length(Path['Messages.In']) + 1,
            Length(sl[i])));
          ParamByName('I_FILE_NAME').Value := AnsiLowerCaseFileName(FileName);
          ParamByName('I_FILE_SIZE').Value := GetFileSize(sl[i]);
          ParamByName('I_FILE_DTM').AsDateTime := FileDateToDateTime(fileAge(sl[i]));
          ExecProc;
          if VarIsNull(ParamValue('O_MESSAGE_ID')) then
          begin
            trnTimer.RollBackToSavePoint('CreateMessage');
            ForceDirectories(Path['Messages.Unknown']);
            GvFile.MoveFile(sl[i], Path['Messages.Unknown']);
          end
          else
            Inc(MessageCount);
        end;
      end;
    end;
    trnTimer.Commit;
    sbMain.SimpleText := Format('%u сообщений зарегистрировано',
      [MessageCount]);
  finally
    sl.Free;
  end
end;

procedure TMainForm.actExportOrdersExecute(Sender: TObject);
var
  ProductXml: TGvXml;
  p: Integer;
  FileName: string;
begin
  ExportApprovedOrder(trnWrite);
end;

procedure TMainForm.actSetByr2EurExecute(Sender: TObject);
begin
  with TFormSetByr2Eur.Create(Self) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TMainForm.FormShow(Sender: TObject);
var
  Byr2EurDate: variant;
begin
  tmrImportMessages.OnTimer(Self);
  if not trnRead.Active then
    trnRead.StartTransaction;
  Byr2EurDate := trnRead.DefaultDatabase.QueryValue(
    'select cast(s.valid_dtm as date) from settings s ' +
    'where s.setting_sign = ''BYR2EUR'' ' +
    'and cast(s.valid_dtm as date) = current_date ', 0, trnRead);
  if Byr2EurDate = null then
    actSetByr2Eur.Execute;
end;

procedure TMainForm.actInstallPatchExecute(Sender: TObject);
const
  HeaderText = 'Установка обновлений';
var
  BeforeBackupFileName: string;
  AfterBackupFileName: string;
  ScriptMeta, ScriptData: string;
  NewBuild: string;
begin
  NewBuild := FillFront(IntToStr(dmOtto.Build + 1), 6, '0');
  dmOtto.CreateAlert(HeaderText, Format('Установка патча %s ...', [NewBuild]),
    mtInformation, 10000);
  if dmOtto.dbOtto.Connected then
    dmOtto.dbOtto.Close;
  BeforeBackupFileName := Format('%s%s_%s_Before.fbk',
    [Path['Backup'], FormatDateTime('YYYYMMDD', Date), NewBuild]);
  ScriptMeta := Format('%s%s_meta.sql',
    [Path['Updates'], NewBuild]);
  ScriptData := Format('%s%s_data.sql',
    [Path['Updates'], NewBuild]);
  AfterBackupFileName := Format('%s%s_%s_After.fbk',
    [Path['Backup'], FormatDateTime('YYYYMMDD', Date), NewBuild]);
  try
    try
      dmOtto.BackupDatabase(BeforeBackupFileName);
    except
      on E: Exception do
      begin
        dmOtto.CreateAlert(HeaderText,
          Format('Ошибка создания резервной копии "%s" (%s)',
          [BeforeBackupFileName, E.Message]), mtError);
        raise;
      end;
    end;
    dmOtto.dbOtto.Open;
    trnWrite.StartTransaction;
    try
      try
        scrptUpdate.ExecuteFromFile(ScriptMeta);
      except
        on E: Exception do
        begin
          dmOtto.CreateAlert(HeaderText,
            Format('Ошибка при выпонении скрипта "%s" (%s)',
            [ScriptMeta, E.Message]), mtError);
          raise;
        end;
      end;
      try
        scrptUpdate.ExecuteFromFile(ScriptData);
      except
        on E: Exception do
        begin
          dmOtto.CreateAlert(HeaderText,
            Format('Ошибка при выпонении скрипта "%s" (%s)',
            [ScriptData, E.Message]), mtError);
          raise;
        end;
      end;
      if trnWrite.Active = False then
        trnWrite.StartTransaction;
      trnWrite.ExecSQLImmediate(Format(
        'insert into builds (build) values (%s)',
        [NewBuild]));
      trnWrite.Commit;
    except
      trnWrite.Rollback;
      raise;
    end;
    dmOtto.dbOtto.Close;
    try
      dmOtto.BackupDatabase(AfterBackupFileName);
      dmOtto.CreateAlert(HeaderText, Format('Версия %s установлена',
        [NewBuild]), mtInformation);
    except
      on E: Exception do
      begin
        dmOtto.CreateAlert(HeaderText,
          Format('Ошибка создания резервной копии "%s" (%s)',
          [BeforeBackupFileName, E.Message]), mtError);
        raise;
      end;
    end;
    dmOtto.dbOtto.Open(true);
  except
    NewBuild := FillFront(IntToStr(dmOtto.Build), 6, '0');
    try
      dmOtto.RestoreDatabase(BeforeBackupFileName);
      dmOtto.CreateAlert(HeaderText, Format('Версия %s восстановлена', [NewBuild]),
        mtWarning);
      dmOtto.dbOtto.Open(true);
    except
      on E: Exception do
        dmOtto.CreateAlert(HeaderText,
          Format('Ошибка при восстановлении верcии "%s". Восстановите базу из резеврное копии вручную. (%s)',
          [NewBuild, E.Message]), mtError);
    end;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  verInfo.Filename := ParamStr(0);
  Caption := Format('PPZ2 Builds:%s/%s %s', [verInfo.GetBuildOnly, dmOtto.Build, dmOtto.UserName]);
  for i := 0 to tbrMain.Items.Count - 1 do
    if tbrMain.Items[i].GroupIndex = 1 then
      tbrMain.Items[i].Visible := dmOtto.isAdminRole;
end;

procedure TMainForm.scrptUpdateExecuteError(Sender: TObject; StatementNo,
  Line: Integer; Statement: TStrings; SQLCode: Integer; const Msg: string;
  var doRollBack, Stop: Boolean);
begin
  Log1.Add(FormatDateTime('DD-MM-YYYY HH:NN', Now), IntToStr(Line) + ' ' +
    Statement.Text + Msg);
  log1.ShowLog('aaa');
end;

procedure TMainForm.actExportSMSRejectedExecute(Sender: TObject);
begin
  ExportSMS(trnWrite);
end;

procedure TMainForm.actExportCancellationExecute(Sender: TObject);
begin
  ExportCancelRequest(trnWrite);
end;

procedure TMainForm.actExportPaymentExecute(Sender: TObject);
begin
  ExportInvoices(trnWrite);
end;

procedure TMainForm.actExportPackListExecute(Sender: TObject);
begin
  ExportPackList(trnWrite);
end;

procedure TMainForm.actBackupExecute(Sender: TObject);
const
  HeaderText = 'Резерная копия';
var
  Build, FileName: string;
  FileList: TStringList;
begin
  Build := FillFront(IntToStr(dmOtto.Build), 6, '0');
  dmOtto.CreateAlert(HeaderText, Format('Создание копии %s ...', [Build]),
    mtInformation, 10000);
  FileName := GetNextFileName(Format('%s%s_%s_%%u',
    [Path['Backup'], FormatDateTime('YYYYMMDD', Date), Build]), 1);
  try
    if dmOtto.dbOtto.Connected then
      dmOtto.dbOtto.Close;
    dmOtto.BackupDatabase(FileName + '.fbk');
    dmOtto.MoveToZip(FileName + '.fbk', FileName + '.7z');
    dmOtto.CreateAlert(HeaderText, Format('Резерная копия %s создана',
      [ExtractFileNameOnly(FileName)]), mtInformation);
  finally
    dmOtto.dbOtto.Open;
  end;
end;

procedure TMainForm.actRestoreExecute(Sender: TObject);
const
  HeaderText = 'Резерная копия';
var
  Build, BeforeBackupFileName: string;
begin
  dlgOpenRestore.InitialDir := Path['Backup'];
  if dlgOpenRestore.Execute then
  begin
    Build := FillFront(IntToStr(dmOtto.Build), 6, '0');
    dmOtto.CreateAlert(HeaderText, Format('Создание копии %s ...', [Build]),
      mtInformation, 10000);
    BeforeBackupFileName := Format('%s%s_%s_prerestore.fbk',
      [Path['Backup'], FormatDateTime('YYYYMMDD', Date), Build]);
    if dmOtto.dbOtto.Connected then
      dmOtto.dbOtto.Close;
    try
      dmOtto.CreateAlert(HeaderText, Format('Восстановление копии %s ...',
        [ExtractFileNameOnly(dlgOpenRestore.FileName)]),
        mtInformation, 10000);
      dmOtto.RestoreDatabase(dlgOpenRestore.FileName);
      dmOtto.CreateAlert(HeaderText, Format('Восстановлено из копии %s ...',
        [ExtractFileNameOnly(dlgOpenRestore.FileName)]),
        mtInformation);
    except
      try
        dmOtto.RestoreDatabase(BeforeBackupFileName);
        dmOtto.CreateAlert(HeaderText, Format('Версия %s восстановлена', [Build]),
          mtWarning);
      except
        on E: Exception do
          dmOtto.CreateAlert(HeaderText,
            Format('Ошибка при восстановлении верcии "%s". Восстановите базу из резеврное копии вручную. (%s)',
            [Build, E.Message]), mtError);
      end;
    end;
    dmOtto.dbOtto.Open(true);
  end
  else
  begin
    dmOtto.CreateAlert(HeaderText, 'Восстановление из копии отменено',
      mtInformation, 10000);
    Exit;
  end;
end;

procedure TMainForm.alMainUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  actInstallPatch.Enabled := verInfo.GetBuildOnly > dmOtto.Build;
  if actInstallPatch.Enabled then
    subMenuSystem.ImageIndex := actInstallPatch.ImageIndex;
end;


procedure TMainForm.actReturnExecute(Sender: TObject);
var
  OrderId: variant;
  OrderCode: string;

begin
//  OrderCode:= '7002';
  if InputQuery('Возврат позиций заявки', 'Укажите номер заявки', OrderCode) then
  begin
    OrderId := trnRead.DefaultDatabase.QueryValue(
      'select o.order_id from orders o ' +
      ' inner join statuses s on (s.status_id = o.status_id) ' +
      'where order_code like ''%''||:order_code '
      , 0, [FillFront(FilterString(OrderCode, '0123456789'), 5, '0')], trnRead);
    if OrderId <> null then
      TFormWizardReturn.CreateDB(Self, OrderId)
    else
      ShowMessage('Заявка еще не доставлена или не существует');
  end;
end;

procedure TMainForm.actExportToSiteExecute(Sender: TObject);
begin
  ExportToSite(trnRead);
end;

procedure TMainForm.actExportPrePacklistExecute(Sender: TObject);
begin
  ExportPrePackList(trnWrite);
end;

procedure TMainForm.actDBCleanExecute(Sender: TObject);
begin
  dmOtto.CleanUp;
end;

procedure TMainForm.actMoneyBackBankExecute(Sender: TObject);
begin
  ReportMoneyBackBank(trnWrite);
end;

procedure TMainForm.actMoneyBackBelpostExecute(Sender: TObject);
begin
  ReportMoneyBackBelpost(trnWrite);
end;

procedure TMainForm.actMoneyBackAccountExecute(Sender: TObject);
begin
  ReportMoneyBackAccount(trnWrite);
end;

procedure TMainForm.actReestrReturnsExecute(Sender: TObject);
begin
  ReportReturnedOrderItems(trnWrite);
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
  lblBYR2EUR.Caption := Format('Курс Евро: %s BYR',
    [dmOtto.SettingGet(trnRead, 'BYR2EUR')]);
end;

procedure TMainForm.actExportReturnExecute(Sender: TObject);
begin
  ExportReturns(trnWrite);
end;

procedure TMainForm.actReportByPeriodExecute(Sender: TObject);
begin
  with dmOtto do
  begin
    frxReport.LoadFromFile(Path['FastReport'] + 'OperStats.fr3');
    frxReport.ShowReport;
  end;
end;

procedure TMainForm.actOrderUnclaimedExecute(Sender: TObject);
var
  OrderId: variant;
  OrderCode: string;
begin
//  OrderCode:= '7002';
  if InputQuery('Возврат невостребованной заявки', 'Укажите номер заявки', OrderCode) then
  begin
    OrderId := trnRead.DefaultDatabase.QueryValue(
      'select o.order_id from orders o ' +
      ' inner join statuses s on (s.status_id = o.status_id and s.status_sign = ''DELIVERING'') ' +
      'where order_code like ''%''||:order_code '
      , 0, [FillFront(FilterString(OrderCode, '0123456789'), 5, '0')], trnRead);
    if OrderId <> null then
    begin
      trnWrite.StartTransaction;
      try
        dmOtto.ActionExecute(trnWrite, 'ORDER', 'ORDER_UNCLAIM', nil, OrderId);
        trnWrite.Commit;
        ShowMessage('Заявка переведена в статус "Невостребована"');
      except
        trnWrite.Rollback;
      end
    end
    else
      ShowMessage('Заявка еще не доставлена или не существует');
  end;
end;

procedure TMainForm.actPacklistByPeriodExecute(Sender: TObject);
begin
  with dmOtto do
  begin
    frxReport.LoadFromFile(Path['FastReport'] + 'PacklistStats.fr3');
    frxReport.ShowReport;
  end;
end;

procedure TMainForm.btnUnclaimedClick(Sender: TObject);
begin
  with dmOtto do
  begin
    frxReport.LoadFromFile(Path['FastReport'] + 'UnClaimed.fr3');
    frxReport.ShowReport;
  end;
end;

procedure TMainForm.actProcessKomnRExecute(Sender: TObject);
var
  vMessageId: Integer;
begin
  repeat
    vMessageId := dmOtto.MessageBusy(14);
    if vMessageId > 0 then
    begin
      ProcessInfoKomnr(vMessageId, trnWrite);
      Application.ProcessMessages;
    end;
  until vMessageId = 0;
end;

procedure TMainForm.actProcessArtExecute(Sender: TObject);
var
  vMessageId: Integer;
begin
  repeat
    vMessageId := dmOtto.MessageBusy(15);
    if vMessageId > 0 then
    begin
      ProcessInfoArt(vMessageId, trnWrite);
      Application.ProcessMessages;
    end;
  until vMessageId = 0;
end;

procedure TMainForm.actProcessPaymentBaltPostExecute(Sender: TObject);
var
  vMessageId: Integer;
begin
  repeat
    vMessageId := dmOtto.MessageBusy(16);
    if vMessageId > 0 then
    begin
      ProcessPaymentBaltPost(vMessageId, trnWrite);
      Application.ProcessMessages;
    end;
  until vMessageId = 0;
end;

procedure TMainForm.actExportDealerDataExecute(Sender: TObject);
begin
  ExportDealerData(trnWrite);
end;

procedure TMainForm.actAdressListExecute(Sender: TObject);
begin
  with dmOtto do
  begin
    frxReport.LoadFromFile(Path['FastReport'] + 'Adresses.fr3');
    frxReport.ShowReport;
  end;
end;

procedure TMainForm.actActionCodesExecute(Sender: TObject);
var
  frmActionCodes: TfrmActionCodeSetup;
begin
  frmActionCodes := TfrmActionCodeSetup.Create(Self);
  try
    frmActionCodes.ShowModal;
  finally
    frmActionCodes.Free;
  end;
end;

end.


