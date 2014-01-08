unit GvListDataSet;

interface

uses
  DB, Classes, SysUtils, Windows, Forms, Contnrs, GvCustomDataSet;

type
  TGvListDataSet = class (TGvCustomDataSet)
  protected
    // the list holding the data
    FList: TObjectList;
    // dataset virtual methods
    procedure InternalPreOpen; override;
    procedure InternalClose; override;
    // custom dataset virtual methods
    function InternalRecordCount: Integer; override;
    procedure InternalLoadCurrentRecord (Buffer: PChar); override;
  end;

implementation

uses
  GvMath;

procedure TGvListDataSet.InternalPreOpen;
begin
  if not Assigned(FList) then
    FList := TObjectList.Create (True); // owns objects
  FRecordSize := 4; // an integer, the list item id
  inherited;
end;

procedure TGvListDataSet.InternalClose;
begin
  if Assigned(FList) then
    FList.Free;
  inherited;
end;

procedure TGvListDataSet.InternalLoadCurrentRecord (Buffer: PChar);
begin
  PInteger (Buffer)^ := fCurrentRecord;
  with PMdRecInfo(Buffer + FRecordSize)^ do
  begin
    BookmarkFlag := bfCurrent;
    Bookmark := fCurrentRecord;
  end;
end;

function TGvListDataSet.InternalRecordCount: Integer;
begin
  Result:= MinInt(fList.Count, FMaxRecords);
end;

end.
