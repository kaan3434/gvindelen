unit uRecBetBy;

interface
uses
  Classes, NativeXML, ComCtrls;

const
  BetBy_Name= 'BetBy';
  BetBy_Id=6;

procedure RecognizeBetByLine(Html: String; ProgressBar: TProgressBar; StatusBar: TStatusBar);

implementation

uses
  dm, GvinStr, GvHtml, SysUtils, Masks, Math, DateUtils, GvHtml2Xml,
  GvinFile, GvinMath, GvVars, Forms;

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

procedure FillDopTotal(ndTable: TXmlNode);
var
  r, i: Integer;
  tr, ptr: TXmlNode;

begin
  r:= 1;
  while r+1<ndTable.NodeCount do
  begin
    inc(r);
    tr:= ndTable.Nodes[r];
    ptr:= ndTable.Nodes[r-1];
    if tr[0].ValueAsString = '' then
    begin
      For i:= 0 to 7 do
        tr.Nodes[i].ValueAsString:= ptr.Nodes[i].ValueAsString;
    end;
  end;
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
      '"Дата=EventDate","Время=EventTime",'+
      '"Э=Express",'+
      '"Команда 1='+ctGamer1+'",'+
      '"Команда 2='+ctGamer2+'",'+
      '"1='+btWin1+'","Х='+btDraw+'","2='+btWin2+'",'+
      '"1Х='+btNoLose1+'","12='+btNoDraw+'","Х2='+btNoLose2+'",'+
      '"фора=FV","Коэф=FK",'+
      '"Тотал='+ctTotV+'","&lt;&lt;='+btTotLo+'","&gt;&gt;='+btTotHi+'"';
    For c:=0 to th.NodeCount-1 do
    begin
      tdh:= th.Nodes[c];
      Caption:= tdh.ValueAsString;
      if Titles.Values[Caption]<>'' then
        tdh.WriteAttributeString(attTitle, Titles.Values[Caption]);
    end;
    tdh:= th.NodeByAttributeValue(nnTd, attTitle, 'FV');
    if tdh<>nil then
      tdh.WriteAttributeString(attTitle, ctFora1V);
    tdh:= th.NodeByAttributeValue(nnTd, attTitle, 'FK');
    if tdh<>nil then
      tdh.WriteAttributeString(attTitle, btFora1);
    tdh:= th.NodeByAttributeValue(nnTd, attTitle, 'FV');
    if tdh<>nil then
      tdh.WriteAttributeString(attTitle, ctFora2V);
    tdh:= th.NodeByAttributeValue(nnTd, attTitle, 'FK');
    if tdh<>nil then
      tdh.WriteAttributeString(attTitle, btFora2);
  finally
    Titles.Free;
  end;
end;

procedure RecognizeBetByLine(Html: String; ProgressBar: TProgressBar; StatusBar: TStatusBar);
var
  BSportName, TournirName: String;
  ASportId, BookerId: Integer;
  CountrySign: String;
  BSportId, TournirId, WaysCnt: Integer;
  Line: TNativeXML;
  PrztT, PrztG: TStringList;

procedure ExtractLineEvent(Html: String);
var
  ndTable, tr, td: TXmlNode;
  r: Integer;
  iDate, iTime, iGamer1, iGamer2: Integer;
begin
  ndTable:= Line.Root;
  try
    Html:= CopyAllBE(Html, '<tr', '</tr>');
    TableHtmlToXML(Html, ndTable);

    RecognizeHeader(ndTable);
    FillDopTotal(ndTable);
    CopyHeaderToAttribute(ndTable);
//    KillRowIfCol(ndTable, 5, tcaNoEmpty);

    if ndTable.NodeCount = 0 then exit;
    tr:= ndTable.Nodes[0];
    try
      iDate:= tr.NodeByAttributeValue(nnTd, attTitle, 'EventDate').IndexInParent;
      iTime:= tr.NodeByAttributeValue(nnTd, attTitle, 'EventTime').IndexInParent;
      td:= tr.NodeByAttributeValue(nnTd,attTitle, ctGamer1);
      if td=nil then exit;
      iGamer1:= td.IndexInParent;
      td:= tr.NodeByAttributeValue(nnTd,attTitle, ctGamer2);
      if td = nil then exit;
      iGamer2:= td.IndexInParent;

      for r:= 1 to ndTable.NodeCount-1 do
      begin
        tr:= ndTable.Nodes[r];
        if tr[0].ValueAsIntegerDef(-1) = -1 then
          continue;
        dmSwim.FillEventParam(TournirId,
          GetEventDate(tr[iDate].ValueAsString+' '+tr[iTime].ValueAsString),
          PrepareGamerName(tr[iGamer1].ValueAsString, PrztG),
          PrepareGamerName(tr[iGamer2].ValueAsString, PrztG));
        try
          dmSwim.PutBet(0, btWin1, tr, WaysCnt);
          dmSwim.PutBet(1, btWin2, tr, WaysCnt);
          if WaysCnt = 3 then
          begin
            dmSwim.PutBet(2, btDraw, tr, 3);
            dmSwim.PutBet(3, btNoLose1, tr, 3);
            dmSwim.PutBet(4, btNoDraw, tr, 3);
            dmSwim.PutBet(5, btNoLose2, tr, 3);
          end;
          dmSwim.PutTotal(6, btTotLo, tr);
          dmSwim.PutTotal(7, btTotHi, tr);
          dmSwim.PutFora(8, btFora1, tr);
          dmSwim.PutFora(9, btFora2, tr);
        except
        end;
        dmSwim.PutEvent;
      end;
    except
  //    ShowMessage(tr.WriteToString);
    end;
  finally
    ndTable.Clear;
  end;
end;

procedure ExtractTournir(Html: String);
var
  sl: TStringList;
  St: String;
  i: Integer;
begin
  sl:= TStringList.Create;
  try
    sl.Text:= ReplaceAll(Html, '<h1', #$D#$A'<h1');
    ProgressBar.Max:= sl.Count;
    For i:= 0 to sl.Count - 1 do
    begin
      Application.ProcessMessages;
      ProgressBar.StepIt;
      St:= sl[i];
      if LowerCase(copy(St, 1, 3)) <> '<h1' then continue;
      TournirName:= TakeBE(St, '<h1 ', '</td>');
      TournirName:= PrepareTournirName(TournirName, PrztT);
      BSportName:= Trim(TakeFront5(TournirName, ['.']));
      TournirName:= Trim(TournirName);
      StatusBar.SimpleText:= BSportName+'. '+TournirName;

      ASportId:= dmSwim.GetASportId_byBSportName(BookerId, BSportName, TournirName,
        CountrySign, BSportId, TournirId, WaysCnt);
      if ASportId > 0 then
        ExtractLineEvent(St);
    end;
  finally
    sl.Free;
  end;
end;

begin
  Line:= TNativeXml.CreateName('Node');
  PrztT:= CreateParazit(Path['Parazit.Tournir']+'BetBy.txt');
  PrztG:= CreateParazit(Path['Parazit.Gamer']+'BetBy.txt');
  try
    BookerId:= BetBy_Id;
    ProgressBar.Position:= 0;
    ExtractTournir(Html);
    ProgressBar.Position:= 0;
    StatusBar.SimpleText:= '';
  finally
    Line.Free;
    PrztG.Free;
    PrztT.Free;
  end;
end;


end.
