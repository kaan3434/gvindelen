unit GvUDFStrUnicode;

interface

function ib_util_malloc(l: integer): pointer; cdecl; external 'ib_util.dll';

function CopyFront_WithKey_UTF8(const CString, CKeyString: PAnsiChar): PAnsiChar; cdecl; export;
function CopyFront_WithOutKey_UTF8(const CString, CKeyString: PAnsiChar): PAnsiChar; cdecl; export;

function Copy_Start_End_UTF8(const CString, CStart, CEnd: PAnsiChar;
  var FromPos: Integer): PAnsiChar; cdecl; export;
function Copy_Between_UTF8(const CString, CStart, CEnd: PAnsiChar;
  var FromPos: Integer): PAnsiChar; cdecl; export;

function Recode_UTF8(const CString, CMask: PAnsiChar): PAnsiChar; cdecl; export;

function CharCount_UTF8(const CString, CChars: PAnsiChar): Integer; cdecl; export;
function StrLen_UTF8(const CString: PAnsiChar): Integer; cdecl; export;
function StrLenMM_inner(CString: WideString; FontSize: integer): Integer;
function StrLenMM_UTF8(const CString: PAnsiChar; var FontSize: integer): Integer; cdecl; export;
function EscapeString_UTF8(const CString: PAnsiChar): PAnsiChar; cdecl; export;
function EscapeStringEx_UTF8(const CString, CAddChars: PAnsiChar): PAnsiChar; cdecl; export;
function UnEscapeString_UTF8(const CString: PAnsiChar): PAnsiChar; cdecl; export;
function UnEscapeStringEx_UTF8(const CString, CAddChars: PAnsiChar): PAnsiChar; cdecl; export;

function StrPos_UTF8(const CSubString, CString: PAnsiChar): Integer; cdecl; export;
function ToFloat(const CString: PAnsiChar): Single; cdecl; export;
function FormatValue_UTF8(const CString, CFormatter: PAnsiChar): PAnsiChar; cdecl; export;

implementation

uses
  Windows, GvStr, SysUtils, StrUtils, Graphics;

//function ChangeMyString(const p: PChar): PChar; cdecl;
//var
//  s: string;
//begin
//  s := DoSomething(string(p));
//  Result := ib_util_malloc(Length(s) + 1);
//  StrPCopy(Result, s);
//end;

function Min(Value1, Value2: Integer): Integer;
begin
  if Value1>Value2 then
    result:= Value2
  else
    result:= Value1;
end;

function CopyFront_WithKey_UTF8(const CString, CKeyString: PAnsiChar): PAnsiChar; cdecl; export;
var
  uResult: Utf8string;
  wString, wKeyString, wResult: WideString;
  lResult: integer;
begin
  wString:= UTF8Decode(utf8string(CString));
  wKeyString:= UTF8Decode(utf8string(CKeyString));
  wResult:= CopyFront3(wString, wKeyString);
  uResult:= UTF8Encode(wResult);
  lResult:= Length(uResult);
  Result:= ib_util_malloc(lResult+1);
  StrPCopy(Result, uResult);
end;

function CopyFront_WithOutKey_UTF8(const CString, CKeyString: PAnsiChar): PAnsiChar; cdecl; export;
var
  uResult: Utf8string;
  wString, wKeyString, wResult: WideString;
  lResult: integer;
begin
  wString:= UTF8Decode(utf8string(CString));
  wKeyString:= UTF8Decode(utf8string(CKeyString));
  wResult:= CopyFront4(wString, wKeyString);
  uResult:= UTF8Encode(wResult);
  lResult:= Length(uResult);
  Result:= ib_util_malloc(lResult+1);
  StrPCopy(Result, uResult);
end;

function Copy_Start_End_UTF8(const CString, CStart, CEnd: PAnsiChar;
  var FromPos: Integer): PAnsiChar; cdecl; export;
var
  uResult: Utf8string;
  wString, wStart, wEnd, wResult: WideString;
  lResult: integer;
