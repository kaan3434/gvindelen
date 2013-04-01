unit GvStr;

interface

uses Classes, Controls, Messages;

// SkipFront Возвращает строку без лидирующих символов из списка KeyChar
// аналогична LTrim, только можно пропускать любые символы
// SkipFront(' 12234 ', ' 1') = '2234 '
function SkipFront(St: String; KeyChar: String =' '): String; overload;
function SkipFront(St: WideString; KeyChar: WideString =' '): WideString; overload;
function SkipLeadingZero(St: string): string;

// SkipBack Возвращает строку без концевых символов из списка KeyChar
// аналогична RTrim, только можно пропускать любые символы
// SkipFront(' 12234 ', ' 1')
// result = '  12234'
function SkipBack(St: String; KeyChar: String = ' '): String; overload;
function SkipBack(St: WideString; KeyChar: WideString = ' '): WideString; overload;

function FillFront(St: String; Len: Integer; Ch: Char = #32): String; overload;
function FillBack(St: String; Len: Integer; Ch: Char = #32): String; overload;
function FillCenter(St: String; Len: Integer; Ch: Char = #32): String; overload;

function LastChar(St:String): Char;
function FirstChar(St: String): Char;
function TakeChar(var St: String; Index: integer): Char;
function TakeLastChar(var St: String): Char;
procedure DelLastChar(var St: String);
function TakeFirstChar(var St: String): Char;
procedure DelFirstChar(var St: String);
function CharsPresent(KeyChar, St: String): Boolean;

{$IFDEF VER150}
function DetectOem(St: String): Boolean;
function ToAnsi(const OemStr: String): String;
function ToOem(const AnsiStr: String): String;
{$ENDIF}

// Take - Вырезает из строки St подстроку начиная с позиции Index длиной Count
// Take(' 12234', 2, 2)
// Result = '12';
// St = ' 234';
function Take(var St: String; Index, Count: Integer): string; overload;
function Take(var St:WideString; Index, Count: Integer): WideString; overload;
function CopyLast(St: String; Count: Integer): string;
function TakeLast(var St: String; Count: Integer): String;

function CopyFront3(St: AnsiString; KeyChar: AnsiString; StartPos: Integer = 1): AnsiString; overload;
function CopyFront3(St: WideString; KeyChar: WideString; StartPos: Integer = 1): WideString; overload;
function CopyFront4(St: AnsiString; KeyChar: AnsiString; StartPos: Integer = 1): AnsiString; overload;
function CopyFront4(St: WideString; KeyChar: WideString; StartPos: Integer = 1): WideString; overload;

function TakeFront3(var St: String; KeyChar: String=' '): String; overload;
function TakeFront4(var St: String; KeyChar: String=' '): String; overload;
function TakeFront5(var St: String; KeyChar: String=' '): String; overload;
function TakeFront5(var St: WideString; KeyChar: WideString=' '): WideString; overload;

function CopyBack3(St: String; KeyChar: String=#32): String; overload;
function CopyBack4(St: String; KeyChar: String=#32): String; overload;

function TakeBack3(var St: String; KeyChar: String=#32): String; overload;
function TakeBack4(var St: String; KeyChar: String=#32): String; overload;
function TakeBack5(var St: String; KeyChar: String=#32): String; overload;

function CopyBetween(ASt, ABegin, AContain1, AContain2, AContain3, AEnd: String;
  var VPos: Integer; ACaseSensitive:Boolean=false): String; overload;
function CopyBetween(ASt, ABegin, AContain1, AContain2, AContain3, AEnd: WideString;
  var VPos: Integer; ACaseSensitive:Boolean=false): WideString; overload;
function CopyBetween(ASt, ABegin, AEnd: String;
  ACaseSensitive:Boolean=false): String; overload;
function CopyBetween(ASt, ABegin, AEnd: String; StartPos: Integer;
  ACaseSensitive: Boolean = false): String; overload;
function CopyBetween(ASt, ABegin, AContain1, AEnd: String;
  ACaseSensitive:Boolean=false): String; overload;
function CopyBetween(ASt, ABegin, AContain1, AContain2, AEnd: String;
  ACaseSensitive:Boolean=false): String; overload;
function CopyBetween(ASt, ABegin, AContain1, AContain2, AContain3, AEnd: String;
  ACaseSensitive:Boolean=false): String; overload;

function CopyBE(ASt, ABegin, AContain1, AContain2, AContain3, AEnd: String;
  var VPos: Integer; ACaseSensitive: Boolean = false): String; overload;
function CopyBE(ASt, ABegin, AContain1, AContain2, AContain3, AEnd: WideString;
  var VPos: Integer; ACaseSensitive: Boolean = false): WideString; overload;
function CopyBE(ASt, ABegin, AEnd: String;
  ACaseSensitive: Boolean = false): String; overload;
function CopyBE(ASt, ABegin, AContain1, AEnd: String;
  ACaseSensitive: Boolean = false): String; overload;
function CopyBE(ASt, ABegin, AContain1, AContain2, AEnd: String;
  ACaseSensitive: Boolean = false): String; overload;
function CopyBE(ASt, ABegin, AContain1, AContain2, AContain3, AEnd: String;
  ACaseSensitive: Boolean = false): String; overload;

function CopyAllBE(ASt, ABegin, AContain1, AContain2, AContain3, AEnd: String;
  ACaseSensitive: Boolean = false; Separator: String=''): String; overload;
function CopyAllBE(ASt, ABegin, AContain1, AContain2, AEnd: String;
  ACaseSensitive: Boolean = false; Separator: String=''): String; overload;
function CopyAllBE(ASt, ABegin, AContain1, AEnd: String;
  ACaseSensitive: Boolean = false; Separator: String=''): String; overload;
function CopyAllBE(ASt, ABegin, AEnd: String;
  ACaseSensitive: Boolean = false; Separator: String=''): String; overload;

function CopyBSE(ASt, ABegin, AContain1, AContain2, AContain3, AEnd: String;
  var VPos: Integer; ACaseSensitive: Boolean): String; Overload;
function CopyBSE(ASt, ABegin, AContain1, AEnd: String;
  ACaseSensitive: Boolean = false): String; Overload;
function CopyBSE(ASt, ABegin, AContain1, AContain2, AEnd: String;
  ACaseSensitive: Boolean = false): String; Overload;
function CopyBSE(ASt, ABegin, AContain1, AContain2, AContain3, AEnd: String;
  ACaseSensitive: Boolean = false): String; Overload;

function TakeBE(var VSt: String; ABegin, AContain1, AContain2, AContain3, AEnd: String;
  ACaseSensitive: Boolean = false): String; overload;
function TakeBE(var VSt: String; ABegin, AContain1, AContain2, AEnd: String;
  ACaseSensitive: Boolean = false): String; overload;
function TakeBE(var VSt: String; ABegin, AContain1, AEnd: String;
  ACaseSensitive: Boolean = false): String; overload;
function TakeBE(var VSt: String; ABegin, AEnd: String;
  ACaseSensitive: Boolean = false): String; overload;


{function DeleteWhileExists(St, SubStBegin, ContainSt, SubStEnd: String;
  CaseInsensitive:Boolean=false): String; overload;
}
function StrToZA90(Value: String): String;
function ZA90ToStr(Value: String): String;

function ListToStr(List: TStrings; Devider: String): String;
function ListNamesToStr(List: TStrings; Devider: String): String;

procedure StrToList(St: String; List: TStrings; KeyChar: String=';');
procedure StrAppendList(St: String; List: TStrings; KeyChar: String=';');
procedure PasteStrInListXY(St: String; sl: TStringList; Line:Integer; Column: Integer);

function StrToHex(St: String): String;
function HexToStr(St: String): String;
function Hex2Dec(const S: string): Longint;

function ExtractFormatChar(VFormat: String; var ChPos: Integer): Char;

function WordNo(AWord, AWords: String; ADelimiter: Char = ';'): Integer;

// Взято из RX-library
function WordCount(St: String; KeyChar: String=#32): Integer;
function NPos(const C: string; S: string; N: Integer): Integer;
function ExtractWord(N: Integer; const S: string; const WordDelims: String): string;
function WordPosition(const N: Integer; const S: string; const WordDelims: String): Integer;
function IsWild(InputStr, Wilds: string; IgnoreCase: Boolean): Boolean;
function FindPart(const HelpWilds, InputStr: string): Integer;

procedure WriteStringToStream(Stream: TStream; St: String);
function ReadStringFromStream(Stream: TStream): String;

function StringByValue(IntValue: Integer; Values: String): String; overload;
function StringByValue(BoolValue: Boolean; Values: String='No;Yes'): String; overload;

function CompressString(Value: String): String;
function DeCompressString(Value: String): String;

function CopyHashPair(Value: String): String;
function TakeHashPair(var Value: String): String;

function PosFirstChar(St: String; KeyChar: String; StartPos: Integer=1): Integer;

function DeleteDoubleChar(St: String; Ch: Char=#32): String;
function DeleteDoubleSpace(St: String): String;

function DeleteChars(St: String; KeyChars: String): String;

// ReplaceBeforeString - Заменяет часть строки St, заканчивающуюся EndSt
// на NewSt и возвращает в качестве результата,
// CaseSensitive - чувствительность к регистру символов
// ReplaceBeforeString('Windows Forever', 'WINDOWS', 'Delphi')
// Result = 'Delphi Forever';
function ReplaceBeforeString(St, EndSt, NewSt: String;
  CaseSensitive: Boolean = false): String;
function ReplaceAfterString(St, StartSt, NewSt: String;
  CaseInsensitive: Boolean = false): String;

function ReplaceAll(ASt, ASubSt, ANewSt: String;
  ACaseSensitive: Boolean = false): String; overload;

function ReplaceAllBE(ASt, ABegin, AContain1, AContain2, AContain3, AEnd, ANew: String;
  ACaseSensitive: Boolean = false): String; overload;
function ReplaceAllBE(ASt, ABegin, AContain1, AContain2, AEnd, ANew: String;
  ACaseSensitive: Boolean = false): String; overload;
function ReplaceAllBE(ASt, ABegin, AContain1, AEnd, ANew: String;
  ACaseSensitive: Boolean = false): String; overload;
function ReplaceAllBE(ASt, ABegin, AEnd, ANew: String;
  ACaseSensitive: Boolean = false): String; overload;
function ReplaceAllBEKeyChar(ASt, ABegin: String; AKeyChar: String; ANew: String;
  ACaseSensitive: Boolean = false): String; overload;


function ReplaceAllBSE(ASt, ABegin, AContain1, AContain2, AContain3, AEnd, ANew: String;
  ACaseSensitive: Boolean = false): String; overload;
function ReplaceAllBSE(ASt, ABegin, AContain1, AContain2, AEnd, ANew: String;
  ACaseSensitive: Boolean = false): String; overload;
function ReplaceAllBSE(ASt, ABegin, AContain1, AEnd, ANew: String;
  ACaseSensitive: Boolean = false): String; overload;

function DeleteAll(ASt, ASubSt: String;
  ACaseSensitive: Boolean = false): String; overload;

function DeleteAllBE(ASt, ABegin, AContain1, AContain2, AContain3, AEnd: String;
  ACaseSensitive: Boolean = false): String; overload;
function DeleteAllBE(ASt, ABegin, AContain1, AContain2, AEnd: String;
  ACaseSensitive: Boolean = false): String; overload;
function DeleteAllBE(ASt, ABegin, AContain1, AEnd: String;
  ACaseSensitive: Boolean = false): String; overload;
function DeleteAllBE(ASt, ABegin, AEnd: String;
  ACaseSensitive: Boolean = false): String; overload;
function DeleteAllBEKeyChar(ASt, ABegin: String; AKeyChar: String;
  ACaseSensitive: Boolean = false): String; overload;

function DeleteAllBSE(ASt, ABegin, AContain1, AContain2, AContain3, AEnd: String;
  ACaseSensitive: Boolean = false): String; overload;
function DeleteAllBSE(ASt, ABegin, AContain1, AContain2, AEnd: String;
  ACaseSensitive: Boolean = false): String; overload;
function DeleteAllBSE(ASt, ABegin, AContain1, AEnd: String;
  ACaseSensitive: Boolean = false): String; overload;

function DeleteAllAttribute(ASt, AAttributeName: String): String;
function DeleteAllAttributeWithValue(ASt, AAttributeName, AValue: String): String;

function TakeAttName(var St: String): String;
function TakeAttValue(var St: String): String;

function GvUtf8ToAnsi(St: String): String;
//function GvUTF8ToAnsiSmart(Value: String): String;

function EscapeString(St: String; AddChar: String = ''): string; overload;
function EscapeString(St: WideString; AddChar: WideString = ''): WideString; overload;
function UnEscapeString(St: Ansistring; AddChar: AnsiString = ''): Ansistring; overload;
function UnEscapeString(St: WideString): WideString; overload;

function FilterString(St, KeyChars: string): string;

function Translit(St: string): string;
function DeTranslit(St: string): string;
function UpCaseFirst(St: string): string;
function UpCaseWord(St: string; KeyChars: string=' ,.!-:?'): string;

function IsWordPresent(aWord, aWordList, aDelimiter: String): Boolean;
function FormatString(aStr, aFormat: string): String;

function CoalesceStr(aStr1, aStr2: string): string;

implementation
uses
  windows, sysutils, Zlib, Math, StrUtils;

{$IFDEF VER150}
function DetectOem(St: String): Boolean;
var
  Stat: Array[0..255] of Word;
  OemCnt, AnsiCnt, i: LongInt;
begin
  OemCnt:= 0;
  AnsiCnt:= 0;
  FillChar(Stat, SizeOf(Stat),0);
  For i:= 1 to Length(St) do Inc(Stat[Ord(St[i])]);
  For i:= $80 to $9F do Inc(OemCnt, Stat[i]);
  For i:= $C0 to $DF do Inc(AnsiCnt, Stat[i]);
  result:= OemCnt>=AnsiCnt;
end;

function ToOem(const AnsiStr: string): string;
begin
  SetLength(Result, Length(AnsiStr));
  if Length(Result) > 0 then
    CharToOemBuff(PChar(AnsiStr), PChar(Result), Length(Result));
end;

function ToAnsi(const OemStr: string): string;
begin
  SetLength(Result, Length(OemStr));
  if Length(Result) > 0 then
    OemToCharBuff(PChar(OemStr), PChar(Result), Length(Result));
end;
{$ENDIF}

function SkipFront(St: String; KeyChar: String): String;
var
  LS, P: Integer;
begin
  LS:= Length(St);
  P:= 1;
  while (P<=LS) and (Pos(St[P], KeyChar)>0) do Inc(P);
  result:= Copy(St, P, LS-P+1);
end;

function SkipFront(St: WideString; KeyChar: WideString): WideString;
var
  LS, P: Integer;
begin
  LS:= Length(St);
  P:= 1;
  while (P<=LS) and (Pos(St[P], KeyChar)>0) do Inc(P);
  result:= Copy(St, P, LS-P+1);
end;

function SkipLeadingZero(St: string): string;
begin
  result:= SkipFront(St, '0');
  if Result = '' then
    Result:= '0'
  else
  if (Result[1] = '.') or (Result[1] =',') then
    Result:= '0' + Result;
end;

function SkipBack(St: String; KeyChar: String): String;
var
  P: Integer;
begin
  P:= Length(St);
  while (P>0) and (Pos(St[P], KeyChar)>0) do Dec(p);
  result:= Copy(St, 1, P);
end;

function SkipBack(St: WideString; KeyChar: WideString): WideString; overload;
var
  P: Integer;
begin
  P:= Length(St);
  while (P>0) and (Pos(St[P], KeyChar)>0) do Dec(p);
  result:= Copy(St, 1, P);
end;

function FillFront(St: String;  Len: Integer; Ch: Char =#32): String;
var
  LS: Integer;
begin
  LS:= Length(St);
  if LS>=Len then
    result:= St
  else
    Result:= StringOfChar(Ch,Len-LS)+St;
end;

function FillBack(St: String; Len: Integer; Ch: Char=#32): String;
begin
  result:= St;
  While Length(Result) < Len do Result:= Result+Ch;
end;

function FillCenter(St: String; Len: Integer; Ch: Char=#32): String;
begin
  result:= FillBack(FillFront(St, (Len+Length(St)) div 2, Ch), Len, Ch);
end;

function LastChar(St:String): Char;
begin
  if St<>'' then result:= St[Length(St)] else result:= #0;
end;
function FirstChar(St: String): Char;
begin
  if St<>'' then result:= St[1] else result:= #0;
end;

function TakeChar(var St: String; Index: integer): Char;
begin
  if (Length(St)>0) and (Index <= Length(St)) then
  begin
    result:= St[Index];
    Delete(St, Index, 1);
  end
  else result:= #0;
end;

function TakeFirstChar(var St: String): Char;
begin
  result:= TakeChar(St, 1);
end;
function TakeLastChar(var St: String): Char;
begin
  result:= TakeChar(St, Length(St));
end;
procedure DelLastChar(var St: String);
begin
  if St<>'' then
    Delete(St, Length(St), 1);
end;

procedure DelFirstChar(var St: String);
begin
  if St<>'' then
    Delete(St, 1, 1);
end;

function CharsPresent(KeyChar, St: String): Boolean;
var
  i: Integer;
begin
  result:= true;
  for i:= 1 to Length(St) do
    if Pos(St[i], KeyChar)>0 then Exit;
  result:= false;
end;

function Take(var St: String; Index, Count: Integer): string;
begin
  Result:= Copy(St, Index, Count);
  Delete(St, Index, Length(Result));
end;

function Take(var St: WideString; Index, Count: Integer): WideString;
begin
  Result:= Copy(St, Index, Count);
  Delete(St, Index, Length(Result));
end;

function CopyLast(St: String; Count: Integer): string;
begin
  Result:= Copy(St, Length(St)-Count+1, Count);
end;

function TakeLast(var St: String; Count: Integer): string;
begin
  Result:= CopyLast(St, Count);
  St:= Copy(St, 1, Length(St)-Count);
end;

function CopyFront3(St: AnsiString; KeyChar: AnsiString; StartPos: Integer = 1): AnsiString;
var
  LS, P: Integer;
begin
  LS:= Length(St);
  P:= StartPos;
  While (P<=LS) and (Pos(St[P], KeyChar)=0) do inc(P);
  While (P<=LS) and (Pos(St[P], KeyChar)>0) do inc(P);
  result:= Copy(St, StartPos, P-StartPos);
end;

function CopyFront3(St: WideString; KeyChar: WideString; StartPos: Integer = 1): WideString;
var
  LS, P: Integer;
begin
  LS:= Length(St);
  P:= StartPos;
  While (P<=LS) and (Pos(St[P], KeyChar)=0) do inc(P);
  While (P<=LS) and (Pos(St[P], KeyChar)>0) do inc(P);
  result:= Copy(St, StartPos, P-StartPos);
end;


function CopyFront4(St: AnsiString; KeyChar: AnsiString; StartPos: Integer = 1): AnsiString;
var
  LS, P: Integer;
begin
  LS:= Length(St);
  P:= 1;
  While (P<=LS) and (Pos(St[P], KeyChar)=0) do inc(P);
  result:= Copy(St, StartPos, P-StartPos);
end;

function CopyFront4(St: WideString; KeyChar: WideString; StartPos: Integer = 1): WideString;
var
  LS, P: Integer;
begin
  LS:= Length(St);
  P:= 1;
  While (P<=LS) and (Pos(St[P], KeyChar)=0) do inc(P);
  result:= Copy(St, StartPos, P-StartPos);
end;

function TakeFront3(var St: String; KeyChar: String): String;
var
  LS, P: Integer;
begin
  LS:= Length(St);
  P:= 1;
  While (P<=LS) and (Pos(St[P], KeyChar)=0) do inc(P);
  While (P<=LS) and (Pos(St[P], KeyChar)>0) do inc(P);
  result:= Copy(St, 1, P-1);
  St:= Copy(St, P, LS-P+1);
end;

function TakeFront4(var St: String; KeyChar: String): String;
var
  LS, P: Integer;
begin
  LS:= Length(St);
  P:= 1;
  While (P<=LS) and (Pos(St[P], KeyChar)=0) do inc(P);
  result:= Copy(St, 1, P-1);
  St:= Copy(St, P, LS-P+1);
end;

function TakeFront5(var St: String; KeyChar: String): String;
var
  LS, P: Integer;
begin
  LS:= Length(St);
  P:= 1;
  While (P<=LS) and (Pos(St[P], KeyChar)=0) do inc(P);
  result:= Copy(St, 1, P-1);
  While (P<=LS) and (Pos(St[P], KeyChar)>0) do inc(P);
  St:= Copy(St, P, LS-P+1);
end;

function TakeFront5(var St: WideString; KeyChar: WideString): WideString;
var
  LS, P: Integer;
begin
  LS:= Length(St);
  P:= 1;
  While (P<=LS) and (Pos(St[P], KeyChar)=0) do inc(P);
  result:= Copy(St, 1, P-1);
  While (P<=LS) and (Pos(St[P], KeyChar)>0) do inc(P);
  St:= Copy(St, P, LS-P+1);
end;

function CopyBack3(St: String; KeyChar: String): String;
var
  LS, P: Integer;
begin
  LS:= Length(St);
  P:= LS;
  While (P>0) and (Pos(St[P], KeyChar)=0) do dec(P);
  While (P>0) and (Pos(St[P], KeyChar)>0) do dec(P);
  result:= Copy(St, P+1, LS-P);
end;

function CopyBack4(St: String; KeyChar: String): String;
var
  LS, P: Integer;
begin
  LS:= Length(St);
  P:= LS;
  While (P>0) and (Pos(St[P], KeyChar)=0) do dec(P);
  result:= Copy(St, P+1, LS-P);
end;

function TakeBack3(var St: String; KeyChar: String): String;
var
  LS, P: Integer;
begin
  LS:= Length(St);
  P:= LS;
  While (P>0) and (Pos(St[P], KeyChar)=0) do dec(P);
  While (P>0) and (Pos(St[P], KeyChar)>0) do dec(P);
  result:= Copy(St, P+1, LS-P);
  St:= Copy(St, 1, P);
end;

function TakeBack4(var St: String; KeyChar: String): String;
var
  LS, P: Integer;
begin
  LS:= Length(St);
  P:= LS;
  While (P>0) and (Pos(St[P], KeyChar)=0) do dec(P);
  result:= Copy(St, P+1, LS-P);
  St:= Copy(St, 1, P);
end;

function TakeBack5(var St: String; KeyChar: String): String;
var
  LS, P: Integer;
begin
  LS:= Length(St);
  P:= LS;
  While (P>0) and (Pos(St[P], KeyChar)=0) do dec(P);
  result:= Copy(St, P+1, LS-P);
  While (P>0) and (Pos(St[P], KeyChar)>0) do dec(P);
  St:= Copy(St, 1, P);
end;

{function DeleteWhileExists(St, SubStBegin, ContainSt, SubStEnd: String;
  CaseSensitive:Boolean=false): String; overload;
var
  ps: integer;
  S: String;
  NeedDel: Boolean;
begin
  Ps:= 0;
  repeat
    S:= CopyBE(St, SubStBegin, SubStEnd, Ps, CaseInsensitive);
    if CaseInsensitive then
      NeedDel:= Pos(AnsiLowerCase(ContainSt), AnsiLowerCase(S))>0
    else
      NeedDel:= Pos(ContainSt, S)>0;
    if NeedDel then
      Delete(St, Ps, Length(S))
    else
      Inc(ps);
  until s='';
  result:= St;
end;
}

function NextPos(SubSt, St: String; StartPos, EndPos: Integer): Integer;
var
  P: Integer;
begin
  result:= StartPos;
  repeat
    P:= PosEx(SubSt, St, result+1);
    if InRange(P, result, EndPos-1) then
      result:= P
    else
      Exit;
  until false;
end;

//------------------------------------------------------------------------------
// CopyBetween - CopyBeginEnd
//------------------------------------------------------------------------------
function CopyBetween(ASt, ABegin, AContain1, AContain2, AContain3, AEnd: String;
  var VPos: Integer; ACaseSensitive: Boolean = false): String; overload;
var
  PSB, PSC1, PSC2, PSC3, PSE: Integer;
  LSB, LSC1, LSC2, LSC3: Integer;
  LSt: String;
begin
  LSB:= Length(ABegin);
  LSC1:= Length(AContain1);
  LSC2:= Length(AContain2);
  LSC3:= Length(AContain3);
  result:= '';
  if ACaseSensitive then LSt:= ASt else
  begin
    LSt:= AnsiLowerCase(ASt);
    ABegin:= AnsiLowerCase(ABegin);
    AEnd:= AnsiLowerCase(AEnd);
    AContain1:= AnsiLowerCase(AContain1);
    AContain2:= AnsiLowerCase(AContain2);
    AContain3:= AnsiLowerCase(AContain3);
  end;
  PSB:= Max(1, VPos);
  try
    repeat
      PSB:= PosEx(ABegin, LSt, PSB);
      if PSB = 0 then Exit;
      PSE:= PosEx(AEnd, LSt, PSB+LSB);
      if PSE = 0 then Exit;
      // Начинаем уменьшать жадность
      PSB:= NextPos(ABegin, LSt, PSB, PSE);
      if LSC1 = 0 then PSC1:= 1 else
        PSC1:= PosEx(AContain1, Copy(LSt, PSB+LSB, PSE-PSB-LSB-1));
      if LSC2 = 0 then PSC2:= Succ(PSC1) else
        PSC2:= PosEx(AContain2, Copy(LSt, PSB+LSB+PSC1+LSC1, PSE-PSB-LSB-1));
      if LSC3 = 0 then PSC3:= Succ(PSC2) else
        PSC3:= PosEx(AContain3, Copy(LSt, PSB+LSB+PSC2+LSC2, PSE-PSB-LSB-1));
      if (PSC1>0) and (PSC2>0) and (PSC3>0) then
        break
      else
        PSB:= PSE;
    until false;
    Inc(PSB, LSB);
    result:= Copy(ASt, PSB, PSE-PSB);
  finally
    VPos:= IfThen(result='', 0, PSB);
  end;
end;

function CopyBetween(ASt, ABegin, AContain1, AContain2, AContain3, AEnd: WideString;
  var VPos: Integer; ACaseSensitive: Boolean = false): WideString; overload;
var
  PSB, PSC1, PSC2, PSC3, PSE: Integer;
  LSB, LSC1, LSC2, LSC3: Integer;
  LSt: String;
begin
  LSB:= Length(ABegin);
  LSC1:= Length(AContain1);
  LSC2:= Length(AContain2);
  LSC3:= Length(AContain3);
  result:= '';
  if ACaseSensitive then LSt:= ASt else
  begin
    LSt:= AnsiLowerCase(ASt);
    ABegin:= AnsiLowerCase(ABegin);
    AEnd:= AnsiLowerCase(AEnd);
    AContain1:= AnsiLowerCase(AContain1);
    AContain2:= AnsiLowerCase(AContain2);
    AContain3:= AnsiLowerCase(AContain3);
  end;
  PSB:= Max(1, VPos);
  try
    repeat
      PSB:= PosEx(ABegin, LSt, PSB);
      if PSB = 0 then Exit;
      PSE:= PosEx(AEnd, LSt, PSB+LSB);
      if PSE = 0 then Exit;
      // Начинаем уменьшать жадность
      PSB:= NextPos(ABegin, LSt, PSB, PSE);
      if LSC1 = 0 then PSC1:= 1 else
        PSC1:= PosEx(AContain1, Copy(LSt, PSB+LSB, PSE-PSB-LSB-1));
      if LSC2 = 0 then PSC2:= Succ(PSC1) else
        PSC2:= PosEx(AContain2, Copy(LSt, PSB+LSB+PSC1+LSC1, PSE-PSB-LSB-1));
      if LSC3 = 0 then PSC3:= Succ(PSC2) else
        PSC3:= PosEx(AContain3, Copy(LSt, PSB+LSB+PSC2+LSC2, PSE-PSB-LSB-1));
      if (PSC1>0) and (PSC2>0) and (PSC3>0) then
        break
      else
        PSB:= PSE;
    until false;
    Inc(PSB, LSB);
    result:= Copy(ASt, PSB, PSE-PSB);
  finally
    VPos:= IfThen(result='', 0, PSB);
  end;
end;

function CopyBetween(ASt, ABegin, AEnd: String;
  ACaseSensitive: Boolean = false): String; overload;
var
  PSB: Integer;
begin
  PSB:= 1;
  result:= CopyBetween(ASt, ABegin, '', '', '', AEnd, PSB, ACaseSensitive);
end;

function CopyBetween(ASt, ABegin, AEnd: String; StartPos: Integer;
  ACaseSensitive: Boolean = false): String; overload;
begin
  result:= CopyBetween(ASt, ABegin, '', '', '', AEnd, StartPos, ACaseSensitive);
end;

function CopyBetween(ASt, ABegin, AContain1, AEnd: String;
  ACaseSensitive: Boolean = false): String; overload;
var
  PSB: Integer;
begin
  PSB:= 1;
  result:= CopyBetween(ASt, ABegin, AContain1, '', '', AEnd, PSB, ACaseSensitive);
end;

function CopyBetween(ASt, ABegin, AContain1, AContain2, AEnd: String;
  ACaseSensitive: Boolean = false): String; overload;
var
  PSB: Integer;
begin
  PSB:= 1;
  result:= CopyBetween(ASt, ABegin, AContain1, AContain2, '', AEnd, PSB, ACaseSensitive);
end;

function CopyBetween(ASt, ABegin, AContain1, AContain2, AContain3, AEnd: String;
  ACaseSensitive: Boolean = false): String; overload;
var
  PSB: Integer;
begin
  PSB:= 1;
  result:= CopyBetween(ASt, ABegin, AContain1, AContain2, AContain3, AEnd, PSB, ACaseSensitive);
end;

//------------------------------------------------------------------------------
// CopyBE - CopyBeginEnd
//------------------------------------------------------------------------------

function CopyBE(ASt, ABegin, AContain1, AContain2, AContain3, AEnd: String;
  var VPos: Integer; ACaseSensitive: Boolean = false): String; overload;
var
  PSB, PSC1, PSC2, PSC3, PSE: Integer;
  LSB, LSC1, LSC2, LSC3, LSE, LSR: Integer;
  LSt, RSt: String;
begin
  LSB:= Length(ABegin);
  LSE:= Length(AEnd);
  LSC1:= Length(AContain1);
  LSC2:= Length(AContain2);
  LSC3:= Length(AContain3);
  result:= '';
  if ACaseSensitive then LSt:= ASt else
  begin
    LSt:= AnsiLowerCase(ASt);
    ABegin:= AnsiLowerCase(ABegin);
    AEnd:= AnsiLowerCase(AEnd);
    AContain1:= AnsiLowerCase(AContain1);
    AContain2:= AnsiLowerCase(AContain2);
    AContain3:= AnsiLowerCase(AContain3);
  end;
  PSE:= Max(1, VPos);
  repeat
    PSB:= PosEx(ABegin, LSt, PSE);
    try
      if PSB = 0 then Exit;
      PSE:= PosEx(AEnd, LSt, PSB+LSB);
      if PSE = 0 then Exit;
      // Начинаем уменьшать жадность
      PSB:= NextPos(ABegin, LSt, PSB, PSE);
      RSt:= Copy(LSt, PSB+LSB, PSE-PSB-LSB);
      LSR:= Length(RSt);
      if LSC1 <> 0 then
      begin
        PSC1:= PosEx(AContain1, RSt);
        if PSC1 = 0 then continue;
        RSt:= Copy(RSt, PSC1+LSC1, LSR);
        if LSC2 <> 0 then
        begin
          PSC2:= PosEx(AContain2, RSt);
          if PSC2 = 0 then continue;
          RSt:= Copy(RSt, PSC2+LSC2, LSR);
          if LSC3 <> 0 then
          begin
            PSC3:= PosEx(AContain3, RSt);
            if PSC3 = 0 then continue;
          end;
        end;
      end;
      result:= Copy(ASt, PSB, PSE-PSB+LSE);
      break;
    finally
      VPos:= IfThen(result='', 0, PSB);
    end;
  until false;
end;

function CopyBE(ASt, ABegin, AContain1, AContain2, AContain3, AEnd: WideString;
  var VPos: Integer; ACaseSensitive: Boolean = false): WideString; overload;
var
  PSB, PSC1, PSC2, PSC3, PSE: Integer;
  LSB, LSC1, LSC2, LSC3, LSE, LSR: Integer;
  LSt, RSt: String;
begin
  LSB:= Length(ABegin);
  LSE:= Length(AEnd);
  LSC1:= Length(AContain1);
  LSC2:= Length(AContain2);
  LSC3:= Length(AContain3);
  result:= '';
  if ACaseSensitive then LSt:= ASt else
  begin
    LSt:= AnsiLowerCase(ASt);
    ABegin:= AnsiLowerCase(ABegin);
    AEnd:= AnsiLowerCase(AEnd);
    AContain1:= AnsiLowerCase(AContain1);
    AContain2:= AnsiLowerCase(AContain2);
    AContain3:= AnsiLowerCase(AContain3);
  end;
  PSE:= Max(1, VPos);
  repeat
    PSB:= PosEx(ABegin, LSt, PSE);
    try
      if PSB = 0 then Exit;
      PSE:= PosEx(AEnd, LSt, PSB+LSB);
      if PSE = 0 then Exit;
      // Начинаем уменьшать жадность
      PSB:= NextPos(ABegin, LSt, PSB, PSE);
      RSt:= Copy(LSt, PSB+LSB, PSE-PSB-LSB);
      LSR:= Length(RSt);
      if LSC1 <> 0 then
      begin
        PSC1:= PosEx(AContain1, RSt);
        if PSC1 = 0 then continue;
        RSt:= Copy(RSt, PSC1+LSC1, LSR);
        if LSC2 <> 0 then
        begin
          PSC2:= PosEx(AContain2, RSt);
          if PSC2 = 0 then continue;
          RSt:= Copy(RSt, PSC2+LSC2, LSR);
          if LSC3 <> 0 then
          begin
            PSC3:= PosEx(AContain3, RSt);
            if PSC3 = 0 then continue;
          end;
        end;
      end;
      result:= Copy(ASt, PSB, PSE-PSB+LSE);
      break;
    finally
      VPos:= IfThen(result='', 0, PSB);
    end;
  until false;
end;

function CopyBE(ASt, ABegin, AEnd: String;
  ACaseSensitive:Boolean = false): String; overload;
var
  PSB: Integer;
begin
  PSB:= 1;
  result:= CopyBE(ASt, ABegin, '', '', '', AEnd, PSB, ACaseSensitive);
end;

function CopyBE(ASt, ABegin, AContain1, AEnd: String;
  ACaseSensitive: Boolean = false): String; overload;
var
  PSB: Integer;
begin
  PSB:= 1;
  result:= CopyBE(ASt, ABegin, AContain1, '', '', AEnd, PSB, ACaseSensitive);
end;

function CopyBE(ASt, ABegin, AContain1, AContain2, AEnd: String;
  ACaseSensitive: Boolean = false): String; overload;
var
  PSB: Integer;
begin
  PSB:= 1;
  result:= CopyBE(ASt, ABegin, AContain1, AContain2, '', AEnd, PSB, ACaseSensitive);
end;

function CopyBE(ASt, ABegin, AContain1, AContain2, AContain3, AEnd: String;
  ACaseSensitive: Boolean = false): String; overload;
var
  PSB: Integer;
begin
  PSB:= 1;
  result:= CopyBE(ASt, ABegin, AContain1, AContain2, AContain3, AEnd, PSB, ACaseSensitive);
end;

function CopyAllBE(ASt, ABegin, AContain1, AContain2, AContain3, AEnd: String;
  ACaseSensitive: Boolean = false; Separator: String=''): String; overload;
var
  LPos: Integer;
  LSt: String;
begin
  result:= '';
  LPos:= 1;
  LSt:= '';
  repeat
    Inc(LPos, Length(LSt));
    LSt:= CopyBE(ASt, ABegin, AContain1, AContain2, AContain3, AEnd, LPos, ACaseSensitive);
    if result = '' then
      result:= LSt
    else
      result:= result+Separator+LSt;
  until LPos = 0;
end;

function CopyAllBE(ASt, ABegin, AContain1, AContain2, AEnd: String;
  ACaseSensitive: Boolean = false; Separator: String=''): String; overload;
begin
  result:= CopyAllBE(ASt, ABegin, AContain1, AContain2, '', AEnd, ACaseSensitive, Separator);
end;

function CopyAllBE(ASt, ABegin, AContain1, AEnd: String;
  ACaseSensitive: Boolean = false; Separator: String=''): String; overload;
begin
  result:= CopyAllBE(ASt, ABegin, AContain1, '', '', AEnd, ACaseSensitive, Separator);
end;

function CopyAllBE(ASt, ABegin, AEnd: String;
  ACaseSensitive: Boolean = false; Separator: String=''): String; overload;
begin
  result:= CopyAllBE(ASt, ABegin, '', '', '', AEnd, ACaseSensitive, Separator);
end;

//------------------------------------------------------------------------------
// Copy Begin Substring End
//------------------------------------------------------------------------------
function CopyBSE(ASt, ABegin, AContain1, AContain2, AContain3, AEnd: String;
  var VPos: Integer; ACaseSensitive: Boolean): String; Overload;
var
  PSB, PSC1, PSC2, PSC3, PSE: Integer;
  LSB, LSC1, LSC2, LSC3, LSE: Integer;
  LSt: String;
begin
  LSB:= Length(ABegin);
  LSC1:= Length(AContain1);
  LSC2:= Length(AContain2);
  LSC3:= Length(AContain3);
  LSE:= Length(AEnd);
  result:= '';
  if ACaseSensitive then LSt:= ASt else
  begin
    LSt:= AnsiLowerCase(ASt);
    ABegin:= AnsiLowerCase(ABegin);
    AEnd:= AnsiLowerCase(AEnd);
    AContain1:= AnsiLowerCase(AContain1);
    AContain2:= AnsiLowerCase(AContain2);
    AContain3:= AnsiLowerCase(AContain3);
  end;
  PSB:= Max(1, VPos);
  try
    PSB:= PosEx(ABegin, LSt, PSB);
    if PSB = 0 then Exit;
    if LSC1 = 0 then PSC1:= PSB+LSB else
      PSC1:= PosEx(AContain1, LSt, PSB+LSB);
    if PSC1 = 0 then Exit;
    if LSC2 = 0 then PSC2:= PSC1+LSC1 else
      PSC2:= PosEx(AContain2, LSt, PSC1+LSC1);
    if PSC2 = 0 then Exit;
    if LSC3 = 0 then PSC3:= PSC2+LSC2 else
      PSC3:= PosEx(AContain3, LSt, PSC2+LSC2);
    if PSC3 = 0 then Exit;
    PSE:= PosEx(AEnd, LSt, PSC3+LSC3);
    if PSE = 0 then Exit;
    // Начинаем уменьшать жадность
    if LSC3 = 0 then PSC3:= PSE else
      PSC3:= NextPos(AContain3, LSt, PSC3, PSE);
    if LSC2 = 0 then PSC2:= PSC3 else
      PSC2:= NextPos(AContain2, LSt, PSC2, PSC3);
    if LSC1 = 0 then PSC1:= PSC2 else
      PSC1:= NextPos(AContain1, LSt, PSC1, PSC2);
    PSB:= NextPos(ABegin, LSt, PSB, PSC1);
    result:= Copy(ASt, PSB, PSE-PSB+LSE);
  finally
    VPos:= IfThen(result='', 0, PSB);
  end;
end;

function CopyBSE(ASt, ABegin, AContain1, AEnd: String;
  ACaseSensitive: Boolean=false): String; Overload;
var
  PSB: Integer;
begin
  PSB:= 1;
  result:= CopyBSE(ASt, ABegin, AContain1, '', '', AEnd, PSB, ACaseSensitive);
end;

function CopyBSE(ASt, ABegin, AContain1, AContain2, AEnd: String;
  ACaseSensitive: Boolean=false): String; Overload;
var
  PSB: Integer;
begin
  PSB:= 1;
  result:= CopyBSE(ASt, ABegin, AContain1, AContain2, '', AEnd, PSB, ACaseSensitive);
end;

function CopyBSE(ASt, ABegin, AContain1, AContain2, AContain3, AEnd: String;
  ACaseSensitive: Boolean=false): String; Overload;
var
  PSB: Integer;
begin
  PSB:= 1;
  result:= CopyBSE(ASt, ABegin, AContain1, AContain2, AContain3, AEnd, PSB, ACaseSensitive);
end;

// TakeBeginEnd

function TakeBE(var VSt: String; ABegin, AContain1, AContain2, AContain3, AEnd: String;
  ACaseSensitive: Boolean = false): String; overload;
var
  PSB: Integer;
begin
  PSB:= 1;
  result:= CopyBE(VSt, ABegin, AContain1, AContain2, AContain3, AEnd, PSB, ACaseSensitive);
  if PSB<>0 then
    Delete(VSt, PSB, Length(Result));
end;

function TakeBE(var VSt: String; ABegin, AContain1, AContain2, AEnd: String;
  ACaseSensitive: Boolean = false): String; overload;
begin
  result:= TakeBE(VSt, ABegin, AContain1, AContain2, '', AEnd, ACaseSensitive);
end;

function TakeBE(var VSt: String; ABegin, AContain1, AEnd: String;
  ACaseSensitive: Boolean = false): String; overload;
begin
  result:= TakeBE(VSt, ABegin, AContain1, '', '', AEnd, ACaseSensitive);
end;

function TakeBE(var VSt: String; ABegin, AEnd: String;
  ACaseSensitive: Boolean = false): String; overload;
begin
  result:= TakeBE(VSt, ABegin, '', '', '', AEnd, ACaseSensitive);
end;

//
//
//

const
  cZA90= '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';

function StrToZA90(Value: String): String;
var
  i64: Int64;
begin
  result:= '';
  i64:= StrToInt64Def(Value, 0);
  while true do
  begin
    result:= cZA90[(i64 mod Length(cZA90))+1]+result;
    if i64 < Length(cZA90) then break;
    i64:= i64 div Length(cZA90);
  end;
end;

function ZA90ToStr(Value: String): String;
var
  i64: Int64;
  Ch: Char;
function MyPower(p: Integer): Int64;
var
  i: integer;
begin
  result:= 1;
  For i:= 1 to p do result:= result*Length(cZA90);
end;
begin
  i64:= 0;
  While Value <> '' do
  begin
    Ch:= TakeFirstChar(Value);
    i64:= i64+(Pos(Ch, cZA90)-1)*MyPower(Length(Value));
  end;
  result:=IntToStr(i64);
end;

function ListToStr(List: TStrings; Devider: String): String;
begin
  result:= ReplaceAll(List.Text, #$0D#$0A, Devider);
  SetLength(result, Length(result)-Length(Devider));
end;

function ListNamesToStr(List: TStrings; Devider: String): String;
begin
  result:= ReplaceAllBE(List.Text, '=', #$0D#$0A, Devider);
  SetLength(result, Length(result)-Length(Devider));
end;

procedure PasteStrInListXY(St: String; sl: TStringList; Line:Integer; Column: Integer);
var
  StLine: String;
begin
  While sl.Count<Line do sl.Add('');
  StLine:= sl[Line-1];
  if Column=0 then Column:= Length(StLine)+1;
  if Length(StLine)<Column then
    StLine:= StLine+StringOfChar(' ', Column-Length(StLine)+Length(St));
  Move(St, StLine[Column], Length(St));
end;

function StrToHex(St: String): String;
var
  i: integer;
begin
  result:= '';
  For i:= 1 to Length(St) do
    result:= result+IntToHex(Ord(St[i]),2);
end;

function HexToStr(St: String): String;
const
  Hex= '0123456789ABCDEF';
var
  S: String;
begin
  result:= '';
  while St <> '' do
  begin
    S:= Take(St,1,2);
    result:= result+chr((Pos(S[1],Hex)-1)*16+Pos(S[2],Hex)-1);
  end;
end;

function ExtractFormatChar(VFormat: String; var ChPos: Integer): Char;
begin
  ChPos:= Length(VFormat);
  VFormat:= UpperCase(VFormat);
  TakeFront5(VFormat,'%');
  VFormat:= SkipFront(VFormat, '0123456789:.-');
  result:= TakeFirstChar(VFormat);
  Dec(ChPos, Length(VFormat));
end;

function WordCount(St: String; KeyChar: String=#32): Integer;
var
  SLen, I: Cardinal;
begin
  Result := 0;
  I := 1;
  SLen := Length(St);
  while I <= SLen do
  begin
    while (I <= SLen) and (Pos(St[I], KeyChar)>0) do Inc(I);
    if I <= SLen then Inc(Result);
    while (I <= SLen) and (Pos(St[I], KeyChar)=0) do Inc(I);
  end;
end;

function WordNo(AWord, AWords: String; ADelimiter: Char = ';'): Integer;
var
  sl: TStringList;
begin
  sl:= TStringList.Create;
  try
    sl.Text:= ReplaceAll(AWords, ADelimiter, #$D#$A);
    result:= sl.IndexOf(AWord);
  finally
    sl.Free;
  end;
end;

function NPos(const C: string; S: string; N: Integer): Integer;
var
  I, P, K: Integer;
begin
  Result := 0;
  K := 0;
  for I := 1 to N do begin
    P := Pos(C, S);
    Inc(K, P);
    if (I = N) and (P > 0) then begin
      Result := K;
      Exit;
    end;
    if P > 0 then Delete(S, 1, P)
    else Exit;
  end;
end;

function ExtractWord(N: Integer; const S: string;
  const WordDelims: String): string;
var
  I: Integer;
  Len: Integer;
begin
  Len := 0;
  I := WordPosition(N, S, WordDelims);
  if I <> 0 then
    { find the end of the current word }
    while (I <= Length(S)) and (Pos(S[I], WordDelims)=0) do
    begin
      { add the I'th character to result }
      Inc(Len);
      SetLength(Result, Len);
      Result[Len] := S[I];
      Inc(I);
    end;
  SetLength(Result, Len);
end;

function WordPosition(const N: Integer; const S: string;
  const WordDelims: String): Integer;
var
  Count, I: Integer;
begin
  Count := 0;
  I := 1;
  Result := 0;
  while (I <= Length(S)) and (Count <> N) do begin
    { skip over delimiters }
    while (I <= Length(S)) and (Pos(S[I], WordDelims)>0) do Inc(I);
    { if we're not beyond end of S, we're at the start of a word }
    if I <= Length(S) then Inc(Count);
    { if not finished, find the end of the current word }
    if Count <> N then
      while (I <= Length(S)) and (Pos(S[I], WordDelims)=0) do Inc(I)
    else Result := I;
  end;
end;

function IsWild(InputStr, Wilds: string; IgnoreCase: Boolean): Boolean;

 function SearchNext(var Wilds: string): Integer;
 { looking for next *, returns position and string until position }
 begin
   Result := Pos('*', Wilds);
   if Result > 0 then Wilds := Copy(Wilds, 1, Result - 1);
 end;

var
  CWild, CInputWord: Integer; { counter for positions }
  I, LenHelpWilds: Integer;
  MaxInputWord, MaxWilds: Integer; { Length of InputStr and Wilds }
  HelpWilds: string;
begin
  if Wilds = InputStr then begin
    Result := True;
    Exit;
  end;
  repeat { delete '**', because '**' = '*' }
    I := Pos('**', Wilds);
    if I > 0 then
      Wilds := Copy(Wilds, 1, I - 1) + '*' + Copy(Wilds, I + 2, MaxInt);
  until I = 0;
  if Wilds = '*' then begin { for fast end, if Wilds only '*' }
    Result := True;
    Exit;
  end;
  MaxInputWord := Length(InputStr);
  MaxWilds := Length(Wilds);
  if IgnoreCase then begin { upcase all letters }
    InputStr := AnsiUpperCase(InputStr);
    Wilds := AnsiUpperCase(Wilds);
  end;
  if (MaxWilds = 0) or (MaxInputWord = 0) then begin
    Result := False;
    Exit;
  end;
  CInputWord := 1;
  CWild := 1;
  Result := True;
  repeat
    if InputStr[CInputWord] = Wilds[CWild] then begin { equal letters }
      { goto next letter }
      Inc(CWild);
      Inc(CInputWord);
      Continue;
    end;
    if Wilds[CWild] = '?' then begin { equal to '?' }
      { goto next letter }
      Inc(CWild);
      Inc(CInputWord);
      Continue;
    end;
    if Wilds[CWild] = '*' then begin { handling of '*' }
      HelpWilds := Copy(Wilds, CWild + 1, MaxWilds);
      I := SearchNext(HelpWilds);
      LenHelpWilds := Length(HelpWilds);
      if I = 0 then begin
        { no '*' in the rest, compare the ends }
        if HelpWilds = '' then Exit; { '*' is the last letter }
        { check the rest for equal Length and no '?' }
        for I := 0 to LenHelpWilds - 1 do begin
          if (HelpWilds[LenHelpWilds - I] <> InputStr[MaxInputWord - I]) and
            (HelpWilds[LenHelpWilds - I]<> '?') then
          begin
            Result := False;
            Exit;
          end;
        end;
        Exit;
      end;
      { handle all to the next '*' }
      Inc(CWild, 1 + LenHelpWilds);
      I := FindPart(HelpWilds, Copy(InputStr, CInputWord, MaxInt));
      if I= 0 then begin
        Result := False;
        Exit;
      end;
      CInputWord := I + LenHelpWilds;
      Continue;
    end;
    Result := False;
    Exit;
  until (CInputWord > MaxInputWord) or (CWild > MaxWilds);
  { no completed evaluation }
  if CInputWord <= MaxInputWord then Result := False;
  if (CWild <= MaxWilds) and (Wilds[MaxWilds] <> '*') then Result := False;
end;

function FindPart(const HelpWilds, InputStr: string): Integer;
var
  I, J: Integer;
  Diff: Integer;
begin
  I := Pos('?', HelpWilds);
  if I = 0 then begin
    { if no '?' in HelpWilds }
    Result := Pos(HelpWilds, InputStr);
    Exit;
  end;
  { '?' in HelpWilds }
  Diff := Length(InputStr) - Length(HelpWilds);
  if Diff < 0 then begin
    Result := 0;
    Exit;
  end;
  { now move HelpWilds over InputStr }
  for I := 0 to Diff do begin
    for J := 1 to Length(HelpWilds) do begin
      if (InputStr[I + J] = HelpWilds[J]) or
        (HelpWilds[J] = '?') then
      begin
        if J = Length(HelpWilds) then begin
          Result := I + 1;
          Exit;
        end;
      end
      else Break;
    end;
  end;
  Result := 0;
end;

function Hex2Dec(const S: string): Longint;
var
  HexStr: string;
begin
  if Pos('$', S) = 0 then HexStr := '$' + S
  else HexStr := S;
  Result := StrToIntDef(HexStr, 0);
end;

procedure WriteStringToStream(Stream: TStream; St: String);
var
  Len: Integer;
begin
  Len:= Length(St);
  Stream.Write(Len, 4);
  if Len>0 then
    Stream.Write(St[1], Len);
end;

function ReadStringFromStream(Stream: TStream): String;
var
  Len: Integer;
begin
  result:= '';
  Stream.Read(Len, SizeOf(Len));
  if Len>0 then
  begin
    SetLength(result, Len);
    Stream.Read(result[1], Len);
  end;
end;

function StringByValue(IntValue: Integer; Values: String): String; overload;
begin
  result:= ExtractWord(IntValue, Values, ';');
end;

function StringByValue(BoolValue: Boolean; Values: String='No;Yes'): String; overload;
begin
  result:= StringByValue(Byte(BoolValue)+1, Values);
end;

function CompressString(Value: String): String;

var
  ZStream: TCompressionStream;
  IStream, OStream: TMemoryStream;
  OSize: Integer;
begin
  if Value='' then Exit;
  IStream:= TMemoryStream.Create;
  try
    IStream.Write(Value[1], Length(Value));
    OStream:= TMemoryStream.Create;
    try
      OSize:= Length(Value);
      OStream.Write(OSize, SizeOf(OSize));
      ZStream:= TCompressionStream.Create(clMax, OStream);
      try
        ZStream.CopyFrom(IStream, 0);
      finally
        ZStream.Free
      end;
      OStream.Seek(0,0);
      SetLength(result, OStream.Size);
      OStream.Read(result[1], OStream.Size);
    finally
      OStream.Free;
    end;
  finally
    IStream.Free;
  end;
end;

function DeCompressString(Value: String): String;
var
  ZStream: TDeCompressionStream;
  IStream, OStream: TMemoryStream;
  ZSize: Integer;
begin
  if Value='' then Exit;
  IStream := TMemoryStream.Create;
  try
    IStream.Write(Value[1], Length(Value));
    IStream.Position := 0;
    IStream.Read(ZSize, SizeOf(ZSize));
    OStream := TMemoryStream.Create;
    try
      ZStream := TDecompressionStream.Create(IStream);
      try
        OStream.CopyFrom(ZStream, ZSize);
      finally
        ZStream.Free;
      end;
      OStream.Seek(0,0);
      SetLength(result, ZSize);
      OStream.Read(result[1], ZSize);
    finally
      OStream.Free;
    end;
  finally
    IStream.Free;
  end;
end;

function CopyHashPair(Value: String): String;
var
  PEqual, PComma, PDotComma, PDvKavNext, P: Integer;
begin
  Result:= '';
  if Value='' then exit;
  P:= 0;
  try
    PComma:= PosEx(',', Value);
    PDotComma:= PosEx(';', Value);
    P:= Min(PComma, PDotComma);
    if P=0 then
      P:= Max(PComma, PDotComma);
    if P=0 then
      Exit;  // Тока 1 элемент хэша
    PEqual:= PosEx('=', Value);
    if PEqual= 0 then
      Exit;  // Нет символа "="
    if P<PEqual then
      Exit;  // "=" от другого элемента хэша
    // прокидываем пробелы до информационных символов
    while Value[PEqual+1] < #32 do Inc(PEqual);
    // если начинается строковая
    if Value[PEqual+1]='"' then
    begin
      P:= PEqual;
      While Value[P+1]='"' do
      begin
        PDvKavNext:= PosEx('"', Value, P+2);
        if PDvKavNext=0 then
          raise Exception.CreateFmt('Нарушение парности кавычек в выражении "%s"', [Value])
        else
          P:= PDvKavNext;
      end
    end;
  finally
    if P=0 then P:= Length(Value);
    if Value[P] in [';', ','] then Dec(P);
    result:= Copy(Value, 1, P);
  end;
end;

function TakeHashPair(var Value: String): String;
begin
  result:= CopyHashPair(Value);
  if result<>'' then
  begin
    Delete(Value,1,Length(result));
    if Value<>'' then
      Delete(Value, 1, 1);
  end;
end;

function PosFirstChar(St: String; KeyChar: String; StartPos: Integer=1): Integer;
var
  i, LSt: Integer;
begin
  result:= 0;
  LSt:= Length(St);
  For i:= StartPos to LSt do
    if Pos(St[i], KeyChar)>0 then
    begin
      result:= i;
      break;
    end;
end;

function DeleteDoubleChar(St: String; Ch: Char=#32): String;
var
  i, j, LSt: Integer;
begin
  LSt:= Length(St);
  SetLength(result, LSt);
  j:= 0;
  i:= 1;
  while i<LSt do
  begin
    if (St[i]<>Ch) or ((St[i]=Ch) and (St[i+1]<>Ch)) then
    begin
      j:= succ(j);
      result[j]:= St[i];
    end;
    i:= Succ(i);
  end;
  j:= succ(j);
  if i<=Length(St) then
    result[j]:= st[i];
  SetLength(result, j);
end;

function DeleteDoubleSpace(St: String): String; overload;
begin
  result:= DeleteDoubleChar(St);
end;

function DeleteChars(St: String; KeyChars: String): String;
var
  i, lr, LSt: integer;
begin
  LSt:= Length(St);
  SetLength(result, LSt);
  lr:= 0;
  i:= 1;
  while i<=LSt do
  begin
    if Pos(St[i], KeyChars)=0 then
    begin
      Inc(lr);
      result[lr]:=St[i];
    end;
    Inc(i);
  end;
  SetLength(result, lr);
end;




function ReplaceBeforeString(St, EndSt, NewSt: String;
  CaseSensitive: Boolean=false): String;
var
  ps, pe, lr: Integer;
  LStE, LStN, LSt: Integer;
  LowSt: String;
begin
  LStE:= Length(EndSt);
  LStN:= Length(NewSt);
  LSt:= Length(St);
  if LStN>LStE then
    SetLength(result, Length(St)-LStE+LStN)
  else
    SetLength(result, Length(St));
  if Not CaseSensitive then
  begin
    LowSt:= AnsiLowerCase(St);
    EndSt:= AnsiLowerCase(EndSt);
  end
  else
    LowSt:= St;
  lr:= 0;
  ps:= PosEx(EndSt, LowSt);
  if ps=0 then
  begin
    Move(St[1], result[1], LSt);
    lr:= LSt;
  end
  else
  begin
    if LStN>0 then
    begin
      Move(NewSt[1], result[lr+1], LStN);
      Inc(lr, LStN);
    end;
    pe:= ps+LStE-1;
    Move(St[pe+1], result[lr+1], LSt-pe);
    inc(lr, LSt-pe);
  end;
  SetLength(result, lr);
end;


function ReplaceAfterString(St, StartSt, NewSt: String;
  CaseInsensitive: Boolean=false): String;
var
  ps, lr: Integer;
  LStS, LStN, LSt: Integer;
  LowSt: String;
begin
  LStS:= Length(StartSt);
  LStN:= Length(NewSt);
  LSt:= Length(St);
  if LStN>LStS then
    SetLength(result, Length(St)-LStS+LStN)
  else
    SetLength(result, Length(St));
  if CaseInsensitive then
  begin
    LowSt:= AnsiLowerCase(St);
    StartSt:= AnsiLowerCase(StartSt);
  end
  else
    LowSt:= St;
  lr:= 0;
  repeat
    ps:= PosEx(StartSt, LowSt, lr+1);
    if ps=0 then break;
    lr:= ps;
  until false;
  if lr=0 then
  begin
    lr:= LSt;
    Move(St[1], result[1], LSt);
  end
  else
  begin
    Dec(lr);
    Move(St[1], result[1], lr);
    Move(NewSt[1], result[lr+1], LStN);
  end;
  SetLength(result, lr);
end;

function ReplaceAll(ASt, ASubSt, ANewSt: String;
  ACaseSensitive: Boolean=false): String; overload;
var
  PSB, PSE, lr: Integer;
  LSS, LSN, LS: Integer;
  LSt: String;
begin
  LSS:= Length(ASubSt);
  LSN:= Length(ANewSt);
  LS:= Length(ASt);
  if LSN > LSS then
    SetLength(result, Round(LS*(LSN/LSS)))
  else
    SetLength(result, LS);
  if ACaseSensitive then LSt:= ASt else
  begin
    LSt:= AnsiLowerCase(ASt);
    ASubSt:= AnsiLowerCase(ASubSt);
  end;
  lr:= 0;
  PSE:= 0;
  repeat
    PSB:= PosEx(ASubSt, LSt, PSE+1);
    if PSB = 0 then break;
    Move(ASt[PSE+1], result[lr+1], ((PSB-1)-PSE)*SizeOf(Char));
    Inc(lr, (PSB-1)-PSE);
    if LSN > 0 then
    begin
      Move(ANewSt[1], result[lr+1], LSN*SizeOf(Char));
      Inc(lr, LSN);
    end;
    PSE:= PSB+LSS-1;
  until false;
  Move(ASt[PSE+1], result[lr+1], (LS-PSE)*SizeOf(Char));
  inc(lr, LS-PSE);
  SetLength(result, lr);
end;

function ReplaceAllBE(ASt, ABegin, AContain1, AContain2, AContain3, AEnd, ANew: String;
  ACaseSensitive: Boolean = false): String; overload;
var
  LSB, LSC1, LSC2, LSC3, LSE, LSN, LR, LSR: Integer;
  PSB, PSC1, PSC2, PSC3, PSES, PSEN: Integer;
  LSt, RSt: String;
begin
  LSB:= Length(ABegin);
  LSE:= Length(AEnd);
  LSN:= Length(ANew);
  LSC1:= Length(AContain1);
  LSC2:= Length(AContain2);
  LSC3:= Length(AContain3);
  SetLength(result, Length(ASt));
  if ACaseSensitive then LSt:= ASt else
  begin
    LSt:= AnsiLowerCase(ASt);
    ABegin:= AnsiLowerCase(ABegin);
    AEnd:= AnsiLowerCase(AEnd);
    AContain1:= AnsiLowerCase(AContain1);
    AContain2:= AnsiLowerCase(AContain2);
    AContain3:= AnsiLowerCase(AContain3);
  end;
  LR:= 0;
  PSES:= 0;
  try
    repeat
      PSEN:= PSES;
      repeat
        PSB:= PosEx(ABegin, LSt, PSEN+1);
        if PSB = 0 then exit;
        PSEN:= PosEx(AEnd, LSt, PSB+LSB);
        if PSEN = 0 then exit;
        // Начинаем уменьшать жадность
        PSB:= NextPos(ABegin, LSt, PSB, PSEN);
        RSt:= Copy(LSt, PSB+LSB, PSEN-PSB-LSB-1);
        LSR:= Length(RSt);
        if LSC1 <> 0 then
        begin
          PSC1:= PosEx(AContain1, RSt);
          if PSC1 = 0 then continue;
          RSt:= Copy(RSt, PSC1+LSC1, LSR);
          if LSC2 <> 0 then
          begin
            PSC2:= PosEx(AContain2, RSt);
            if PSC2 = 0 then continue;
            RSt:= Copy(RSt, PSC2+LSC2, LSR);
            if LSC3 <> 0 then
            begin
              PSC3:= PosEx(AContain3, RSt);
              if PSC3 = 0 then continue;
            end;
          end;
        end;
        break
      until false;
      Move(ASt[PSES+1], result[lr+1], (PSB-1)-PSES);
      inc(lr, (PSB-1)-PSES);
      if LSN > 0 then
      begin
        Move(ANew[1], result[lr+1], LSN);
        inc(lr, LSN);
      end;
      PSES:= PSEN+LSE-1;
    until false;
  finally
    Move(ASt[PSES+1], result[lr+1], Length(ASt)-PSES);
    inc(lr, Length(ASt)-PSES);
    SetLength(result, lr);
  end;
end;

function ReplaceAllBEKeyChar(ASt, ABegin: String; AKeyChar: String; ANew: String;
  ACaseSensitive: Boolean = false): String; overload;
var
  LSB, LSN, LR, LS: Integer;
  PSB, PSES, PSEN: Integer;
  LSt: String;
begin
  LSB:= Length(ABegin);
  LSN:= Length(ANew);
  LS:= Length(ASt);
  SetLength(result, LS);
  if ACaseSensitive then LSt:= ASt else
  begin
    LSt:= AnsiLowerCase(ASt);
    ABegin:= AnsiLowerCase(ABegin);
  end;
  PSES:= 0;
  lr:= 0;
  repeat
    PSB:= PosEx(ABegin, LSt, PSES+1);
    if PSB = 0 then break;
    PSEN:= PosFirstChar(LSt, AKeyChar, PSB+LSB);
    if PSEN = 0 then break;
    PSB:= NextPos(ABegin, LSt, PSB, PSEN);
    Move(ASt[PSES+1], result[lr+1], (PSB-1)-PSES);
    inc(lr, (PSB-1)-PSES);
    if LSN>0 then
    begin
      Move(ANew[1], result[lr+1], LSN);
      inc(lr, LSN);
    end;
    PSES:= PSEN-1;
  until false;
  Move(ASt[PSES+1], result[lr+1], LS-PSES);
  inc(lr, LS-PSES);
  SetLength(result, lr);
end;

function ReplaceAllBE(ASt, ABegin, AContain1, AContain2, AEnd, ANew: String;
  ACaseSensitive: Boolean = false): String; overload;
begin
  result:= ReplaceAllBE(ASt, ABegin, AContain1, AContain2, '', AEnd, ANew, ACaseSensitive);
end;

function ReplaceAllBE(ASt, ABegin, AContain1, AEnd, ANew: String;
  ACaseSensitive: Boolean = false): String; overload;
begin
  result:= ReplaceAllBE(ASt, ABegin, AContain1, '', '', AEnd, ANew, ACaseSensitive);
end;

function ReplaceAllBE(ASt, ABegin, AEnd, ANew: String;
  ACaseSensitive: Boolean = false): String; overload;
begin
  result:= ReplaceAllBE(ASt, ABegin, '', '', '', AEnd, ANew, ACaseSensitive);
end;

function ReplaceAllBSE(ASt, ABegin, AContain1, AContain2, AContain3, AEnd, ANew: String;
  ACaseSensitive: Boolean = false): String; overload;
var
  LSB, LSC1, LSC2, LSC3, LSE, LSN, LR, LS: Integer;
  PSB, PSC1, PSC2, PSC3, PSES, PSEN: Integer;
  LSt: String;
begin
  LSB:= Length(ABegin);
  LSE:= Length(AEnd);
  LSN:= Length(ANew);
  LS:= Length(ASt);
  LSC1:= Length(AContain1);
  LSC2:= Length(AContain2);
  LSC3:= Length(AContain3);
  SetLength(result, LS);
  if ACaseSensitive then LSt:= ASt else
  begin
    LSt:= AnsiLowerCase(ASt);
    ABegin:= AnsiLowerCase(ABegin);
    AEnd:= AnsiLowerCase(AEnd);
    AContain1:= AnsiLowerCase(AContain1);
    AContain2:= AnsiLowerCase(AContain2);
    AContain3:= AnsiLowerCase(AContain3);
  end;
  LR:= 0;
  PSES:= 0;
  repeat
    PSB:= PosEx(ABegin, LSt, PSES+1);
    if PSB = 0 then break;
    if LSC1 = 0 then PSC1:= PSB+LSB else
     PSC1:=  PosEx(AContain1, LSt, PSB+LSB);
    if PSC1 = 0 then break;
    if LSC2 = 0 then PSC2:= PSC1+LSC1 else
      PSC2:=  PosEx(AContain2, LSt, PSC1+LSC1);
    if PSC2 = 0 then break;
    if LSC3 = 0 then PSC3:= PSC2+LSC2 else
      PSC3:=  PosEx(AContain3, LSt, PSC2+LSC2);
    if PSC3 = 0 then break;
    PSEN:= PosEx(AEnd, LSt, PSC3+LSC3);
    if PSEN = 0 then break;
    // Начинаем уменьшать жадность
    if LSC3 = 0 then PSC3:= PSEN else
      PSC3:= NextPos(AContain3, LSt, PSC3, PSEN);
    if LSC2 = 0 then PSC2:= PSC3 else
      PSC2:= NextPos(AContain2, LSt, PSC2, PSC3);
    if LSC1 = 0 then PSC1:= PSC2 else
      PSC1:= NextPos(AContain1, LSt, PSC1, PSC2);
    PSB:= NextPos(ABegin, LSt, PSB+1, PSC1);
    Move(ASt[PSES+1], result[lr+1], (PSB-1)-PSES);
    inc(lr, (PSB-1)-PSES);
    if LSN > 0 then
    begin
      Move(ANew[1], result[lr+1], LSN);
      inc(lr, LSN);
    end;
    PSES:= PSEN+LSE-1;
  until false;
  Move(ASt[PSES+1], result[lr+1], LS-PSES);
  inc(lr, LS-PSES);
  SetLength(result, lr);
end;

function ReplaceAllBSE(ASt, ABegin, AContain1, AContain2, AEnd, ANew: String;
  ACaseSensitive: Boolean = false): String; overload;
begin
  result:= ReplaceAllBSE(ASt, ABegin, AContain1, AContain2, '', AEnd, ANew, ACaseSensitive);
end;

function ReplaceAllBSE(ASt, ABegin, AContain1, AEnd, ANew: String;
  ACaseSensitive: Boolean = false): String; overload;
begin
  result:= ReplaceAllBSE(ASt, ABegin, AContain1, '', '', AEnd, ANew, ACaseSensitive);
end;


function DeleteAll(ASt, ASubSt: String;
  ACaseSensitive: Boolean = false): String; overload;
begin
  result:= ReplaceAll(ASt, ASubSt, '', ACaseSensitive);
end;

function DeleteAllBE(ASt, ABegin, AContain1, AContain2, AContain3, AEnd: String;
  ACaseSensitive: Boolean = false): String; overload;
begin
  result:= ReplaceAllBE(ASt, ABegin, AContain1, AContain2, AContain3, AEnd, '', ACaseSensitive);
end;

function DeleteAllBE(ASt, ABegin, AContain1, AContain2, AEnd: String;
  ACaseSensitive: Boolean = false): String; overload;
begin
  result:= ReplaceAllBE(ASt, ABegin, AContain1, AContain2, '', AEnd, '', ACaseSensitive);
end;

function DeleteAllBE(ASt, ABegin, AContain1, AEnd: String;
  ACaseSensitive: Boolean = false): String; overload;
begin
  result:= ReplaceAllBE(ASt, ABegin, AContain1, '', '', AEnd, '', ACaseSensitive);
end;

function DeleteAllBE(ASt, ABegin, AEnd: String;
  ACaseSensitive: Boolean = false): String; overload;
begin
  result:= ReplaceAllBE(ASt, ABegin, '', '', '', AEnd, '', ACaseSensitive);
end;

function DeleteAllBEKeyChar(ASt, ABegin: String; AKeyChar: String;
  ACaseSensitive: Boolean = false): String; overload;
begin
  result:= ReplaceAllBE(ASt, ABegin, AKeyChar, '', ACaseSensitive);
end;


function DeleteAllBSE(ASt, ABegin, AContain1, AContain2, AContain3, AEnd: String;
  ACaseSensitive: Boolean = false): String; overload;
begin
  result:= ReplaceAllBSE(ASt, ABegin, AContain1, AContain2, AContain3, AEnd, '', ACaseSensitive);
end;

function DeleteAllBSE(ASt, ABegin, AContain1, AContain2, AEnd: String;
  ACaseSensitive: Boolean = false): String; overload;
begin
  result:= ReplaceAllBSE(ASt, ABegin, AContain1, AContain2, '', AEnd, '', ACaseSensitive);
end;

function DeleteAllBSE(ASt, ABegin, AContain1, AEnd: String;
  ACaseSensitive: Boolean = false): String; overload;
begin
  result:= ReplaceAllBSE(ASt, ABegin, AContain1, '', '', AEnd, '', ACaseSensitive);
end;


function DeleteAllAttributeWithValue(ASt, AAttributeName, AValue: String): String;
begin
  result:= ReplaceAll(ASt, '"'+AAttributeName+'=', '" '+AAttributeName+'=');
  result:= ReplaceAll(result, ''''+AAttributeName+'=', ''' '+AAttributeName+'=');
  result:= ReplaceAll(result, AAttributeName+' '+'=', AAttributeName+'=');
  result:= ReplaceAll(result, AAttributeName+'= ', AAttributeName+'=');
  result:= DeleteAll(result, ' '+AAttributeName+'="'+AValue+'"');
  result:= DeleteAll(result, ' '+AAttributeName+'='''+AValue+'''');
  result:= DeleteAllBEKeyChar(result, ' '+AAttributeName+'='+AValue, ' >');
end;

function DeleteAllAttribute(ASt, AAttributeName: String): String;
begin
  result:= ReplaceAll(ASt, '"'+AAttributeName+'=', '" '+AAttributeName+'=');
  result:= ReplaceAll(result, ''''+AAttributeName+'=', ''' '+AAttributeName+'=');
  result:= ReplaceAll(result, AAttributeName+' '+'=', AAttributeName+'=');
  result:= ReplaceAll(result, AAttributeName+'= ', AAttributeName+'=');
  result:= DeleteAllBE(result, #9+AAttributeName+'="', '"');
  result:= DeleteAllBE(result, ' '+AAttributeName+'="', '"');
  result:= DeleteAllBE(result, ' '+AAttributeName+'=''', '''');
  result:= DeleteAllBEKeyChar(result, ' '+AAttributeName+'=', ' >');
end;

function TakeAttName(var St: String): String;
begin
  if St='' then
    result:= ''
  else
  begin
    St:= Trim(St);
    result:= TakeFront4(St, ' =');
    St:= Trim(St);
  end;
end;

function TakeAttValue(var St: String): String;
begin
  if (St='') then
    result:= ''
  else
  if St[1]<>'=' then
    result:= ''
  else
  begin
    Delete(St, 1, 1);
    St:= Trim(St);
    if St[1]='"' then
    begin
      Delete(St,1,1);
      result:= TakeFront5(St, '"');
    end
    else
    if St[1]='''' then
    begin
      Delete(St,1,1);
      result:= TakeFront5(St, '''');
    end
    else
      result:= TakeFront5(St, ' ');
    St:= Trim(St);
  end;
end;

procedure StrToList(St: String; List: TStrings; KeyChar: String=';');
begin
  List.Clear;
  StrAppendList(St, List, KeyChar);
end;

procedure StrAppendList(St: String; List: TStrings; KeyChar: String=';');
var
  LKeyChar, i: integer;
begin
  LKeyChar:= Length(KeyChar);
  For i:= 1 to LKeyChar do
    St:= ReplaceAll(St, KeyChar[i], #$0D#$0A);
  List.Text:= List.Text+St;
end;


function GvUtf8ToAnsi(St: String): String;
const
  C3: array [$80..$BF] of char =
    ('A','A','A','A','A','A','A','C','E','E','E','E','I','I','I','I',
     'D','N','O','O','O','O','O','x','O','U','U','U','U','Y','P','s',
     'a','a','a','a','a','a','a','c','e','e','e','e','i','i','i','i',
     't','n','o','o','o','o','o','-','o','u','u','u','u','y','p','y');
  C4: array [$80..$BF] of char =
    ('A','a','A','a','A','a','C','c','C','c','C','c','C','c','D','d',
     'D','d','E','e','E','e','E','e','E','e','E','e','G','g','G','g',
     'G','g','G','g','H','h','H','h','I','i','I','i','I','i','I','i',
     'I','i','I','i','J','j','K','k','k','L','l','L','l','L','l','L');
  C5: array [$80..$BF] of char =
    ('l','L','l','N','n','N','n','N','n','n','N','n','O','o','O','o',
     'O','o','O','o','R','r','R','r','R','r','S','s','S','s','S','s',
     'S','s','T','t','T','t','T','t','U','u','U','u','U','u','U','u',
     'U','u','U','u','W','w','Y','y','Y','Z','z','Z','z','Z','z','l');
  D0: array [$80..$BF] of char =
    ('Е','Ё','Т','Г','Е','S','I','I','J','Л','Н','h','К','Й','У','Ц',
     'А','Б','В','Г','Д','Е','Ж','З','И','Й','К','Л','М','Н','О','П',
     'Р','С','Т','У','Ф','Х','Ц','Ч','Ш','Щ','Ъ','Ы','Ь','Э','Ю','Я',
     'а','б','в','г','д','е','ж','з','и','й','к','л','м','н','о','п');
  D1: array [$80..$9F] of char =
    ('р','с','т','у','ф','х','ц','ч','ш','щ','ъ','ы','ь','э','ю','я',
     'е','е','h','г','е','s','i','i','j','л','н','h','к','й','у','ц');

var
  i, r, LSt: Integer;
  c1, c2: byte;
begin
  LSt:= Length(St);
  i:= 1;
  r:= 0;
  SetLength(result, LSt);
  while i<=LSt do
  begin
    r:= succ(r);
    c1:= byte(St[i]);
    if c1 < $80 then
      result[r]:= st[i]
    else
    begin
      i:= succ(i);
      c2:= byte(St[i]);
      case c1 of
        $C3: begin
               result[r]:= C3[c2];
               if c2 in [$86, $9F, $A6, $B0] then
               begin
                 r:= succ(r);
                 case c2 of
                   $86: result[r]:= 'E';
                   $9F: result[r]:= 's';
                   $A6: result[r]:= 'e';
                   $B0: result[r]:= 'h';
                 end
               end
             end;
        $C4: begin
               result[r]:= C4[c2];
               if c2 in [$B2, $B3] then
               begin
                 r:= succ(r);
                 case c2 of
                   $B2: result[r]:= 'J';
                   $B3: result[r]:= 'j';
                 end
               end
             end;
        $C5: begin
               result[r]:= C4[c2];
               if c2 in [$92, $93] then
               begin
                 r:= succ(r);
                 case c2 of
                   $92: result[r]:= 'E';
                   $93: result[r]:= 'e';
                 end
               end
             end;
        $D0: begin
               result[r]:= D0[c2];
               if c2 in [$89, $8A] then
               begin
                 r:= succ(r);
                 case c2 of
                   $89: result[r]:= 'Ь';
                   $8A: result[r]:= 'Ь';
                 end
               end
             end;
        $D1: begin
               result[r]:= D1[c2];
               if c2 in [$99, $9A] then
               begin
                 r:= succ(r);
                 case c2 of
                   $99: result[r]:= 'ь';
                   $9A: result[r]:= 'ь';
                 end
               end
             end;
      else
      begin
        Result[r]:= '?';
        i:= pred(i);
      end
      end;
    end;
    i:= succ(i);
  end;
  SetLength(result, r);
//  result:= Utf8ToAnsi(result);
end;

{Convert string from UTF-8 format mixed with standart ASCII symbols($00..$7f)}
//function UTF8ToStrSmart(Value: String): String;
//var
//  Digit: String;
//  i: Integer;
//  HByte: Byte;
//  Len: Byte;
//begin
//  Result := '';
//  Len := 0;
//  if Value = '' then Exit;
//  for i := 1 to Length(Value) do
//  begin
//    if Len > 0 then
//    begin
//      Digit := Digit + Value[i];
//      Dec(Len);
//      if Len = 0 then
//        Result := Result + UTF8ToStr(Digit);
//    end else
//    begin
//      HByte := Ord(Value[i]);
//      if HByte in [$00..$7f] then       //Standart ASCII chars
//        Result := Result + Value[i]
//      else begin
//        //Get length of UTF-8 char
//        if HByte and $FC = $FC then
//          Len := 6
//        else if HByte and $F8 = $F8 then
//          Len := 5
//        else if HByte and $F0 = $F0 then
//          Len := 4
//        else if HByte and $E0 = $E0 then
//          Len := 3
//        else if HByte and $C0 = $C0 then
//          Len := 2
//        else begin
//          Result := Result + Value[i];
//          Continue;
//        end;
//        Dec(Len);
//        Digit := Value[i];
//      end;
//    end;
//  end;
//end;

function EscapeString(St: String; AddChar: String = ''): string;
const
  EscChar : string = '|,<>"''=';
var
  i: Byte;
  EscChars : WideString;
begin
  EscChars:= EscChar + AddChar;
  for i:= 1 to Length(EscChars) do
    St:= ReplaceAll(St, EscChars[i], '&#'+IntToStr(ord(EscChars[i]))+';');
  result:= St;
end;

function EscapeString(St: WideString; AddChar: WideString = ''): WideString;
const
  EscChar : WideString = '|,<>"''=';
var
  i: Byte;
  EscChars : WideString;
begin
  EscChars:= EscChar + AddChar;
  for i:= 1 to Length(EscChars) do
    St:= ReplaceAll(St, EscChars[i], '&#'+IntToStr(ord(EscChars[i]))+';');
  result:= St;
end;

function UnEscapeString(St: Ansistring; AddChar: AnsiString = ''): AnsiString;
const
  EscChar : WideString = '|,';
var
  i: Byte;
  EscChars: WideString;
begin
  EscChars:= EscChar + AddChar;
  for i:= 1 to Length(EscChars) do
    St:= ReplaceAll(St, '&#'+IntToStr(ord(EscChars[i]))+';', EscChars[i] );
  result:= St;
end;

function UnEscapeString(St: WideString): WideString;
var
  P: Integer;
  EscChar: WideString;
begin
  P:= PosEx('&#', St, 1);
  while P > 0 do
  begin
    EscChar:= CopyBetween(St, '&#', ';', P);
    if FilterString(EscChar, '0123456789') = EscChar then
      St:= ReplaceAll(St, '&#'+EscChar+';', Chr(StrToInt(EscChar)));
    P:= PosEx('&#', St, P);
  end;
  result:= St;
end;


function FilterString(St, KeyChars: string): string;
var
  RLen, SLen, i: Integer;
begin
  RLen:= 0;
  SLen:= Length(St);
  SetLength(Result, SLen);
  for i:= 1 to SLen do
    if Pos(St[i], KeyChars) > 0 then
    begin
      RLen:= succ(RLen);
      Result[RLen]:= st[i];
    end;
  SetLength(Result, RLen);
end;

function Translit(St: string): string;
const
  Rus='АБВГДЕЖЗИЙКЛМНОПРСТУФХЪЫЭабвгдежзийклмнопрстуфхъыэ';
  Lat='ABVGDEJZIYKLMNOPRSTUFH`YEabvgdejziyklmnoprstufh`ye';
var
  Mapping: TStringList;
  i, lr, p: Integer;
begin
  Result:= St;
  Mapping:= TStringList.Create;
  try
    Mapping.Text:= ReplaceAll('Лю=Liu;лю=liu;ё=yo;Ч=Ch;ч=ch;Ш=Sh;ш=sh;Щ=Sch;щ=sch;Ю=Yu;ю=yu;Я=Ya;я=ya;Ц=Ts;ц=ts;ь=', ';', #13#10);
    for i:= 0 to Mapping.count - 1 do
      Result:= ReplaceAll(Result, Mapping.Names[i], Mapping.ValueFromIndex[i], true);
  finally
    Mapping.Free;
  end;
  lr:= Length(Result);
  for i:= 1 to lr do
  begin
    p:= Pos(Result[i], Rus);
    if p > 0 then
      Result[i]:= Lat[p];
  end;
end;

function DeTranslit(St: string): string;
const
  Rus='АБВГДЕЖЗИЙКЛМНОПРСТУФХЪЫЭабвгдежзийклмнопрстуфхъыэ';
  Lat='ABVGDEJZIYKLMNOPRSTUFH`YEabvgdejziyklmnoprstufh`ye';
var
  Mapping: TStringList;
  i, lr, p: Integer;
begin
  Result:= St;
  Mapping:= TStringList.Create;
  try
    Mapping.Text:= ReplaceAll(
      'Liu=Лю;liu=лю;yo=ё;Ch=Ч;ch=ч;Sh=Ш;sh=ш;Sch=Щ;sch=щ;Yu=Ю;yu=ю;Ya=Я;ya=я;'+
      'Ts=Ц;ts=ц;Ci=Цы;ci=цы;Ca=Ка;C=Ц;c=ц', ';', #13#10);
    for i:= 0 to Mapping.count - 1 do
      Result:= ReplaceAll(Result, Mapping.Names[i], Mapping.ValueFromIndex[i], true);
  finally
    Mapping.Free;
  end;
  lr:= Length(Result);
  for i:= 1 to lr do
  begin
    p:= Pos(Result[i], Lat);
    if p > 0 then
      Result[i]:= Rus[p];
  end;
end;

function UpCaseFirst(St: string): string;
begin
  Result:= AnsiUpperCase(Copy(St, 1, 1)) + AnsiLowerCase(Copy(St, 2, Length(St)));
end;

function UpCaseWord(St: string; KeyChars: string=' ,.!-:?'): string;
var
  i, Len: integer;
  StartWord: Boolean;
begin
  Len:= Length(St);
  Result:= '';
  Result:= AnsiLowerCase(St);
  StartWord:= true;
  for i:= 1 to Len do
  begin
    if StartWord then
    begin
      Result[i]:= AnsiUpperCase(Copy(St, i, 1))[1];
      StartWord:= false;
    end
    else
      StartWord:= Pos(St[i], KeyChars) > 0;
  end;
end;

function IsWordPresent(aWord, aWordList, aDelimiter: String): Boolean;
begin
  result:= Pos(aDelimiter+aWord+aDelimiter, aDelimiter+aWordList+aDelimiter) > 0;
end;

function FormatString(aStr, aFormat: string): String;
var
  l: Integer;
  s: string;
  Ch: Char;
begin
  result:= aFormat;
  l:= Length(aStr);
  repeat
    s:= CopyBetween(Result, '[', ']');
    if s <> '' then
    begin
      if StrToInt(s)>l then Ch:= ' ' else Ch:= aStr[StrToInt(s)];
      Result:= ReplaceAll(Result, '['+s+']', Ch);
    end;
  until s = '';
end;

function CoalesceStr(aStr1, aStr2: string): string;
begin
  if aStr1 <> '' then
    Result:= aStr1
  else
    Result:= aStr2;
end;

end.
