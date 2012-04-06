{$IFNDEF CLR}
{$I IbDac.inc}
unit DbxIdaMetaInfo;
{$ENDIF}

interface

uses
{$IFNDEF CLR}
  CLRClasses,
{$ENDIF}
{$IFDEF VER6P}
  Variants,
{$ENDIF}
{$IFDEF DBX30}
  DBXpress30,
{$ELSE}
  DBXpress,
{$ENDIF}
  SqlTimSt, FmtBcd,
  SysUtils, Classes, MemData, CRAccess, CRMetaInfo, IBCClasses, IBCMetaInfo;

type
  TDbxIdaMetaInfo = class (TGDSMetaInfo)
  protected
    procedure CopyObjectList;
    procedure GetFieldType(var TypeName: string; var FieldPrec, FieldScale, FieldLength, FieldType, FieldSubType: integer);

    procedure CopyTablesData(Restrictions: TStrings); override;
    procedure CopyColumnsData(Restrictions: TStrings); override;
    procedure CopyProceduresData(Restrictions: TStrings); override;
    procedure CopyProcedureParametersData(Restrictions: TStrings); override;
    function GetIndexColumns(Restrictions: TStrings): TData; override;

    function GetDataTypes(Restrictions: TStrings): TData; override;
    function GetRoles(Restrictions: TStrings): TData; override;
  end;

implementation

{ TDbxIdaMetaInfo }

procedure TDbxIdaMetaInfo.CopyTablesData(Restrictions: TStrings);
const
  snTABLE_NAME    = 1;
  snVIEW_BLR      = 2;
  snSYSTEM_FLAG   = 3;

  dnRECNO         = 1;
  dnCATALOG_NAME  = 2;
  dnSCHEMA_NAME   = 3;
  dnTABLE_NAME    = 4;
  dnTABLE_TYPE    = 5;
var
  Value: variant;
  TableType: integer;
  MetaInfoFormat: string;
  BriefFormat: boolean;
begin
  MetaInfoFormat := AnsiLowerCase(Trim(Restrictions.Values['METAINFO_FORMAT']));
  BriefFormat := MetaInfoFormat = 'dbx_brief';

  if BriefFormat then
    CreateObjectListFields
  else
    CreateTablesFields;
  FMemData.Open;
  FMemDataHelper.AllocBuffer;
  FRecordSetHelper.AllocBuffer;
  while FRecordSetHelper.NextRecord do begin
    FMemDataHelper.InitRecord;
    CopyRecord([snTABLE_NAME], [dnTABLE_NAME]);

    if not BriefFormat then begin
      Value := FRecordSetHelper.FieldValues[snVIEW_BLR];
      if VarIsNull(Value) then
        TableType := eSQLTable
      else
        TableType := eSQLView;

      Value := FRecordSetHelper.FieldValues[snSYSTEM_FLAG];
      if Value = 1 then
        TableType := TableType or eSQLSystemTable;

      FMemDataHelper.FieldValues[dnTABLE_TYPE] := TableType;
    end;

    FMemDataHelper.AppendRecord;
  end;
  FMemData.SetToBegin;
end;

procedure TDbxIdaMetaInfo.GetFieldType(var TypeName: string; var FieldPrec, FieldScale,
  FieldLength, FieldType, FieldSubType: integer);
var
  OrigType, OrigSubType, OriginalLength: integer;
