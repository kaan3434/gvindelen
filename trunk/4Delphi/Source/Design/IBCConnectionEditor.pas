
//////////////////////////////////////////////////
//  InterBase Data Access Components
//  Copyright © 1998-2011 Devart. All right reserved.
//  IBCConnection Editor
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I IbDac.inc}

unit IBCConnectionEditor;
{$ENDIF}
interface
uses
  SysUtils, Classes,
{$IFDEF MSWINDOWS}
  Windows, Messages, Registry,
{$ENDIF}
  Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, Buttons, IbDacVcl,
{$IFNDEF FPC}
  Mask,
{$ENDIF}
{$IFDEF FPC}
  LResources,
{$ENDIF}
{$IFNDEF STD}
  IBCAdmin,
{$ENDIF}
  CRTypes, DBAccess, DAConnectionEditor, IBC, IBCCall, IBCClasses;

{$IFDEF MSWINDOWS}
const
  WM_SETDATABASETEXT = WM_USER + 1;
{$ENDIF}

type
  TIBCConnectionEditorForm = class(TDAConnectionEditorForm)
    lbDatabase: TLabel;
    edDatabase: TComboBox;
    lbProtocol: TLabel;
    edProtocol: TComboBox;
    shOptions: TTabSheet;
    lbClientLibrary: TLabel;
    edClientLibrary: TEdit;
    btClientLibrary: TBitBtn;
    lbCharset: TLabel;
    edCharset: TComboBox;
    lbRole: TLabel;
    edRole: TEdit;
    gbParams: TGroupBox;
    meParams: TMemo;
    procedure edDatabaseChange(Sender: TObject);
    procedure edDatabaseDropDown(Sender: TObject);
    procedure edProtocolChange(Sender: TObject);
    procedure edRoleChange(Sender: TObject);
    procedure edCharsetChange(Sender: TObject);
    procedure meParamsExit(Sender: TObject);
    procedure btClientLibraryClick(Sender: TObject);
    procedure edServerChange(Sender: TObject);
    procedure edClientLibraryChange(Sender: TObject);
    procedure edCharsetDropDown(Sender: TObject);
  private
    FDataBaseText: string;
    FCurrItemIndex: Integer;
    FCurrItemText: string;
  {$IFNDEF STD}
    FService: TCustomIBCService;
  {$ENDIF}
  {$IFDEF MSWINDOWS}
    procedure WMSetDataBaseText(var Message: TMessage); message WM_SETDATABASETEXT;
  {$ENDIF}
  protected
    FProtocols: array of Integer;
    function GetConnection: TIBCConnection;
    procedure SetConnection(Value: TIBCConnection);

    procedure DoInit; override;
    procedure DoActivate; override;
    procedure FillInfo; override;
  {$IFNDEF STD}
    function GetComponent: TComponent; override;
    procedure SetComponent(Value: TComponent); override;
    procedure PerformConnect; override;
    procedure PerformDisconnect; override;
    function IsConnected: boolean; override;
    procedure AssignUsername(const Value: string); override;
    procedure AssignPassword(const Value: string); override;
    procedure AssignServer(const Value: string); override;
    procedure AssignLoginPrompt(Value: boolean); override;
    function GetConnectDialogClass: TConnectDialogClass; override;
  {$ENDIF}

    procedure ConnToControls; override;
    procedure ControlsToConn; override;

    procedure GetServerList(List: _TStrings); override;
  {$IFDEF MSWINDOWS}
    procedure AddServerToList; override;
  {$ENDIF}
    function IsValidKeyValue(Value: string; Name: string): boolean;

    procedure GetDatabaseList(List: TStrings);

    procedure GetProtocolList(List: TStrings);
  public
    property Connection: TIBCConnection read GetConnection write SetConnection;
  end;

  procedure GetCharsetList(Connection: TIBCConnection; List: TStrings);

implementation

{$IFNDEF FPC}
{$R IBCConnectionEditor.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF}

uses
  DacVcl, DAConsts, TypInfo, CREditor;

var
  LastServer,
  LastDatabase: string;
  KnownCharsetList: TStringList;

procedure GetCharsetList(Connection: TIBCConnection; List: TStrings);
var
  Query: TIBCQuery;
