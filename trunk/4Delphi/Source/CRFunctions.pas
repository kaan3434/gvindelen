
//////////////////////////////////////////////////
//  Copyright © 1998-2011 Devart. All right reserved.
//  CRFunctions
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I Dac.inc}

unit CRFunctions;
{$ENDIF}
interface

uses
  Classes, {$IFDEF VER6P}Variants,{$ENDIF} CRTypes;

{$IFDEF VER6}
  function StrToBool(const S: string): Boolean;
  function TryStrToBool(const S: string; out Value: Boolean): Boolean;
{$ENDIF}

{ Delphi 5 support }

{$IFNDEF VER6P}
  function TryStrToInt(const S: string; out Value: Integer): Boolean;
  function BoolToStr(const Value: boolean; UseBoolStrs: Boolean = False): string;
  function TryStrToBool(const S: string; out Value: Boolean): Boolean;
  function StrToBool(const S: string): Boolean;
  procedure DecodeDateTime(const AValue: TDateTime; out AYear, AMonth, ADay,
    AHour, AMinute, ASecond, AMilliSecond: Word);
  function WideUpperCase(const S: WideString): WideString;
  function VarToWideStr(const V: Variant): WideString;
  function VarIsStr(const V: Variant): Boolean;
  function AnsiDequotedStr(const S: string; AQuote: Char): string;
  function AnsiContainsText(const AText, ASubText: string): Boolean;
{$ENDIF}

{ Unicode build support }

  function _LowerCase(const S: _string): _string;
  function _UpperCase(const S: _string): _string;
  function _CompareText(const S1, S2: _string): Integer;
  function _SameText(const S1, S2: _string): Boolean;
  function _QuotedStr(const S: _string; AQuote: _char): _string;
  function _DequotedStr(const S: _string; AQuote: _char): _string;
  function _VarToStr(const V: Variant): _string;
  function _Format(const AFormat: _string; const Args: array of const): _string;

  procedure AssignStrings(Source: _TStrings; Dest: TStrings); overload;
{$IFDEF CRUNICODE}
  procedure AssignStrings(Source: TStrings; Dest: _TStrings); overload;
{$ENDIF}

{ POSIX support }

{$IFDEF POSIX}
  function GetTickCount: Cardinal;

  function InterlockedIncrement(var I: Integer): Integer;
  function InterlockedDecrement(var I: Integer): Integer;

  function WideCharToMultiByte(CodePage: Cardinal; dwFlags: Cardinal;
    lpWideCharStr: PWideChar; cchWideChar: Integer; lpMultiByteStr: PAnsiChar;
    cchMultiByte: Integer; lpDefaultChar: PAnsiChar; lpUsedDefaultChar: PLongBool): Integer;
  function MultiByteToWideChar(CodePage: Cardinal; dwFlags: Cardinal;
    const lpMultiByteStr: PAnsiChar; cchMultiByte: Integer;
    lpWideCharStr: PWideChar; cchWideChar: Integer): Integer;
{$ENDIF}

{ FPC support}

{$IFDEF FPC}

{$IFDEF UNIX}
function GetTickCount: Cardinal;
{$ENDIF}

{$IFDEF CPUX64}
function VarArrayCreate(const Bounds: array of Integer; aVarType: TVarType): Variant;
{$ENDIF}

{$ENDIF}

function SwapLongWord(const Value: LongWord): LongWord;

implementation

uses
{$IFDEF VER6}
  SysConst,
{$ENDIF}
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
{$IFDEF POSIX}
  System.Diagnostics,
{$ENDIF}
{$IFDEF UNIX}
  unix,
{$ENDIF}
  SysUtils;

{$IFDEF VER6}
procedure ConvertErrorFmt(ResString: PResStringRec; const Args: array of const); local;
begin
  raise EConvertError.CreateResFmt(ResString, Args);
end;

function StrToBool(const S: string): Boolean;
begin
  if not TryStrToBool(S, Result) then
    ConvertErrorFmt(@SInvalidBoolean, [S]);
end;

procedure VerifyBoolStrArray;
begin
  if Length(TrueBoolStrs) = 0 then
  begin
    SetLength(TrueBoolStrs, 1);
    TrueBoolStrs[0] := DefaultTrueBoolStr;
  end;
  if Length(FalseBoolStrs) = 0 then
  begin
    SetLength(FalseBoolStrs, 1);
    FalseBoolStrs[0] := DefaultFalseBoolStr;
  end;
end;

function TryStrToBool(const S: string; out Value: Boolean): Boolean;

  function CompareWith(const aArray: array of string): Boolean;
  var
    I: Integer;
  begin
    Result := False;
    for I := Low(aArray) to High(aArray) do
      if AnsiSameText(S, aArray[I]) then
      begin
        Result := True;
        Break;
      end;
  end;

var
  LResult: Extended;
