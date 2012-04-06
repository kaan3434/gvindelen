unit ClientForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, ToolWin, ComCtrls, Db, DBClient, ExtCtrls, DBCtrls,
  StdCtrls, MConnect, MidasCon;

type
  TfmClient = class(TForm)
    ToolBar: TToolBar;
    DBGrid: TDBGrid;
    brConnect: TButton;
    btDisconnect: TButton;
    btOpen: TButton;
    btClose: TButton;
    btApplyUpd: TButton;
    btCancelUpd: TButton;
    ToolBar1: TToolBar;
    DBNavigator1: TDBNavigator;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    RemoteServer: TRemoteServer;
    StatusBar: TStatusBar;
    DeptNo: TLabel;
    edDeptNo: TEdit;
    procedure brConnectClick(Sender: TObject);
    procedure RemoteServerAfterConnect(Sender: TObject);
    procedure RemoteServerAfterDisconnect(Sender: TObject);
    procedure btOpenClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure btApplyUpdClick(Sender: TObject);
    procedure btCancelUpdClick(Sender: TObject);
    procedure btDisconnectClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmClient: TfmClient;

implementation

{$R *.DFM}

procedure TfmClient.brConnectClick(Sender: TObject);
begin
  RemoteServer.Connected:= True;
end;

procedure TfmClient.btDisconnectClick(Sender: TObject);
begin
  RemoteServer.Connected:= False;
end;

procedure TfmClient.RemoteServerAfterConnect(Sender: TObject);
begin
  StatusBar.Panels[0].Text:= 'Connected';
end;

procedure TfmClient.RemoteServerAfterDisconnect(Sender: TObject);
begin
  if Assigned(StatusBar) then
    StatusBar.Panels[0].Text:= 'Disconnected';
end;

procedure TfmClient.btOpenClick(Sender: TObject);
begin
  if edDeptNo.Text <> '' then
    ClientDataSet.Params.ParamByName('DeptNo').AsInteger:= StrToInt(edDeptNo.Text);
  ClientDataSet.Open;
  edDeptNo.Text:= IntToStr(ClientDataSet.Params.ParamByName('DeptNo').AsInteger);
end;

procedure TfmClient.btCloseClick(Sender: TObject);
begin
  ClientDataSet.Close;
end;

procedure TfmClient.btApplyUpdClick(Sender: TObject);
begin
  ClientDataSet.ApplyUpdates(0);
end;

procedure TfmClient.btCancelUpdClick(Sender: TObject);
begin
  ClientDataSet.CancelUpdates;
end;

end.