begin
  Query := nil;
  Assert(Connection <> nil);
  if Connection.Connected and ((LastServer <> Connection.Server) or (LastDatabase <> Connection.Database)) then
    try
      Query := TIBCQuery.Create(nil);
      Query.Connection := Connection;
      Query.SQL.Text := 'SELECT RDB$CHARACTER_SET_NAME FROM RDB$CHARACTER_SETS';
      Query.FetchAll := True;
      Query.Open;
      KnownCharsetList.Sorted := True;
      while not Query.Eof do begin
        KnownCharsetList.Add(Query.Fields[0].AsString);
        Query.Next;
      end;
      KnownCharsetList.Sorted := False;
      KnownCharsetList.Move(KnownCharsetList.IndexOf('NONE'), 0);
      LastServer := Connection.Server;
      LastDatabase := Connection.Database;
    finally
      Query.Free;
    end;
  List.Assign(KnownCharsetList);
end;

{ TIBCConnectionEditorForm }

procedure TIBCConnectionEditorForm.DoInit;
begin
  GetProtocolList(edProtocol.Items);

{$IFNDEF STD}
  if FService <> nil then begin
    if not IsPublishedProp(FService, 'Database') then begin
      lbDatabase.Enabled := False;
      edDatabase.Enabled := False;
    end;
    lbRole.Enabled := False;
    edRole.Enabled := False;
    lbCharset.Enabled := False;
    edCharset.Enabled := False;
    btConnect.Caption := 'Attach';
    btDisconnect.Caption := 'Detach';
  end;
{$ENDIF}

  inherited;
  lbVersion.Caption := IBDACVersion + ' ';
  UpdateVersionPosition;
  FCurrItemIndex := -1;
  FCurrItemText := '';
{$IFDEF CLR}
  gbParams.Height := gbParams.Height + gbParams.Top - edClientLibrary.Top;
  gbParams.Top := edClientLibrary.Top;
  lbClientLibrary.Visible := False;
  edClientLibrary.Visible := False;
  btClientLibrary.Visible := False;
{$ENDIF}
end;

procedure TIBCConnectionEditorForm.DoActivate;
begin
  inherited;

  if InitialProperty = 'Params' then begin
    PageControl.ActivePage := shOptions;
    meParams.SetFocus;
  end
  else
  if InitialProperty <> '' then
    Assert(False, InitialProperty);
end;

procedure TIBCConnectionEditorForm.FillInfo;
var
  Line: string;
begin
  meInfo.Lines.BeginUpdate;
  try
    meInfo.Clear;
    Line := 'Server Version: ';
    if (Connection <> nil) and Connection.Connected then
      if Connection.DatabaseInfo.FBVersion <> '' then
        Line := Line + Connection.DatabaseInfo.FBVersion
      else
        Line := Line + Connection.DatabaseInfo.Version;
    meInfo.Lines.Add(Line);
    Line := 'Client Version: ';
    if (Connection <> nil) and Connection.Connected then
      Line := Line + TDBAccessUtils.GetIConnection(Connection).GetClientVersion;
    meInfo.Lines.Add(Line);
    Line := 'ODS Version: ';
    if (Connection <> nil) and Connection.Connected then
      Line := Line + IntToStr(Connection.DatabaseInfo.ODSMajorVersion) + '.' + IntToStr(Connection.DatabaseInfo.ODSMinorVersion);
    meInfo.Lines.Add(Line);
    Line := 'Client Library: ';
    if (Connection <> nil) and Connection.Connected then
      Line := Line + Connection.ClientLibrary;
    meInfo.Lines.Add(Line);
    Line := 'Database SQL Dialect: ';
    if (Connection <> nil) and Connection.Connected then
      Line := Line + IntToStr(Connection.DatabaseInfo.DBSQLDialect);
    meInfo.Lines.Add(Line);
    meInfo.SelStart := 0;
  finally
    meInfo.Lines.EndUpdate;
  end;
end;

{$IFNDEF STD}
function TIBCConnectionEditorForm.GetComponent: TComponent;
begin
  if FService <> nil then
    Result := FService
  else
    Result := inherited GetComponent;
end;

procedure TIBCConnectionEditorForm.SetComponent(Value: TComponent);
begin
  if Value is TCustomIBCService then
    FService := TCustomIBCService(Value)
  else
    inherited;
