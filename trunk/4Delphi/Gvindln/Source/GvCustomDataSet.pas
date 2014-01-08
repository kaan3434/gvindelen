unit GvCustomDataSet;

interface

uses
  SysUtils, Classes, Db;

type
  EGvDataSetError = class (Exception);

  TMdRecInfo = record
    Bookmark: Longint;
    BookmarkFlag: TBookmarkFlag;
  end;
  PMdRecInfo = ^TMdRecInfo;

  TGvCustomDataSet = class(TDataSet)
  protected
    // status
    FMaxRecords: integer;
    FIsTableOpen: Boolean;

    // record data
    FRecordSize, // the size of the actual data
    FRecordBufferSize, // data + housekeeping (TRecInfo)
    FCurrentRecord, // current record (0 to FRecordCount - 1)
    BofCrack, // before the first record (crack)
    EofCrack: Integer; // after the last record (crack)

    // create, close, and so on
    procedure InternalOpen; override;
    procedure InternalClose; override;
    function IsCursorOpen: Boolean; override;

    // custom functions
    function InternalRecordCount: Integer; virtual; abstract;
    procedure InternalPreOpen; virtual;
    procedure InternalAfterOpen; virtual;
    procedure InternalLoadCurrentRecord(Buffer: PChar); virtual; abstract;
    procedure InternalPreClose; virtual;

    // memory management
    function AllocRecordBuffer: PChar; override;
    procedure InternalInitRecord(Buffer: PChar); override;
    procedure FreeRecordBuffer(var Buffer: PChar); override;
    function GetRecordSize: Word; override;

    // movement and optional navigation (used by grids)
    function GetRecord(Buffer: PChar; GetMode: TGetMode;
      DoCheck: Boolean): TGetResult; override;
    procedure InternalFirst; override;
    procedure InternalLast; override;
    function GetRecNo: Longint; override;
    function GetRecordCount: Longint; override;
    procedure SetRecNo(Value: Integer); override;

    // bookmarks
    procedure InternalGotoBookmark(Bookmark: Pointer); override;
    procedure InternalSetToRecord(Buffer: PChar); override;
    procedure SetBookmarkData(Buffer: PChar; Data: Pointer); override;
    procedure GetBookmarkData(Buffer: PChar; Data: Pointer); override;
    procedure SetBookmarkFlag(Buffer: PChar; Value: TBookmarkFlag); override;
    function GetBookmarkFlag(Buffer: PChar): TBookmarkFlag; override;

    // editing (dummy vesions)
    procedure InternalDelete; override;
    procedure InternalAddRecord(Buffer: Pointer; Append: Boolean); override;
    procedure InternalPost; override;

    // other
    procedure InternalHandleException; override;
  published
    // redeclared data set properties
    property Active;
    property BeforeOpen;
    property AfterOpen;
    property BeforeClose;
    property AfterClose;
    property BeforeInsert;
    property AfterInsert;
    property BeforeEdit;
    property AfterEdit;
    property BeforePost;
    property AfterPost;
    property BeforeCancel;
    property AfterCancel;
    property BeforeDelete;
    property AfterDelete;
    property BeforeScroll;
    property AfterScroll;
    property OnCalcFields;
    property OnDeleteError;
    property OnEditError;
    property OnFilterRecord;
    property OnNewRecord;
    property OnPostError;
  end;


implementation

uses
  GvMath, Math;
/////////////////////////////////////////////////
////// Part I:
////// Initialization, opening, and closing
/////////////////////////////////////////////////

// I: open the dataset
procedure TGvCustomDataSet.InternalOpen;
begin
  FMaxRecords:= 0;
  InternalPreOpen; // custom method for subclasses

  // initialize the field definitions
  // (another virtual abstract method of TDataSet)
  InternalInitFieldDefs;

  // if there are no persistent field objects,
  // create the fields dynamically
  if DefaultFields then
    CreateFields;
  // connect the TField objects with the actual fields
  BindFields (True);

  InternalAfterOpen; // custom method for subclasses

  // sets cracks and record position and size
  BofCrack := -1;
  EofCrack := InternalRecordCount;
  FCurrentRecord := BofCrack;
  FRecordBufferSize := FRecordSize + sizeof (TMdRecInfo);
  BookmarkSize := sizeOf (Integer);

  // everything OK: table is now open
  FIsTableOpen := True;
end;

procedure TGvCustomDataSet.InternalClose;
begin
  // disconnet field objects
  BindFields (False);
  // destroy field object (if not persistent)
  if DefaultFields then
    DestroyFields;

  // close the file
  FIsTableOpen := False;
end;

// I: is table open
function TGvCustomDataSet.IsCursorOpen: Boolean;
begin
  Result := FIsTableOpen;
end;

////////////////////////////////////////
////// Part II:
////// Bookmarks management and movement
////////////////////////////////////////

// II: set the requested bookmark as current record
procedure TGvCustomDataSet.InternalGotoBookmark (Bookmark: Pointer);
var
  ReqBookmark: Integer;
begin
  ReqBookmark := PInteger (Bookmark)^;
  if (ReqBookmark >= 0) and (ReqBookmark < InternalRecordCount) then
    FCurrentRecord := ReqBookmark
  else
    raise EGvDataSetError.Create ('Bookmark ' +
      IntToStr (ReqBookmark) + ' not found');
end;

// II: same as above (but passes a buffer)
procedure TGvCustomDataSet.InternalSetToRecord (Buffer: PChar);
var
  ReqBookmark: Integer;
