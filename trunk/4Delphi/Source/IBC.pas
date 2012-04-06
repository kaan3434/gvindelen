
//////////////////////////////////////////////////
//  InterBase Data Access Components
//  Copyright © 2006-2011 Devart. All right reserved.
//  InterBase DataSet
//////////////////////////////////////////////////

{$IFNDEF CLR}
{$I IbDac.inc}
unit IBC;
{$ENDIF}

interface
uses
  SysUtils, Classes, DB,
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
{$IFDEF CLR}
  System.Text, System.Runtime.InteropServices, System.Reflection,
{$ELSE}
  CLRClasses,
{$ENDIF}
{$IFDEF VER6P}
  Variants,
{$ENDIF}
  MemData, {$IFNDEF FPC}MemDS{$ELSE}MemDataSet{$ENDIF}, MemUtils,
  CRTypes, CRAccess, CRParser, DBAccess,
  IBCCall, IBCClasses, IBCArray, IBCError, IBCServices;

{$I IbDacVer.inc}



const
  ftObject = ftADT;
  ftXML = 108;
  ftIBCArray = 110;
  ftIBCDbKey = 111;

Type

  TIBCSQL = class;
  TIBCUpdateSQL = class;
  TIBCConnection = class;
  TIBCTransaction = class;
  TIBCParam = class;
  TIBCArray = class;

{TIBCConnection}
  TIBCCharLength = 0..6;
  TIBCProtocol = (TCP, NetBEUI, SPX);

  TIBCConnectionOptions = class (TDAConnectionOptions)
  private
    FProtocol: TIBCProtocol;
    FCharset: string;
    FCharLength: TIBCCharLength;
    FRole: string;
    FEnableMemos: boolean;
    FUseUnicode: boolean;

    procedure SetProtocol(const Value: TIBCProtocol);
    function GetCharset: string;
    procedure SetCharset(const Value: string);
    function GetCharLength: TIBCCharLength;
    procedure SetCharLength(const Value: TIBCCharLength);
    function GetRole: string;
    procedure SetRole(const Value: string);
    procedure SetUseUnicode(const Value: boolean);
    procedure SetEnableMemos(Value: boolean);

  protected
    procedure AssignTo(Dest: TPersistent); override;

  published
    constructor Create(Owner: TCustomDAConnection);
    property Protocol: TIBCProtocol read FProtocol write SetProtocol default TCP;
    property Charset: string read GetCharset write SetCharset;
    property CharLength: TIBCCharLength read GetCharLength write SetCharLength default 0;
    property Role: string read GetRole write SetRole;
    property UseUnicode: boolean read FUseUnicode write SetUseUnicode
      default {$IFNDEF UNICODE_BUILD}False{$ELSE}True{$ENDIF};
    property EnableMemos: boolean read FEnableMemos write SetEnableMemos default False;

    property KeepDesignConnected;
    property DisconnectedMode;
    property LocalFailover;
    property DefaultSortType default stBinary;
    property EnableBCD;
  {$IFDEF VER6P}
  {$IFNDEF FPC}
    property EnableFMTBCD;
  {$ENDIF}
  {$ENDIF}
  end;

{$IFDEF VER16P}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32)]
{$ENDIF}
  TIBCConnection = class (TCustomDAConnection)
   private
    FDatabase: string;
    FSQLDialect: Integer;
    FOptions: TIBCConnectionOptions;
    FParams: TStrings;
    FParamsChanged: boolean;
    FClientLibrary: string;

    procedure SetOptions(const Value: TIBCConnectionOptions);
    procedure SetDatabase(const Value: string);
    function GetSQLDialect: Integer;
    procedure SetSQLDialect(const Value: Integer);
    function GetDBSQLDialect: Integer;
    function GetDatabaseInfo: TGDSDatabaseInfo;
    procedure SetDefaultTransaction(Value: TIBCTransaction);
    function GetDefaultTransaction: TIBCTransaction;
    function GetTransaction(Index: Integer): TIBCTransaction;
    function GetParams: TStrings;
    procedure SetParams(Value: TStrings);
    procedure ParamsChanged(Sender: TObject);
    function GetConnectPrompt: boolean;
    procedure SetConnectPrompt(Value: boolean);
    function GetLastError: integer;
    procedure SetLastError(Value: integer);
    function GetSQL: TIBCSQL;
    function GetHandle: TISC_DB_HANDLE;
    procedure SetHandle(Value: TISC_DB_HANDLE);
    function GetHandleIsShared: boolean;
    function GetIsReadOnly: boolean;
    function GetStreamedConnected: boolean;

    function GetClientLibrary: string;
    procedure SetClientLibrary(const Value: string);
   
  protected
    FIConnection: TGDSConnection;

    procedure GetConnectProps(var Host: string; var Protocol: _TIBCProtocol; var FileName: string);
    procedure SetServer(const Value: _string); override;
    function InternalGetServer: _string; override;
    function GetSQLs: TDAList;
    procedure CreateIConnection; override;
    function GetGDSConnection: TGDSConnection;

    procedure SetIConnection(Value: TCRConnection); override;

    function GetIConnectionClass: TCRConnectionClass; override;
    function GetICommandClass: TCRCommandClass; override;
    function GetIRecordSetClass: TCRRecordSetClass; override;
    function GetIMetaDataClass: TCRMetaDataClass; override;
    function IsMultipleTransactionsSupported: boolean; override;

    function ConnectDialogClass: TConnectDialogClass; override;
    function SQLMonitorClass: TClass; override;
    function CreateOptions: TDAConnectionOptions; override;
    procedure CheckCommand; override;

  //Operations stack functionality
    function PushOperation(Operation: TConnLostCause; AllowFailOver: boolean = true): integer; override;
    function PopOperation: TConnLostCause; override;

    procedure DoConnect; override;

    function IsFirebirdConnection: boolean;
    function GetMajorServerVersion: integer;
    function GetMinorServerVersion: integer;
    procedure AssignConnectOptions(Source: TCustomDAConnection); override;
{$IFNDEF VER6P}
    procedure DefineProperties(Filer: TFiler); override;
{$ENDIF}
    procedure AssignTo(Dest: TPersistent); override;

  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;

    function ParamByName(const Name: _string): TIBCParam;

    procedure GetGeneratorNames(List: _TStrings; AllGenerators: boolean = False);

    procedure AssignConnect(Source: TIBCConnection);
    function CreateDataSet: TCustomDADataSet; override;
    function CreateSQL: TCustomDASQL; override;
    function CreateTransaction: TDATransaction; override;
    function CreateMetaData: TDAMetaData; override;

    procedure CommitRetaining;
    procedure RollbackRetaining;

    procedure CreateDatabase;
    procedure DropDatabase;

    function AddTransaction(TR: TIBCTransaction): Integer;
    function FindDefaultTransaction: TIBCTransaction;
    procedure RemoveTransaction(TR: TIBCTransaction);

  //Properties
    property Handle: TISC_DB_HANDLE read GetHandle write SetHandle;
    property HandleIsShared: boolean read GetHandleIsShared;
    property IsReadOnly: Boolean read GetIsReadOnly;

    property SQL: TIBCSQL read GetSQL;
    property DBSQLDialect: Integer read GetDBSQLDialect;
    property DatabaseInfo: TGDSDatabaseInfo read GetDatabaseInfo;

    property TransactionCount;
    property Transactions[Index: Integer]: TIBCTransaction read GetTransaction;
    property LastError: integer read GetLastError write SetLastError;
  published
    property Database: string read FDatabase write SetDatabase;
    property ConnectPrompt: boolean read GetConnectPrompt write SetConnectPrompt stored False default True; //obsolette
    property Options: TIBCConnectionOptions read FOptions write SetOptions;
    property Params: TStrings read GetParams write SetParams;
    property DefaultTransaction: TIBCTransaction read GetDefaultTransaction write SetDefaultTransaction;
    property SQLDialect: Integer read GetSQLDialect write SetSQLDialect default 3;
    property ClientLibrary: string read GetClientLibrary write SetClientLibrary;

    property PoolingOptions;
    property Pooling;
    property Username;
    property Password;
    property Server;
    property AutoCommit;
    property Connected stored IsConnectedStored;
    property ConnectDialog;
    property LoginPrompt;
    property Debug;
//Events
    property AfterConnect;
    property BeforeConnect;
    property AfterDisconnect;
    property BeforeDisconnect;
    property OnLogin;
    property OnError;
    property OnConnectionLost;
  end;

{TConnectionList}
  TConnectionList = class (TThreadList)
  private
    function GetCount: integer;
    function GetConnection(i: integer): TIBCConnection;
  public
    property Count: integer read GetCount;
    property Items[i: integer]: TIBCConnection read GetConnection; default;
  end;

{ TIBCParam }

  TIBCParam = class (TDAParam)
  private
  {$IFNDEF VER6P}
    FNumericScale: Integer;
    FPrecision: Integer;
  {$ENDIF}  

    function GetAsIbBlob: TIBCBlob;
    procedure SetAsIbBlob(Value: TIBCBlob);

    function GetAsArray: TIBCArray;
    procedure SetAsArray(Value: TIBCArray);

  protected
    function IsObjectDataType(DataType: TFieldType): boolean; overload; override;
    function IsObjectDataType: boolean; overload;

    function GetSize: integer; override;

    function GetAsString: string; override;
    procedure SetAsString(const Value: string); override;
    function GetAsVariant: variant; override;
    procedure SetAsVariant(const Value: variant); override;
    function GetIsNull: boolean; override;

    procedure CreateObject; override;

    property ParamObject;
  public
    destructor Destroy; override;

    procedure Clear; override;

    procedure SetBlobData(Buffer: IntPtr; Size: integer);

  {$IFNDEF VER6P}
    property Precision: Integer read FPrecision write FPrecision default 0;
    property NumericScale: Integer read FNumericScale write FNumericScale default 0;
  {$ENDIF}

    property AsIbBlob: TIBCBlob read GetAsIbBlob write SetAsIbBlob;
    property AsArray: TIBCArray read GetAsArray write SetAsArray;
  end;

{ TIBCParams }

  TIBCParams = class (TDAParams)
  private
    FOwner: TPersistent;

    function GetItem(Index: integer): TIBCParam;
    procedure SetItem(Index: integer; Value: TIBCParam);

  public
    constructor Create(Owner: TPersistent);

    function ParamByName(const Value: _string): TIBCParam;
    function FindParam(const Value: _string): TIBCParam;
    property Items[Index: integer]: TIBCParam read GetItem write SetItem; default;
  end;

{ TIBCDbKeyField}
  TIBCDbKeyField = class({$IFNDEF FPC}TBytesField{$ELSE}TStringField{$ENDIF})
  protected
    procedure GetText(var Text: string; DisplayText: Boolean); override;
    function GetAsString: string; override;
  public
    constructor Create(Owner: TComponent); override;
  end;

{ TIBCArrayField}
  TIBCArrayField = class(TField)
  private
    function GetAsArray: TIBCArray;
    function GetModified: boolean;
  protected
    class procedure CheckTypeSize(Value: Integer); override;
    function GetIsNull: Boolean; override;
  {$IFNDEF FPC}
    function GetSize: Integer; override;
  {$ENDIF}
    function GetDataSize: integer; override;

    procedure GetText(var Text: string; DisplayText: Boolean); override;
    procedure SetText(const Value: string); override;

    function GetAsString: string; override;
    procedure SetAsString(const Value: string); override;
    function GetAsVariant: variant; override;
    procedure SetAsVariant(const Value: Variant); override;
  public
    constructor Create(Owner: TComponent); override;
    property AsArray: TIBCArray read GetAsArray;
    property Modified: boolean read GetModified;
  end;

{ TIBCSQL }
{$IFDEF VER16P}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32)]
{$ENDIF}
  TIBCSQL = class (TCustomDASQL)
  private
    FDescribeParams: boolean;

    function GetSQLType: Integer;
    function GetSQLTypeEx: Integer;
    function GetText: _string;
    procedure SetText(const Value: _string);
    function GetConnection: TIBCConnection;
    procedure SetConnection(Value: TIBCConnection);
    function GetParams: TIBCParams;
    procedure SetParams(Value: TIBCParams);
    function GetIBCTransaction: TIBCTransaction;
    procedure SetIBCTransaction(Value: TIBCTransaction);
    function GetHandle: TISC_STMT_HANDLE;
    procedure SetDescribeParams(Value: boolean);
    function GetPlan: string;

  protected
    FICommand: TGDSCommand;

    procedure CreateICommand; override;
    procedure SetICommand(Value: TCRCommand); override;
    function CreateParamsObject: TDAParams; override;
    function GetDataTypesMap: TDataTypesMapClass; override;
    function UsedConnection: TCustomDAConnection; override;
    procedure CheckConnection; override;
    procedure ConnectChange(Sender: TObject; Connecting: boolean); override;

    function GetTransaction: TDATransaction; override;

    function IsInOutParamSupported: boolean; override;
    function NeedConvertEOLForBlob: boolean; override;
    procedure AssignParam(ParamDesc: TParamDesc; Param: TDAParam); override;
    procedure AssignParamDesc(Param: TDAParam; ParamDesc: TParamDesc); override;
    procedure AssignTo(Dest: TPersistent); override;
    procedure InternalExecute(Iters: integer); override;

    function NeedRecreateProcCall: boolean; override;

    property StoredProcIsQuery;

  public
    constructor Create(Owner: TComponent); override;

    function ExecuteNext: boolean;
    procedure BreakExec;
    function FindParam(const Value: _string): TIBCParam;
    function ParamByName(const Value: _string): TIBCParam;
    procedure CreateProcCall(const Name: _string);

    property SQLType: integer read GetSQLType;
    property SQLTypeEx: integer read GetSQLTypeEx;
    property Text: _string read GetText write SetText;
    property Handle: TISC_STMT_HANDLE read GetHandle;
    property Plan: string read GetPlan;

  published
    property Connection: TIBCConnection read GetConnection write SetConnection;
    property Transaction: TIBCTransaction read GetIBCTransaction write SetIBCTransaction stored IsTransactionStored;
    property Params: TIBCParams read GetParams write SetParams stored False;
    property DescribeParams: boolean read FDescribeParams write SetDescribeParams default False;
    property ParamCheck; // before SQL
    property SQL;
    property Macros;
    property AutoCommit default False;
    property Debug;
    property BeforeExecute;
    property AfterExecute;
  end;

{TIBCTransaction}
  TIBCTransactionErrorEvent = procedure (Sender: TObject; E: EIBCError) of object;
  TIBCTransactionAction = (taCommit, taRollback, taCommitRetaining, taRollbackRetaining);

{$IFDEF VER16P}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32)]
{$ENDIF}
  TIBCTransaction = class (TDATransaction)
  private
    FDefaultCloseAction: TIBCTransactionAction;
    FStreamedActive: boolean;
    FOnIBCError: TIBCTransactionErrorEvent;
    FParams: TStrings;

    function GetDefaultConnection: TIBCConnection;
    procedure SetDefaultConnection(const Value: TIBCConnection);
    function GetActive: boolean;
    procedure SetActive(Value: boolean);
    procedure SetParams(Value: TStrings);
    function GetHandle: TISC_TR_HANDLE;
    procedure SetHandle(Value: TISC_TR_HANDLE);
    function GetHandleIsShared: boolean;
    function GetDefaultCloseAction: TIBCTransactionAction;
    procedure SetDefaultCloseAction(Value: TIBCTransactionAction);
    function GetConnection(Index: integer): TIBCConnection;
    function GetIsolationLevel: TIBCIsolationLevel;
    procedure SetIsolationLevel(Value: TIBCIsolationLevel);
    function IsActiveStored: boolean; //in case of implicit start we shouldn't store Acive property
    procedure DoError(Sender: TObject; E: EDAError; var Fail: boolean);
  protected
    FITransaction: TGDSTransaction;

    procedure Loaded; override;
    function GetITransactionClass: TCRTransactionClass; override;
    procedure SetITransaction(Value: TCRTransaction); override;
    function UsedConnection: TCustomDAConnection; override;
    function SQLMonitorClass: TClass; override;
    procedure InternalHandleException;

    procedure DoSavepoint(const Name: _string); override;
    procedure DoReleaseSavepoint(const Name: _string); override;
    procedure DoRollbackToSavepoint(const Name: _string); override;

    // CLR cross-assembly
    procedure CloseTransaction(Force: boolean = False); override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function AddConnection(Connection: TIBCConnection): integer;
    function FindDefaultConnection: TIBCConnection;
    procedure RemoveConnection(Connection: TIBCConnection);

    procedure Commit; override;
    procedure Rollback; override;

    procedure CommitRetaining;
    procedure RollbackRetaining;

 { Savepoit control }
    procedure ReleaseSavepoint(const Name: string);
    procedure RollbackSavepoint(const Name: string);
    procedure StartSavepoint(const Name: string);

    property Handle: TISC_TR_HANDLE read GetHandle write SetHandle;
    property HandleIsShared: boolean read GetHandleIsShared;
    property Connections[Index: integer]: TIBCConnection read GetConnection;
    property ConnectionsCount;
  published
    property DefaultConnection: TIBCConnection read GetDefaultConnection write SetDefaultConnection stored IsInternalTrStored;
    property Params: TStrings read FParams write SetParams;
    property DefaultCloseAction: TIBCTransactionAction read GetDefaultCloseAction write SetDefaultCloseAction default taRollback;
    property IsolationLevel: TIBCIsolationLevel read GetIsolationLevel write SetIsolationLevel default iblReadCommitted;
    property Active: Boolean read GetActive write SetActive stored IsActiveStored default False;
    property OnError: TIBCTransactionErrorEvent read FOnIBCError write FOnIBCError;

    property OnStart;
    property OnCommit;
    property OnRollback;
  end;

