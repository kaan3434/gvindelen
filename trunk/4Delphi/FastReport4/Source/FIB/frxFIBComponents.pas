(*
 *
 *        FastReport 4.0
 *
 *    FIBPlus enduser components
 *
 *    Copyright (c) 2004-2006
 *
 *    Roman V. Babenko aka romb
 *          mailto: romb@devrace.com, romb@devrona.com
 *
 *
*)

unit frxFIBComponents;

interface

{$I frx.inc}

uses
  Graphics, Windows, Classes, SysUtils, frxClass, frxCustomDB, DB,
  FIBDatabase, pFIBDatabase, FIBDataSet, pFIBDataSet, FIBQuery
{$IFDEF Delphi6}
, Variants
{$ENDIF}
{$IFDEF QBUILDER}
, fqbClass
{$ENDIF};

type
  TfrxFIBComponents = class(TfrxDBComponents)
  private
    FDefaultDatabase: TpFIBDatabase;
    FOldComponents: TfrxFIBComponents;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetDescription: String; override;
  published
    property DefaultDatabase: TpFIBDatabase read FDefaultDatabase write FDefaultDatabase;
  end;

  TfrxFIBDatabase = class(TfrxCustomDatabase)
  private
    FDatabase: TpFIBDatabase;
    function GetSQLDialect: Integer;
    procedure SetSQLDialect(const Value: Integer);
    function GetLibraryName: string;
    procedure SetLibraryName(const Value: string);
    function GetTRParams: TStrings;
  protected
    procedure SetConnected(Value: Boolean); override;
    procedure SetDatabaseName(const Value: String); override;
    procedure SetLoginPrompt(Value: Boolean); override;
    procedure SetParams(Value: TStrings); override;
    function GetConnected: Boolean; override;
    function GetDatabaseName: String; override;
    function GetLoginPrompt: Boolean; override;
    function GetParams: TStrings; override;
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: String; override;
    procedure SetLogin(const Login, Password: String); override;
    property Database: TpFIBDatabase read FDatabase;
  published
    property DatabaseName;
    property LoginPrompt;
    property Params;
    property SQLDialect: Integer read GetSQLDialect write SetSQLDialect;
    property Connected;
    {FIBPlus properties}
    property LibraryName: string read GetLibraryName write SetLibraryName;
    property TRParams: TStrings read GetTRParams;
  end;

  TfrxFIBQuery = class(TfrxCustomQuery)
  private
    FDatabase: TfrxFIBDatabase;
    FQuery: TpFIBDataset;
    procedure SetDatabase(const Value: TfrxFIBDatabase);
    function GetUniDirectional: Boolean;
    procedure SetUniDirectional(const Value: Boolean);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetMaster(const Value: TDataSource); override;
    procedure SetSQL(Value: TStrings); override;
    function  GetSQL: TStrings; override;
  public
    constructor Create(AOwner: TComponent); override;
    constructor DesignCreate(AOwner: TComponent; Flags: Word); override;
    class function GetDescription: String; override;
    procedure BeforeStartReport; override;
    procedure UpdateParams; override;
{$IFDEF QBUILDER}
    function QBEngine: TfqbEngine; override;
{$ENDIF}
    property Query: TpFIBDataset read FQuery;
  published
    property Database: TfrxFIBDatabase read FDatabase write SetDatabase;
    property UniDirectional: Boolean read GetUniDirectional write SetUniDirectional default False;
  end;

{$IFDEF QBUILDER}
  TfrxEngineFIB = class(TfqbEngine)
  private
    FQuery: TFIBDataset;
  public
    constructor Create(AOwner: TComponent); override;
    procedure ReadTableList(ATableList: TStrings); override;
    procedure ReadFieldList(const ATableName: string; var AFieldList: TfqbFieldList); override;
    function ResultDataSet: TDataSet; override;
    procedure SetSQL(const Value: string); override;
  end;
{$ENDIF}

var
  FIBComponents: TfrxFIBComponents;


implementation

uses
  frxFIBRTTI, frxUtils, frxRes,
{$IFNDEF NO_EDITORS}
  frxFIBEditor,
{$ENDIF}
  frxDsgnIntf;           

procedure frxFIBParamsToTParams(Query: TfrxCustomQuery; aParams: TFIBXSQLDA);
var
  i: Integer;
  Item: TfrxParamItem;
