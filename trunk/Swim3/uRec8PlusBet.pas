unit uRec8PlusBet;

interface
uses
  Classes, NativeXML, ComCtrls;

const
  EightPlusBet_Name= '8 Плюс';
  EightPlusBet_Id=9;

procedure Recognize8PlusBetLine(Html: String; Line: TNativeXML; StatusBar: TStatusBar);

implementation
uses
  regExpr,dm, GvinStr, GvHtml, SysUtils, Masks, Math, DateUtils, 
  GvinFile, GvinMath;

procedure KillIndividualTotal(ndTable: TXmlNode);
var
  i, Index: integer;
  tr, td: TXmlNode;
begin
  For i:= 0 to ndTable.NodeCount-1 do
  begin
    tr:= ndTable.Nodes[i];
    td:= tr.NodeByAttributeValue(nnTd, attTitle, 'IT');
    if td<>nil then
    begin
      Index:= td.IndexInParent;
      td.ValueAsString:= '';
      tr.Nodes[Index+2].Delete;
      tr.Nodes[Index+1].Delete;
      td.Delete;
    end;
  end;
end;


procedure RecognizeHeader(ndTable: TXmlNode);
var
  c: Integer;
  th, tdh: TXmlNode;
  Caption: String;
  WayCnt: Integer;
  Titles: TStringList;
begin
  th:= ndTable.Nodes[0];
  if th = nil then Exit;
  // определяем типы колонок
  Titles:= TStringList.Create;
  try
    Titles.CommaText:=
      '"Дата=EventDt",'+
      '"Название='+nnGamer1+'",'+
      '"П1='+btWin1+'",'+
      '"Н='+btDraw+'",'+
      '"П2='+btWin2+'",'+
      '"1X='+btNoLose1+'","12='+btNoDraw+'","X2='+btNoLose2+'",'+
      '"1Х='+btNoLose1+'","Х2='+btNoLose2+'",'+
      '"Ф1='+ctFora1V+'",'+
      '"K1='+btFora1+'",'+
      '"К1='+btFora1+'",'+
      '"Ф2='+ctFora2V+'",'+
      '"K2='+btFora2+'",'+
      '"К2='+btFora2+'",'+
      '"Тот='+ctTotV+'","Мен='+btTotLo+'","Бол='+btTotHi+'"';

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
  // определяем исходность события
  WayCnt:= IfThenElse(th.NodeByAttributeValue(nnTd, attTitle, btDraw)=nil, 2, 3);
  tdh:= th.NodeByAttributeValue(nnTd, attTitle, btWin1);
  if tdh<>nil then
    tdh.WriteAttributeInteger(attWays, WayCnt);
  tdh:= th.NodeByAttributeValue(nnTd, attTitle, btWin2);
  if tdh<>nil then
    tdh.WriteAttributeInteger(attWays, WayCnt);
end;

procedure DoubleFora(Table: TXmlNode;TitleV,TitleK,Header: String);
var
 i,j :Integer;
 tr,tr2, td,td2, tdh: TXmlNode;
 IdxV, IdxK, IdxH, IdxG1, IdxG2,IdxDt,CountCells: Integer;