{TCustomIBCDataSet}
  TIBCDataSetOptions = class (TDADataSetOptions)
  private
    FFieldsAsString: boolean;
    FAutoClose: boolean;
    FDeferredBlobRead: boolean;
    FCacheBlobs: boolean;
    FStreamedBlobs: boolean;
    FComplexArrayFields: boolean;
    FDeferredArrayRead: boolean;
    FCacheArrays: boolean;
    FBooleanDomainFields: boolean;
    FDescribeParams: boolean;
    FSetDomainNames: boolean;

    procedure SetAutoClose(const Value: boolean);
    procedure SetFieldsAsString(const Value: boolean);
    procedure SetDeferredBlobRead(Value: boolean);
    procedure SetCacheBlobs(Value: boolean);
    procedure SetStreamedBlobs(Value: boolean);
    procedure SetComplexArrayFields(Value: boolean);
    procedure SetDeferredArrayRead(Value: boolean);
    procedure SetCacheArrays(Value: boolean);
    procedure SetBooleanDomainFields(Value: boolean);
    procedure SetDescribeParams(Value: boolean);
    procedure SetSetDomainNames(Value: boolean);
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create(Owner: TCustomDADataSet);
  published
    property AutoClose: boolean read FAutoClose write SetAutoClose default False;
    property FieldsAsString: boolean read FFieldsAsString write SetFieldsAsString default False;
    property DeferredBlobRead: boolean read FDeferredBlobRead write SetDeferredBlobRead default False;
    property CacheBlobs: boolean read FCacheBlobs write SetCacheBlobs default True;
    property StreamedBlobs: boolean read FStreamedBlobs write SetStreamedBlobs default False;
    property ComplexArrayFields: boolean read FComplexArrayFields write SetComplexArrayFields default True;
    property DeferredArrayRead: boolean read FDeferredArrayRead write SetDeferredArrayRead default True;
    property CacheArrays: boolean read FCacheArrays write SetCacheArrays default True;
    property BooleanDomainFields: boolean read FBooleanDomainFields write SetBooleanDomainFields default False;
    property DescribeParams: boolean read FDescribeParams write SetDescribeParams default False;
    property SetDomainNames: boolean read FSetDomainNames write SetSetDomainNames default False;

    property SetFieldsReadOnly;
    property RequiredFields;
    property FieldsOrigin;
    property DefaultValues;
    property StrictUpdate;
    property NumberRange;
    property QueryRecCount;
    property AutoPrepare;
    property TrimFixedChar;
    property SetEmptyStrToNull;
    property LongStrings;
    property RemoveOnRefresh;
    property FlatBuffers;
    property DetailDelay;
    property LocalMasterDetail;
    property CacheCalcFields;
    property FullRefresh;
    property QuoteNames;
    property ReturnParams;
  {$IFDEF HAVE_COMPRESS}
    property CompressBlobMode;
  {$ENDIF}
    property UpdateAllFields;
    property PrepareUpdateSQL default True;
  end;

  TLockMode = (lmNone, lmLockImmediate, lmLockDelayed);
  TGeneratorMode = (gmInsert, gmPost);

  TIBCSQLGenerator = class (TCustomIBCSQLGenerator)
  protected
    function FieldModified(FieldDesc: TCRFieldDesc): boolean; override;
  end;

  TIBCDataSetUpdater = class (TCustomIBCDataSetUpdater)
  protected
    procedure SetUpdateQueryOptions(const StatementType: TStatementType); override;
  end;

  TIBCDataSetService = class (TCustomIBCDataSetService)
  protected
    procedure CreateSQLGenerator; override;
    procedure CreateDataSetUpdater; override;
    procedure SetFieldOrigin(Field: TField; FieldDesc: TCRFieldDesc); override;
  end;

  TCustomIBCDataSet = class (TCustomDADataSet)
  private
    FFetchCanceled: boolean;
    FKeyGenerator: _string;
    FGeneratorMode: TGeneratorMode;
    FGeneratorStep: integer;

    function GetRowsFetched: integer;
    function GetRowsInserted: integer;
    function GetRowsUpdated: integer;
    function GetRowsDeleted: integer;
    function GetSQLType: integer;
    function GetSQLTypeEx: integer;
    function GetCursor: string;
    function GetConnection: TIBCConnection;
    procedure SetConnection(const Value: TIBCConnection);
    procedure SetIBCTransaction(const Value: TIBCTransaction);
    function GetIBCTransaction: TIBCTransaction;
    function GetUpdateTransaction: TIBCTransaction;
    procedure SetUpdateTransaction(const Value: TIBCTransaction);
    function GetOptions: TIBCDataSetOptions;
    procedure SetOptions(const Value: TIBCDataSetOptions);
    function GetParams: TIBCParams;
    procedure SetParams(const Value: TIBCParams);
    function GetLockMode: TLockMode;
    procedure SetLockMode(Value: TLockMode);
    procedure SetKeyGenerator(const Value: _string);
    procedure SetGeneratorMode(Value: TGeneratorMode);
    procedure SetGeneratorStep(Value: integer);
    function GetHandle: TISC_STMT_HANDLE;
    function GetPlan: string;
    function GetUpdateObject: TIBCUpdateSQL;
    procedure SetUpdateObject(Value: TIBCUpdateSQL);
    
  {$IFNDEF FPC}
  protected
  { IProviderSupport }
    function PSGetDefaultOrder: TIndexDef; override;
  {$ENDIF}

  protected
    FIRecordSet: TGDSRecordSet;
    FICommand: TGDSCommand;

    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure CheckInactive; override;
    procedure CreateIRecordSet; override;
    procedure SetIRecordSet(Value: TData); override;
    procedure CreateCommand; override;
    function CreateOptions: TDADataSetOptions; override;
    function GetDataSetServiceClass: TDataSetServiceClass; override;
    procedure SetDataSetService(Value: TDataSetService); override;

    function UsedConnection: TCustomDAConnection; override;
    procedure CheckConnection; override;
    procedure ConnectChange(Sender: TObject; Connecting: boolean); override;

    function GetTransaction: TDATransaction; override;
    procedure SetTransaction(Value: TDATransaction); override;

  { Open/Close }
    procedure InternalExecute; override;
    procedure InternalOpen; override;
    procedure CheckFieldCompatibility(Field: TField; FieldDef: TFieldDef);override;
    procedure DoAfterScroll; override;
  { Fields }
    function GetFieldType(DataType: word): TFieldType; override;
    function GetFieldType(FieldDesc: TFieldDesc): TFieldType; override;
    function GetFieldClass(FieldType: TFieldType): TFieldClass; override;
  {$IFNDEF FPC}
    function GetFieldFullName(Field: TField): string; override;
  {$ENDIF}
    function GetFielDefSize(FieldType: TFieldType; FieldDesc: TFieldDesc): integer; override;
    function GetObjectFieldDefName(Parent: TFieldDef; Index: integer; ObjType: TObjectType): _string; override;

    procedure AssignFieldValue(Param: TDAParam; Field: TField; Old: boolean); override;
    procedure DoAfterExecute(Result: boolean); override;
    procedure AssignTo(Dest: TPersistent); override;

  { Additional data types }
    function GetArray(FieldDesc: TFieldDesc): TIBCArray; overload;
  { SQL modify }
    function SQLAddWhere(SQLText, Condition: _string): _string; override;
    function SQLDeleteWhere(SQLText: _string): _string; override;
    function SQLSetOrderBy(SQLText: _string; Fields: _string): _string; override;
    function SQLGetOrderBy(SQLText: _string): _string; override;
  { DeXter compatibility }
    procedure SetModified(Value: Boolean);
    function GetActiveRecBuf(var RecBuf: TRecordBuffer): boolean;
    function GetData: TData;
    function UnQuoteValue(Value: _string): _string;

    //property IdentityField;
  public
    constructor Create(Owner: TComponent); override;

  { Open/Close }
    function Fetched: boolean; override;
    procedure UnPrepare; override;
  { Edit }
    function QueryKeyFields(TableName: _string; List: _TStrings): _string;
    procedure CreateProcCall(const Name: _string);
    function FindParam(const Value: _string): TIBCParam;
    function ParamByName(const Value: _string): TIBCParam;
  { Additional data types }
    function GetBlob(const FieldName: _string): TIBCBlob;
    function GetArray(const FieldName: _string): TIBCArray; overload;

    property AutoCommit;
    property FetchAll;
    property KeyFields;
    property DMLRefresh;

    property Connection: TIBCConnection read GetConnection write SetConnection;
    property Params: TIBCParams read GetParams write SetParams stored False ;
    property RowsFetched: integer read GetRowsFetched;
    property RowsInserted: integer read GetRowsInserted;
    property RowsUpdated: integer read GetRowsUpdated;
    property RowsDeleted: integer read GetRowsDeleted;
    property IsQuery: boolean  read GetIsQuery;
    property SQLType: integer read GetSQLType;
    property SQLTypeEx: integer read GetSQLTypeEx;
    property Cursor: string read GetCursor;
    property LockMode: TLockMode read GetLockMode write SetLockMode default lmNone;
    property Options: TIBCDataSetOptions read GetOptions write SetOptions;
  //GeneratorField
    property KeyGenerator: _string read FKeyGenerator write SetKeyGenerator;
    property GeneratorMode: TGeneratorMode read FGeneratorMode write SetGeneratorMode default gmPost;
    property GeneratorStep: integer read FGeneratorStep write SetGeneratorStep default 1;
    property Transaction: TIBCTransaction read GetIBCTransaction write SetIBCTransaction stored IsTransactionStored;
    property UpdateTransaction: TIBCTransaction read GetUpdateTransaction write SetUpdateTransaction;
    property Plan: string read GetPlan;
    property Handle: TISC_STMT_HANDLE read GetHandle;
    property UpdateObject: TIBCUpdateSQL read GetUpdateObject write SetUpdateObject;
  end;

  TCustomIBCQuery = class (TCustomIBCDataSet)
  protected
  { Generators }
    procedure InternalOpen; override;
    procedure InternalClose; override;

  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;
    procedure ExecSQL;  // for BDE compatibility
  end;

{$IFDEF VER16P}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32)]
{$ENDIF}
  TIBCStoredProc = class (TCustomIBCQuery)
  private
    FStoredProcName: _string;

    procedure SetStoredProcName(const Value: _string);

  {$IFNDEF FPC}
  protected
  { IProviderSupport }
    procedure PSSetCommandText(const CommandText: string); override;
  {$ENDIF}

  protected
    procedure DoBeforeInsert; override;
    procedure DoBeforeDelete; override;
    procedure DoBeforeEdit; override;
    procedure DoBeforeExecute; override;

    function SQLAutoGenerated: boolean; override;
    procedure BeforeOpenCursor(InfoQuery: boolean); override;

    procedure AssignTo(Dest: TPersistent); override;
  public
    // must be overriden to prevent error in C++Builder CodeGuard
    constructor Create(Owner: TComponent); override;

    procedure Prepare; override;
    procedure PrepareSQL(IsQuery: boolean = False);
    procedure ExecProc;
  published
    property StoredProcName: _string read FStoredProcName write SetStoredProcName;
    property SQLInsert;
    property SQLDelete;
    property SQLUpdate;
    property SQLLock;
    property SQLRefresh;
    property LocalUpdate;
    property Connection;
    property Transaction;
    property UpdateTransaction;
    property ParamCheck stored False;// before SQL
    property SQL;
    property Debug;
    property Params;
    property FetchRows;
    property FetchAll;
    property ReadOnly;
    property UniDirectional;
    property CachedUpdates;
    property AutoCommit;
    property LockMode default lmNone;
    property RefreshOptions;
    property Options;
    property LocalConstraints;
    property BeforeExecute;
    property AfterExecute;
    property BeforeUpdateExecute;
    property AfterUpdateExecute;
    property OnUpdateError;
    property OnUpdateRecord;
    property UpdateObject;
    property Active;
    property AutoCalcFields;
    property Filtered;
    property Filter;
    property FilterOptions;
    property IndexFieldNames;
  {$IFNDEF FPC}
    property ObjectView default False;
  {$ENDIF}
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
    property AfterRefresh;
    property BeforeRefresh;
  end;

{$IFDEF VER16P}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32)]
{$ENDIF}
  TIBCQuery = class (TCustomIBCQuery)
  published
    property UpdatingTable;
    property KeyFields;
    property KeyGenerator;
    property GeneratorMode;
    property GeneratorStep;
    property DMLRefresh;    

    property SQLInsert;
    property SQLDelete;
    property SQLUpdate;
    property SQLRefresh;
    property SQLLock;
    property Connection;
    property Transaction;
    property UpdateTransaction;
    property SQL;
    property MasterFields;
    property DetailFields;
    property MasterSource;
    property Debug;
    property Macros;
    property Params;
    property FetchRows;
    property FetchAll;
    property ReadOnly;
    property UniDirectional;
    property CachedUpdates;
    property AutoCommit;
    property FilterSQL;
    property LockMode default lmNone;
    property RefreshOptions;
    property Options;
    property LocalConstraints;
  {$IFNDEF FPC}
    property ObjectView default False;
  {$ENDIF}
    property BeforeExecute;
    property AfterExecute;
    property BeforeUpdateExecute;
    property AfterUpdateExecute;
    property OnUpdateError;
    property OnUpdateRecord;
    property UpdateObject;
    property Active;
    property AutoCalcFields;
    property Filtered;
    property Filter;
    property FilterOptions;
    property IndexFieldNames;
    property BeforeOpen;
    property AfterOpen;
    property BeforeFetch;
    property AfterFetch;
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
    property AfterRefresh;
    property BeforeRefresh;
  end;

{ TCustomIBCTable }

  TCustomIBCTable = class (TCustomIBCQuery)
  private
    FTableName: _string;
    FOrderFields:_string;
    
  {$IFNDEF FPC}
  protected
  { IProviderSupport }
    function PSGetTableName: string; override;
    procedure PSSetParams(AParams: DB.TParams); override;
    procedure PSSetCommandText(const CommandText: string); override;
  {$ENDIF}
  
  protected
  { Open/Close }
    procedure OpenCursor(InfoQuery: boolean); override;
    procedure AssignTo(Dest: TPersistent); override;
//    procedure SetKeyFields(Value: _string); override;
    procedure SetReadOnly(Value: boolean); override;
    procedure SetTableName(const Value: _string);
    procedure SetOrderFields(const Value: _string);
    function GetExists: boolean;
    function SQLAutoGenerated: boolean; override;

  { SQL Modifications }
    procedure CheckSQL; override;
    function GetFinalSQL: _string; override;

  public

    procedure PrepareSQL;
    procedure Prepare; override;
    procedure Execute; override;
    procedure EmptyTable;

    //InterBase specific
    procedure DeleteTable;

    property Exists: Boolean read GetExists;
    property TableName: _string read FTableName write SetTableName;
    property OrderFields: _string read FOrderFields write SetOrderFields;
  end;

