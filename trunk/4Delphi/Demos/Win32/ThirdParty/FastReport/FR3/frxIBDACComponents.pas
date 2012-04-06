{******************************************}
{                                          }
{             FastReport v3.20             }
{         IBDAC enduser components         }
{                                          }

// Created by: Devart
// E-mail: ibdac@devart.com

{                                          }
{******************************************}

unit frxIBDACComponents;

interface

{$I frx.inc}

uses
  Windows, Sysutils, Classes, frxClass, frxCustomDB, DB, IBC, IbDacVcl,
 frxDACComponents
{$IFDEF Delphi6}
, Variants
{$ENDIF}
{$IFDEF QBUILDER}
, fqbClass
{$ENDIF};

type
  TIBDACTable = class(TIBCTable)
  protected
    procedure InitFieldDefs; override;
  end;

  TIBDACQuery = class(TIBCQuery)
  protected
    procedure InitFieldDefs; override;
  end;

  TfrxIBDACComponents = class(TfrxDACComponents)
  public
    function GetDescription: string; override;

    class function GetComponentsName: string; override;
    class function ResourceName: string; override;
    class function GetDatabaseClass: TfrxDACDatabaseClass; override;
    class function GetTableClass: TfrxDACTableClass; override;
    class function GetQueryClass: TfrxDACQueryClass; override;
  end;

  TfrxIBDACDatabase = class(TfrxDACDatabase)
  private
  protected
    function GetDatabaseName: string; override;
    procedure SetDatabaseName(const Value: string); override;

  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: string; override;

  published
    property LoginPrompt;
    property DatabaseName;
    property Username;
    property Password;
    property Server;
    property Connected;
    Property Params;
  end;

  TfrxIBDACTable = class(TfrxDACTable)
  private
    FTable: TIBDACTable;
  protected
    procedure SetDatabase(const Value: TfrxDACDatabase); override;
    procedure SetMaster(const Value: TDataSource); override;
    procedure SetMasterFields(const Value: string); override;
    procedure SetIndexFieldNames(const Value: string); override;
    function GetIndexFieldNames: string; override;
    function GetTableName: string; override;
    procedure SetTableName(const Value: string); override;
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: string; override;

    property Table: TIBDACTable read FTable;
  published
    property Database;
    Property TableName: string read GetTableName write setTableName;
  end;

TfrxIBDACQuery = class(TfrxDACQuery)
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: string; override;
{$IFDEF QBUILDER}
    function QBEngine: TfqbEngine; override;
{$ENDIF}
  published
    property Database;
    property IndexName;
    property MasterFields;
  end;

 {$IFDEF QBUILDER}
  TfrxEngineIBDAC = class(TfrxEngineDAC)
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ReadFieldList(const ATableName: string; var AFieldList: TfqbFieldList); override;
  end;
 {$ENDIF}

implementation

{$R *.res}

uses
  Graphics, frxIBDACRTTI,
{$IFNDEF NO_EDITORS}
  frxIBDACEditor,
{$ENDIF}
  frxDsgnIntf, frxRes;

{ TIBDACTable }

procedure TIBDACTable.InitFieldDefs;
begin
  if (TableName <> '') and (Assigned(Connection)) then
    inherited;
end;

{ TIBDACQuery }

procedure TIBDACQuery.InitFieldDefs;
begin
  if (SQL.Text <> '') and Assigned(Connection) then
    inherited;
end;

{ TfrxIBDACComponents }

class function TfrxIBDACComponents.GetComponentsName: string;
begin
  Result := 'IBDAC';
end;

class function TfrxIBDACComponents.GetDatabaseClass: TfrxDACDatabaseClass;
begin
  Result := TfrxIBDACDatabase;
end;

class function TfrxIBDACComponents.GetTableClass: TfrxDACTableClass;
begin
  Result := TfrxIBDACTable;
end;

class function TfrxIBDACComponents.GetQueryClass: TfrxDACQueryClass;
begin
  Result := TfrxIBDACQuery;
end;

class function TfrxIBDACComponents.ResourceName: string;
begin
  Result := 'frxIBDACObjects';
end;

function TfrxIBDACComponents.GetDescription: string;
begin
  Result := 'IBDAC';
end;

{ TfrxIBDACDatabase }

constructor TfrxIBDACDatabase.Create(AOwner: TComponent);
begin
  inherited;
  FDatabase := TIBCConnection.Create(nil);
  Component := FDatabase;
