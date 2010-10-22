unit uRecPlusMinus;

interface

uses
  Classes, NativeXML, ComCtrls;

const
  PlusMinus_Name= 'ПлюсМинус';
  PlusMinus_Id=7;

procedure RecognizePlusMinusLine(Html: String; ProgressBar: TProgressBar; StatusBar: TStatusBar);

implementation

uses
  dm, GvinStr, GvHtml, SysUtils, Masks, Math, DateUtils, GvinFile, GvHtml2Xml, 
  GvinMath, Forms;

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
//  if Result < Date then result:= IncYear(result, 1);
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
      '"Дата='+ctEventDtTm+'","Событие='+ctGamer1+'",'+
      '"1='+btWin1+'","Поб.1='+btWin1+'",'+
      '"X='+btDraw+'",'+
      '"2='+btWin2+'","Поб.2='+btWin2+'",'+
      '"1X='+btNoLose1+'","12='+btNoDraw+'","X2='+btNoLose2+'",'+
      '"Ф1='+ctFora1V+'","K1='+btFora1+'","Ф2='+ctFora2V+'","K2='+btFora2+'",'+
      '"T='+ctTotV+'","М='+btTotLo+'","Б='+btTotHi+'"';
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
    begin
      if (tr.Nodes[0].IsEmpty) and (tr.Nodes[1].IsEmpty) then
      begin
        For i:= 0 to 3 do
          tr.Nodes[i].ValueAsString:= ptr.Nodes[i].ValueAsString;
      end;
    end;
    inc(r);
  end;
end;

procedure RecognizePlusMinusLine(Html: String; ProgressBar: TProgressBar; StatusBar: TStatusBar);
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
  Html:= DeleteAllBSE(Html, '<tr class=line3', 'экспрессы', '<tr class=line', '</tr>');
  Html:= DeleteAllBE(Html, '<tr class=line3', '</tr>');
  ndTable:= Line.Root;
  try
    TableHtmlToXML(Html, ndTable);
    RecognizeHeader(ndTable);
    CopyHeaderToAttribute(ndTable);
    SplitCol(ndTable, ctGamer1, ctGamer2, ' - ');
    KillRowIfCol(ndTable, 0, tcaEqualSt, 'N');

    if ndTable.NodeCount = 0 then Exit;
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
        if tr[0].ValueAsString <> '' then
          dmSwim.FillEventParam(TournirId,
            GetEventDate(tr[iDate].ValueAsString),
            PrepareGamerName(tr[iGamer1].ValueAsString, PrztG),
            PrepareGamerName(tr[iGamer2].ValueAsString, PrztG))
        else
        if (tr[1].ValueAsString <> '') or (tr[2].ValueAsString <> '') then
          continue
        else
          dmSwim.ClearBetParam;
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
    sl.Text:= ReplaceAll(Html, '><table>', '>'#$D#$A'<table>');
    ProgressBar.Max:= sl.Count;
    For i:= 0 to sl.Count - 1 do
    begin
      Application.ProcessMessages;
      ProgressBar.StepIt;
      St:= sl[i];
      TournirName:= PrepareTournirName(TakeBE(St, '<table>', '</table>'), PrztT);
      // Вставляем точку
      BSportName:= TakeFront5(TournirName, [#32, '.']);
      if BSportName = '' then Continue;
      while (TournirName<>'') and
            (TournirName[1] <> AnsiUpperCase(TournirName[1])) do
        BSportName:= BSportName + ' ' + TakeFront5(TournirName, [#32, '.']);
      TournirName:= Trim(TournirName);
      StatusBar.SimpleText:= BSportName+'. '+ TournirName;

      ASportId:= dmSwim.GetASportId_byBSportName(BookerID, BSportName, TournirName,
        CountrySign, BSportId, TournirId, WaysCnt);
      if ASportId > 0 then
      begin
        St:= CopyBE(St, '<table', '</table>');
        ExtractLineEvent(St);
      end
    end;
  finally
    sl.Free;
  end;
end;

begin
  Line:= TNativeXml.CreateName('Table');
  PrztT:= CreateParazit(Path['Parazit.Tournir']+'PlusMinus.txt');
  PrztG:= CreateParazit(Path['Parazit.Gamer']+'PlusMinus.txt');
  try
    BookerId:= PlusMinus_Id;
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


