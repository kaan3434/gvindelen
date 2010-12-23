unit uRecBetBy;

interface
uses
  Classes, NativeXML, SysUtils, uSwimCommon, GvVars;

const
  Booker_Id=6;

var
  DMSwimIntf: IDMSwim;
  Path: TVarList;

procedure RecognizeBetByLine;

implementation

uses
  GvStr, DateUtils, GvHtml2Xml, GvFile;

procedure RecognizeBetByLine;
var
  Line: TNativeXML;
  PrztT, PrztG: TStringList;
  Booker_Name: String;
  BSportName, TournirName: String;
  ASportId: Integer;
  BSportId, TournirId, WaysCnt: Integer;

function GetEventDate(St: String): TDateTime;
var
  D, M, Y, H, N: Word;
begin
  D:= StrToInt(TakeFront5(St, './'));
  M:= StrToInt(TakeFront5(St, ' '));
  Y:= YearOf(Date);
  H:= StrToInt(TakeFront5(St, ':'));
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

procedure ExtractLineEvent(Html: String);
var
  ndTable, tr, td: TXmlNode;
  r: Integer;
  iDate, iTime, iGamer1, iGamer2: Integer;
  St: string;
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
        St:= FillEventParam(TournirId,
          GetEventDate(tr[iDate].ValueAsString+' '+tr[iTime].ValueAsString),
          PrepareGamerName(tr[iGamer1].ValueAsString, PrztG),
          PrepareGamerName(tr[iGamer2].ValueAsString, PrztG));
        try
          St:= St + PutBet(0, btWin1, tr, WaysCnt);
          St:= St + PutBet(1, btWin2, tr, WaysCnt);
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
    DMSwimIntf.InitProgressBar(sl.Count);
    For i:= 0 to sl.Count - 1 do
    begin
      DMSwimIntf.StepProgressBar;
      St:= sl[i];
      if LowerCase(copy(St, 1, 3)) <> '<h1' then continue;
      TournirName:= TakeBE(St, '<h1 ', '</td>');
      TournirName:= PrepareTournirName(TournirName, PrztT);
      BSportName:= Trim(TakeFront5(TournirName, '.'));
      TournirName:= Trim(TournirName);
      DMSwimIntf.UpdateStatusBar(BSportName+'. '+TournirName);

      ASportId:= DMSwimIntf.GetASportId_byBSportName(Booker_Id, PChar(BSportName), PChar(TournirName),
        BSportId, TournirId, WaysCnt);
      if ASportId > 0 then
        ExtractLineEvent(St);
    end;
  finally
    sl.Free;
  end;
end;

procedure RecognizePart;
var
  FName, Html: String;
begin
  FName:= Format('%s%s.html', [Path['Lines'], Booker_Name]);
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
    RecognizePart;
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
