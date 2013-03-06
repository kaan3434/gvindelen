unit GvUDFMath;

interface

function RoundPrecision(var aAmount: Double; var aPrecision: Double): Double; cdecl; export;

implementation

uses
  GvMath;

function RoundPrecision(var aAmount: Double; var aPrecision: Double): Double;
begin
  Result:= GvMath.RoundPrecision(aAmount, aPrecision);
end;


end.
