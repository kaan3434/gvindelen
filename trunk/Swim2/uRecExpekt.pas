unit uRecExpekt;

interface
uses
  Classes, NativeXML, ComCtrls;

const
  Expekt_Name= 'Expekt';
  Expekt_Id= 12;

procedure RecognizeExpektLine(Html, SportName, LineType: String;
          ProgressBar: TProgressBar; StatusBar: TStatusBar);

implementation

uses
  dm, GvinStr, GvHtml, SysUtils, Masks, Math, DateUtils, GvHtml2Xml,
  GvinFile, GvinMath, uAGamers;

type
  TBetLineType = (bltUnknown,     //0
                  blt2Way12,      //1
                  blt3Way1X2,     //2
                  blt3Way1X12X2,  //3
                  blt2WayTotal,   //4
                  blt2WayFora,    //5
                  blt2Way12DEF);  //6

var
  CurBetLineType: TBetLineType;

procedure RecognizeHeader(ndTable: TXmlNode; CurBetLineType: TBetLineType);
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
    Case CurBetLineType of
      blt3Way1X2, blt3Way1X12X2, blt2Way12: Titles.CommaText:=
         '"Time='+ctEventDtTm+'","event='+ctGamer1+'",'+
         '"type=Tournir",'+
         '"1='+btWin1+'","X='+btDraw+'","2='+btWin2+'",'+
         '"1X='+btNoLose1+'","12='+btNoDraw+'","X2='+btNoLose2+'"';
      blt2WayTotal: Titles.CommaText:=
         '"Time='+ctEventDtTm+'","event='+ctGamer1+'",'+
         '"type=Tournir","odds=TotalV1"';
    end;
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

function GetEventDate(St: String): TDateTime;
var
  D, M, Y, H, N: Word;
begin
  TakeFront5(St);
  D:= StrToInt(TakeFront5(St, ['-']));
  M:= StrToInt(TakeFront5(St, ['-']));
  Y:= StrToInt(TakeFront5(St));
  H:= StrToInt(TakeFront5(St, [':']));
  N:= StrToInt(St);
  Result:= EncodeDateTime(Y, M, D, H, N, 0, 0);
end;

procedure RecognizeExpektLine(Html, SportName, LineType: String;
          ProgressBar: TProgressBar; StatusBar: TStatusBar);
var
  ASportId, BookerId: Integer;
  CountrySign: String;
  BSportId, TournirId, WaysCnt: Integer;
  StDt, TournirName: String;
  EventDate, EventTime: TDateTime;
  Line: TNativeXml;
  PrztT, PrztG: TStringList;
  iTournir, iGamer1, iGamer2, iDate: Integer;

procedure MyPutTotal(Index: Integer; ColNameV, ColNameK: String; tr: TXmlNode);
var
  K, V, S: String;
  td, ndBet: TXmlNode;
begin
  td:= tr.NodeByAttributeValue(nnTd, attTitle, ColNameV);
  if td=nil then exit;
  V:= td.ValueAsString;
  td:= tr.NodeByAttributeValue(nnTd, attTitle, ColNameK);
  if td=nil then exit;
  K:= td.ValueAsString;
  if K='' then exit;
  S:= LowerCase(TakeFront5(V));
  if S = 'under' then s:= btTotLo else s:= btTotHi;
  V:= CopyFront4(V);
{  ndBet:= Bets.NodeNew(nnBet);
  ndBet.ValueAsString:= ReplaceAll(K, ',', '.');
  ndBet.AttributeAdd(attType, S);
  ndBet.AttributeAdd(attWays, 2);
  ndBet.AttributeAdd(attValue, ReplaceAll(V, ',', '.'));}
end;

procedure ExtractEvent(tr: TXmlNode);
var
  St, StTbl, StNew: String;
  i: integer;
