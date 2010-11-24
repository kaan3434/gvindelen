unit GvDtTm;

interface

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

implementation

uses
  SysUtils, GvStr, Classes;

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
    result:= LongMonthNames[MonthNo];
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

end.
