unit GvDtTm;

interface
{$I Gvindln.inc}

function DayOfYear(ADate: TDateTime): integer;
function DateOfYear(aDayNo: Word): TDateTime;

function YearNo(DtTm: TDateTime):Word;
function NumYearNo(NumDate: Longint): Word;

function MonthNo(DtTm: TDateTime):Word;
function NumMonthNo(NumDate: Longint): Word;

function DayNo(DtTm: TDateTime):Word;
function NumDayNo(NumDate: Longint): Word;

function HourNo(DtTm:TDateTime):Word;


function DaysInMonth(DtTm: TDateTime): Word;

function DateToInt(DtTm:TDateTime): LongInt;

function TimeToInt(DtTm:TDateTime): LongInt;

function MonthName(MonthNo: Byte; Padeg: byte=0): String;

function DateToNumDate(DtTm:TDateTime): LongInt;

function IntToDate(IntDate: LongInt): TDateTime;

function NumDateToDate(NumDate: LongInt): TDateTime;

function StrToNumDate(St: String; Fmt:String='DMY'): LongInt;
function NumDateToStr(NumDate: LongInt): String;

function DateInRange(DtTm, StartDtTm, EndDtTm: TDateTime): Boolean;

function MaxDateTime(aDtTm: Array of TDateTime): TDateTime;
function MinDateTime(aDtTm: Array of TDateTime): TDateTime;

function DateTimeToHex(aDtTm: TDateTime): String;
function HexToDateTime(aDtTm: String): TDateTime;

function DateTimeToDtTm(aDtTm: TDateTime): String;
function DtTmToDateTime(aDtTm: String): TDateTime;
function DtTmToStr(aDtTm: String): String;
function StrToDtTm(Str: String): String;

function FormatDtTm(Format, aDtTm: String): String;
function FormatNumDtTm(Format: String; NumDate: Longint): String;

function DateToPath(aDtTm: TDateTime; Order: String='YM';
         ExpandMonth: Boolean=true): String;

function YMToPath(aYear, aMonth: Extended; ExpandMonth: Boolean=true): String;

function UYMToPath(User: String; aYear, aMonth: Extended; ExpandMonth: Boolean=false): String;

function DateTimeStrEval(const DateTimeFormat : string;
                         const DateTimeStr : string) : TDateTime;

implementation

uses
  SysUtils, GvStr, Classes, DateUtils;

function DayOfYear(ADate: TDateTime): integer;
var
  FirstOfYear: TDateTime;
begin
  FirstOfYear := EncodeDate(YearNo(ADate), 01, 01);
  Result      := Trunc(ADate) - Trunc(FirstOfYear);
end;

function DateOfYear(aDayNo: Word): TDateTime;
begin
  result:= IncDay(StartOfTheYear(Date), aDayNo-1);
end;

function YearNo(DtTm:TDateTime):Word;
var
  Y,M,D: Word;
begin
  DecodeDate(DtTm,Y,M,D);
  result:= Y;
end;

function NumYearNo(NumDate: Longint): Word;
begin
  result:= YearNo(NumDateToDate(NumDate));
end;

function MonthNo(DtTm:TDateTime):Word;
var
  Y,M,D: Word;
begin
  DecodeDate(DtTm,Y,M,D);
  result:= M;
end;

function NumMonthNo(NumDate: Longint): Word;
begin
  result:= MonthNo(NumDateToDate(NumDate));
end;

function DayNo(DtTm:TDateTime):Word;
var
  Y,M,D: Word;
begin
  DecodeDate(DtTm,Y,M,D);
  result:= D;
end;
function NumDayNo(NumDate: Longint): Word;
begin
  result:= DayNo(NumDateToDate(NumDate));
end;

function HourNo(DtTm:TDateTime):Word;
var
  H,M,S,S100:Word;
begin
  DecodeTime(DtTm, H, M, S, S100);
  Result:= H; 
end;

function DaysInMonth(DtTm: TDateTime): Word;
var
  Y,M,D: Word;
begin
  DecodeDate(DtTm, Y,M,D);
  DtTm:= EncodeDate(Y,M,1);
  DtTm:= IncMonth(DtTm,1)-1;
  DecodeDate(DtTm, Y,M,result);
end;

