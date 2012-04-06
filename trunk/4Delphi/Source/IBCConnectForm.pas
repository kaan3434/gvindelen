
//////////////////////////////////////////////////
//  InterBase Data Access Components
//  Copyright © 2006-2011 Devart. All right reserved.
//  Connect Form
//////////////////////////////////////////////////

{$IFNDEF CLR}

unit IBCConnectForm;
{$ENDIF}

interface

{$IFDEF WIN32}
  {$DEFINE MSWINDOWS}
  {$DEFINE WIN32_64}
{$ENDIF}
{$IFDEF WIN64}
  {$DEFINE MSWINDOWS}
  {$DEFINE WIN32_64}
{$ENDIF}
{$IFDEF CLR}
  {$DEFINE MSWINDOWS}
{$ENDIF}

uses
  SysUtils, Classes,
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF}
  Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls,
{$IFDEF FPC}
  LResources, LCLType,
{$ENDIF}
  CRTypes, CRFunctions, DBAccess, IBCCall, IBC, TypInfo, IBCClasses;

type
  TIBCConnectForm = class(TForm)
    Panel: TPanel;
    lbUsername: TLabel;
    lbPassword: TLabel;
    lbServer: TLabel;
    edUsername: TEdit;
    btConnect: TButton;
    btCancel: TButton;
    edPassword: TEdit;
    edServer: TComboBox;
    lbProtocol: TLabel;
    lbDatabase: TLabel;
    edDatabase: TComboBox;
    edProtocol: TComboBox;
    procedure btConnectClick(Sender: TObject);
    procedure edServerDropDown(Sender: TObject);
    procedure edDatabaseDropDown(Sender: TObject);
    procedure edExit(Sender: TObject);
    procedure edServerChange(Sender: TObject);
    procedure edServerKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);

  private
    FConnectDialog: TCustomConnectDialog;
    FRetries: integer;
    FOldCreateOrder: boolean;
    FRetry: boolean;
    FDatabasesGot, FServersGot: boolean;
    procedure SetConnectDialog(Value: TCustomConnectDialog);

  protected
    procedure DoInit; virtual;
    procedure DoConnect; virtual;

  public

  published
    property ConnectDialog: TCustomConnectDialog read FConnectDialog write SetConnectDialog;

    property OldCreateOrder: boolean read FOldCreateOrder write FOldCreateOrder;
  end;

implementation

{$IFNDEF FPC}
{$R IBCConnectForm.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF}

uses
  IbDacVcl;

procedure TIBCConnectForm.DoInit;
var
  i: integer;
begin
  FRetry := False;
  FRetries := FConnectDialog.Retries;
  Caption := FConnectDialog.Caption;
  FDatabasesGot := False;
  FServersGot := False;

  for i := Integer(Low(TIBCProtocol)) to Integer(High(TIBCProtocol)) do
    edProtocol.Items.Add(GetEnumName(TypeInfo(TIBCProtocol), i));

  with FConnectDialog do begin
    lbUsername.Caption := UsernameLabel;
    lbPassword.Caption := PasswordLabel;
    lbServer.Caption := ServerLabel;

    if FConnectDialog is TIBCConnectDialog then begin
      lbProtocol.Caption := TIBCConnectDialog(FConnectDialog).ProtocolLabel;
      lbDatabase.Caption := TIBCConnectDialog(FConnectDialog).DatabaseLabel;
    end;

    btConnect.Caption := ConnectButton;
    btCancel.Caption := CancelButton;

    edUsername.Text := Connection.Username;
    edPassword.Text := Connection.Password;
    edProtocol.ItemIndex := Integer(TIBCConnection(Connection).Options.Protocol);
    edServer.Text := Connection.Server;
    edDatabase.Text := TIBCConnection(Connection).Database;

    if (edUsername.Text <> '') and (edPassword.Text = '') then
      ActiveControl := edPassword;
  end;
end;

procedure TIBCConnectForm.DoConnect;
begin
  try
    edExit(nil);
    if TDBAccessUtils.GetNeedConnect(FConnectDialog) then
      FConnectDialog.Connection.PerformConnect(FRetry);
    ModalResult := mrOk;
  except
    on E: EDAError do begin
      Dec(FRetries);
      FRetry := True;
      if FRetries = 0 then
        ModalResult:= mrCancel;
      ActiveControl := edServer;
      raise;
    end
    else
      raise;
  end;
end;

procedure TIBCConnectForm.SetConnectDialog(Value: TCustomConnectDialog);
begin
  FConnectDialog := Value;
  DoInit;
end;

procedure TIBCConnectForm.btConnectClick(Sender: TObject);
begin
  DoConnect;
end;

procedure TIBCConnectForm.edServerDropDown(Sender: TObject);
var
  OldCursor: TCursor;
  List: _TStringList;
begin
  if FServersGot then
    Exit;

  FServersGot := True;
  OldCursor := Screen.Cursor;
  Screen.Cursor := crSQLWait;
  List := _TStringList.Create;
  try
    FConnectDialog.GetServerList(List);
    AssignStrings(List, edServer.Items);
  finally
    List.Free;
    Screen.Cursor := OldCursor;
  end;
end;

procedure TIBCConnectForm.edServerChange(Sender: TObject);
var
  ProtoIndex: integer;
begin
  FDatabasesGot := False;
  ProtoIndex := GetIBCProtocol(edServer.Text);
  if ProtoIndex >= 0 then
    edProtocol.ItemIndex := ProtoIndex;
end;

procedure TIBCConnectForm.edDatabaseDropDown(Sender: TObject);
var
  OldCursor: TCursor;
begin
  if FDatabasesGot then
    Exit;

  FDatabasesGot := True;
  edDatabase.Items.Clear;
  OldCursor := Screen.Cursor;
  Screen.Cursor := crSQLWait;
  try
    GetIBCDatabaseList(edServer.Text, edDatabase.Items);
  finally
    Screen.Cursor := OldCursor;
  end;
end;

procedure TIBCConnectForm.edExit(Sender: TObject);
begin
  try
    FConnectDialog.Connection.Password := edPassword.Text;
    FConnectDialog.Connection.Server := edServer.Text;
    FConnectDialog.Connection.UserName := edUsername.Text;
    TIBCConnection(FConnectDialog.Connection).Database := edDatabase.Text;
    TIBCConnection(FConnectDialog.Connection).Options.Protocol := TIBCProtocol(edProtocol.ItemIndex);
  except
    ActiveControl := Sender as TWinControl;
    raise;
  end;
end;

procedure TIBCConnectForm.edServerKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    edServerChange(Sender);
end;

initialization
  if GetClass('TIBCConnectForm') = nil then
    Classes.RegisterClass(TIBCConnectForm);

end.