end;

class function TfrxIBDACDatabase.GetDescription: string;
begin
  Result := 'IBDAC Database';
end;

function TfrxIBDACDatabase.GetDatabaseName: string;
begin
  Result := TIBCConnection(FDatabase).Database;
end;

procedure TfrxIBDACDatabase.SetDatabaseName(const Value: string);
begin
  TIBCConnection(FDatabase).Database := Value;
end;

{ TfrxIBDACTable }

constructor TfrxIBDACTable.Create(AOwner: TComponent);
begin
  FTable := TIBDACTable.Create(nil);
  DataSet := FTable;
  SetDatabase(nil);
  inherited;
end;

class function TfrxIBDACTable.GetDescription: string;
begin
  Result := 'IBDAC Table';
end;

procedure TfrxIBDACTable.SetDatabase(const Value: TfrxDACDatabase);
begin
  inherited;
  if Value <> nil then
    FTable.Connection := TIBCConnection(Value.Database)
  else
    if DACComponents <> nil then
      FTable.Connection := TIBCConnection(DACComponents.DefaultDatabase)
    else
      FTable.Connection := nil;
end;

function TfrxIBDACTable.GetIndexFieldNames: string;
begin
  Result := FTable.IndexFieldNames;
end;

function TfrxIBDACTable.GetTableName: string;
begin
  Result := FTable.TableName;
end;

procedure TfrxIBDACTable.SetIndexFieldNames(const Value: string);
begin
  FTable.IndexFieldNames := Value;
end;

procedure TfrxIBDACTable.SetTableName(const Value: string);
begin
  FTable.TableName := Value;
  if Assigned(FTable.Connection) then
    FTable.InitFieldDefs;
end;

procedure TfrxIBDACTable.SetMaster(const Value: TDataSource);
begin
  FTable.MasterSource := Value;
end;

procedure TfrxIBDACTable.SetMasterFields(const Value: string);
var
  MasterNames: string;
  DetailNames: string;
begin
  GetMasterDetailNames(MasterFields, MasterNames, DetailNames);
  FTable.MasterFields := MasterNames;
  FTable.DetailFields := DetailNames;
end;

{ TfrxIBDACQuery }

constructor TfrxIBDACQuery.Create(AOwner: TComponent);
begin
  FQuery := TIBDACQuery.Create(nil);
  inherited Create(AOwner);
end;

class function TfrxIBDACQuery.GetDescription: string;
begin
  Result := 'IBDAC Query';
end;

 {$IFDEF QBUILDER}
function TfrxIBDACQuery.QBEngine: TfqbEngine;
begin
  Result := TfrxEngineIBDAC.Create(nil);
  TfrxEngineIBDAC(Result).FQuery.Connection := TIBCConnection(FQuery.Connection);
end;
 {$ENDIF}

 {$IFDEF QBUILDER}

{ TfrxEngineIBDAC }

constructor TfrxEngineIBDAC.Create(AOwner: TComponent);
begin
  inherited;
  FQuery := TIBDACQuery.Create(Self);
end;

destructor TfrxEngineIBDAC.Destroy;
begin
  FQuery.Free;
  inherited;
end;

procedure TfrxEngineIBDAC.ReadFieldList(const ATableName: string;
  var AFieldList: TfqbFieldList);
var
  TempTable: TIBDACTable;
  Fields: TFieldDefs;
  i: Integer;
  tmpField: TfqbField;
begin
  AFieldList.Clear;
  TempTable := TIBDACTable.Create(Self);
  try
    TempTable.Connection := TIBCConnection(FQuery.Connection);
    TempTable.TableName := ATableName;
    Fields := TempTable.FieldDefs;
    try
      TempTable.Active := True;
      tmpField:= TfqbField(AFieldList.Add);
      tmpField.FieldName := '*';
      for i := 0 to Fields.Count - 1 do begin
        tmpField := TfqbField(AFieldList.Add);
        tmpField.FieldName := Fields.Items[i].Name;
        tmpField.FieldType := Ord(Fields.Items[i].DataType)
      end;
    except
    end;
  finally
    TempTable.Free;
  end;
end;

 {$ENDIF}

initialization
  RegisterDacComponents(TfrxIBDACComponents);

finalization
  UnRegisterDacComponents(TfrxIBDACComponents);

end.
