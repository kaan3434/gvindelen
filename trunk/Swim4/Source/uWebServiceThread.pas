unit uWebServiceThread;

interface

uses
  System.Classes, Variants, uDmWebServiceThread, ScanWSDL, GvVars;

type
  TWebServiceRequester = class(TThread)
  private
    { Private declarations }
    dm: TdmSwimThread;
    FThreadId: integer;
    FRequestId: integer;
    FScanId: integer;
    FActionSign: string;
    FParts: TVarList;
    FWSScan: TScanPort;
    procedure PutBookers;
    procedure PutSports;
    procedure PutTournirs;
    procedure PutEvents;
    function BusyNextRequest: boolean;
    procedure CommitRequest;
    procedure RollbackRequest;
    procedure RequestCommit;
    procedure RequestRollback;
  protected
    procedure MyInit;
    procedure MyDestroy;
    procedure Execute; override;
    property ThreadId: integer read FThreadId;
    property RequestId: integer read FRequestId;
  end;

implementation

uses
  ActiveX;
{
  Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure WebServiceRequester.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end;

    or

    Synchronize(
      procedure
      begin
        Form1.Caption := 'Updated in thread via an anonymous method'
      end
      )
    );

  where an anonymous method is passed.

  Similarly, the developer can call the Queue method with similar parameters as
  above, instead passing another TThread class as the first parameter, putting
  the calling thread in a queue with the other thread.

}

{ WebServiceRequester }

function TWebServiceRequester.BusyNextRequest: boolean;
begin
  with dm.spRequestBusyNext do
  begin
    Params.ParamByName('I_THREAD_ID').AsInteger:= ThreadId;
    ExecProc;
    result:= ParamValue('O_REQUEST_ID') <> null;
    if result then
    begin
      FRequestId:= ParamValue('O_REQUEST_ID');
      FActionSign:= ParamValue('O_ACTION_SIGN');
      FParts.Text:= ParamValue('O_PARTS');
    end;
  end;
end;

procedure TWebServiceRequester.RequestCommit;
begin
  with dm.spRequestCommit do
  begin
    Params.ParamByName('I_REQUEST_ID').AsInteger:= FRequestId;
    ExecProc;
  end;
end;

procedure TWebServiceRequester.RequestRollback;
begin
  with dm.spRequestRollback do
  begin
    Params.ParamByName('I_REQUEST_ID').AsInteger:= FRequestId;
    ExecProc;
  end;
end;

procedure TWebServiceRequester.MyInit;
begin
  FreeOnTerminate:= true;
  dm:= TdmSwimThread.Create(nil);
  FThreadId:= dm.dbSwim.QueryValue(
    'SELECT gen_id(gen_thread_id, 1) FROM RDB$DATABASE', 0);
  FParts:= TVarList.Create;
  FWSScan:= GetTScanPort;
  CoInitialize(nil);
end;

procedure TWebServiceRequester.MyDestroy;
begin
  CoUninitialize;
  FParts.Free;
  dm.Free;
end;

procedure TWebServiceRequester.CommitRequest;
begin
  with dm.spRequestCommit do
  begin
    Params.ParamByName('I_REQUEST_ID').AsInteger:= RequestId;
    ExecProc;
  end;
end;

procedure TWebServiceRequester.Execute;
begin
  MyInit;
  try
    while BusyNextRequest do
    try
      if FActionSign = 'getEvents' then
        PutEvents
      else
      if FActionSign = 'getTournirs' then
        PutTournirs
      else
      if FActionSign = 'getSports' then
        PutSports
      else
      if FActionSign = 'getBookers' then
        PutBookers;
      RequestCommit;
    except
      RequestRollback;
    end;
  finally
    MyDestroy;
  end;
end;

procedure TWebServiceRequester.PutBookers;
var
  Bookers: TBookers;
  i: Integer;
  Parts: TStringList;
begin
  Bookers:= FWSScan.getBookers('Gvindelen').Bookers;
  Parts:= TStringList.Create;
  try
    for i:= 0 to High(Bookers) do
    begin
      Parts.Values['Booker']:= Bookers[i].Sign;
      with dm.spRequestAdd do
      begin
        Params.ParamByName('ActionSign').AsString:= 'getSports';
        Params.ParamByName('Parts').AsString := Parts.Text;
        ExecProc;
      end;
    end;
  finally
    Parts.Free;
  end;
end;

procedure TWebServiceRequester.PutEvents;
var
  Events: TEventsResponse;
begin
  Events:= FWSScan.getEvents(FParts['Booker'],
                             FParts.AsInteger['SportId'],
                             FParts['TournirId'],
                             FParts['TournirUrl']);
end;

procedure TWebServiceRequester.PutSports;
var
  Sports: TSportsResponse;
begin
  Sports:= FWSScan.getSports(FParts.Values['Booker']);
end;

procedure TWebServiceRequester.PutTournirs;
var
  Tournirs: TTournirsResponse;
begin
  Tournirs:= FWSScan.getTournirs(FParts['Booker'],
                                 FParts.AsInteger['SportId'])
end;

procedure TWebServiceRequester.RollbackRequest;
begin

end;

end.
