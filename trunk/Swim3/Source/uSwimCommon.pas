unit uSwimCommon;

interface

uses
  Classes, SysUtils, NativeXml, GvVars;

type
  IDMSwim = interface ['{58A19A8B-DE31-4466-8732-21BB5CEB0DE0}']
    function Booker_Name(BookerId: Integer): ShortString;
    procedure UpdateStatusBar(aText: ShortString);
    procedure StepProgressBar;
    procedure InitProgressBar(aMaxValue: Integer);

    function GetASportId_byBSportName(BookerId: Integer; BSportName, TournirName: PChar;
      var BSportId, TournirId, Ways: Integer): integer;

    function PutEvent(aSt: PChar): Integer;
  end;

const
  ctEventDtTm='EventDtTm';
  ctGamers='Gamers';
  ctGamer1='Gamer1';
  ctGamer2='Gamer2';
  ctTotV='TV';
  ctFora1V='F1V';
  ctFora2V='F2V';

  btWin1='1';
  btWin2='2';
  btDraw='X';
  btNoLose1='1X';
  btNoDraw='12';
  btNoLose2='X2';
  btTotLo='TL';
  btTotHi='TH';
  btFora1='F1';
  btFora2='F2';

  nnTable='Table';
   nnTr='tr';
    nnTd='td'; attTitle='Title';

type
  TCompareAction=(tcaEmpty, tcaNoEmpty, tcaEqualSt, tcaContainSt,
    tcaNoContainSt, tcaInteger, tcaNoInteger, tcaAttributeEq);

procedure CopyHeaderToAttribute(ndTable: TXmlNode; Row: Integer=0);
procedure FillAttrForCol(ndTable: TXmlNode; ColNo: Integer;
  AttributeName, AttributeValue: String;
  AttributeName2:String=''; AttributeValue2: String='');
procedure KillRowIfCol(ndTable: TXmlNode; ColNo: Integer;
  Action: TCompareAction; Value: String=''; AttributeName: String='');
procedure ClearCellIfCol(ndTable: TXmlNode; ConditionTitle: String;
  Action: TCompareAction; Value, AttributeName, ClearTitle: String);
procedure SplitColKeyChar(ndTable: TXmlNode; Title, Title2, KeyChar: String);
procedure SplitColKeyString(ndTable: TXmlNode; Title, Title2, KeyString: String);

function NormalizeName(Name: String): String;
function PrepareTournirName(Tournir_Name: String; Parazits: TStrings): String;
function PrepareGamerName(GamerName: String; Parazits: TStrings): String;

function CreateParazit(FName: String): TStringList;

function FillEventParam(TournirId: Integer; EventDtTm: TDateTime;
  Gamer1Name, Gamer2Name: String): string;
procedure ClearBetParam(sl: TStringList);

function PutBet(IndexNo: Integer; BetTypeSign, Koef: String;
  Ways: Integer): String; overload;
function PutBet(IndexNo: Integer; BetTypeSign: String; tr: TXmlNode;
  Ways: Integer): String; overload;
function PutTotal(IndexNo: Integer; BetTypeSign, Value, Koef: String): String; overload;
function PutTotal(IndexNo: Integer; BetTypeSign: String; tr: TXmlNode): String; overload;
function PutFora(IndexNo: Integer; BetTypeSign, Value, Koef: String): String; overload;
function PutFora(IndexNo: Integer; BetTypeSign: String; tr: TXmlNode): String; overload;



implementation

uses
  GvStr;

procedure CopyHeaderToAttribute(ndTable: TXmlNode; Row: Integer=0);
var
  r, c, a, ColCount: Integer;
  th, tr, thn, td: TXmlNode;
  Name: String;
begin
  th:= ndTable.Nodes[Row];
  if th = nil then Exit;
  ColCount:= th.NodeCount;
  for r:= Row+1 to ndTable.NodeCount-1 do
  begin
    tr:= ndTable.Nodes[r];
    while tr.NodeCount<ColCount do tr.NodeNew(nnTd);
    For c:= 0 to ColCount-1 do
    begin
      thn:= th.Nodes[c];
      td:= tr.Nodes[c];
      For a:= 0 to thn.AttributeCount-1 do
      begin
        Name:= thn.AttributeName[a];
        td.AttributeByName[Name]:= thn.AttributeValue[a];
      end;
    end;
  end;
end;

