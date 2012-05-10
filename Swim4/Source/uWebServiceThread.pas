unit uWebServiceThread;

interface

uses
  System.Classes, Variants, uDmWebServiceThread, ScanWSDL;

type
  TWebServiceRequester = class(TThread)
  private
    { Private declarations }
    dm: TdmSwimThread;
    FThreadId: integer;
    FRequestId: integer;
    FScanId: integer;
    FActionSign: string;
    FParts: TStringList;
    FWSScan: TScanPort;
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
  ActiveX, GvXml, Dialogs, SysUtils;
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
  FParts:= TStringList.Create;
  FWSScan:= GetTScanPort;
  CoInitialize(nil);
end;

procedure TWebServiceRequester.MyDestroy;
begin
  CoUninitialize;
  FParts.Free;
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
  Parts: TStringList;
begin
  Node:= TGvXmlNode.Create;
  try
    Node.ImportAttrs(FParts);
    Events:= FWSScan.getEvents(Node.Attr['Booker_Sign'].AsString,
                               Node.Attr['Sport_Id'].AsInteger,
                               Node.Attr['Tournir_Id'].AsString,
                               Node.Attr['Tournir_Url'].AsString).Events;
    Parts:= TStringList.Create;
    try
      dm.trnWrite.StartTransaction;
      try
        for Event in Events do
        begin
          Parts.Clear;
          Node.Clear;
          Node.ImportAttrs(FParts);
          Node.Attr['Event_Dtm'].AsDateTime:= Event.DateTime.AsDateTime;
          Node.Attr['Event_Gamer1_Name'].AsString:= Event.Gamer1_Name;
          Node.Attr['Event_Gamer2_Name'].AsString:= Event.Gamer2_Name;
          dm.EventDetect(Node);
          Node.ExportAttrs(Parts);
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
            Node.NodeName:= 'a';
            ShowMessage(Node.WriteToString);
          end;
        end;
      finally
        dm.RequestCommit(FRequestId);
        dm.trnWrite.Commit;
      end;
    finally
      Parts.Free;
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
  Parts: TStringList;
begin
  Node:= TGvXmlNode.Create;
  try
    Node.ImportAttrs(FParts);
    Sports:= FWSScan.getSports(Node.Attr['Booker_Sign'].AsString).Sports;
    Parts:= TStringList.Create;
    try
      dm.trnWrite.StartTransaction;
      try
        for Sport in Sports do
        begin
          Parts.Clear;
          Node.Clear;
          Node.ImportAttrs(FParts);
          Node.Attr['Sport_Id'].AsInteger:= Sport.Id;
          Node.Attr['Sport_Sign'].AsString:= Sport.Sign;
          Node.Attr['Sport_Title'].AsString:= Sport.Title;
          dm.SportDetect(Node);
          Node.ExportAttrs(Parts);
          dm.trnWrite.SetSavePoint('PutTournir');
          try
            if Node.Attr['Ignore_Flg'].AsBooleanDef(false) then
              // ��� ������������ �����?
            else
              // ��������� ������ �� ��������� ��������
              dm.RequestAdd(FScanId, 'getTournirs', Parts.Text);
          except
            dm.trnWrite.RollBackToSavePoint('PutTournir');
            Node.NodeName:= 'a';
            ShowMessage(Node.WriteToString);
          end;
        end;
      finally
        dm.RequestCommit(FRequestId);
        dm.trnWrite.Commit;
      end;
    finally
      Parts.Free;
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
  Parts: TStringList;
begin
  Node:= TGvXmlNode.Create;
  try
    Node.ImportAttrs(FParts);
    Tournirs:= FWSScan.getTournirs(Node.Attr['Booker_Sign'].AsString,
                                   Node.Attr['Sport_Id'].AsInteger).Tournirs;
    Parts:= TStringList.Create;
    try
      dm.trnWrite.StartTransaction;
      try
        for Tournir in Tournirs do
        begin
          Parts.Clear;
          Node.Clear;
          Node.ImportAttrs(FParts);
          Node.Attr['Tournir_Id'].AsString:= Tournir.Id;
          Node.Attr['Tournir_Region'].AsString:= Tournir.Region;
          Node.Attr['Tournir_Title'].AsString:= Tournir.Title;
          dm.TournirDetect(Node);
          Node.ExportAttrs(Parts);
          dm.trnWrite.SetSavePoint('Tournir');
          try
            if Node.Attr['Ignore_Flg'].AsBooleanDef(false) then
              // ��� ������������ ������?
            else
              // ��������� ������ �� ��������� �������
              dm.RequestAdd(FScanId, 'getEvents', Parts.Text);
          except
            dm.trnWrite.RollBackToSavePoint('Tournir');
          end;
        end;
      finally
        dm.RequestCommit(FRequestId);
        dm.trnWrite.Commit
      end;
    finally
      Parts.Free;
    end;
  finally
    Node.Free;
  end;
end;

end.
