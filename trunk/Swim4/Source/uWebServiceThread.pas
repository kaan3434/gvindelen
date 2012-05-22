unit uWebServiceThread;

interface

uses
  System.Classes, Variants, uDmWebServiceThread, ScanWSDL, GvXml;

type
  TWebServiceRequester = class(TThread)
  private
    { Private declarations }
    dm: TdmSwimThread;
    FThreadId: integer;
    FRequestId: integer;
    FScanId: integer;
    FActionSign: string;
    FWSScan: TScanPort;
    FNode: TGvXmlNode;
    procedure PutBookers;
    procedure PutSports;
    procedure PutTournirs;
    procedure PutEvents;
    function BusyNextRequest: boolean;
  protected
    procedure MyInit;
    procedure MyDestroy;
    procedure Execute; override;
    property ThreadId: integer read FThreadId;
    property RequestId: integer read FRequestId;
  end;

implementation

uses
  ActiveX, Dialogs, SysUtils, GvStr, GvFile;
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
var
  IsEmpty: Boolean;
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
      FNode.ReadAttributes(ParamValue('O_PARTS'), IsEmpty);
      FScanId:= ParamValue('O_SCAN_ID');
    end;
  end;
end;

procedure TWebServiceRequester.MyInit;
begin
  FreeOnTerminate:= true;
  dm:= TdmSwimThread.Create(nil);
  FThreadId:= dm.dbSwim.QueryValue(
    'SELECT gen_id(gen_thread_id, 1) FROM RDB$DATABASE', 0);
  FWSScan:= GetTScanPort;
  FNode:= TGvXmlNode.Create;
  CoInitialize(nil);
end;

procedure TWebServiceRequester.MyDestroy;
begin
  CoUninitialize;
  FNode.Free;
  dm.Free;
end;

procedure TWebServiceRequester.Execute;
begin
  MyInit;
  try
    repeat
      while BusyNextRequest do
      begin
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
      end;
      Suspend;
    until Terminated;
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
      Parts.Values['BookerSign']:= Bookers[i].Sign;
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
  Events: TEvents;
  Event: TEvent;
  Bet: TBet;
  Node: TGvXmlNode;
  IsEmpty: Boolean;
begin
  DecimalSeparator:= '.';
  Node:= TGvXmlNode.Create;
  try
    try
      Events:= FWSScan.getEvents(FNode.Attr['Booker_Sign'].AsString,
                                 FNode.Attr['Sport_Id'].AsInteger,
                                 FNode.Attr['Tournir_Id'].AsString,
                                 FNode.Attr['Tournir_Url'].AsString).Events;
    except
      on E: Exception do
      begin
        ShowMessage(Format('Webservice error (Request=%u, Message="%s", Node="%s"',
          [FRequestId, E.Message, FNode.WriteToString]));
        exit;
      end;
    end;
    try
      dm.trnWrite.StartTransaction;
      for Event in Events do
      begin
        Node.Clear;
        Node.NodeName:= 'putEvent';
        Node.ReadAttributes(FNode.WriteToString, IsEmpty);
        Node.Attr['Event_Dtm'].AsDateTime:= Event.DateTime.AsDateTime;
        Node.Attr['Gamer1_Name'].AsString:= Event.Gamer1_Name;
        Node.Attr['Gamer2_Name'].AsString:= Event.Gamer2_Name;
        dm.EventDetect(Node);
        dm.trnWrite.SetSavePoint('PutEvent');
        try
          if Node.Attr['Ignore_Flg'].AsBooleanDef(false) then
            // ��� ������������ �������?
          else
          begin
            // ��������� ������ �� ��������� ��������
            for Bet in Event.Bet do
            try
              dm.trnWrite.SetSavePoint('PutBet');
              dm.BetDetect(Bet.Period, Bet.Kind, Bet.Subject, Bet.Gamer,
                           Bet.Value, Bet.Modifier, Bet.Koef,
                           Node.Attr['Event_Swap'].AsBoolean);
            except
              dm.trnWrite.RollBackToSavePoint('PutBet');
            end;
          end;
        except
          dm.trnWrite.RollBackToSavePoint('PutEvent');
          ShowMessage(Node.WriteToString);
        end;
      end;
    finally
      dm.RequestCommit(FRequestId);
      dm.trnWrite.Commit;
    end;
  finally
    Node.Free;
  end;
end;

procedure TWebServiceRequester.PutSports;
var
  Sports: TSports;
  Sport: TSport;
  Node: TGvXmlNode;
  IsEmpty: Boolean;
begin
  Node:= TGvXmlNode.Create;
  try
    Sports:= FWSScan.getSports(FNode.Attr['Booker_Sign'].AsString).Sports;
    dm.trnWrite.StartTransaction;
    try
      for Sport in Sports do
      begin
        Node.Clear;
        Node.NodeName:= 'putTournir';
        Node.ReadAttributes(FNode.WriteToString, IsEmpty);
        Node.Attr['Sport_Id'].AsInteger:= Sport.Id;
        Node.Attr['Sport_Sign'].AsString:= Sport.Sign;
        Node.Attr['Sport_Title'].AsString:= Sport.Title;
        dm.SportDetect(Node);
        dm.trnWrite.SetSavePoint('PutTournir');
        try
          if Node.Attr['Ignore_Flg'].AsBooleanDef(false) then
            // ��� ������������ �����?
          else
            // ��������� ������ �� ��������� ��������
            dm.RequestAdd(FScanId, 'getTournirs', Node.WriteToString);
        except
          dm.trnWrite.RollBackToSavePoint('PutTournir');
          ShowMessage(Node.WriteToString);
        end;
      end;
    finally
      dm.RequestCommit(FRequestId);
      dm.trnWrite.Commit;
    end;
  finally
    Node.Free;
  end;
end;

procedure TWebServiceRequester.PutTournirs;
var
  Tournirs: TTournirs;
  Tournir: TTournir;
  Node: TGvXmlNode;
  IsEmpty: Boolean;
begin
  Node:= TGvXmlNode.Create;
  try
    Tournirs:= FWSScan.getTournirs(FNode.Attr['Booker_Sign'].AsString,
                                   FNode.Attr['Sport_Id'].AsInteger).Tournirs;
    dm.trnWrite.StartTransaction;
    try
      for Tournir in Tournirs do
      begin
        Node.Clear;
        Node.NodeName:= 'getEvents';
        Node.ReadAttributes(FNode.WriteToString, IsEmpty);
        Node.Attr['Tournir_Id'].AsString:= Tournir.Id;
        Node.Attr['Tournir_Region'].AsString:= Tournir.Region;
        Node.Attr['Tournir_Title'].AsString:= UnEscapeString(Tournir.Title);
        dm.TournirDetect(Node);
        dm.trnWrite.SetSavePoint('Tournir');
        try
          if Node.Attr['Ignore_Flg'].AsBooleanDef(false) then
            // ��� ������������ ������?
          else
            // ��������� ������ �� ��������� �������
            dm.RequestAdd(FScanId, 'getEvents', Node.WriteToString);
        except
          ShowMessage(Node.WriteToString);
          dm.trnWrite.RollBackToSavePoint('Tournir');
        end;
      end;
    finally
      dm.RequestCommit(FRequestId);
      dm.trnWrite.Commit
    end;
  finally
    Node.Free;
  end;
end;

end.