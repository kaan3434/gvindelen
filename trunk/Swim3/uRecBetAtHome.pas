unit uRecBetAtHome;

interface
uses
  Classes, NativeXML, ComCtrls;

const
  BetAtHome_Name= 'BetAtHome';
  BetAtHome_Id= 10;

procedure RecognizeBetAtHomeLine(Html, SportName, LineType: String;
          ProgressBar: TProgressBar; StatusBar: TStatusBar);

implementation

uses
  dm, GvinStr, GvHtml, SysUtils, Masks, Math, DateUtils, GvHtml2Xml,
  GvinFile, GvinMath;

type
  TBetLineType = (bltUnknown,     //0
                  blt2Way12,      //1
                  blt3Way1X2,     //2
                  blt3Way1X12X2,  //3
                  blt2WayTotal,   //4
                  blt2WayFora);   //5

var                  
  CurBetLineType: TBetLineType;

function GetEventDate(St: String): TDateTime;
var
  D, M, Y, H, N: Word;
begin
  D:= StrToInt(TakeFront5(St, ['.','/']));
  M:= StrToInt(TakeFront5(St, ['.','/']));
  Y:= StrToInt(TakeFront5(St));
  if Y<100 then Inc(Y, 2000);
  H:= StrToInt(TakeFront5(St, [':']));
  N:= StrToInt(St);
  Result:= EncodeDateTime(Y, M, D, H, N, 0, 0);
end;

procedure RecognizeHeader(ndTable: TXmlNode; CurBetLineType:TBetLineType; Row: Integer=0);
var
  c: Integer;
  th, tdh: TXmlNode;
  Caption: String;
  Titles: TStringList;
begin
  th:= ndTable.Nodes[Row];
  if th=nil then Exit;
  // определяем типы колонок
  Titles:= TStringList.Create;
  try
    if CurBetLineType=blt2WayTotal then
      Titles.CommaText:=
        '"1='+btTotLo+'",'+
        '"2='+btTotHi+'"'
    else
      Titles.CommaText:=
        '"1='+btWin1+'",'+
        '"X='+btDraw+'",'+
        '"2='+btWin2+'",'+
        '"1Х='+btNoLose1+'","12='+btNoDraw+'","Х2='+btNoLose2+'"';
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

procedure RecognizeBetAtHomeLine(Html, SportName, LineType: String;
          ProgressBar: TProgressBar; StatusBar: TStatusBar);
var
  ndSport, ndEvents, ndEvent, ndBets,
  ndTable: TXmlNode;
  ASportId, BookerId: Integer;
  BSportId, TournirId, WaysCnt: Integer;
  CountrySign, TournirName: String;
  Line: TNativeXml;
  PrztT, PrztG: TStringList;

procedure Extract3WayLineEvent(Html: String);
var
  St: String;
  tr: TXmlNode;
  iDate, iGamer1, iGamer2, r: Integer;
begin
  ndTable:= Line.Root;
  try
    TableHtmlToXML(html, ndTable);
    ndTable.Nodes[0].Delete;
    RecognizeHeader(ndTable, CurBetLineType);
    CopyHeaderToAttribute(ndTable);
    FillAttrForCol(ndTable, 3, attTitle, ctEventDtTm);
    FillAttrForCol(ndTable, 1, attTitle, ctGamer1);
    SplitCol(ndTable, ctGamer1, ctGamer2, ['|']);
    KillRowIfCol(ndTable, 4, tcaEmpty);

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
        except
        end;
        dmSwim.PutEvent;
      end;
    except
    end;
  finally
    ndTable.Clear;
  end;
end;

procedure ExtractTotalLineEvent(Html: String);
var
  St: String;
  tr: TXmlNode;
  iDate, iGamer1, iGamer2, r: Integer;
