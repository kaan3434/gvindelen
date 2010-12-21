unit uRecBetCity;

interface

uses
  Classes, NativeXML, SysUtils, uSwimCommon, GvVars;

const
  Booker_Id=4;

var
  DMSwimIntf: IDMSwim;
  Path: TVarList;

procedure RecognizeBetCityLine;

implementation

uses
  GvStr, DateUtils, GvHtml2Xml, GvFile;

procedure RecognizeBetCityLine;
var
  Line: TNativeXML;
  PrztT, PrztG: TStringList;
  Booker_Name: String;
  EventDate: TDateTime;
  BSportName, TournirName: String;
  ASportId: Integer;
  BSportId, TournirId, WaysCnt: Integer;

function GetEventDate(St: String): TDateTime;
var
  D, M, Y: Word;
  Mns: String;
begin
  if Pos(' ', St) = 0 then
  begin
    D:= StrToInt(TakeFront5(St, '.'));
    M:= StrToInt(TakeFront5(St, '.'));
    Y:= StrToInt(TakeFront5(St, '.'));
  end
  else
  begin
    D:= StrToInt(TakeFront5(St, ', '));
    Mns:= AnsiLowerCase(TakeFront5(St));
    Y:= StrToInt(TakeFront5(St));
    M:= WordNo(Mns, 'января;февраля;марта;апреля;мая;июня;июля;августа;сентября;октября;ноября;декабря')+1;
  end;
  Result:= EncodeDate(Y, M, D)
end;

function GetEventTime(St: String): TDateTime;
var
  H, N: Word;
begin
  H:= StrToInt(TakeFront5(St, ':'));
  N:= StrToInt(St);
  result:= EncodeTime(H, N, 0, 0);
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
  // определяем типы колонок
  Titles:= TStringList.Create;
  try
    Titles.CommaText:=
      '"ВРЕМЯ='+ctEventDtTm+'",'+
      '"КОМАНДА 1='+ctGamer1+'","КОМАНДА1='+ctGamer1+'",'+
      '"ИГРОК 1='+ctGamer1+'","ИГРОК1='+ctGamer1+'",'+
      '"СПОРТСМЕН 1='+ctGamer1+'","СПОРТСМЕН1='+ctGamer1+'",'+
      '"УЧАСТНИК 1='+ctGamer1+'","УЧАСТНИК1='+ctGamer1+'",'+
      '"КОМАНДА 2='+ctGamer2+'","КОМАНДА2='+ctGamer2+'",'+
      '"ИГРОК 2='+ctGamer2+'","ИГРОК2='+ctGamer2+'",'+
      '"СПОРТСМЕН 2='+ctGamer2+'","СПОРТСМЕН2='+ctGamer2+'",'+
      '"УЧАСТНИК 2='+ctGamer2+'","УЧАСТНИК2='+ctGamer2+'",'+
      '"1='+btWin1+'","Поб.1='+btWin1+'",'+
      '"X='+btDraw+'","Х='+btDraw+'",'+
      '"2='+btWin2+'","Поб.2='+btWin2+'",'+
      '"1X='+btNoLose1+'","1Х='+btNoLose1+'","12='+btNoDraw+'","X2='+btNoLose2+'","Х2='+btNoLose2+'",'+
      '"ФОРА=FV","КФ=FK","ФОРА 1='+ctFora1V+'","ФОРА1='+ctFora1V+'",'+
      '"ФОРА 2='+ctFora2V+'","ФОРА2='+ctFora2V+'",'+
      '"ТОТАЛ='+ctTotV+'","ТОТАЛ(РАУНДОВ)='+ctTotV+'","МЕН='+btTotLo+'","БОЛ='+btTotHi+'"';
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
end;

procedure ExtractLineEvent(Html: String);
var
  ndTable, tr: TXmlNode;
  iDate, iGamer1, iGamer2,
  r: Integer;
  St: String;