procedure FillAttrForCol(ndTable: TXmlNode; ColNo: Integer;
  AttributeName, AttributeValue: String; AttributeName2:String=''; AttributeValue2: String='');
var
  td: TXmlNode;
  r: Integer;
begin
  For r:= 0 to ndTable.NodeCount-1 do
  begin
    td:= ndTable.Nodes[r].Nodes[ColNo];
    if td <> nil then
    begin
      td.writeAttributeString(AttributeName, AttributeValue);
      if AttributeName2<>'' then
        td.writeAttributeString(AttributeName2, AttributeValue2);
    end;
  end;
end;

function IsInteger(St: string): Boolean;
var
  i, r: integer;
begin
  Val(St, i, r);
  Result:= r = 0
end;

procedure KillRowIfCol(ndTable: TXmlNode; ColNo: Integer;
  Action: TCompareAction; Value: String=''; AttributeName: String='');
var
  tr, td: TXmlNode;
  r: Integer;
  KillRow: Boolean;
begin
  For r:= ndTable.NodeCount-1 downto 0 do
  begin
    tr:= ndTable.Nodes[r];
    KillRow:= false;
    while tr.NodeCount<ColNo+1 do
      tr.NodeNew(nnTd);
    td:= tr.Nodes[ColNo];
    if td=nil then continue;
    Case Action of
      tcaEmpty,
      tcaEqualSt:
        KillRow:= trim(td.ValueAsString)=Value;
      tcaNoEmpty:
        KillRow:= trim(td.ValueAsString)<>Value;
      tcaContainSt:
        KillRow:= Pos(Value, td.ValueAsString)>0;
      tcaNoContainSt:
        KillRow:= Pos(Value, td.ValueAsString)=0;
      tcaAttributeEq:
        KillRow:= td.AttributeByName[AttributeName]=Value;
      tcaInteger:
        KillRow:= (td.ValueAsString<>'') and IsInteger(td.ValueAsString);
      tcaNoInteger:
        KillRow:= (td.ValueAsString<>'') and Not IsInteger(td.ValueAsString);
    end;
    if KillRow then
      tr.Delete;
  end;
end;

procedure ClearCellIfCol(ndTable: TXmlNode; ConditionTitle: String;
  Action: TCompareAction; Value, AttributeName, ClearTitle: String);
var
  tr, td: TXmlNode;
  r: Integer;
  ClearCell: Boolean;
begin
  For r:= ndTable.NodeCount-1 downto 0 do
  begin
    tr:= ndTable.Nodes[r];
    ClearCell:= false;
    td:= tr.NodeByAttributeValue(nnTd, attTitle, ConditionTitle);
    if td=nil then continue;
    Case Action of
      tcaEmpty,
      tcaEqualSt:
        ClearCell:= trim(td.ValueAsString)=Value;
      tcaNoEmpty:
        ClearCell:= trim(td.ValueAsString)<>Value;
      tcaContainSt:
        ClearCell:= Pos(Value, td.ValueAsString)>0;
      tcaNoContainSt:
        ClearCell:= Pos(Value, td.ValueAsString)=0;
      tcaAttributeEq:
        ClearCell:= td.AttributeByName[AttributeName]=Value;
      tcaInteger:
        ClearCell:= (td.ValueAsString<>'') and IsInteger(td.ValueAsString);
      tcaNoInteger:
        ClearCell:= (td.ValueAsString<>'') and Not IsInteger(td.ValueAsString);
    end;
    if ClearCell then
    begin
      td:= tr.NodeByAttributeValue(nnTd, attTitle, ClearTitle);
      if td<>nil then
        td.ValueAsString:= '';
    end;
  end;
end;


procedure SplitColKeyChar(ndTable: TXmlNode; Title, Title2, KeyChar: String); overload;
var
  i, idx: Integer;
  tr, td, td2: TXmlNode;
  St: String;
begin
  td:= ndTable.NodeFindOrCreate(nnTr).NodeByAttributeValue(nnTd, attTitle, Title);
  if td=nil then Exit;
  idx:= td.IndexInParent;
  For i:= 0 to ndTable.NodeCount-1 do
  begin
    tr:= ndTable[i];
    td:= tr[idx];
    St:= td.ValueAsString;
    td.ValueAsString:= TakeFront5(St, KeyChar);
    td2:= tr.NodeNewAtIndex(idx+1, td.Name);
    td2.Assign(td);
    td2.ValueAsString:= St;
    td2.WriteAttributeString(attTitle, Title2);
  end;
