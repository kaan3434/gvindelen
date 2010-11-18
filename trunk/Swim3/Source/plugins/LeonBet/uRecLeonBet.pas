unit uRecLeonBet;

interface
uses
  Classes, NativeXML, ComCtrls;

const
  LeonBet_Name= 'LeonBet';
  LeonBet_Id=11;

procedure RecognizeLeonBetLine(Html: String; Line: TNativeXML; StatusBar: TStatusBar);

implementation

uses
  dm, GvinStr, GvHtml, SysUtils, Masks, Math, DateUtils, GvHtml2Xml, 
  GvinFile, GvinMath;

procedure RecognizeLeonBetLine(Html: String; Line: TNativeXML; StatusBar: TStatusBar);
var
  Sport_Name, Tournir_Name: String;
  ndSport, ndEvents, ndEvent, ndBets, ndGamer1, ndGamer2: TXmlNode;
  ndTable, tr, td: TXmlNode;
  AbsSport_Id, Bookmaker_Id: Integer;
  Tournir_Sex: String;
  Country_Id, Sport_Id, Tournir_Id, Ways_Cnt: Integer;

function GetEventDate(St: String): TDateTime;
var
  D, M, Y, H, N: Word;
  Mns: String;
begin
  D:= StrToInt(TakeFront5(St, [',', ' ']));
  Mns:= AnsiLowerCase(TakeFront5(St));
  H:= StrToInt(TakeFront5(St, [':']));
  N:= StrToInt(St);
  Y:= YearOf(Date);
  M:= WordNo(Mns, 'jan;feb;mar;apr;may;jun;jul;aug;sep;oct;nov;dec')+1;
  Result:= EncodeDateTime(Y, M, D, H, N, 0, 0);
  if Result < Date then result:= IncYear(result, 1);
end;


procedure RecognizeHeader(ndTable: TXmlNode);
var
  th, tdh: TXmlNode;
  Caption: String;
  c: Integer;
  Titles: TStringList;
begin
  th:= ndTable.Nodes[0];
  if th=nil then Exit;
  // определ€ем типы колонок
  Titles:= TStringList.Create;
  try
    Titles.CommaText:=
      '"Time='+ctEventDtTm+'",'+
      '"Event=Gamers",'+
      '"Win 1='+btWin1+'","Win. 1='+btWin1+'",'+
      '"Draw X='+btDraw+'",'+
      '"Win 2='+btWin2+'","Win. 2='+btWin2+'"';
    For c:=0 to th.NodeCount-1 do
    begin
      tdh:= th.Nodes[c];
      Caption:= tdh.ValueAsString;
      if Titles.Values[Caption]<>'' then
        tdh.WriteAttributeString(attTitle, Titles.Values[Caption]);
    end;
  finally
    Titles.Free;
  end;
end;


procedure ExtractLineEvent(Html: String);
var
  St: String;
  r: Integer;
