unit udmExch;

interface

uses
  SysUtils, Classes, FIBDatabase, pFIBDatabase, GvVars, JvTimer, DB,
  FIBDataSet, pFIBDataSet, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdExplicitTLSClientServerBase, IdFTP, IdIntercept,
  IdLogBase, IdLogFile, Dialogs, JvBaseDlg, JvDesktopAlert, JvComponentBase;

type
  TdmExch = class(TDataModule)
    dbOtto: TpFIBDatabase;
    trnWrite: TpFIBTransaction;
    trnRead: TpFIBTransaction;
    tmrScan: TJvTimer;
    qryPorts: TpFIBDataSet;
    IdFtp: TIdFTP;
    logFile: TIdLogFile;
    alertStockExcange: TJvDesktopAlertStack;
    procedure DataModuleCreate(Sender: TObject);
    procedure tmrScanTimer(Sender: TObject);
  private
    { Private declarations }
  public
    procedure CreateAlert(aHeaderText, aMessageText: string;
      DlgType: TMsgDlgType; Duration: Integer = 0);
  end;

var
  dmExch: TdmExch;
  Path: TVarList;
  IniFileName: string;

implementation

{$R *.dfm}

uses
  IdURI, GvFile, GvStr, Forms;

procedure TdmExch.DataModuleCreate(Sender: TObject);
var
  dbParams: TVarList;
begin
  if dbOtto.Connected then dbOtto.Close;
  dbParams:= TVarList.Create;
  try
    dbParams.LoadSectionFromIniFile(IniFileName, 'DataBase_'+GetUserFromWindows);
    if dbParams.Count = 0 then
      dbParams.LoadSectionFromIniFile(ProjectIniFileName, 'DataBase');
    dbOtto.DBName:= dbParams['ServerName']+':'+dbParams['FileName'];
    dbOtto.ConnectParams.CharSet:= 'CYRL';
    try
      dbOtto.Open(true);
    except
      Halt;
    end;
    tmrScanTimer(Self);
  finally
    dbParams.Free;
  end;
end;

procedure FillProxy(FTP: TIdFTP);
var
  sl: TStringList;
begin
  Sl:= TStringList.Create;
  try
    try
      sl.Text:= ReadIniSection(IniFileName, 'Proxy_'+GetUserFromWindows);
      if sl.Text <> '' then
      begin
        FTP.ProxySettings.Host:= Sl.Values['Host'];
        FTP.ProxySettings.Port:= StrToInt(sl.Values['Port']);
      end;
    except
    end;
  finally
    sl.Free;
  end;
end;

procedure TdmExch.tmrScanTimer(Sender: TObject);
var
  URL: String;
  URI: TIdURI;
  Files: TStringList;
  i: Integer;
  FilePath, FileMask, FileName: String;
begin
  tmrScan.Enabled:= False;
  qryPorts.Open;
  URL:= '';
  Files:= TStringList.Create;
  try
    qryPorts.First;
    while not qryPorts.Eof do
    begin
      if URL <> qryPorts['PORT_ADRESS'] then
      begin
        URL:= qryPorts['PORT_ADRESS'];
        URI:= TIdURI.Create(URL);
        try
          if IdFtp.Connected then
            IdFtp.Disconnect;
          IdFtp.Host:= URI.Host;
          if URI.Port <> '' then IdFtp.Port:= StrToInt(URI.Port);
          IdFtp.Username:= URI.Username;
          IdFtp.Password:= URI.Password;
          FillProxy(IdFTP);
          try
            IdFtp.Connect;
          except
            CreateAlert('Ошибка соединения', URI.Host, mtError, 30000);
          end;
        finally
          URI.Free;
        end;
      end;
      if IdFtp.Connected then
      begin
        Files.Clear;
        while IdFtp.RetrieveCurrentDir <> '/' do
          IdFtp.ChangeDirUp;
        FilePath:= IdFtp.RetrieveCurrentDir;
        FilePath:= ReplaceAll(qryPorts['SOURCE_PATH'], '/', '\');
        FileMask:= ExtractFileName(FilePath);
        FilePath:= ExtractFilePath(FilePath);
        while FilePath <> '' do
          IdFtp.ChangeDir(TakeFront5(FilePath, '\'));
        IdFTP.List(Files, FileMask, false);
        for i:= 0 to Files.Count-1 do
        begin
          FileName:= Format('%s%s\%s',
             [ExtractFilePath(ParamStr(0)), qryPorts['DEST_PATH'], Files[i]]);
          if Not FileExists(FileName) then
          try
            IdFtp.Get(Files[i], Format('%s%s\%s',
             [ExtractFilePath(ParamStr(0)), qryPorts['DEST_PATH'], Files[i]]), True, false);
            CreateAlert('Получен файл', ExtractFileName(FileName), mtInformation, 30000);
          except;
          end;
        end;
      end;
      qryPorts.Next;
    end;
  finally
    qryPorts.Close;
    tmrScan.Enabled:= true;
    URL:= '';
    Files.Free;
  end;
end;

procedure TdmExch.CreateAlert(aHeaderText, aMessageText: string;
  DlgType: TMsgDlgType; Duration: Integer = 0);
var
  DesktopAlert: TJvDesktopAlert;
  i: Integer;
begin
  DesktopAlert := TJvDesktopAlert.Create(nil);
  with DesktopAlert do
  begin
    AutoFree := True;
    HeaderText := aHeaderText;
    if Length(aMessageText) < 100 then
      MessageText := aMessageText
    else
    begin
      MessageText := Copy(aMessageText, 1, 100) + '...';
      ShowHint := True;
      Hint := aMessageText;
    end;
    StyleOptions.DisplayDuration := Duration;
    Options := [daoCanClose];
    ParentFont := True;
    //    Image.Bitmap.Canvas.FillRect(Image.BitmapClientRect); //очищаем канву
//    if DlgType = mtError then
//      imgListAlerts.Draw(Image.Bitmap.Canvas, 0, 0, 1)
//    else
//      imgListAlerts.Draw(Image.Bitmap.Canvas, 0, 0, 0);
    with StyleOptions do
    begin
      StartInterval := 1;
      StartSteps := 0;
    end;
    Execute;
  end;
  Sleep(100);
  for i := 0 to 100 do
    Application.ProcessMessages;
end;


initialization
  IniFileName:= ExtractFilePath(ParamStr(0))+'ppz2.ini';
  Path:= TVarList.Create;
  Path.LoadSectionFromIniFile(IniFileName, 'PATH');
  Path.Text:= ReplaceAll(Path.Text, '=.\', '='+ExtractFilePath(ParamStr(0)));
finalization
  Path.Free;
end.