end;

procedure TIBCConnectionEditorForm.PerformConnect;
var
  OldLoginPrompt: boolean;
begin
  if FService <> nil then begin
    OldLoginPrompt := FService.LoginPrompt;
    FService.LoginPrompt := False;
    try
      FService.Attach;
    finally
      FService.LoginPrompt := OldLoginPrompt;
    end;
  end
  else
    inherited;
end;

procedure TIBCConnectionEditorForm.PerformDisconnect;
begin
  if FService <> nil then
    FService.Detach
  else
    inherited;
end;

function TIBCConnectionEditorForm.IsConnected: boolean;
begin
  if FService <> nil then
    Result := FService.Active
  else
    Result := inherited IsConnected;
end;

procedure TIBCConnectionEditorForm.AssignUsername(const Value: string);
begin
  if FService <> nil then begin
    FService.Detach;
    FService.Username := Value;
  end
  else
    inherited;
end;

procedure TIBCConnectionEditorForm.AssignPassword(const Value: string);
begin
  if FService <> nil then begin
    FService.Detach;
    FService.Password := Value;
  end
  else
    inherited;
end;

procedure TIBCConnectionEditorForm.AssignServer(const Value: string);
begin
  if FService <> nil then begin
    FService.Detach;
    FService.Server := Value;
  end
  else
    inherited;
end;

procedure TIBCConnectionEditorForm.AssignLoginPrompt(Value: boolean);
begin
  if FService <> nil then
    FService.LoginPrompt := Value
  else
    inherited;
end;

function TIBCConnectionEditorForm.GetConnectDialogClass: TConnectDialogClass;
begin
  Result := TIBCConnectDialog;
end;
{$ENDIF}

procedure TIBCConnectionEditorForm.ConnToControls;
Var
  OldOnChange: TNotifyEvent;
begin
{$IFNDEF STD}
  if FService <> nil then begin
    edUsername.Text := FService.Username;
    edPassword.Text := FService.Password;
    edServer.Text := FService.Server;
    cbLoginPrompt.Checked := FService.LoginPrompt;

    if IsPublishedProp(FService, 'Database') then
      edDatabase.Text := GetStrProp(FService, 'Database');
    edProtocol.ItemIndex := edProtocol.Items.IndexOf(GetEnumName(TypeInfo(TIBCProtocol), Integer(FService.Protocol)));
    meParams.Text := FService.Params.Text;

    OldOnChange := edClientLibrary.OnChange;
    edClientLibrary.OnChange := nil;
    try
      edClientLibrary.Text := FService.ClientLibrary;
    finally
      edClientLibrary.OnChange := OldOnChange;
    end;
  end
  else
{$ENDIF}
  begin
    inherited;

    edDatabase.Text := Connection.Database;
    edProtocol.ItemIndex := edProtocol.Items.IndexOf(GetEnumName(TypeInfo(TIBCProtocol), Integer(Connection.Options.Protocol)));
    edRole.Text := Connection.Options.Role;
    edCharset.Text := Connection.Options.Charset;
    meParams.Text := Connection.Params.Text;

    OldOnChange := edClientLibrary.OnChange;
    edClientLibrary.OnChange := nil;
    try
      edClientLibrary.Text := Connection.ClientLibrary;
    finally
      edClientLibrary.OnChange := OldOnChange;
    end;
  end;
end;

procedure TIBCConnectionEditorForm.ControlsToConn;
begin
{$IFNDEF STD}
  if FService <> nil then begin
    FService.Params.Text := meParams.Text;
  end
  else
{$ENDIF}
  begin
    inherited;

    Connection.Params.Text := meParams.Text;
  end;
end;

function TIBCConnectionEditorForm.GetConnection: TIBCConnection;
begin
  Result := FConnection as TIBCConnection;
end;

procedure TIBCConnectionEditorForm.SetConnection(Value: TIBCConnection);
begin
  FConnection := Value;
end;

{$IFDEF MSWINDOWS}
procedure TIBCConnectionEditorForm.WMSetDataBaseText(var Message: TMessage);
begin
  edDatabase.SetFocus;
  edDatabase.Text := FDataBaseText;
{$IFNDEF STD}
  if FService <> nil then begin
    if IsPublishedProp(FService, 'Database') then
      SetStrProp(FService, 'Database', edDatabase.Text);
  end
  else
{$ENDIF}
    Connection.Database := edDatabase.Text;
  edDatabase.SelectAll;
