unit GvRibbon;

interface

uses
  Ribbon, Vcl.ActnMan, Vcl.Controls;

function findItemByControl(aRibbonGroup: TRibbonGroup; aControl: TControl): TActionClientItem;


implementation

function findItemByControl(aRibbonGroup: TRibbonGroup; aControl: TControl): TActionClientItem;
var
  i: Integer;
begin
  for i := 0 to aRibbonGroup.Items.Count-1 do
  begin
    Result:= aRibbonGroup.Items[i];
    if (Result.CommandStyle = csControl) and
       (TControlProperties(Result.CommandProperties).ContainedControl = aControl) then Exit;
  end;
  Result:= nil;
end;

end.