{ TIBCTable }

{$IFDEF VER16P}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32)]
{$ENDIF}
  TIBCTable = class (TCustomIBCTable)
  published
    property TableName;
    property OrderFields;
    property MasterFields;
    property DetailFields;
    property MasterSource;
    property ReadOnly;

    property KeyFields;
    property KeyGenerator;
    property GeneratorMode;
    property GeneratorStep;
    property DMLRefresh;
//    property RefreshFields;

    property Connection;
    property Transaction;
    property UpdateTransaction;
    property FilterSQL;

    property Debug;
    property FetchRows;
    property FetchAll;
    property UniDirectional;
    property CachedUpdates;
    property AutoCommit;
    property LockMode default lmNone;
    property RefreshOptions;
    property Options;
    property LocalConstraints;
    property OnUpdateError;
    property OnUpdateRecord;

    property UpdateObject;

    property Active;
    property AutoCalcFields;
    property Filtered;
    property Filter;
    property FilterOptions;
    property IndexFieldNames;
  {$IFNDEF FPC}
    property ObjectView default False;
  {$ENDIF}

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
    property AfterRefresh;
    property BeforeRefresh;
  end;

{ TIBCUpdateSQL }

{$IFDEF VER16P}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32)]
{$ENDIF}
  TIBCUpdateSQL = class (TCustomDAUpdateSQL)
  protected
    function DataSetClass: TCustomDADataSetClass; override;
    function SQLClass: TCustomDASQLClass; override;
  end;

{ TIBCMetaData }

{$IFDEF VER16P}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32)]
{$ENDIF}
  TIBCMetaData = class (TDAMetaData)
  private
    function GetConnection: TIBCConnection;
    procedure SetConnection(Value: TIBCConnection);
    function GetIBCTransaction: TIBCTransaction;
    procedure SetIBCTransaction(Value: TIBCTransaction);

  protected
    function GetTransaction: TDATransaction; override;
    procedure SetTransaction(Value: TDATransaction); override;

  published
    property Active;
    property Filtered;
    property Filter;
    property FilterOptions;
    property IndexFieldNames;

    property BeforeOpen;
    property AfterOpen;
    property BeforeClose;
    property AfterClose;
    property BeforeScroll;
    property AfterScroll;
    property OnFilterRecord;

    property MetaDataKind;
    property Restrictions;

    property Connection: TIBCConnection read GetConnection write SetConnection;
    property Transaction: TIBCTransaction read GetIBCTransaction write SetIBCTransaction stored IsTransactionStored;
  end;

{ TIBCDataSource }

{$IFDEF VER16P}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32)]
{$ENDIF}
  TIBCDataSource = class (TCRDataSource)
  end;

{ TIBCDataTypesMap }

  TIBCDataTypesMap = class(TCustomIBCDataTypesMap)
  public
    class function GetFieldType(DataType: Word): TFieldType; override;
    class function GetDataType(FieldType: TFieldType): integer; override;
  end;

  TIBCArray = class(TCustomIBCArray)
  private
    function GetItemType: TFieldType;
    procedure SetItemType(Value: TFieldType);

  public
    constructor Create(DbHandle: TISC_DB_HANDLE; TrHandle: TISC_TR_HANDLE; Field: TField); overload;
    constructor Create(Connection: TGDSConnection; Transaction: TGDSTransaction; Field: TField); overload;

    property ItemType: TFieldType read GetItemType write SetItemType;
  end;

{ TIBCUtils}

  TIBCUtils = class
  public
  end;

  function DefaultConnection: TIBCConnection;

{ SQL modify}

{  function SetWhere(SQL: string; Condition: string): string;
  function AddWhere(SQL: string; Condition: string): string;
  function DeleteWhere(SQL: string): string;
  function SetOrderBy(SQL: string; Fields: string): string;
  function GetOrderBy(SQL: string): string;
  function SetGroupBy(SQL: string; Fields: string): string;

  function SetFieldList(SQL: string; Fields: string): string;
  function SetTableList(SQL: string; Tables: string): string;
  function GetTableList(SQL: string): string;
  function GetTablesInfo(SQL: string; var TablesInfo: TTablesInfo): integer;
}

  function IsLargeDataTypeUsed(const Field: TField): boolean;

var
  Connections: TConnectionList;
  DefConnection: TIBCConnection;
  UseDefConnection: boolean;
  DefConnectDialogClassProc: function: TClass = nil;

  UnicodeMemoParameters: boolean = False;

implementation

uses
{$IFNDEF FPC}
  DBCommon,
{$ENDIF}
  Math, CRFunctions, DAConsts, IBCConsts, IBCSQLMonitor, IBCParser,
  CRConnectionPool, IBCConnectionPool;

function IsLargeDataTypeUsed(const Field: TField): boolean;
begin
  Result :=
    (Field is TBlobField) or (Field is TMemoField);
end;

procedure DisconnectConnections;
var
  i: integer;
  List: TList;
begin
  if Connections <> nil then begin
    List := Connections.LockList;
    try
      for i := 0 to List.Count - 1 do
        try
          TIBCConnection(List[i]).Disconnect
        except
        end;
    finally
      Connections.UnlockList;
    end;
  end;

  try
    TIBCConnectionPoolManager.Clear;
  except
  end;
end;

{ TIBCDataTypesMap }

class function TIBCDataTypesMap.GetFieldType(DataType: word): TFieldType;
begin
  case DataType of
    dtArray:
      Result := TFieldType(ftIBCArray);
  else
    Result := inherited GetFieldType(DataType);
  end;
end;

class function TIBCDataTypesMap.GetDataType(FieldType: TFieldType): integer;
begin
  if Integer(FieldType) = ftIBCArray then
    Result := dtArray
  else
  if Integer(FieldType) = ftIBCDbKey then
  {$IFNDEF FPC}
    Result := dtBytes
  {$ELSE}
    Result := dtString
  {$ENDIF}
  else
    Result := inherited GetDataType(FieldType);
end;

{ TIBCConnectionOptions }

procedure TIBCConnectionOptions.AssignTo(Dest: TPersistent);
begin
  inherited;

  if Dest is TIBCConnectionOptions then begin
    TIBCConnectionOptions(Dest).Protocol := Protocol;
    TIBCConnectionOptions(Dest).Charset := Charset;
    TIBCConnectionOptions(Dest).CharLength := CharLength;
    TIBCConnectionOptions(Dest).Role := Role;
    TIBCConnectionOptions(Dest).UseUnicode := UseUnicode;
  end;
end;

constructor TIBCConnectionOptions.Create(Owner: TCustomDAConnection);
begin
  inherited Create(Owner);

  DefaultSortType := stBinary;
  FProtocol := TCP;
{$IFDEF UNICODE_BUILD}
  FUseUnicode := True;
{$ENDIF}
end;

procedure TIBCConnectionOptions.SetProtocol(const Value: TIBCProtocol);
var
  NamePos: integer;
  Host, FileName: string;
  Protocol: _TIBCProtocol;
begin
  if FProtocol <> Value then begin
    FOwner.Disconnect;
    FProtocol := Value;

    //Sync Database
    NamePos := GetDBNamePos(TIBCConnection(FOwner).Database);
    if NamePos > 0 then begin
      ParseDatabaseName(TIBCConnection(FOwner).Database, Host, Protocol, FileName);
      TIBCConnection(FOwner).FDatabase := GetFullDatabaseName(Host, _TIBCProtocol(FProtocol), FileName);
    end;

    if TIBCConnection(FOwner).FIConnection <> nil then
      TIBCConnection(FOwner).FIConnection.SetProp(prProtocol, Variant(FProtocol));
  end;
end;

function TIBCConnectionOptions.GetCharset: string;
var
  Val: Variant;
begin
  if TIBCConnection(FOwner).FIConnection <> nil then begin
    TIBCConnection(FOwner).FIConnection.GetProp(prCharset, Val);
    Result := Val;
  end
  else
    Result := FCharset;
end;

procedure TIBCConnectionOptions.SetCharset(const Value: string);
begin
  if FCharset <> Value then begin
    TIBCConnection(FOwner).Disconnect;
    FCharset := Value;
  end;
  if TIBCConnection(FOwner).FIConnection <> nil then
    TIBCConnection(FOwner).FIConnection.SetProp(prCharset, Value);
end;

function TIBCConnectionOptions.GetCharLength: TIBCCharLength;
var
  Val: Variant;
begin
  if TIBCConnection(FOwner).FIConnection <> nil then begin
    TIBCConnection(FOwner).FIConnection.GetProp(prCharLength, Val);
    Result := TIBCCharLength(Integer(Val));
  end
  else
    Result := FCharLength;
end;

procedure TIBCConnectionOptions.SetCharLength(const Value: TIBCCharLength);
begin
  if FCharLength <> Value then begin
    TIBCConnection(FOwner).Disconnect;
    FCharLength := Value;
  end;
  if TIBCConnection(FOwner).FIConnection <> nil then
    TIBCConnection(FOwner).FIConnection.SetProp(prCharLength, Byte(Value));
end;

function TIBCConnectionOptions.GetRole: string;
var
  Val: Variant;
begin
 if TIBCConnection(FOwner).FIConnection <> nil then begin
   TIBCConnection(FOwner).FIConnection.GetProp(prRole, Val);
   Result := Val;
 end
 else
   Result := FRole;
end;

procedure TIBCConnectionOptions.SetRole(const Value: string);
begin
  FRole := Value;
  if TIBCConnection(FOwner).FIConnection <> nil then
    TIBCConnection(FOwner).FIConnection.SetProp(prRole, Value);
end;

procedure TIBCConnectionOptions.SetUseUnicode(const Value: boolean);
begin
  if FUseUnicode <> Value then begin
    TIBCConnection(FOwner).Disconnect;
    FUseUnicode := Value;
  end;
  if TIBCConnection(FOwner).FIConnection <> nil then
    TIBCConnection(FOwner).FIConnection.SetProp(prUseUnicode, Value);
end;

procedure TIBCConnectionOptions.SetEnableMemos(Value: boolean);
begin
  FEnableMemos := Value;
  if TIBCConnection(FOwner).FIConnection <> nil then
    TIBCConnection(FOwner).FIConnection.SetProp(prEnableMemos, Value);
end;

{ TIBCConnection }

constructor TIBCConnection.Create(Owner: TComponent);
var
  List: TList;
begin
  inherited Create(Owner);

  FOptions := inherited Options as TIBCConnectionOptions;
  FSQLDialect := 3;

  FParams := TStringList.Create;
  TStringList(FParams).OnChange := ParamsChanged;

  List := {$IFDEF CLR}Devart.IbDac.{$ENDIF}IBC.Connections.LockList;
  try
    if DefConnection = nil then
      DefConnection := Self;

    List.Add(Self);
  finally
    {$IFDEF CLR}Devart.IbDac.{$ENDIF}IBC.Connections.UnlockList;
  end;
end;

destructor TIBCConnection.Destroy;
var
  List: TList;
begin
  try
    FParams.Free;

  finally
    inherited;

    if {$IFDEF CLR}Devart.IbDac.{$ENDIF}IBC.Connections <> nil then begin // to aviod AV on DLL finalization
      List := {$IFDEF CLR}Devart.IbDac.{$ENDIF}IBC.Connections.LockList;
      try
        List.Remove(Self);
        if DefConnection = Self then
          if List.Count > 0 then
            DefConnection := TIBCConnection(List[0])
          else begin
            DefConnection := nil;
          end;
      finally
        {$IFDEF CLR}Devart.IbDac.{$ENDIF}IBC.Connections.UnlockList;
      end;
    end
    else
      DefConnection := nil;
  end;
end;

function TIBCConnection.GetSQLs: TDAList;
begin
  Result := FSQLs;
end;

function TIBCConnection.GetStreamedConnected: boolean;
begin
  Result := FStreamedConnected;
end;

procedure TIBCConnection.CreateIConnection;
begin
  if FIConnection <> nil then begin
    if FParamsChanged then begin
      FIConnection.SetParams(FParams);
      FParamsChanged := False;
    end;
  end
  else
    SetIConnection(GetGDSConnection);
end;

procedure TIBCConnection.GetConnectProps(var Host: string; var Protocol: _TIBCProtocol;
  var FileName: string);
begin
  if GetDBNamePos(FDatabase) > 0 then
    ParseDatabaseName(FDatabase, Host, Protocol, FileName)
  else begin
    Host := Server;
    Protocol := _TIBCProtocol(Options.Protocol);
    FileName := FDatabase;
  end;
end;

function TIBCConnection.InternalGetServer: _string;
var
  Host, FileName: string;
  Protocol: _TIBCProtocol;
begin
  GetConnectProps(Host, Protocol, FileName);
  Result := Host;
end;

function TIBCConnection.GetGDSConnection: TGDSConnection;
var
  ConnectionParameters: TIBCConnectionParameters;
  AHost, AFileName: string;
  AProtocol: _TIBCProtocol;
begin
  GetConnectProps(AHost, AProtocol, AFileName);
  if Pooling then begin
    ConnectionParameters := TIBCConnectionParameters.Create;
    try
      ConnectionParameters.MinPoolSize := PoolingOptions.MinPoolSize;
      ConnectionParameters.MaxPoolSize := PoolingOptions.MaxPoolSize;
      ConnectionParameters.ConnectionLifeTime := PoolingOptions.ConnectionLifetime;
      ConnectionParameters.Validate := PoolingOptions.Validate;
      ConnectionParameters.Username := Username;
      ConnectionParameters.Password := Password;
      ConnectionParameters.DBParams.Assign(FParams);
      FParamsChanged := False;
      ConnectionParameters.Charset := Options.Charset;
      ConnectionParameters.SQLDialect := SQLDialect;
      ConnectionParameters.UseUnicode := Options.UseUnicode;
      ConnectionParameters.Role := Options.Role;
      ConnectionParameters.Server := AHost;
      ConnectionParameters.Protocol := AProtocol;
      ConnectionParameters.Database := AFileName;
      ConnectionParameters.OnError := DoError;
      Result := TGDSConnection(TIBCConnectionPoolManager.GetConnection(ConnectionParameters,
        TIBCSQLMonitor));
    finally
      ConnectionParameters.Free;
    end;
  end
  else begin
    Result := TGDSConnection.Create;
    if FParamsChanged then begin
      Result.SetParams(FParams);
      FParamsChanged := False;
    end;
    Result.SetProp(prProtocol, Variant(AProtocol));
    Result.SetProp(prDatabase, AFileName);
    Result.SetProp(prCharset, Options.FCharset);
    Result.SetProp(prCharLength, Byte(Options.FCharLength));
    Result.SetProp(prUseUnicode, Options.FUseUnicode);
    Result.SetProp(prClientLibrary, FClientLibrary);
  end;
  Result.SetProp(prRole, Options.FRole);
  Result.SetProp(prAutoCommit, AutoCommit);
  Result.SetProp(prDisconnectedMode, Options.DisconnectedMode);
  Result.SetProp(prEnableBCD, Options.EnableBCD);
{$IFDEF VER6P}
{$IFNDEF FPC}
  Result.SetProp(prEnableFMTBCD, Options.EnableFMTBCD);
{$ENDIF}
{$ENDIF}
  Result.SetProp(prEnableMemos, Options.FEnableMemos);
  Result.SetProp(prDefaultSortType, Variant(Options.DefaultSortType));
end;

function TIBCConnection.GetIConnectionClass: TCRConnectionClass;
begin
  Result := TGDSConnection;
end;

function TIBCConnection.GetICommandClass: TCRCommandClass;
begin
  Result := TGDSCommand;
end;

function TIBCConnection.GetIRecordSetClass: TCRRecordSetClass;
begin
  Result := TGDSRecordSet;
end;

function TIBCConnection.GetIMetaDataClass: TCRMetaDataClass;
begin
  Result := TGDSMetaData;
end;

function TIBCConnection.IsMultipleTransactionsSupported: boolean;
begin
  Result := True;
end;

procedure TIBCConnection.SetIConnection(Value: TCRConnection);
begin
  inherited;

  FIConnection := Value as TGDSConnection;
end;

