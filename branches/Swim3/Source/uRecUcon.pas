unit uRecUcon;

interface

uses
  Classes, NativeXML, ComCtrls;

const
  Ucon_Name= 'Юкон';
  Ucon_Id=3;

procedure RecognizeUconLine(Html: String; ProgressBar: TProgressBar; StatusBar: TStatusBar);

implementation

uses
  dm, GvinStr, GvHtml, SysUtils, Masks, Math, DateUtils, GvHtml2Xml,
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
      '"Фора1='+ctFora1V+'","Коэфф=F","Фора2='+ctFora2V+'",'+
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
  tdh:= th.NodeByAttributeValue(nnTd, attTitle, 'F');
  if tdh<>nil then
    tdh.WriteAttributeString(attTitle, btFora1);
  tdh:= th.NodeByAttributeValue(nnTd, attTitle, 'F');
  if tdh<>nil then
    tdh.WriteAttributeString(attTitle, btFora2);
end;

procedure RecognizeUconLine(Html: String; ProgressBar: TProgressBar; StatusBar: TStatusBar);
var
  BSportName, TournirName: String;
  ASportId, BookerId: Integer;
  CountrySign: String;
  BSportId, TournirId, WaysCnt: Integer;
  Line: TNativeXML;
  PrztT, PrztG: TStringList;

procedure ExtractLineEvent(Html: String);
var
  St: String;
  ndTable, tr: TXmlNode;
  r: Integer;
  iDate, iGamer1, iGamer2: Integer; 

begin
  ndTable:= Line.Root;
  try
    St:= ReplaceAll(Html, ' - ', '|');
    TableHtmlToXML(St, ndTable);
    KillRowIfCol(ndTable, 0, tcaEmpty);
    RecognizeHeader(ndTable);
    CopyHeaderToAttribute(ndTable);
    KillRowIfCol(ndTable,1, tcaEqualSt, 'Дата');
    KillRowIfCol(ndTable, 1, tcaEmpty);
    SplitCol(ndTable, ctGamer1, ctGamer2, ['|']);

    tr:= ndTable.Nodes[0];
    try
      iDate:= tr.NodeByAttributeValue(nnTd, attTitle, ctEventDtTm).IndexInParent;
      iGamer1:= tr.NodeByAttributeValue(nnTd,attTitle, ctGamer1).IndexInParent;
      iGamer2:= tr.NodeByAttributeValue(nnTd,attTitle, ctGamer2).IndexInParent;
      for r:= 0 to ndTable.NodeCount-1 do
      begin
        tr:= ndTable.Nodes[r];
        dmSwim.FillEventParam(TournirId, GetEventDate(tr[iDate].ValueAsString),
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
    sl.Text:= ReplaceAll(Html, '><h3>', '>'#$D#$A'<h3>');
    ProgressBar.Max:= sl.Count;
    For i:= 0 to sl.Count - 1 do
    begin
      Application.ProcessMessages;
      ProgressBar.StepIt;
      St:= sl[i];
      if LowerCase(copy(St, 1, 4)) <> '<h3>' then continue;
      TournirName:= PrepareTournirName(CopyBetween(St, '<h3>', '</h3>'), PrztT);
      BSportName:= TakeFront5(TournirName, [',', '.']);
      TournirName:= Trim(TournirName);
      StatusBar.SimpleText:= BSportName+'. '+TournirName;

      ASportId:= dmSwim.GetASportId_byBSportName(BookerId, BSportName, TournirName,
        CountrySign, BSportId, TournirId, WaysCnt);
      if ASportId > 0 then
        ExtractLineEvent(CopyBE(St, '<table', '</table>'));
    end;
  finally
    sl.Free;
  end;
end;

begin
  Line:= TNativeXml.CreateName('Node');
  PrztT:= CreateParazit(Path['Parazit.Tournir']+'Ucon.txt');
  PrztG:= CreateParazit(Path['Parazit.Gamer']+'Ucon.txt');
  try
    BookerId:= Ucon_Id;
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
 