begin
  with Query do
  for i := 0 to aParams.Count - 1 do
    if Params.IndexOf(aParams[i].Name) <> -1 then
    begin
      Item := Params.Find(aParams[i].Name);
      if Item <> nil  then
      begin
        if Trim(Item.Expression) <> '' then
          if not (IsLoading or IsDesigning) then
          begin
            Report.CurObject := Name;
            Item.Value := Report.Calc(Item.Expression);
          end;
        if not VarIsEmpty(Item.Value) then
        try
          if Item.DataType = ftDate then
            aParams[i].AsDate := VarToDateTime(Item.Value)
          else
            aParams[i].AsString := VarToStr(Item.Value);
        except
          aParams[i].AsString := Item.Value;
        end;
      end;
    end;
end;

{ TfrxDBComponents }

constructor TfrxFIBComponents.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOldComponents := FIBComponents;
  FIBComponents := Self;
end;

destructor TfrxFIBComponents.Destroy;
begin
  if FIBComponents = Self then
    FIBComponents := FOldComponents;
  inherited Destroy;
end;

function TfrxFIBComponents.GetDescription: String;
begin
  Result := 'FIB';
end;


{ TfrxFIBDatabase }

constructor TfrxFIBDatabase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDatabase := TpFIBDatabase.Create(nil);
  FDatabase.DefaultTransaction := TpFIBTransaction.Create(FDatabase);
  FDatabase.DefaultTransaction.TRParams.CommaText :=
  'isc_tpb_read,isc_tpb_nowait,isc_tpb_read_committed,isc_tpb_rec_version';
  Component := FDatabase;
  FImageIndex := 37;
end;

class function TfrxFIBDatabase.GetDescription: String;
begin
  Result := frxResources.Get('obFIBDB');
end;

function TfrxFIBDatabase.GetConnected: Boolean;
begin
  Result := FDatabase.Connected;
end;

function TfrxFIBDatabase.GetDatabaseName: String;
begin
  Result := FDatabase.DatabaseName;
end;

function TfrxFIBDatabase.GetLibraryName: string;
begin
  Result := Database.LibraryName;
end;

function TfrxFIBDatabase.GetLoginPrompt: Boolean;
begin
  Result := FDatabase.UseLoginPrompt;
end;

function TfrxFIBDatabase.GetParams: TStrings;
begin
  Result := FDatabase.DBParams;
end;

function TfrxFIBDatabase.GetSQLDialect: Integer;
begin
  Result := FDatabase.SQLDialect;
end;

function TfrxFIBDatabase.GetTRParams: TStrings;
begin
  Result := FDatabase.DefaultTransaction.TRParams;
end;

procedure TfrxFIBDatabase.SetConnected(Value: Boolean);
begin
  BeforeConnect(Value);
  FDatabase.Connected := Value;
end;

procedure TfrxFIBDatabase.SetDatabaseName(const Value: String);
begin
  FDatabase.DatabaseName := Value;
end;

procedure TfrxFIBDatabase.SetLoginPrompt(Value: Boolean);
begin
  FDatabase.UseLoginPrompt := Value;
end;

procedure TfrxFIBDatabase.SetParams(Value: TStrings);
begin
  FDatabase.DBParams.AddStrings(Value);
end;

procedure TfrxFIBDatabase.SetSQLDialect(const Value: Integer);
begin
  FDatabase.SQLDialect := Value;
end;

procedure TfrxFIBDatabase.SetLibraryName(const Value: string);
var
  saveActive: Boolean;
begin
  saveActive := Database.Connected;
  Database.Connected := False;
  Database.LibraryName := Value;
  Database.Connected := saveActive;
end;

procedure TfrxFIBDatabase.SetLogin(const Login, Password: String);
begin
  Params.Text := 'user_name=' + Login + #13#10 + 'password=' + Password;
end;

{ TfrxFIBQuery }

constructor TfrxFIBQuery.Create(AOwner: TComponent);
begin
  FQuery := TpFIBDataset.Create(nil);
  Dataset := FQuery;
  SetDatabase(nil);
  inherited Create(AOwner);
  FImageIndex := 39;
end;

constructor TfrxFIBQuery.DesignCreate(AOwner: TComponent; Flags: Word);
var
  i: Integer;
  l: TList;
