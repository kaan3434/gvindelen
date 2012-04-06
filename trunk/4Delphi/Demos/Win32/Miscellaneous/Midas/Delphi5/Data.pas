unit Data;

interface

uses
  Windows, Messages, SysUtils, Classes, ComServ, ComObj, VCLCom, DataBkr,
  DBClient, Server_TLB, StdVcl, Db, MemDS, IBC, Provider,
  DBTables, DBAccess, IbDacVcl;

type
  TDatas = class(TRemoteDataModule, IDatas)
    IBCConnection: TIBCConnection;
    Query: TIBCQuery;
    DataSetProvider: TDataSetProvider;
    ConnectDialog: TIBCConnectDialog;
    procedure DatasCreate(Sender: TObject);
    procedure DatasDestroy(Sender: TObject);
    procedure IBCConnectionAfterConnect(Sender: TObject);
    procedure IBCConnectionAfterDisconnect(Sender: TObject);
  private
    procedure ShowCountConnection;
  protected
    class procedure UpdateRegistry(Register: Boolean; const ClassID, ProgID: string); override;
  end;

var
  Datas:TDatas;

implementation
uses ServerForm;
var
  CountConnection:integer;

{$R *.DFM}

class procedure TDatas.UpdateRegistry(Register: Boolean; const ClassID, ProgID: string);
begin
  if Register then
  begin
    inherited UpdateRegistry(Register, ClassID, ProgID);
    EnableSocketTransport(ClassID);
    EnableWebTransport(ClassID);
  end else
  begin
    DisableSocketTransport(ClassID);
    DisableWebTransport(ClassID);
    inherited UpdateRegistry(Register, ClassID, ProgID);
  end;
end;

procedure TDatas.DatasCreate(Sender: TObject);
var
  St:string;
begin
  if not Assigned(Datas) then begin
    Datas := TDatas(Sender);
    St := Query.SQL.Text;

    fmServer.meSQL.Lines.Text := St;
    fmServer.cbDebug.Checked := Query.Debug;
    fmServer.DataSource.DataSet := Query;
    fmServer.rbDSResolve.Checked := DataSetProvider.ResolveToDataset;
    fmServer.rbSQLResolve.Checked := not DataSetProvider.ResolveToDataset;
  end;

  Inc(CountConnection);
  fmServer.StatusBar.Panels[0].Text := 'Count connections ' + IntToStr(CountConnection);
end;

procedure TDatas.DatasDestroy(Sender: TObject);
begin
  if Datas = TDatas(Sender) then begin
    if assigned(fmServer) then
      fmServer.DataSource.DataSet := nil;
    Datas := nil;
  end;

  Dec(CountConnection);
  if assigned(fmServer) then
    fmServer.StatusBar.Panels[0].Text := 'Count connections ' + IntToStr(CountConnection);
end;

procedure TDatas.ShowCountConnection;
begin
  if Assigned(fmServer) then
    fmServer.StatusBar.Panels[0].Text := 'Count connections ' + IntToStr(CountConnection);
end;

procedure TDatas.IBCConnectionAfterConnect(Sender: TObject);
begin
  Inc(CountConnection);
  ShowCountConnection;
end;

procedure TDatas.IBCConnectionAfterDisconnect(Sender: TObject);
begin
  Dec(CountConnection);
  ShowCountConnection;
end;

initialization
  TComponentFactory.Create(ComServer, TDatas,
    Class_Datas, ciMultiInstance{, tmApartment});
end.