end;
{$ENDIF}

procedure TIBCConnectionEditorForm.edDatabaseChange(Sender: TObject);
var
  Dialog: TOpenDialog;
begin
  if FInDoInit then
    Exit;

  try
    if edDatabase.Text = '<Browse...>' then begin
      Dialog := nil;
      try
        Dialog := TOpenDialog.Create(nil);
      {$IFDEF MSWINDOWS}
        Dialog.Filter := 'Database Files (*.gdb;*.fdb;*.ib)|*.gdb;*.fdb;*.ib' +
          '|InterBase Database Files (*.gdb)|*.gdb' +
          '|Firebird Database Files (*.fdb)|*.fdb' +
          '|InterBase 7 Database Files (*.ib)|*.ib' +
          '|All Files (*.*)|*.*';
      {$ELSE}
        Dialog.Filter := 'All Files (*)|*';
      {$ENDIF}
        Dialog.Options := Dialog.Options + [ofFileMustExist];
        if Dialog.Execute then begin
          PerformDisconnect;
          FDataBaseText := Dialog.FileName;
        {$IFDEF MSWINDOWS}
          PostMessage(Handle, WM_SETDATABASETEXT, 0, 0);
        {$ENDIF}
        end
        else begin
          edDatabase.ItemIndex := FCurrItemIndex;
          if (FCurrItemIndex = -1) and (FCurrItemText <> '') then begin
            FDataBaseText := FCurrItemText;
          {$IFDEF MSWINDOWS}
            PostMessage(Handle, WM_SETDATABASETEXT, 0, 0);
          {$ENDIF}
          end;
          
        end;
      finally
        Dialog.Free;
      end;
    end
    else begin
      FCurrItemIndex := edDatabase.Items.IndexOf(edDatabase.Text);
      FCurrItemText := edDatabase.Text;
    end;
  {$IFNDEF STD}
    if FService <> nil then begin
      if IsPublishedProp(FService, 'Database') then
        SetStrProp(FService, 'Database', edDatabase.Text);
    end
    else
  {$ENDIF}
      Connection.Database := edDatabase.Text;
  finally
    ShowState;
  end;
end;

procedure TIBCConnectionEditorForm.edDatabaseDropDown(Sender: TObject);
begin
{$IFDEF UNIX}
  edDatabase.OnGetItems := nil;
  try
{$ENDIF}
  StartWait;
  try
    FCurrItemText := edDatabase.Text;
    GetDatabaseList(edDatabase.Items);
    if edDatabase.Items.Count < 20 then
      edDatabase.DropDownCount := edDatabase.Items.Count
    else
      edDatabase.DropDownCount := 20;
  finally
    StopWait;
  end;
{$IFDEF UNIX}
  finally
    edDatabase.OnGetItems := edDatabaseDropDown;
  end;
{$ENDIF}
end;

procedure TIBCConnectionEditorForm.GetProtocolList(List: TStrings);
var
  i: integer;
  s: string;
begin
  List.Clear;
  for i := Integer(Low(TIBCProtocol)) to Integer(High(TIBCProtocol)) do begin
    s := GetEnumName(TypeInfo(TIBCProtocol), i);
    List.Add(s);
  end;
end;

procedure TIBCConnectionEditorForm.edProtocolChange(Sender: TObject);
begin
  if FInDoInit then
    Exit;

  try
    if edProtocol.Text <> '' then
    {$IFNDEF STD}
      if FService <> nil then begin
        FService.Detach;
        FService.Protocol := TIBCProtocol(GetEnumValue(TypeInfo(TIBCProtocol), edProtocol.Text));
      end
      else
    {$ENDIF}
        Connection.Options.Protocol := TIBCProtocol(GetEnumValue(TypeInfo(TIBCProtocol), edProtocol.Text));
  finally
    ShowState;
  end;
end;

procedure TIBCConnectionEditorForm.edRoleChange(Sender: TObject);
begin
  if FInDoInit then
    Exit;

  try
    if Connection <> nil then
      Connection.Options.Role := edRole.Text;
  finally
    ShowState;
  end;