function DateToNumDate(DtTm:TDateTime): LongInt;
var
  Y,M,D: Word;
begin
  DecodeDate(DtTm,Y,M,D);
  result:= Y*10000+M*100+D;
end;

function DateToInt(DtTm:TDateTime): LongInt;
var
  Y,M,D: Word;
begin
  DecodeDate(DtTm,Y,M,D);
  result:= Y*10000+M*100+D;
end;

function IntToDate(IntDate: LongInt): TDateTime;
var
  Y, M, D: Word;
begin
  if IntDate<999999 then
  begin
    D:= IntDate div 10000;
    Dec(IntDate, D*10000);
    M:= IntDate div 100;
    Dec(IntDate, M*100);
    Y:= IntDate+2000;
  end
  else
  begin
    D:= IntDate div 1000000;
    Dec(IntDate, D*1000000);
    M:= IntDate div 10000;
    Dec(IntDate, M*10000);
    Y:= IntDate;
  end;
  result:= EncodeDate(Y,M,D)
end;

function NumDateToDate(NumDate: LongInt): TDateTime;
var
  Y,M,D: Word;
begin
  if NumDate<999999 then Inc(NumDate, 20000000);
  Y:= NumDate div 10000;
  Dec(NumDate, Y*10000);
  M:= NumDate div 100;
  Dec(NumDate, M*100);
  D:= NumDate;
  result:= EncodeDate(Y,M,D)
end;

function StrToNumDate(St: String; Fmt:String='DMY'): LongInt;
var
  r: String;
  sl: TStringList;
begin
  sl:= TStringList.Create;
  StrToList(St, sl, '/.');
  if Fmt='DMY' then
    r:= sl[2]+sl[1]+sl[0]
  else if Fmt='MDY' then
    r:= sl[2]+sl[0]+sl[1]
  else
    r:= '';
  sl.Free;
  if Length(r)=6 then r:= '20'+r;
  result:= StrToInt(r);
end;

function NumDateToStr(NumDate: LongInt): String;
var
  St: String;
begin
  result:= '';
  if Numdate>9999 then
  begin
    if NumDate<999999 then Inc(NumDate, 20000000);
    St:= IntToStr(NumDate);
    result:= Copy(St,7,2)+'.'+Copy(St,5,2)+'.'+Copy(St,1,4);
  end;
end;

function FormatNumDtTm(Format: String; NumDate: Longint): String;
begin
  result:= FormatDateTime(Format,NumDateToDate(NumDate));
end;


function TimeToInt(DtTm:TDateTime): LongInt;
var
  H, M, S, Ms: Word;
begin
  DecodeTime(DtTm, H, M, S, ms);
  result:= H*10000+M+100+S;
end;

function MonthName(MonthNo: Byte; Padeg: byte=0): String;
var
  LCh: Char;
begin
  if MonthNo in [1..12] then
  begin
    result:= {$IFDEF D_XE6+}FormatSettings.{$ENDIF}LongMonthNames[MonthNo];
    LCh:= TakeLastChar(result);
    case Padeg of
      1: if LCh in ['ь','й'] then result:= result+'я' else result:= result+LCh+'а';
      2: if LCh in ['ь','й'] then result:= result+'ю' else result:= result+LCh+'у';
      4: if LCh in ['ь','й'] then result:= result+'ем' else result:= result+LCh+'ом';
      5: if LCh in ['ь','й'] then result:= result+'е' else result:= result+LCh+'e';
    else
        result:= result+LCh;
    end
  end
  else
    result:= '';
end;

function DateInRange(DtTm, StartDtTm, EndDtTm: TDateTime): Boolean;
begin
  result:= (DtTm>=StartDtTm) and (DtTm<=EndDtTm);
end;

function MaxDateTime(aDtTm: Array of TDateTime): TDateTime;
var
  i: Integer;
begin
  result:= aDtTm[0];
  for i := 1 to High(aDtTm) do
    if result < aDtTm[i] then result:= aDtTm[i];
end;

function MinDateTime(aDtTm: Array of TDateTime): TDateTime;
var
  i: Integer;
begin
  result:= aDtTm[0];
  for i := 1 to High(aDtTm) do
    if result < aDtTm[i] then result:= aDtTm[i];
end;

