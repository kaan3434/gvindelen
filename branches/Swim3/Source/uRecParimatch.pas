unit uRecParimatch;

interface
uses
  Classes, NativeXML, ComCtrls;

const
  Parimatch_Name= 'Пари-матч';
  Parimatch_Id=2;

procedure RecognizeParimatchLine(Html: String;
  ProgressBar: TProgressBar; StatusBar: TStatusBar);

implementation

uses
  dm, GvinStr, GvHtml, SysUtils, Masks, Math, DateUtils, GvHtml2Xml,
  GvinFile, GvinMath, Forms;


function GetEventDate(St: String): TDateTime;
var
  D, M, Y, H, N: Word;
begin
  D:= StrToInt(TakeFront5(St, ['.','/']));
  M:= StrToInt(TakeFront5(St, [' ','|']));
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
      '"Событие='+ctGamer1+'",'+
      '"П1='+btWin1+'","Поб.1='+btWin1+'",'+
      '"X='+btDraw+'",'+
      '"П2='+btWin2+'","Поб.2='+btWin2+'",'+
      '"1X='+btNoLose1+'","12='+btNoDraw+'","X2='+btNoLose2+'",'+
      '"Фора='+ctFora1V+'","КФ='+btFora1+'",'+
      '"iТ=IT","Т='+ctTotV+'","М='+btTotLo+'","Б='+btTotHi+'"';
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
  tdh:= th.NodeByAttributeValue(nnTd, attTitle, 'IT');
  if tdh<>nil then
    For c:= tdh.IndexInParent to th.NodeCount - 1 do
      th[c].AttributesClear;
end;



procedure RecognizeParimatchLine(Html: String;
  ProgressBar: TProgressBar; StatusBar: TStatusBar);
var
  BSportName, TournirName: String;
  ASportId, BookerId: Integer;
  CountrySign: String;
  BSportId, TournirId, WaysCnt: Integer;
  Line: TNativeXML;
  PrztT, PrztG: TStringList;

procedure ExtractLineEvent(Html: String);
var
  St, LowSt: String;
  ndTable, tr: TXmlNode;
  iDate, iGamer1, iGamer2, 
  r: Integer;
begin
  St:= Html;
  LowSt:=AnsiLowerCase(St);
  if (Pos('<th>да<', LowSt)>0) or (Pos('<th>нет<', LowSt)>0) then
  begin
    St:= '';
    Exit;
  end;
  St:= ReplaceAll(St, '<br>', '|');
  St:= DeleteAllBE(St, '<table ', '>');
  St:= DeleteAll(St, '</table>');

  ndTable:= Line.Root;
  try
    TableHtmlToXML(St, ndTable);
    KillRowIfCol(ndTable, 0, tcaEmpty);
    RecognizeHeader(ndTable);
    CopyHeaderToAttribute(ndTable);

    KillRowIfCol(ndTable, 0, tcaEqualSt, 'Дата');
    KillRowIfCol(ndTable, 0, tcaNoContainSt, '|');
    SplitCol(ndTable, ctGamer1, ctGamer2, ['|']);
    SplitCol(ndTable, ctGamer2, '', ['|']);
    SplitCol(ndTable, ctFora1V, ctFora2V, ['|']);
    SplitCol(ndTable, ctFora2V, '', ['|']);
    ClearCellIfCol(ndTable, btFora1, tcaContainSt, 'igif', '', btFora1);
    SplitCol(ndTable, btFora1, btFora2, ['|']);
    SplitCol(ndTable, btFora2, '', ['|']);
    ClearCellIfCol(ndTable, btTotLo, tcaContainSt, 'igif', '', btTotLo);
    SplitCol(ndTable, btTotLo, '', ['|']);
    ClearCellIfCol(ndTable, btTotHi, tcaContainSt, 'igif', '', btTotHi);
    SplitCol(ndTable, btTotHi, '', ['|']);
    SplitCol(ndTable, ctTotV, '', ['|']);

    tr:= ndTable.Nodes[0];
    try
      iDate:= tr.NodeByAttributeValue(nnTd, attTitle, ctEventDtTm).IndexInParent;
      iGamer1:= tr.NodeByAttributeValue(nnTd,attTitle, ctGamer1).IndexInParent;
      iGamer2:= tr.NodeByAttributeValue(nnTd,attTitle, ctGamer2).IndexInParent;

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
    sl.Text:= ReplaceAll(Html, '><TABLE class=hdr>', '>'#$D#$A'<TABLE class=hdr>');
    ProgressBar.Max:= sl.Count;
    For i:= 0 to sl.Count - 1 do
    begin
      Application.ProcessMessages;
      ProgressBar.StepIt;
      St:= sl[i];
      TournirName:= TakeBE(St, '<table ', '</table>');
      TournirName:= ReplaceAll(TournirName, '<tr><td>', '.<tr><td>');
      TournirName:= PrepareTournirName(TournirName, PrztT);
      BSportName:= Trim(TakeFront5(TournirName, ['.']));
      TournirName:= Trim(TournirName);
      StatusBar.SimpleText:= TournirName;

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
  PrztT:= CreateParazit(Path['Parazit.Tournir']+'Parimatch.txt');
  PrztG:= CreateParazit(Path['Parazit.Gamer']+'Parimatch.txt');
  try
    BookerId:= Parimatch_Id;
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
