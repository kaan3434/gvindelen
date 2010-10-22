unit uRecBWin;

interface
uses
  Classes, NativeXML, ComCtrls;

const
  BWin_Name= 'bwin';
  BWin_Id= 9;

procedure RecognizeBWinLine(Html, SportName, LineType: String;
          ProgressBar: TProgressBar; StatusBar: TStatusBar);

implementation

uses
  dm, GvinStr, GvHtml, SysUtils, Masks, Math, DateUtils, GvHtml2Xml,
  GvinFile, GvinMath, Forms, Dialogs, GvVars;

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

function GetEventDate(St: String): TDateTime;
var
  D, M, Y: Word;
  Dof, Mns: String;
begin
  Dof:= TakeFront5(St);
  if IsInteger(Dof) then
  begin
    D:= StrToInt(Dof);
    Mns:= AnsiLowerCase(TakeFront5(St));
    Y:= StrToInt(TakeFront5(St));
    M:= WordNo(Mns, 'января;февраля;марта;апреля;мая;июня;июля;августа;сентября;октября;ноября;декабря')+1;
  end
  else
  begin
    Mns:= AnsiLowerCase(TakeFront5(St));
    D:= StrToInt(TakeFront5(St, [',', ' ']));
    Y:= StrToInt(TakeFront5(St));
    M:= WordNo(Mns, 'january;february;march;april;may;june;july;august;september;october;november;december')+1;
    if M = 0 then
      M:= WordNo(Mns, 'январь;февраль;март;апрель;май;июнь;июль;август;сентябрь;октябрь;ноябрь;декабрь')+1;
  end;
  Result:= EncodeDate(Y, M, D)
end;

procedure PatchDateTime(ndTable: TXmlNode; ColNo: Integer; StrDate: String);
var
  r: Integer;
  tr, td: TXmlNode;
  Tm, AMPM: String;
  H,M: Integer;
begin
  r:= 0;
  while r < ndTable.NodeCount do
  begin
    tr:= ndTable.Nodes[r];
    td:= tr.Nodes[ColNo];
    Tm:= td.ValueAsString;
    AMPM:= UpperCase(TakeBack5(tm));
    M:= StrToInt(TakeBack5(Tm, [':']));
    H:= StrToInt(TakeBack5(Tm));
    if (AMPM='AM') and (H=12) then H:= 0 else
    if (AMPM='PM') and (H<12) then Inc(H, 12);
    td.ValueAsString:= Format('%s %2.2u:%2.2u', [StrDate, H, M]);
    td.WriteAttributeString(attTitle, ctEventDtTm);
    Inc(r);
  end;
end;

function GetEventTime(EventTm: String): TDateTime;
var
  AMPM: String;
  H, M: Integer;
begin
  EventTm:= DeleteAllBE(EventTm, '<', '>');
  if LastChar(EventTm)=')' then
  begin
    TakeBack5(EventTm, ['(']);
    EventTm:= Trim(EventTm);
  end;
  if LastChar(EventTm) = 'M' then
    AMPM:= UpperCase(TakeBack5(EventTm))
  else
    AMPM:='';
  M:= StrToInt(TakeBack5(EventTm, [':']));
  H:= StrToInt(TakeBack5(EventTm));
  if (AMPM='AM') and (H=12) then H:= 0 else
  if (AMPM='PM') and (H<12) then Inc(H, 12);
  Result:= EncodeTime(H, M, 0, 0);
end;

procedure RecognizeBWinLine(Html, SportName, LineType: String;
          ProgressBar: TProgressBar; StatusBar: TStatusBar);
var
  ASportId, BookerId: Integer;
  CountrySign: String;
  BSportId, TournirId, WaysCnt: Integer;
  StDt, TournirName: String;
  EventDate, EventTime: TDateTime;
  Line: TNativeXml;
  PrztT, PrztG: TStringList;


procedure ExtractEvent(Html: String);
var
  sl: TStringList;
  St, EventName, NewSt: String;
  i: Integer;
  Gamer1Name, Gamer2Name: String;

procedure ExtractGamersAndTime(Html: String);
var
  EventTime: TDateTime;
