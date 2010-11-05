unit GvUDFStr;

interface

function malloc(Size: Integer): PChar; cdecl; external 'msvcrt.dll';

function CopyFront_WithKey(CString, KeyString: PChar): PChar; cdecl; export;
function CopyFront_WithOutKey(CString, KeyString: PChar): PChar; cdecl; export;

//function CopyBack_3(CString, KeyString: PChar): PChar; cdecl; export;
//function CopyBack_4(CString, KeyString: PChar): PChar; cdecl; export;

function Copy_Start_End(CString, CStart, CEnd: PChar; var FromPos, Len: Integer): PChar; cdecl; export;
function Copy_Between(CString, CStart, CEnd: PChar; var FromPos, Len: Integer): PChar; cdecl; export;

implementation

uses
  SysUtils;

type
  TKeyChar= Set Of Char;

function Min(Value1, Value2: Integer): Integer;
begin
  if Value1>Value2 then
    result:= Value2
  else
    result:= Value1;
end;

function StrToKeyChars(Str: AnsiString): TKeyChar;
var
  i, LStr: Integer;
begin
  result:= [];
  LStr:= Length(Str);
  For i:= 1 to LStr do
    result:= result+[Str[i]];
end;

function CopyFront_WithKey(CString, KeyString: PChar): PChar; cdecl; export;
var
  KCh: TKeyChar;
  LStr: Integer;
  Len: Integer;
begin
  KCh:= StrToKeyChars(KeyString);
  LStr:= StrLen(CString);
  Len:= 0;
  while (Len<LStr) and not(CString[Len] in KCh) do
    Len:= Succ(Len);
  while (Len<LStr) and (CString[Len] in KCh) do
    Len:= Succ(Len);
  result:= malloc(Succ(Len));
  StrLCopy(result, CString, Len);
end;

function CopyFront_WithOutKey(CString, KeyString: PChar): PChar; cdecl; export;
var
  KCh: TKeyChar;
  LStr: Integer;
  Len: Integer;
begin
  KCh:= StrToKeyChars(KeyString);
  LStr:= StrLen(CString);
  Len:= 0;
  while (Len<LStr) and not(CString[Len] in KCh) do
    len:= Succ(Len);
  result:= malloc(Succ(Len));
  StrLCopy(result, CString, Len);
  while (Len<LStr) and (CString[Len] in KCh) do
    Len:= Succ(Len);
end;

function Copy_Back_3(CString, KeyString: PChar): PChar; cdecl; export;
var
  KCh: TKeyChar;
  LenS, i: Integer;
begin
  KCh:= StrToKeyChars(KeyString);
  LenS:= StrLen(CString);
  i:= 0;
  while (i<LenS) and not(CString[LenS-1-i] in KCh) do
    inc(i);
  while (i<LenS) and (CString[LenS-1-i] in KCh) do
    inc(i);
  result:= malloc(i);
  StrLCopy(result, CString+LenS-i, i-1);
end;

function Copy_Back_4(CString, KeyString: PChar): PChar; cdecl; export;
var
  KCh: TKeyChar;
  LenS, i: Integer;
begin
  KCh:= StrToKeyChars(KeyString);
  LenS:= StrLen(CString);
  i:= 0;
  while (i<LenS) and not(CString[LenS-1-i] in KCh) do
    inc(i);
  result:= malloc(i);
  StrLCopy(result, CString+LenS-i, i-1);
end;

{function Str_Length(CString: PChar): Integer; cdecl; export;
begin
  Result := StrLen(CString);
end;

function Copy_From_To(CString: PChar; var FromPos, ToPos: Integer): PChar; cdecl; export;
var
  LStr, LSubStr: Integer;
begin
  LStr := StrLen(CString);
  FromPos:= Min(FromPos, LStr);
  ToPos:= Min(ToPos, LStr);
  FromPos:= Pred(FromPos);
  ToPos:= Pred(ToPos);
  LSubStr:= Succ(ToPos-FromPos);
  result:= malloc(Succ(LSubStr));
  StrLCopy(result, CString+FromPos, LSubStr);
end;

function Copy_From_Len(CString: PChar; var FromPos, Len: Integer): PChar; cdecl; export;
var
  LStr: Integer;
begin
  LStr := StrLen(CString);
  FromPos:= Min(FromPos, LStr);
  FromPos:= Pred(FromPos);
  Len:= Min(Len, LStr-FromPos);
  result:= malloc(Succ(Len));
  StrLCopy(result, CString+FromPos, Len);
end;
}

function Copy_Start_End(CString, CStart, CEnd: PChar; var FromPos, Len: Integer): PChar; cdecl; export;
var
  LStart, LEnd: Integer;
  PStart, PStart2, PEnd: PChar;
begin
  result:= nil;
  FromPos:= -1;
  Len:=0;
  LStart:= StrLen(CStart);
  LEnd:= StrLen(CEnd);
  PStart:= StrPos(CString, CStart);
  PEnd:= StrPos(PStart+LStart, CEnd);
  if PEnd=nil then Exit;
  PStart2:= StrPos(PStart+LStart, CStart);
  while (PStart2<>nil) and (PStart2<PEnd) do
  begin
    PStart:= PStart2;
    PStart2:= StrPos(PStart+LStart, CStart);
  end;
  Len:= PEnd - PStart + LEnd;
  FromPos:= Succ(PStart-CString);
  result:= malloc(Succ(Len));
  StrLCopy(result, PStart, Len);
end;

function Copy_Between(CString, CStart, CEnd: PChar; var FromPos, Len: Integer): PChar; cdecl; export;
var
  LStart: Integer;
  PStart, PStart2, PEnd: PChar;
begin
  result:= nil;
  FromPos:= -1;
  Len:=0;
  LStart:= StrLen(CStart);
  PStart:= StrPos(CString, CStart);
  PEnd:= StrPos(PStart+LStart, CEnd);
  if PEnd=nil then Exit;
  PStart2:= StrPos(PStart+LStart, CStart);
  while (PStart2<>nil) and (PStart2<PEnd) do
  begin
    PStart:= PStart2;
    PStart2:= StrPos(PStart+LStart, CStart);
  end;
  Len:= PEnd - PStart - LStart;
  FromPos:= Succ(PStart-CString) + LStart;
  result:= malloc(Succ(Len));
  StrLCopy(result, PStart+LStart, Len);
end;

end.
