unit GvNodeDataSet;

interface

uses
  GvListDataSet, GvCustomDataSet, TypInfo, db, classes, sysutils, GvXml;

type
  TGvXmlFieldDef = class(TFieldDef)
  private
    FXPath: string;
    FAttrName: string;
    function GetFullPath: String;
    procedure SetFullPath(const Value: String);
  public
    constructor Create(Owner: TFieldDefs; const Name: String; DataType: TFieldType; Size: Integer; Required: Boolean; FieldNo: Integer; Path:String); overload;
    property XPath: String read FXPath;
    property AttrName: String read FAttrName;
    property FullPath: String read GetFullPath write SetFullPath;
  end;

  TGvNodeDataSet = class(TGvListDataSet)
  private
    FDataSetNode: TGvXmlNode;
    FDataBackup: TStringList;
    FInitFieldDefs: TStringList;
    procedure SetDataSetNode(const Value: TGvXmlNode);
    procedure SetInitFieldDefs(const Value: TStringList);
    function ActiveNode(FieldDef: TGvXmlFieldDef):TGvXmlNode;
  protected
    procedure InternalInitFieldDefs; override;
    procedure InternalPost; override;
    procedure InternalCancel; override;
    procedure InternalEdit; override;
    procedure SetFieldData(Field: TField; Buffer: Pointer; NativeFormat: Boolean); overload; override;
    procedure SetFieldData(Field: TField; Buffer: Pointer); overload; override;
    function GetCanModify: Boolean; override;
    procedure InternalPreOpen; override;
    procedure InternalClose; override;
    procedure InternalBackupData; virtual;
    procedure InternalRestoreData; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetFieldData(Field: TField; Buffer: Pointer; NativeFormat: Boolean): Boolean; overload; override;
    function GetFieldData(Field: TField; Buffer: Pointer): Boolean; overload; override;
    property Node: TGvXmlNode read FDataSetNode write SetDataSetNode;
  published
    property InitFieldDefs: TStringList read FInitFieldDefs write SetInitFieldDefs;
  end;

procedure Register;

implementation

uses
  Contnrs, Dialogs, Windows, Forms, Controls, GvMath, Variants, GvVariant, GvStr;

{$R GvNodeDataSet.res}


procedure Register;
begin
  RegisterComponents ('Gvindelen', [TGvNodeDataSet]);
end;

procedure TGvNodeDataSet.InternalInitFieldDefs;
type
  FInitDefItems = (idiFieldName,idiXPath,idiFieldType,idiSize,idiPrecision);
var
  FieldName, XPath: string;
  I, nSize: Integer;
  FieldType: TFieldType;
  FieldDef: TFieldDef;
  sl: TStringList;
begin
  if not (csDesigning in ComponentState) and (FDataSetNode = nil) then
    raise EGvDataSetError.Create ('Missing DataSet Node');
  sl:= TStringList.Create;
  FieldDefs.Clear;
  try
    for I := 0 to FInitFieldDefs.Count-1 do
    begin
      if Trim(FInitFieldDefs[i]) = '' then Continue;
      sl.CommaText:= Trim(FInitFieldDefs[i])+',,,,,,,';
      // create the field
      FieldName:= sl[Byte(idiFieldName)];
      if FieldName = '' then
        raise EGvDataSetError.Create('InitFieldsDefs: No name for field '+IntToStr(I));
      XPath:= sl[Byte(idiXPath)];
      FieldType:= TFieldType(GetEnumValue(TypeInfo(TFieldType), sl[Byte(idiFieldType)]));
      nSize:= 0;
      case FieldType of
        ftString:
          nSize:= StrToIntDef(sl[Byte(idiSize)], 0);
        ftBoolean,
        ftSmallInt, ftWord,
        ftInteger, ftDate, ftTime,
        ftFloat, ftCurrency,ftDateTime:
      else
        raise EGvDataSetError.Create (
          'InitFieldsDefs: Unsupported field type');
      end;
      FieldDef:= TGvXmlFieldDef.Create(FieldDefs, FieldName, FieldType, nSize, False, i, XPath);
      case FieldType of
        ftCurrency:
          FieldDef.Precision:= 4;
        ftFloat:
          FieldDef.Precision:= StrToIntDef(sl[Byte(idiPrecision)],0);
      else
        FieldDef.Precision:= 0;
      end;
    end;
  finally
    sl.Free;
  end;
