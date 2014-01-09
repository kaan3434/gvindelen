unit GvXmlDataSet;

interface

uses
  GvListDataSet, GvCustomDataSet, TypInfo, db, classes, sysutils, GvXml;

type
  TGvXmlDataSet = class(TGvListDataSet)
  private
    FDataSetNode: TGvXmlNode;
    DataBackup: TStringList;
    FRowNodeName: string;
    FInitFieldDefs: TStringList;
    procedure SetDataSetNode(const Value: TGvXmlNode);
    procedure SetInitFieldDefs(const Value: TStringList);
    procedure SetRowNodeName(const Value: string);
    function ActiveNode:TGvXmlNode;
  protected
    procedure InternalInitFieldDefs; override;
    procedure InternalInsert; override;
    procedure InternalPost; override;
    procedure InternalCancel; override;
    procedure InternalEdit; override;
    procedure SetFieldData(Field: TField; Buffer: Pointer; NativeFormat: Boolean); overload; override;
    procedure SetFieldData(Field: TField; Buffer: Pointer); overload; override;
    function GetCanModify: Boolean; override;
    procedure InternalPreOpen; override;
    procedure InternalClose; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetFieldData(Field: TField; Buffer: Pointer; NativeFormat: Boolean): Boolean; overload; override; 
    function GetFieldData(Field: TField; Buffer: Pointer): Boolean; overload; override; 
    property Node: TGvXmlNode read FDataSetNode write SetDataSetNode;
  published
    property InitFieldDefs: TStringList read FInitFieldDefs write SetInitFieldDefs;
    property RowNodeName: string read FRowNodeName write SetRowNodeName;
  end;

procedure Register;

implementation

uses
  Dialogs, Windows, Forms, Controls, GvMath, Variants, GvVariant;

{$R GvXmlDataSet.res}


procedure Register;
begin
  RegisterComponents ('Gvindelen', [TGvXmlDataSet]);
end;

procedure TGvXmlDataSet.InternalInitFieldDefs;
type
  FInitDefItems = (idiFieldName,idiFieldType,idiSize,idiPrecision);
var
  FieldName: string;
  I, nSize: Integer;
  FieldType: TFieldType;
  FieldDef: TFieldDef;
  sl: TStringList;
begin
  if FDataSetNode = nil then
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
      FieldDef:= TFieldDef.Create(FieldDefs, FieldName, FieldType, nSize, False, i);
      case FieldType of
        ftCurrency:
          FieldDef.Precision:= 4;
        ftFloat:
          FieldDef.Precision:= StrToIntDef(sl[Byte(idiPrecision)],0);
      else
        FieldDef.Precision:= 0;
      end;
//      FieldDef.DisplayName:= IfThen(sl[4]<>'', sl[4], sl[0]);
    end; // for
  finally
    sl.Free;
  end;
end;

procedure TGvXmlDataSet.InternalPost;
begin
  DataBackup.Clear;
end;

procedure TGvXmlDataSet.InternalCancel;
var
  Node: TGvXmlNode;
begin
  Node:= TGvXmlNode(fList[fCurrentRecord]);
  if State = dsEdit then
  begin
    Node.Attributes.Clear;
    Node.ImportAttrs(DataBackup);
  end
  else
  if State = dsInsert then
  begin
    DataBackup.Clear;
    FList.Delete(FList.count-1);
  end;
end;

function TGvXmlDataSet.GetFieldData (
  Field: TField; Buffer: Pointer; NativeFormat: Boolean): Boolean;

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
begin
  Result:= False;
  if ActiveRecord >= InternalRecordCount then Exit;

  if ActiveNode.HasAttribute(Field.FieldName) then
    case Field.DataType of
      ftDate, ftTime, ftDateTime:
        OutValue:= ActiveNode.Attr[Field.FieldName].AsDateTime;
    else
      OutValue:= ActiveNode[Field.FieldName]
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

function TGvXmlDataSet.GetFieldData(Field: TField; Buffer: Pointer): Boolean;
begin
  Result:= GetFieldData(Field, Buffer, True);
end;


// III: Move data from field to record buffer
procedure TGvXmlDataSet.SetFieldData(Field: TField; Buffer: Pointer; NativeFormat: Boolean);
var
  v: Variant;
  procedure BufferToVar(var Data: Variant);
  begin
    case Field.DataType of
      ftString, ftFixedChar, ftGuid:
        Data := AnsiString(PAnsiChar(Buffer));
//        SetString(Data, PChar(Buffer), StrLen(PChar(Buffer)));
      ftWideString:
        Data := WideString(Buffer^);
//        WStrCopy(PWideChar(Data), PWideChar(VarToWideStr(Buffer)));
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

begin
  Field.Validate(Buffer);

  if Buffer = nil then
    v := Null
  else
    BufferToVar(v);

  ActiveNode[Field.FieldName]:= v;
  SetModified(True);
end;

procedure TGvXmlDataSet.SetFieldData(Field: TField; Buffer: Pointer);
begin
  SetFieldData(Field, Buffer, true);
end;

procedure TGvXmlDataSet.InternalInsert;
var
  Node: TGvXmlNode;
begin
  Node:= FDataSetNode.AddChild(FRowNodeName);
  Node.ExportAttrs(DataBackup);
  Last;
end;

procedure TGvXmlDataSet.InternalEdit;
begin
  DataBackup.Clear;
  ActiveNode.ExportAttrs(DataBackup);
end;

function TGvXmlDataSet.GetCanModify: Boolean;
begin
  Result := True; // read-write
end;

procedure TGvXmlDataSet.InternalPreOpen;
begin
  DataBackup:= TStringList.Create;
  FList:= FDataSetNode.ChildNodes;
  inherited;
end;

procedure TGvXmlDataSet.InternalClose;
begin
  FList:= nil;
  FreeAndNil(DataBackup);
  inherited;
end;

procedure TGvXmlDataSet.SetDataSetNode(const Value: TGvXmlNode);
begin
  FDataSetNode := Value;
end;

procedure TGvXmlDataSet.SetInitFieldDefs(const Value: TStringList);
begin
  FInitFieldDefs.Assign(Value);
end;

procedure TGvXmlDataSet.SetRowNodeName(const Value: string);
begin
  FRowNodeName := Value;
end;

constructor TGvXmlDataset.Create(AOwner: TComponent);
begin
  inherited;
  FInitFieldDefs:= TStringList.Create;
end;

destructor TGvXmlDataset.Destroy;
begin
  FInitFieldDefs.Free;
  inherited;
end;

function TGvXmlDataSet.ActiveNode: TGvXmlNode;
begin
  Result:= TGvXmlNode(FList[ActiveRecord]);
end;

end.