begin
  OrigType := FieldType;
  OrigSubType := FieldSubType;
  OriginalLength := FieldLength;

  TypeName := '';
  FieldType := 0;
  FieldSubType := 0;
  FieldLength := 0;
  case OrigType of
    7: begin
      TypeName := 'SMALLINT';
      FieldType := fldINT16;
      FieldLength := SizeOf(SmallInt);
    end;
    8: begin
      TypeName := 'INTEGER';
      FieldType := fldINT32;
      FieldLength := SizeOf(Integer);
    end;
    10: begin
      TypeName := 'FLOAT';
      FieldType := fldFLOAT;
      FieldLength := SizeOf(Double);
    end;
    12: begin
      TypeName := 'DATE';
      FieldType := fldDATE;
      FieldLength := SizeOf(Double); //!
    end;
    13: begin
      TypeName := 'TIME';
      FieldType := fldTIME;
      FieldLength := SizeOf(Double); //!
    end;
    14: begin
      TypeName := 'CHAR';
      FieldType := fldZSTRING;
      FieldSubType := fldstFIXED;
      FieldLength := OriginalLength + 1;
    end;
    16: begin
      TypeName := 'NUMERIC';
      if (FieldScale = 0) and (FieldPrec <= 9) then begin
        FieldType := fldINT32;
        FieldLength := SizeOf(Integer);
      end
      else
        if EnableBCD then begin
          FieldType := fldFmtBCD;
          FieldLength := SizeOf(TBcd);
        end
        else begin
          FieldType := fldFLOAT;
          FieldLength := SizeOf(Double);
        end;
    end;
    27: begin
      TypeName := 'DOUBLE PRECISION';
      FieldType := fldFLOAT;
      FieldLength := SizeOf(Double);
    end;
    35: begin
      TypeName := 'TIMESTAMP';
      FieldType := fldDATETIME;
      FieldLength := SizeOf(TSQLTimeStamp);//SizeOf(Double); // !
    end;
    37: begin
      TypeName := 'VARCHAR';
      FieldType := fldZSTRING;
      FieldLength := OriginalLength + 1;
    end;
    261: begin
      TypeName := 'BLOB';
      FieldType := fldBLOB;
      if OrigSubType = 1 then
        FieldSubType := fldstMEMO
      else
        FieldSubType := fldstBINARY;
      FieldLength := 0; // !
    end;
  end;
  if FieldPrec = 0 then
    FieldPrec := OriginalLength;
end;

procedure TDbxIdaMetaInfo.CopyColumnsData(Restrictions: TStrings);
const
  snTABLE_NAME    = 1;
  snCOLUMN_NAME   = 2;
  snPOSITION      = 3;
  snTYPE          = 4;
  snSUBTYPE       = 5;
  snLENGTH        = 6;
  snPRECISION     = 7;
  snSCALE         = 8;
  snNULL_FLAG     = 9;
  snDEFAULT_VALUE = 10;

  dnRECNO         = 1;
  dnCATALOG_NAME  = 2;
  dnSCHEMA_NAME   = 3;
  dnTABLE_NAME    = 4;
  dnCOLUMN_NAME   = 5;
  dnPOSITION      = 6;
  dnTYPE          = 7;
  dnDATATYPE      = 8;
  dnTYPENAME      = 9;
  dnSUBTYPE       = 10;
  dnLENGTH        = 11;
  dnPRECISION     = 12;
  dnSCALE         = 13;
  dnNULLABLE      = 14;

var
  Value: variant;
  ColumnType, FieldType, FieldSubType, FieldLength, FieldPrec, FieldScale: integer;
  TypeName: string;
begin
  CreateColumnsFields;
  FMemData.Open;
  FMemDataHelper.AllocBuffer;
  FRecordSetHelper.AllocBuffer;
  while FRecordSetHelper.NextRecord do begin
    FMemDataHelper.InitRecord;
    CopyRecord(
      [snTABLE_NAME, snCOLUMN_NAME, snPOSITION],
      [dnTABLE_NAME, dnCOLUMN_NAME, dnPOSITION]);

    Value := FRecordSetHelper.FieldValues[snDEFAULT_VALUE];
    if VarIsNull(Value) then
      ColumnType := 0
    else
      ColumnType := eSQLDefault;
    FMemDataHelper.FieldValues[dnTYPE] := ColumnType;

    FieldType := FRecordSetHelper.FieldValues[snTYPE];
    Value := FRecordSetHelper.FieldValues[snSUBTYPE];
    if VarIsNull(Value) then
      FieldSubType := 0
    else
      FieldSubType := Value;
    Value := FRecordSetHelper.FieldValues[snPRECISION];
    if VarIsNull(Value) then
      FieldPrec := 0
    else
      FieldPrec := Value;
    Value := FRecordSetHelper.FieldValues[snSCALE];
    if VarIsNull(Value) then
      FieldScale := 0
    else
      FieldScale := -Value;
    Value := FRecordSetHelper.FieldValues[snLENGTH];
    if VarIsNull(Value) then
      FieldLength := 0
    else
      FieldLength := Value;

    GetFieldType(TypeName, FieldPrec, FieldScale, FieldLength, FieldType, FieldSubType);

    FMemDataHelper.FieldValues[dnTYPENAME] := TypeName;
    FMemDataHelper.FieldValues[dnDATATYPE] := FieldType;
    FMemDataHelper.FieldValues[dnSUBTYPE] := FieldSubType;
    FMemDataHelper.FieldValues[dnLENGTH] := FieldLength;
    FMemDataHelper.FieldValues[dnPRECISION] := FieldPrec;
    FMemDataHelper.FieldValues[dnSCALE] := FieldScale;

    Value := FRecordSetHelper.FieldValues[snNULL_FLAG];
    if VarIsNull(Value) then
      ColumnType := 1
    else
      ColumnType := 0;
    FMemDataHelper.FieldValues[dnNULLABLE] := ColumnType;

    FMemDataHelper.AppendRecord;
  end;
  FMemData.SetToBegin;
