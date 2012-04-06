
//////////////////////////////////////////////////
//  Interbase Data Access Components
//  Copyright © 2006-2011 Devart. All right reserved.
//  ReportBuilder support
//  Based on Digital Metaphors Corporation's demos
//////////////////////////////////////////////////

unit daIBDAC;

interface
uses
  Classes, SysUtils, Forms, ExtCtrls, DB,
  ppClass, ppComm, ppDBPipe, ppDB, ppClasUt, ppTypes,
  daDB, daDataView, daQueryDataView, daPreviewDataDlg,
  IBC, IbDacVcl;

type
  {Interbase Data Access Components (IBDAC) DataView Classes:
     1.  IBDAC TDataSet descendants
           - TDataSets that can be children of a DataView.
           - Override the HasParent method of TComponent to return True
           - Must be registerd with the Delphi IDE using the RegisterNoIcon procedure

       a. TdaChildIBDACQuery        - TIBCQuery descendant that can be a child of a DataView
       b. TdaChildIBDACTable        - TIBCTable descendant that can be a child of a DataView
       b. TdaChildIBDACStoredProc   - TIBCStoredProc descendant that can be a child of a DataView

     3.  TdaIBDACSession
           - descendant of TppSession
           - implements GetDatabaseNames, GetTableNames, etc.

     4.  TdaIBDACDataSet
          - descendant of TppDataSet
          - implements GetFieldNames for SQL

     5.  TdaIBDACQueryDataView
          - descendant of TppQueryDataView
          - uses the above classes to create the required
            Query -> DataSource -> Pipeline -> Report connection
          - uses the TdaSQL object built by the QueryWizard to assign
            SQL to the TIBDACQuery etc.
      }

  { TdaChildIBDACQuery }
  TdaChildIBDACQuery = class(TIBCQuery)
  public
    function HasParent: Boolean; override;
  end;  {class, TdaChildIBDACQuery}

  { TdaChildIBDACTable }
  TdaChildIBDACTable = class(TIBCTable)
  public
    function HasParent: Boolean; override;
  end;  {class, TdaChildIBDACTable}

  { TdaChildIBDACStoredProc }
  TdaChildIBDACStoredProc = class(TIBCStoredProc)
  public
    function HasParent: Boolean; override;
  end;  {class, TdaChildIBDACStoredProc}

  { TdaIBDACSession }
  TdaIBDACSession = class(TdaSession)
  private

    procedure AddDatabase(aDatabase: TComponent);

  protected
    procedure SetDataOwner(aDataOwner: TComponent); override;

  public
    class function ClassDescription: String; override;
    class function DataSetClass: TdaDataSetClass; override;
    class function DatabaseClass: TComponentClass; override;

    procedure GetDatabaseNames(aList: TStrings); override;
    function  GetDatabaseType(const aDatabaseName: String): TppDatabaseType; override;
    procedure GetTableNames(const aDatabaseName: String; aList: TStrings); override;
    function  ValidDatabaseTypes: TppDatabaseTypes; override;
  end; {class, TdaIBDACSession}

  { TdaIBDACDataSet }
  TdaIBDACDataSet = class(TdaDataSet)
  private
    FQuery: TIBCQuery;
    FSession: TIBCConnection;

    function GetQuery: TIBCQuery;

  protected
    procedure BuildFieldList; override;
    function  GetActive: Boolean; override;
    procedure SetActive(Value: Boolean); override;
    procedure SetDatabase(aDatabase: TComponent); override;
    procedure SetDataName(const aDataName: String); override;

    property Query: TIBCQuery read GetQuery;

  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;

    class function ClassDescription: String; override;

    procedure GetFieldNamesForSQL(aList: TStrings; aSQL: TStrings); override;
    procedure GetFieldsForSQL(aList: TList; aSQL: TStrings); override;
  end; {class, TdaIBDACDataSet}

  { TdaIBDACQueryDataView }
  TdaIBDACQueryDataView = class(TdaQueryDataView)
    private
      FDataSource: TppChildDataSource;
      FQuery: TdaChildIBDACQuery;

    protected
      procedure SQLChanged; override;

    public
      constructor Create(aOwner: TComponent); override;
      destructor Destroy; override;

      class function PreviewFormClass: TFormClass; override;
      class function SessionClass: TClass; override;

      procedure Init; override;
      procedure ConnectPipelinesToData; override;

    published
      property DataSource: TppChildDataSource read FDataSource;

  end; {class, TdaIBDACQueryDataView}


  {global functions to access default IBDAC connection}
  function daGetDefaultIBDACConnection: TIBCConnection;

  {utility routines}
  procedure daGetIBDACConnectionNames(aList: TStrings);
  function daGetIBDACConnectionForName(aDatabaseName: String): TIBCConnection;
  function daIBDACConnectToDatabase(aDatabaseName: String): Boolean;

  function daGetIBDACConnectionList: TppComponentList;

  {Delphi design time registration}
  procedure Register;