function TIBCConnection.CreateDataSet: TCustomDADataSet;
begin
  Result := TCustomIBCDataSet.Create(nil);
  Result.Connection := Self;
  TCustomIBCDataSet(Result).Transaction := DefaultTransaction;
end;

function TIBCConnection.CreateSQL: TCustomDASQL;
begin
  Result := TIBCSQL.Create(nil);
  Result.Connection := Self;
  TIBCSQL(Result).Transaction := DefaultTransaction;
end;

function TIBCConnection.CreateTransaction: TDATransaction;
begin
  Result := TIBCTransaction.Create(nil);
  Result.DefaultConnection := Self;
end;

function TIBCConnection.CreateMetaData: TDAMetaData;
begin
  Result := TIBCMetaData.Create(nil);
  Result.Connection := Self;
  TIBCMetaData(Result).Transaction := DefaultTransaction;
end;

function TIBCConnection.SQLMonitorClass: TClass;
begin
  Result := TIBCSQLMonitor;
end;

function TIBCConnection.ConnectDialogClass: TConnectDialogClass;
begin
  if Assigned(DefConnectDialogClassProc) then
    Result := TConnectDialogClass(DefConnectDialogClassProc)
  else
    Result := nil;
end;

function TIBCConnection.CreateOptions: TDAConnectionOptions;
begin
  Result := TIBCConnectionOptions.Create(Self);
end;

procedure TIBCConnection.CheckCommand;
begin
  if FCommand = nil then begin
    inherited CheckCommand;

    TIBCSQL(FCommand).AutoCommit := True;
  end;
end;

function TIBCConnection.PushOperation(Operation: TConnLostCause; AllowFailOver: boolean = true): integer;
begin
  Result := inherited PushOperation(Operation, AllowFailOver); //CLR crossassembly issue
end;

function TIBCConnection.PopOperation: TConnLostCause;
begin
  Result := inherited PopOperation;  //CLR crossassembly issue
end;

procedure TIBCConnection.DoConnect;
var
  Val: Variant;
begin
  if FDatabase = '' then
    DatabaseError(SDatabaseNameMissing);
  CreateIConnection;

  FIConnection.SetProp(prSQLDialect, FSQLDialect);

  inherited;

  if Options.DisconnectedMode then begin
    //read and cache general Database parameters
    //this is necessary in disconnect mode
    FIConnection.GetProp(prReadOnly, Val);
    FIConnection.IsFBServer;
    FIConnection.GetMajorServerVersion;
    FIConnection.GetMinorServerVersion;
  end;
end;

procedure TIBCConnection.AssignConnectOptions(Source: TCustomDAConnection);
begin
  inherited;

  Database := TIBCConnection(Source).Database;
end;

function TIBCConnection.ParamByName(const Name: _string): TIBCParam;
begin
  Result := SQL.ParamByName(Name);
end;

procedure TIBCConnection.GetGeneratorNames(List: _TStrings; AllGenerators: boolean = False);
var
  MetaData: TDAMetaData;
  Name: _string;
begin
  MetaData := CreateMetaData;
  try
    MetaData.MetaDataKind := 'Generators';
    if not AllGenerators then
      MetaData.Restrictions.Add('SCOPE=LOCAL');
    MetaData.Open;
    List.Clear;
    while not MetaData.Eof do begin
      Name := _VarToStr(MetaData.FieldByName('GENERATOR_NAME').Value);
      List.Add(Name);
      MetaData.Next;
    end;
  finally
    MetaData.Free;
  end;
end;

procedure TIBCConnection.CommitRetaining;
begin
  DoCommitRetaining;
end;

procedure TIBCConnection.RollbackRetaining;
begin
  DoRollbackRetaining;
end;

procedure TIBCConnection.SetOptions(const Value: TIBCConnectionOptions);
begin
  FOptions.Assign(Value);
end;

procedure TIBCConnection.SetDatabase(const Value: string);
var
  NamePos: integer;
  Host, FileName: string;
  Protocol: _TIBCProtocol;
begin
  if FDatabase <> Trim(Value) then begin
    Disconnect;
    FDatabase := Trim(Value);

    //Sync Server and Protocol
    NamePos := GetDBNamePos(FDatabase);
    if NamePos > 0 then begin
      ParseDatabaseName(FDatabase, Host, Protocol, FileName);
      FServer := Host;
      Options.FProtocol := TIBCProtocol(Protocol);
      if FIConnection <> nil then
        FIConnection.SetProp(prProtocol, Variant(Protocol));
    end
    else
      FileName := FDatabase;

    if FIConnection <> nil then
      FIConnection.SetProp(prDatabase, FileName);
  end;
end;

procedure TIBCConnection.SetServer(const Value: _string);
var
  NamePos: integer;
  Host, FileName: string;
  Protocol: _TIBCProtocol;
begin
  if Value <> FServer then begin
    inherited;

    //Sync Database
    NamePos := GetDBNamePos(FDatabase);
    if NamePos > 0 then begin
      ParseDatabaseName(FDatabase, Host, Protocol, FileName);
      FDatabase := GetFullDatabaseName(FServer, Protocol, FileName);
    end;
  end;
end;

function TIBCConnection.GetSQLDialect: Integer;
var
  Val: Variant;
begin
 if (FIConnection <> nil) and FIConnection.GetConnected then begin
   FIConnection.GetProp(prSQLDialect, Val);
   Result := Val;
 end
 else
   Result := FSQLDialect;
end;

procedure TIBCConnection.SetSQLDialect(const Value: Integer);
begin
  if FSQLDialect <> Value then begin
    Disconnect;
    FSQLDialect := Value;
  end;
end;

function TIBCConnection.GetDBSQLDialect: Integer;
var
  Val: Variant;
begin
  if FIConnection <> nil then begin
    FIConnection.GetProp(prDBSQLDialect, Val);
    Result := Val;
  end
  else
    Result := DefaultDBSQLDialect;
end;

function TIBCConnection.GetDatabaseInfo: TGDSDatabaseInfo;
begin
  if FIConnection = nil then
    CreateIConnection;
  Result := FIConnection.DatabaseInfo;
end;

procedure TIBCConnection.AssignConnect(Source: TIBCConnection);
begin
  inherited AssignConnect(Source);
end;

procedure TIBCConnection.SetDefaultTransaction(Value: TIBCTransaction);
begin
  inherited DefaultTransaction := Value;
end;

function TIBCConnection.GetDefaultTransaction: TIBCTransaction;
begin
  Result := TIBCTransaction(inherited DefaultTransaction);
end;

function TIBCConnection.GetTransaction(Index: Integer): TIBCTransaction;
begin
  Result := TIBCTransaction(inherited Transactions[Index]);
end;

function TIBCConnection.GetParams: TStrings;
begin
  Result := FParams;
end;

procedure TIBCConnection.SetParams(Value: TStrings);
begin
  FParams.Assign(Value);
end;

procedure TIBCConnection.ParamsChanged(Sender: TObject);
begin
  FParamsChanged := True;
end;

function TIBCConnection.GetConnectPrompt: boolean;
begin
  Result := LoginPrompt;
end;

procedure TIBCConnection.SetConnectPrompt(Value: boolean);
begin
  LoginPrompt := Value;
end;

function TIBCConnection.GetLastError: integer;
begin
  if FIConnection <> nil then
    Result := (FIConnection as TGDSConnection).GetLastError
  else
    Result := 0;
end;

procedure TIBCConnection.SetLastError(Value: integer);
begin
  if FIConnection <> nil then
    (FIConnection as TGDSConnection).SetLastError(Value);
end;

function TIBCConnection.GetSQL: TIBCSQL;
begin
  CheckCommand;
  Result := TIBCSQL(FCommand);
end;

function TIBCConnection.GetHandle: TISC_DB_HANDLE;
begin
  if FIConnection <> nil then
    Result := FIConnection.GetDatabaseHandle
  else
    Result := nil;
end;

procedure TIBCConnection.SetHandle(Value: TISC_DB_HANDLE);
begin
  if (FIConnection = nil) and (Value <> nil) then
    CreateIConnection;
  if FIConnection <> nil then
    FIConnection.SetDatabaseHandle(Value);
end;

function TIBCConnection.GetHandleIsShared: boolean;
begin
  Result := (FIConnection <> nil) and not FIConnection.NativeConnection;
end;

function TIBCConnection.GetIsReadOnly: boolean;
var
  Val: Variant;
begin
  if FIConnection <> nil then begin
    FIConnection.Component := Self;
    FIConnection.GetProp(prReadOnly, Val);
    Result := Val;
  end
  else
    Result := False;
end;

function TIBCConnection.IsFirebirdConnection: boolean;
begin
  if FIConnection <> nil then
    Result:= FIConnection.IsFBServer
  else
    Result := False;
end;

function TIBCConnection.GetMajorServerVersion: integer;
begin
  if FIConnection <> nil then
    Result := FIConnection.GetMajorServerVersion
  else
    Result := 0;
end;

function TIBCConnection.GetMinorServerVersion: integer;
begin
  if FIConnection <> nil then
    Result := FIConnection.GetMinorServerVersion
  else
    Result := 0;
end;

function TIBCConnection.GetClientLibrary: string;
begin
  if Connected then
    Result := FIConnection.GDS.GDSDLL
  else
    Result := FClientLibrary;
end;

procedure TIBCConnection.SetClientLibrary(const Value: string);
begin
  if Value <> FClientLibrary then begin
    Disconnect;
    FClientLibrary := Value;
    if FIConnection <> nil then
      FIConnection.SetProp(prClientLibrary, Value);
  end;
end;

function TIBCConnection.FindDefaultTransaction: TIBCTransaction;
begin
  Result := DefaultTransaction;
end;

function TIBCConnection.AddTransaction(TR: TIBCTransaction): Integer;
begin
  Result := DoAddTransaction(TR);
end;

procedure TIBCConnection.RemoveTransaction(TR: TIBCTransaction);
begin
  DoRemoveTransaction(TR);
end;

procedure TIBCConnection.CreateDatabase;
var
  Host, FileName: string;
  Protocol: _TIBCProtocol;
begin
  GetConnectProps(Host, Protocol, FileName);

  CreateIConnection;
  FIConnection.SetServer(Host);
  FIConnection.SetProp(prProtocol, Variant(Protocol));
  FIConnection.SetProp(prDatabase, FileName);
  FIConnection.SetProp(prSQLDialect, SQLDialect);
  FIConnection.CreateDatabase;
end;

procedure TIBCConnection.DropDatabase;
begin
  if not Connected then
    DatabaseError(SConnectionIsClosed);

  DisconnectTransaction;

  FIConnection.DropDatabase;
end;

{$IFNDEF VER6P}
type
  _TWriter = class(TFiler)
  private
    FRootAncestor: TComponent;
    FPropPath: string;
  public
    property RootAncestor: TComponent read FRootAncestor write FRootAncestor; //Hint fix
  end;

  _TWriter2 = class(TWriter)
  end;

procedure TIBCConnection.DefineProperties(Filer: TFiler);
var
  OldAncestor: TPersistent;
  SavePropPath: string;
begin
  inherited;
  if (DefaultTransaction = FInternalDefTransaction) and (Filer is TWriter) then
    with _TWriter(Filer) do begin
      OldAncestor := Ancestor;
      SavePropPath := FPropPath;
      try
        FPropPath := FPropPath + 'DefaultTransaction.';
        if (Ancestor <> nil) and (Self.ClassType = Ancestor.ClassType) then
          Ancestor := TIBCConnection(Ancestor).DefaultTransaction;
       _TWriter2(Filer).WriteProperties(DefaultTransaction);
      finally
        Ancestor := OldAncestor;
        FPropPath := SavePropPath;
      end;
    end;
end;
{$ENDIF}

procedure TIBCConnection.AssignTo(Dest: TPersistent);
begin
  inherited;
  
  if Dest is TIBCConnection then begin
    TIBCConnection(Dest).Database := Database;
    TIBCConnection(Dest).SQLDialect := SQLDialect;
  end;
end;

{ TConnectionList }

function TConnectionList.GetCount: integer;
var
  List: TList;
begin
  List := LockList;
  try
    Result := List.Count;
  finally
    UnlockList;
  end;
end;

function TConnectionList.GetConnection(i: integer): TIBCConnection;
var
  List: TList;
begin
  List := LockList;
  try
    Result := TIBCConnection(List[i]);
  finally
    UnlockList;
  end;
end;

{ TIBCParam }

destructor TIBCParam.Destroy;
begin
  FreeObject;

  inherited;
end;

procedure TIBCParam.CreateObject;
var
  Blob: TIBCBlob;
begin
  Assert(FParamObject = nil);

  case DataType of
    ftBlob, ftMemo{$IFDEF VER10P}, ftWideMemo{$ENDIF}: begin
      Blob := TIBCBlob.Create(TGDSConnection(nil), TGDSTransaction(nil));
      FParamObject := Blob;
      if DataType in [ftMemo{$IFDEF VER10P}, ftWideMemo{$ENDIF}] then
        Blob.SubType := isc_blob_text;

      if {$IFDEF VER10P}(DataType = ftWideMemo) or {$ENDIF}
        UnicodeMemoParameters and (DataType = ftMemo)
      then begin
        Blob.IsUnicode := True;
        Blob.CharsetID := CH_UTF8;
      end;

    end;
    else
      if (Integer(DataType) = ftIBCArray) or (DataType = ftADT) then
        FParamObject := TIBCArray.Create(nil, nil)
      else
        inherited;
  end;
end;

procedure TIBCParam.SetBlobData(Buffer: IntPtr; Size: integer);
var
  Data: TBytes;
{$IFNDEF VER12P}
  DataStr: string;
{$ENDIF}
begin
  SetLength(Data, Size);
  Marshal.Copy(Buffer, Data, 0, Size);
{$IFNDEF VER12P}
  DataStr := Encoding.Default.GetString(Data);
  AsBlob := DataStr;
{$ELSE}
  AsBlob := Data;
{$ENDIF}
end;

function TIBCParam.GetAsString: string;
begin
  if (Integer(DataType) = ftIBCArray) or (DataType = ftADT) then
    Result := TIBCArray(FParamObject).AsString
  else
    Result := inherited GetAsString;
end;

procedure TIBCParam.SetAsString(const Value: string);
begin
  if Datatype in [ftFixedChar, ftVarBytes, ftBytes] then
    Self.Value := Value
  else
  if (Integer(DataType) = ftIBCArray) or (DataType = ftADT) then
    TIBCArray(FParamObject).AsString := Value
  else
    inherited;
end;

function TIBCParam.GetAsVariant: variant;
begin
  if (Integer(DataType) = ftIBCArray) or (DataType = ftADT) then
    Result := TIBCArray(FParamObject).Items
  else
    Result := inherited GetAsVariant;
end;

procedure TIBCParam.SetAsVariant(const Value: variant);
begin
  if IsObjectDataType and (VarType(Value) = {$IFDEF CLR}varObject{$ELSE}varByRef{$ENDIF}) then begin
  {$IFDEF CLR}
    ParamObject := TSharedObject(Value);
  {$ELSE}
    ParamObject := TVarData(Value).VPointer;
  {$ENDIF}
    Assert(ParamObject is TSharedObject);
  end
  else
    if (Integer(DataType) = ftIBCArray) or (DataType = ftADT) then
      TIBCArray(FParamObject).Items := Value
    else
      inherited;
end;

function TIBCParam.GetIsNull: boolean;
begin
  if (Integer(DataType) = ftIBCArray) or (DataType = ftADT) then
    Result := TIBCArray(FParamObject).IsNull
  else
    Result := inherited GetIsNull;
end;

procedure TIBCParam.Clear;
begin
  if (Integer(DataType) = ftIBCArray) or (DataType = ftADT) then
    TIBCArray(FParamObject).IsNull := True
  else
    inherited;
end;

function TIBCParam.IsObjectDataType(DataType: TFieldType): boolean;
begin
  case DataType of
    {$IFDEF VER6P}ftTimeStamp,{$ENDIF}
    {$IFDEF VER10P}ftWideMemo,{$ENDIF}
    ftMemo, ftBlob, ftArray, ftADT:
      Result := True;
  else
    case Integer(DataType) of
      Integer(ftXML):
        Result := True;
      Integer(ftIBCArray):
        Result := True;
    else
      Result := False;
    end;
  end;
