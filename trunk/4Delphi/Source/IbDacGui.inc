type

{ TIBCConnectDialog }

{$IFDEF VER16P}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32)]
{$ENDIF}
  {$IFDEF FMX}TIBCConnectDialogFmx{$ELSE}TIBCConnectDialog{$ENDIF} = class(TCustomConnectDialog)
  private
    function GetConnection: TIBCConnection;

  protected
    FDatabaseLabel: string;
    FProtocolLabel: string;

    function GetServerEnumeratorClass: TCRServerEnumeratorClass; override;
    procedure SetLabelSet(Value: TLabelSet); override;

    function DefDialogClass: TClass; override;
  {$IFDEF MSWINDOWS}
    function GetKeyPath: string; override;
    procedure SaveServerListToRegistry; override;
    procedure LoadServerListFromRegistry(List: _TStrings); override;
    procedure SaveInfoToRegistry(Registry: TRegistry); override;
    procedure LoadInfoFromRegistry(Registry: TRegistry); override;
  {$ENDIF}

  public
    constructor Create(Owner: TComponent); override;

    function Execute: boolean; override;

    property Connection: TIBCConnection read GetConnection;

  published
    property DatabaseLabel: string read FDatabaseLabel write FDatabaseLabel;
    property ProtocolLabel: string read FProtocolLabel write FProtocolLabel;

    property Retries;
    property SavePassword;
    property DialogClass;

    property Caption;
    property UsernameLabel;
    property PasswordLabel;
    property ServerLabel;
    property ConnectButton;
    property CancelButton;

    property LabelSet;
    property StoreLogInfo;
  end;

procedure GetIBCDatabaseList(Server: string; List: TStrings; RaiseErrors: boolean = True); overload;
procedure GetIBCDatabaseList(ServerIndex: integer; List: TStrings; RaiseErrors: boolean = True); overload;
function GetIBCProtocol(Server: string): integer;

procedure GetIBCServerList(List: _TStrings; WithEmpties: boolean = False; RaiseErrors: boolean = True);


implementation

uses
  {$IFDEF VER16P}{$IFDEF FMX}FMX.Types,{$ELSE}Controls,{$ENDIF}{$ENDIF}
  DAConsts;

function DefConnectDialogClass: TClass;
begin
  Result := {$IFDEF FMX}TIBCConnectDialogFmx{$ELSE}TIBCConnectDialog{$ENDIF};
end;

const
  KeyPath = '\SOFTWARE\Devart\IBDAC\';

procedure GetIBCServerList(List: _TStrings; WithEmpties: boolean = False; RaiseErrors: boolean = True);
{$IFDEF MSWINDOWS}
var
  Registry: TRegistry;
  ServerPath, ServerLabel: string;
  SvrName: string;
  i: integer;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  ServerLabel := 'Server';
  ServerPath := KeyPath + 'Connect\' + ServerLabel;
  Registry := TRegistry.Create;
  try
    if Registry.KeyExists(KeyPath + 'Connect') then begin
      List.Clear;
      i := 1;
      while Registry.OpenKey(Format('%s %d',[ServerPath, i]), False) do begin
        SvrName := Registry.ReadString(ServerLabel);
        if (SvrName <> '') or WithEmpties then
          List.Add(Registry.ReadString(ServerLabel));
        Inc(i);
        Registry.CloseKey;
      end;
    end;
  finally
    Registry.Free;
  end;
{$ENDIF}
end;

function GetServerIndex(Server: string): integer;
{$IFDEF MSWINDOWS}
var
  Registry: TRegistry;
  ServerPath, ServerLabel: string;
  i: integer;
{$ENDIF}
begin
  Result := -1;
{$IFDEF MSWINDOWS}

  ServerLabel := 'Server';
  ServerPath := KeyPath + 'Connect\' + ServerLabel;
  Registry := TRegistry.Create;
  try
    if Registry.KeyExists(KeyPath + 'Connect') then begin
      i := 1;
      while Registry.OpenKey(Format('%s %d',[ServerPath, i]), False) do begin
        if Server = Registry.ReadString(ServerLabel) then
          Result := i;
        Inc(i);
        Registry.CloseKey;
      end;
    end;
  finally
    Registry.Free;
  end;
{$ENDIF}
end;