end;

procedure TIBCConnectionEditorForm.edCharsetChange(Sender: TObject);
begin
  if FInDoInit then
    Exit;

  try
    if (Connection <> nil) and (Connection.Options.Charset <> edCharset.Text) then begin
      Connection.Disconnect;
      Connection.Options.Charset := edCharset.Text;
    end;
  finally
    ShowState;
  end;
end;

procedure TIBCConnectionEditorForm.meParamsExit(Sender: TObject);
begin
  if FInDoInit then
    Exit;

  try
  {$IFNDEF STD}
    if FService <> nil then
      FService.Params.Text := meParams.Text
    else
  {$ENDIF}
      Connection.Params.Text := meParams.Text;
  finally
    ShowState;
  end;
end;

procedure TIBCConnectionEditorForm.btClientLibraryClick(Sender: TObject);
var
  OpenDialog: TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(nil);
  try
  {$IFDEF MSWINDOWS}
    OpenDialog.Filter := 'Dynamic link library (*.dll)|*.dll|All Files (*.*)|*.*';
  {$ELSE}
    OpenDialog.Filter := 'All Files (*)|*';
  {$ENDIF}
    OpenDialog.Options := OpenDialog.Options + [ofFileMustExist];
    if OpenDialog.Execute then begin
      PerformDisconnect;
      edClientLibrary.SetFocus;
      edClientLibrary.Text := OpenDialog.FileName;
      edClientLibrary.SelectAll;
      edClientLibraryChange(nil);
    end;
  finally
    OpenDialog.Free;
  end;
end;

procedure TIBCConnectionEditorForm.edClientLibraryChange(Sender: TObject);
begin
{$IFNDEF STD}
  if FService <> nil then begin
    FService.Detach;
  {$IFNDEF CLR}
    FService.ClientLibrary := edClientLibrary.Text;
  {$ENDIF}
  end
  else
{$ENDIF}
  begin
    Connection.Connected := False;
  {$IFNDEF CLR}
    Connection.ClientLibrary := edClientLibrary.Text;
  {$ENDIF}
  end;
end;

{$IFDEF MSWINDOWS}

{$IFDEF FPC}
const
  IbDacKey = '\SOFTWARE\Devart\IBDAC\Connect';
{$ENDIF}

procedure TIBCConnectionEditorForm.AddServerToList;
var
  i: integer;
  ServerName, s: string;
  DatabaseName: string;
  KeyNames: TStringList;
  ValueNames: TStringList;
  Values: TStringList;
  ConnectKey: string;