end;

procedure TGvNodeDataSet.InternalPost;
begin
  FDataBackup.Clear;
end;

procedure TGvNodeDataSet.InternalCancel;
var
  Node: TGvXmlNode;
begin
  if State = dsEdit then
    InternalRestoreData;
end;

function TGvNodeDataSet.GetFieldData (
  Field: TField; Buffer: Pointer; NativeFormat: Boolean): Boolean;
var
  Node: TGvXmlNode;
  vInteger: Integer;
  vString: string;
  vDateTime: TDateTime;
  vBool: WordBool;

procedure VarToBuffer(var Value: Variant);
begin
  case Field.DataType of
    ftGuid, ftFixedChar, ftString:
      begin
        PAnsiChar(Buffer)[Field.Size] := #0;
        StrLCopy(PAnsiChar(Buffer), PAnsiChar(VarToAnsiStr(Value)), Field.Size);
      end;
    ftWideString:
      WideString(Buffer^) := Value;
    ftSmallint:
        SmallInt(Buffer^) := Value;
    ftWord:
        Word(Buffer^) := Value;
    ftAutoInc, ftInteger:
      Integer(Buffer^) := Value;
    ftFloat, ftCurrency:
        Double(Buffer^) := Value;
    ftBCD:
      if NativeFormat
        then DataConvert(Field, @Value, Buffer, True)
        else Currency(Buffer^) := Value;
    ftBoolean:
      WordBool(Buffer^) := Value;
    ftDate, ftTime, ftDateTime:
      if NativeFormat
        then DataConvert(Field, @TVarData(Value).VDate, Buffer, True)
        else TDateTime(Buffer^) := Value;
    ftBytes, ftVarBytes:
      if NativeFormat
        then DataConvert(Field, @Value, Buffer, True)
        else Variant(Buffer^) := Value;
    ftInterface: IUnknown(Buffer^) := Value;
    ftIDispatch: IDispatch(Buffer^) := Value;
    ftBlob..ftTypedBinary, ftVariant: Variant(Buffer^) := Value;
  else
    DatabaseErrorFmt('SUsupportedFieldType', [FieldTypeNames[Field.DataType],
      Field.DisplayName]);
  end;
end;

var
  OutValue: Variant;
  FieldDef: TGvXmlFieldDef;
begin
  Result:= False;
  if ActiveRecord >= InternalRecordCount then Exit;

  FieldDef:= FieldDefs[Field.FieldNo] as TGvXmlFieldDef;
  if ActiveNode(FieldDef).HasAttribute(FieldDef.AttrName) then
    case Field.DataType of
      ftDate, ftTime, ftDateTime:
        OutValue:= ActiveNode(FieldDef).Attr[FieldDef.AttrName].AsDateTime;
    else
      OutValue:= ActiveNode(FieldDef)[FieldDef.AttrName];
    end
  else
    OutValue:= null;
  if IsNull(OutValue) then
    Result := False
  else
  if Buffer <> nil then
  begin
    VarToBuffer(OutValue);
    Result:= True
  end;
end;

function TGvNodeDataSet.GetFieldData(Field: TField; Buffer: Pointer): Boolean;
begin
  Result:= GetFieldData(Field, Buffer, True);
end;


// III: Move data from field to record buffer
procedure TGvNodeDataSet.SetFieldData(Field: TField; Buffer: Pointer; NativeFormat: Boolean);
var
  v: Variant;
  Node: TGvXmlNode;
  vInteger: Integer;
  vString: String;
  vDateTime: TDateTime;
  vBool: WordBool;
  procedure BufferToVar(var Data: Variant);
  begin
    case Field.DataType of
      ftString, ftFixedChar, ftGuid:
        Data := AnsiString(PAnsiChar(Buffer));
      ftWideString:
        Data := WideString(Buffer^);
      ftAutoInc, ftInteger:
        Data := LongInt(Buffer^);
      ftSmallInt:
        Data := SmallInt(Buffer^);
      ftWord:
        Data := Word(Buffer^);
      ftBoolean:
        Data := WordBool(Buffer^);
      ftFloat, ftCurrency:
        Data := Double(Buffer^);
      ftBlob, ftMemo, ftGraphic, ftVariant:
        Data := Variant(Buffer^);
      ftInterface:
        Data := IUnknown(Buffer^);
      ftIDispatch:
        Data := IDispatch(Buffer^);
      ftDate, ftTime, ftDateTime:
        if NativeFormat
          then DataConvert(Field, Buffer, @TVarData(Data).VDate, False)
          else Data := TDateTime(Buffer^);
      ftBCD:
        if NativeFormat
          then DataConvert(Field, Buffer, @TVarData(Data).VCurrency, False)
          else Data := Currency(Buffer^);
      ftBytes, ftVarBytes:
        if NativeFormat
          then DataConvert(Field, Buffer, @Data, False)
          else Data := Variant(Buffer^);
      ftLargeInt:
          Data := Int64(Buffer^);
      else
        DatabaseErrorFmt('SUsupportedFieldType', [FieldTypeNames[Field.DataType],
          Field.DisplayName]);
    end;
  end;