end;

function TIBCParam.IsObjectDataType: boolean;
begin
  Result := inherited IsObjectDataType;
end;

function TIBCParam.GetSize: integer;
begin
  if (DataType in [ftString, ftFixedChar, ftWideString, ftBytes, ftVarBytes]) or (Integer(DataType) = Integer(ftFixedWideChar)) then
    Result := inherited GetSize
  else
    Result := 0;
end;

function TIBCParam.GetAsIbBlob: TIBCBlob;
begin
  if DataType = ftUnknown then
    DataType := ftBlob;

  if DataType in [ftBlob, ftMemo{$IFDEF VER10P}, ftWideMemo{$ENDIF}] then
    Result := FParamObject as TIBCBlob
  else
    Result := nil;
end;

procedure TIBCParam.SetAsIbBlob(Value: TIBCBlob);
begin
  FreeObject;

  if not (DataType in [ftBlob, ftMemo{$IFDEF VER10P}, ftWideMemo{$ENDIF}]) then
    inherited DataType := ftBlob;

  ParamObject := Value;
end;

function TIBCParam.GetAsArray: TIBCArray;
begin
  if DataType = ftUnknown then
    DataType := TFieldType(ftIBCArray);

  if (DataType = ftADT) or (Integer(DataType) = ftIBCArray) then
    Result := TIBCArray(FParamObject as TCustomIBCArray)
  else
    Result := nil;
end;

procedure TIBCParam.SetAsArray(Value: TIBCArray);
begin
  if FParamObject <> Value then begin
    FreeObject;

    if (DataType <> ftADT) and (DataType <> TFieldType(ftIBCArray)) then
      DataType := TFieldType(ftIBCArray);

    ParamObject := Value;
  end;
end;

{ TIBCParams }

constructor TIBCParams.Create(Owner: TPersistent);
begin
  inherited Create(TIBCParam);

  FNeedsUpdateItem := True;
  FOwner := Owner;
end;

function TIBCParams.ParamByName(const Value: _string): TIBCParam;
begin
  Result := TIBCParam(inherited ParamByName(Value));
end;

function TIBCParams.FindParam(const Value: _string): TIBCParam;
begin
  Result := TIBCParam(inherited FindParam(Value));
end;

function TIBCParams.GetItem(Index: integer): TIBCParam;
begin
  Result := TIBCParam(inherited Items[Index]);
end;

procedure TIBCParams.SetItem(Index: integer; Value: TIBCParam);
begin
  inherited Items[Index] := Value;
end;


{ TIBCDbKeyField }
constructor TIBCDbKeyField.Create(Owner: TComponent);
begin
  inherited Create(Owner);
{$IFNDEF FPC}
  SetDataType(ftBytes);
{$ENDIF}
end;

procedure TIBCDbKeyField.GetText(var Text: string; DisplayText: Boolean);
begin
  Text := GetAsString;
end;

function TIBCDbKeyField.GetAsString: string;
var
  Data, Buffer: IntPtr;
  SB: StringBuilder;
  i: integer;
begin
  Result := '';
  if not IsNull then begin
    Data := Marshal.AllocHGlobal(Size + 1); //Buffer will contain byte data with 0 terminator 
    SB := StringBuilder.Create(Size * 2);
    try
      GetData(Data);
      Buffer := Data;
      for i := 1 to Size div 4 do begin
        SB.Append(IntToHex(Marshal.ReadInt32(Buffer), 8));
        Buffer := PtrOffset(Buffer, 4);
      end;
      Result := SB.ToString;
    finally
      Marshal.FreeHGlobal(Data);
      SB.Free;
    end;
  end;
end;

{ TIBCArrayField }

constructor TIBCArrayField.Create(Owner: TComponent);
begin
  inherited Create(Owner);
  SetDataType(TFieldType(ftIBCArray));
end;

function TIBCArrayField.GetAsArray: TIBCArray;
var
  Data: IntPtr;
begin
  Data := Marshal.AllocHGlobal(SizeOf(IntPtr));
  Marshal.WriteIntPtr(Data, nil);
  try
    GetData(Data);
    Result := TIBCArray(GetGCHandleTarget(Marshal.ReadIntPtr(Data)));
  finally
    Marshal.FreeHGlobal(Data);
  end;
end;

function TIBCArrayField.GetAsString: string;
var
  IBCArray: TIBCArray;
begin
  IBCArray := AsArray;
  if IBCArray <> nil then
    Result := IBCArray.AsString;
end;

procedure TIBCArrayField.SetAsString(const Value: string);
var
  IBCArray: TIBCArray;
begin
  IBCArray := AsArray;
  if IBCArray <> nil then
    IBCArray.AsString := Value;
  SetData(nil);
end;

function TIBCArrayField.GetAsVariant: variant;
var
  IBCArray: TIBCArray;
begin
  IBCArray := AsArray;
  if IBCArray <> nil then
    Result := IBCArray.Items
  else
    Result := Unassigned;
end;

procedure TIBCArrayField.SetAsVariant(const Value: Variant);
var
  IBCArray: TIBCArray;
begin
  IBCArray := AsArray;
  if IBCArray <> nil then
    AsArray.Items := Value;
end;

function TIBCArrayField.GetDataSize: integer;
var
  IBCArray: TIBCArray;
begin
  IBCArray := AsArray;
  Result := 0;
  if IBCArray <> nil then
    Result := IBCArray.ArraySize;
end;

procedure TIBCArrayField.GetText(var Text: string; DisplayText: Boolean);
begin
  Text := GetAsString;
end;

procedure TIBCArrayField.SetText(const Value: string);
begin
  SetAsString(Value);
end;

{$IFNDEF FPC}
function TIBCArrayField.GetSize: Integer;
var
  IBCArray: TIBCArray;
begin
  IBCArray := AsArray;
  Result := 0;
  if IBCArray <> nil then
    Result := IBCArray.ArraySize;
end;
{$ENDIF}

class procedure TIBCArrayField.CheckTypeSize(Value: Integer);
begin
end;

function TIBCArrayField.GetModified: boolean;
var
  IBCArray: TIBCArray;
begin
  IBCArray := AsArray;
  Result := False;
  if IBCArray <> nil then
    Result := IBCArray.Modified;
end;

function TIBCArrayField.GetIsNull: Boolean;
var
  IBCArray: TIBCArray;
begin
  IBCArray := AsArray;
  Result := True;
  if IBCArray <> nil then
    Result := IBCArray.IsNull;
end;

{ TIBCTransaction }

constructor TIBCTransaction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  
  DefaultCloseAction := taRollback;
  FParams := TStringList.Create;
  FOnError := DoError;
end;

destructor TIBCTransaction.Destroy;
begin
  FParams.Free;

  inherited;
end;

procedure TIBCTransaction.InternalHandleException;
begin
{$IFDEF VER6P}
  if Assigned(Classes.ApplicationHandleException) then
    Classes.ApplicationHandleException(ExceptObject)
  else
    ShowException(ExceptObject, ExceptAddr)
{$ELSE}
  ApplicationHandleException(Self);
{$ENDIF}
end;

function TIBCTransaction.GetITransactionClass: TCRTransactionClass;
begin
  Result := TGDSTransaction;
end;

procedure TIBCTransaction.SetITransaction(Value: TCRTransaction);
begin
  inherited;

  FITransaction := TGDSTransaction(Value);
  if FITransaction <> nil then begin
    FITransaction.SetParams(FParams);
  end;
end;

function TIBCTransaction.UsedConnection: TCustomDAConnection;
begin
  Result := FindDefaultConnection;
  if (Result = nil) and (ConnectionsCount > 0) then
    Result := Connections[0];
  if (Result = nil) and UseDefConnection then
    Result := {$IFDEF CLR}Devart.IbDac.{$ENDIF}IBC.DefConnection
end;

function TIBCTransaction.SQLMonitorClass: TClass;
begin
  Result := TIBCSQLMonitor;
end;

procedure TIBCTransaction.Loaded;
  function CheckKeepConnected: boolean;
  var
    i: integer;
  begin
    Result := True;
    for i := 0 to FConnections.Count - 1 do
      if not FConnections[i].Options.KeepDesignConnected then begin
        Result := False;
        Break;
      end
      else
        if TIBCConnection(FConnections[i]).GetStreamedConnected and (not FConnections[i].Connected) then begin
          TIBCConnection(FConnections[i]).Loaded;
        end;
  end;

begin
  inherited;

  try
    if FStreamedActive and
     ((ConnectionsCount = 0) or //At least one Connection are present
       CheckKeepConnected or  //All Connections allow design connected
      (csDesigning in ComponentState))
    then
      Active := True;
  except
    if csDesigning in ComponentState then
      InternalHandleException
    else
      raise;
  end;
end;

function TIBCTransaction.IsActiveStored: boolean;
begin
  Result := not FDisconnectedMode and IsInternalTrStored and FExplicitlyStarted;
  //There is no design-time transaction start in Disconnect mode 
end;

procedure TIBCTransaction.DoError(Sender: TObject; E: EDAError; var Fail: boolean);
begin
  if Assigned(FOnIBCError) then
    FOnIBCError(Sender, EIBCError(E));
end;

procedure TIBCTransaction.Commit;
begin
  CheckActive;

  inherited;
end;

procedure TIBCTransaction.Rollback;
begin
  CheckActive;

  inherited;
end;

procedure TIBCTransaction.CommitRetaining;
begin
  DoCommitRetaining;
end;

procedure TIBCTransaction.RollbackRetaining;
begin
  DoRollbackRetaining;
end;

procedure TIBCTransaction.StartSavepoint(const Name: string);
begin
  DoSavepoint(Name);
end;

procedure TIBCTransaction.RollbackSavepoint(const Name: string);
begin
  DoRollbackToSavepoint(Name);
end;

procedure TIBCTransaction.ReleaseSavepoint(const Name: string);
begin
  DoReleaseSavepoint(Name);
end;

procedure TIBCTransaction.DoSavepoint(const Name: _string);
begin
  CheckActive;

  inherited;
end;

procedure TIBCTransaction.DoRollbackToSavepoint(const Name: _string);
begin
  CheckActive;

  inherited;
end;

procedure TIBCTransaction.DoReleaseSavepoint(const Name: _string);
begin
  CheckActive;

  inherited;
end;

procedure TIBCTransaction.CloseTransaction(Force: boolean = False);
begin
  inherited;
end;

function TIBCTransaction.GetDefaultConnection: TIBCConnection;
begin
  Result := TIBCConnection(inherited DefaultConnection);
end;

procedure TIBCTransaction.SetDefaultConnection(const Value: TIBCConnection);
begin
  inherited DefaultConnection := Value;
end;

function TIBCTransaction.GetActive: boolean;
begin
  Result := inherited Active;
end;

procedure TIBCTransaction.SetActive(Value: boolean);
begin
  if (csReading in ComponentState)
  {$IFNDEF VER7P}or ((FDefaultConnection <> nil) and (csReading in FDefaultConnection.ComponentState)){$ENDIF} then
    FStreamedActive := Value
  else begin
    if Value then begin
      if (FITransaction = nil) or not FITransaction.GetInTransaction then
        StartTransaction;
    end
    else
      if (FITransaction <> nil) and FITransaction.GetInTransaction then
        CloseTransaction;
  end;
end;

procedure TIBCTransaction.SetParams(Value: TStrings);
begin
  FParams.Assign(Value);
  if FITransaction <> nil then
    FITransaction.SetParams(Value);
end;

function TIBCTransaction.GetHandle: TISC_TR_HANDLE;
begin
  if FITransaction <> nil then
    Result := FITransaction.GetTransactionHandle
  else
    Result := nil;
end;

procedure TIBCTransaction.SetHandle(Value: TISC_TR_HANDLE);
begin
  if (FITransaction = nil) and (Value <> nil) then
    CheckITransaction;
  if FITransaction <> nil then
    FITransaction.SetTransactionHandle(Value);
end;

function TIBCTransaction.GetHandleIsShared: boolean;
begin
  Result := (FITransaction <> nil) and not FITransaction.NativeTransaction;
end;

function TIBCTransaction.GetDefaultCloseAction: TIBCTransactionAction;
begin
  Result := FDefaultCloseAction;
end;

procedure TIBCTransaction.SetDefaultCloseAction(Value: TIBCTransactionAction);
begin
  FDefaultCloseAction := Value;

  case Value of
    taCommit, taCommitRetaining:
      inherited DefaultCloseAction := CRAccess.taCommit;
    taRollback, taRollbackRetaining:
      inherited DefaultCloseAction := CRAccess.taRollback;
  end;
end;

function TIBCTransaction.GetConnection(Index: integer): TIBCConnection;
begin
  Result := TIBCConnection(inherited Connections[Index]);
end;

function TIBCTransaction.GetIsolationLevel: TIBCIsolationLevel;
begin
  if ReadOnly then
    case inherited IsolationLevel of
      ilReadCommitted:
        Result := iblReadOnlyReadCommitted;
      ilIsolated:
        Result := iblReadOnlyTableStability;
    else
      Assert(False);
      Result := iblReadOnlyReadCommitted;
    end
  else
    case inherited IsolationLevel of
      ilReadCommitted:
        Result := iblReadCommitted;
      ilIsolated:
        Result := iblTableStability;
      ilSnapshot:
        Result := iblSnapshot;
      ilCustom:
        Result := iblCustom;
    else
      Assert(False);
      Result := iblReadCommitted;
    end
end;

procedure TIBCTransaction.SetIsolationLevel(Value: TIBCIsolationLevel);
var
  CRLevel: TCRIsolationLevel;
begin
  CheckInactive;

  ReadOnly := Value in [iblReadOnlyReadCommitted, iblReadOnlyTableStability];

  case Value of
    iblSnapshot:
      CRLevel := ilSnapshot;
    iblReadCommitted, iblReadOnlyReadCommitted:
      CRLevel := ilReadCommitted;
    iblTableStability, iblReadOnlyTableStability:
      CRLevel := ilIsolated;
    iblCustom:
      CRLevel := ilCustom;
  else
    Assert(False);
    CRLevel := ilReadCommitted;
  end;

  inherited IsolationLevel := CRLevel;
end;

function TIBCTransaction.FindDefaultConnection: TIBCConnection;
var
  i: Integer;
begin
  Result := TIBCConnection(FDefaultConnection);
  if FDefaultConnection = nil then
    for i := 0 to FConnections.Count - 1 do
      if TIBCConnection(FConnections[i]).DefaultTransaction = Self then begin
        Result := TIBCConnection(FConnections[i]);
        break;
      end;
end;

function TIBCTransaction.AddConnection(Connection: TIBCConnection): integer;
begin
  Result := DoAddConnection(Connection);
end;

procedure TIBCTransaction.RemoveConnection(Connection: TIBCConnection);
begin
  DoRemoveConnection(Connection);
end;

{ TIBCStoredProc }

constructor TIBCStoredProc.Create(Owner: TComponent);
begin
  inherited Create(Owner);
end;

procedure TIBCStoredProc.DoBeforeInsert;
begin
  inherited;

  if not (LocalUpdate or
    (SQLInsert.Count > 0) or
    (Assigned(UpdateObject) and ((UpdateObject.InsertSQL.Count > 0) or (UpdateObject.InsertObject <> nil))))
  then
    Abort;
end;

procedure TIBCStoredProc.DoBeforeDelete;
begin
  inherited;

  if not (LocalUpdate or
    (SQLDelete.Count > 0) or
    (Assigned(UpdateObject) and ((UpdateObject.DeleteSQL.Count > 0) or (UpdateObject.DeleteObject <> nil))))
  then
    Abort;
end;

procedure TIBCStoredProc.DoBeforeEdit;
begin
  inherited;

  if not (LocalUpdate or
    (SQLUpdate.Count > 0) or
    (Assigned(UpdateObject) and ((UpdateObject.ModifySQL.Count > 0) or (UpdateObject.ModifyObject <> nil))))
  then
    Abort;
end;

procedure TIBCStoredProc.DoBeforeExecute;
begin
  if SQL.Count = 0 then
    PrepareSQL(False);

  inherited;
end;