begin
 tr:= Table.Nodes[0];
 if tr = nil then Exit;

 tdh:= tr.NodeByAttributeValue(nnTd,attTitle,TitleV);
 if tdh=nil then Exit;
 IdxV:= tdh.IndexInParent;

 tdh:= tr.NodeByAttributeValue(nnTd,attTitle,TitleK);
 if tdh=nil then Exit;
 IdxK:= tdh.IndexInParent;

 tdh:= tr.NodeByAttributeValue(nnTd,attTitle,nnGamer1);
 if tdh=nil then Exit;
 IdxG1:= tdh.IndexInParent;

 tdh:= tr.NodeByAttributeValue(nnTd,attTitle,nnGamer2);
 if tdh=nil then Exit;
 IdxG2:= tdh.IndexInParent;

 tdh:= tr.NodeByAttributeValue(nnTd,attTitle,'EventDt');
 if tdh=nil then Exit;
 IdxDt:= tdh.IndexInParent;

 CountCells:= tr.NodeCount;

 for i:= tr.NodeCount-1 downto IdxK do
 begin
   td:= tr.Nodes[i];
   IdxH:=i;
   if td.ValueAsString = Header then
   begin
     tr.Nodes[IdxH].ValueAsString:='';
     Break;
   end;  
 end;

 if IdxK = IdxH then Exit;

 for i:=Table.NodeCount - 1 downto 1 do
 begin
   tr:= Table.Nodes[i];
   if  (tr.Nodes[IdxH].IsEmpty)or (Tr = nil) then Continue;
   Tr2:=Table.NodeNew(nnTr);
   for j:=0 to CountCells - 1 do
   begin
     Td2:=Tr2.NodeNew(nnTd);
     if Tr.Nodes[j].ReadAttributeString(attTitle)<>'' then
       Td2.WriteAttributeString(attTitle,tr.Nodes[j].ReadAttributeString(attTitle));
   end;
   Tr2.Nodes[IdxDt].ValueAsString:= Tr.Nodes[IdxDt].ValueAsString;
   Tr2.Nodes[IdxG1].ValueAsString:= Tr.Nodes[IdxG1].ValueAsString;
   Tr2.Nodes[IdxG2].ValueAsString:= Tr.Nodes[IdxG2].ValueAsString;

//   if Tr2.Nodes[IdxV].ValueAsString<>'' then
     Tr2.Nodes[IdxV].ValueAsFloat:= Tr.Nodes[IdxV].ValueAsFloat + StrToFloat(Header);

   Tr2.Nodes[IdxK].ValueAsString:= Tr.Nodes[IdxH].ValueAsString;
   Tr.Nodes[IdxH].ValueAsString:='';

//   Tr.Nodes[IdxH].
 end;


end;

procedure Recognize8PlusBetLine(Html: String; Line: TNativeXML; StatusBar: TStatusBar);
var
  St, Sport_Name: String;
  ndSport, ndEvents, ndEvent, ndBets, ndTable, tr, td: TXmlNode;
  sl: TStringList;
  i,r, AbsSport_Id, Bookmaker_Id: Integer;
  Tournir_Sex: String;
  Country_Id, Sport_Id: Integer;
  Y,M,D,H,N: Word;
  EventDate: TDateTime;
  Tournir_Name:String;
  Delta: Real;