end;

procedure TDbxIdaMetaInfo.CopyProceduresData(Restrictions: TStrings);
const
  snPROC_NAME     = 1;
  snIN_PARAMS     = 2;
  snOUT_PARAMS    = 3;

  dnRECNO         = 1;
  dnCATALOG_NAME  = 2;
  dnSCHEMA_NAME   = 3;
  dnPROC_NAME     = 4;
  dnPROC_TYPE     = 5;
  dnIN_PARAMS     = 6;
  dnOUT_PARAMS    = 7;
var
  Value: variant;
  MetaInfoFormat: string;
  BriefFormat: boolean;
begin
  MetaInfoFormat := AnsiLowerCase(Trim(Restrictions.Values['METAINFO_FORMAT']));
  BriefFormat := MetaInfoFormat = 'dbx_brief';

  if BriefFormat then
    CreateObjectListFields
  else
    CreateProceduresFields;
  FMemData.Open;
  FMemDataHelper.AllocBuffer;
  FRecordSetHelper.AllocBuffer;
  while FRecordSetHelper.NextRecord do begin
    FMemDataHelper.InitRecord;
    CopyRecord([snPROC_NAME], [dnPROC_NAME]);

    if not BriefFormat then begin
      FMemDataHelper.FieldValues[dnPROC_TYPE] := 1;

      Value := FRecordSetHelper.FieldValues[snIN_PARAMS];
      if VarIsNull(Value) then
        Value := 0;
      FMemDataHelper.FieldValues[dnIN_PARAMS] := Value;

      Value := FRecordSetHelper.FieldValues[snOUT_PARAMS];
      if VarIsNull(Value) then
        Value := 0;
      FMemDataHelper.FieldValues[dnOUT_PARAMS] := Value;
    end;

    FMemDataHelper.AppendRecord;
  end;
  FMemData.SetToBegin;
end;

procedure TDbxIdaMetaInfo.CopyProcedureParametersData(Restrictions: TStrings);
const
  snPROC_NAME     = 1;
  snPARAM_NAME    = 2;
  snPOSITION      = 3;
  snDIRECTION     = 4;
  snTYPE          = 5;
  snSUBTYPE       = 6;
  snLENGTH        = 7;
  snPRECISION     = 8;
  snSCALE         = 9;

  dnRECNO          = 1;
  dnCATALOG_NAME   = 2;
  dnSCHEMA_NAME    = 3;
  dnPROC_NAME      = 4;
  dnPARAM_NAME     = 5;
  dnPOSITION       = 6;
  dnTYPE           = 7;
  dnDATATYPE       = 8;
  dnTYPENAME       = 9;
  dnSUBTYPE        = 10;
  dnLENGTH         = 11;
  dnPRECISION      = 12;
  dnSCALE          = 13;
  dnNULLABLE       = 14;
var
  Value: variant;
  ParamType, FieldType, FieldSubType, FieldLength, FieldPrec, FieldScale: integer;
  TypeName: string;