begin
  Result := TryStrToFloat(S, LResult);
  if Result then
    Value := LResult <> 0
  else
  begin
    VerifyBoolStrArray;
    Result := CompareWith(TrueBoolStrs);
    if Result then
      Value := True
    else
    begin
      Result := CompareWith(FalseBoolStrs);
      if Result then
        Value := False;
    end;
  end;
end;
{$ENDIF}

{ Delphi 5 support }

{$IFNDEF VER6P}

function TryStrToInt(const S: string; out Value: Integer): Boolean;
var
  E: Integer;
begin
  Val(S, Value, E);
  Result := E = 0;
end;

function BoolToStr(const Value: boolean; UseBoolStrs: Boolean = False): string;
const
  cSimpleBoolStrs: array [boolean] of String = ('0', '-1');
begin
  if UseBoolStrs then
  begin
    if Value then
      Result := 'True'
    else
      Result := 'False';
  end
  else
    Result := cSimpleBoolStrs[Value];
end;

function TryStrToBool(const S: string; out Value: Boolean): Boolean;
begin
  Result := True;
  if SameText(s, 'True') or SameText(s, 'Yes') or SameText(s, '1') then
    Value := True
  else
  if SameText(s, 'False') or SameText(s, 'No') or SameText(s, '0') then
    Value := False
  else
    Result := False;
end;

function StrToBool(const S: string): Boolean;
begin
  if not TryStrToBool(S, Result) then
    raise EConvertError.Create('InvalidBoolean - ' + S);
end;

type
  PWordBool = ^WordBool;

procedure DecodeDateTime(const AValue: TDateTime; out AYear, AMonth, ADay,
  AHour, AMinute, ASecond, AMilliSecond: Word);
begin
  DecodeDate(AValue, AYear, AMonth, ADay);
  DecodeTime(AValue, AHour, AMinute, ASecond, AMilliSecond);
end;

function WideUpperCase(const S: WideString): WideString;
var
  Len: Integer;
begin
  Len := Length(S);
  SetString(Result, PWideChar(S), Len);
  if Len > 0 then CharUpperBuffW(Pointer(Result), Len);
end;

function VarToWideStr(const V: Variant): WideString;
begin
  if not VarIsNull(V) then
    Result := V
  else
    Result := '';;
end;

function VarIsStr(const V: Variant): Boolean;
begin
  case VarType(V) of
    varString, varOleStr:
      Result := True;
  else
    Result := False;
  end;
end;

function AnsiDequotedStr(const S: string; AQuote: Char): string;
var
  LText: PChar;
begin
  LText := PChar(S);
  Result := AnsiExtractQuotedStr(LText, AQuote);
  if Result = '' then
    Result := S;
end;

function AnsiContainsText(const AText, ASubText: string): Boolean;
begin
  Result := AnsiPos(AnsiUppercase(ASubText), AnsiUppercase(AText)) > 0;
end;
{$ENDIF}

{ Unicode build support }

function _LowerCase(const S: _string): _string;
begin
{$IFDEF CRUNICODE}
  Result := WideLowerCase(S);
{$ELSE}
  Result := AnsiLowerCase(S);
{$ENDIF}
end;

function _UpperCase(const S: _string): _string;
begin
{$IFDEF CRUNICODE}
  Result := WideUpperCase(S);
{$ELSE}
  Result := AnsiUpperCase(S);
{$ENDIF}
end;

function _CompareText(const S1, S2: _string): Integer;
begin
{$IFDEF CRUNICODE}
  Result := WideCompareText(S1, S2);
{$ELSE}
  Result := AnsiCompareText(S1, S2);
{$ENDIF}
end;

function _SameText(const S1, S2: _string): Boolean;
begin
{$IFDEF CRUNICODE}
  Result := WideSameText(S1, S2);
{$ELSE}
  Result := AnsiSameText(S1, S2);
{$ENDIF}
end;

function _QuotedStr(const S: _string; AQuote: _char): _string;
{$IFDEF CRUNICODE}
var
  I: Integer;
begin
  Result := S;
  for I := Length(Result) downto 1 do
    if Result[I] = AQuote then Insert(AQuote, Result, I);
  Result := AQuote + Result + AQuote;
end;
{$ELSE}
begin
  Result := AnsiQuotedStr(S, AQuote);
end;
{$ENDIF}

function _DequotedStr(const S: _string; AQuote: _char): _string;
{$IFDEF CRUNICODE}
var
  i, len: Integer;
begin
  len := Length(S);
  if (len >= 2) and (S[1] = AQuote) and (S[len] = AQuote) then begin
    Result := Copy(S, 2, len - 2);
    len := len - 2;
    i := len;
    while i >= 2 do begin
      if (Result[i] = AQuote) and (Result[i-1] = AQuote) then begin
        Delete(Result, i, 1);
        Dec(i, 2);
      end
      else
        Dec(i);
    end;
  end
  else
    Result := S;
