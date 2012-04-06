{$I DacDemo.inc}

unit MyConnectForm;

interface

uses
  Classes, SysUtils,
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  Menus, ImgList, StdCtrls, ComCtrls, Buttons, ExtCtrls, Graphics,
  Controls, Forms, Dialogs, DBCtrls, Grids, DBGrids, IbDacVcl,
{$IFNDEF FPC}
  Mask,
{$ENDIF}
{$IFNDEF VER130}
  Variants,
{$ENDIF}
{$IFDEF FPC}
  LResources,
{$ENDIF}
  DB, MemUtils, DBAccess, IBC, DemoFrame, IBCError, IBCConnectForm, TypInfo,
  CRTypes, CRFunctions;

type
  TfmMyConnect = class(TForm)
    Panel: TPanel;
    lbUsername: TLabel;
    lbPassword: TLabel;
    lbServer: TLabel;
    edUsername: TEdit;
  {$IFNDEF FPC}
    edPassword: TMaskEdit;
  {$ELSE}
    edPassword: TEdit;
  {$ENDIF}
    edServer: TComboBox;
    btConnect: TBitBtn;
    btCancel: TBitBtn;
    Bevel1: TBevel;
    lbDatabase: TLabel;
    lbProtocol: TLabel;
    edProtocol: TComboBox;
    edDatabase: TComboBox;
    procedure btConnectClick(Sender: TObject);
  private
    FConnectDialog: TIBCConnectDialog; ////!!!!!
    FRetries: integer;
    FRetry: boolean;

    procedure SetConnectDialog(Value:TIBCConnectDialog);

  protected
    procedure DoInit; virtual;
    procedure DoConnect; virtual;

  public

  published
    property ConnectDialog: TIBCConnectDialog read FConnectDialog write SetConnectDialog;

  end;

var
  fmMyConnect: TfmMyConnect;

implementation

{$IFNDEF FPC}
{$IFDEF CLR}
{$R *.nfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}
{$ENDIF}

procedure TfmMyConnect.DoInit;
var
  i: integer;
  List: _TStringList;
begin
  FRetry := False;
  FRetries := FConnectDialog.Retries;
  Caption := FConnectDialog.Caption;
  lbUsername.Caption := 'User name';
  lbPassword.Caption := 'Password';
  lbServer.Caption := 'Server name';
  lbProtocol.Caption := 'Protocol';
  lbDatabase.Caption := 'Database';
  btConnect.Caption := 'Connect';
  btCancel.Caption := 'Cancel';

  List := _TStringList.Create;
  try
    GetIBCServerList(List);
    AssignStrings(List, edServer.Items);
  finally
    List.Free;
  end;
  edServer.Text := FConnectDialog.Connection.Server;
  for i := Integer(Low(TIBCProtocol)) to Integer(High(TIBCProtocol)) do
    edProtocol.Items.Add(TypInfo.GetEnumName(TypeInfo(TIBCProtocol), i));
  GetIBCDatabaseList(edServer.Text, edDatabase.Items);

  edUsername.Text := FConnectDialog.Connection.Username;
  edPassword.Text := FConnectDialog.Connection.Password;
  edDatabase.Text := TIBCConnection(FConnectDialog.Connection).Database;
  edProtocol.ItemIndex := Integer(TIBCConnection(FConnectDialog.Connection).Options.Protocol);

  if (edUsername.Text <> '') and (edPassword.Text = '') then
    ActiveControl := edPassword;


  if (edUsername.Text <> '') and (edPassword.Text = '') then
    ActiveControl := edPassword;
end;

procedure TfmMyConnect.DoConnect;
begin
  FConnectDialog.Connection.UserName := edUsername.Text;
  FConnectDialog.Connection.Password := edPassword.Text;
  FConnectDialog.Connection.Server := edServer.Text;
  FConnectDialog.Connection.Options.Protocol := TIBCProtocol(edProtocol.ItemIndex);
  FConnectDialog.Connection.Database := edDatabase.Text;
  try
    FConnectDialog.Connection.PerformConnect(FRetry);
    ModalResult := mrOk;
  except
    on E:EIBCError do begin
      Dec(FRetries);
      FRetry := True;

      if FRetries = 0 then
        ModalResult := mrCancel;
    raise;
    end
    else
      raise;
  end;
end;

procedure TfmMyConnect.SetConnectDialog(Value:TIBCConnectDialog);
begin
  FConnectDialog := Value;
  DoInit;
end;

procedure TfmMyConnect.btConnectClick(Sender: TObject);
begin
  DoConnect;
end;

initialization
{$IFDEF FPC}
  {$i MyConnectForm.lrs}
{$ENDIF}

  if GetClass('TfmMyConnect') = nil then
    Classes.RegisterClass(TfmMyConnect);
end.