begin
  St:= ReplaceAll(Html, '(under/over ', '|');
  for r:= 0 to 9 do
    St:= ReplaceAll(St, IntToStr(r)+')</td', IntToStr(r)+'</td>');
  ndTable:= Line.Root;
  try
    TableHtmlToXML(St, ndTable);
    ndTable.Nodes[0].Delete;
    RecognizeHeader(ndTable, CurBetLineType);
    CopyHeaderToAttribute(ndTable);
    FillAttrForCol(ndTable, 3, attTitle, ctEventDtTm);
    FillAttrForCol(ndTable, 1, attTitle, ctGamer1);
    SplitCol(ndTable, ctGamer1, ctGamer2, ['|']);
    SplitCol(ndTable, ctGamer2, ctTotV, ['|']);
    KillRowIfCol(ndTable, 5, tcaEmpty);

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
          dmSwim.PutTotal(0, btTotLo, tr);
          dmSwim.PutTotal(1, btTotHi, tr);
        except
        end;
        dmSwim.PutEvent;
      end;
    except
    end;
  finally
    ndTable.Clear;
  end;
end;

procedure ExtractForaLineEvent(Html: String);
var
  St: String;
  tr: TXmlNode;
  iDate, iGamer1, iGamer2, r: Integer;
begin
  St:= ReplaceAll(Html, '(-', '|-');
  St:= ReplaceAll(St, '(+', '|+');
  for r:= 0 to 9 do
    St:= ReplaceAll(St, IntToStr(r)+')</td', IntToStr(r)+'</td>');
  ndTable:= Line.Root;
  try
    TableHtmlToXML(St, ndTable);
    ndTable.Nodes[0].Delete;
    RecognizeHeader(ndTable, CurBetLineType);
    CopyHeaderToAttribute(ndTable, 1);
    FillAttrForCol(ndTable, 3, attTitle, ctEventDtTm);
    FillAttrForCol(ndTable, 1, attTitle, ctGamer1);
    SplitCol(ndTable, ctGamer1, ctGamer2, ['|']);
    SplitCol(ndTable, ctGamer2, ctFora1V, ['|']);
    SplitCol(ndTable, ctFora1V, ctFora2V, ['/']);
    KillRowIfCol(ndTable, 5, tcaEmpty);

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
          dmSwim.PutFora(0, btFora1, tr);
          dmSwim.PutFora(1, btFora2, tr);
        except
        end;
        dmSwim.PutEvent;
      end;
    except
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
    sl.text:= ReplaceAll(Html, '><table', '>'#$D#$A'<table');
    For i:= 0 to sl.Count-1 do
    begin
      St:= sl[i];
      TournirName:= PrepareTournirName(CopyBE(St, '<tr>', '</tr>'), PrztT);
      if TournirName = '' then Continue;
      StatusBar.SimpleText:= SportName+'. '+TournirName;
      ASportId:= dmSwim.GetASportId_byBSportName(BookerId, SportName, TournirName,
        CountrySign, BSportId, TournirId, WaysCnt);
      if ASportId > 0 then
      begin
        St:= ReplaceAll(St, ' - ', '|');
        Case CurBetLineType of
          blt2WayTotal:
            ExtractTotalLineEvent(St);
          blt2WayFora:
            ExtractForaLineEvent(St);
        else
          Extract3WayLineEvent(St);
        end;
      end
    end;
  finally
    sl.Free;
  end;
end;

begin
  Line:= TNativeXML.Create;
  PrztT:= CreateParazit(Path['Parazit.Tournir']+'BetAtHome.txt');
  PrztG:= CreateParazit(Path['Parazit.Gamer']+'BetAtHome.txt');
  try
    StatusBar.SimpleText:= Format('Разбираем %s.%s', [SportName, LineType]);
    CurBetLineType:= TBetLineType(WordNo(LineType, '1_2;1_X_2;1X_X2_12;TOTAL;FORA')+1);
    BookerId:= BetAtHome_id;
    ExtractTournir(Html);
  finally
    Line.Free;
    PrztG.Free;
    PrztT.Free;
  end;
end;

end.