end;

procedure SplitColKeyString(ndTable: TXmlNode; Title, Title2, KeyString: String); overload;
var
  i, idx, p, lsp: Integer;
  tr, td, td2: TXmlNode;
  St: String;
begin
  td:= ndTable.NodeFindOrCreate(nnTr).NodeByAttributeValue(nnTd, attTitle, Title);
  if td=nil then Exit;
  idx:= td.IndexInParent;
  KeyString:= AnsiLowerCase(Keystring);
  lsp:= length(KeyString);
  For i:= 0 to ndTable.NodeCount-1 do
  begin
    tr:= ndTable[i];
    td:= tr[idx];
    St:= td.ValueAsString;
    p:= Pos(KeyString, AnsiLowerCase(St));
    if p>0 then
    begin
      td.ValueAsString:= Take(St, 1, p-1);
      Delete(St, 1, lsp);
    end
    else
      St:= '';
    td2:= tr.NodeNewAtIndex(idx+1, td.Name);
    td2.Assign(td);
    td2.ValueAsString:= st;
    td2.WriteAttributeString(attTitle, Title2);
  end;
end;


procedure PrepareLine(Line: TNativeXML; Bookmaker_Id: Integer);
begin
  Line.Clear;
  Line.Root.Name:= 'Root';
  Line.Root.WriteAttributeInteger('Bookmaker_Id', Bookmaker_Id);
end;

function NormalizeName(Name: String): String;
begin
  result:= ReplaceAll(Name, '.', '. ');
  result:= ReplaceAll(result, ',', ', ');
  result:= ReplaceAll(result, ')', ') ');
  result:= ReplaceAll(result, '(', ' (');
  result:= ReplaceAll(result, ' )', ')');
  result:= ReplaceAll(result, '( ', '(');
  result:= DeleteDoubleSpace(result);
  result:= ReplaceAll(result, ' .', '.');
  result:= ReplaceAll(result, ' ,', ',');
  result:= DeleteDoubleChar(result, '.');
  result:= DeleteDoubleChar(result, ',');
  result:= Trim(result);
  if LastChar(result) = '.' then TakeLastChar(Result);
  result:= Trim(Result);
end;

function KillParazits(St: String; Parazits: TStrings; ReplaceStr: Char): String;
var
  i: Integer;
  S: String;
begin
  Result:= St;
  For i:= 0 to Parazits.Count-1 do
  begin
    s:= Parazits[i];
    if s<>'' then
      Result:= DeleteDoubleChar(ReplaceAll(Result, s, ReplaceStr), ReplaceStr);
  end;
end;

function PrepareTournirName(Tournir_Name: String; Parazits: TStrings): String;
var
  i, LTN: integer;
begin
  Tournir_Name:= DeleteAllBE(Tournir_Name, '<', '>');
  LTN:= Length(Tournir_Name);
  For i:= LTN downto 2 do
    if (Tournir_Name[i] in ['À'..'ß', '0'..'9']) and
       (Tournir_Name[i-1] in ['à'..'ÿ']) then
       insert(' ', Tournir_Name, i);
  Tournir_Name:= NormalizeName(Tournir_Name);
  Tournir_Name:= KillParazits(Tournir_Name, Parazits, '.');
  result:= Trim(NormalizeName(Tournir_Name));
end;


function PrepareGamerName(GamerName: String; Parazits: TStrings): String;
begin
  result:= NormalizeName(GamerName);
  Result:= Trim(KillParazits(Result, Parazits, ' '));
end;

function ParazitSort(List: TStringList; Index1, Index2: Integer): Integer; far;
var
  L1, L2: Integer;
  S1, S2: String;
begin
  S1:= List[Index1];
  S2:= List[Index2];
  L1:= Length(S1);
  L2:= Length(S2);
  if L1 > L2 then
    result:= -1
  else
  if L1 < L2 then
    result:= 1
  else
  if S1 > S2 then
    result:= -1
  else
  if S1 < S2 then
    result:= 1
  else
    result:= 0
end;

function CreateParazit(FName: String): TStringList;
begin
  Result:= TStringList.Create;
  if FileExists(FName) then
  begin
    result.LoadFromFile(FName);
    result.CustomSort(ParazitSort);
    result.SaveToFile(FName);
  end;
end;