begin
  inherited DesignCreate(AOwner, Flags);
  l := Report.AllObjects;
  for i := 0 to l.Count - 1 do
  begin
    if TObject(l[i]) is TfrxFIBDatabase then
    begin
      SetDatabase(TfrxFIBDatabase(l[i]));
      break;
    end;
  end;
end;

class function TfrxFIBQuery.GetDescription: String;
begin
  Result := frxResources.Get('obFIBQ');
end;

procedure TfrxFIBQuery.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FDatabase) then
  begin
    SetDatabase(nil);
  end;
end;

procedure TfrxFIBQuery.SetDatabase(const Value: TfrxFIBDatabase);
begin
  FDatabase := Value;
  if Value <> nil then
    FQuery.Database := Value.Database
  else if FIBComponents <> nil then
    FQuery.Database := FIBComponents.DefaultDatabase
  else
    FQuery.Database := nil;
  DBConnected := FQuery.Database <> nil;
end;

procedure TfrxFIBQuery.SetMaster(const Value: TDataSource);
begin
  FQuery.DataSource := Value;
end;

procedure TfrxFIBQuery.SetSQL(Value: TStrings);
begin
  FQuery.SelectSQL := Value;
end;

procedure TfrxFIBQuery.SetUniDirectional(const Value: boolean);
begin
  FQuery.UniDirectional := Value;
end;

function TfrxFIBQuery.GetSQL: TStrings;
begin
  Result := FQuery.SelectSQL;
end;

function TfrxFIBQuery.GetUniDirectional: boolean;
begin
  Result := FQuery.UniDirectional;
end;

procedure TfrxFIBQuery.UpdateParams;
begin
  frxFIBParamsToTParams(Self, FQuery.Params);
end;

procedure TfrxFIBQuery.BeforeStartReport;
begin
  SetDatabase(FDatabase);
  if Assigned(Database) and (not Database.Connected) then
  begin
    Database.Connected := True;
  end;
end;

{$IFDEF QBUILDER}
function TfrxFIBQuery.QBEngine: TfqbEngine;
begin
  Result := TfrxEngineFIB.Create(nil);
  TfrxEngineFIB(Result).FQuery.Database := FQuery.Database;
  if Assigned(FQuery.Database) and Assigned(FQuery.Transaction) and
     not FQuery.Database.Connected then
  begin
    FQuery.Database.Connected := True;
  end;  
end;
{$ENDIF}


{$IFDEF QBUILDER}
constructor TfrxEngineFIB.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FQuery := TpFIBDataset.Create(Self);
end;

procedure TfrxEngineFIB.ReadFieldList(const ATableName: string;
  var AFieldList: TfqbFieldList);
var
 ds       : TpFIBDataSet;
 i        : Integer;
 fqbField : TfqbField;
 Field    : TField;
begin
  ds := TpFIBDataSet.Create(nil);
  try
    ds.Database := FQuery.Database;
    ds.SelectSQL.Text := format('SELECT * FROM %s', [ATableName]);
    AFieldList.Add.FieldName := '*';
    ds.FieldDefs.Update;
    for i := 0 to ds.FieldDefs.Count - 1 do
    begin
      Field := ds.FieldDefs.Items[i].CreateField(ds);
      with AFieldList.Add do
      begin
        FieldName := Field.FieldName;
        FieldType := Ord(Field.DataType);
      end;
    end;
  finally
    FreeAndNil(ds);
  end;
end;

procedure TfrxEngineFIB.ReadTableList(ATableList: TStrings);
begin
  ATableList.Clear;
  TpFIBDatabase(FQuery.Database).GetTableNames(ATableList, ShowSystemTables);
end;

function TfrxEngineFIB.ResultDataSet: TDataSet;
begin
  Result := FQuery;
end;

procedure TfrxEngineFIB.SetSQL(const Value: string);
begin
  FQuery.SelectSQL.Text := Value;
end;
{$ENDIF}                 

initialization
  frxObjects.RegisterObject1(TfrxFIBDataBase, nil, '', '', 0, 37);
  frxObjects.RegisterObject1(TfrxFIBQuery, nil, '', '', 0, 39);
  
finalization
  frxObjects.UnRegister(TfrxFIBDataBase);
  frxObjects.UnRegister(TfrxFIBQuery);

end.