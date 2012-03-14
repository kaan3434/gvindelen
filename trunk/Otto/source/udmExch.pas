unit udmExch;

interface

uses
  SysUtils, Classes, FIBDatabase, pFIBDatabase, GvVars, DB,
  FIBDataSet, pFIBDataSet, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdExplicitTLSClientServerBase, IdFTP, IdIntercept,
  IdLogBase, IdLogFile, Dialogs, JvBaseDlg, JvDesktopAlert, JvComponentBase;

type
  TdmExch = class(TDataModule)
    dbOtto: TpFIBDatabase;
    trnWrite: TpFIBTransaction;
    trnRead: TpFIBTransaction;
    qryWays: TpFIBDataSet;
    IdFtp: TIdFTP;
    logFile: TIdLogFile;
    alertStockExcange: TJvDesktopAlertStack;
    procedure DataModuleCreate(Sender: TObject);
  private
    procedure ExchangeWay;
    procedure ChangePath(aNewPortPath: string);
    { Private declarations }
  public
    procedure ExchangeAllWays;
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
  IdURI, GvFile, GvStr, Forms, Variants;

procedure TdmExch.DataModuleCreate(Sender: TObject);
var
  dbParams: TVarList;
begin
  if dbOtto.Connected then dbOtto.Close;
  dbParams:= TVarList.Create;
  try
    dbParams.LoadSectionFromIniFile(IniFileName, 'DataBase_'+GetUserFromWindows);
    if dbParams.Count = 0 then
      dbParams.LoadSectionFromIniFile(IniFileName, 'DataBase');
    dbOtto.DBName:= dbParams['ServerName']+':'+dbParams['FileName'];
    dbOtto.ConnectParams.CharSet:= 'CYRL';
    try
      dbOtto.Open(true);
    except
      Halt;
    end;
    ExchangeAllWays;
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
        FTP.ProxySettings.ProxyType:= fpcmHttpProxyWithFtp;
      end;
    except
    end;
  finally
    sl.Free;
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


procedure TdmExch.ChangePath(aNewPortPath: string);
begin
  if aNewPortPath <> IdFtp.RetrieveCurrentDir then
  begin
    while IdFtp.RetrieveCurrentDir <> '/' do
      IdFtp.ChangeDirUp;
    while aNewPortPath <> '' do
      IdFtp.ChangeDir(TakeFront5(aNewPortPath, '/'));
  end;
end;

procedure TdmExch.ExchangeWay;
var
  PortFiles, LocalFiles: TStringList;
  LocalPath, FileName: string;
  i: Integer;
begin
  PortFiles:= TStringList.Create;
  LocalFiles:= TStringList.Create;
  try
    ChangePath(qryWays['PORT_PATH']);
    IdFtp.List(PortFiles, qryWays['FILE_MASK'], False);
    LocalPath:= ExtractFilePath(ParamStr(0))+ ReplaceAll(qryWays['LOCAL_PATH']+'/', '//', '/');
    if IsWordPresent('INBOUND', qryWays['FLAG_SIGN_LIST'], ',') then
    begin
      // Входящие сообщения
      for i:= 0 to PortFiles.Count-1 do
      begin
        if trnRead.DefaultDatabase.QueryValue(
          'select m.message_id from messages m where m.file_name = lower(:file_name)',
          0, [PortFiles[i]], trnRead) = null then
        begin
          FileName:= LocalPath+PortFiles[i];
          if Not FileExists(FileName) then
          try
            IdFtp.Get(PortFiles[i], FileName, True, false);
            CreateAlert('Получен файл', FileName, mtInformation, 3000);
          except;
          end;
          if IsWordPresent('DELETE', qryWays['FLAG_SIGN_LIST'], ',') then
            IdFtp.Delete(PortFiles[i]);
        end
      end;
    end
    else
    if IsWordPresent('OUTBOUND', qryWays['FLAG_SIGN_LIST'], ',') then
    begin
      // исходящие файлы
      ListFileName(LocalFiles, LocalPath+qryWays['FILE_MASK'], false);
      for i:= 0 to LocalFiles.Count - 1 do
      begin
        FileName:= ExtractFileName(LocalFiles[i]);
        if PortFiles.IndexOf(FileName) = -1 then
        try
          IdFtp.Put(LocalFiles[i], FileName);
          CreateAlert('Отправлен файл', FileName, mtInformation, 3000);
        except
        end;
        if IsWordPresent('DELETE', qryWays['FLAG_SIGN_LIST'], ',') then
          DeleteFile(LocalFiles[i]);
      end;
    end;
  finally
    PortFiles.Free;
    LocalFiles.Free;
  end;
end;

procedure TdmExch.ExchangeAllWays;
var
  URL: String;
  URI: TIdURI;
  Files: TStringList;
  i: Integer;
  FilePath, FileMask, FileName: String;
begin
  qryWays.Open;
  try
    qryWays.First;
    while not qryWays.Eof do
    begin
      try
        if URL <> qryWays['PORT_ADRESS'] then
        begin
          URL:= qryWays['PORT_ADRESS'];
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
          ExchangeWay;
      except
      end;
      qryWays.Next;
    end;
  finally
    qryWays.Close;
  end;
end;

initialization
  IniFileName:= ExtractFilePath(ParamStr(0))+'ppz2.ini';
  Path:= TVarList.Create;
  Path.LoadSectionFromIniFile(IniFileName, 'PATH');
  Path.Text:= ReplaceAll(Path.Text, '=.\', '='+ExtractFilePath(ParamStr(0)));
finalization
  Path.Free;
end.