begin
  Bookmaker_Id:= dmSwim.BookmakerId(EightPlusBet_Name);
  sl:= TStringList.Create;
  Line.Clear;
  Line.Root.Name:= 'Root';
  Line.Root.WriteAttributeInteger('Bookmaker_Id', Bookmaker_Id);
  try
    StatusBar.SimpleText:= 'Разбираемся с концами строк';
    Html:= CopyBeginEnd(Html, '<form id=''LineView''', '</form>', true);
    Html:= DeleteChars(Html, [#$D, #$A, #$9]);
    Html:= ReplaceAll(Html, #150, '-', true);
    Html:= ReplaceAll(Html, #151, '-', true);
    Html:= ReplaceAll(Html, '&nbsp;', #32, true);

    Html:= ReplaceAll(Html, '<br>', '', true);

    StatusBar.SimpleText:= 'Удаляем <b> и </b>';
    Html:= DeleteAll(Html, '<b>', true);
    Html:= DeleteAll(Html, '</b>', true);
    Html:= DeleteAll(Html, '<b ', '>', true);

    StatusBar.SimpleText:= 'Удаляем <a .*?> и </a>';
    Html:= DeleteAll(Html, '<a ', '>', true);
    Html:= DeleteAll(Html, '</a>', true);

    StatusBar.SimpleText:= 'Удаляем <s .*?> и </s>';
    Html:= DeleteAll(Html, '<s>', true);
    Html:= DeleteAll(Html, '</s>', true);

    StatusBar.SimpleText:= 'Удаляем <img .*?>';
    Html:= DeleteAll(Html, '<img ', '>', true);

    StatusBar.SimpleText:= 'Удаляем <colgroup .*?>';
    Html:= DeleteAll(Html, '<colgroup ', '>', true);

    StatusBar.SimpleText:= 'Удаляем <small> и </small>';
    Html:= DeleteAll(Html, '<small>', true);
    Html:= DeleteAll(Html, '</small>', true);

    Html:= DeleteAll(Html, '<Input ','>',True);

    StatusBar.SimpleText:= 'Удаляем <span *> и </span>';
    Html:= DeleteAll(Html, '<span class=tr>', '</span>', true);
    Html:= DeleteAll(Html, '<span ','>', true);
    Html:= DeleteAll(Html, '</span>', true);

    StatusBar.SimpleText:= 'Удаляем аттрибуты';
    Html:= DeleteAllAttribute(Html, 'width');
    Html:= DeleteAllAttribute(Html, 'border');
    Html:= DeleteAllAttribute(Html, 'id');
    Html:= DeleteAllAttribute(Html, 'frame');
    Html:= DeleteAllAttribute(Html, 'rules');
    Html:= DeleteAllAttribute(Html, 'align');
    Html:= DeleteAllAttribute(Html, 'valign');
    Html:= DeleteAllAttribute(Html, 'bordercolorlight');
    Html:= DeleteAll(Html, ' border');
    Html:= DeleteAll(Html, '[оглавление]');

    Html:= DeleteAllAttribute(Html, 'bgcolor');

    StatusBar.SimpleText:= 'Удаляем <Font *> и </font>';
    Html:= DeleteAll(Html, '<Font ','>', true);
    Html:= DeleteAll(Html, '</Font>', true);

    Html:= DeleteAllAttribute(Html, 'style');
    Html:= DeleteAll(Html, ' noWrap',True);
    Html:= DeleteAllAttribute(Html, 'class');

    StatusBar.SimpleText:= 'Подчищаем таблицы';
    Html:=DeleteDoubleSpace(Html);
    Html:= ReplaceAll(Html, ' >', '>', true);
    Html:= ReplaceAll(Html, '> ', '>', true);
    Html:= ReplaceAll(Html, ' <', '<', true);

    Html:= ReplaceAll(Html,'</p><p>','<br>',True);
    Html:= DeleteAll(Html,'</p>',True);
    Html:= DeleteAll(Html,'<p>',True);

    Html:= DeleteAll(Html,'<form ','>',True);
    Html:= DeleteAll(Html, '<div>', '</form>', true);
    // Разделение игроков
    Html:= ReplaceAll(Html,'>1) ','>',True);
    Html:= ReplaceAll(Html,'2) ','|',True);

    Html:= ReplaceAll(Html, '<br>', #$D#$A, true);

    sl.Text:= Html;
   // sl.SaveToFile('D:\SWIM\8PlusBet\8PlusBet.htm');


    For i:= 0 to sl.count-1 do
    begin
      Html:= sl[i];
      Tournir_Name:= (Trim(TakeBeginEnd(Html,'<Table>','</Table>',True)));
      Tournir_Name:=DeleteAll(Tournir_Name,'<','>',True);

      Sport_Name:=Trim(TakeFront5(Tournir_Name, ['.']));
      Tournir_Name:= Trim(Tournir_Name);
      Html:=DeleteAll(Html, '<table>', true);
      Html:=DeleteAll(Html, '</table>', true);
      AbsSport_Id:= dmSwim.GetAbsSportId(Bookmaker_ID, Sport_Name, Tournir_Name,Country_Id, Tournir_Sex, Sport_Id);
      if AbsSport_Id>=0 then
      begin
        ndSport:= Line.Root.NodeNew('Sport');
        ndSport.WriteAttributeInteger('Bookmaker_Id', Bookmaker_Id);
        ndSport.WriteAttributeInteger('AbsSport_Id', AbsSport_Id);
        ndSport.WriteAttributeInteger('Sport_Id', Sport_Id);
        ndSport.AttributeByName['Sport']:= Sport_Name;
        if Country_Id>0 then
          ndSport.WriteAttributeInteger('Country_Id', Country_Id);
        if trim(Tournir_Sex)<>'' then
          ndSport.WriteAttributeString('Sex', Tournir_Sex);
        ndSport.ValueAsString:= Tournir_Name;

        ndTable:= ndSport.NodeNew(nnTable);


        TableHtmlToXML(html, ndTable);
        KillRowIfCol(ndTable, 0, tcaEmpty, '');
        KillRowIfCol(ndTable, 3, tcaEqualSt, 'Исход встречи');
        KillRowIfCol(ndTable, 3, tcaContainSt, 'Прием');
        RecognizeHeader(ndTable);
        CopyHeaderToAttribute(ndTable);
        SplitCol(ndTable, nnGamer1, nnGamer2, ['|']);

        Delta:= 4;
        while Delta >=-4 do
        begin
          If Delta < 0 then
          begin
            DoubleFora(ndTable,ctTotV,btTotLo,Format('%3.1f',[Delta]));
            DoubleFora(ndTable,ctTotV,btTotHi,Format('%3.1f',[Delta]));
            DoubleFora(ndTable,ctFora2V,btFora2,Format('%3.1f',[Delta]));
            DoubleFora(ndTable,ctFora1V,btFora1,Format('%3.1f',[Delta]))
          end
          else
          If Delta > 0 then
          begin
            DoubleFora(ndTable,ctTotV,btTotLo,Format('+%3.1f',[Delta]));
            DoubleFora(ndTable,ctTotV,btTotHi,Format('+%3.1f',[Delta]));
            DoubleFora(ndTable,ctFora2V,btFora2,Format('+%3.1f',[Delta]));
            DoubleFora(ndTable,ctFora1V,btFora1,Format('+%3.1f',[Delta]));
          end;

          Delta:= Delta - 0.5
        end;
        KillRowIfCol(ndTable,0,tcaEqualSt,'Дата');
        ndSport.NodeNew('Events');
      end;
    end;
    StatusBar.SimpleText:= 'Разносим коэффициенты по событиям';
    For i:= Line.Root.NodeCount-1 downto 0 do
    begin
      ndSport:= Line.Root.Nodes[i];
      ndTable:= ndSport.NodeByName(nnTable);
      ndEvents:= ndSport.NodeByName(nnEvents);
      For r:= 0 to ndTable.NodeCount-1 do
      begin
        tr:= ndTable.Nodes[r];
        ndEvent:= ndEvents.NodeNew(nnEvent);
        // Заносим дату события
        td:= tr.NodeByAttributeValue(nnTd, attTitle, 'EventDt');
        if td<>nil then
        begin
          St:= td.ValueAsString;
          D:= StrToInt(TakeFront5(St, ['.', '/']));
          St:=Trim(St);
          M:= StrToInt(St[1]+St[2]);
          Delete(St,1,2);

          H:= StrToInt(TakeFront5(St, [':']));
          N:= StrToInt(St);
          Y:= YearOf(Now);
          EventDate:= EncodeDateTime(Y,M,D,H,N,0,0);
          if Abs(DaysBetween(Date, EventDate))>Abs(DaysBetween(Date, IncYear(EventDate))) then
            EventDate:= IncYear(EventDate);
          ndEvent.NodeFindOrCreate(nnDate).ValueAsDateTime:= EventDate;
        end;
        //Заносим участников события
        td:= tr.NodeByAttributeValue(nnTd,attTitle, nnGamer1);
        if td<>nil then
          ndEvent.NodeFindOrCreate(nnGamer1).ValueAsString:= PrepareGamerName(td.ValueAsString);
        td:= tr.NodeByAttributeValue(nnTd,attTitle, nnGamer2);
        if td<>nil then
          ndEvent.NodeFindOrCreate(nnGamer2).ValueAsString:= PrepareGamerName(td.ValueAsString);

        ndBets:= ndEvent.NodeNew(nnBets);
        PutBet(btWin1, tr, ndBets);
        PutBet(btWin2, tr, ndBets);
        PutBet(btDraw, tr, ndBets);
        PutBet(btNoLose1, tr, ndBets);
        PutBet(btNoLose2, tr, ndBets);
        PutBet(btNoDraw, tr, ndBets);

        PutTotal(btTotLo, tr, ndBets);
        PutTotal(btTotHi, tr, ndBets);


        PutFora(btFora1, tr, ndBets);
        PutFora(btFora2, tr, ndBets);

       end;
      ndTable.Delete;
    end;
    StatusBar.SimpleText:= 'Html 8 Плюс распознан';
  finally
    sl.Free;
  end;
end;

end.