begin
  ReqBookmark := PMdRecInfo(Buffer + FRecordSize).Bookmark;
  InternalGotoBookmark (@ReqBookmark);
end;

// II: retrieve bookmarks flags from buffer
function TGvCustomDataSet.GetBookmarkFlag (
  Buffer: PChar): TBookmarkFlag;
begin
  Result := PMdRecInfo(Buffer + FRecordSize).BookmarkFlag;
end;

// II: change the bookmark flags in the buffer
procedure TGvCustomDataSet.SetBookmarkFlag (Buffer: PChar;
  Value: TBookmarkFlag);
begin
  PMdRecInfo(Buffer + FRecordSize).BookmarkFlag := Value;
end;

// II: Go to a special position before the first record
procedure TGvCustomDataSet.InternalFirst;
begin
  FCurrentRecord := BofCrack;
end;

// II: Go to a special position after the last record
procedure TGvCustomDataSet.InternalLast;
begin
  if FMaxRecords > 0 then
    EofCrack:= GvMath.MinInt(FMaxRecords, InternalRecordCount)
  else
    EofCrack := InternalRecordCount;
  FCurrentRecord := EofCrack;
end;

// II: read the bookmark data from record buffer
procedure TGvCustomDataSet.GetBookmarkData (
  Buffer: PChar; Data: Pointer);
begin
  PInteger(Data)^ :=
    PMdRecInfo(Buffer + FRecordSize).Bookmark;
end;

// II: set the bookmark data in the buffer
procedure TGvCustomDataSet.SetBookmarkData (
  Buffer: PChar; Data: Pointer);
begin
  PMdRecInfo(Buffer + FRecordSize).Bookmark :=
    PInteger(Data)^;
end;

// II (optional): Record count
function TGvCustomDataSet.GetRecordCount: Longint;
begin
  CheckActive;
  Result := InternalRecordCount;
end;

// II (optional): Get the number of the current record
function TGvCustomDataSet.GetRecNo: Longint;
begin
  UpdateCursorPos;
  if FCurrentRecord < 0 then
    Result := 1
  else
    Result := FCurrentRecord + 1;
end;

// II (optional): Move to the given record number
procedure TGvCustomDataSet.SetRecNo(Value: Integer);
begin
  CheckBrowseMode;
  if (Value >= 1) and (Value <= InternalRecordCount) then
  begin
    FCurrentRecord := Value - 1;
    Resync([]);
  end;
end;

//////////////////////////////////////////
////// Part III:
////// Record buffers and field management
//////////////////////////////////////////

// III: Retrieve data for current, previous, or next record
// (eventually moving to it) and return the status
function TGvCustomDataSet.GetRecord(Buffer: PChar;
  GetMode: TGetMode; DoCheck: Boolean): TGetResult;
begin
  Result := grOK; // default
  case GetMode of
    gmNext: // move on
      if FCurrentRecord < InternalRecordCount - 1 then
        Inc (FCurrentRecord)
      else
        Result := grEOF; // end of file
    gmPrior: // move back
      if FCurrentRecord > 0 then
        Dec (FCurrentRecord)
      else
        Result := grBOF; // begin of file
    gmCurrent: // check if empty
      if FCurrentRecord >= InternalRecordCount then
        Result := grError;
  end;
  if (FMaxRecords > 0) and (FCurrentRecord > FMaxRecords - 1 ) then
    Result:= grError;
  // load the data
  if Result = grOK then
    InternalLoadCurrentRecord (Buffer)
  else
  if (Result = grError) and (FCurrentRecord > FMaxRecords - 1) then
  else
  if (Result = grError) and DoCheck then
    raise EGvDataSetError.Create ('GetRecord: Invalid record');
end;

// III: Initialize the record (set to 0)
procedure TGvCustomDataSet.InternalInitRecord(Buffer: PChar);
begin
  FillChar(Buffer^, FRecordBufferSize, 0);
end;

// III: Free the buffer
procedure TGvCustomDataSet.FreeRecordBuffer (var Buffer: PChar);
begin
  FreeMem (Buffer);
end;

/// III: Determine the size of each record buffer in memory
function TGvCustomDataSet.GetRecordSize: Word;
begin
  Result := FRecordSize; // data only
end;

/// III: Allocate a buffer for the record
function TGvCustomDataSet.AllocRecordBuffer: PChar;
begin
  GetMem (Result, FRecordBufferSize);
end;

// III: Delete the current record
procedure TGvCustomDataSet.InternalDelete;
begin
  // not supported in this generic version
  raise EGvDataSetError.Create ('Delete: Operation not supported');
end;

// default exception handling

procedure TGvCustomDataSet.InternalHandleException;
begin
  // special purpose exception handling
  // do nothing
end;

procedure TGvCustomDataSet.InternalAddRecord(Buffer: Pointer;
  Append: Boolean);
begin
  // not supported in this generic version
  raise EGvDataSetError.Create ('AddRecord: Operation not supported');
end;

procedure TGvCustomDataSet.InternalPost;
begin
  // not supported in this generic version
  raise EGvDataSetError.Create ('Post: Operation not supported');
end;

procedure TGvCustomDataSet.InternalAfterOpen;
begin
  // nothing to do: subclasses can hook in here
end;

procedure TGvCustomDataSet.InternalPreOpen;
begin
  // nothing to do: subclasses can hook in here
end;

procedure TGvCustomDataSet.InternalPreClose;
begin
  // nothing to do: subclasses can hook in here
end;

end.
