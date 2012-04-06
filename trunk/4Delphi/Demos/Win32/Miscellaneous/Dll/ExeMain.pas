unit ExeMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IBC, StdCtrls, ExtCtrls, Grids, DBGrids, Db, MemDS, DBCtrls, DBAccess, IbDacVcl;

type
  TfmExeMain = class(TForm)
    IBCConnection: TIBCConnection;
    ConnectDialog: TIBCConnectDialog;
    pnToolBar: TPanel;
    btLoadDLL: TButton;
    btFreeDLL: TButton;
    DBGrid: TDBGrid;
    btConnect: TButton;
    btDisconnect: TButton;
    btOpen: TButton;
    btClose: TButton;
    IBCQuery: TIBCQuery;
    DBNavigator: TDBNavigator;
    DataSource: TDataSource;
    btShowForm: TButton;
    btHideForms: TButton;
    procedure btLoadDLLClick(Sender: TObject);
    procedure btFreeDLLClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btConnectClick(Sender: TObject);
    procedure btDisconnectClick(Sender: TObject);
    procedure btOpenClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btShowFormClick(Sender: TObject);
    procedure btHideFormsClick(Sender: TObject);
  private
    hDLL:HModule;

  public

  end;

  TAssignConnection = procedure (Connection: TIBCConnection); cdecl;
  TShowForm = procedure; cdecl;
  THideForms = procedure; cdecl;

var
  fmExeMain: TfmExeMain;

implementation

{$R *.DFM}

procedure TfmExeMain.btLoadDLLClick(Sender: TObject);
var
  AssignConnection: TAssignConnection;
begin
  if hDLL = 0 then begin
    hDLL := LoadLibrary('IBCDLL.dll');
    if hDLL <> 0 then begin
      @AssignConnection := GetProcAddress(hDLL, 'AssignConnection');
      if @AssignConnection <> nil then
        AssignConnection(IBCConnection);
      MessageDlg('DLL is loaded', mtInformation, [mbOk], 0);
    end
    else
      MessageDlg('Cannot load DLL', mtError, [mbOk], 0);
  end;
end;

procedure TfmExeMain.btShowFormClick(Sender: TObject);
var
  ShowForm: TShowForm;
begin
  if hDLL <> 0 then begin
    @ShowForm := GetProcAddress(hDLL, 'ShowForm');
    if @ShowForm <> nil then
      ShowForm;
    SetFocus;
  end
  else
    MessageDlg('DLL is not loaded', mtError, [mbOk], 0);
end;

procedure TfmExeMain.btHideFormsClick(Sender: TObject);
var
  HideForms: THideForms;
begin
  if hDLL <> 0 then begin
    @HideForms := GetProcAddress(hDLL, 'HideForms');
    if @HideForms <> nil then
      HideForms;
  end
  else
    MessageDlg('DLL is not loaded', mtError, [mbOk], 0);
end;

procedure TfmExeMain.btFreeDLLClick(Sender: TObject);
begin
  if hDLL <> 0 then begin
    FreeLibrary(hDLL);
    hDLL := 0;
  end
  else
    MessageDlg('DLL is not loaded', mtError, [mbOk], 0);
end;

procedure TfmExeMain.FormCreate(Sender: TObject);
begin
  hDLL:= 0;
end;

procedure TfmExeMain.btConnectClick(Sender: TObject);
begin
  IBCConnection.Connect;
end;

procedure TfmExeMain.btDisconnectClick(Sender: TObject);
begin
  IBCConnection.Disconnect;
end;

procedure TfmExeMain.btOpenClick(Sender: TObject);
begin
  IBCQuery.Open;
end;

procedure TfmExeMain.btCloseClick(Sender: TObject);
begin
  IBCQuery.Close;
end;

procedure TfmExeMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if hDLL <> 0 then
    FreeLibrary(hDLL);
end;

end.
