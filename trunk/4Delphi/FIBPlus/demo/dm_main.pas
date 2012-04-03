unit dm_main;

interface

uses
  common,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FIBDatabase, pFIBDatabase, ImgList, SIBEABase, SIBFIBEA, pFIBErrorHandler,
  FIBQuery, pFIBQuery, Db, FIBDataSet, pFIBDataSet;

type
  TdmMain = class(TDataModule)
    dbDemo: TpFIBDatabase;
    trRead: TpFIBTransaction;
    trWrite: TpFIBTransaction;
    ImageList1: TImageList;
    eaDemo: TSIBfibEventAlerter;
    erDemo: TpFibErrorHandler;
    trSpeedRead: TpFIBTransaction;
    trSpeedWrite: TpFIBTransaction;
    sqlSpeedRead: TpFIBQuery;
    sqlSpeedWrite: TpFIBQuery;
    dtCustomer: TpFIBDataSet;
    dtOrders: TpFIBDataSet;
    dtItems: TpFIBDataSet;
    dsCustomer: TDataSource;
    dsOrders: TDataSource;
    dsItems: TDataSource;
    dtDemoPack: TpFIBDataSet;
    dsDemoPack: TDataSource;
    dtCustomerID: TFIBIntegerField;
    dtCustomerNAME: TFIBStringField;
    dtCustomerADDRESS_1: TFIBStringField;
    dtCustomerADDRESS_2: TFIBStringField;
    dtCustomerCITY: TFIBStringField;
    dtCustomerSTATE: TFIBStringField;
    dtCustomerZIP: TFIBStringField;
    dtCustomerCOUNTRY: TFIBStringField;
    dtCustomerPHONE: TFIBStringField;
    dtCustomerFAX: TFIBStringField;
    dtCustomerTAX_RATE: TFIBFloatField;
    dtCustomerCONTACT: TFIBStringField;
    dtCustomerLAST_INVOICE_DATE: TDateTimeField;
    procedure dbDemoLogin(Database: TFIBDatabase; LoginParams: TStrings;
      var DoConnect: Boolean);
    procedure eaDemoEventAlert(Sender: TObject; EventName: String;
      EventCount: Integer);
    procedure dbDemoBeforeDisconnect(Sender: TObject);
  private
    { Private declarations }
    function GetConnectParams: Boolean;
    procedure DoBeforeConnect;
    procedure DoBeforeDisconnect;
    procedure RegisterEvent;
    procedure UnRegisterEvent;
  public
    { Public declarations }
    function Connect: Boolean;
    function Disconnect: Boolean;
  end;

var
  dmMain: TdmMain;

implementation

uses connect, main;

{$R *.DFM}

function TdmMain.GetConnectParams: Boolean;
var
  UserParams: TStrings;
begin
  Result := False;
  try
    UserParams := TStringList.Create;
    SetConnectParams(UserParams, False);
    if Assigned(UserParams) then
    begin
      with dbDemo do
      begin
        DBName := UserParams.Strings[0];
        UserParams.Delete(0);
        DBParams.Assign(UserParams);
      end;
      Result := True;  
    end;
  finally
    UserParams.Free;
  end;
end;

procedure TdmMain.DoBeforeConnect;
begin
// do something
end;

procedure TdmMain.DoBeforeDisconnect;
begin
// do something
end;

procedure TdmMain.RegisterEvent;
begin
  with eaDemo do
    if not Registered then RegisterEvents;
end;

procedure TdmMain.UnRegisterEvent;
begin
  with eaDemo do
    if Registered then UnregisterEvents;
end;

function TdmMain.Connect: Boolean;
begin
  with dbDemo do
  begin
    Connected := True;
    Result := Connected;
    if Result then
    begin
      // Example, if this single connect to database then do something
      // if UserNames.Count = 1 then DoBeforeConnect;
      DoBeforeConnect;
      RegisterEvent;
    end;
  end;
end;

function TdmMain.Disconnect: Boolean;
begin
  with dbDemo do
  begin
    UnRegisterEvent;
    DoBeforeDisconnect;
    Connected := False;
    Result := not Connected;
    if Result then
    begin
      // do something
    end;
  end;
end;

procedure TdmMain.dbDemoLogin(Database: TFIBDatabase;
  LoginParams: TStrings; var DoConnect: Boolean);
begin
  DoConnect := GetConnectParams;
end;

procedure TdmMain.eaDemoEventAlert(Sender: TObject; EventName: String;
  EventCount: Integer);
begin
//  ! Don't work with TThread there
  if EventName = 'TEST_EVENT1' then MsgInformation('You receive Event 1 from Server. Do something there...');
  if EventName = 'TEST_EVENT2' then MsgInformation('You receive Event 2 from Server. Do something there...');
  if EventName = 'TEST_EVENT3' then MsgInformation('You receive Event 3 from Server. Do something there...');
end;

procedure TdmMain.dbDemoBeforeDisconnect(Sender: TObject);
begin
//  frmMain.DisconnectInDLL;
end;

end.