begin
  CreateProcedureParametersFields;
  FMemData.Open;
  FMemDataHelper.AllocBuffer;
  FRecordSetHelper.AllocBuffer;
  while FRecordSetHelper.NextRecord do begin
    FMemDataHelper.InitRecord;
    CopyRecord(
      [snPROC_NAME, snPARAM_NAME, snPOSITION],
      [dnPROC_NAME, dnPARAM_NAME, dnPOSITION]);

    ParamType := FRecordSetHelper.FieldValues[snDIRECTION];

    FMemDataHelper.FieldValues[dnTYPE] := ParamType + 1;
    FMemDataHelper.FieldValues[dnNULLABLE] := 1;

    FieldType := FRecordSetHelper.FieldValues[snTYPE];
    Value := FRecordSetHelper.FieldValues[snSUBTYPE];
    if VarIsNull(Value) then
      FieldSubType := 0
    else
      FieldSubType := Value;
    Value := FRecordSetHelper.FieldValues[snPRECISION];
    if VarIsNull(Value) then
      FieldPrec := 0
    else
      FieldPrec := Value;
    Value := FRecordSetHelper.FieldValues[snSCALE];
    if VarIsNull(Value) then
      FieldScale := 0
    else
      FieldScale := -Value;
    Value := FRecordSetHelper.FieldValues[snLENGTH];
    if VarIsNull(Value) then
      FieldLength := 0
    else
      FieldLength := Value;

    GetFieldType(TypeName, FieldPrec, FieldScale, FieldLength, FieldType, FieldSubType);

    FMemDataHelper.FieldValues[dnTYPENAME] := TypeName;
    FMemDataHelper.FieldValues[dnDATATYPE] := FieldType;
    FMemDataHelper.FieldValues[dnSUBTYPE] := FieldSubType;
    FMemDataHelper.FieldValues[dnLENGTH] := FieldLength;
    FMemDataHelper.FieldValues[dnPRECISION] := FieldPrec;
    FMemDataHelper.FieldValues[dnSCALE] := FieldScale;

    FMemDataHelper.AppendRecord;
  end;
  FMemData.SetToBegin;
end;

function TDbxIdaMetaInfo.GetIndexColumns(Restrictions: TStrings): TData;
const
  fmtGetIndexColumnsSQL = 'SELECT I.RDB$RELATION_NAME TABLE_NAME, I.RDB$INDEX_NAME INDEX_NAME, ' +
    'S.RDB$FIELD_NAME COLUMN_NAME, S.RDB$FIELD_POSITION COLUMN_POSITION, ' +
    'C.RDB$CONSTRAINT_NAME PKEY_NAME, I.RDB$UNIQUE_FLAG, C.RDB$CONSTRAINT_TYPE, ' +
    'I.RDB$INDEX_TYPE ' +
    'FROM RDB$INDICES I ' +
    'INNER JOIN RDB$INDEX_SEGMENTS S ON (I.RDB$INDEX_NAME = S.RDB$INDEX_NAME) ' +
    'LEFT JOIN RDB$RELATION_CONSTRAINTS C ON (I.RDB$INDEX_NAME = C.RDB$INDEX_NAME) ' +
    '%s ORDER BY S.RDB$INDEX_NAME, S.RDB$FIELD_POSITION';

  snTABLE_NAME    = 1;
  snINDEX_NAME    = 2;
  snCOLUMN_NAME   = 3;
  snPOSITION      = 4;
  snPKEY_NAME     = 5;
  snUNIQUE_FLAG   = 6;
  snCONSTRAINT_TYPE = 7;
  snINDEX_TYPE    = 8;

  dnRECNO         = 1;
  dnCATALOG_NAME  = 2;
  dnSCHEMA_NAME   = 3;
  dnTABLE_NAME    = 4;
  dnINDEX_NAME    = 5;
  dnCOLUMN_NAME   = 6;
  dnPOSITION      = 7;
  dnPKEY_NAME     = 8;
  dnINDEX_TYPE    = 9;
  dnSORT_ORDER    = 10;
  dnFILTER        = 11;
var
  WhereClause, TableName, IndexName: string;
  Value: variant;
  IndexType: integer;
  SortOrder: string;