function DateTimeToHex(aDtTm: TDateTime): String;
var
  P: PByteArray;
  i: Integer;
begin
  P:= @aDtTm;
  result:= '';
  For i:= 7 downto 0 do
    result:= result+IntToHex(P^[i],2);
end;

function DateTimeToDtTm(aDtTm: TDateTime): String;
var
  Y,M,D,H,Mn,S, MS: Word;
begin
  DecodeDate(aDtTm, Y, M, D);
  DecodeTime(aDtTm, H, Mn, S, MS);
  result:= Format('%4.4u%2.2u%2.2u%2.2u%2.2u%2.2u',[Y,M,D,H,Mn,S]);
end;

function DtTmToDateTime(aDtTm: String): TDateTime;
begin
  aDtTm:= FillBack(aDtTm, 14, '0');
  result:= EncodeDate(StrToInt(Copy(aDtTm, 1, 4)),
                      StrToInt(Copy(aDtTm, 5, 2)),
                      StrToInt(Copy(aDtTm, 7, 2)))+
           EncodeTime(StrToInt(Copy(aDtTm, 9, 2)),
                      StrToInt(Copy(aDtTm, 11, 2)),
                      StrToInt(Copy(aDtTm, 13, 2)), 1);
end;

function FormatDtTm(Format, aDtTm: String): String;
begin
  result:= FormatDateTime(Format, DtTmToDateTime(aDtTm));
end;

function DtTmToStr(aDtTm: String): String;
begin
  result:= DateTimeToStr(DtTmToDateTime(aDtTm));
  if Length(result)<10 then
    result:= result+'  0:00:00';
end;

function StrToDtTm(Str: String): String;
begin
  result:= DateTimeToDtTm(StrToDateTime(Str))
end;

function HexToDateTime(aDtTm: String): TDateTime;
const
  Hex= '0123456789ABCDEF';
var
  P: PByteArray;
  i: Integer;
  DtTm: TDateTime;
  S: String;
begin
  P:= @DtTm;
  For i:= 7 downto 0 do
  begin
    S:= Take(aDtTm, 1, 2);
    P^[i]:= byte((Pos(S[1],Hex)-1)*16+Pos(S[2],Hex)-1);
  end;
  result:= DtTm;
end;

function DateToPath(aDtTm: TDateTime; Order: String='YM';
         ExpandMonth: Boolean=true): String;
var
  i: Byte;