var
  FieldDef: TGvXmlFieldDef;
begin
  Field.Validate(Buffer);

  if Buffer = nil then
    v := Null
  else
    BufferToVar(v);

  FieldDef:= FieldDefs[Field.FieldNo] as TGvXmlFieldDef;
  ActiveNode(FieldDef)[FieldDef.AttrName]:= v;
  SetModified(True);
end;

procedure TGvNodeDataSet.SetFieldData(Field: TField; Buffer: Pointer);
begin
  SetFieldData(Field, Buffer, true);
end;

procedure TGvNodeDataSet.InternalEdit;
begin
  FDataBackup.Clear;
  InternalBackupData;
end;

function TGvNodeDataSet.GetCanModify: Boolean;
begin
  Result := True; // read-write
end;

procedure TGvNodeDataSet.InternalPreOpen;
begin
  FMaxRecords:= 1;
  FList := TObjectList.Create(false);
  FList.Add(FDataSetNode);
  FDataBackup:= TStringList.Create;
  inherited;
end;

procedure TGvNodeDataSet.InternalClose;
begin
  FList.Extract(FDataSetNode);
  FreeAndNil(FDataBackup);
  inherited;
end;

procedure TGvNodeDataSet.SetDataSetNode(const Value: TGvXmlNode);
begin
  FDataSetNode := Value;
end;

procedure TGvNodeDataSet.SetInitFieldDefs(const Value: TStringList);
begin
  FInitFieldDefs.Assign(Value);
end;

constructor TGvNodeDataSet.Create(AOwner: TComponent);
begin
  inherited;
  FInitFieldDefs:= TStringList.Create;
end;

destructor TGvNodeDataSet.Destroy;
begin
  FInitFieldDefs.Free;
  inherited;
end;

function TGvNodeDataSet.ActiveNode(FieldDef: TGvXmlFieldDef): TGvXmlNode;
begin
  result:= FDataSetNode.NodeByPath(FieldDef.XPath);
end;

{ TGvXmlFieldDef }

constructor TGvXmlFieldDef.Create(Owner: TFieldDefs; const Name: String;
  DataType: TFieldType; Size: Integer; Required: Boolean; FieldNo: Integer;
  Path: String);
begin
  inherited Create(Owner, Name, DataType, Size, Required, FieldNo);
  FullPath:= IfThen(Path='', Name, Path);
end;

procedure TGvNodeDataSet.InternalBackupData;
var
  FieldDef: TGvXmlFieldDef;
  i: Integer;
begin
  for i:= 0 to FieldDefs.Count-1 do
  begin
    FieldDef:= FieldDefs[i] as TGvXmlFieldDef;
    FDataBackup.Values[FieldDef.FullPath]:= Fields[i].AsString;
  end;
end;

procedure TGvNodeDataSet.InternalRestoreData;
var
  FieldDef: TGvXmlFieldDef;
  i: Integer;
begin
  for i:= 0 to FieldDefs.Count-1 do
  begin
    FieldDef:= FieldDefs[i] as TGvXmlFieldDef;
    Fields[i].AsString:= FDataBackup.Values[FieldDef.FullPath];
  end;
end;

function TGvXmlFieldDef.GetFullPath: String;
begin
  Result:= IfThen(FXPath='', '', FXPath+':') + FAttrName;
end;

procedure TGvXmlFieldDef.SetFullPath(const Value: String);
begin
  FXPath:= Value;
  FAttrName:= TakeBack5(FXPath, ':');
end;

end.