begin
  TableName := Trim(Restrictions.Values['TABLE_NAME']);
  IndexName := Trim(Restrictions.Values['INDEX_NAME']);

  WhereClause := '';
  AddWhere(WhereClause, 'I.RDB$RELATION_NAME', TableName);
  AddWhere(WhereClause, 'I.RDB$INDEX_NAME', IndexName);
  if WhereClause <> '' then
    WhereClause := 'WHERE ' + WhereClause;

  FRecordSet.SetSQL(Format(fmtGetIndexColumnsSQL, [WhereClause]));
  FRecordSet.Open;

  CreateIndexColumnsFields;
  FMemData.Open;
  FMemDataHelper.AllocBuffer;
  FRecordSetHelper.AllocBuffer;
  while FRecordSetHelper.NextRecord do begin
    FMemDataHelper.InitRecord;
    CopyRecord([snTABLE_NAME, snINDEX_NAME, snCOLUMN_NAME, snPOSITION, snPKEY_NAME],
      [dnTABLE_NAME, dnINDEX_NAME, dnCOLUMN_NAME, dnPOSITION, dnPKEY_NAME]);

    Value := FRecordSetHelper.FieldValues[snUNIQUE_FLAG];
    if Value = 1 then
      IndexType := eSQLUnique
    else
      IndexType := eSQLNonUnique;
    Value := FRecordSetHelper.FieldValues[snCONSTRAINT_TYPE];
    if Value = 'PRIMARY KEY' then
      IndexType := IndexType or eSQLPrimaryKey;
    FMemDataHelper.FieldValues[dnINDEX_TYPE] := IndexType;

    Value := FRecordSetHelper.FieldValues[snINDEX_TYPE];
    if Value = 1 then
      SortOrder := 'D'
    else
      SortOrder := 'A';
    FMemDataHelper.FieldValues[dnSORT_ORDER] := SortOrder;
    FMemDataHelper.FieldValues[dnFILTER] := '<NULL>';

    FMemDataHelper.AppendRecord;
  end;
  FMemData.SetToBegin;
  Result := FMemData;
end;

procedure TDbxIdaMetaInfo.CopyObjectList;
const
  snOBJECT_NAME   = 1;

  dnRECNO         = 1;
  dnCATALOG_NAME  = 2;
  dnSCHEMA_NAME   = 3;
  dnOBJECT_NAME   = 4;
begin
  CreateObjectListFields;
  FMemData.Open;
  FMemDataHelper.AllocBuffer;
  FRecordSetHelper.AllocBuffer;
  while FRecordSetHelper.NextRecord do begin
    FMemDataHelper.InitRecord;
    CopyRecord([snOBJECT_NAME], [dnOBJECT_NAME]);
    FMemDataHelper.AppendRecord;
  end;
  FMemData.SetToBegin;
end;

function TDbxIdaMetaInfo.GetDataTypes(Restrictions: TStrings): TData;
const
  DataTypesCount = 11;
  DataTypeNames: array [1..DataTypesCount] of string =
    ('BLOB', 'CHAR', 'DATE', 'DOUBLE PRECISION', 'FLOAT', 'INTEGER', 'NUMERIC',
    'SMALLINT', 'TIME', 'TIMESTAMP', 'VARCHAR');
var
  RecNo: integer;
begin
  CreateObjectListFields;
  FMemData.Open;
  FMemDataHelper.AllocBuffer;
  for RecNo := 1 to DataTypesCount do begin
    FMemDataHelper.InitRecord;
    FMemDataHelper.FieldValues[1] := RecNo;
    FMemDataHelper.FieldValues[2] := '<NULL>';
    FMemDataHelper.FieldValues[3] := '<NULL>';
    FMemDataHelper.FieldValues[4] := DataTypeNames[RecNo];
    FMemDataHelper.AppendRecord;
  end;
  FMemData.SetToBegin;
  Result := FMemData;
end;

function TDbxIdaMetaInfo.GetRoles(Restrictions: TStrings): TData;
begin
  inherited GetRoles(Restrictions);

  CopyObjectList;
  Result := FMemData;
end;

end.
