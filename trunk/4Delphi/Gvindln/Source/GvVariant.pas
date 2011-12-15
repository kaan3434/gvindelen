unit GvVariant;

interface
uses
  Variants;

function IsNull(Value: Variant): Boolean;

function IsNotNull(Value: Variant): Boolean;

function nvl(Value1, Value2: Variant): Variant;

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

end.