function FillEventParam(TournirId: Integer; EventDtTm: TDateTime;
  Gamer1Name, Gamer2Name: String): String;
begin
  result:= Format(
    'BTournir_Id=%u'#13#10'Event_DTm=%s'#13#10'BGamer1_Nm=%s'#13#10'BGamer2_Nm=%s',
  [TournirId, DateTimeToStr(EventDtTm),Gamer1Name, Gamer2Name]);
end;

function FillBetParam(IndexNo: Integer; BetTypeSign: String;
  BetValue, BetKoef: Single): String;
var
  s: String[4];
begin
  result:= Format(#13#10's_%u=%s'#13#10'v_%u=%5.1f'#13#10'k_%u=%5.3f',
    [IndexNo, BetTypeSign, IndexNo, BetValue, IndexNo, BetKoef]);
end;


function PutBet(IndexNo: Integer; BetTypeSign, Koef: String;
  Ways: Integer): String;
begin
  if Koef = '' then exit;
  Koef:= ReplaceAll(Koef, ',', DecimalSeparator);
  Koef:= ReplaceAll(Koef, '.', DecimalSeparator);
  if IsFloat(Koef) then
    result:= FillBetParam(IndexNo, IntToStr(Ways)+BetTypeSign, 0, StrToFloat(Koef));
end;

function PutBet(IndexNo: Integer; BetTypeSign: String; tr: TXmlNode;
          Ways: Integer): String;
var
  td: TXmlNode;
begin
  td:= tr.NodeByAttributeValue(nnTd, attTitle, BetTypeSign, false);
  if td=nil then exit;
  Result:= PutBet(IndexNo, BetTypeSign, td.ValueAsString, Ways);
end;

function PutTotal(IndexNo: Integer; BetTypeSign, Value, Koef: String): String;
begin
  if (Koef='') or (Value='') then exit;
  Koef:= ReplaceAll(Koef, ',', DecimalSeparator);
  Koef:= ReplaceAll(Koef, '.', DecimalSeparator);
  Value:= ReplaceAll(Value, ',', DecimalSeparator);
  Value:= ReplaceAll(Value, '.', DecimalSeparator);
  if IsFloat(Koef) and IsFloat(Value) then
    Result:= FillBetParam(IndexNo, '2'+BetTypeSign, StrToFloat(Value), StrToFloat(Koef));
end;

function PutTotal(IndexNo: Integer; BetTypeSign: String; tr: TXmlNode): String;
var
  td, ndTotalV: TXmlNode;
begin
  td:= tr.NodeByAttributeValue(nnTd, attTitle, BetTypeSign, false);
  if td=nil then exit;
  ndTotalV:= tr.NodeByAttributeValue(nnTd, attTitle, ctTotV, false);
  if ndTotalV=nil then exit;
  Result:= PutTotal(IndexNo, BetTypeSign, ndTotalV.ValueAsString, td.ValueAsString);
end;

function PutFora(IndexNo: Integer; BetTypeSign, Value, Koef: String): String;
begin
  if (Koef='') or (Value='') then exit;
  Koef:= ReplaceAll(Koef, ',', DecimalSeparator);
  Koef:= ReplaceAll(Koef, '.', DecimalSeparator);
  Value:= ReplaceAll(Value, ',', DecimalSeparator);
  Value:= ReplaceAll(Value, '.', DecimalSeparator);
  if IsFloat(Koef) and IsFloat(Value) then
    Result:= FillBetParam(IndexNo, '2'+BetTypeSign, StrToFloat(Value), StrToFloat(Koef));
end;

function PutFora(IndexNo: Integer; BetTypeSign: String; tr: TXmlNode): String;
var
  td, ndForaV: TXmlNode;
begin
  td:= tr.NodeByAttributeValue(nnTd, attTitle, BetTypeSign);
  if td=nil then exit;
  ndForaV:= tr.NodeByAttributeValue(nnTd, attTitle, BetTypeSign+'V');
  if ndForaV=nil then exit;
    Result:= PutFora(IndexNo, BetTypeSign, ndForaV.ValueAsString, td.ValueAsString);
end;

procedure ClearBetParam(sl: TStringList);
var
  i: Integer;
begin
  for i:= sl.count-1 downto 0 do
    if sl.Names[i][2] = '_' then
      sl.Delete(i);
end;

initialization
  DecimalSeparator:= '.';

end.