begin
  TournirName:= tr[iTournir].ValueAsString;
  TournirName:= Trim(PrepareTournirName(TournirName, PrztT));
  StatusBar.SimpleText:= SportName+'. '+TournirName;

  ASportId:= dmSwim.GetASportId_byBSportName(BookerId, SportName, TournirName,
    CountrySign, BSportId, TournirId, WaysCnt);
  if ASportId > 0 then
  begin
    dmSwim.FillEventParam(TournirId,
      GetEventDate(tr[iDate].ValueAsString),
      PrepareGamerName(tr[iGamer1].ValueAsString, PrztG),
      PrepareGamerName(tr[iGamer2].ValueAsString, PrztG));

    Case CurBetLineType of
      blt3Way1X2, blt2Way12:
        begin
          dmSwim.PutBet(0, btWin1, tr, WaysCnt);
          if WaysCnt = 3 then
            dmSwim.PutBet(1, btDraw, tr, WaysCnt);
          dmSwim.PutBet(2, btWin2, tr, WaysCnt);
        end;
      blt3Way1X12X2:
        begin
          dmSwim.PutBet(0, btNoLose1, tr, 3);
          dmSwim.PutBet(1, btNoDraw, tr, 3);
          dmSwim.PutBet(2, btNoLose2, tr, 3);
        end;
      blt2WayTotal:
        begin
          MyPutTotal(0, 'TotalV1', 'TotalK1', tr);
          MyPutTotal(1, 'TotalV2', 'TotalK2', tr);
        end;
    end;
    dmSwim.PutEvent;
  end
end;

procedure ExtractEvents(Html: String);
var
  ndTable, td: TXmlNode;
  i: Integer;
  St: String;
begin
  ndTable:= Line.Root;
  try
    Html:= ReplaceAllBE(Html, '<table', 'CET', '</table>', 'Time');
    Html:= ReplaceAll(Html, '<br/></td>', '</td');
    TableHtmlToXML(Html, ndTable);
    while ndTable[0][0].ValueAsString <> 'Time' do
      ndTable.NodeDelete(0);
    RecognizeHeader(ndTable, CurBetLineType);
    SplitCol(ndTable, ctGamer1, ctGamer2, ' - ');
    if CurBetLineType = blt2WayTotal then
    begin
      SplitCol(ndTable, 'TotalV1', 'TotalK1', '<br/>');
      SplitCol(ndTable, 'TotalK1', 'TotalV2', '<br/>');
      SplitCol(ndTable, 'TotalV2', 'TotalK2', '<br/>');
      SplitCol(ndTable, 'TotalK2', '', '<br/>');
    end;
    CopyHeaderToAttribute(ndTable);

    td:= ndTable[0].NodeByAttributeValue(nntd, attTitle, 'Tournir');
    if td = nil then Exit;
    iTournir:= td.IndexInParent;

    td:= ndTable[0].NodeByAttributeValue(nntd, attTitle, ctGamer1);
    if td = nil then Exit;
    iGamer1:= td.IndexInParent;

    td:= ndTable[0].NodeByAttributeValue(nntd, attTitle, ctGamer2);
    if td = nil then Exit;
    iGamer2:= td.IndexInParent;

    td:= ndTable[0].NodeByAttributeValue(nntd, attTitle, ctEventDtTm);
    if td = nil then Exit;
    iDate:= td.IndexInParent;

    For i:= 1 to ndTable.NodeCount-1 do
      ExtractEvent(ndTable[i]);
  finally
    ndTable.Clear;
  end;
end;

var
  S, TagNo: String;
begin
  Line:= TNativeXML.CreateName('table');
  PrztT:= CreateParazit(Path['Parazit.Tournir']+'Expekt.txt');
  PrztG:= CreateParazit(Path['Parazit.Gamer']+'Expekt.txt');
  try
    StatusBar.SimpleText:= Format('Разбираем %s.%s', [SportName, LineType]);
    CurBetLineType:= TBetLineType(WordNo(LineType, '1_2;1_X_2;1X_X2_12;TOTAL;FORA;1_2_DEF')+1);
    BookerId:= Expekt_id;
    Html:= NumberingTag(Html, 'table');
    Html:= TakeNumberedTagContains(Html, 'table', 'oddsRow1');
    Html:= DeleteAll(Html, '<br/>Under/Over');
    Html:= DeleteAll(Html, '<br/>double chance');
    if Html <> '' then
    begin
      Case CurBetLineType of
        blt2WayTotal:
          begin
            TagNo:= ExtractTagNo(Html, 'table');
//            Html:=
          end
      else
        begin
          Html:= ClearNumbering(Html);
          ExtractEvents(Html);
        end
      end;
    end;
  finally
    Line.Free;
    PrztG.Free;
    PrztT.Free;
  end;
end;

end.

