unit GvClipboard;

interface

uses
  Classes, SysUtils, DB, Variants;

type
  TGvClipboardItem = class(TMemoryStream)
  private
    FClipSign: string;
  protected
    procedure WriteInteger(aInt: Integer);
    procedure WriteString(aStr: string);
    procedure WriteDateTime(aDTm: TDateTime);
    procedure WriteExtended(aFlt: Extended);
    procedure WriteVariant(aVariant: Variant); 
    function ReadInteger: Integer;
    function ReadString: string;
    function ReadDateTime: TDateTime;
    function ReadExtended: Extended;
    function ReadVariant: Variant;
  public
    constructor Create(aClipSign: string);
    procedure Clear;

    property ClipSign: string read FClipSign;
  end;

  TGvDataSetClipboard = class(TGvClipboardItem)
  private
    procedure WriteField(aField: TField);
    procedure ReadField(aDataSet: TDataSet);
  public
    procedure Copy(aDataSet: TDataSet; aFieldNames: string);
    procedure Append(aDataSet: TDataSet; aFieldNames: string);
    procedure Paste(aDataSet: TDataSet);
    procedure PasteNext(aDataSet: TDataSet);
  end;

  TGvClipboards = class(TList)
  private
    function ClipboardIsEmpty(aName: string): Boolean;
  public
    destructor Destroy; override;
    procedure Clear(aName: string); overload;
    function GetClipboard(aName: string): TGvClipboardItem;
    property Clipboards[aName: string]: TGvClipboardItem read GetClipboard;
    property IsEmpty[aName: string]: Boolean read ClipboardIsEmpty;
  end;

var
  GvClipboards: TGvClipboards;

implementation

uses
  GvStr;

{ TGvClipboardItem }

constructor TGvClipboardItem.Create(aClipSign: string);
begin
  inherited Create;
  FClipSign := aClipSign;
  GvClipboards.Add(Self);
end;

procedure TGvClipboardItem.Clear;
begin
  SetSize(0);
end;

procedure TGvClipboardItem.WriteInteger(aInt: Integer);
begin
  WriteBuffer(aInt, SizeOf(Integer));
end;

procedure TGvClipboardItem.WriteString(aStr: string);
var
  StrLen: integer;
begin
  StrLen := Length(aStr);
  WriteInteger(StrLen);
  if StrLen > 0 then
    WriteBuffer(aStr[1], StrLen);
end;

function TGvClipboardItem.ReadInteger: Integer;
begin
  ReadBuffer(Result, SizeOf(Integer));
end;

function TGvClipboardItem.ReadString: string;
var
  LenStr: integer;
begin
  Result := '';
  LenStr := ReadInteger;
  SetLength(Result, LenStr);
  Read(Result[1], LenStr);
end;

procedure TGvClipboardItem.WriteExtended(aFlt: Extended);
begin
  WriteBuffer(aFlt, SizeOf(Extended));
end;

procedure TGvClipboardItem.WriteVariant(aVariant: Variant);
var
  vt: Word;
begin
  vt:= VarType(aVariant);
  WriteInteger(vt);
  case vt of
    varNull:;
    varString:
      WriteString(string(aVariant));
    varSmallint, varInteger:
      WriteInteger(Integer(aVariant));
    varDate:
      WriteDateTime(TDateTime(aVariant));
    varSingle, varDouble:
      WriteExtended(Extended(aVariant));
  else
    raise Exception.CreateFmt('Unknown Variant Datatype %u', [vt]);
  end;
end;

function TGvClipboardItem.ReadDateTime: TDateTime;
var
  Ext: Extended;
  Dbl: Double;
begin
  Ext:= ReadExtended;
  Dbl:= Ext;
  Result:= TDateTime(Dbl);
end;

function TGvClipboardItem.ReadExtended: Extended;
begin
  ReadBuffer(Result, SizeOf(Extended));
end;

function TGvClipboardItem.ReadVariant: Variant;
var
  vt: Word;
begin
  vt:= ReadInteger;
  case vt of
    varNull:
      Result:= null;
    varString:
      Result:= ReadString;
    varSmallint, varInteger:
      Result:= ReadInteger;
    varDate:
      Result:= ReadDateTime;
    varSingle, varDouble:
      Result:= ReadExtended;
  else
    raise Exception.CreateFmt('Unknown Variant Datatype %u', [vt]);
  end;
end;

procedure TGvClipboardItem.WriteDateTime(aDTm: TDateTime);
var
  Dbl: Double;
  Ext: Extended;
begin
  Dbl:= Double(aDTM);
  Ext:= Dbl;
  WriteExtended(Ext);
end;


{ TGvDataSetClipboard }

procedure TGvDataSetClipboard.Append(aDataSet: TDataSet;
  aFieldNames: string);
var
  FieldName: string;
  sl: TStringList;
  i: Integer;
begin
  sl := TStringList.Create;
  try
    while aFieldNames <> '' do
    begin
      FieldName := TakeFront5(aFieldNames, ',');
      if aDataSet.FindField(FieldName) = nil then
        raise Exception.CreateFmt('Field %s not found', [FieldName])
      else
        sl.Add(FieldName);
    end;
    WriteInteger(sl.Count);
    for i := 0 to sl.count - 1 do
      WriteField(aDataSet.FieldByName(sl[i]));
  finally
    sl.Free;
  end;
end;

procedure TGvDataSetClipboard.Copy(aDataSet: TDataSet; aFieldNames: string);
begin
  Clear;
  Append(aDataSet, aFieldNames);
end;

procedure TGvDataSetClipboard.Paste(aDataSet: TDataSet);
begin
  Position := 0;
  PasteNext(aDataSet);
end;

procedure TGvDataSetClipboard.PasteNext(aDataSet: TDataSet);
var
  cnt, i: Integer;
begin
  if aDataSet.State = dsBrowse then
    aDataSet.Append;
  cnt := ReadInteger;
  for i := 0 to cnt - 1 do
    ReadField(aDataSet);
  aDataSet.Post;
end;

procedure TGvDataSetClipboard.ReadField(aDataSet: TDataSet);
var
  FieldName: string;
  Value: Variant;
begin
  FieldName := ReadString;
  value := ReadVariant;
  aDataSet[FieldName] := Value;
end;

procedure TGvDataSetClipboard.WriteField(aField: TField);
begin
  WriteString(aField.FieldName);
  WriteVariant(aField.Value);
end;

{ TGvClipboards }

procedure TGvClipboards.Clear(aName: string);
var
  Clipboard: TGvClipboardItem;
begin
  Clipboard := GetClipboard(aName);
  if Assigned(Clipboard) then
    Clipboard.Clear;
end;

function TGvClipboards.ClipboardIsEmpty(aName: string): Boolean;
var
  Clipboard: TGvClipboardItem;
begin
  Result := true;
  Clipboard := GetClipboard(aName);
  if Assigned(Clipboard) then
    Result := Clipboard.Size > 0;
end;

destructor TGvClipboards.Destroy;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    TGvClipboardItem(Items[i]).Free;
  inherited;
end;

function TGvClipboards.GetClipboard(aName: string): TGvClipboardItem;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if TGvClipboardItem(Items[i]).ClipSign = aName then
      Result := Items[i];
end;

initialization
  GvClipboards := TGvClipboards.Create;
finalization
  GvClipboards.Free;
end.
 
