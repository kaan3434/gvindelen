
//////////////////////////////////////////////////
//  InterBase Data Access Components
//  Copyright © 2006-2011 Devart. All right reserved.
//  Connect Form
//////////////////////////////////////////////////

{$DEFINE FMX}

unit IBCConnectFormFmx;

interface

uses
  Classes, SysUtils, TypInfo,
{$IFDEF MSWINDOWS}
  Winapi.Windows, System.Win.Registry,
{$ENDIF}
  System.UITypes, FMX.Types, FMX.Platform,
  FMX.Forms, FMX.Controls, FMX.Edit, FMX.ListBox, FMX.Memo,
  CRTypes, MemUtils, DBAccess, IBCCall, IBC, IBCClasses;

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
    edServer: TEdit;
    lbDatabase: TLabel;
    edDatabase: TEdit;
    edProtocol: TComboBox;
    lbProtocol: TLabel;
    procedure btConnectClick(Sender: TObject);
    procedure edExit(Sender: TObject);
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

{$R *.fmx}

uses
  CRFunctions, DacFMX, IbDacFMX;

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
    lbUsername.Text := UsernameLabel;
    lbPassword.Text := PasswordLabel;
    lbServer.Text := ServerLabel;

    if FConnectDialog is TIBCConnectDialogFmx then begin
      lbProtocol.Text := TIBCConnectDialogFmx(FConnectDialog).ProtocolLabel;
      lbDatabase.Text := TIBCConnectDialogFmx(FConnectDialog).DatabaseLabel;
    end;

    btConnect.Text := ConnectButton;
    btCancel.Text := CancelButton;

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

procedure TIBCConnectForm.edExit(Sender: TObject);
begin
  try
    FConnectDialog.Connection.Password := edPassword.Text;
    FConnectDialog.Connection.Server := edServer.Text;
    FConnectDialog.Connection.UserName := edUsername.Text;
    TIBCConnection(FConnectDialog.Connection).Database := edDatabase.Text;
    TIBCConnection(FConnectDialog.Connection).Options.Protocol := TIBCProtocol(edProtocol.ItemIndex);
  except
    ActiveControl := Sender as TStyledControl;
    raise;
  end;
end;

initialization
  if GetClass('TIBCConnectForm') = nil then
    Classes.RegisterClass(TIBCConnectForm);
end.