begin
  ndTable:= ndEvents.NodeNew(nnTable);
  Html:= DeleteAllBE(Html, #9'TagNo="', '"');

  TableHtmlToXML(html, ndTable);
  KillRowIfCol(ndTable, 0, tcaEmpty);
  RecognizeHeader(ndTable);
  CopyHeaderToAttribute(ndTable);

  for r:= 1 to ndTable.NodeCount-1 do
  begin
    tr:= ndTable.Nodes[r];
    St:= tr.WriteToString;
    ndEvent:= ndEvents.NodeNew(nnEvent);
    ndEvent.WriteAttributeInteger(attBookmaker_Id, Bookmaker_Id);

    // «аносим дату событи€
    td:= tr.NodeByAttributeValue(nnTd, attTitle, ctEventDtTm);
    if td<>nil then
    begin
      if td.ValueAsString = '' then Exit;
      ndEvent.NodeNew(nnDate).ValueAsDateTime:= GetEventDate(td.ValueAsString);
    end;
    td:= tr.NodeByAttributeValue(nnTd,attTitle, 'Gamers');
    if td<>nil then
    begin
      St:= ReplaceAll(td.ValueAsString, ' - ', '|');
      ndGamer1:= ndEvent.NodeFindOrCreate(nnGamer1);
      ndGamer1.ValueAsString:= PrepareGamerName(TakeFront5(St, ['|']));
      ndGamer2:= ndEvent.NodeFindOrCreate(nnGamer2);
      ndGamer2.ValueAsString:= PrepareGamerName(TakeFront5(St, ['|']));
    end;

    ndBets:= ndEvent.NodeNew(nnBets);
    PutBet(btWin1, tr, ndBets, ndSport);
    PutBet(btDraw, tr, ndBets, ndSport);
    PutBet(btWin2, tr, ndBets, ndSport);
  end;
  ndTable.Delete;
end;

procedure MyPutBet(BetType, TotalV, TotalK: String);
begin
  TotalV:= trim(ReplaceAll(TotalV, ',', '.'));
  if Pos('.', TotalV)>0 then
    with ndBets.NodeNew(nnBet) do
    begin
      WriteAttributeString(attType, BetType);
      WriteAttributeInteger(attWays, 2);
      WriteAttributeString(attValue, TotalV);
      ValueAsString:= trim(ReplaceAll(TotalK, ',', '.'));
    end;
end;

procedure ExtractTotalBets(ndTable: TXmlNode);
var
  r: Integer;
  St, v: String;
begin
  For r:= 0 to ndTable.NodeCount-1 do
  begin
    tr:= ndTable[r];
    v:= CopyFront3(tr[0].ValueAsString, ['0'..'9','.',',']);
    St:= AnsiLowerCase(TakeFront5(v));
    if St='under' then
      MyPutBet(btTotLo, v, tr[1].ValueAsString)
    else
    if St='over' then
      MyPutBet(btTotHi, v, tr[1].ValueAsString);
  end;
end;

procedure ExtractForaBets(ndTable: TXmlNode);
var
  r: Integer;
  St, v: String;
begin
  For r:= 0 to ndTable.NodeCount-1 do
  begin
    tr:= ndTable[r];
    St:= tr[0].ValueAsString;
    v:= TakeBack3(St, ['0'..'9','.',',','-','+']);
    v:= TakeBack3(v, ['0'..'9','.',',','-','+']);
    if St = '' then
    begin
      St:= v;
      v:= '0';
    end;
    if Pos(St, ndGamer1.ValueAsString) > 0 then
      MyPutBet(btFora1, v, tr[1].ValueAsString)
    else
    if Pos(St, ndGamer2.ValueAsString) > 0 then
      MyPutBet(btFora2, v, tr[1].ValueAsString)
  end;
end;

procedure ExtractAdditionEventBets(Html: String);
var
  Header: String;
begin
  ndTable:= ndEvents.NodeNew(nnTable);

  Html:= DeleteAllBE(Html, #9'TagNo="', '"');
  Header:= TakeBE(Html, '<tr', '</tr>');
  Header:= DeleteAllBE(Header, '<', '>');

  ndTable:= ndEvents.NodeNew(nnTable);
  TableHtmlToXML(html, ndTable);
  if Header = 'Total' then
    ExtractTotalBets(ndTable)
  else
    ExtractForaBets(ndTable);

  ndTable.Delete;
end;


procedure ExtractEvent(Html: String);
var
  Header, TagNo, Row, Table: String;
begin
  Html:= NumberingTag(Html, 'tr');
  TagNo:= ExtractTagNo(Html, 'tr');
  Header:= TakeTagWithNo(Html, 'tr', TagNo);
  repeat
    TagNo:= ExtractTagNo(Html, 'tr');
    if TagNo = '' then Break;
    Row:= TakeTagWithNo(Html, 'tr', TagNo);
    if CopyBE(Row, '<table', '</table>') = '' then
      ExtractLineEvent(Header+Row)
    else
    begin
      repeat
        Table:= TakeBE(Row, '<table', '</table>');
        if Table = '' then break;
        ExtractAdditionEventBets(Table);
      until false;
    end;
  until false;
end;

procedure ExtractTournir(Html: String);
var
  sl: TStringList;
  St: String;
  i: Integer;
begin
  sl:= TStringList.Create;
  try
    sl.Text:= Html;
    For i:= 0 to sl.Count - 1 do
    begin
      St:= sl[i];
      Tournir_Name:= PrepareTournirName(TakeBE(St, '<table ', '</table>'));
      Sport_Name:= Trim(TakeFront5(Tournir_Name, ['-']));
      Tournir_Name:= Trim(Tournir_Name);
      StatusBar.SimpleText:= Tournir_Name;

      AbsSport_Id:= dmSwim.GetAbsSportId(Bookmaker_ID, Sport_Name, Tournir_Name,
        Country_Id, Tournir_Sex, Sport_Id, Tournir_Id, Ways_Cnt);
      if AbsSport_Id >=0 then
      begin
        ndSport:= Line.Root.NodeNew(nnSport);
        ndSport.ValueAsString:= Tournir_Name;
        ndSport.WriteAttributeString(attSport_Name, Sport_Name);
        ndSport.WriteAttributeInteger(attBookmaker_Id, Bookmaker_Id);
        ndSport.WriteAttributeInteger(attAbsSport_Id, AbsSport_Id);
        ndSport.WriteAttributeInteger(attSport_Id, Sport_Id);
        ndSport.WriteAttributeInteger(attTournir_Id, Tournir_Id);
        if Country_Id>0 then
          ndSport.WriteAttributeInteger(attCountry_Id, Country_Id);
        if trim(Tournir_Sex)<>'' then
          ndSport.WriteAttributeString(attSex, Tournir_Sex);
        ndSport.WriteAttributeInteger(attWays, Ways_Cnt);
        ndEvents:= ndSport.NodeNew(nnEvents);

        try
          ExtractEvent(St);
          if ndSport.NodeFindOrCreate(nnEvents).NodeCount = 0 then
            ndSport.Delete;
        except
          ndSport.NodeNew(nnHtml).ValueAsString:= St;
        end;
      end
    end;
  finally
    sl.Free;
  end;
end;

begin
  Bookmaker_Id:= LeonBet_Id;
  ExtractTournir(Html);
  StatusBar.SimpleText:= '';
end;

end.
