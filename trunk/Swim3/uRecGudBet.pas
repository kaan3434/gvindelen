unit uRecGudBet;

interface
uses
  Classes, NativeXML, ComCtrls;

const
  GudBet_Name= 'GudBet';
  GudBet_Id= 8;

procedure RecognizeGudBetLine(Html: String; Line: TNativeXML; StatusBar: TStatusBar);

implementation
uses
  dm, GvinStr, GvHtml, SysUtils, Masks, Math, DateUtils, GvHtml2Xml, 
  GvinFile, GvinMath;


function GetEventDate(St: String): TDateTime;
var
  D, M, Y, H, N: Word;
begin
  D:= StrToInt(TakeFront5(St, ['.','/']));
  M:= StrToInt(TakeFront5(St, [' ']));
  Y:= YearOf(Date);
  H:= StrToInt(TakeFront5(St, [':']));
  N:= StrToInt(St);
  Result:= EncodeDateTime(Y, M, D, H, N, 0, 0);
  if Result < Date then result:= IncYear(result, 1);
end;


procedure RecognizeHeader(ndTable: TXmlNode);
var
  c: Integer;
  th, tdh: TXmlNode;
  Caption: String;
  Titles: TStringList;
begin
  th:= ndTable.Nodes[0];
  if th=nil then Exit;
  // определяем типы колонок
  Titles:= TStringList.Create;
  try
    Titles.CommaText:=
      '"Дата='+ctEventDtTm+'",'+
      '"Событие='+nnGamer1+'",'+
      '"Поб.1='+btWin1+'",'+
      '"Ничья='+btDraw+'",'+
      '"Поб.2='+btWin2+'",'+
      '". 1X .='+btNoLose1+'",". 12 .='+btNoDraw+'",". X2 .='+btNoLose2+'",'+
      '"(Ф1) КФ.1='+ctFora1V+'",'+
      '"(Ф2) КФ.2='+ctFora2V+'",'+
      '"Тотал='+ctTotV+'","Мен.='+btTotLo+'","Бол.='+btTotHi+'"';
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


procedure RecognizeGudBetLine(Html: String; Line: TNativeXML; StatusBar: TStatusBar);
var
  Sport_Name: String;
  ndSport, ndEvents, ndEvent, ndBets: TXmlNode;
  AbsSport_Id, Bookmaker_Id: Integer;
  Tournir_Sex: String;
  Country_Id, Sport_Id, Tournir_Id, Ways_Cnt: Integer;
  Tournir_Name:String;

procedure MyPutFora(BetType: String; tr, Bets: TXmlNode);
var
  K, V: String;
  td, ndBet, ndForaV: TXmlNode;
begin
  td:= tr.NodeByAttributeValue(nnTd, attTitle, BetType);
  if td=nil then exit;
  K:= td.ValueAsString;
  if K='' then exit;
  ndForaV:= tr.NodeByAttributeValue(nnTd, attTitle, BetType+'V');
  if ndForaV=nil then exit;
  V:= DeleteChars(ndForaV.ValueAsString, ['(', ')']);
  ndBet:= Bets.NodeNew(nnBet);
  ndBet.ValueAsString:= ReplaceAll(K, ',', '.');
  ndBet.AttributeAdd(attType, BetType);
  ndBet.AttributeAdd(attWays, 2);
  ndBet.AttributeAdd(attValue, ReplaceAll(V, ',', '.'));
end;

procedure ExtractLineEvent(Html: String);
var
  St, Gamer_Name: String;
  ndTable, tr, td: TXmlNode;
  r: Integer;
begin
  St:= Html;
  ndTable:= ndEvents.NodeNew(nnTable);
  TableHtmlToXML(St, ndTable);
  RecognizeHeader(ndTable);
  CopyHeaderToAttribute(ndTable);

  SplitCol(ndTable, nnGamer1, nnGamer2, ['|']);
  SplitCol(ndTable, ctFora1V, btFora1, [')']);
  SplitCol(ndTable, ctFora2V, btFora2, [')']);

  for r:= 1 to ndTable.NodeCount-1 do
  begin
    tr:= ndTable.Nodes[r];
    ndEvent:= ndEvents.NodeNew(nnEvent);
    ndEvent.WriteAttributeInteger(attBookmaker_Id, Bookmaker_Id);
    td:= tr.NodeByAttributeValue(nnTd,attTitle, nnGamer1);
    if td<>nil then
    begin
      Gamer_Name:= td.ValueAsString;
      ndEvent.NodeFindOrCreate(nnGamer1).ValueAsString:= PrepareGamerName(Copy(Gamer_Name, 3, Length(Gamer_Name)));
    end;
    td:= tr.NodeByAttributeValue(nnTd,attTitle, nnGamer2);
    if td<>nil then
    begin
      Gamer_Name:= td.ValueAsString;
      ndEvent.NodeFindOrCreate(nnGamer2).ValueAsString:= PrepareGamerName(Copy(Gamer_Name, 3, Length(Gamer_Name)));
    end;
    td:= tr.NodeByAttributeValue(nnTd, attTitle, ctEventDtTm);
    if td<>nil then
      ndEvent.NodeNew(nnDate).ValueAsDateTime:= GetEventDate(td.ValueAsString);

    ndBets:= ndEvent.NodeNew(nnBets);
    PutBet(btWin1, tr, ndBets, ndSport);
    PutBet(btDraw, tr, ndBets, ndSport);
    PutBet(btWin2, tr, ndBets, ndSport);
    PutBet(btNoLose1, tr, ndBets, ndSport);
    PutBet(btNoDraw, tr, ndBets, ndSport);
    PutBet(btNoLose2, tr, ndBets, ndSport);
    PutTotal(btTotLo, tr, ndBets);
    PutTotal(btTotHi, tr, ndBets);
    MyPutFora(btFora1, tr, ndBets);
    MyPutFora(btFora2, tr, ndBets);
  end;
  ndTable.Delete;
end;

procedure ExtractTournir(Html: String);
var
  sl: TStringList;
  St: String;
  i: Integer;
begin
  sl:= TStringList.Create;
  try
    sl.Text:= ReplaceAll(Html, '><span>', '>'#$D#$A'<span>');
    For i:= 0 to sl.Count-1 do
    begin
      St:= sl[i];
      if LowerCase(Copy(St,1, 6)) <> '<span>' then Continue;
      Tournir_Name:= PrepareTournirName(CopyBE(St, '<span>', '<table', '>'));
      Sport_Name:= TakeFront5(Tournir_Name, ['.']);
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

        St:= CopyBE(St, '<table', '</table>');
        try
          ExtractLineEvent(St);
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
  Bookmaker_Id:= GudBet_Id;
  ExtractTournir(Html);
  StatusBar.SimpleText:= '';
end;

end.
