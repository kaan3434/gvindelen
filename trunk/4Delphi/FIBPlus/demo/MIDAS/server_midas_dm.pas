unit server_midas_dm;

interface

uses
  Windows, Messages, SysUtils, Classes, ComServ, ComObj, VCLCom, DataBkr,
  DBClient, server_midas_TLB, StdVcl, FIBDatabase, pFIBDatabase, Provider,
  Db, FIBDataSet, pFIBDataSet, FIBQuery, pFIBQuery;

type
  TFIBPlusDemoServer = class(TRemoteDataModule, IFIBPlusDemoServer)
    dbMidas: TpFIBDatabase;
    dspMidas: TDataSetProvider;
    trRead: TpFIBTransaction;
    trWrite: TpFIBTransaction;
    dtMidas: TpFIBDataSet;
    dtMidasID: TFIBIntegerField;
    dtMidasNAME: TFIBStringField;
    dtMidasCAPITAL: TFIBStringField;
    dtMidasCONTINENT: TFIBStringField;
    dtMidasAREA: TFIBFloatField;
    dtMidasPOPULATION: TFIBFloatField;
    procedure dtMidasAfterOpen(DataSet: TDataSet);
    procedure dtMidasAfterClose(DataSet: TDataSet);
    procedure dtMidasAfterFetchRecord(FromQuery: TFIBQuery;
      RecordNumber: Integer; var StopFetching: Boolean);
  private
    { Private declarations }
  protected
    class procedure UpdateRegistry(Register: Boolean; const ClassID, ProgID: string); override;
  public
    { Public declarations }
  end;

implementation

uses server_midas_main;

{$R *.DFM}

class procedure TFIBPlusDemoServer.UpdateRegistry(Register: Boolean; const ClassID, ProgID: string);
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

procedure TFIBPlusDemoServer.dtMidasAfterOpen(DataSet: TDataSet);
begin
  Form1.Memo1.Lines.Add('DataSet Opened');
end;

procedure TFIBPlusDemoServer.dtMidasAfterClose(DataSet: TDataSet);
begin
  Form1.Memo1.Lines.Add('DataSet Closed');
end;

procedure TFIBPlusDemoServer.dtMidasAfterFetchRecord(FromQuery: TFIBQuery;
  RecordNumber: Integer; var StopFetching: Boolean);
begin
  Form1.Memo1.Lines.Add('DataSet Fetched');
end;

initialization
  TComponentFactory.Create(ComServer, TFIBPlusDemoServer,
    Class_FIBPlusDemoServer, ciMultiInstance, tmApartment);
end.
