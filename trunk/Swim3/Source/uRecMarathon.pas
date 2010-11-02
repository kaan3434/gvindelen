unit uRecMarathon;

interface

uses
  Classes, NativeXML, ComCtrls;

procedure RecognizeMarathonLine(Html: String; ProgressBar: TProgressBar; StatusBar: TStatusBar);

const
  Marathon_Name='Марафон';
  Marathon_Id=1;

implementation

uses
  dm, GvinStr, GvHtml, SysUtils, Masks, Math, DateUtils, GvHtml2Xml,
  GvinFile, GvinMath, Forms, Dialogs;

procedure KillSecondLine(ndTable: TXmlNode);
var
  ptr, tr: TXmlNode;
  r: Integer;
begin
  For r:= ndTable.NodeCount-1 downto 1 do
  begin
    tr:= ndTable.Nodes[r];
    ptr:= ndTable.Nodes[r-1];
    if Copy(tr.Nodes[2].ValueAsString, 1, 2)='2)' then
    begin
      ptr.Nodes[1].ValueAsString:= ptr.Nodes[1].ValueAsString+' '+ tr.Nodes[1].ValueAsString;
      ptr.Nodes[2].ValueAsString:= ptr.Nodes[2].ValueAsString+'|'+ tr.Nodes[2].ValueAsString;
      tr.Delete;
    end;
  end;
end;

function GetEventDate(St: String): TDateTime;
var
  D, M, Y, H, N: Word;
begin
  D:= StrToInt(TakeFront5(St, ['.','/']));
  M:= StrToInt(TakeFront5(St, [' ','|']));
  Y:= YearOf(Date);
  H:= StrToInt(TakeFront5(St, [':']));
  N:= StrToInt(TakeFront5(St));
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
      '"Событие=Gamers",'+
      '"Поб.1='+btWin1+'",'+
      '"НичьяX='+btDraw+'",'+
      '"Поб.2='+btWin2+'",'+
      '"1X='+btNoLose1+'","1Х='+btNoLose1+'",'+
      '"12='+btNoDraw+'",'+
      '"X2='+btNoLose2+'","Х2='+btNoLose2+'",'+
      '"фора1!кф1='+ctFora1V+'",'+
      '"фора2!кф2='+ctFora2V+'",'+
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

procedure JoinCol(ndTable: TXmlNode; BaseCol, JoinCol: Integer; JoinStr, CellType: String);
var
  tr, td1, td2: TXmlNode;
  i: Integer;
begin
  For i:= 0 to ndTable.NodeCount-1 do
  begin
    tr:= ndTable.Nodes[i];
    if BaseCol >= tr.NodeCount then Exit;
    td1:= tr.Nodes[BaseCol];
    if JoinCol >= tr.NodeCount then Exit;
    td2:= tr.Nodes[JoinCol];
    if (td2.ReadAttributeString(attTitle)<>CellType) then Exit;
    td1.ValueAsString:= td1.ValueAsString+JoinStr+td2.ValueAsString;
    td2.Delete;
  end;
end;

procedure RecognizeMarathonLine(Html: String; ProgressBar: TProgressBar; StatusBar: TStatusBar);
var
  St, BSportName, TournirName, GridHeader: String;
  ndTable, tr: TXmlNode;
  MaxLen, BookerId, ASportId: Integer;
  EmptyCol: Boolean;
  CountrySign: String;
  BSportId, TournirId, WaysCnt: Integer;
  Line: TNativeXml;
  PrztT, PrztG: TStringList;

procedure ExtractEvent(Html: String);
var
  c,l, IndexNo: Integer;
  sl, grid: TStringList;
  Gamer, Gamer1Name, Gamer2Name, Header: String;

procedure DrawVertLine(Col: Integer);
var
  l: Integer;
  st: String;
begin
  For l:= 0 to grid.count-1 do
  begin
    st:= grid[l];
    St[Col]:= '|';
    grid[l]:= st;
  end;
end;

procedure ExtractAdditionalFora(var IndexNo: Integer; Text: String);
var
  Gamer, V, K: String;