procedure GetIBCDatabaseList(Server: string; List: TStrings; RaiseErrors: boolean = True);
{$IFDEF MSWINDOWS}
var
  ServerIndex: integer;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  ServerIndex := GetServerIndex(Server);
  if ServerIndex > 0 then
    GetIBCDatabaseList(ServerIndex, List, RaiseErrors);
{$ENDIF}
end;

procedure GetIBCDatabaseList(ServerIndex: integer; List: TStrings; RaiseErrors: boolean = True);
{$IFDEF MSWINDOWS}
var
  Registry: TRegistry;
  ServerLabel, DatabaseLabel: string;
  i: integer;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  ServerLabel := Format('Connect\Server %d', [ServerIndex]);
  DatabaseLabel := 'Database';
  Registry := TRegistry.Create;
  try
    if Registry.OpenKey(KeyPath + ServerLabel, False) then begin
      List.Clear;
      i := 1;
      while Registry.ValueExists(Format('%s %d',[DatabaseLabel, i])) do begin
        List.Add(Registry.ReadString(Format('%s %d',[DatabaseLabel, i])));
        Inc(i);
      end;
      Registry.CloseKey;
    end;
  finally
    Registry.Free;
  end;
{$ENDIF}
end;

function GetIBCProtocol(Server: string): integer;
var
{$IFDEF MSWINDOWS}
  Registry: TRegistry;
  ServerLabel : string;
{$ENDIF}  
  ServerIndex: integer;
begin
  Result := -1;
  ServerIndex := GetServerIndex(Server);
  if ServerIndex <= 0 then
    Exit;
{$IFDEF MSWINDOWS}
  ServerLabel := Format('Connect\Server %d', [ServerIndex]);
  Registry := TRegistry.Create;
  try
    if Registry.OpenKey(KeyPath + ServerLabel, False) then begin
      if Registry.ValueExists('Protocol') then
        Result := Registry.ReadInteger('Protocol');
      Registry.CloseKey;
    end;
  finally
    Registry.Free;
  end;
{$ENDIF}
end;

{ TIBCConnectDialog }

constructor {$IFDEF FMX}TIBCConnectDialogFmx{$ELSE}TIBCConnectDialog{$ENDIF}.Create(Owner: TComponent);
begin
  inherited;

  FDatabaseLabel := 'Database';
  FProtocolLabel := 'Protocol';
end;

function {$IFDEF FMX}TIBCConnectDialogFmx{$ELSE}TIBCConnectDialog{$ENDIF}.Execute: boolean;
var
  OldDatabase: string;
  OldProtocol: TIBCProtocol;
begin
  OldDatabase := TIBCConnection(Connection).Database;
  OldProtocol := TIBCConnection(Connection).Options.Protocol;

  Result := False;
  try
    Result := inherited Execute;
  finally
    if not Result then begin
      TIBCConnection(Connection).Database := OldDatabase;
      TIBCConnection(Connection).Options.Protocol := OldProtocol;
    end;
  end;
end;

function {$IFDEF FMX}TIBCConnectDialogFmx{$ELSE}TIBCConnectDialog{$ENDIF}.GetServerEnumeratorClass: TCRServerEnumeratorClass;
begin
  Result := TIBCServerEnumerator;
end;

procedure {$IFDEF FMX}TIBCConnectDialogFmx{$ELSE}TIBCConnectDialog{$ENDIF}.SetLabelSet(Value: TLabelSet);
begin
  inherited SetLabelSet(Value);

{$IFDEF WIN32_64}
  if Value <> lsCustom then begin
    FDatabaseLabel := GetString(6);
    FProtocolLabel := GetString(8);
  end;
{$ELSE}
    FDatabaseLabel := 'Database';
    FProtocolLabel := 'Protocol';
{$ENDIF}
end;

function {$IFDEF FMX}TIBCConnectDialogFmx{$ELSE}TIBCConnectDialog{$ENDIF}.DefDialogClass: TClass;
begin
  Result := TIBCConnectForm;
end;