implementation

const
  cDefaultConnection = 'DefaultIBDACConnection';

var
  FIBDACConnection: TIBCConnection;
  FIBDACConnectionList: TppComponentList;


{******************************************************************************
 *
 ** R E G I S T E R
 *
{******************************************************************************}

procedure Register;
begin
  {IBDAC DataAccess Components}
  RegisterNoIcon([TdaChildIBDACQuery, TdaChildIBDACTable, TdaChildIBDACStoredProc]);

  {IBDAC DataViews}
  RegisterNoIcon([TdaIBDACQueryDataView]);
end;


{******************************************************************************
 *
 ** C H I L D   I N T E R B A S E   D A T A   A C C E S S   C O M P O N E N T S
 *
{******************************************************************************}

{------------------------------------------------------------------------------}
{ TdaChildIBDACQuery.HasParent }

function TdaChildIBDACQuery.HasParent: Boolean;
begin
  Result := True;
end; {function, HasParent}

{------------------------------------------------------------------------------}
{ TdaChildIBDACTable.HasParent }

function TdaChildIBDACTable.HasParent: Boolean;
begin
  Result := True;
end; {function, HasParent}

{------------------------------------------------------------------------------}
{ TdaChildIBDACStoredProc.HasParent }

function TdaChildIBDACStoredProc.HasParent: Boolean;
begin
  Result := True;
end; {function, HasParent}

{******************************************************************************
 *
 ** I N T E R B A S E   C O N N E C T I O N
 *
{******************************************************************************}

{------------------------------------------------------------------------------}
{ TdaIBDACSession.ClassDescription }

class function TdaIBDACSession.ClassDescription: String;
begin
  Result := 'IBDACSession';
end; {class function, ClassDescription}

{------------------------------------------------------------------------------}
{ TdaIBDACSession.DataSetClass }

class function TdaIBDACSession.DataSetClass: TdaDataSetClass;
begin
  Result := TdaIBDACDataSet;
end; {class function, DataSetClass}

{------------------------------------------------------------------------------}
{ TdaIBDACSession.DatabaseClass }

class function TdaIBDACSession.DatabaseClass: TComponentClass;
begin
  Result := TIBCConnection;
end;

{------------------------------------------------------------------------------}
{ TdaIBDACSession.GetDatabaseType }

function TdaIBDACSession.GetDatabaseType(const aDatabaseName: String): TppDatabaseType;
begin
  Result := dtInterbase;
end; {procedure, GetDatabaseType}

{------------------------------------------------------------------------------}
{ TdaIBDACSession.GetTableNames }

procedure TdaIBDACSession.GetTableNames(const aDatabaseName: String; aList: TStrings);
begin
  {get list of table names from a table object}
  if not daIBDACConnectToDatabase(aDatabaseName) then Exit;

  daGetIBDACConnectionForName(aDatabaseName).GetTableNames(aList);

end; {procedure, GetTableNames}

{------------------------------------------------------------------------------}
{ TdaIBDACSession.AddDatabase }

procedure TdaIBDACSession.AddDatabase(aDatabase: TComponent);
begin
  if daGetIBDACConnectionList.IndexOf(aDatabase) < 0 then
    FIBDACConnectionList.Add(aDatabase);
end; {procedure, AddDatabase}

{------------------------------------------------------------------------------}
{ TdaIBDACSession.GetDatabaseNames }

procedure TdaIBDACSession.GetDatabaseNames(aList: TStrings);
var
  liIndex: Integer;
begin
  {call utility routine to get list of database names}
  //daGetIBDACConnectionNames(aList);

  daGetDatabaseObjectsFromOwner(TdaSessionClass(Self.ClassType), aList, DataOwner);

  for liIndex := 0 to aList.Count-1 do
    if aList.Objects[liIndex] <> nil then
      AddDatabase(TComponent(aList.Objects[liIndex]));
end; {procedure, GetDatabaseNames}

{------------------------------------------------------------------------------}
{ TdaIBDACSession.SetDataOwner }

procedure TdaIBDACSession.SetDataOwner(aDataOwner: TComponent);
var
  lList: TStringList;
begin
  inherited SetDataOwner(aDataOwner);

  lList := TStringList.Create;

  GetDatabaseNames(lList);

  lList.Free;
end; {procedure, SetDataOwner}

{------------------------------------------------------------------------------}
{ TdaIBDACSession.ValidDatabaseTypes }

function TdaIBDACSession.ValidDatabaseTypes: TppDatabaseTypes;
begin
  Result := [dtInterbase];
end; {function, ValidDatabaseTypes}

{******************************************************************************
 *
 ** I N T E R B A S E   D A T A S E T
 *
{******************************************************************************}

{------------------------------------------------------------------------------}
{ TdaIBDACDataSet.Create }

constructor TdaIBDACDataSet.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);

  FQuery := nil;
end; {constructor, Create}

{------------------------------------------------------------------------------}
{ TdaIBDACDataSet.Destroy }

destructor TdaIBDACDataSet.Destroy;
begin
  FQuery.Free;

  inherited Destroy;
end; {destructor, Destroy}

{------------------------------------------------------------------------------}
{ TdaIBDACDataSet.ClassDescription }

class function TdaIBDACDataSet.ClassDescription: String;
begin
  Result := 'IBDACDataSet';
end; {class function, ClassDescription}

{------------------------------------------------------------------------------}
{ TdaIBDACDataSet.GetActive }

function TdaIBDACDataSet.GetActive: Boolean;
begin
  Result := GetQuery.Active
end; {function, GetActive}

{------------------------------------------------------------------------------}
{ TdaIBDACDataSet.SetActive }

procedure TdaIBDACDataSet.SetActive(Value: Boolean);
begin
  GetQuery.Active := Value;
end; {procedure, SetActive}

{------------------------------------------------------------------------------}
{ TdaIBDACDataSet.GetQuery }

function TdaIBDACDataSet.GetQuery: TIBCQuery;
begin
  {create IBDACDataSet, if needed}
  if (FQuery = nil) then
    FQuery := TIBCQuery.Create(Self);

  Result := FQuery;
end; {procedure, GetQuery}

{------------------------------------------------------------------------------}
{ TdaIBDACDataSet.SetDatabase}

procedure TdaIBDACDataSet.SetDatabase(aDatabase: TComponent);
begin
  inherited SetDatabase(aDatabase);

  {table cannot be active to set database property}
  if GetQuery.Active then
    FQuery.Active := False;

  FSession := (aDatabase as TIBCConnection);
  {get IBDAC Connection for name}
  FQuery.Connection := FSession;
end; {procedure, SetDatabaseName}

{------------------------------------------------------------------------------}
{ TdaIBDACDataSet.SetDataName }

procedure TdaIBDACDataSet.SetDataName(const aDataName: String);
begin
  inherited SetDataName(aDataName);

  {dataset cannot be active to set data name}
  if GetQuery.Active then
    FQuery.Active := False;

  {construct an SQL statment that returns an empty result set,
   this is used to get the field information }
  FQuery.SQL.Text := 'SELECT * FROM ' + aDataName +
                     ' WHERE ''c'' <> ''c'' ';
end; {procedure, SetDataName}

{------------------------------------------------------------------------------}
{ TdaIBDACDataSet.BuildFieldList }

procedure TdaIBDACDataSet.BuildFieldList;
var
  liIndex: Integer;
  lQueryField: TField;
  lField: TppField;
begin
  inherited BuildFieldList;


  {set table to active}
  if not(GetQuery.Active) then
    FQuery.Active := True;

  {create TppField objects for each field in the table}
  for liIndex := 0 to FQuery.FieldCount - 1 do begin
    lQueryField := FQuery.Fields[liIndex];

    lField := TppField.Create(nil);

    lField.TableName    := DataName;
    lField.FieldName    := lQueryField.FieldName;
    lField.DataType     := ppConvertFieldType(lQueryField.DataType);

    AddField(lField);
  end;
end; {function, BuildFieldList}

{------------------------------------------------------------------------------}
{ TdaIBDACDataSet.GetFieldNamesForSQL }

procedure TdaIBDACDataSet.GetFieldNamesForSQL(aList: TStrings; aSQL: TStrings);
var
  lQuery: TIBCQuery;
begin
  aList.Clear;

  {create a temporary query}
  lQuery := TIBCQuery.Create(Self);

  {set the database and SQL properties}
  lQuery.Connection := FSession;
  lQuery.SQL := aSQL;

  {get the field names}
  lQuery.GetFieldNames(aList);

  lQuery.Free;
end; {procedure, GetFieldNamesForSQL}

{------------------------------------------------------------------------------}
{ TdaIBDACDataSet.GetFieldsForSQL }

procedure TdaIBDACDataSet.GetFieldsForSQL(aList: TList; aSQL: TStrings);
var
  lQuery: TIBCQuery;
  lQueryField: TField;
  lField: TppField;
  liIndex: Integer;
begin
  aList.Clear;

  {create a temporary query}
  lQuery := TIBCQuery.Create(Self);

  {assign databae and SQL properties}
  lQuery.Connection := FSession;
  lQuery.SQL := aSQL;

  {set query to active}
  lQuery.Active := True;

  {create a TppField object for each field in the query}
  for liIndex := 0 to lQuery.FieldCount - 1 do begin
    lQueryField := lQuery.Fields[liIndex];

    lField := TppField.Create(nil);

    lField.FieldName    := lQueryField.FieldName;
    lField.DataType     := ppConvertFieldType(lQueryField.DataType);

    aList.Add(lField);
  end;

  lQuery.Free;
end; {procedure, GetFieldsForSQL}



{******************************************************************************
 *
 ** I N T E R B A S E   Q U E R Y   D A T A V I E W
 *
{******************************************************************************}

{------------------------------------------------------------------------------}
{ TdaIBDACQueryDataView.Create }

constructor TdaIBDACQueryDataView.Create(aOwner: TComponent);
begin

  inherited Create(aOwner);

  {notes: 1. must use ChildQuery, ChildDataSource, ChildPipeline etc.
          2. use Self as owner for Query, DataSource etc.
          3. do NOT assign a Name }

  FQuery := TdaChildIBDACQuery.Create(Self);

  FDataSource := TppChildDataSource.Create(Self);
  FDataSource.DataSet := FQuery;

end; {constructor, Create}

{------------------------------------------------------------------------------}
{ TdaIBDACQueryDataView.Destroy }

destructor TdaIBDACQueryDataView.Destroy;
begin
  FDataSource.Free;
  FQuery.Free;

  inherited Destroy;

end; {destructor, Destroy}

{------------------------------------------------------------------------------}
{ TdaIBDACQueryDataView.PreviewFormClass }

class function TdaIBDACQueryDataView.PreviewFormClass: TFormClass;
begin
  Result := TFormClass(GetClass('TdaPreviewDataDialog'));
end; {class function, PreviewFormClass}

{------------------------------------------------------------------------------}
{ TdaIBDACQueryDataView.SessionClass }

class function TdaIBDACQueryDataView.SessionClass: TClass;
begin
  Result := TdaIBDACSession;
end; {class function, SessionClass}

{------------------------------------------------------------------------------}
{ TdaIBDACQueryDataView.ConnectPipelinesToData }

procedure TdaIBDACQueryDataView.ConnectPipelinesToData;
begin

  if DataPipelineCount = 0 then Exit;

  {need to reconnect here}
  TppDBPipeline(DataPipelines[0]).DataSource := FDataSource;

end; {procedure, ConnectPipelinesToData}

{------------------------------------------------------------------------------}
{ TdaIBDACQueryDataView.Init }

procedure TdaIBDACQueryDataView.Init;
var
  lDataPipeline: TppChildDBPipeline;

begin

  inherited Init;

  if DataPipelineCount > 0 then Exit;

  {note: DataView's owner must own the DataPipeline }
  lDataPipeline := TppChildDBPipeline(ppComponentCreate(Self, TppChildDBPipeline));
  lDataPipeline.DataSource := FDataSource;
 
  lDataPipeline.AutoCreateFields := False;

  {add DataPipeline to the dataview }
  lDataPipeline.DataView := Self;

end; {procedure, Init}

{------------------------------------------------------------------------------}
{ TdaIBDACQueryDataView.SQLChanged }

procedure TdaIBDACQueryDataView.SQLChanged;
begin

  if FQuery.Active then
    FQuery.Close;

  FQuery.Connection := daGetIBDACConnectionForName(SQL.DatabaseName);
  FQuery.SQL := SQL.MagicSQLText;

end; {procedure, SQLChanged}


{******************************************************************************
 *
 ** P R O C E D U R E S   A N D   F U N C T I O N S
 *
{******************************************************************************}

{------------------------------------------------------------------------------}
{ daGetDefaultIBDACConnection }

function daGetDefaultIBDACConnection: TIBCConnection;
begin
  {create the default Connection, if needed}
  if (FIBDACConnection = nil) then begin
    {create default IBDAC Connection}
    FIBDACConnection := TIBCConnection.Create(nil);
    FIBDACConnection.Name := cDefaultConnection;
  end;

  Result := FIBDACConnection;
end; {function, daGetDefaultIBDACConnection}

{------------------------------------------------------------------------------}
{ daGetIBDACConnectionNames }

procedure daGetIBDACConnectionNames(aList: TStrings);
begin
end; {procedure, daGetIBDACConnectionNames}

{------------------------------------------------------------------------------}
{ daGetIBDACConnectionForName }

function daGetIBDACConnectionForName(aDatabaseName: String): TIBCConnection;
var
  liIndex: Integer;
begin
  Result := nil;

  liIndex := 0;

 {check for a database object with this name}
  while (Result = nil) and (liIndex < daGetIBDACConnectionList.Count) do
  begin
    if (AnsiCompareStr(FIBDACConnectionList[liIndex].Name, aDatabaseName) = 0) or
       (AnsiCompareStr(TIBCConnection(FIBDACConnectionList[liIndex]).Server, aDatabaseName) = 0)
    then
      Result :=  TIBCConnection(FIBDACConnectionList[liIndex]);
    Inc(liIndex);
  end;

  if (Result <> nil) then
    Exit;

  {use the default database object}
  Result := daGetDefaultIBDACConnection;

  {set DatabaseName property, if needed}
  if (Result.Server <> aDatabaseName) then begin
    if Result.Connected then
      Result.Connected := False;
    Result.Server := aDatabaseName;
  end;
end; {function, daGetIBDACConnectionForName}

{------------------------------------------------------------------------------}
{ daIBDACConnectToDatabase }

function daIBDACConnectToDatabase(aDatabaseName: String): Boolean;
var
  lConnection: TIBCConnection;
begin
  Result := False;

  lConnection := daGetIBDACConnectionForName(aDatabaseName);

  if (lConnection = nil) then
    Exit;

  if not lConnection.Connected then begin
    if (lConnection = daGetDefaultIBDACConnection) then
      lConnection.Connected := True
    else
      lConnection.Connected := True;
  end;

  Result := lConnection.Connected;
end; {function, daIBDACConnectToDatabase}


{------------------------------------------------------------------------------}
{ daGetIBDACConnectionList }

function daGetIBDACConnectionList: TppComponentList;
begin
  if (FIBDACConnectionList = nil) then
    FIBDACConnectionList := TppComponentList.Create(nil);

  Result := FIBDACConnectionList;
end; {function, daGetIBDACConnectionList}


initialization
  {register the IBDAC descendant classes}
  RegisterClasses([TdaChildIBDACQuery, TdaChildIBDACTable, TdaChildIBDACStoredProc]);

  {register DADE descendant session, dataset, dataview}
  daRegisterSession(TdaIBDACSession);
  daRegisterDataSet(TdaIBDACDataSet);
  daRegisterDataView(TdaIBDACQueryDataView);

  {initialize internal reference variables}
  FIBDACConnection     := nil;
  FIBDACConnectionList := nil;

finalization
  {free the default connection object}
  FIBDACConnection.Free;
  FIBDACConnectionList.Free;

  {unregister the IBDAC descendant classes}
  UnRegisterClasses([TdaChildIBDACQuery, TdaChildIBDACTable, TdaChildIBDACStoredProc]);

  {unregister DADE descendant the session, dataset, dataview}
  daUnRegisterSession(TdaIBDACSession);
  daUnRegisterDataSet(TdaIBDACDataSet);
  daUnRegisterDataView(TdaIBDACQueryDataView);
end.