begin
  Order:= UpperCase(Order);
  Result:= '';
  For i:= 1 to Length(Order) do
  begin
    Case Order[i] of
      'Y': Result:= Result + Format('%u\', [YearNo(aDtTm)]);
      'M': if ExpandMonth then
             Result:= Result+FillFront(IntToStr(MonthNo(aDtTm)),2,'0')+'\'
           else
             Result:= Result + Format('%u\', [MonthNo(aDtTm)]);
      'D': Result:= Result + Format('%u\', [DayNo(aDtTm)]);
    end;
  end;
end;

function YMToPath(aYear, aMonth: Extended; ExpandMonth: Boolean=true): String;
begin
  if aYear<100 then aYear:= aYear+2000;
  if ExpandMonth then
    Result:= IntToStr(Trunc(aYear))+'\'+
             FillFront(IntToStr(Trunc(aMonth)), 2, '0')+'\'
  else
    Result:= IntToStr(Trunc(aYear))+'\'+IntToStr(Trunc(aMonth))+'\';
end;

function UYMToPath(User: String; aYear, aMonth: Extended;
  ExpandMonth: Boolean=false): String;
begin
  if aYear<100 then aYear:= aYear+2000;
  if ExpandMonth then
    Result:= User+'\'+IntToStr(Trunc(aYear))+'\'+
             FillFront(IntToStr(Trunc(aMonth)), 2, '0')+'\'
  else
    Result:= User+'\'+IntToStr(Trunc(aYear))+'\'+IntToStr(Trunc(aMonth))+'\';
end;

//=============================================================================
// Evaluate a date time string into a TDateTime obeying the
// rules of the specified DateTimeFormat string
// eg. DateTimeStrEval('dd-MMM-yyyy hh:nn','23-May-2002 12:34)
//
// NOTE : One assumption I have to make that DAYS,MONTHS,HOURS and
//        MINUTES have a leading ZERO or SPACE (ie. are 2 chars long)
//        and MILLISECONDS are 3 chars long (ZERO or SPACE padded)
//
// Supports DateTimeFormat Specifiers
//
// dd    the day as a number with a leading zero or space (01-31).
// ddd the day as an abbreviation (Sun-Sat)
// dddd the day as a full name (Sunday-Saturday)
// mm    the month as a number with a leading zero or space (01-12).
// mmm the month as an abbreviation (Jan-Dec)
// mmmm the month as a full name (January-December)
// yy    the year as a two-digit number (00-99).
// yyyy the year as a four-digit number (0000-9999).
// hh    the hour with a leading zero or space (00-23)
// nn    the minute with a leading zero or space (00-59).
// ss    the second with a leading zero or space (00-59).
// zzz the millisecond with a leading zero (000-999).
// ampm  Specifies am or pm flag hours (0..12)
// ap    Specifies a or p flag hours (0..12)
//
//
// Delphi 6 Specific in DateUtils can be translated to ....
//
// YearOf()
//
// function YearOf(const AValue: TDateTime): Word;
// var LMonth, LDay : word;
// begin
//   DecodeDate(AValue,Result,LMonth,LDay);
// end;
//
// TryEncodeDateTime()
//
// function TryEncodeDateTime(const AYear,AMonth,ADay,AHour,AMinute,ASecond,
//                            AMilliSecond : word;
//                            out AValue : TDateTime): Boolean;
// var LTime : TDateTime;
// begin
//   Result := TryEncodeDate(AYear, AMonth, ADay, AValue);
//   if Result then begin
//     Result := TryEncodeTime(AHour, AMinute, ASecond, AMilliSecond, LTime);
//     if Result then
//       AValue := AValue + LTime;
//   end;
// end;
//
// =============================================================================
function DateTimeStrEval(const DateTimeFormat : string;
                         const DateTimeStr : string) : TDateTime;
var i,ii,iii : integer;
    Retvar : TDateTime;
    Tmp,
    Fmt,Data,Mask,Spec : string;
    Day, Month, Year, Hour, Minute, Second, MSec, AmPm : integer;
  LSt: Integer;
begin
  Year:= 0;
  Month:= 0;
  Day:= 0;
  Hour:= 0;
  Minute:= 0;
  Second:= 0;
  MSec:= 0;
  Fmt := UpperCase(DateTimeFormat);
  Data := UpperCase(DateTimeStr);
  i := 1;
  Mask := '';
  AmPm := 0;

  try
    while i < length(Fmt) do
    begin
      if Data = '' then Exit;
      if Fmt[i] in ['A','P','D','M','Y','H','N','S','Z'] then
      begin
        // Start of a date specifier
        Mask  := Fmt[i];
        ii := i + 1;

        // Keep going till not valid specifier
        while true do
        begin
          if ii > length(Fmt) then Break; // End of specifier string
          Spec := Mask + Fmt[ii];

          if (Spec = 'DD') or (Spec = 'DDD') or (Spec = 'DDDD') or
             (Spec = 'MM') or (Spec = 'MMM') or (Spec = 'MMMM') or
             (Spec = 'YY') or (Spec = 'YYY') or (Spec = 'YYYY') or
             (Spec = 'HH') or (Spec = 'NN') or (Spec = 'SS') or
             (Spec = 'ZZ') or (Spec = 'ZZZ') or (Spec = 'ZZZZ') or
             (Spec = 'AP') or (Spec = 'AM') or (Spec = 'AMP') or
             (Spec = 'AMPM') then
          begin
            Mask := Spec;
            inc(ii);
          end
          else // End of or Invalid specifier
            Break;
        end;

        // Got a valid specifier ? - evaluate it from data string
        if (Mask <> '') and (length(Data) > 0) then
        begin
          // Day 1..31
          if (Mask = 'DD') then
          begin
             Day := StrToIntDef(trim(copy(Data,1,2)),0);
             delete(Data,1,2);
          end;

          // Day Sun..Sat (Just remove from data string)
          if Mask = 'DDD' then delete(Data,1,3);

          // Day Sunday..Saturday (Just remove from data string LEN)
          if Mask = 'DDDD' then
          begin
            Tmp := copy(Data,1,3);
            for iii := 1 to 7 do
            begin
              if Tmp = Uppercase(copy({$IFDEF D_XE6+}FormatSettings.{$ENDIF}LongDayNames[iii],1,3)) then
              begin
                delete(Data,1,length({$IFDEF D_XE6+}FormatSettings.{$ENDIF}LongDayNames[iii]));
                Break;
              end;
            end;
          end;

          // Month 1..12
          if (Mask = 'MM') then
          begin
             Month := StrToIntDef(trim(copy(Data,1,2)),0);
             delete(Data,1,2);
          end;

          // Month Jan..Dec
          if Mask = 'MMM' then
          begin
            Tmp := copy(Data,1,3);
            for iii := 1 to 12 do
            begin
              if Tmp = Uppercase(copy({$IFDEF D_XE6+}FormatSettings.{$ENDIF}LongMonthNames[iii],1,3)) then
              begin
                Month := iii;
                delete(Data,1,3);
                Break;
              end;
            end;
          end;


          // Month January..December
          if Mask = 'MMMM' then
          begin
            Tmp := copy(Data,1,3);
            for iii := 1 to 12 do
            begin
              if Tmp = Uppercase(copy({$IFDEF D_XE6+}FormatSettings.{$ENDIF}LongMonthNames[iii],1,3)) then
              begin
                Month := iii;
                delete(Data,1,length({$IFDEF D_XE6+}FormatSettings.{$ENDIF}LongMonthNames[iii]));
                Break;
              end;
            end;
          end;

          // Year 2 Digit
          if Mask = 'YY' then
          begin
            Year := StrToIntDef(copy(Data,1,2),0);
            delete(Data,1,2);
            if Year < {$IFDEF D_XE6+}FormatSettings.{$ENDIF}TwoDigitYearCenturyWindow then
              Year := (YearNo(Date) div 100) * 100 + Year
            else
              Year := (YearNo(Date) div 100 - 1) * 100 + Year;
          end;

          // Year 4 Digit
          if Mask = 'YYYY' then
          begin
            Year := StrToIntDef(copy(Data,1,4),0);
            delete(Data,1,4);
            if Year < 1000 then
              Exit;
          end;

          // Hours
          if Mask = 'HH' then
          begin
             Hour := StrToIntDef(trim(copy(Data,1,2)),0);
             delete(Data,1,2);
          end;

          // Minutes
          if Mask = 'NN' then
          begin
             Minute := StrToIntDef(trim(copy(Data,1,2)),0);
             delete(Data,1,2);
          end;

          // Seconds
          if Mask = 'SS' then
          begin
             Second := StrToIntDef(trim(copy(Data,1,2)),0);
             delete(Data,1,2);
          end;

          // Milliseconds
          if Mask = 'ZZ' then
          begin
             MSec := StrToIntDef(trim(copy(Data,1,2)),0);
             delete(Data,1,3);
          end;
          if Mask = 'ZZZ'then
          begin
             MSec := StrToIntDef(trim(copy(Data,1,3)),0);
             delete(Data,1,3);
          end;
          if Mask = 'ZZZZ' then
          begin
             MSec := StrToIntDef(trim(copy(Data,1,3)),0);
             delete(Data,1,4);
          end;


          // AmPm A or P flag
          if (Mask = 'AP') then
          begin
             if Data[1] = 'A' then
               AmPm := -1
             else
               AmPm := 1;
             delete(Data,1,1);
          end;

          // AmPm AM or PM flag
          if (Mask = 'AM') or (Mask = 'AMP') or (Mask = 'AMPM') then
          begin
             if copy(Data,1,2) = 'AM' then
               AmPm := -1
             else
               AmPm := 1;
             delete(Data,1,2);
          end;

          Mask := '';
          i := ii;
        end;
      end
      else begin
        // Remove delimiter from data string
        if length(Data) > 1 then delete(Data,1,1);
        inc(i);
      end;
    end;

    if AmPm = 1 then Hour := Hour + 12;
  finally
    if TryEncodeDateTime(Year,Month,Day,Hour,Minute,Second,MSec,Retvar) then
      Result := Retvar
    else
      Result := 0.0;
  end;
end;

end.