begin
  wString:= UTF8Decode(utf8string(CString));
  wStart:= UTF8Decode(utf8string(CStart));
  wEnd:= UTF8Decode(utf8string(CEnd));
  wResult:= CopyBE(wString, wStart, '', '', '', wEnd, FromPos);
  uResult:= UTF8Encode(wResult);
  lResult:= Length(uResult);
  Result:= ib_util_malloc(lResult+1);
  StrPCopy(Result, uResult);
end;

function Copy_Between_UTF8(const CString, CStart, CEnd: PAnsiChar;
  var FromPos: Integer): PAnsiChar; cdecl; export;
var
  uResult: Utf8string;
  wString, wStart, wEnd, wResult: WideString;
  lResult: integer;
begin
  wString:= UTF8Decode(utf8string(CString));
  wStart:= UTF8Decode(utf8string(CStart));
  wEnd:= UTF8Decode(utf8string(CEnd));
  wResult:= CopyBetween(wString, wStart, '', '', '', wEnd, FromPos);
  uResult:= UTF8Encode(wResult);
  lResult:= Length(uResult);
  Result:= ib_util_malloc(lResult+1);
  StrPCopy(Result, uResult);
end;

function FormatValue_UTF8(const CString, CFormatter: PAnsiChar): PAnsiChar; cdecl; export;
var
  uResult: Utf8string;
  wFormatter, wResult, wFormatFunc, wFormatFuncParams: WideString;
  aResult: string;
  lResult: integer;
begin
  wResult:= UTF8Decode(utf8string(CString));
  wFormatter:= UTF8Decode(utf8string(CFormatter));
  aResult:= FormatterStr(string(wResult), string(wFormatter));
  uResult:= AnsiToUtf8(aResult);
  lResult:= Length(uResult);
  Result:= ib_util_malloc(lResult+1);
  StrPCopy(Result, uResult);
end;

function Recode_inner(const CString, CMask: WideString): WideString;
var
  Ch: WideChar;
  Len, LMask, PMask, PSkob: Integer;
begin
  Len:= 0;
  PMask:= 1;
  LMask:= Length(CMask);
  SetLength(result, LMask);
  while (PMask <= LMask) do
  begin
    Ch:= CMask[PMask];
    Inc(Len);
    if Ch = '[' then
    begin
      Inc(PMask);
      PSkob:= PosEx(']', CMask, PMask);
      try
        Ch:= CString[StrToInt(copy(CMask, PMask, PSkob-PMask))];
      except
        Ch:= ' ';
      end;
      PMask:= succ(PSkob);
    end
    else
      inc(PMask);
    result[Len]:= Ch;
  end;
  SetLength(result, Len);
end;


function Recode_UTF8(const CString, CMask: PAnsiChar): PAnsiChar; cdecl; export;
var
  uResult: Utf8string;
  wString, wMask, wResult: WideString;
  lResult: integer;
begin
  wString:= UTF8Decode(utf8string(CString));
  wMask:= UTF8Decode(utf8string(CMask));
  wResult:= Recode_inner(wString, wMask);
  uResult:= UTF8Encode(wResult);
  lResult:= Length(uResult);
  Result:= ib_util_malloc(lResult+1);
  StrPCopy(Result, uResult);
end;

function CharCount_inner(CString: WideString; CChar: WideChar): integer; cdecl; export;
var
  LSt, i: Integer;
begin
  LSt:= Length(CString);
  result:= 0;
  for i:= 1 to LSt do
    if CString[i] = CChar then
      inc(result);
end;

function CharCount_UTF8(const CString, CChars: PAnsiChar): Integer; cdecl; export;
var
  wString, wChars: WideString;
begin
  wChars:= UTF8Decode(utf8string(CChars));
  if wChars<>'' then
  begin
    wString:= UTF8Decode(utf8string(CString));
    Result:= CharCount_inner(wString, wChars[1]);
  end
  else
    Result:= 0;
end;

function StrLen_UTF8(const CString: PAnsiChar): Integer; cdecl; export;
var
  wString: WideString;
