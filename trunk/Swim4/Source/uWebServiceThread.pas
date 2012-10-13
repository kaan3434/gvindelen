unit uWebServiceThread;

interface

uses
  System.Classes, Variants, uDmWebServiceThread, GvXml, GvSoapClient;

type
  TWebServiceRequester = class(TThread)
  private
    { Private declarations }
    dm: TdmSwimThread;
    FThreadId: integer;
    FRequestId: integer;
    FScanId: integer;
    FActionSign: string;
    FNode: TGvXmlNode;
    FSoapClient: TGvSoapClient;
//    procedure getBookers;
    procedure getSports;
    procedure getTournirs;
    procedure getEvents;
    function BusyNextRequest: boolean;
    function GetURL: String;
  protected
    procedure MyInit;
    procedure MyDestroy;
    procedure UpdateMainForm;
    procedure Execute; override;
    property ThreadId: integer read FThreadId;
    property RequestId: integer read FRequestId;
  end;

implementation

uses
  Windows, ActiveX, Dialogs, SysUtils, GvStr, GvFile, Forms, uDmSwim, uSettings;
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
      FNode['Scan_Id']:= FScanId;
    end;
  end;
end;

procedure TWebServiceRequester.MyInit;
var
  Addr: String;
  Proxy: TGvXmlNode;
begin
  FreeOnTerminate:= true;
  dm:= TdmSwimThread.Create(nil);
  FThreadId:= dm.dbSwim.QueryValue(
    'SELECT gen_id(gen_thread_id, 1) FROM RDB$DATABASE', 0);
  FNode:= TGvXmlNode.Create;
  Proxy:= Settings.Proxy;
  if Proxy <> nil then
    FSoapClient:= TGvSoapClient.Create(Proxy['Server'], Proxy.Attr['Port'].AsInteger)
  else
    FSoapClient:= TGvSoapClient.Create;
  CoInitialize(nil);
end;

procedure TWebServiceRequester.MyDestroy;
begin
  CoUninitialize;
  FSoapClient.Free;
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
          getEvents
        else
        if FActionSign = 'getTournirs' then
          getTournirs
        else
        if FActionSign = 'getSports' then
          getSports;
        Synchronize(UpdateMainForm);
      end;
      Suspend;
    until Terminated;
  finally
    MyDestroy;
  end;
end;


//procedure TWebServiceRequester.PutBookers;
//var
//  aURL: String;
//  i: Integer;
//  Parts: TStringList;
//  Bookers: TGvXmlNode;
//begin
//  aURL:= settings.DefaultService['Url'];
//  with FSoapClient do
//  begin
//    Clear;
//    Method:= 'getBookers';
//    Request.AddChild('UserSign', 'Gvindelen');
//    Execute(aURL);
//    Bookers
//    for I := 0 to  do
//
//  end;
//
//  Bookers:= FWSScan.getBookers('Gvindelen').Bookers;
//  Parts:= TStringList.Create;
//  try
//    for i:= 0 to High(Bookers) do
//    begin
//      Parts.Values['BookerSign']:= Bookers[i].Sign;
//      with dm.spRequestAdd do
//      begin
//        Params.ParamByName('ActionSign').AsString:= 'getSports';
//        Params.ParamByName('Parts').AsString := Parts.Text;
//        ExecProc;
//      end;
//    end;
//  finally
//    Parts.Free;
//  end;
//end;

function TWebServiceRequester.GetURL: String;
var
  Services: TStringList;
  ndBooker: TGvXmlNode;
  BookerId: String;
begin
  Services:= TStringList.Create;
  try
    BookerId:= FNode['Booker_Id'];
    ndBooker:= settings.Bookers.Find('Booker', 'Id', BookerId);
    Services.CommaText:= ndBooker['Services'];
    Case Services.Count of
      0: result:= settings.RandomService['Url'];
      1: result:= settings.Services.Find('Service', 'Id', Services[0])['Url'];
    else
      result:= settings.Services.Find('Service', 'Id', Services[Random(Services.Count)])['Url'];
    End;
  finally
    Services.Free;
  end;
end;

procedure TWebServiceRequester.getSports;
var
  Sports: TGvXmlNode;
  Sport: TGvXmlNode;
  Node: TGvXmlNode;
  IsEmpty: Boolean;
begin
  try
    FSoapClient.Clear;
    FSoapClient.Method:= 'getSports';
    FSoapClient.Request.AddChild('BookerSignPart', FNode['Booker_Sign']);
    FSoapClient.Execute(GetUrl);
  except
    exit;
  end;
  Node:= TGvXmlNode.Create;
  try
    dm.trnWrite.StartTransaction;
    try
      Sports:= FSoapClient.Response.Find('Sports');
//      ShowMessage(Sports.WriteToString(true));
      for Sport in Sports.ChildNodes do
      begin
        Node.Clear;
        Node.NodeName:= 'Sport';
        Node.ReadAttributes(FNode.WriteToString, IsEmpty);
        Node.Attr['Sport_Id'].AsInteger:= Sport['Id'];
        Node.Attr['Sport_Sign'].AsString:= Sport['Sign'];
        Node.Attr['BSport_Name'].AsString:= Sport['Title'];
        Node.Attr['Url'].AsString:= Sport['Url'];
        dm.SportDetect(Node);
        dm.trnWrite.SetSavePoint('PutTournir');
        try
          if Node.Attr['Ignore_Flg'].AsBooleanDef(false) then
            // Это игнорируемый спорт?
          else
            // Добавляем запрос на получение турниров
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

