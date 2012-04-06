
//////////////////////////////////////////////////
//  InterBase Data Access Components
//  Copyright © 1998-2011 Devart. All right reserved.
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I IbDac.inc}

unit IBCDesignUtils;
{$ENDIF}

interface

uses
  Classes, SysUtils, CRTypes, DBAccess, DADesignUtils;

type
  TIBCDesignUtils = class(TDADesignUtils)
    class function GetProjectName: string; override;

  { Component }
    class function GetDesignCreate(Obj: TComponent): boolean; override;
    class procedure SetDesignCreate(Obj: TComponent; Value: boolean); override;
  {$IFNDEF FPC}
    class function GetConnectionList: TObject; override;
  {$ENDIF}

  { Connection support }
    class function HasConnection(Obj: TComponent): boolean; override;
    class function GetConnection(Obj: TComponent): TCustomDAConnection; override;
    class procedure SetConnection(Obj: TComponent; Value: TCustomDAConnection); override;

  { TDATable support }
    class function GetTableName(Obj: TCustomDADAtaSet): _string; override;
    class procedure SetTableName(Obj: TCustomDADAtaSet; const Value: _string); override;
    class function GetOrderFields(Obj: TCustomDADAtaSet): _string; override;
    class procedure SetOrderFields(Obj: TCustomDADAtaSet; const Value: _string); override;
    class procedure PrepareSQL(Obj: TCustomDADAtaSet); override;

  { TDAStoredProc support}
    class function GetStoredProcName(Obj: TCustomDADataSet): _string; override;
    class procedure SetStoredProcName(Obj: TCustomDADataSet; const Value: _string); override;
  {$IFDEF USE_SYNEDIT}
    class function SQLDialect: integer ; override; // SynHighlighterSQL TSQLDialect = (sqlStandard, sqlInterbase6, sqlMSSQL7, sqlMySQL, sqlOracle, sqlSybase, sqlIngres, sqlMSSQL2K);
  {$ENDIF}
  end;

implementation

uses
  IBC {$IFDEF IBDAC}, IBCDesign{$ENDIF};

{ TIBCDesignUtils }

class function TIBCDesignUtils.GetProjectName: string;
begin
  Result := 'IBDAC';
end;

class function TIBCDesignUtils.HasConnection(Obj: TComponent): boolean;
begin
  Result := inherited HasConnection(Obj);
end;

class function TIBCDesignUtils.GetConnection(Obj: TComponent): TCustomDAConnection;
begin
  Result := inherited GetConnection(Obj);
end;

class procedure TIBCDesignUtils.SetConnection(Obj: TComponent; Value: TCustomDAConnection);
begin
  inherited;
end;

class function TIBCDesignUtils.GetOrderFields(
  Obj: TCustomDADAtaSet): _string;
begin
  Assert(Obj is TCustomIBCTable, Obj.ClassName);
  Result := TCustomIBCTable(Obj).OrderFields;
end;

class procedure TIBCDesignUtils.SetOrderFields(Obj: TCustomDADAtaSet;
  const Value: _string);
begin
  Assert(Obj is TCustomIBCTable, Obj.ClassName);
  TCustomIBCTable(Obj).OrderFields := Value;
end;

class function TIBCDesignUtils.GetTableName(Obj: TCustomDADAtaSet): _string;
begin
  Assert(Obj is TCustomIBCTable, Obj.ClassName);
  Result := TCustomIBCTable(Obj).TableName;
end;

class procedure TIBCDesignUtils.SetTableName(Obj: TCustomDADAtaSet;
  const Value: _string);
begin
  Assert(Obj is TCustomIBCTable, Obj.ClassName);
  TCustomIBCTable(Obj).TableName := Value;
end;

class procedure TIBCDesignUtils.PrepareSQL(Obj: TCustomDADAtaSet);
begin
  Assert(Obj is TCustomIBCTable, Obj.ClassName);
  TCustomIBCTable(Obj).PrepareSQL;
end;

class function TIBCDesignUtils.GetDesignCreate(Obj: TComponent): boolean;
begin
  Result := inherited GetDesignCreate(Obj);
end;

class procedure TIBCDesignUtils.SetDesignCreate(Obj: TComponent;
  Value: boolean);
begin
  inherited SetDesignCreate(Obj, Value);
end;

{$IFNDEF FPC}
class function TIBCDesignUtils.GetConnectionList: TObject;
begin
{$IFDEF IBDAC}
  Result := TIBCConnectionList.Create;
{$ELSE}
  Result := nil;
{$ENDIF}
end;
{$ENDIF}

class function TIBCDesignUtils.GetStoredProcName(Obj: TCustomDADataSet): _string;
begin
  Assert(Obj is TIBCStoredProc, Obj.ClassName);
  Result := TIBCStoredProc(Obj).StoredProcName;
end;

class procedure TIBCDesignUtils.SetStoredProcName(Obj: TCustomDADataSet; const Value: _string);
begin
  Assert(Obj is TIBCStoredProc, Obj.ClassName);
  TIBCStoredProc(Obj).StoredProcName := Value;
end;

{$IFDEF USE_SYNEDIT}
class function TIBCDesignUtils.SQLDialect: integer;
begin
  Result := 1; // sqlInterbase6
end;
{$ENDIF}

end.