begin
  wString:= UTF8Decode(utf8string(CString));
  Result:= Length(wString);
end;

function StrLenMM_inner(CString: WideString; FontSize: integer): Integer;
const
  PPI = 96;
var
  BitMap: TBitmap;
begin
  BitMap:= TBitmap.Create;
  try
    Bitmap.Height:=100;
    BitMap.Width:= 100;
    BitMap.PixelFormat:= pf1bit;
    BitMap.Canvas.Font.Name:= 'Mipgost';
    BitMap.Canvas.Font.Size:= FontSize;
    BitMap.Canvas.Font.Style:= [fsBold, fsItalic];
    BitMap.Canvas.Font.PixelsPerInch:= PPI;
    Result:= BitMap.Canvas.TextWidth(CString);
    Result:= Round(Result / PPI * 25.4);
  finally
    BitMap.free;
  end;
end;

function StrLenMM_UTF8(const CString: PAnsiChar; var FontSize: integer): Integer; cdecl; export;
var
  wString: WideString;
begin
  wString:= UTF8Decode(utf8string(CString));
  result:= StrLenMM_inner(wString, FontSize);
end;

function StrPos_UTF8(const CSubString, CString: PAnsiChar): Integer; cdecl; export;
var
  wString, wSubString: WideString;
begin
  wString:= UTF8Decode(utf8string(CString));
  wSubString:= UTF8Decode(utf8string(CSubString));
  Result:= Pos(wSubString, wString);
end;

function StrSize(const CString: PAnsiChar): Integer; cdecl; export;
begin
  Result:= Length(CString);
end;

function EscapeString_UTF8(const CString: PAnsiChar): PAnsiChar; cdecl; export;
var
  uResult: Utf8string;
  wString, wResult: WideString;
  lResult: integer;
begin
  wString:= UTF8Decode(utf8string(CString));
  wResult:= EscapeString(wString);
  uResult:= UTF8Encode(wResult);
  lResult:= Length(uResult);
  Result:= ib_util_malloc(lResult+1);
  StrPCopy(Result, uResult);
end;

function EscapeStringEx_UTF8(const CString, CAddChars: PAnsiChar): PAnsiChar; cdecl; export;
var
  uResult: Utf8string;
  wString, wAddChars, wResult: WideString;
  lResult: integer;
begin
  wString:= UTF8Decode(utf8string(CString));
  wAddChars:= UTF8Decode(utf8string(CAddChars));
  wResult:= EscapeString(wString, wAddChars);
  uResult:= UTF8Encode(wResult);
  lResult:= Length(uResult);
  Result:= ib_util_malloc(lResult+1);
  StrPCopy(Result, uResult);
end;

function UnEscapeString_UTF8(const CString: PAnsiChar): PAnsiChar; cdecl; export;
var
  uResult: Utf8string;
  wString, wResult: WideString;
  lResult: integer;
begin
  wString:= UTF8Decode(utf8string(CString));
  wResult:= UnEscapeString(wString);
  uResult:= UTF8Encode(wResult);
  lResult:= Length(uResult);
  Result:= ib_util_malloc(lResult+1);
  StrPCopy(Result, uResult);
end;

function UnEscapeStringEx_UTF8(const CString, CAddChars: PAnsiChar): PAnsiChar; cdecl; export;
var
  uResult: Utf8string;
  wString, wAddChars, wResult: WideString;
  lResult: integer;
begin
  wString:= UTF8Decode(utf8string(CString));
  wAddChars:= UTF8Decode(utf8string(CAddChars));
  wResult:= UnEscapeString(wString, wAddChars);
  uResult:= UTF8Encode(wResult);
  lResult:= Length(uResult);
  Result:= ib_util_malloc(lResult+1);
  StrPCopy(Result, uResult);
end;

function ToFloat(const CString: PAnsiChar): Single; cdecl; export;
begin
  if DecimalSeparator = ',' then
    Result:= StrToFloat(ReplaceAll(CString, '.', ','))
  else
    Result:= StrToFloat(ReplaceAll(CString, ',', '.'));
end;

end.
