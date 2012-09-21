unit GvVariant;

interface
uses
  Variants, SysUtils;

function IsNull(Value: Variant): Boolean;

function IsNotNull(Value: Variant): Boolean;

function nvl(Value1, Value2: Variant): Variant;

function ToNumber(St: string): Variant;

function NullIf(Value1, Value2: Variant): Variant;

implementation

function nvl(Value1, Value2: Variant): Variant;
begin
  if Value1 = null then
    Result:= Value2
  else
    Result:= Value1;
end;

function IsNull(Value: Variant): Boolean;
begin
  Result:= Value = null;
end;

function IsNotNull(Value: Variant): Boolean;
begin
  Result:= Value <> null;
end;

function ToNumber(St: string): Variant;
var
  p1, p2: Integer;
begin
  p1:= Pos(',', St);
  p2:= Pos('.', St);
  if p1>0 then
    St[p1]:= DecimalSeparator
  else
  if p2>0 then
    St[p2]:= DecimalSeparator;
  Result:= St;
end;

function NullIf(Value1, Value2: Variant): Variant;
begin
  if Value1 = Value2 then
    Result:= null
  else
    Result:= Value1;
end;

end.