begin
  ndTable:= Line.Root;
  try
    TableHtmlToXML(html, ndTable);
    KillRowIfCol(ndTable, 0, tcaEmpty);
    RecognizeHeader(ndTable);
    CopyHeaderToAttribute(ndTable);
    KillRowIfCol(ndTable, 0, tcaEqualSt, 'ВРЕМЯ');

    tr:= ndTable.Nodes[0];
    try
      iDate:= tr.NodeByAttributeValue(nnTd, attTitle, ctEventDtTm).IndexInParent;
      iGamer1:= tr.NodeByAttributeValue(nnTd,attTitle, ctGamer1).IndexInParent;
      iGamer2:= tr.NodeByAttributeValue(nnTd,attTitle, ctGamer2).IndexInParent;

      for r:= 0 to ndTable.NodeCount-1 do
      begin
        tr:= ndTable.Nodes[r];
        st:= FillEventParam(TournirId,
          EventDate+GetEventTime(tr[iDate].ValueAsString),
          PrepareGamerName(tr[iGamer1].ValueAsString, PrztG),
          PrepareGamerName(tr[iGamer2].ValueAsString, PrztG));
        try
          st:= st+PutBet(0, btWin1, tr, WaysCnt);
          st:= st+PutBet(1, btWin2, tr, WaysCnt);
          if WaysCnt = 3 then
          begin
            St:= St + PutBet(2, btDraw, tr, 3);
            St:= St + PutBet(3, btNoLose1, tr, 3);
            St:= St + PutBet(4, btNoDraw, tr, 3);
            St:= St + PutBet(5, btNoLose2, tr, 3);
          end;
          St:= St + PutTotal(6, btTotLo, tr);
          St:= St + PutTotal(7, btTotHi, tr);
          St:= St + PutFora(8, btFora1, tr);
          St:= St + PutFora(9, btFora2, tr);
        except
        end;

        DMSwimIntf.PutEvent(PChar(St));
      end;
    except
      SaveStringAsFile('error.txt', St);
    end;
  finally
    ndTable.Clear;
  end;
end;

procedure ExtractDate(Html: String);
var
  sl: TStringList;
  i: Integer;
  St, StDt: String;
begin
  sl:= TStringList.Create;
  try
    sl.Text:= ReplaceAll(Html, '><tbody class=date>', '>'#$D#$A'<tbody class=date>');
    for i:= 0 to sl.Count-1 do
    begin
      St:= sl[i];
      StDt:= TakeBE(St, '<tbody ', '</tbody>');
      StDt:= DeleteAllBE(StDt, '<', '>');
      EventDate:= GetEventDate(StDt);
      ExtractLineEvent(St);
    end
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
    sl.Text:= ReplaceAll(Html, '><table ', '>'#$D#$A'<table ');
    DMSwimIntf.InitProgressBar(sl.Count);
    For i:= 0 to sl.Count - 1 do
    begin
      DMSwimIntf.StepProgressBar;
      St:= sl[i];
      if LowerCase(Copy(St,1, 6)) <> '<table' then Continue;
      TournirName:= PrepareTournirName(TakeBE(St, '<thead>', '</thead>'), PrztT);
      BSportName:= TakeFront5(TournirName, '.');
      TournirName:= Trim(TournirName);
      DMSwimIntf.UpdateStatusBar(BSportName+'. '+TournirName);

      ASportId:= DMSwimIntf.GetASportId_byBSportName(Booker_Id, PChar(BSportName), PChar(TournirName),
        BSportId, TournirId, WaysCnt);
      if ASportId > 0 then
      begin
        St:= DeleteAllBE(St, '<table ', '>');
        ExtractDate(St);
      end;
    end;
  finally
    sl.Free;
  end;
end;

procedure RecognizePart(SportName: String);
var
  FName, Html: String;
begin
  FName:= Format('%s%s.%s.html', [Path['Lines'], Booker_Name, SportName]);
  if FileExists(FName) then
  begin
    Html:= LoadFileAsString(FName);
    if Html<>'' then
      ExtractTournir(Html);
      DMSwimIntf.InitProgressBar(100);
      DMSwimIntf.UpdateStatusBar('');
  end;
end;

begin
  Booker_Name:= DMSwimIntf.Booker_Name(Booker_Id);
  Line:= TNativeXml.CreateName('Table');
  PrztT:= CreateParazit(Path['Parazit.Tournir']+Booker_Name+'.txt');
  PrztG:= CreateParazit(Path['Parazit.Gamer']+Booker_Name+'.txt');
  try
    RecognizePart('Футбол');
    RecognizePart('Теннис');
    RecognizePart('Баскетбол');
    RecognizePart('Волейбол');
    RecognizePart('Гандбол');
    RecognizePart('Футзал');
  finally
    Line.Free;
    PrztG.Free;
    PrztT.Free;
  end;
end;


initialization
  Path:= TVarList.Create;
  Path.LoadSectionFromIniFile(ProjectIniFileName, 'Path');
  Path.Text:= StringReplace(Path.Text, '=.\', '='+ExtractFilePath(ParamStr(0)),[rfReplaceAll]);
  Path['Self']:= ExtractFilePath(ParamStr(0));
finalization
  Path.Free;
end.
