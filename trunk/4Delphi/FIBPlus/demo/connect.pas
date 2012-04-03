unit connect;

interface

uses
  common,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, jpeg;

type
  TfrmConnect = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    Bevel1: TBevel;
    Label1: TLabel;
    edtDBName: TEdit;
    Label2: TLabel;
    edtUserName: TEdit;
    Label3: TLabel;
    edtPassword: TEdit;
    edtRoleName: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure GetIniConnectParams; //Считывание параметров коннекта из ини-файла
    procedure SetIniConnectParams; //Запись параметров коннекта в ини-файл
  public
    { Public declarations }
  end;

  procedure SetConnectParams(var UserParams: TStrings; ShowInputRole: Boolean);

//var
//  frmConnect: TfrmConnect;

implementation

{$R *.DFM}

procedure TfrmConnect.GetIniConnectParams;
var
  IniFile, Section: string;
begin
  IniFile := GetExePath + INI_FILE_NAME;
  Section := 'CONNECT_PARAMS';
  edtDBName.Text   := ReadString_Ini(IniFile, Section, 'DB_NAME',   '');
  edtUserName.Text := ReadString_Ini(IniFile, Section, 'USER_NAME', '');
  edtRoleName.Text := ReadString_Ini(IniFile, Section, 'ROLE_NAME', '');
end;

procedure TfrmConnect.SetIniConnectParams;
var
  IniFile, Section: string;
begin
  IniFile := GetExePath + INI_FILE_NAME;
  Section := 'CONNECT_PARAMS';
  WriteString_Ini(IniFile, Section, 'DB_NAME',   edtDBName.Text);
  WriteString_Ini(IniFile, Section, 'USER_NAME', edtUserName.Text);
  WriteString_Ini(IniFile, Section, 'ROLE_NAME', edtRoleName.Text);
end;

procedure TfrmConnect.FormShow(Sender: TObject);
begin
  GetIniConnectParams;

  if Length(edtDBName.Text) = 0 then
    ActiveControl := edtDBName
  else
    if Length(edtUserName.Text) = 0 then
      ActiveControl := edtUserName
    else
      if Length(edtPassword.Text) = 0 then
        ActiveControl := edtPassword;
end;

procedure TfrmConnect.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = mrOk then SetIniConnectParams;
end;

procedure SetConnectParams(var UserParams: TStrings; ShowInputRole: Boolean);
var
  frmConnect: TfrmConnect;
begin
  frmConnect := nil;
  try
    frmConnect := TfrmConnect.Create(Application);
    with frmConnect do
    begin
      Label4.Visible := ShowInputRole;
      edtRoleName.Visible := ShowInputRole;
      if ShowModal = mrOk then
      begin
        UserParams.Add(edtDBName.Text);
        UserParams.Add(Format('USER_NAME=%s', [edtUserName.Text]));
        UserParams.Add(Format('PASSWORD=%s', [edtPassword.Text]));
        if Length(edtRoleName.Text) <> 0 then UserParams.Add(Format('ROLE=%s', [edtRoleName.Text]));
        UserParams.Add(Format('LC_CTYPE=%s', ['WIN1251']));
        UserParams.Add('no_garbage_collect');
      end
      else
        UserParams := nil;
    end;
  finally
    frmConnect.Free;
  end;
end;

end.