begin
  if FRegistry <> nil then begin
    KeyNames := nil;
    ValueNames := nil;
    Values := nil;
  {$IFNDEF FPC}
    ConnectKey := FRegistry.CurrentPath;
  {$ELSE}
    ConnectKey := IbDacKey;
  {$ENDIF}
  {$IFNDEF STD}
    if FService <> nil then begin
      ServerName := FService.Server;
      if IsPublishedProp(FService, 'Database') then
        DatabaseName := GetStrProp(FService, 'Database')
      else
        exit
    end
    else
  {$ENDIF}
    begin
      ServerName := Connection.Server;
      DatabaseName := Connection.Database;
    end;
    try
      KeyNames := TStringList.Create;
      FRegistry.GetKeyNames(KeyNames);
      KeyNames.Sort;
      for i := 0 to KeyNames.Count - 1 do
        if IsValidKeyValue(KeyNames[i], 'Server') then begin
          FRegistry.CloseKey;
          FRegistry.OpenKey(ConnectKey + '\' + KeyNames[i], False);
          if AnsiUppercase(FRegistry.ReadString('Server')) = AnsiUppercase(ServerName) then begin
            FRegistry.CloseKey;
            FRegistry.MoveKey(ConnectKey + '\' + KeyNames[i], ConnectKey + '\' + 'Server 0', True);
            Break;
          end;
        end;
      FRegistry.CloseKey;
      FRegistry.OpenKey(ConnectKey + '\Server 0', True);
      FRegistry.WriteString('Server', ServerName);
      FRegistry.WriteInteger('Protocol', edProtocol.ItemIndex);
      ValueNames := TStringList.Create;
      FRegistry.GetValueNames(ValueNames);
      ValueNames.Sort;
      Values := TStringList.Create;
      Values.Add(DatabaseName);
      for i := 0 to ValueNames.Count - 1 do
        if IsValidKeyValue(ValueNames[i], 'Database') and (FRegistry.GetDataType(ValueNames[i]) = rdString) then begin
          s := Trim(FRegistry.ReadString(ValueNames[i]));
          if (s <> '') and (Values.IndexOf(s) = -1) then
            Values.Add(s);
          FRegistry.DeleteValue(ValueNames[i]);
        end;
      for i := 0 to Values.Count - 1 do begin
        s := Format('Database %d', [i + 1]);
        FRegistry.WriteString(s, Values[i]);
      end;
      FRegistry.CloseKey;
      FRegistry.OpenKey(ConnectKey, False);
      FRegistry.GetKeyNames(KeyNames);
      KeyNames.Sort;
      i := 0;
      while True do begin
        if not IsValidKeyValue(KeyNames[i], 'Server') then
          KeyNames.Delete(i)
        else
          Inc(i);
        if i = KeyNames.Count then
          break;
      end;
      for i := KeyNames.Count - 1 downto 0 do
        FRegistry.MoveKey(KeyNames[i], Format('Server %d', [i + 1]), True);
    finally
      Values.Free;
      ValueNames.Free;
      KeyNames.Free;
      FRegistry.CloseKey;
      FRegistry.OpenKey(ConnectKey, False);
    end;
  end;
end;
{$ENDIF}

procedure TIBCConnectionEditorForm.GetServerList(List: _TStrings);
{$IFDEF MSWINDOWS}
var
  i: integer;
  ServerName: string;
  KeyNames: TStringList;
  ConnectKey: string;
{$ENDIF}
begin
  List.Clear;
  SetLength(FProtocols, 0);
{$IFDEF MSWINDOWS}
  if (FRegistry <> nil) then begin
    KeyNames := TStringList.Create;
  {$IFNDEF FPC}
    ConnectKey := FRegistry.CurrentPath;
  {$ELSE}
    ConnectKey := IbDacKey;
  {$ENDIF}
    try
      FRegistry.GetKeyNames(KeyNames);
      KeyNames.Sort;
      for i := 0 to KeyNames.Count - 1 do
        if IsValidKeyValue(KeyNames[i], 'Server') then begin
          FRegistry.CloseKey;
          FRegistry.OpenKey(ConnectKey + '\' + KeyNames[i], False);
          if FRegistry.ValueExists('Server') and (FRegistry.GetDataType('Server') = rdString) then begin
            ServerName := Trim(FRegistry.ReadString('Server'));
            if (ServerName <> '') and (List.IndexOf(ServerName) = -1) then
              List.Add(ServerName);
            if FRegistry.ValueExists('Protocol') and (FRegistry.GetDataType('Protocol') = rdInteger) then begin
              SetLength(FProtocols, Length(FProtocols) + 1);
              FProtocols[Length(FProtocols) - 1] := FRegistry.ReadInteger('Protocol');
            end;
          end;
        end;
    finally
      KeyNames.Free;
      FRegistry.CloseKey;
      FRegistry.OpenKey(ConnectKey, False);
    end;
  end;
{$ENDIF}
end;

procedure TIBCConnectionEditorForm.GetDatabaseList(List: TStrings);
{$IFDEF MSWINDOWS}
var
  i, j: Integer;
  Server, s: string;
  KeyNames: TStringList;
  ValueNames: TStringList;
  ConnectKey: string;
{$ENDIF}
begin
  List.Clear;
{$IFDEF MSWINDOWS}
{$IFNDEF STD}
  if FService <> nil then
    Server := FService.Server
  else
{$ENDIF}
    Server := Connection.Server;
  Server := AnsiUpperCase(Server);
  if (FRegistry <> nil) then begin
    KeyNames := TStringList.Create;
    ValueNames := TStringList.Create;
  {$IFNDEF FPC}
    ConnectKey := FRegistry.CurrentPath;
  {$ELSE}
    ConnectKey := IbDacKey;
  {$ENDIF}
    try
      FRegistry.GetKeyNames(KeyNames);
      KeyNames.Sort;
      for i := 0 to KeyNames.Count - 1 do begin
        FRegistry.CloseKey;
        FRegistry.OpenKey(ConnectKey + '\' + KeyNames[i], False);

        if AnsiUpperCase(FRegistry.ReadString('Server')) = Server then begin
          FRegistry.GetValueNames(ValueNames);
          ValueNames.Sort;
          for j := 0 to ValueNames.Count - 1 do
            if IsValidKeyValue(ValueNames[j], 'Database') and
              (FRegistry.GetDataType(ValueNames[j]) = rdString) then begin
              s := Trim(FRegistry.ReadString(ValueNames[j]));
              if (s <> '') and (List.IndexOf(s) = -1) then
                List.Add(s);
            end;
        end;
      end;
    finally
      KeyNames.Free;
      ValueNames.Free;
      FRegistry.CloseKey;
      FRegistry.OpenKey(ConnectKey, False);
      List.Add('<Browse...>');
    end;
  end;
{$ENDIF}
end;

procedure TIBCConnectionEditorForm.edServerChange(Sender: TObject);
var
  i: Integer;
begin
  inherited;

  try
    if edServer.Text = '' then
      edProtocol.ItemIndex := 0
    else begin
      i := edServer.Items.IndexOf(edServer.Text);
      if i <> -1 then
        edProtocol.ItemIndex := FProtocols[i];
    end;
  finally
    ShowState;
  end;
end;

function TIBCConnectionEditorForm.IsValidKeyValue(Value: string; Name: string): boolean;
var
  p: Integer;
begin
  p := Pos(AnsiUpperCase(Name), AnsiUpperCase(Value));
  if p <> 0 then begin
    Inc(p, Length(Name) - 1);
    if p < Length(Value) then
      Inc(p);
    while (Byte(Value[p]) in [$30..$30+9, $20]) and (p <> Length(Value)) do
      Inc(p);
    Result := p = Length(Value);
  end
  else
    Result := False;
end;

procedure TIBCConnectionEditorForm.edCharsetDropDown(Sender: TObject);
begin
{$IFDEF UNIX}
  edCharset.OnGetItems := nil;
  try
{$ENDIF}
  GetCharsetList(GetConnection, edCharset.Items);
{$IFDEF UNIX}
  finally
    edCharset.OnGetItems := edCharsetDropDown;
  end;
{$ENDIF}
end;

initialization
  KnownCharsetList := TStringList.Create;
  KnownCharsetList.Duplicates := dupIgnore;
  KnownCharsetList.Text :=
    'NONE'#$d +
    'ASCII'#$d +
    'BIG_5'#$d +
    'CYRL'#$d +
    'DOS437'#$d +
    'DOS737'#$d +
    'DOS775'#$d +
    'DOS850'#$d +
    'DOS852'#$d +
    'DOS857'#$d +
    'DOS858'#$d +
    'DOS860'#$d +
    'DOS861'#$d +
    'DOS862'#$d +
    'DOS863'#$d +
    'DOS864'#$d +
    'DOS865'#$d +
    'DOS866'#$d +
    'DOS869'#$d +
    'EUCJ_0208'#$d +
    'GB_2312'#$d +
    'ISO8859_1'#$d +
    'ISO8859_13'#$d +
    'ISO8859_15'#$d +
    'ISO8859_2'#$d +
    'ISO8859_3'#$d +
    'ISO8859_4'#$d +
    'ISO8859_5'#$d +
    'ISO8859_6'#$d +
    'ISO8859_7'#$d +
    'ISO8859_8'#$d +
    'ISO8859_9'#$d +
    'KOI8R'#$d +
    'KOI8U'#$d +
    'KSC_5601'#$d +
    'NEXT'#$d +
    'OCTETS'#$d +
    'SJIS_0208'#$d +
    'UNICODE_FSS'#$d +
    'UTF8'#$d +
    'WIN1250'#$d +
    'WIN1251'#$d +
    'WIN1252'#$d +
    'WIN1253'#$d +
    'WIN1254'#$d +
    'WIN1255'#$d +
    'WIN1256'#$d +
    'WIN1257'#$d +
    'WIN1258'#$d;

finalization
  KnownCharsetList.Free;
end.