begin
  Html:= CopyBE(Html, '<td ',' - ',' - ', '</td>');
  Html:= ReplaceAll(Html, ' - ', '|');
  Html:= Trim(DeleteAllBE(Html, '<', '>'));
  if CurBetLineType = blt2Way12DEF then
    Html:= ReplaceAll(Html, ' at ', '|', true);
  Gamer1Name:= PrepareGamerName(TakeFront5(Html, ['|']), PrztG);
  EventTime:= GetEventTime(TakeBack5(Html, ['|']));
  if LastChar(Html) = ')' then
          TakeBack5(Html, ['(']);
  Gamer2Name:= PrepareGamerName(TakeBack5(Html, ['|']), PrztG);
  dmSwim.FillEventParam(TournirId, EventDate+EventTime, Gamer1Name, Gamer2Name);
end;

procedure ExtractForaValue(Html: String);
var
  StTbl, StV, StK: String;
  IndexNo: Integer;
begin
  IndexNo:= 0;
  StTbl:= TakeBE(Html, '<table>', '</table>');
  while StTbl<>'' do
  begin
    StV:= TakeBE(StTbl, '<td', '</td>');
    StV:= DeleteAllBE(StV, '<', '>');
    StV:= CopyBack3(ReplaceAll(StV, ',', '.'), ['+', '-']);
    StV:= DeleteAll(StV, ' ');
    StK:= TakeBE(StTbl, '<td', '</td>');
    StK:= DeleteAllBE(StK, '<', '>');
    if IsFloat(StV) then
    begin
      if IndexNo = 0 then
        dmSwim.PutTotal(IndexNo, btFora1, StV, StK)
      else
        dmSwim.PutTotal(IndexNo, btFora2, StV, StK);
      Inc(IndexNo);
    end;
    StTbl:= TakeBE(Html, '<table>', '</table>');
  end;
end;

procedure ExtractTotalValue(Html: String);
var
  StTbl, StV, StK: String;
  IndexNo: Integer;
begin
  IndexNo:= 0;
  StTbl:= TakeBE(Html, '<table>', '</table>');
  while StTbl<>'' do
  begin
    StV:= TakeBE(StTbl, '<td', '</td>');
    StV:= DeleteAllBE(StV, '<', '>');
    StK:= TakeBE(StTbl, '<td', '</td>');
    StK:= DeleteAllBE(StK, '<', '>');
    if StV='' then Continue;
    StV:= AnsiUpperCase(StV);
    if (CopyLast(StV, 8) = ' OR MORE') or (CopyLast(StV, 11) = ' ИЛИ БОЛЬШЕ') then
    begin
      dmSwim.PutTotal(IndexNo, btTotHi, Format('%u.5', [StrToInt(CopyFront4(StV))-1]), StK);
      Inc(IndexNo);
    end
    else
    if (CopyFront4(StV) = 'OVER') or
       (CopyFront4(StV) = 'БОЛЬШЕ') or
       (CopyFront4(StV) = 'БОЛЕЕ') then
    begin
      dmSwim.PutTotal(IndexNo, btTotHi, CopyBack4(StV), StK);
      Inc(IndexNo);
    end
    else
    if (CopyFront4(StV) = 'UNDER') or
       (CopyFront4(StV) = 'МЕНЬШЕ') or
       (CopyFront4(StV) = 'МЕНЕЕ') then
    begin
      dmSwim.PutTotal(IndexNo, btTotLo, CopyBack4(StV), StK);
      Inc(IndexNo);
    end;
    StTbl:= TakeBE(Html, '<table>', '</table>');
  end;
end;

procedure ExtractTotalBetGroup(Html: String);
var
  sl: TStringList;
  i: Integer;
  St, BetGroup: String;
