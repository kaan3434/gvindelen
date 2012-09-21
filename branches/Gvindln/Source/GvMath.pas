unit GvMath;

interface

uses
  Variants;

function Max(Flt1, Flt2: Extended): Extended;
function Min(Flt1, Flt2: Extended): Extended;
function Avg(Flt1, Flt2: Extended): Extended;
function MaxInt(Int1, Int2: LongInt): LongInt;
function MinInt(Int1, Int2: LongInt): LongInt;

function RoundPower(Value: Extended; Power: Integer):Extended;
function RoundDown(Value: Extended; Power: Integer):Extended;
function RoundUp(Value: Extended; Power: Integer):Extended;

function Between(Value, RangeStart, RangeEnd: Extended): Boolean;
function IfThen(Condition: Boolean; ValueTrue: Variant; ValueElse: Variant): variant;

implementation

function Max(Flt1, Flt2: Extended): Extended;
begin
  if Flt1 > Flt2 then result:= Flt1 else result:= Flt2;
end;

function Min(Flt1, Flt2: Extended): Extended;
begin
  if Flt1 < Flt2 then result:= Flt1 else result:= Flt2;
end;

function Avg(Flt1, Flt2: Extended): Extended;
begin
  result:= (Flt1 + Flt2)/2;
end;

function MaxInt(Int1, Int2: Longint): Longint;
begin
  if Int1 > Int2 then result:= Int1 else result:= Int2;
end;

function MinInt(Int1, Int2: Longint): Longint;
begin
  if Int1 < Int2 then result:= Int1 else result:= Int2;
end;

function RoundPower(Value: Extended; Power: Integer):Extended;
var
  i: Word;
  p: Extended;
  l: LongInt;
begin
  p:= 1;
  For i:= 1 to Abs(Power) do p:= p*10;
  if Power < 0 then
  begin
   l:= Round(Value*p);
   result:= l/p;
  end
  else
  begin
    l:= round(Value/p);
    result:= l*p;
  end;
end;

function RoundDown(Value: Extended; Power: Integer):Extended;
var
  i: Word;
  p: Extended;
  l: LongInt;
begin
  p:= 1;
  For i:= 1 to Abs(Power) do p:= p*10;
  if Power < 0 then
  begin
   l:= trunc(Value*p);
   result:= l/p;
  end
  else
  begin
    l:= trunc(Value/p);
    result:= l*p;
  end;
end;

function RoundUp(Value: Extended; Power: Integer):Extended;
var
  i, p: LongInt;
begin
  p:= 1;
  For i:= 1 to Abs(Power) do p:= p*10;
  if Power >= 0 then
  begin
    result:= trunc(Value/p)*p;
    if value-result<>0 then
      result:= result+p;
  end
  else
  begin
    result:= trunc(Value*p)/p;
    if Value-result<>0 then
      result:= result+1/p;
  end;
end;

function Between(Value, RangeStart, RangeEnd: Extended): Boolean;
begin
  result:= (Value>=RangeStart) and (Value<=RangeEnd);
end;

function IfThen(Condition: Boolean; ValueTrue: Variant; ValueElse: Variant): variant;
begin
  if Condition then
    Result:= ValueTrue
  else
    Result:= ValueElse;
end;

end.
