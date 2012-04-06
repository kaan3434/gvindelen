unit ServerForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, StdCtrls, ToolWin, ComCtrls, ExtCtrls, DBCtrls, Db;

type
  TfmServer = class(TForm)
    ToolBar: TToolBar;
    meSQL: TMemo;
    DBGrid: TDBGrid;
    btConnect: TButton;
    btDisconnect: TButton;
    btOpen: TButton;
    btClose: TButton;
    ToolBar1: TToolBar;
    DBNavigator: TDBNavigator;
    cbDebug: TCheckBox;
    ToolButton2: TToolButton;
    DataSource: TDataSource;
    StatusBar: TStatusBar;
    rbDSResolve: TRadioButton;
    rbSQLResolve: TRadioButton;
    procedure btConnectClick(Sender: TObject);
    procedure btDisconnectClick(Sender: TObject);
    procedure btOpenClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure cbDebugClick(Sender: TObject);
    procedure meSQLExit(Sender: TObject);
    procedure rbDSResolveClick(Sender: TObject);
    procedure rbSQLResolveClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmServer: TfmServer;

implementation
uses
  Data;

{$R *.DFM}

procedure TfmServer.btConnectClick(Sender: TObject);
begin
  if Assigned(Datas) then
    Datas.IBCConnection.Connect;
end;

procedure TfmServer.btDisconnectClick(Sender: TObject);
begin
  if Assigned(Datas) then
    Datas.IBCConnection.Disconnect;
end;

procedure TfmServer.btOpenClick(Sender: TObject);
begin
  if Assigned(Datas) then
    Datas.Query.Open;
end;

procedure TfmServer.btCloseClick(Sender: TObject);
begin
  if Assigned(Datas) then
    Datas.Query.Close;
end;

procedure TfmServer.cbDebugClick(Sender: TObject);
begin
  if Assigned(Datas) then
    Datas.Query.Debug:= cbDebug.Checked;
end;

procedure TfmServer.meSQLExit(Sender: TObject);
begin
  if Assigned(Datas) then
    if meSQL.Lines.Text <> Datas.Query.SQL.Text then
      Datas.Query.SQL.Assign(meSQL.Lines);
end;

procedure TfmServer.rbDSResolveClick(Sender: TObject);
begin
  if Assigned(Datas) then
    Datas.DataSetProvider.ResolveToDataset:= rbDSResolve.Checked;
end;

procedure TfmServer.rbSQLResolveClick(Sender: TObject);
begin
  if Assigned(Datas) then
    Datas.DataSetProvider.ResolveToDataset:= not rbSQLResolve.Checked;
end;

procedure TfmServer.FormDestroy(Sender: TObject);
begin
  fmServer := nil;
end;

end.
