unit uRecFavorit;

interface
uses
  Classes, NativeXML, ComCtrls;

const
  Favorit_Name= 'Фаворит';
  Favorit_Id=5;

procedure RecognizeFavoritLine(Html: String; ProgressBar: TProgressBar; StatusBar: TStatusBar);

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
  while r<ndTable.NodeCount do
  begin
    ptr:= ndTable.Nodes[r-1];
    tr:= ndTable.Nodes[r];
    if Not IsInteger(tr.Nodes[0].ValueAsString) then
    begin
      For i:= 0 to 3 do
        tr.Nodes[i].ValueAsString:= ptr.Nodes[i].ValueAsString;
    end;
    inc(r);
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
      '"Дата='+ctEventDtTm+'",'+
      '"Участник 1='+ctGamer1+'","Участник1='+ctGamer1+'",'+
      '"Участник 2='+ctGamer2+'","Участник2='+ctGamer2+'",'+
      '"поб.1='+btWin1+'",'+
      '"ничья='+btDraw+'",'+
      '"поб.2='+btWin2+'",'+
      '"1Х='+btNoLose1+'","12='+btNoDraw+'","Х2='+btNoLose2+'",'+
      '"фора1='+ctFora1V+'","кф1='+btFora1+'",'+
      '"фора2='+ctFora2V+'","кф2='+btFora2+'",'+
      '"тотал='+ctTotV+'","мен.='+btTotLo+'","бол.='+btTotHi+'"';
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

procedure RecognizeFavoritLine(Html: String; ProgressBar: TProgressBar; StatusBar: TStatusBar);
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
  iDate, iGamer1, iGamer2: Integer;
begin
  ndTable:= Line.Root;
  try
    Html:= CopyBE(Html, '<table', 'Дата', '</table>');
    TableHtmlToXML(Html, ndTable);
    KillRowIfCol(ndTable, 0, tcaEmpty);
    RecognizeHeader(ndTable);
    FillDopTotal(ndTable);
    CopyHeaderToAttribute(ndTable);
    KillRowIfCol(ndTable,1, tcaEqualSt, 'Дата');

    tr:= ndTable.Nodes[0];
    try
      iDate:= tr.NodeByAttributeValue(nnTd, attTitle, ctEventDtTm).IndexInParent;
      td:= tr.NodeByAttributeValue(nnTd,attTitle, ctGamer1);
      if td=nil then exit;
      iGamer1:= td.IndexInParent;
      td:= tr.NodeByAttributeValue(nnTd,attTitle, ctGamer2);
      if td = nil then exit;
      iGamer2:= td.IndexInParent;

      for r:= 0 to ndTable.NodeCount-1 do
      begin
        tr:= ndTable.Nodes[r];
        dmSwim.FillEventParam(TournirId,
          GetEventDate(tr[iDate].ValueAsString),
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
    sl.Text:= ReplaceAll(Html, '><tr height="22">', '>'#$D#$A'<tr height="22">');
    ProgressBar.Max:= sl.Count;
    For i:= 0 to sl.Count - 1 do
    begin
      Application.ProcessMessages;
      ProgressBar.StepIt;
      St:= sl[i];
      if LowerCase(copy(St, 1, 3)) <> '<tr' then continue;
      TournirName:= TakeBE(St, '<tr ', '</tr>');
      TournirName:= PrepareTournirName(TournirName, PrztT);
      BSportName:= Trim(TakeFront5(TournirName, ['-']));
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
  PrztT:= CreateParazit(Path['Parazit.Tournir']+'Favorit.txt');
  PrztG:= CreateParazit(Path['Parazit.Gamer']+'Favorit.txt');
  try
    BookerId:= Favorit_Id;
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