begin
  sl:= TStringList.Create;
  try
    sl.Text:= ReplaceAll(Html, '><tr class="alt">', '>'#$D#$A'<tr class="alt">');
    For i:= 0 to sl.Count-1 do
    begin
      St:= sl[i];
      BetGroup:= TakeBE(St, '<tr class="alt">', '</tr>');
      BetGroup:= Trim(DeleteAllBE(BetGroup, '<', '>'));
      BetGroup:= Trim(DeleteChars(BetGroup, ['0'..'9','.',',']));
      BetGroup:= CopyFront3(BetGroup, ['?']);
      if BetGroup = 'Total' then
        ExtractTotalValue(St)
      else
      if BetGroup = 'Fora' then
        ExtractForaValue(St);
    end;
  finally
    sl.Free;
  end;
end;

procedure ExtractDoubleChanceValue(Html: String);
var
  StTbl, StV, StK, NoLose1, NoLose2, NoDraw: String;
begin
  NoLose1:= '';
  NoLose2:= '';
  NoDraw:= '';
  StTbl:= TakeBE(Html, '<table ', '</table>');
  while StTbl<>'' do
  begin
    StV:= TakeBE(StTbl, '<td', '</td>');
    StV:= DeleteAllBE(StV, '<', '>');
    StK:= TakeBE(StTbl, '<td', '</td>');
    StK:= DeleteAllBE(StK, '<', '>');
    if StV='' then Continue;
    StV:= AnsiUpperCase(StV);
    if (CopyLast(StV, 5) = ' OR X') or (CopyLast(StV, 6) = ' ИЛИ X') then
      NoLose1:= StK
    else
    if (Copy(StV, 1, 5) = 'X OR ') or (Copy(StV, 1, 6) = 'X ИЛИ ')then
      NoLose2:= StK
    else
    if (Pos(' OR ', StV) > 0) or (Pos(' ИЛИ ', StV) > 0) then
      NoDraw:= StK;
    StTbl:= TakeBE(Html, '<table ', '</table>');
  end;
  dmSwim.PutBet(0, btNoLose1, NoLose1, 3);
  dmSwim.PutBet(1, btNoLose2, NoLose2, 3);
  dmSwim.PutBet(2, btNoDraw, NoDraw, 3);
end;


procedure ExtractDoubleChanceBetGroup(Html: String);
var
  sl: TStringList;
  i: Integer;
  St, BetGroup: String;
begin
  sl:= TStringList.Create;
  try
    sl.Text:= ReplaceAll(Html, '><tr class="alt">', '>'#$D#$A'<tr class="alt">');
    For i:= 0 to sl.Count-1 do
    begin
      St:= sl[i];
      BetGroup:= TakeBE(St, '<tr class="alt">', '</tr>');
      BetGroup:= DeleteAllBE(BetGroup, '<', '>');
      if BetGroup = 'Двойной шанс' then
        ExtractDoubleChanceValue(St);
    end;
  finally
    sl.Free;
  end;
end;

procedure ExtractWinLoseLineValue(Html: string);
var
  StTbl, StV, StK, Win1, Win2: String;
begin
  Win1:= '';
  Win2:= '';
  StTbl:= TakeBE(Html, '<table ', '</table>');
  while StTbl<>'' do
  begin
    StV:= TakeBE(StTbl, '<td ', '</td>');
    StV:= DeleteAllBE(StV, '<', '>');
    StK:= TakeBE(StTbl, '<td ', '</td>');
    StK:= DeleteAllBE(StK, '<', '>');
    if StV='' then Continue;
    StV:= PrepareGamerName(StV, PrztG);
    if StV=Gamer1Name then
      Win1:= StK
    else
    if StV = Gamer2Name then
      Win2:= StK;
    StTbl:= TakeBE(Html, '<table ', '</table>');
  end;
  dmSwim.PutBet(0, btWin1, Win1, WaysCnt);
  dmSwim.PutBet(1, btWin2, Win2, WaysCnt);
end;

procedure ExtractWinLoseBetGroup(Html: String);
var
  sl: TStringList;
  i: Integer;
  St: String;
begin
  sl:= TStringList.Create;
  try
    sl.Text:= ReplaceAll(Html, '><tr class="alt">', '>'#$D#$A'<tr class="alt">');
    For i:= 0 to sl.Count-1 do
    begin
      St:= sl[i];
      ExtractWinLoseLineValue(St);
    end;
  finally
    sl.Free;
  end;
end;

begin
  repeat
    St:= CopyBE(Html, '<tr class="alt">', ' - ', ':', '</td>', '</tr>');
    if St='' then break;
    NewSt:= ReplaceAll(St, '"alt"', '"evn"');
    Html:= ReplaceAll(Html, St, #$D#$A+NewSt);
  until false;

  sl:= TStringList.Create;
  try
    sl.text:= Html;
    For i:= 0 to sl.Count-1 do
    begin
      St:= sl[i];
      EventName:= TakeBE(St, '<tr class="evn">', '</tr>');
      if (EventName<>'') and (Pos(':', EventName)>0)  then
      begin
        ExtractGamersAndTime(EventName);
        if CurBetLineType = blt2WayTotal then
          ExtractTotalBetGroup(St)
        else
        if CurBetLineType = blt3Way1X12X2 then
          ExtractDoubleChanceBetGroup(St)
        else
        if CurBetLineType = blt2Way12DEF then
          ExtractWinLoseBetGroup(St);
        dmSwim.PutEvent;
      end;
    end;
  finally
    sl.Free;
  end;
end;


procedure ExtractLineValue(Html: string);
var
  StTbl, StV, StK, Gamer1Name, Gamer2Name, Win1, Win2, Draw: String;
begin
  Gamer1Name:= '';
  Gamer2Name:= '';
  Win1:= '';
  Win2:= '';
  Draw:= '';
  StTbl:= TakeBE(Html, '<table>', '</table>');
  while StTbl<>'' do
  begin
    StV:= TakeBE(StTbl, '<td>', '</td>');
    StV:= DeleteAllBE(StV, '<', '>');
    StK:= TakeBE(StTbl, '<td>', '</td>');
    StK:= DeleteAllBE(StK, '<', '>');
    if StV='' then Continue;
    if StV='X' then
      Draw:= StK
    else
    if Gamer1Name='' then
    begin
      Gamer1Name:= PrepareGamerName(StV, PrztG);
      Win1:= StK;
    end
    else
    begin
      Gamer2Name:= PrepareGamerName(StV, PrztG);
      Win2:= StK;
    end;
    StTbl:= TakeBE(Html, '<table>', '</table>');
  end;
  dmSwim.FillEventParam(TournirId, EventDate+EventTime, Gamer1Name, Gamer2Name);
  dmSwim.PutBet(0, btWin1, Win1, WaysCnt);
  dmSwim.PutBet(1, btDraw, Draw, 3);
  dmSwim.PutBet(2, btWin2, Win2, WaysCnt);
  dmSwim.PutEvent;
end;

procedure ExtractLineEvent(Html: String);
var
  sl: TStringList;
  St: String;
  i: Integer;
begin
  sl:= TStringList.Create;
  try
    sl.text:= ReplaceAll(Html, '><tr class="normal">', '>'#$D#$A'<tr class="normal">');
    sl.Text:= ReplaceAll(sl.Text, '><tr class="def">', '>'#$D#$A'<tr class="def">');
    For i:= sl.Count-1 downto 0 do
      if Pos(' class="def"', sl[i])>0 then
        sl.Delete(i);
    For i:= 0 to sl.Count-1 do
    begin
      St:= sl[i];
      EventTime:= GetEventTime(TakeBE(St, '<td>', '</td>'));
      ExtractLineValue(St);
    end;
  finally
    sl.Free;
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
    sl.text:= ReplaceAll(Html, '><tr class="topbar">', '>'#$D#$A'<tr class="topbar">');
    For i:= 0 to sl.Count-1 do
    begin
      St:= sl[i];
      TournirName:= PrepareTournirName(TakeBE(St, '<tr class="topbar">', '</tr>'), PrztT);
      if TournirName = '' then Continue;
      StatusBar.SimpleText:= SportName+'. '+TournirName;
      ASportId:= dmSwim.GetASportId_byBSportName(BookerId, SportName, TournirName,
        CountrySign, BSportId, TournirId, WaysCnt);
      if ASportId > 0 then
      begin
        if CurBetLineType in [blt2Way12, blt3Way1X2] then
          ExtractLineEvent(St)
        else
          ExtractEvent(St);
      end
    end;
  finally
    sl.Free;
  end;
end;

procedure ExtractDate(Html: String);
var
  sl: TStringList;
  St, S, TagNo: String;
  i: Integer;
begin
  sl:= TStringList.Create;
  try
    sl.Text:= ReplaceAll(Html, '><div class="controlHeaderNoShadow">',  '>'#$D#$A'<div class="controlHeaderNoShadow">');
    ProgressBar.Max:= sl.Count;
    For i:= 0 to sl.Count - 1 do
    begin
      Application.ProcessMessages;
      ProgressBar.StepIt;
      St:= Sl[i];
      StDt:= Trim(DeleteAllBE(TakeBE(St, '<div', '"controlHeaderNoShadow"', '</div>'), '<', '>'));

      if StDt = '' then continue;
      EventDate:= GetEventDate(StDt);
      ExtractTournir(St);
    end;
  finally
    sl.Free;
  end;
end;

begin
  Line:= TNativeXML.Create;
  PrztT:= CreateParazit(Path['Parazit.Tournir']+'BWin.txt');
  PrztG:= CreateParazit(Path['Parazit.Gamer']+'BWin.txt');
  try
    StatusBar.SimpleText:= Format('Разбираем %s.%s', [SportName, LineType]);
    CurBetLineType:= TBetLineType(WordNo(LineType, '1_2;1_X_2;1X_X2_12;TOTAL;FORA;1_2_DEF')+1);
    BookerId:= bwin_id;
    ExtractDate(Html);
  finally
    Line.Free;
    PrztG.Free;
    PrztT.Free;
  end;
end;

end.