procedure TIBCStoredProc.PrepareSQL(IsQuery: boolean = False);
begin
  if (IsQuery <> TIBCSQL(FCommand).StoredProcIsQuery) or (SQL.Count = 0) then begin
    InternalCreateProcCall(StoredProcName,
      (Params.Count = 0) or (IsQuery <> TIBCSQL(FCommand).StoredProcIsQuery), IsQuery);
  end;
end;

procedure TIBCStoredProc.Prepare;
begin
  if not Prepared then
    PrepareSQL(False);

  inherited;
end;

function TIBCStoredProc.SQLAutoGenerated: boolean;
begin
  Result := True;
end;

procedure TIBCStoredProc.BeforeOpenCursor(InfoQuery: boolean);
begin
  if SQL.Count = 0 then
    PrepareSQL(True);

  inherited;
end;

procedure TIBCStoredProc.ExecProc;
begin
  Execute;
end;

procedure TIBCStoredProc.AssignTo(Dest: TPersistent);
begin
  if Dest is TIBCStoredProc then begin
    TIBCStoredProc(Dest).SQL.Text := SQL.Text;
    TIBCStoredProc(Dest).FStoredProcName := FStoredProcName;
  end;

  inherited;
end;

{$IFNDEF FPC}
{ IProviderSupport }

procedure TIBCStoredProc.PSSetCommandText(const CommandText: string);
begin
  if CommandText <> '' then
    StoredProcName := CommandText;
end;
{$ENDIF}

procedure TIBCStoredProc.SetStoredProcName(const Value: _string);
begin
  if Value <> FStoredProcName then begin
    if SQL.Text <> '' then   //This will prevent Params.Clear
      SQL.Text := '';

    FStoredProcName := Trim(Value);
  end;
end;

{ TIBCSQL }

constructor TIBCSQL.Create(Owner: TComponent);
begin
  inherited Create(Owner);
end;

function TIBCSQL.NeedRecreateProcCall: boolean;
begin
  Result := True;
end;

procedure TIBCSQL.CreateICommand;
begin
  inherited;

  if FICommand = nil then
    SetICommand(TGDSCommand.Create);
end;

procedure TIBCSQL.SetICommand(Value: TCRCommand);
begin
  FICommand := TGDSCommand(Value); // before inherited bacause inherited calls WriteParams

  inherited;

  if FICommand <> nil then begin
    FICommand.SetProp(prUseDescribeParams, FDescribeParams);
  end;
end;

function TIBCSQL.CreateParamsObject: TDAParams;
begin
  Result := TIBCParams.Create(Self);
end;

function TIBCSQL.GetDataTypesMap: TDataTypesMapClass;
begin
  Result := TIBCDataTypesMap;
end;

procedure TIBCSQL.AssignTo(Dest: TPersistent);
begin
  inherited;
end;

procedure TIBCSQL.InternalExecute(Iters: integer);
begin
  inherited InternalExecute(Iters);
end;

function TIBCSQL.UsedConnection: TCustomDAConnection;
begin
  Result := inherited UsedConnection;
  if Result = nil then
    if UseDefConnection then
      Result := {$IFDEF CLR}Devart.IbDac.{$ENDIF}IBC.DefConnection
end;

procedure TIBCSQL.CheckConnection;
begin
  inherited;
end;

procedure TIBCSQL.ConnectChange(Sender: TObject; Connecting: boolean);
begin
  inherited;
end;

function TIBCSQL.GetTransaction: TDATransaction;
var
  vConnection: TIBCConnection;
begin
  Result := inherited GetTransaction;

  if Result = nil then begin
    vConnection := Connection;
    if (vConnection <> nil) and (vConnection.DefaultTransaction <> nil) then
      Result := vConnection.DefaultTransaction
  end;
end;

function TIBCSQL.IsInOutParamSupported: boolean;
begin
  Result := False;
end;

function TIBCSQL.NeedConvertEOLForBlob: boolean;
begin
  Result := True;
end;

procedure TIBCSQL.AssignParam(ParamDesc: TParamDesc; Param: TDAParam);
var
  IBCParam: TIBCParam;
  IBCParamDesc: TIBCParamDesc;
begin
  inherited;

  IBCParam := TIBCParam(Param);
  IBCParamDesc := TIBCParamDesc(ParamDesc);

  IBCParamDesc.Precision := IBCParam.Precision;
  IBCParamDesc.Scale := IBCParam.NumericScale;
end;

procedure TIBCSQL.AssignParamDesc(Param: TDAParam; ParamDesc: TParamDesc);
var
  IBCParam: TIBCParam;
  IBCParamDesc: TIBCParamDesc;
begin
  inherited;

  IBCParam := TIBCParam(Param);
  IBCParamDesc := TIBCParamDesc(ParamDesc);

  IBCParam.NumericScale := IBCParamDesc.Scale;
  IBCParam.Precision := IBCParamDesc.Precision;
end;

function TIBCSQL.ExecuteNext: boolean;
begin
  CheckICommand;
  Result := FICommand.ExecuteNext;
end;

procedure TIBCSQL.BreakExec;
begin
  if FICommand <> nil then
    FICommand.BreakExec;
end;

function TIBCSQL.FindParam(const Value: _string): TIBCParam;
begin
  Result := Params.FindParam(Value);
end;

function TIBCSQL.ParamByName(const Value: _string): TIBCParam;
begin
  Result := Params.ParamByName(Value);
end;

procedure TIBCSQL.CreateProcCall(const Name: _string);
begin
  InternalCreateProcCall(Name, True, False);
end;

function TIBCSQL.GetSQLType: Integer;
begin
  if FICommand <> nil then
    Result := FICommand.GetSQLType
  else
    Result := 0;
end;

function TIBCSQL.GetSQLTypeEx: Integer;
begin
  if FICommand <> nil then
    Result := FICommand.GetSQLTypeEx
  else
    Result := 0;
end;

function TIBCSQL.GetText: _string;
begin
  Result := SQL.Text;
end;

procedure TIBCSQL.SetText(const Value: _string);
begin
  SQL.Text := Value;
end;

function TIBCSQL.GetConnection: TIBCConnection;
begin
  Result := TIBCConnection(inherited Connection);
end;

procedure TIBCSQL.SetConnection(Value: TIBCConnection);
begin
  inherited Connection := Value;
end;

function TIBCSQL.GetParams: TIBCParams;
begin
  Result := TIBCParams(inherited Params);
end;

procedure TIBCSQL.SetParams(Value: TIBCParams);
begin
  inherited Params := Value;
end;

procedure TIBCSQL.SetIBCTransaction(Value: TIBCTransaction);
begin
  inherited Transaction := Value;
end;

function TIBCSQL.GetIBCTransaction: TIBCTransaction;
begin
  Result := TIBCTransaction(inherited Transaction);
end;

function TIBCSQL.GetHandle: TISC_STMT_HANDLE;
begin
  if FICommand <> nil then
    Result := FICommand.GetStmtHandle
  else
    Result := nil;
end;

procedure TIBCSQL.SetDescribeParams(Value: boolean);
begin
  if Value <> FDescribeParams then begin
    FDescribeParams := Value;
    if FICommand <> nil then
      FICommand.SetProp(prUseDescribeParams, FDescribeParams);
  end;
end;

function TIBCSQL.GetPlan: string;
var
  Val: Variant;
begin
  if FICommand <> nil then begin
    FICommand.GetProp(prPlan, Val);
    Result := Val;
  end
  else
    Result := '';
end;

{ TIBCDataSetOptions }
constructor TIBCDataSetOptions.Create(Owner: TCustomDADataSet);
begin
  inherited Create(Owner);

  CacheBlobs := True;
  CacheArrays := True;
  DeferredArrayRead := True;
{$IFNDEF FPC}
  ComplexArrayFields := True;
{$ENDIF}
  PrepareUpdateSQL := True;
end;

procedure TIBCDataSetOptions.AssignTo(Dest: TPersistent);
begin
  inherited;

  if Dest is TIBCDataSetOptions then begin
    TIBCDataSetOptions(Dest).AutoClose := AutoClose;
    TIBCDataSetOptions(Dest).FieldsAsString := FieldsAsString;
    TIBCDataSetOptions(Dest).CacheBlobs := CacheBlobs;
    TIBCDataSetOptions(Dest).StreamedBlobs := StreamedBlobs;
    TIBCDataSetOptions(Dest).DeferredBlobRead := DeferredBlobRead;
    TIBCDataSetOptions(Dest).CacheArrays := CacheArrays;
    TIBCDataSetOptions(Dest).DeferredArrayRead := DeferredArrayRead;
    TIBCDataSetOptions(Dest).ComplexArrayFields := ComplexArrayFields;
    TIBCDataSetOptions(Dest).BooleanDomainFields := BooleanDomainFields;
    TIBCDataSetOptions(Dest).DescribeParams := DescribeParams;
    TIBCDataSetOptions(Dest).SetDomainNames := SetDomainNames;
  end;
end;

procedure TIBCDataSetOptions.SetAutoClose(const Value: boolean);
begin
  FAutoClose := Value;
  if TCustomIBCDataSet(FOwner).FIRecordSet <> nil then
    TCustomIBCDataSet(FOwner).FIRecordSet.SetProp(prAutoClose, FAutoClose);
end;

procedure TIBCDataSetOptions.SetFieldsAsString(const Value: boolean);
begin
  FFieldsAsString := Value;
  if TCustomIBCDataSet(FOwner).FIRecordSet <> nil then
    TCustomIBCDataSet(FOwner).FIRecordSet.SetProp(prFieldsAsString, FFieldsAsString);
end;

procedure TIBCDataSetOptions.SetDeferredBlobRead(Value: boolean);
begin
  FDeferredBlobRead := Value;
  if TCustomIBCDataSet(FOwner).FIRecordSet <> nil then
    TCustomIBCDataSet(FOwner).FIRecordSet.SetProp(prDeferredBlobRead, FDeferredBlobRead);
end;

procedure TIBCDataSetOptions.SetCacheBlobs(Value: boolean);
begin
  TCustomIBCDataSet(FOwner).CheckInactive;
  FCacheBlobs := Value;
  if TCustomIBCDataSet(FOwner).FICommand <> nil then
    TCustomIBCDataSet(FOwner).FICommand.SetProp(prCacheBlobs, FCacheBlobs);
end;

procedure TIBCDataSetOptions.SetStreamedBlobs(Value: boolean);
begin
  FStreamedBlobs := Value;
  if TCustomIBCDataSet(FOwner).FICommand <> nil then
    TCustomIBCDataSet(FOwner).FICommand.SetProp(prStreamedBlobs, FStreamedBlobs);
end;

procedure TIBCDataSetOptions.SetComplexArrayFields(Value: boolean);
begin
  if Value <> FComplexArrayFields then begin
    TCustomIBCDataSet(FOwner).CheckInactive;
    TCustomIBCDataSet(FOwner).UnPrepare;
    FComplexArrayFields := Value;
    if TCustomIBCDataSet(FOwner).FIRecordSet <> nil then
      TCustomIBCDataSet(FOwner).FIRecordSet.SetProp(prComplexArrayFields, FComplexArrayFields);
  end;
end;

procedure TIBCDataSetOptions.SetDeferredArrayRead(Value: boolean);
begin
  FDeferredArrayRead := Value;
  if TCustomIBCDataSet(FOwner).FIRecordSet <> nil then
    TCustomIBCDataSet(FOwner).FIRecordSet.SetProp(prDeferredArrayRead, FDeferredArrayRead);
end;

procedure TIBCDataSetOptions.SetCacheArrays(Value: boolean);
begin
  if Value <> FCacheArrays then begin
    TCustomIBCDataSet(FOwner).CheckInactive;
    FCacheArrays := Value;
    if TCustomIBCDataSet(FOwner).FICommand <> nil then
      TCustomIBCDataSet(FOwner).FICommand.SetProp(prCacheArrays, FCacheArrays);
  end;
end;

procedure TIBCDataSetOptions.SetBooleanDomainFields(Value: boolean);
begin
  if Value <> FBooleanDomainFields then begin
    TCustomIBCDataSet(FOwner).CheckInactive;
    if TCustomIBCDataSet(FOwner).FIRecordSet <> nil then
      TCustomIBCDataSet(FOwner).FIRecordSet.SetProp(prBooleanDomainFields, Value);
    FBooleanDomainFields := Value;
  end;
end;

procedure TIBCDataSetOptions.SetDescribeParams(Value: boolean);
begin
  if Value <> FDescribeParams then begin
    FDescribeParams := Value;
    if TCustomIBCDataSet(FOwner).FICommand <> nil then
      TCustomIBCDataSet(FOwner).FICommand.SetProp(prUseDescribeParams, FDescribeParams);
  end;
end;

procedure TIBCDataSetOptions.SetSetDomainNames(Value: boolean);
begin
  if Value <> FSetDomainNames then begin
    TCustomIBCDataSet(FOwner).CheckInactive;
    FSetDomainNames := Value;
    if TCustomIBCDataSet(FOwner).FIRecordSet <> nil then
      TCustomIBCDataSet(FOwner).FIRecordSet.SetProp(prSetDomainNames, Value);
  end;
end;

{ TIBCSQLGenerator }

function TIBCSQLGenerator.FieldModified(FieldDesc: TCRFieldDesc): boolean;
begin
  if FieldDesc.DataType = dtArray then
    Result := TCustomIBCDataSet(FDataSet).GetArray(FieldDesc).Modified
  else
    Result := inherited FieldModified(FieldDesc);
end;

{ TIBCDataSetUpdater }

procedure TIBCDataSetUpdater.SetUpdateQueryOptions(const StatementType: TStatementType);
var
  Source, Dest: TCustomIBCDataSet;
begin
  Source := TCustomIBCDataSet(FDataSet);
  Dest := TCustomIBCDataSet(UpdateQuery);

  Dest.Options.FieldsAsString := Source.Options.FieldsAsString;
  Dest.Options.CacheBlobs := Source.Options.CacheBlobs;
  Dest.Options.StreamedBlobs := Source.Options.StreamedBlobs;
  Dest.Options.ComplexArrayFields := Source.Options.ComplexArrayFields;
  Dest.Options.CacheArrays := Source.Options.CacheArrays;
  Dest.Options.DeferredArrayRead := Source.Options.DeferredArrayRead;
  Dest.Options.BooleanDomainFields := Source.Options.BooleanDomainFields;
  Dest.Options.DescribeParams := Source.Options.DescribeParams;
  Dest.Options.SetDomainNames := Source.Options.SetDomainNames;
end;

{ TIBCDataSetService }

procedure TIBCDataSetService.CreateSQLGenerator;
begin
  SetSQLGenerator(TIBCSQLGenerator.Create(Self));
end;

procedure TIBCDataSetService.CreateDataSetUpdater;
begin
  SetDataSetUpdater(TIBCDataSetUpdater.Create(Self));
end;

procedure TIBCDataSetService.SetFieldOrigin(Field: TField; FieldDesc: TCRFieldDesc);
begin
  if FDataSet is TCustomIBCTable then
    Field.Origin := _Format('%s.%s',
      [TCustomIBCTable(FDataSet).FTableName, Field.FieldName])
  else
    inherited;
end;

{ TCustomIBCDataSet }

function AddWhere(SQL: _string; Condition: _string): _string;
begin
  Result := _AddWhere(SQL, Condition, TIBCParser, False);
end;

function SetWhere(SQL: _string; Condition: _string): _string;
begin
  Result := _SetWhere(SQL, Condition, TIBCParser, True);
end;

function DeleteWhere(SQL: _string): _string;
begin
  Result := SetWhere(SQL, '');
end;

function SetOrderBy(SQL: _string; Fields: _string): _string;
begin
  Result := _SetOrderBy(SQL, Fields, TIBCParser);
end;

function GetOrderBy(SQL: _string): _string;
begin
  Result := _GetOrderBy(SQL, TIBCParser);
end;

constructor TCustomIBCDataSet.Create;
begin
  inherited;

  FGeneratorStep := 1;
  FGeneratorMode := gmPost;
end;

procedure TCustomIBCDataSet.CreateIRecordSet;
begin
  inherited;

  if FIRecordSet = nil then
    SetIRecordSet(TGDSRecordSet.Create);
end;