begin
  K:= Trim(TakeBack5(Text, ['-']));
  Text:= Trim(Text);
  V:= DeleteChars(TakeBack5(Text, ['(']), [')']);
  Gamer:= Trim(Text);
  if Gamer = Gamer1Name then
    dmSwim.PutFora(IndexNo, btFora1, V, K)
  else
  if Gamer = Gamer2Name then
    dmSwim.PutFora(IndexNo, btFora2, V, K)
  else
    ShowMessage(Gamer);
  Inc(IndexNo);
end;

procedure ExtractAdditionalTotal(var IndexNo: Integer; Header, Text: String);
var
  st, V, K: String;
begin
  V:= CopyBetween(Header, '(', ')');
  st:= TakeFront5(Text, ['.']);
  Text:= SkipFront(Text, [' ', '-']);
  K:= TakeFront5(text, [',']);
  if st = 'мен' then
    dmSwim.PutTotal(IndexNo, btTotLo, V, K)
  else
  if st = 'бол' then
    dmSwim.PutTotal(IndexNo, btTotHi, V, K)
  else
    ShowMessage(St);
  Inc(IndexNo);
end;

begin
  sl:= TStringList.Create;
  grid:= TStringList.Create;
  grid.Add(GridHeader);
  try
    MaxLen:= Length(GridHeader);
    // патчим оставшееся
    St:= ReplaceAll(Html, '<br>',#$D#$A);
    St:= ReplaceAllBE(St, '<sup>', '</sup>', ' ');
    St:= DeleteAllBE(St, '<', '>');
    St:= ReplaceAll(St, '=&gt;', '!');
    sl.Text:= St;

    // добавляем записи с датой и временем в сетку
    For l:= 0 to 1 do
    begin
      st:= sl[0];
      grid.Add(St);
      sl.Delete(0);
      MaxLen:= MaxIntValue([MaxLen, Length(st)]);
    end;

    // Выравниваем все строки по ширине
    For l:= 0 to grid.Count-1 do
      grid[l]:= fillback(grid[l], MaxLen);
    // проводим вертикальные линии пока все символы в столбце #32
    DrawVertLine(7);
    For c:= 10 to MaxLen-1 do
    begin
      EmptyCol:= true;
      For l:= 0 to grid.count-1 do
        EmptyCol:= EmptyCol and (grid[l][c]=#32);
      if EmptyCol then
        DrawVertLine(c);
    end;

    // превращаем таблицу в html таблицу
    Html:= Grid.Text;
    For c:= 30 downto 1 do
    begin
      St:= StringOfChar('|', c);
      Html:= ReplaceAll(Html, St+'|', St+' ');
    end;
    // Объединяем ящейки у которых в header пусто

    Html:= ReplaceAll(Html, '|', '<td>');
    Html:= '<tr><td>'+ReplaceAll(Html, #$D#$A, '</tr>'#$D#$A'<tr><td>')+'</tr>';
    Html:= DeleteDoubleSpace(Html);
    Html:= ReplaceAll(Html, ' <', '<');
    Html:= ReplaceAll(Html, '> ', '>');

    ndTable:= Line.Root;
    try
      TableHtmlToXML(html, ndTable);
      RecognizeHeader(ndTable);
      CopyHeaderToAttribute(ndTable);
      FillAttrForCol(ndTable, 0, attTitle, ctEventDtTm);
      FillAttrForCol(ndTable, 1, attTitle, ctGamers);
      SplitCol(ndTable, ctFora1V, btFora1, ['!']);
      SplitCol(ndTable, ctFora2V, btFora2, ['!']);
      // склеиваем перебитые ячейки
      tr:= ndTable[0];
      while tr[2].ValueAsString = '' do
        JoinCol(ndTable, 1, 2, ' ', '');

      tr:= ndTable[1];
      // Заносим дату события
      St:= tr[1].ValueAsString;
      if (Pos('Угл ', St)<>0) or
         (Pos('ЖК ', St)<>0) or
         (Pos('Хозяева', St)<> 0) or
         (Pos('Гости', St)<> 0)then Exit;
      Gamer:= trim(ndTable[1][1].ValueAsString);
      Gamer1Name:= Copy(Gamer, 3, Length(Gamer));
      Gamer:= trim(ndTable[2][1].ValueAsString);
      Gamer2Name:= Copy(Gamer, 3, Length(Gamer));
      dmSwim.FillEventParam(TournirId,
        GetEventDate(ndTable[1][0].ValueAsString+' '+ndTable[2][0].ValueAsString),
        PrepareGamerName(Gamer1Name, PrztG),
        PrepareGamerName(Gamer2Name, PrztG));
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
    finally
      ndTable.Clear
    end;
    // шманаем оставшеся строки
    dmSwim.ClearBetParam;
    IndexNo:= 0;
    For l:= 0 to sl.Count-1 do
    begin
      st:= trim(sl[l]);
      if IndexNo>8 then
      begin
        dmSwim.PutEvent;
        dmSwim.ClearBetParam;
        IndexNo:= 0;
      end;
      Header:= TakeFront5(St, [':']);
      if Header = 'Победа с учетом форы' then
      begin
        st:= trim(st);
        while st <> '' do
        begin
          ExtractAdditionalFora(IndexNo, TakeFront5(st, [',']));
          st:= trim(st);
        end;
      end
      else
      if (Copy(Header, 1, 11) = 'Тотал матча') and (LastChar(Header)= ')') then
      begin
        st:= trim(st);
        while st<>'' do
        begin
          ExtractAdditionalTotal(IndexNo, Header, TakeFront5(st, [',']));
          st:= trim(st);
        end
      end;
    end;
    if IndexNo>0 then
      dmSwim.PutEvent;
  finally
    grid.Free;
    sl.Free;
  end;
end;

procedure ExtractEvents(Html: String);
var
  sl: TStringList;
  i: Integer;
begin
  Html:= DeleteAll(Html, '<br><hr>');
  sl:= TStringList.Create;
  try
    sl.Text:= ReplaceAll(Html, '<br><br>', #$D#$A);
    For i:= 0 to sl.Count-1 do
      ExtractEvent(sl[i]);
  finally
    sl.Free;
  end;
end;

procedure ExtractGrid(Html: String);
var
  sl: TStringList;
  st: String;
  i: Integer;
begin
  sl:= TStringList.Create;
  try
    repeat
      St:= CopyBSE(Html, '<hr>', '<hr>', '<hr>', false);
      if St <> '' then
      begin
        sl.Add(St);
        Html:= ReplaceAll(Html, St, '<hr>')
      end;
    until St='';
    for i:= 0 to sl.Count-1 do
    begin
      st:= sl[i];
      GridHeader:= TakeBE(St, '<hr>', '<hr>');
      GridHeader:= DeleteAll(GridHeader, '<br><hr>');
      GridHeader:= DeleteAll(GridHeader, '<hr>');
      GridHeader:= ReplaceAll(GridHeader, '=&gt;', '!');
      if pos('<br>', Lowercase(GridHeader)) = 0 then
      begin
        GridHeader:= ' Дата   Событие'+Copy(GridHeader, 16, Length(GridHeader));
        ExtractEvents(St);
      end
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
    sl.Text:= ReplaceAll(Html, '<div class=cap>', #$D#$A'<div class=cap>');

    StatusBar.SimpleText:= 'Определяем группы событий';
    ProgressBar.Max:= sl.Count;
    For i:= 0 to sl.Count - 1 do
    begin
      Application.ProcessMessages;
      ProgressBar.StepIt;
      St:= sl[i];
      if LowerCase(CopyFront4(St)) <> '<div' then continue;
      TournirName:= PrepareTournirName(TakeBE(St, '<div ', '</div>'), PrztT);
      BSportName:= Trim(TakeFront5(TournirName, ['.']));
      TournirName:= Trim(TournirName);
      StatusBar.SimpleText:= BSportName+'. '+TournirName;

      ASportId:= dmSwim.GetASportId_byBSportName(BookerId, BSportName, TournirName,
        CountrySign, BSportId, TournirId, WaysCnt);
      if ASportId > 0 then
      begin
        St:= CopyBetween(St, '<pre>', '</pre>');
        ExtractGrid(St);
      end;
    end;
  finally
    sl.Free;
  end;
end;

begin
  Line:= TNativeXml.CreateName('Node');
  PrztT:= CreateParazit(Path['Parazit.Tournir']+'Marathon.txt');
  PrztG:= CreateParazit(Path['Parazit.Gamer']+'Marathon.txt');
  try
    BookerId:= Marathon_Id;
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
