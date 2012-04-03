unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IB_Services, ExtCtrls;

type
  TFormMain = class(TForm)
    Panel1: TPanel;
    BExit: TButton;
    BBackup: TButton;
    BRestore: TButton;
    BackupService1: TpFIBBackupService;
    RestoreService1: TpFIBRestoreService;
    Memo1: TMemo;
    OpenDialogBackup: TOpenDialog;
    OpenDialogDatabase: TOpenDialog;
    procedure BExitClick(Sender: TObject);
    procedure BBackupClick(Sender: TObject);
    procedure BRestoreClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.DFM}

procedure TFormMain.BExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFormMain.BBackupClick(Sender: TObject);
var i: Integer;
begin
//  OpenDialogBackup.Options.Clear;
  OpenDialogBackup.Options := [ofAllowMultiSelect];
//  OpenDialogDatabase.Options.Clear;
  OpenDialogDatabase.Options := [ofFileMustExist];
  if not (OpenDialogDatabase.Execute) then exit;
  if not (OpenDialogBackup.Execute) then exit;
  BackupService1.DatabaseName := OpenDialogDatabase.FileName;
  BackupService1.BackupFile.Clear;
  Memo1.Clear;
  Memo1.Lines.Add('*** Database file: ***');
  Memo1.Lines.Add(BackupService1.DatabaseName);
  Memo1.Lines.Add('*** Backup file(s): ***');
  for i := 0 to OpenDialogBackup.Files.Count - 1 do
  begin
    BackupService1.BackupFile.Add(OpenDialogBackup.Files.Strings[i]);
    Memo1.Lines.Add(OpenDialogBackup.Files.Strings[i]);
  end;
  Memo1.Lines.Add(
    '==================== Backup started ====================');
  BackupService1.Active := True;
  BExit.Enabled := False;
  BBackup.Enabled := False;
  BRestore.Enabled := False;
  BackupService1.ServiceStart;
  while not (BackupService1.Eof) do
    Memo1.Lines.Add(BackupService1.GetNextLine);
  BackupService1.Active := False;
  BExit.Enabled := True;
  BBackup.Enabled := True;
  BRestore.Enabled := True;
  Memo1.Lines.Add(
    '==================== Backup ended ====================');
end;

procedure TFormMain.BRestoreClick(Sender: TObject);
var i: Integer;
begin
//  OpenDialogBackup.Options.Clear();
  OpenDialogBackup.Options := [ofAllowMultiSelect, ofFileMustExist];
//  OpenDialogDatabase.Options.Clear();
  OpenDialogDatabase.Options := [ofAllowMultiSelect];
  if not (OpenDialogDatabase.Execute) then exit;
  if not (OpenDialogBackup.Execute) then exit;
  RestoreService1.DatabaseName.Clear;
  RestoreService1.BackupFile.Clear;
  Memo1.Clear;
  Memo1.Lines.Add('*** Database file(s): ***');
  for i := 0 to OpenDialogDatabase.Files.Count - 1 do
  begin
    RestoreService1.DatabaseName.Add(OpenDialogDatabase.Files.Strings[i]);
    Memo1.Lines.Add(OpenDialogDatabase.Files.Strings[i]);
  end;
  Memo1.Lines.Add('*** Backup file(s): ***');
  for i := 0 to OpenDialogBackup.Files.Count - 1 do
  begin
    RestoreService1.BackupFile.Add(OpenDialogBackup.Files.Strings[i]);
    Memo1.Lines.Add(OpenDialogBackup.Files.Strings[i]);
  end;
  Memo1.Lines.Add(
    '==================== Restore started ====================');
  RestoreService1.Active := True;
  BExit.Enabled := False;
  BBackup.Enabled := False;
  BRestore.Enabled := False;
  RestoreService1.ServiceStart;
  while not (RestoreService1.Eof) do
    Memo1.Lines.Add(RestoreService1.GetNextLine);
  RestoreService1.Active := False;
  BExit.Enabled := True;
  BBackup.Enabled := True;
  BRestore.Enabled := True;
  Memo1.Lines.Add(
    '==================== Restore ended ====================');
end;

end.