procedure TCustomIBCDataSet.SetIRecordSet(Value: TData);
begin
  inherited;

  FIRecordSet := TGDSRecordSet(Value);

  if FIRecordSet <> nil then begin
    FICommand := TGDSCommand(FIRecordSet.GetCommand);

    if Options <> nil then begin
      FIRecordSet.SetProp(prAutoClose, Options.AutoClose);
      FIRecordSet.SetProp(prFieldsAsString, Options.FieldsAsString);
      FIRecordSet.SetProp(prDeferredBlobRead, Options.DeferredBlobRead);
      FICommand.SetProp(prCacheBlobs, Options.CacheBlobs);
      FICommand.SetProp(prStreamedBlobs, Options.StreamedBlobs);
      FIRecordSet.SetProp(prComplexArrayFields, Options.ComplexArrayFields);
      FIRecordSet.SetProp(prDeferredArrayRead, Options.DeferredArrayRead);
      FICommand.SetProp(prCacheArrays, Options.CacheArrays);
      FIRecordSet.SetProp(prBooleanDomainFields, Options.BooleanDomainFields);
      FICommand.SetProp(prUseDescribeParams, Options.DescribeParams);
      FIRecordSet.SetProp(prSetDomainNames, Options.SetDomainNames);
    end;
  end
  else
    FICommand := nil;
end;

procedure TCustomIBCDataSet.CreateCommand;
var
  IBCSQL: TIBCSQL;
begin
  IBCSQL := TIBCSQL.Create(Self);
  SetCommand(IBCSQL);
end;

function TCustomIBCDataSet.CreateOptions: TDADataSetOptions;
begin
  Result := TIBCDataSetOptions.Create(Self);
end;

function TCustomIBCDataSet.GetDataSetServiceClass: TDataSetServiceClass;
begin
  Result := TIBCDataSetService;
end;

procedure TCustomIBCDataSet.SetDataSetService(Value: TDataSetService);
begin
  inherited;

  if FDataSetService <> nil then begin
    FDataSetService.SetProp(prGeneratorMode, Variant(GeneratorMode));
    FDataSetService.SetProp(prGeneratorStep, GeneratorStep);
    FDataSetService.SetProp(prKeyGenerator, Variant(KeyGenerator));
  end;
end;

function TCustomIBCDataSet.UsedConnection: TCustomDAConnection;
begin
  Result := Connection;
  if Result = nil then
    if UseDefConnection then
      Result := {$IFDEF CLR}Devart.IbDac.{$ENDIF}IBC.DefConnection;
end;

procedure TCustomIBCDataSet.CheckConnection;
begin
  inherited;
end;

procedure TCustomIBCDataSet.ConnectChange(Sender: TObject; Connecting: boolean);
begin
  inherited; //CLR crossAssembly call
end;

procedure TCustomIBCDataSet.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if (Operation = opRemove) then
    if (AComponent = UsedTransaction) then
      SetTransaction(nil);

  inherited;
end;

function TCustomIBCDataSet.GetTransaction: TDATransaction;
var
  vConnection: TIBCConnection;
begin
  Result := inherited GetTransaction;

  if Result = nil then begin
    vConnection := Connection;
    if (vConnection <> nil) then
      Result := vConnection.DefaultTransaction
  end;
end;

procedure TCustomIBCDataSet.SetTransaction(Value: TDATransaction);
var
  IsChanged: boolean;
begin
  if not (csDestroying in ComponentState) then begin
    IsChanged := Value <> UsedTransaction;
    if (UsedTransaction <> nil) and IsChanged then
      Disconnect;
  end;

  inherited;
end;

procedure TCustomIBCDataSet.CheckFieldCompatibility(Field: TField; FieldDef: TFieldDef);
begin
  //TIBCDbKeyField - is fully compatible with TBytesField and should be treated as TBytseField   
  if not((Field.DataType = ftBytes) and (FieldDef.DataType = TFieldType(ftIBCDbKey))) then
    inherited;
end;

procedure TCustomIBCDataSet.DoAfterScroll;
begin
  if FFetchCanceled then begin
    Resync([]);
    FFetchCanceled := False;
  end;

  inherited;
end;

procedure TCustomIBCDataSet.InternalExecute;
begin
{$IFDEF HAVE_COMPRESS}
  if not Options.CacheBlobs and ((Options.CompressBlobMode = cbClient) or (Options.CompressBlobMode = cbClientServer)) then
    raise Exception.Create(SCannotCompressNotCached);
{$ENDIF}

  inherited;
end;

procedure TCustomIBCDataSet.DoAfterExecute(Result: boolean);
var
  OldQueryRowsAffected: variant;
begin
  if not Options.StrictUpdate then begin
    FICommand.GetProp(prQueryRowsAffected, OldQueryRowsAffected); //RowsAffected reduce perfomance
    FICommand.SetProp(prQueryRowsAffected, False); //so we remove its query from after excute
  end;
  try
    inherited;
  finally
    if not Options.StrictUpdate then
      FICommand.SetProp(prQueryRowsAffected, OldQueryRowsAffected);
  end;
end;

function TCustomIBCDataSet.QueryKeyFields(TableName: _string; List: _TStrings): _string;
var
  PKeyRecordSet: TGDSRecordSet;
  PKeyConnection: TGDSConnection;
  FetchedRows: Variant;
  RecBuf: IntPtr;
  Data: IntPtr;
  i: integer;
  IsBlank: boolean;
  ImplicitStart: boolean;
  ListCreated: boolean;
  FieldName: _string;
begin
  ListCreated := List = nil;
  if ListCreated then
    List := _TStringList.Create;
  try
    BeginConnection;
    try
      PKeyRecordSet := TGDSRecordSet.Create;
      try
        PKeyConnection := TIBCConnection(UsedConnection).FIConnection;
        PKeyRecordSet.SetConnection(PKeyConnection);
        PKeyRecordSet.SetTransaction(PKeyConnection.GetInternalTransaction);

        ImplicitStart := not PKeyConnection.GetInternalTransaction.GetInTransaction;
        if ImplicitStart then
          PKeyConnection.GetInternalTransaction.StartTransaction;

        PKeyRecordSet.SetSQL('SELECT RDB$FIELD_NAME, RDB$FIELD_POSITION' +
           ' FROM RDB$RELATION_CONSTRAINTS REL, RDB$INDEX_SEGMENTS IDX' +
           ' WHERE REL.RDB$INDEX_NAME = IDX.RDB$INDEX_NAME AND' +
           ' RDB$RELATION_NAME = '''  +  UnQuoteValue(TableName) + ''' AND RDB$CONSTRAINT_TYPE = ''PRIMARY KEY '''+
           ' ORDER BY RDB$FIELD_POSITION');
        PKeyRecordSet.SetProp(prFlatBuffers, False);
        PKeyRecordSet.Open;
        PKeyRecordSet.FetchAll;
        PKeyRecordSet.SetToBegin;
        PKeyRecordSet.GetProp(prRowsFetched, FetchedRows);

        PKeyRecordSet.AllocRecBuf(RecBuf);
        Data := Marshal.AllocHGlobal(250);  //Actual field definition is CHAR(67)
        try
          Result := '';
          for i := 0 to Integer(FetchedRows) - 1 do begin
            PKeyRecordSet.GetNextRecord(RecBuf);
            if PKeyRecordSet.Eof then
              break;
            PKeyRecordSet.GetField(1, RecBuf, Data, IsBlank);
            if IsBlank then
              continue;
            if TIBCConnection(UsedConnection).Options.UseUnicode then
              FieldName := Trim(_string(Marshal.PtrToStringUni(Data)))
            else
              FieldName := Trim(_string(Marshal.PtrToStringAnsi(Data)));
            List.Add(FieldName);
            Result := Result + ' ' + FieldName;
          end;
        finally
          PKeyRecordSet.FreeRecBuf(RecBuf);
          Marshal.FreeHGlobal(Data);
          PKeyRecordSet.Close;
          if ImplicitStart then
            PKeyConnection.GetInternalTransaction.Commit;
        end;
      finally
        PKeyRecordSet.Free;
      end;
    finally
      EndConnection;
    end;
  finally
    if ListCreated then
      List.Free;
  end;
end;

procedure TCustomIBCDataSet.InternalOpen;
begin
  {$IFDEF HAVE_COMPRESS}
  if not Options.CacheBlobs and ((Options.CompressBlobMode = cbClient) or (Options.CompressBlobMode = cbClientServer)) then
    raise Exception.Create(SCannotCompressNotCached);
  {$ENDIF}

  inherited;
end;

function TCustomIBCDataSet.Fetched: boolean;
begin
  Result := not Executing and inherited Fetched;
end;

procedure TCustomIBCDataSet.UnPrepare;
begin
  inherited;
end;

procedure TCustomIBCDataSet.CreateProcCall(const Name: _string);
begin
  InternalCreateProcCall(Name, True, False);
end;

function TCustomIBCDataSet.GetUpdateObject: TIBCUpdateSQL;
begin
  Result := TIBCUpdateSQL(inherited UpdateObject);
end;

procedure TCustomIBCDataSet.SetUpdateObject(Value: TIBCUpdateSQL);
begin
  inherited UpdateObject := Value;
end;

{ Fields }

function TCustomIBCDataSet.GetFieldType(DataType: word): TFieldType;
begin
  Result := inherited GetFieldType(DataType);
  if (Integer(Result) = ftIBCArray) and Options.FComplexArrayFields then
    Result := ftADT;
end;

function TCustomIBCDataSet.GetFieldType(FieldDesc: TFieldDesc): TFieldType;
begin
  if FieldDesc.SubDataType = dtDbKey then
    Result := TFieldType(ftIBCDbKey)
  else
    Result := inherited GetFieldType(FieldDesc);
end;

function TCustomIBCDataSet.GetFieldClass(FieldType: TFieldType): TFieldClass;
begin
  if Integer(FieldType) = ftIBCArray then
    Result := TIBCArrayField
  else
  if Integer(FieldType) = ftIBCDbKey then
    Result := TIBCDbKeyField
  else
    Result := inherited GetFieldClass(Fieldtype);
end;

{$IFNDEF FPC}
function TCustomIBCDataSet.GetFieldFullName(Field: TField): string;
begin
  Result := Field.FieldName;
end;
{$ENDIF}

function TCustomIBCDataSet.GetFielDefSize(FieldType: TFieldType; FieldDesc: TFieldDesc): integer;
begin
  Result := inherited GetFielDefSize(FieldType, FieldDesc);
  if Integer(FieldType) = ftIBCDbKey then
    Result := FieldDesc.Length;
end;

function TCustomIBCDataSet.GetObjectFieldDefName(Parent: TFieldDef; Index: integer; ObjType: TObjectType):_string;
var
  Len: integer;
begin
  Len := Length(Parent.Name);
  Result := Parent.Name;
  if Result[Len] = ']' then begin
    Result[Len] := ',';
    Result := Result + ' ' + IntToStr(TIBCArrayType(ObjType).LowBound + Index) + ']';
  end
  else
    Result := Result + '[' + IntToStr(TIBCArrayType(ObjType).LowBound + Index) + ']';
  //To correct DB.pas ADT name handling
  Parent.Attributes := Parent.Attributes + [faUnNamed];
end;

{ Edit }

procedure TCustomIBCDataSet.AssignFieldValue(Param: TDAParam; Field: TField; Old: boolean);
var
  FieldDesc: TFieldDesc;
begin
  if Field.DataType = ftMemo then begin
    FieldDesc := TCustomDADataSet(Field.DataSet).GetFieldDesc(Field);
    if (FieldDesc <> nil) and (FieldDesc.SubDataType = dtString) then begin
      Param.DataType := ftString;
      Param.AsString := Field.AsString;
      Exit;
    end;
  end
{$IFDEF VER10P}
  else
  if Field.DataType = ftWideMemo then begin
    FieldDesc := TCustomDADataSet(Field.DataSet).GetFieldDesc(Field);
    if (FieldDesc <> nil) and (FieldDesc.SubDataType = dtWideString) then begin
      Param.DataType := ftWideString;
      Param.AsWideString := {$IFDEF CLR}Field.AsString{$ELSE}Field.AsWideString{$ENDIF};
      Exit;
    end;
  end
{$ENDIF}
  ;

  inherited AssignFieldValue(Param, Field, Old);
end;

procedure TCustomIBCDataSet.CheckInactive;
begin
  inherited;
end;

function TCustomIBCDataSet.GetPlan: string;
var
  Val: Variant;
begin
  if FICommand <> nil then begin
    FICommand.GetProp(prPlan, Val);
    Result := Val;
  end
  else
    Result := '';
end;

{ Params }
function TCustomIBCDataSet.FindParam(const Value: _string): TIBCParam;
begin
  Result := Params.FindParam(Value);
end;

function TCustomIBCDataSet.ParamByName(const Value: _string): TIBCParam;
begin
  Result := Params.ParamByName(Value);
end;

{ Additional data types }
function TCustomIBCDataSet.GetBlob(const FieldName: _string): TIBCBlob;
var
  Field: TFieldDesc;
  IsBlank: boolean;
  RecBuf: TRecordBuffer;
  Ptr: IntPtr;
begin
  Ptr := Marshal.AllocHGlobal(sizeof(IntPtr));
  Marshal.WriteIntPtr(Ptr, nil);
  try
    if GetActiveRecBuf(RecBuf) then begin
      Field := Data.FieldByName(FieldName);
      if not ((Field.DataType = dtBlob) or
        (Field.DataType = dtMemo) and (Field.SubDataType <> dtString) or
        (Field.DataType = dtWideMemo) and (Field.SubDataType <> dtWideString))
      then
        DatabaseError(SNeedBlobType);

      Data.GetField(Field.FieldNo, RecBuf, Ptr, IsBlank);
      Result := TIBCBlob(GetGCHandleTarget(Marshal.ReadIntPtr(Ptr)));
    end
    else
      Result := nil;
  finally
    Marshal.FreeHGlobal(Ptr);
  end;
end;

function TCustomIBCDataSet.GetArray(FieldDesc: TFieldDesc): TIBCArray;
begin
  if not (FieldDesc.DataType = dtArray) then
    DatabaseError('SNeedArrayType');

  Result := TIBCArray(GetFieldObject(FieldDesc));
end;

function TCustomIBCDataSet.GetArray(const FieldName: _string): TIBCArray;
var
  Field: TFieldDesc;
begin
  Field := Data.FieldByName(FieldName);
  Result := GetArray(Field);
end;

procedure TCustomIBCDataSet.AssignTo(Dest: TPersistent);
begin
  inherited AssignTo(Dest);
end;

{ SQL modify }

function TCustomIBCDataSet.SQLAddWhere(SQLText, Condition: _string): _string;
begin
  Result := {$IFDEF CLR}Devart.IbDac.{$ENDIF}IBC.AddWhere(SQLText, Condition);
end;

function TCustomIBCDataSet.SQLDeleteWhere(SQLText: _string): _string;
begin
  Result := {$IFDEF CLR}Devart.IbDac.{$ENDIF}IBC.DeleteWhere(SQLText);
end;

function TCustomIBCDataSet.SQLSetOrderBy(SQLText: _string; Fields: _string): _string;
begin
  Result := {$IFDEF CLR}Devart.IbDac.{$ENDIF}IBC.SetOrderBy(SQLText, Fields)
end;

function TCustomIBCDataSet.SQLGetOrderBy(SQLText: _string): _string;
begin
  Result := {$IFDEF CLR}Devart.IbDac.{$ENDIF}IBC.GetOrderBy(SQLText);
end;

procedure TCustomIBCDataSet.SetModified(Value: Boolean);
begin
  inherited SetModified(Value);
end;

function TCustomIBCDataSet.GetActiveRecBuf(var RecBuf: TRecordBuffer): boolean;
begin
  result := inherited GetActiveRecBuf(RecBuf);
end;

function TCustomIBCDataSet.GetData: TData;
begin
  result := Data;
end;

{ IProviderSupport }

{ Provider helpers }

function TCustomIBCDataSet.GetConnection: TIBCConnection;
begin
  Result := TIBCConnection(inherited Connection);
end;

procedure TCustomIBCDataSet.SetConnection(const Value: TIBCConnection);
begin
  inherited Connection := Value;
end;

procedure TCustomIBCDataSet.SetIBCTransaction(const Value: TIBCTransaction);
begin
  inherited Transaction := Value;
end;

function TCustomIBCDataSet.GetIBCTransaction: TIBCTransaction;
begin
  Result := TIBCTransaction(inherited Transaction);