{$IFDEF MSWINDOWS}
function {$IFDEF FMX}TIBCConnectDialogFmx{$ELSE}TIBCConnectDialog{$ENDIF}.GetKeyPath: string;
begin
  Result := KeyPath;
end;

procedure {$IFDEF FMX}TIBCConnectDialogFmx{$ELSE}TIBCConnectDialog{$ENDIF}.SaveInfoToRegistry(Registry: TRegistry);
begin
  inherited;

  Registry.WriteString('Database', TIBCConnection(Connection).Database);
  Registry.WriteInteger('Protocol', integer(TIBCConnection(Connection).Options.Protocol));
end;

procedure {$IFDEF FMX}TIBCConnectDialogFmx{$ELSE}TIBCConnectDialog{$ENDIF}.LoadInfoFromRegistry(Registry: TRegistry);
begin
  inherited;

  if Registry.ValueExists('Database') then
    TIBCConnection(Connection).Database := Registry.ReadString('Database');
  if Registry.ValueExists('Protocol') then
    TIBCConnection(Connection).Options.Protocol := TIBCProtocol(Registry.ReadInteger('Protocol'));
end;

procedure {$IFDEF FMX}TIBCConnectDialogFmx{$ELSE}TIBCConnectDialog{$ENDIF}.LoadServerListFromRegistry(List: _TStrings);
begin
  GetIBCServerList(List, False);
end;

procedure {$IFDEF FMX}TIBCConnectDialogFmx{$ELSE}TIBCConnectDialog{$ENDIF}.SaveServerListToRegistry;
var
  Registry: TRegistry;
  List: _TStrings;
  DbList: TStrings;
  i, j, ServerIndex: integer;
const
  ServerKey = 'Server';
  ProtocolKey = 'Protocol';
  DatabaseKey = 'Database';
begin
  Registry := TRegistry.Create;
  try
    if Registry.OpenKey(GetServerListKeyPath, True) then begin
      List := _TStringList.Create;
      try
        GetIBCServerList(List, True);
        ServerIndex := List.IndexOf(Connection.Server) + 1;
        if ServerIndex > 0 then
          Registry.MoveKey(Format('%s %d',[ServerKey, ServerIndex]), Format('%s %d',[ServerKey, 0]), True)
        else
          ServerIndex := List.Count + 1;

        Registry.OpenKey(Format('%s %d',[ServerKey, 0]), True);
        //Save DataBase & Protocol
        Registry.WriteString(ServerKey, Connection.Server);
        Registry.WriteInteger(ProtocolKey, integer(TIBCConnection(Connection).Options.Protocol));
      finally
        List.Free;
      end;

      DbList := TStringList.Create;
      try
        GetIBCDatabaseList(0, DbList);

        Registry.WriteString(Format('%s %d',[DatabaseKey, 1]), TIBCConnection(Connection).Database);
        i := 2;
        for j := 0 to DbList.Count - 1 do
          if AnsiCompareText(DbList[j], TIBCConnection(Connection).Database) <> 0 then begin
            Registry.WriteString(Format('%s %d',[DatabaseKey, i]), DbList[j]);
            Inc(i);
          end;
      finally
        DbList.Free;
      end;

      Registry.CloseKey;
      Registry.OpenKey(GetKeyPath + 'Connect', False);
      for i := ServerIndex - 1 downto 0 do
        if Registry.KeyExists(Format('%s %d',[ServerKey, i])) then
          Registry.MoveKey(Format('%s %d',[ServerKey, i]), Format('%s %d',[ServerKey, i + 1]), True);
      Registry.CloseKey;
    end;
  finally
    Registry.Free;
  end;
end;
{$ENDIF}

function {$IFDEF FMX}TIBCConnectDialogFmx{$ELSE}TIBCConnectDialog{$ENDIF}.GetConnection: TIBCConnection;
begin
  Result := (inherited Connection) as TIBCConnection;
end;

initialization
  DefConnectDialogClassProc := DefConnectDialogClass;
{$IFDEF VER16P}
{$IFDEF FMX}
  GroupDescendentsWith(TIBCConnectDialogFmx, TFmxObject);
{$ELSE}
  GroupDescendentsWith(TIBCConnectDialog, TControl);
{$ENDIF}
{$ENDIF}

end.