procedure TWebServiceRequester.getTournirs;
var
  Tournirs: TGvXmlNode;
  Tournir: TGvXmlNode;
  Node: TGvXmlNode;
  IsEmpty: Boolean;
  Title: String;
begin
  try
    FSoapClient.Clear;
    FSoapClient.Method:= 'getTournirs';
    FSoapClient.Request.AddChild('BookerSignPart', FNode['Booker_Sign']);
    FSoapClient.Request.AddChild('SportIdPart', FNode['Sport_Id']);
    FSoapClient.Execute(GetUrl);
  except
    exit;
  end;
  Node:= TGvXmlNode.Create;
  try
    dm.trnWrite.StartTransaction;
    try
      for Tournir in FSoapClient.Response.Find('Tournirs').ChildNodes  do
      begin
        Node.Clear;
        Node.NodeName:= 'putTournir';
        Node.ReadAttributes(FNode.WriteToString, IsEmpty);
        Node.Attr['Tournir_Id'].AsString:= Tournir['Id'];
        Node.Attr['Tournir_Region'].AsString:= Tournir['Region'];
        if pos('&amp;', Tournir['Title']) > 0 then
          Tournir['Title']:= ReplaceAll(Tournir['Title'], '&amp;', '&');
        Node.Attr['BTournir_Name'].AsString:= UnEscapeString(Tournir['Title']);
        dm.TournirDetect(Node);
        dm.trnWrite.SetSavePoint('Tournir');
        try
          if Node.Attr['Ignore_Flg'].AsBooleanDef(false) then
            // это игрорируемый турнир?
          else
            // добавляем запрос на получение событий
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


procedure TWebServiceRequester.getEvents;
var
  Events: TGvXmlNode;
  Event: TGvXmlNode;
  Bet: TGvXmlNode;
  Node: TGvXmlNode;
  IsEmpty: Boolean;
begin
  try
    FSoapClient.Clear;
    FSoapClient.Method:= 'getEvents';
    FSoapClient.Request.AddChild('BookerSignPart', FNode['Booker_Sign']);
    FSoapClient.Request.AddChild('SportIdPart', FNode['Sport_Id']);
    FSoapClient.Request.AddChild('TournirIdPart', FNode['Tournir_Id']);
    FSoapClient.Request.AddChild('TournirUrlPart', FNode['Tournir_Url']);
    FSoapClient.Execute(GetUrl);
  except
    exit;
  end;
  DecimalSeparator:= '.';
  Node:= TGvXmlNode.Create;
  try
    try
      dm.trnWrite.StartTransaction;
      try
        for Event in FSoapClient.Response.Find('Events').ChildNodes  do
        begin
          Node.Clear;
          Node.NodeName:= 'putEvent';
          Node.ReadAttributes(FNode.WriteToString, IsEmpty);
          Node.Attr['Event_Dtm'].AsDateTime:= Event.Attr['DateTime'].AsDateTime;
          Node.Attr['BGamer1_Name'].AsString:= Event['Gamer1_Name'];
          Node.Attr['BGamer2_Name'].AsString:= Event['Gamer2_Name'];
          dm.trnWrite.SetSavePoint('PutEvent');
          try
            dm.EventDetect(Node);
            if Node.Attr['Ignore_Flg'].AsBooleanDef(false) then
              // Это игнорируемое событие?
            else
            begin
              // Добавляем запрос на получение турниров
              for Bet in Event.ChildNodes do
              begin
                dm.BetAdd(Node.Attr['BEvent_Id'].AsInteger, Bet.Attr['Ways'].AsInteger,
                  Bet['Period'], Bet['Kind'], Bet['Subject'], Bet['Gamer'],
                  Bet['Value'], Bet['Modifier'], Bet.Attr['Koef'].AsFloat);
              end;
            end;
          except
            on E:Exception do
            begin
              FSoapClient.SaveToFile('d:\soap.xml');
              ShowMessage(E.Message+' '+Node.WriteToString);
              dm.trnWrite.RollBackToSavePoint('PutEvent');
            end;
          end;
        end;
      finally
        dm.RequestCommit(FRequestId);
        dm.trnWrite.Commit;
      end;
    except
      on E:Exception do
      begin
        FSoapClient.SaveToFile('d:\soap.xml');
        ShowMessage(e.Message);
      end;
    end;
  finally
    Node.Free;
  end;
end;

procedure TWebServiceRequester.UpdateMainForm;
var
  QueueSize: integer;
begin
  QueueSize:= dm.trnRead.DefaultDatabase.QueryValue(
    'select count(*) from requests', 0, dm.trnRead);
  PostMessage(Application.MainForm.Handle, MY_QUEUESIZE, QueueSize, 0);
end;

end.