end;

function TCustomIBCDataSet.GetUpdateTransaction: TIBCTransaction;
begin
  Result := TIBCTransaction(inherited UpdateTransaction);
end;

procedure TCustomIBCDataSet.SetUpdateTransaction(const Value: TIBCTransaction);
begin
  inherited UpdateTransaction := Value;
end;

function TCustomIBCDataSet.GetParams: TIBCParams;
begin
  Result :=TIBCParams(inherited Params);
end;

procedure TCustomIBCDataSet.SetParams(const Value: TIBCParams);
begin
  inherited Params := Value;
end;

function TCustomIBCDataSet.GetRowsFetched: integer;
var
  Value: variant;
begin
  if FIRecordSet <> nil then begin
    FIRecordSet.GetProp(prRowsFetched, Value);
    Result := Value;
  end
  else
    Result := 0;
end;

function TCustomIBCDataSet.GetRowsInserted: integer;
var
  Value: variant;
begin
  if FICommand <> nil then begin
    FICommand.GetProp(prRowsInserted, Value);
    Result := Value;
  end
  else
    Result := 0;
end;

function TCustomIBCDataSet.GetRowsUpdated: integer;
var
  Value: variant;
begin
  if FICommand <> nil then begin
    FICommand.GetProp(prRowsUpdated, Value);
    Result := Value;
  end
  else
    Result := 0;
end;

function TCustomIBCDataSet.GetRowsDeleted: integer;
var
  Value: variant;
begin
  if FICommand <> nil then begin
    FICommand.GetProp(prRowsDeleted, Value);
    Result := Value;
  end
  else
    Result := 0;
end;

function TCustomIBCDataSet.GetSQLType: integer;
begin
  if FICommand <> nil then
    Result := FICommand.GetSQLType
  else
    Result := 0;
end;

function TCustomIBCDataSet.GetSQLTypeEx: integer;
begin
  if FICommand <> nil then
    Result := FICommand.GetSQLTypeEx
  else
    Result := 0;
end;

function TCustomIBCDataSet.GetCursor: string;
var
  Val: Variant;
begin
  if FIRecordSet <> nil then begin
    FIRecordSet.GetProp(prCursor, Val);
    Result := string(Val);
  end
  else
    Result := '';
end;

function TCustomIBCDataSet.GetOptions: TIBCDataSetOptions;
begin
  Result := TIBCDataSetOptions(inherited Options);
end;

procedure TCustomIBCDataSet.SetOptions(const Value: TIBCDataSetOptions);
begin
  Options.Assign(Value);
end;

function TCustomIBCDataSet.GetLockMode: TLockMode;
begin
  Result := TLockMode(inherited LockMode);
end;

procedure TCustomIBCDataSet.SetLockMode(Value: TLockMode);
begin
  inherited LockMode := DBAccess.TLockMode(Value);
end;

procedure TCustomIBCDataSet.SetKeyGenerator(const Value: _string);
begin
  FKeyGenerator := Trim(Value);
  if FDataSetService <> nil then
    FDataSetService.SetProp(prKeyGenerator, Variant(FKeyGenerator));
end;

procedure TCustomIBCDataSet.SetGeneratorMode(Value: TGeneratorMode);
begin
  FGeneratorMode := Value;
  if FDataSetService <> nil then
    FDataSetService.SetProp(prGeneratorMode, Variant(FGeneratorMode));
end;

procedure TCustomIBCDataSet.SetGeneratorStep(Value: integer);
begin
  FGeneratorStep := Value;
  if FDataSetService <> nil then
    FDataSetService.SetProp(prGeneratorStep, FGeneratorStep);
end;

function TCustomIBCDataSet.GetHandle: TISC_STMT_HANDLE;
begin
  if FICommand <> nil then
    Result := FICommand.GetStmtHandle
  else
    Result := nil;
end;

function TCustomIBCDataSet.UnQuoteValue(Value: _string): _string;
var
  Quoted: boolean;
begin
  Quoted := False;
  Result := Trim(Value);
  if (Result <> '') and (Result[1] = '"') and (Result[Length(Result)] = '"') then begin
    Quoted := True;
    {$IFDEF CLR}Borland.Delphi.{$ENDIF}System.Delete(Result, 1, 1);
    {$IFDEF CLR}Borland.Delphi.{$ENDIF}System.Delete(Result, Length(Result), 1);
  end;

  if (TIBCConnection(UsedConnection).SQLDialect = 1) or ((TIBCConnection(UsedConnection).SQLDialect = 3) and not Quoted) then
    Result := _UpperCase(Result);
end;

{$IFNDEF FPC}

function TCustomIBCDataSet.PSGetDefaultOrder: TIndexDef;

  function GetIndexForIdxNames: TIndexDef;
  var
    i: integer;
    CurrentField, Fields, DescFields: _string;
  begin
    Result := nil;
    if not(Active) then
      Active := True;
    Data.InitFields;
    if (TMemData(Data).IndexFields.Count > 0) then begin
      Result := TIndexDef.Create(nil);
      Fields := '';
      DescFields := '';
      for i := 0 to TMemData(Data).IndexFields.Count - 1 do begin
        CurrentField := TMemData(Data).IndexFields.Items[i].FieldDesc.Name;
        if Fields <> '' then
          Fields := Fields + ';' + CurrentField
        else
          Fields := CurrentField;
        if TMemData(Data).IndexFields.Items[i].DescendingOrder then
          if DescFields <> '' then
            DescFields := DescFields + ';' + CurrentField
          else
            DescFields := CurrentField;
      end;
      Result.Fields := Fields;
      Result.DescFields := DescFields;
      if Result.Fields = '' then
        begin
          Result.Free;
          Result := nil;
        end;
    end;
  end;

begin
  if KeyFields = '' then
    Result := inherited PSGetDefaultOrder
  else
    if Trim(IndexFieldNames) <> '' then
      Result := GetIndexForIdxNames
    else
      Result := GetIndexForOrderBy(GetFinalSQL, Self);
end;
{$ENDIF}

{ TCustomIBCQuery }

constructor TCustomIBCQuery.Create(Owner: TComponent);
begin
  inherited Create(Owner);
end;

destructor TCustomIBCQuery.Destroy;
begin
  inherited Destroy;
end;

procedure TCustomIBCQuery.InternalOpen;
begin
  inherited;

end;

procedure TCustomIBCQuery.InternalClose;
begin

  inherited;
end;

procedure TCustomIBCQuery.ExecSQL;
begin
  Execute;
end;

{ TCustomIBCTable }

{$IFNDEF FPC}
function TCustomIBCTable.PSGetTableName: string;
begin
  Result := TableName;
end;

procedure TCustomIBCTable.PSSetParams(AParams: DB.TParams);
var
  St: _string;
  i: integer;
begin
  if (Params.Count <> AParams.Count) then begin
    SQL.Text := '';
    St := '';

    for i := 0 to AParams.count - 1 do begin
      if St <> '' then
        St := St + ' AND ';
      St := St + AParams[i].Name + ' = :' + AParams[i].Name;
    end;

    PrepareSQL;

    if St <> '' then
      AddWhere(St);
  end;

  inherited;
end;

procedure TCustomIBCTable.PSSetCommandText(const CommandText: string);
begin
  if CommandText <> '' then
    TableName := CommandText;
end;
{$ENDIF}

procedure TCustomIBCTable.OpenCursor(InfoQuery: boolean);
begin
  PrepareSQL;

  inherited;
end;

procedure TCustomIBCTable.AssignTo(Dest: TPersistent);
begin
  inherited;

  if Dest is TCustomIBCTable then begin
    TCustomIBCTable(Dest).SQL.Text := SQL.Text;
    TCustomIBCTable(Dest).FTableName := TableName;
    TCustomIBCTable(Dest).OrderFields := OrderFields;
  end;
end;

procedure TCustomIBCTable.SetTableName(const Value: _string);
begin
  if FTableName <> Value then begin
    FTableName := '';
    if not (csLoading in ComponentState) then begin
      SQL.Text := '';

    if (AnsiUpperCase(KeyFields) <> 'RDB$DB_KEY') then
        KeyFields := '';
    end;  
    FTableName := Trim(Value);
  end;
end;

procedure TCustomIBCTable.SetOrderFields(const Value: _string);
var
  OldActive: boolean;
begin
  if Value <> OrderFields then begin
    OldActive := Active;

    FOrderFields := Value;

    if not (csLoading in ComponentState) then
      SQL.Text := '';

    if OldActive then
      Open;
  end;
end;

procedure TCustomIBCTable.SetReadOnly(Value: boolean);
begin
  if Value <> inherited ReadOnly then begin
    if not (csLoading in ComponentState) and (KeyFields = '') then
      SQL.Text:= '';

    inherited;
  end;
end;

procedure TCustomIBCTable.CheckSQL;
begin
  PrepareSQL;
end;

function TCustomIBCTable.GetFinalSQL: _string;
begin
  if (TableName <> '') and not (csLoading in ComponentState) then
    PrepareSQL;

  Result := inherited GetFinalSQL;
end;

function TCustomIBCTable.GetExists: boolean;
var
  Query: TCustomIBCDataSet;
begin
  Result := Active;

  if not Result then begin
    if UsedConnection = nil then
      DatabaseError(SConnectionNotDefined);
    Query := TCustomIBCDataSet(UsedConnection.CreateDataSet);
    try
      Query.SQL.Text := 'SELECT RDB$RELATION_NAME FROM RDB$RELATIONS WHERE RDB$RELATION_NAME = ' +
        '''' + UnQuoteValue(FTableName) + '''';
      Query.Open;
      Result := not Query.Eof;
      Query.Close;
    finally
      Query.Free;
    end;
  end;
end;

function TCustomIBCTable.SQLAutoGenerated: boolean;
begin
  Result := True;
end;

procedure TCustomIBCTable.PrepareSQL;
begin
  if SQL.Text = '' then begin
    if TableName = '' then
      DatabaseError(STableNameNotDefined);

    CheckDataSetService;
    SQL.Text := TIBCDataSetService(FDataSetService).SQLGenerator.GenerateTableSQL(TableName, OrderFields);
  end;
end;

procedure TCustomIBCTable.Prepare;
begin
  PrepareSQL;

  inherited;
end;

procedure TCustomIBCTable.Execute;
begin
  PrepareSQL;

  inherited;
end;

procedure TCustomIBCTable.EmptyTable;
var
  Query: TIBCSQL;
begin
  if TableName = '' then
    DatabaseError(STableNameNotDefined);

  BeginConnection;
  try
    Query := TIBCSQL(TIBCConnection(UsedConnection).CreateSQL);
    try
      Query.Transaction := TIBCTransaction(UsedUpdateTransaction);
      CheckDataSetService;
      Query.SQL.Text := 'DELETE FROM ' + TIBCDataSetService(FDataSetService).NormalizeStrValue(TableName);
      Query.Execute;
    finally
      Query.Free;
    end;

    if Active then
      Refresh;
  finally
    EndConnection;
  end;
end;

procedure TCustomIBCTable.DeleteTable;
var
  Query: TIBCSQL;
begin
  if TableName = '' then
    DatabaseError(STableNameNotDefined);

  BeginConnection;
  try
    CheckInactive;

    Query := TIBCSQL(TIBCConnection(UsedConnection).CreateSQL);
    try
      Query.Transaction := TIBCTransaction(UsedUpdateTransaction);
      CheckDataSetService;
      Query.SQL.Text := 'DROP TABLE ' + TIBCDataSetService(FDataSetService).NormalizeStrValue(TableName);
      Query.Execute;
    finally
      Query.Free;
    end;
  finally
    EndConnection;
  end;
end;

{ TIBCUpdateSQL }

function TIBCUpdateSQL.DataSetClass: TCustomDADataSetClass;
begin
  Result := TCustomIBCDataSet;
end;

function TIBCUpdateSQL.SQLClass: TCustomDASQLClass;
begin
  Result := TIBCSQL;
end;

{ TIBCMetaData }

function TIBCMetaData.GetTransaction: TDATransaction;
var
  vConnection: TIBCConnection;
begin
  Result := inherited GetTransaction;

  if Result = nil then begin
    vConnection := Connection;
    if (vConnection <> nil) and (vConnection.DefaultTransaction <> nil) then
      Result := vConnection.DefaultTransaction
  end;
end;

procedure TIBCMetaData.SetTransaction(Value: TDATransaction);
var
  IsChanged: boolean;
begin
  IsChanged := Value <> UsedTransaction;
  if (UsedTransaction <> nil) and IsChanged then
    Close;

  inherited;
end;

function TIBCMetaData.GetConnection: TIBCConnection;
begin
  Result := TIBCConnection(inherited Connection);
end;

procedure TIBCMetaData.SetConnection(Value: TIBCConnection);
begin
  inherited Connection := Value;
end;

function TIBCMetaData.GetIBCTransaction: TIBCTransaction;
begin
  Result := TIBCTransaction(inherited Transaction);
end;

procedure TIBCMetaData.SetIBCTransaction(Value: TIBCTransaction);
begin
  inherited Transaction := Value;
end;

{ TIBCArray }

constructor TIBCArray.Create(DbHandle: TISC_DB_HANDLE; TrHandle: TISC_TR_HANDLE; Field: TField);
var
  FieldDesc: TFieldDesc;
begin
  Assert(Field.DataSet is TCustomIBCDataSet, 'Field.DataSet is not TCustomIBCDataSet');
  FieldDesc := TCustomIBCDataSet(Field.DataSet).GetFieldDesc(Field);
  Create(DbHandle, TrHandle, GenerateTableName(FieldDesc), FieldDesc.ActualName);
end;

constructor TIBCArray.Create(Connection: TGDSConnection; Transaction: TGDSTransaction; Field: TField);
var
  FieldDesc: TFieldDesc;
begin
  Assert(Field.DataSet is TCustomIBCDataSet, 'Field.DataSet is not TCustomIBCDataSet');
  FieldDesc := TCustomIBCDataSet(Field.DataSet).GetFieldDesc(Field);
  Create(Connection, Transaction, GenerateTableName(FieldDesc), FieldDesc.ActualName);
end;

function TIBCArray.GetItemType: TFieldType;
begin
  Result := TIBCDataTypesMap.GetFieldType(FInternalItemType);
end;

procedure TIBCArray.SetItemType(Value: TFieldType);
begin
  case Value of
    ftFloat: begin
      FDescAccessor.DataType := blr_double;
      FDescAccessor.Length := SizeOf(double);
    end;
    ftInteger: begin
      FDescAccessor.DataType := blr_long;
      FDescAccessor.Length := SizeOf(integer);
    end;
    ftSmallInt: begin
      FDescAccessor.DataType := blr_short;
      FDescAccessor.Length := SizeOf(SmallInt);
    end;
    ftBoolean: begin
      FDescAccessor.DataType := blr_boolean_dtype;
      FDescAccessor.Length := SizeOf(WordBool);
    end;
    ftDate: begin
      FDescAccessor.DataType := blr_sql_date;
      FDescAccessor.Length := SizeOf(integer);
    end;
    ftTime: begin
      FDescAccessor.DataType := blr_sql_time;
      FDescAccessor.Length := SizeOf(integer);
    end;
    ftDateTime: begin
      FDescAccessor.DataType := blr_timestamp;
      FDescAccessor.Length := SizeOf(double);
    end;
    ftString: begin
      FDescAccessor.DataType :=  blr_varying;
      FDescAccessor.Length := 0;
    end;
    else
      raise Exception.Create(SDataTypeNotSupported);
  end;
  FInternalItemType := GetInternalItemType;
end;

function DefaultConnection: TIBCConnection;
begin
  Result := DefConnection;
end;

initialization
  DefConnection := nil;
  UseDefConnection := True;
  Connections := TConnectionList.Create;

 if
  {$IFDEF CLR}
    CompareText(Assembly.GetCallingAssembly.GetName.Name, 'Devart.IBDac') = 0
  {$ELSE}
    not IsLibrary
  {$ENDIF}
  then begin
    Classes.RegisterClass(TIBCArrayField);
    Classes.RegisterClass(TIBCDbKeyField);
  end;  

finalization
  if Connections <> nil then begin
    DisconnectConnections;
    Connections.Free;
    Connections := nil;
  end;
end.