end;
{$ELSE}
begin
  Result := AnsiDequotedStr(S, AQuote);
end;
{$ENDIF}

function _VarToStr(const V: Variant): _string;
begin
{$IFDEF CRUNICODE}
  Result := VarToWideStr(V);
{$ELSE}
  Result := VarToStr(V);
{$ENDIF}
end;

function _Format(const AFormat: _string; const Args: array of const): _string;
begin
{$IFDEF CRUNICODE}
  Result := WideFormat(AFormat, Args);
{$ELSE}
  Result := Format(AFormat, Args);
{$ENDIF}
end;

procedure AssignStrings(Source: _TStrings; Dest: TStrings);
{$IFDEF CRUNICODE}
var
  i: Integer;
{$ENDIF}
begin
{$IFDEF CRUNICODE}
  Dest.BeginUpdate;
  try
    Dest.Clear;
    for i := 0 to Source.Count - 1 do
      Dest.Add(Source[i]);
  finally
    Dest.EndUpdate;
  end;
{$ELSE}
  Dest.Assign(Source);
{$ENDIF}
end;

{$IFDEF CRUNICODE}
procedure AssignStrings(Source: TStrings; Dest: _TStrings);
var
  i: Integer;
begin
  Dest.BeginUpdate;
  try
    Dest.Clear;
    for i := 0 to Source.Count - 1 do
      Dest.Add(Source[i]);
  finally
    Dest.EndUpdate;
  end;
end;
{$ENDIF}

{ POSIX support }

{$IFDEF POSIX}

function GetTickCount: Cardinal;
{$IFDEF MACOS}
begin
  Result := TStopwatch.GetTimeStamp div 10000;
end;
{$ENDIF}
{$IFDEF LINUX}
var
  t: tms;
begin
  Result := Cardinal(Int64(Cardinal(times(t)) * 1000) div sysconf(_SC_CLK_TCK));
end;
{$ENDIF}

function InterlockedIncrement(var I: Integer): Integer;
asm
{$IFNDEF CPUX64}
      MOV   EDX,1
      XCHG  EAX,EDX
 LOCK XADD  [EDX],EAX
      INC   EAX
{$ELSE}
      MOV   EAX,1
 LOCK XADD  dword ptr [RCX],EAX
      INC   EAX
{$ENDIF}
end;

function InterlockedDecrement(var I: Integer): Integer;
asm
{$IFNDEF CPUX64}
      MOV   EDX,-1
      XCHG  EAX,EDX
 LOCK XADD  [EDX],EAX
      DEC   EAX
{$ELSE}
      MOV   EAX,-1
 LOCK XADD  dword ptr [RCX],EAX
      DEC   EAX
{$ENDIF}
end;

function WideCharToMultiByte(CodePage: Cardinal; dwFlags: Cardinal;
  lpWideCharStr: PWideChar; cchWideChar: Integer; lpMultiByteStr: PAnsiChar;
  cchMultiByte: Integer; lpDefaultChar: PAnsiChar; lpUsedDefaultChar: PLongBool): Integer;
begin
  Result := LocaleCharsFromUnicode(CodePage, dwFlags, lpWideCharStr, cchWideChar, lpMultiByteStr, cchMultiByte, lpDefaultChar, lpUsedDefaultChar);
end;

function MultiByteToWideChar(CodePage: Cardinal; dwFlags: Cardinal;
  const lpMultiByteStr: PAnsiChar; cchMultiByte: Integer;
  lpWideCharStr: PWideChar; cchWideChar: Integer): Integer;
begin
  Result := UnicodeFromLocaleChars(CodePage, dwFlags, lpMultiByteStr, Integer(cchMultiByte), lpWideCharStr, cchWideChar);
end;
{$ENDIF}

{ FPC support}

{$IFDEF FPC}

{$IFDEF UNIX}
function GetTickCount: Cardinal;
var
  tv: timeval;
begin
  fpgettimeofday(@tv, nil);
  {$RANGECHECKS OFF}
  Result := int64(tv.tv_sec) * 1000 + tv.tv_usec div 1000;
end;
{$ENDIF}

{$IFDEF CPUX64}
function VarArrayCreate(const Bounds: array of Integer; aVarType: TVarType): Variant;
var
  i: integer;
  Bounds64: array of Int64;
begin
  SetLength(Bounds64, Length(Bounds));
  for i := 0 to Length(Bounds) - 1 do
    Bounds64[i] := Bounds[i];
  Result :=  Variants.VarArrayCreate(Bounds64, aVarType);
end;
{$ENDIF}

{$ENDIF}

function SwapLongWord(const Value: LongWord): LongWord;
begin
  Result:= ((Value and $FF) shl 24) or ((Value and $FF00) shl 8) or ((Value and $FF0000) shr 8) or ((Value and $FF000000) shr 24);
end;

end.
