
//////////////////////////////////////////////////
//  InterBase Data Access Components
//  Copyright © 1998-2011 Devart. All right reserved.
//////////////////////////////////////////////////

//{$A8}
//{$R-}

{$IFNDEF CLR}
{$IFNDEF UNIDACPRO}
{$I IbDac.inc}
unit IBCAdmin;
{$ENDIF}
{$ENDIF}

interface

uses
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
{$IFDEF CLR}
  System.Runtime.InteropServices, System.Threading, System.IO, System.Text,
{$ELSE}
  CLRClasses,
{$ENDIF}
  SysUtils, Classes, Contnrs, DB,
  CRTypes, MemUtils, CRAccess, DBAccess,
  IBCCall, IBC;

{$IFNDEF STD}

const
  DefaultBufferSize = 32000;
  SPBPrefix = 'isc_spb_';
  SPBConstantNames: array[1..isc_spb_last_spb_constant] of string = (
    'user_name',
    'sys_user_name',
    'sys_user_name_enc',
    'password',
    'password_enc',
    'command_line',
    'db_name',
    'verbose',
    'options',
    'connect_timeout',
    'dummy_packet_interval',
    'sql_role_name',
    'instance_name');

  SPBConstantValues: array[1..isc_spb_last_spb_constant] of Integer = (
    isc_spb_user_name_mapped_to_server,
    isc_spb_sys_user_name_mapped_to_server,
    isc_spb_sys_user_name_enc_mapped_to_server,
    isc_spb_password_mapped_to_server,
    isc_spb_password_enc_mapped_to_server,
    isc_spb_command_line_mapped_to_server,
    isc_spb_dbname_mapped_to_server,
    isc_spb_verbose_mapped_to_server,
    isc_spb_options_mapped_to_server,
    isc_spb_connect_timeout_mapped_to_server,
    isc_spb_dummy_packet_interval_mapped_to_server,
    isc_spb_sql_role_name_mapped_to_server,
    isc_spb_instance_name_mapped_to_server);

type
  TCustomIBCService = class;

  TCustomIBCService = class(TComponent)
  private
    FGDS: TGDS;
    FParams: TStrings;
    FParamsChanged: Boolean;
    FSPB: TBytes;
    FSPBLength: UShort;
    FStartSPB: TBytes;
    FStartSPBLength: UShort;
    FBufferSize: Integer;
    FHandle: PISC_SVC_HANDLE;
    FStatusVector: TStatusVector;
    FLastError: integer;
    FLoginPrompt: Boolean;
    FConnectDialog: TCustomConnectDialog;
    FStreamedActive : Boolean;
    FProtocol: TIBCProtocol;
    FServer: string;
    FDatabase: string;
    FUsername: _string;
    FPassword: _string;
    FClientLibrary: string;
    FOnAttach: TNotifyEvent;
    FOnError: TCRErrorProc;

    function GetActive: Boolean;
    procedure SetActive(const Value: Boolean);
    procedure SetBufferSize(const Value: Integer);
    procedure SetUsername(const Value: _string);
    procedure SetPassword(const Value: _string);
    function GetClientLibrary: string;
    procedure SetClientLibrary(Value: string);
    procedure SetServer(const Value: string);
    procedure SetProtocol(const Value: TIBCProtocol);
    procedure SetConnectDialog(Value: TCustomConnectDialog);
    procedure SetParams(Value: TStrings);
    procedure ParamsChange(Sender: TObject);
    procedure ParamsChanging(Sender: TObject);
    function GetServiceParamBySPB(const Idx: Integer): string;
    procedure SetServiceParamBySPB(const Idx: Integer; const Value: string);
    function IndexOfSPBConst(const SPB: string): Integer;

    procedure Check(Status: ISC_STATUS);
    procedure GenerateSPB;
    function GetHandle: TISC_SVC_HANDLE;
    function GetIsServiceRunning: Boolean;

  protected
    FOutputBuffer: IntPtr;

    function Login: Boolean;
    procedure Loaded; override;
    procedure CheckActive;
    procedure CheckInactive;
    procedure DoServerChange; virtual;

    function ParseString(var CurPos: Integer): string;
    function ParseInteger(var CurPos: Integer): Integer;
    procedure InternalServiceQuery(const QParam: Byte); overload;
    procedure InternalServiceQuery(const QParams: TBytes); overload;
    procedure SetServiceStartOptions; virtual;
    procedure InitServiceStartParams(Param: Byte);
    procedure AddServiceStartParam(Param: Byte; const Value: string); overload;
    procedure AddServiceStartParam(Param: Byte; Value: Byte = 0); overload;
    procedure AddServiceStartParam32(Param: Byte; Value: Integer);
    procedure InternalServiceStart;
    function CreateConnection(const Database: string): TIBCConnection;
    property GDS: TGDS read FGDS;
    property BufferSize: Integer read FBufferSize write SetBufferSize default DefaultBufferSize;
    property Database: string read FDatabase write FDatabase;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Attach;
    procedure Detach;
    procedure ServiceStart; virtual;

    property Handle: TISC_SVC_HANDLE read GetHandle;
    property ServiceParamBySPB[const Idx: Integer]: string read GetServiceParamBySPB
                                                      write SetServiceParamBySPB;
    property IsServiceRunning: Boolean read GetIsServiceRunning;
  published
    property Active: Boolean read GetActive write SetActive default False;
    property Server: string read FServer write SetServer;
    property Protocol: TIBCProtocol read FProtocol write SetProtocol default TCP;
    property Params: TStrings read FParams write SetParams;
    property LoginPrompt: Boolean read FLoginPrompt write FLoginPrompt default True;
    property ConnectDialog: TCustomConnectDialog read FConnectDialog write SetConnectDialog;
    property Username: _string read FUsername write SetUsername;
    property Password: _string read FPassword write SetPassword;
    property ClientLibrary: string read GetClientLibrary write SetClientLibrary;

    property OnAttach: TNotifyEvent read FOnAttach write FOnAttach;
    property OnError: TCRErrorProc read FOnError write FOnError;
  end;

  TIntegerDynArray = array of Integer;
  TStringDynArray  = array of string;

  TIBCDatabaseInfo = class
  private
    FNoOfAttachments: integer;
    FNoOfDatabases: integer;
    FDbName: TStringDynArray;
  public
    property NoOfAttachments: integer read FNoOfAttachments;
    property NoOfDatabases: integer read FNoOfDatabases;
    property DbName: TStringDynArray read FDbName;
  end;

  TIBCLicenseInfo = class
  private
    FKey: TStringDynArray;
    FId: TStringDynArray;
    FDesc: TStringDynArray;
    FLicensedUsers: integer;
  public
    property Key: TStringDynArray read FKey;
    property Id: TStringDynArray read FId;
    property Desc: TStringDynArray read FDesc;
    property LicensedUsers: integer read FLicensedUsers;
  end;

  TIBCLicenseMaskInfo = class
  private
    FLicenseMask: integer;
    FCapabilityMask: integer;
  public
    property LicenseMask: integer read FLicenseMask;
    property CapabilityMask: integer read FCapabilityMask;
  end;

  TIBCConfigParams = class
  private
    FConfigFileValue: TIntegerDynArray;
    FConfigFileKey: TIntegerDynArray;
    FBaseLocation: string;
    FLockFileLocation: string;
    FMessageFileLocation: string;
    FSecurityDatabaseLocation: string;
  public
    property ConfigFileValue: TIntegerDynArray read FConfigFileValue;
    property ConfigFileKey: TIntegerDynArray read FConfigFileKey;
    property BaseLocation: string read FBaseLocation;
    property LockFileLocation: string read FLockFileLocation;
    property MessageFileLocation: string read FMessageFileLocation;
    property SecurityDatabaseLocation: string read FSecurityDatabaseLocation;
  end;

  TIBCVersionInfo = class
  private
    FServerVersion: string;
    FServerImplementation: string;
    FServiceVersion: integer;
  public
    property ServerVersion: string read FServerVersion;
    property ServerImplementation: string read FServerImplementation;
    property ServiceVersion: integer read FServiceVersion;
  end;

  TIBCAliasInfo = class
  private
    FAlias: string;
    FDBPath: string;
  public
    property Alias: string read FAlias;
    property DBPath: string read FDBPath;
  end;

  TIBCPropertyOption = (poDatabase, poLicense, poLicenseMask, poConfigParameters,
                        poVersion, poDBAlias);
  TIBCPropertyOptions = set of TIBCPropertyOption;

{$IFDEF VER16P}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32)]
{$ENDIF}
  TIBCServerProperties = class(TCustomIBCService)
  private
    FOptions: TIBCPropertyOptions;
    FConfigParams: TIBCConfigParams;
    FDatabaseInfo: TIBCDatabaseInfo;
    FLicenseInfo: TIBCLicenseInfo;
    FLicenseMaskInfo: TIBCLicenseMaskInfo;
    FVersionInfo: TIBCVersionInfo;
    FAliasInfoList: TObjectList;
    function GetAliasCount: Integer;
    function GetAliasInfo(Index: Integer): TIBCAliasInfo;
  protected
    procedure DoServerChange; override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Fetch;
    procedure FetchConfigParams;
    procedure FetchDatabaseInfo;
    procedure FetchLicenseInfo;
    procedure FetchLicenseMaskInfo;
    procedure FetchVersionInfo;
    procedure FetchAliasInfo;
    procedure AddAlias(const Alias, DBPath: string);
    procedure DeleteAlias(const Alias: string);

    property AliasCount: Integer read GetAliasCount;
    property AliasInfo[Index: Integer]: TIBCAliasInfo read GetAliasInfo;
    property ConfigParams: TIBCConfigParams read FConfigParams;
    property DatabaseInfo: TIBCDatabaseInfo read FDatabaseInfo;
    property LicenseInfo: TIBCLicenseInfo read FLicenseInfo;
    property LicenseMaskInfo: TIBCLicenseMaskInfo read FLicenseMaskInfo;
    property VersionInfo: TIBCVersionInfo read FVersionInfo;
  published
    property Options: TIBCPropertyOptions read FOptions write FOptions;
  end;

  TIBCJournalInformation = class(TComponent)
  private
    FDirectory: string;
    FHasArchive: Boolean;
    FHasJournal: Boolean;
    FCheckpointInterval: Integer;
    FCheckpointLength: Integer;
    FPageCache: Integer;
    FPageLength: Integer;
    FPageSize: Integer;
    FTimestampName: Boolean;

  public
    constructor Create(AOwner: TComponent); override;
    function CreateJournalAttributes: string;
    function CreateJournalLength: string;
  published
    property Directory: string read FDirectory write FDirectory;
    property HasArchive: Boolean read FHasArchive;
    property HasJournal: Boolean read FHasJournal;
    property CheckpointInterval: Integer read FCheckpointInterval write FCheckpointInterval default 0;
    property CheckpointLength: Integer read FCheckpointLength write FCheckpointLength default 500;
    property PageCache: Integer read FPageCache write FPageCache default 100;
    property PageLength: Integer read FPageLength write FPageLength default 500;
    property PageSize: Integer read FPageSize write FPageSize default 0;
    property TimestampName: Boolean read FTimestampName write FTimestampName default True;
  end;

  TIBCShutdownMode = (smForced, smDenyTransaction, smDenyAttachment);

{$IFDEF VER16P}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32)]
{$ENDIF}
  TIBCConfigService = class(TCustomIBCService)
  private
    FTransaction: TIBCTransaction;
    FConnection: TIBCConnection;
    FJournalInformation: TIBCJournalInformation;
    procedure SetTransactionParams(Transaction: TIBCTransaction);
  protected
    procedure CongigServiceStart(Param: Byte; Value: Byte);
    procedure Congig32ServiceStart(Param: Byte; Value: Integer);
    procedure ExecuteSQL(const SQL: string);

  public
    constructor Create(AOwner: TComponent); override;
    procedure ServiceStart; override;

    procedure ActivateShadow;
    procedure BringDatabaseOnline;
    procedure SetDBSqlDialect(Value: Integer);
    procedure SetPageBuffers(Value: Integer);
    procedure SetSweepInterval(Value: Integer);
    procedure SetAsyncMode(Value: Boolean);
    procedure SetReadOnly(Value: Boolean);
    procedure SetReserveSpace(Value: Boolean);
    procedure ShutdownDatabase(Options: TIBCShutdownMode; Wait: Integer);
    procedure SweepDatabase;
    procedure SetGroupCommit(Value: Boolean);
    procedure SetLingerInterval(Value: Integer);
    procedure SetFlushInterval(Value: Integer);
    procedure SetReclaimInterval(Value: Integer);
    procedure FlushDatabase;
    procedure DisableFlush;
    procedure ReclaimMemory;

    procedure CreateJournal;
    procedure AlterJournal;
    procedure DropJournal;
    procedure CreateJournalArchive(const Directory: string);
    procedure DropJournalArchive;
    procedure GetJournalInformation;

  published
    property Database;
    property Connection: TIBCConnection read FConnection write FConnection;
    property Transaction: TIBCTransaction read FTransaction write FTransaction;
    property JournalInformation: TIBCJournalInformation read FJournalInformation;
  end;

  TIBCLicensingAction = (laAdd, laRemove);

{$IFDEF VER16P}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32)]
{$ENDIF}
  TIBCLicensingService = class(TCustomIBCService)
  private
    FKey: string;
    FID: string;
    FAction: TIBCLicensingAction;
    procedure SetAction(Value: TIBCLicensingAction);
  protected
    procedure SetServiceStartOptions; override;

  public
    procedure AddLicense;
    procedure RemoveLicense;

  published
    property Action: TIBCLicensingAction read FAction write SetAction default laAdd;
    property Key: string read FKey write FKey;
    property ID: string read FID write FID;
  end;

  TIBCControlAndQueryService = class(TCustomIBCService)
  private
    FEof: Boolean;
    FAction: Integer;
    procedure SetAction(Value: Integer);
  protected
    property Action: Integer read FAction write SetAction;

  public
    constructor Create(AOwner: TComponent); override;
    function GetNextLine: string;
    function GetNextChunk: string;
    property Eof: Boolean read FEof;

  published
    property BufferSize;
  end;

{$IFDEF VER16P}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32)]
{$ENDIF}
  TIBCLogService = class(TIBCControlAndQueryService)
  protected
    procedure SetServiceStartOptions; override;
  end;

  TIBCStatOption = (soDataPages, soDbLog, soHeaderPages, soIndexPages,
                    soSystemRelations, soRecordVersions, soStatTables);
  TIBCStatOptions = set of TIBCStatOption;

{$IFDEF VER16P}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32)]
{$ENDIF}
  TIBCStatisticalService = class(TIBCControlAndQueryService)
  private
    FOptions: TIBCStatOptions;
    FTableNames: string;
  protected
    procedure SetServiceStartOptions; override;

  published
    property Database;
    property Options: TIBCStatOptions read FOptions write FOptions;
    property TableNames: string read FTableNames write FTableNames;
  end;

  TIBCNBackupOption = (nboNoTriggers);
  TIBCNBackupOptions = set of TIBCNBackupOption;

  TIBCBackupRestoreService = class(TIBCControlAndQueryService)
  private
    FVerbose: Boolean;
    FBackupFile: TStrings;
    FUseNBackup: boolean;
    FNBackupLevel: integer;
    FNBackupOptions: TIBCNBackupOptions;

    procedure SetBackupFile(Value: TStrings);

  public
    property Verbose: Boolean read FVerbose write FVerbose default False;
    property BackupFile: TStrings read FBackupFile write SetBackupFile;
    property UseNBackup: boolean read FUseNBackup write FUseNBackup default False;
    property NBackupLevel: integer read FNBackupLevel write FNBackupLevel default 0;
    property NBackupOptions: TIBCNBackupOptions read FNBackupOptions write FNBackupOptions default [];
  end;

  TIBCBackupOption = (boIgnoreChecksums, boIgnoreLimbo, boMetadataOnly,
    boNoGarbageCollection, boOldMetadataDesc, boNonTransportable, boConvertExtTables);
  TIBCBackupOptions = set of TIBCBackupOption;

{$IFDEF VER16P}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32)]
{$ENDIF}
  TIBCBackupService = class(TIBCBackupRestoreService)
  private
    FBlockingFactor: Integer;
    FOptions: TIBCBackupOptions;

  protected
    procedure SetServiceStartOptions; override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  published
    property Database;
    property BackupFile;
    property Verbose;
    property UseNBackup;
    property NBackupLevel;
    property NBackupOptions;
    property BlockingFactor: Integer read FBlockingFactor write FBlockingFactor default 0;
    property Options: TIBCBackupOptions read FOptions write FOptions default [];
  end;

  TIBCRestoreOption = (roDeactivateIndexes, roNoShadow, roNoValidityCheck,
    roOneRelationAtATime, roReplace, roCreateNewDB, roUseAllSpace, roValidationCheck);
  TIBCRestoreOptions = set of TIBCRestoreOption;

{$IFDEF VER16P}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32)]
{$ENDIF}
  TIBCRestoreService = class(TIBCBackupRestoreService)
  private
    FDatabase: TStrings;
    FPageSize: Integer;
    FPageBuffers: Integer;
    FOptions: TIBCRestoreOptions;

    procedure SetDatabase(Value: TStrings);

  protected
    procedure SetServiceStartOptions; override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  published
    property Verbose;
    property BackupFile;
    property UseNBackup;
    property NBackupLevel;
    property NBackupOptions;
    property Database: TStrings read FDatabase write SetDatabase;
    property PageSize: Integer read FPageSize write FPageSize default 4096;
    property PageBuffers: Integer read FPageBuffers write FPageBuffers default 0;
    property Options: TIBCRestoreOptions read FOptions write FOptions default [roCreateNewDB];
  end;

  TIBCValidateOption = (voCheckDB, voIgnoreChecksum, voKillShadows,
                        voMendDB, voValidateDB, voValidateFull);
  TIBCValidateOptions = set of TIBCValidateOption;

  TIBCTransactionGlobalAction = (tgNoGlobalAction, tgCommitGlobal, tgRollbackGlobal);
  TIBCTransactionState = (tsLimboState, tsCommitState, tsRollbackState, tsUnknownState);
  TIBCTransactionAdvise = (taCommitAdvise, taRollbackAdvise, taUnknownAdvise);
  //TIBCTransactionAction = (taCommitAction, taRollbackAction);

  TIBCLimboTransactionInfo = class
  private
    FMultiDatabase: boolean;
    FID: integer;
    FHostSite: string;
    FRemoteSite: string;
    FRemoteDatabasePath: string;
    FState: TIBCTransactionState;
    FAdvise: TIBCTransactionAdvise;
    FAction: TIBCTransactionAction;
  public
    property MultiDatabase: boolean read FMultiDatabase;
    property ID: integer read FID;
    property HostSite: string read FHostSite;
    property RemoteSite: string read FRemoteSite;
    property RemoteDatabasePath: string read FRemoteDatabasePath;
    property State: TIBCTransactionState read FState;
    property Advise: TIBCTransactionAdvise read FAdvise;
    property Action: TIBCTransactionAction read FAction;
  end;

{$IFDEF VER16P}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32)]
{$ENDIF}
  TIBCValidationService = class(TIBCControlAndQueryService)
  private
    FOptions: TIBCValidateOptions;
    FGlobalAction: TIBCTransactionGlobalAction;
    FRecoverTwoPhaseGlobal: Boolean;
    FLimboTransactionInfoList: TObjectList;
    function GetLimboTransactionInfo(Index: Integer): TIBCLimboTransactionInfo;
    function GetLimboTransactionInfoCount: Integer;
  protected
    procedure SetServiceStartOptions; override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure SweepDatabase;
    procedure FetchLimboTransactionInfo;
    procedure FixLimboTransactionErrors;
    property LimboTransactionInfo[Index: Integer]: TIBCLimboTransactionInfo read GetLimboTransactionInfo;
    property LimboTransactionInfoCount: Integer read GetLimboTransactionInfoCount;

  published
    property Database;
    property Options: TIBCValidateOptions read FOptions write FOptions default [];
    property GlobalAction: TIBCTransactionGlobalAction read FGlobalAction write FGlobalAction default tgNoGlobalAction;
    property RecoverTwoPhaseGlobal: Boolean read FRecoverTwoPhaseGlobal write FRecoverTwoPhaseGlobal;
  end;

  TIBCUserModifiedParam = (umPassword, umFirstName, umMiddleName, umLastName,
                           umUserId, umGroupId, umSystemUserName, umGroupName,
                           umDefaultRole, umDescription, umSQLRole, umActiveUser);
  TIBCUserModifiedParams = set of TIBCUserModifiedParam;

  TIBCUserInfo = class
  private
    FUserName: string;
    FPassword: string;
    FFirstName: string;
    FMiddleName: string;
    FLastName: string;
    FUserID: Integer;
    FGroupID: Integer;
    FGroupName: string;
    FSystemUserName: string;
    FDefaultRole: string;
    FDescription: string;
    FSQLRole: string;
    FActiveUser: Boolean;
    FModifiedParams: TIBCUserModifiedParams;

    procedure SetPassword(const Value: string);
    procedure SetFirstName(const Value: string);
    procedure SetMiddleName(const Value: string);
    procedure SetLastName(const Value: string);
    procedure SetUserID(Value: Integer);
    procedure SetGroupID(Value: Integer);
    procedure SetGroupName(const Value: string);
    procedure SetSystemUserName(const Value: string);
    procedure SetDefaultRole(const Value: string);
    procedure SetDescription(const Value: string);
    procedure SetSQLRole(const Value: string);
    procedure SetActiveUser(Value: Boolean);
  protected
    procedure Clear;
    property ModifiedParams: TIBCUserModifiedParams read FModifiedParams;

  public
    property UserName: string read FUserName write FUserName;
    property Password: string read FPassword write SetPassword;
    property FirstName: string read FFirstName write SetFirstName;
    property MiddleName: string read FMiddleName write SetMiddleName;
    property LastName: string read FLastName write SetLastName;
    property UserID: Integer read FUserID write SetUserID;
    property GroupID: Integer read FGroupID write SetGroupID;
    property GroupName: string read FGroupName write SetGroupName;
    property SystemUserName: string read FSystemUserName write SetSystemUserName;
    property DefaultRole: string read FDefaultRole write SetDefaultRole;
    property Description: string read FDescription write SetDescription;
    property SQLRole: string read FSQLRole write SetSQLRole;
    property ActiveUser: Boolean read FActiveUser write SetActiveUser;
  end;

  TIBCSecurityAction = (saAddUser, saDeleteUser, saModifyUser, saDisplayUser);

{$IFDEF VER16P}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32)]
{$ENDIF}
  TIBCSecurityService = class(TIBCControlAndQueryService)
  private
    FSecurityAction: TIBCSecurityAction;
    FUserDatabase: string;
    FUserInfoList: TObjectList;
    FUserInfo: TIBCUserInfo;

    procedure SetSecurityAction(Value: TIBCSecurityAction);
    function GetUserInfo(Index: Integer): TIBCUserInfo;
    function GetUserInfosCount: Integer;
    procedure FetchUserInfo;

  protected
    procedure Loaded; override;
    procedure ExecuteSQL(const SQL: string);
    procedure SetServiceStartOptions; override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure AddUser;
    procedure ModifyUser;
    procedure DeleteUser;
    procedure DisplayUsers;
    procedure DisplayUser(const UserName: string);
    procedure EnableEUA(Value: Boolean);
    procedure SuspendEUA(Value: Boolean);

    property UserInfos[Index: Integer]: TIBCUserInfo read GetUserInfo;
    property UserInfosCount: Integer read GetUserInfosCount;

  published
    property SecurityAction: TIBCSecurityAction read FSecurityAction
      write SetSecurityAction default saAddUser;
    property UserDatabase: string read FUserDatabase write FUserDatabase;
    property UserInfo: TIBCUserInfo read FUserInfo;
  end;

{$IFDEF VER16P}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32)]
{$ENDIF}
  TIBCTraceService = class(TIBCControlAndQueryService)
  private
    FConfig: TStringList;
    FSessionName: string;

    function GetConfig: TStrings;
    procedure SetConfig(Value: TStrings);

  protected
    procedure SetServiceStartOptions; override;
    procedure TraceAction(AnAction, SessionID: integer);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure StartTrace;
    procedure StopTrace(SessionID: integer);
    procedure SuspendTrace(SessionID: integer);
    procedure ResumeTrace(SessionID: integer);
    procedure ListTraceSessions;

  published
    property SessionName: string read FSessionName write FSessionName;
    property Config: TStrings read GetConfig write SetConfig;
  end;

{$ENDIF}

implementation

{$IFNDEF STD}

uses
  Math, IBCError, IBCConsts, IBCClasses, IBCSQLMonitor;

function GetFullODS(DatabaseInfo: TGDSDatabaseInfo): Extended;
begin
  Result := DatabaseInfo.ODSMinorVersion;
  while Result >= 1 do
    Result := Result / 10;
  Result := Result + DatabaseInfo.ODSMajorVersion;
end;

{ TCustomIBCService }

function TCustomIBCService.Login: Boolean;
var
  Dialog: TCustomConnectDialog;
  Connection: TIBCConnection;
begin
  Result := True;
  if Assigned(DefConnectDialogClassProc) then begin
    Connection := nil;
    if FConnectDialog = nil then
      Dialog := TConnectDialogClass(DefConnectDialogClassProc).Create(nil)
    else
      Dialog := FConnectDialog;
    try
      Connection := TIBCConnection.Create(nil);
      Connection.Server := Server;
      Connection.Database := Database;
      Connection.Options.Protocol := Protocol;
      Connection.Username := Username;
      Connection.Password := Password;

      TDBAccessUtils.SetConnection(Dialog, Connection);
      TDBAccessUtils.SetNeedConnect(Dialog, False);
      Result := Dialog.Execute;

      Server := Connection.Server;
      Database := Connection.Database;
      Protocol := Connection.Options.Protocol;
      Username := Connection.Username;
      Password := Connection.Password;
    finally
      if FConnectDialog = nil then
        Dialog.Free;
      Connection.Free;
    end;
  end;
end;

constructor TCustomIBCService.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FProtocol := TCP;
  FLoginPrompt := True;
  FParams := TStringList.Create;
  FParamsChanged := True;
  TStringList(FParams).OnChanging := ParamsChanging;
  TStringList(FParams).OnChange := ParamsChange;

  FStatusVector := Marshal.AllocHGlobal(20 * SizeOf(ISC_Status));
  FHandle := Marshal.AllocHGlobal(SizeOf(TISC_SVC_HANDLE));
  Marshal.WriteIntPtr(FHandle, nil);
  FOutputBuffer := nil;
  FBufferSize := DefaultBufferSize;
end;

destructor TCustomIBCService.Destroy;
begin
  if GetHandle <> nil then
    Detach;

  Marshal.FreeHGlobal(FOutputBuffer);
  Marshal.FreeHGlobal(FHandle);
  Marshal.FreeHGlobal(FStatusVector);
  FParams.Free;

  inherited;
end;

procedure TCustomIBCService.Check(Status: ISC_STATUS);
var
  Msg, SqlErrMsg: _string;
  ErrorNumber, ErrorCode: integer;
  Fail: boolean;
begin
  if Status > 0 then begin
    ErrorCode := GDS.isc_sqlcode(FStatusVector);
    GDS.GetIBError(ErrorCode, False, ErrorNumber, FStatusVector, Msg, SqlErrMsg);
    FLastError := ErrorCode;
    try
      raise EIBCError.Create(FLastError, ErrorNumber, Msg, SqlErrMsg);
    except
      on E: EIBCError do begin
        Fail := True;
        if Assigned(OnError) then
          OnError(E, Fail);
        if Fail then
          raise
        else
          Abort;
      end;
    end;
  end;
end;

procedure TCustomIBCService.GenerateSPB;
  procedure CheckSPBSize(NeededSize: integer; var SPBSize: integer);
  begin
    if SPBSize < NeededSize then begin
      SPBSize := ((NeededSize div 2048) + 1) * 2048;
      SetLength(FSPB, SPBSize);
    end;
  end;

var
  i, j: integer;
  SPBVal, SPBServerVal: UShort;
  ParamName, ParamValue: string;
  SPBSize: integer;
begin
  SPBSize := 2048; //Start size that must cover common user needs
  SetLength(FSPB, SPBSize);
  FSPBLength := 2;
  FSPB[0] := isc_spb_version;
  FSPB[1] := isc_spb_current_version;
  try
    CheckSPBSize(FSPBLength + 4 + Length(FPassword) + Length(FUsername), SPBSize);
    if FUsername <> '' then begin
      FSPB[FSPBLength] := isc_spb_user_name_mapped_to_server;
      FSPB[FSPBLength + 1] := Length(FUsername);
      Encoding.Default.GetBytes(FUsername, 0, Length(FUsername), FSPB, FSPBLength + 2);
      Inc(FSPBLength, 2 + Length(FUsername));
    end;

    if FPassword <> '' then begin
      FSPB[FSPBLength] := isc_spb_password_mapped_to_server;
      FSPB[FSPBLength + 1] := Length(FPassword);
      Encoding.Default.GetBytes(FPassword, 0, Length(FPassword), FSPB, FSPBLength + 2);
      Inc(FSPBLength, 2 + Length(FPassword));
    end;

    for i := 0 to FParams.Count - 1 do begin
      if Trim(FParams.Names[i]) = '' then
        Continue;

      ParamName := LowerCase(FParams.Names[i]);
      ParamValue := Copy(FParams[i], Pos('=', FParams[i]) + 1, Length(FParams[i]));
      if Pos(SPBPrefix, ParamName) = 1 then
        Delete(ParamName, 1, Length(SPBPrefix));
      SPBVal := 0;
      SPBServerVal := 0;
      { Find the parameter }
      for j := 1 to isc_spb_last_spb_constant do
        if ParamName = SPBConstantNames[j] then begin
          SPBVal := j;
          SPBServerVal := SPBConstantValues[j];
          break;
        end;
      case SPBVal of
        isc_spb_user_name, isc_spb_password, isc_spb_instance_name: begin
          CheckSPBSize(FSPBLength + 2 + Length(ParamValue), SPBSize);
          FSPB[FSPBLength] := SPBServerVal;
          FSPB[FSPBLength + 1] := Length(ParamValue);
          Encoding.Default.GetBytes(ParamValue, 0, Length(ParamValue), FSPB, FSPBLength + 2);
          Inc(FSPBLength, 2 + Length(ParamValue));
        end
        else begin
          if (SPBVal > 0) and (SPBVal <= isc_spb_last_spb_constant) then
            RaiseError(Format(SSPBConstantNotSupported, [SPBConstantNames[SPBVal]]))
          else
            RaiseError(Format(SSPBConstantUnknown, [ParamName]));
        end;
      end;
    end;
  except
    SetLength(FSPB, 0);
    FSPBLength := 0;
    raise;
  end;
end;

procedure TCustomIBCService.Attach;
var
  FullServerName: string;
  pServer: IntPtr;
  MessageID: cardinal;
begin
  CheckInactive;

  if FLoginPrompt and not Login then
    Abort;

  TIBCSQLMonitor.ServiceAttach(Self, MessageID, True);

  if (FServer = '') and (FProtocol <> TCP) then
    RaiseError(SServerNameMissing);

  FGDS := GDSList.GetGDS(FClientLibrary);

  if FParamsChanged then begin
    GenerateSPB;
    FParamsChanged := False;
  end;

  case FProtocol of
    TCP:
      if FServer <> '' then
        FullServerName := FServer + ':service_mgr'
      else
        FullServerName := 'service_mgr';
    SPX:
      FullServerName := FServer + '@service_mgr';
    NetBEUI:
      FullServerName := '\\' + FServer + '\service_mgr';
  end;

  pServer := Marshal.StringToHGlobalAnsi(AnsiString(FullServerName));
  try
    try
      Check(GDS.isc_service_attach(FStatusVector, Length(FullServerName),
        pServer, FHandle, FSPBLength, {$IFDEF FPC}PChar{$ENDIF}(FSPB)));
    except
      Marshal.WriteIntPtr(FHandle, nil);
      raise;
    end;
  finally
    Marshal.FreeCoTaskMem(pServer);
  end;

  if Assigned(FOnAttach) then
    FOnAttach(Self);

  TIBCSQLMonitor.ServiceAttach(Self, MessageID, False);
end;

procedure TCustomIBCService.Detach;
var
  MessageID: cardinal;
begin
  if not Active then
    exit;

  TIBCSQLMonitor.ServiceDetach(Self, MessageID, True);

  try
    Check(GDS.isc_service_detach(FStatusVector, FHandle));
  finally
    Marshal.WriteIntPtr(FHandle, nil);
  end;

  TIBCSQLMonitor.ServiceDetach(Self, MessageID, False);
end;

function TCustomIBCService.GetHandle: TISC_SVC_HANDLE;
begin
  Result := Marshal.ReadIntPtr(FHandle);
end;

procedure TCustomIBCService.Loaded;
begin
  inherited;

  try
    if FStreamedActive then
      Attach;
  finally
    FStreamedActive := False;
  end;
end;

procedure TCustomIBCService.CheckActive;
begin
  if FStreamedActive and not Active then
    Loaded;

  if GetHandle = nil then
    RaiseError(SServiceActive);
end;

procedure TCustomIBCService.CheckInactive;
begin
  if GetHandle <> nil then
    RaiseError(SServiceInActive);
end;

function TCustomIBCService.GetActive: Boolean;
begin
  Result := GetHandle <> nil;
end;

procedure TCustomIBCService.SetActive(const Value: Boolean);
begin
  if csReading in ComponentState then
    FStreamedActive := Value
  else
    if Value <> Active then
      if Value then
        Attach
      else
        Detach;
end;

procedure TCustomIBCService.SetBufferSize(const Value: Integer);
begin
  if Value <> FBufferSize then begin
    FBufferSize := Value;
    if FOutputBuffer <> nil then
      FOutputBuffer := Marshal.AllocHGlobal(FBufferSize);
  end;
end;

procedure TCustomIBCService.SetUsername(const Value: _string);
begin
  if Value <> FUsername then begin
    CheckInactive;
    FParamsChanged := True;
    FUsername := Value;
  end;
end;

procedure TCustomIBCService.SetPassword(const Value: _string);
begin
  if Value <> FPassword then begin
    CheckInactive;
    FParamsChanged := True;
    FPassword := Value;
  end;
end;

function TCustomIBCService.GetClientLibrary: string;
begin
  if Active then
    Result := GDS.GDSDLL
  else
    Result := FClientLibrary;
end;

procedure TCustomIBCService.SetClientLibrary(Value: string);
begin
  if Value <> FClientLibrary then
    FClientLibrary := Value;
end;

procedure TCustomIBCService.SetServer(const Value: string);
begin
  if FServer <> Value then begin
    CheckInactive;
    FServer := Value;
    DoServerChange;
  end;
end;

procedure TCustomIBCService.SetProtocol(const Value: TIBCProtocol);
begin
  if FProtocol <> Value then begin
    CheckInactive;
    FProtocol := Value;
  end;
end;

procedure TCustomIBCService.SetConnectDialog(Value: TCustomConnectDialog);
begin
  if Value <> FConnectDialog then begin
    if FConnectDialog <> nil then begin
      RemoveFreeNotification(FConnectDialog);
    end;

    FConnectDialog := Value;

    if FConnectDialog <> nil then begin
      FreeNotification(FConnectDialog);
    end;
  end;
end;

procedure TCustomIBCService.SetParams(Value: TStrings);
begin
  FParams.Assign(Value);
end;

procedure TCustomIBCService.ParamsChanging(Sender: TObject);
begin
  CheckInactive;
end;

procedure TCustomIBCService.ParamsChange(Sender: TObject);
begin
  FParamsChanged := True;
end;

procedure TCustomIBCService.DoServerChange;
begin

end;

function TCustomIBCService.GetServiceParamBySPB(const Idx: Integer): string;
var
  ConstIdx, EqualsIdx: Integer;
begin
  if (Idx > 0) and (Idx <= isc_spb_last_spb_constant) then begin
    ConstIdx := IndexOfSPBConst(SPBConstantNames[Idx]);
    if ConstIdx = -1 then
      Result := ''
    else begin
      Result := Params[ConstIdx];
      EqualsIdx := Pos('=', Result);
      if EqualsIdx = 0 then
        Result := ''
      else
        Result := Copy(Result, EqualsIdx + 1, Length(Result));
    end;
  end
  else
    Result := '';
end;

procedure TCustomIBCService.SetServiceParamBySPB(const Idx: Integer;
  const Value: string);
var
  ConstIdx: Integer;
begin
  ConstIdx := IndexOfSPBConst(SPBConstantNames[Idx]);
  if Value = '' then begin
    if ConstIdx <> -1 then
      Params.Delete(ConstIdx);
  end
  else begin
    if ConstIdx = -1 then
      Params.Add(SPBConstantNames[Idx] + '=' + Value)
    else
      Params[ConstIdx] := SPBConstantNames[Idx] + '=' + Value;
  end;
end;

function TCustomIBCService.IndexOfSPBConst(const SPB: string): Integer;
var
  i, SPB_Pos: Integer;
begin
  Result := -1;
  for i := 0 to Params.Count - 1 do begin
    SPB_Pos := Pos(SPB, Params[i]);
    if (SPB_Pos = 1) or (SPB_Pos = Length(SPBPrefix) + 1) then begin
      Result := i;
      break;
    end;
  end;
end;

function TCustomIBCService.ParseString(var CurPos: Integer): string;
var
  Len: UShort;
begin
  Len := Marshal.ReadInt16(FOutputBuffer, CurPos);
  CurPos := CurPos + 2;
  if Len <> 0 then begin
    Result := string(Marshal.PtrToStringAnsi(PtrOffset(FOutputBuffer, CurPos), Len));
    CurPos := CurPos + Len;
  end
  else
    Result := '';
end;

function TCustomIBCService.ParseInteger(var CurPos: Integer): Integer;
begin
  Result := Marshal.ReadInt32(FOutputBuffer, CurPos);
  CurPos := CurPos + 4;
end;

procedure TCustomIBCService.InternalServiceQuery(const QParam: Byte);
var
  Params: TBytes;
begin
  SetLength(Params, 1);
  Params[0] := QParam;
  InternalServiceQuery(Params);
end;

procedure TCustomIBCService.InternalServiceQuery(const QParams: TBytes);
var
  MessageID: cardinal;
begin
  TIBCSQLMonitor.ServiceQuery(Self, MessageID, True);

  if Length(QParams) = 0 then
    RaiseError(SQueryParamsError);

  if FOutputBuffer = nil then
    FOutputBuffer := Marshal.AllocHGlobal(FBufferSize);

  CheckActive;
  try
    Check(GDS.isc_service_query(FStatusVector, FHandle, nil, 0, nil,
      Length(QParams), {$IFDEF FPC}PChar{$ENDIF}(QParams), FBufferSize, FOutputBuffer));
  except
    Marshal.WriteIntPtr(FHandle, nil);
    raise;
  end;

  TIBCSQLMonitor.ServiceQuery(Self, MessageID, False);
end;


function TCustomIBCService.GetIsServiceRunning: Boolean;
var
  CurPos: Integer;
begin
  InternalServiceQuery(isc_info_svc_running);
  if Marshal.ReadByte(FOutputBuffer) <> isc_info_svc_running then
    RaiseError(SOutputParsingError);

  CurPos := 1;
  Result := ParseInteger(CurPos) = 1;
end;

procedure TCustomIBCService.SetServiceStartOptions;
begin
//
end;

procedure TCustomIBCService.InitServiceStartParams(Param: Byte);
begin
  if Length(FStartSPB) = 0 then
    SetLength(FStartSPB, 128);

  FStartSPB[0] := Param;
  FStartSPBLength := 1;
end;

procedure TCustomIBCService.AddServiceStartParam(Param: Byte; const Value: string);
var
  Len: UShort;
begin
  if Length(Value) > $FFFF then
    RaiseError(SStartParamsError);

  Len := Length(AnsiString(Value));
  if Length(FStartSPB) < (FStartSPBLength + 3 + Len) then
    SetLength(FStartSPB, FStartSPBLength + Max(3 + Len, 128));

  FStartSPB[FStartSPBLength] := Param;
  FStartSPB[FStartSPBLength + 1] := Byte(Len);
  FStartSPB[FStartSPBLength + 2] := Byte(Len shr 8);
  if Len > 0 then
    Encoding.Default.GetBytes(Value, 0, Len, FStartSPB, FStartSPBLength + 3);
  Inc(FStartSPBLength, 3 + Len);
end;

procedure TCustomIBCService.AddServiceStartParam(Param: Byte; Value: Byte = 0);
begin
  if Length(FStartSPB) < (FStartSPBLength + 2) then
    SetLength(FStartSPB, 128 + FStartSPBLength);

  FStartSPB[FStartSPBLength] := Param;
  Inc(FStartSPBLength);
  if Value > 0 then begin
    FStartSPB[FStartSPBLength] := Value;
    Inc(FStartSPBLength);
  end;
end;

procedure TCustomIBCService.AddServiceStartParam32(Param: Byte; Value: Integer);
begin
  if Length(FStartSPB) < (FStartSPBLength + 5) then
    SetLength(FStartSPB, 128 + FStartSPBLength);

  FStartSPB[FStartSPBLength] := Param;
  FStartSPB[FStartSPBLength + 1] := Byte(Value);
  FStartSPB[FStartSPBLength + 2] := Byte(Value shr 8);
  FStartSPB[FStartSPBLength + 3] := Byte(Value shr 16);
  FStartSPB[FStartSPBLength + 4] := Byte(Value shr 24);
  Inc(FStartSPBLength, 5);
end;

procedure TCustomIBCService.InternalServiceStart;
var
  MessageID: cardinal;
begin
  TIBCSQLMonitor.ServiceStart(Self, MessageID, True);

  if FStartSPBLength = 0 then
    RaiseError(SStartParamsError);

  CheckActive;
  try
    try
      Check(GDS.isc_service_start(FStatusVector, FHandle, nil, FStartSPBLength, {$IFDEF FPC}PChar{$ENDIF}(FStartSPB)));
    except
      Marshal.WriteIntPtr(FHandle, nil);
      raise;
    end;
  finally
    FStartSPBLength := 0;
  end;

  TIBCSQLMonitor.ServiceStart(Self, MessageID, False);
end;

procedure TCustomIBCService.ServiceStart;
begin
  CheckActive;
  SetServiceStartOptions;
  InternalServiceStart;
end;

function TCustomIBCService.CreateConnection(const Database: string): TIBCConnection;
begin
  Result := TIBCConnection.Create(nil);
  try
    Result.Username := FUsername;
    Result.Password := FPassword;
    Result.ClientLibrary := ClientLibrary;
    Result.Options.Protocol := FProtocol;
    Result.Server := FServer;
    Result.Database := Database;
    Result.Params.Assign(Params);
    Result.LoginPrompt := LoginPrompt;
    Result.Connected := True;
  except
    Result.Free;
    raise;
  end;
end;

{ TIBCControlAndQueryService }

constructor TIBCControlAndQueryService.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEof := False;
  FAction := 0;
end;

procedure TIBCControlAndQueryService.SetAction(Value: Integer);
begin
  FEof := False;
  FAction := Value;
end;

function TIBCControlAndQueryService.GetNextChunk: string;
var
  Len: Integer;
begin
  if FEof then begin
    Result := '';
    Exit;
  end;

  if FAction = 0 then
    RaiseError(SQueryParamsError);

  InternalServiceQuery(isc_info_svc_to_eof);
  if Marshal.ReadByte(FOutputBuffer) <> isc_info_svc_to_eof then
    RaiseError(SOutputParsingError);

  Len := Marshal.ReadInt16(FOutputBuffer, 1);
  if Marshal.ReadByte(FOutputBuffer, 3 + Len) = isc_info_truncated then
    FEof := False
  else
  if Marshal.ReadByte(FOutputBuffer, 3 + Len) = isc_info_end then
    FEof := True
  else
    RaiseError(SOutputParsingError);

  Result := string(Marshal.PtrToStringAnsi(PtrOffset(FOutputBuffer, 3), Len));
end;

function TIBCControlAndQueryService.GetNextLine: string;
var
  Len: Integer;
begin
  if FEof then begin
    Result := '';
    Exit;
  end;

  if FAction = 0 then
    RaiseError(SQueryParamsError);

  InternalServiceQuery(isc_info_svc_line);
  if Marshal.ReadByte(FOutputBuffer) <> isc_info_svc_line then
    RaiseError(SOutputParsingError);

  Len := Marshal.ReadInt16(FOutputBuffer, 1);
  if Marshal.ReadByte(FOutputBuffer, 3 + Len) <> isc_info_end then
    RaiseError(SOutputParsingError);

  if Len = 0 then begin
    FEof := True;
    Result := '';
  end
  else begin
    FEof := False;
    Result := string(Marshal.PtrToStringAnsi(PtrOffset(FOutputBuffer, 3), Len));
  end;
end;

{ TIBCServerProperties }

constructor TIBCServerProperties.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FConfigParams := TIBCConfigParams.Create;
  FDatabaseInfo := TIBCDatabaseInfo.Create;
  FLicenseInfo := TIBCLicenseInfo.Create;
  FLicenseMaskInfo := TIBCLicenseMaskInfo.Create;
  FVersionInfo := TIBCVersionInfo.Create;
  FAliasInfoList := TObjectList.Create;
end;

destructor TIBCServerProperties.Destroy;
begin
  FConfigParams.Free;
  FDatabaseInfo.Free;
  FLicenseInfo.Free;
  FLicenseMaskInfo.Free;
  FVersionInfo.Free;
  FAliasInfoList.Clear;
  FAliasInfoList.Free;
  inherited;
end;

procedure TIBCServerProperties.DoServerChange;
begin
  // Clear DatabaseInfo
  FDatabaseInfo.FNoOfAttachments := 0;
  FDatabaseInfo.FNoOfDatabases := 0;
  FDatabaseInfo.FDbName := nil;

  // Clear LicenseInfo
  FLicenseInfo.FKey := nil;
  FLicenseInfo.FId := nil;
  FLicenseInfo.FDesc := nil;
  FLicenseInfo.FLicensedUsers := 0;

  // Clear LicenseMaskInfo
  FLicenseMaskInfo.FLicenseMask := 0;
  FLicenseMaskInfo.FCapabilityMask := 0;

  // Clear ConfigParams
  FConfigParams.FConfigFileKey := nil;
  FConfigParams.FConfigFileValue := nil;
  FConfigParams.FBaseLocation := '';
  FConfigParams.FLockFileLocation := '';
  FConfigParams.FMessageFileLocation := '';
  FConfigParams.FSecurityDatabaseLocation := '';

  // Clear VersionInfo
  FVersionInfo.FServerVersion := '';
  FVersionInfo.FServerImplementation := '';
  FVersionInfo.FServiceVersion := 0;

  // Clear AliasInfos
  FAliasInfoList.Clear;
end;

procedure TIBCServerProperties.Fetch;
begin
  if poConfigParameters in Options then
    FetchConfigParams;
  if poDatabase in Options then
    FetchDatabaseInfo;
  if poVersion in Options then
    FetchVersionInfo;
  if poDBAlias in Options then
    FetchAliasInfo;
  if poLicense in Options then
    FetchLicenseInfo;
  if poLicenseMask in Options then
    FetchLicenseMaskInfo;
end;

procedure TIBCServerProperties.FetchConfigParams;
  procedure ParseConfigFileData(var CurPos: Integer);
  begin
    with FConfigParams do begin
      SetLength(FConfigFileKey, Length(ConfigFileKey) + 1);
      SetLength(FConfigFileValue, Length(ConfigFileValue) + 1);

      FConfigFileKey[Length(FConfigFileKey) - 1] := Marshal.ReadByte(FOutputBuffer, CurPos);
      Inc(CurPos);
      FConfigFileValue[Length(FConfigFileValue) - 1] := ParseInteger(CurPos);
    end;
  end;

var
  Params: TBytes;
  CurPos: Integer;
begin
  SetLength(Params, 5);
  Params[0] := isc_info_svc_get_config;
  Params[1] := isc_info_svc_get_env;
  Params[2] := isc_info_svc_get_env_lock;
  Params[3] := isc_info_svc_get_env_msg;
  Params[4] := isc_info_svc_user_dbpath;
  InternalServiceQuery(Params);
  FConfigParams.FConfigFileKey := nil;
  FConfigParams.FConfigFileValue := nil;

  CurPos := 0;
  while Marshal.ReadByte(FOutputBuffer, CurPos) <> isc_info_end do begin
    Inc(CurPos);
    case Marshal.ReadByte(FOutputBuffer, CurPos - 1) of
      isc_info_svc_get_config: begin
        while Marshal.ReadByte(FOutputBuffer, CurPos) <> isc_info_flag_end do
          ParseConfigFileData(CurPos);
        Inc(CurPos);
      end;

      isc_info_svc_get_env:
        FConfigParams.FBaseLocation := ParseString(CurPos);

      isc_info_svc_get_env_lock:
        FConfigParams.FLockFileLocation := ParseString(CurPos);

      isc_info_svc_get_env_msg:
        FConfigParams.FMessageFileLocation := ParseString(CurPos);

      isc_info_svc_user_dbpath:
        FConfigParams.FSecurityDatabaseLocation := ParseString(CurPos);
    else
      RaiseError(SOutputParsingError);
    end;
  end;
end;

procedure TIBCServerProperties.FetchDatabaseInfo;
var
  i, CurPos: Integer;
begin
  InternalServiceQuery(isc_info_svc_svr_db_info);
  if Marshal.ReadByte(FOutputBuffer) <> isc_info_svc_svr_db_info then
    RaiseError(SOutputParsingError);

  CurPos := 1;
  if Marshal.ReadByte(FOutputBuffer, CurPos) <> isc_spb_num_att then
    RaiseError(SOutputParsingError);
  Inc(CurPos);
  FDatabaseInfo.FNoOfAttachments := ParseInteger(CurPos);

  if Marshal.ReadByte(FOutputBuffer, CurPos) <> isc_spb_num_db then
    RaiseError(SOutputParsingError);
  Inc(CurPos);
  FDatabaseInfo.FNoOfDatabases := ParseInteger(CurPos);

  FDatabaseInfo.FDbName := nil;
  SetLength(FDatabaseInfo.FDbName, FDatabaseInfo.FNoOfDatabases);
  for i := 0 to FDatabaseInfo.FNoOfDatabases - 1 do begin
    if Marshal.ReadByte(FOutputBuffer, CurPos) = isc_info_flag_end then
      RaiseError(SOutputParsingError);

    if Marshal.ReadByte(FOutputBuffer, CurPos) <> SPBConstantValues[isc_spb_dbname] then
      RaiseError(SOutputParsingError);
    Inc(CurPos);
    FDatabaseInfo.FDbName[i] := ParseString(CurPos);
  end;

  if Marshal.ReadByte(FOutputBuffer, CurPos) <> isc_info_flag_end then
    RaiseError(SOutputParsingError);
end;

procedure TIBCServerProperties.FetchLicenseInfo;
var
  Params: TBytes;
  CurPos: Integer;
  Ind: Integer;
begin
  SetLength(Params, 2);
  Params[0] := isc_info_svc_get_license;
  Params[1] := isc_info_svc_get_licensed_users;
  InternalServiceQuery(Params);
  FLicenseInfo.FKey := nil;
  FLicenseInfo.FId := nil;
  FLicenseInfo.FDesc := nil;

  Ind := 0;
  CurPos := 0;
  while Marshal.ReadByte(FOutputBuffer, CurPos) <> isc_info_end do begin
    Inc(CurPos);
    case Marshal.ReadByte(FOutputBuffer, CurPos - 1) of
      isc_info_svc_get_license: begin
        while Marshal.ReadByte(FOutputBuffer, CurPos) <> isc_info_flag_end do begin
          if Ind >= Length(FLicenseInfo.FKey) then begin
            SetLength(FLicenseInfo.FKey, Ind + $F);
            SetLength(FLicenseInfo.FId, Ind + $F);
            SetLength(FLicenseInfo.FDesc, Ind + $F);
          end;

          if Marshal.ReadByte(FOutputBuffer, CurPos) <> isc_spb_lic_id then
            RaiseError(SOutputParsingError);
          Inc(CurPos);
          FLicenseInfo.FId[Ind] := ParseString(CurPos);

          if Marshal.ReadByte(FOutputBuffer, CurPos) <> isc_spb_lic_key then
            RaiseError(SOutputParsingError);
          Inc(CurPos);
          FLicenseInfo.FKey[Ind] := ParseString(CurPos);

          if Marshal.ReadByte(FOutputBuffer, CurPos) <> isc_spb_lic_desc then
            RaiseError(SOutputParsingError);
          Inc(CurPos);
          FLicenseInfo.FDesc[Ind] := ParseString(CurPos);

          Inc(Ind);
        end;

        Inc(CurPos);
        if Length(FLicenseInfo.FKey) > Ind then begin
          SetLength(FLicenseInfo.FKey, Ind);
          SetLength(FLicenseInfo.FId, Ind);
          SetLength(FLicenseInfo.FDesc, Ind);
        end;
      end;

      isc_info_svc_get_licensed_users:
        FLicenseInfo.FLicensedUsers := ParseInteger(CurPos);
    else
      RaiseError(SOutputParsingError);
    end;
  end;
end;

procedure TIBCServerProperties.FetchLicenseMaskInfo;
var
  Params: TBytes;
  CurPos: Integer;
begin
  SetLength(Params, 2);
  Params[0] := isc_info_svc_get_license_mask;
  Params[1] := isc_info_svc_capabilities;
  InternalServiceQuery(Params);

  CurPos := 0;
  while Marshal.ReadByte(FOutputBuffer, CurPos) <> isc_info_end do begin
    Inc(CurPos);
    case Marshal.ReadByte(FOutputBuffer, CurPos - 1) of
      isc_info_svc_get_license_mask:
        FLicenseMaskInfo.FLicenseMask := ParseInteger(CurPos);
      isc_info_svc_capabilities:
        FLicenseMaskInfo.FCapabilityMask := ParseInteger(CurPos);
    else
      RaiseError(SOutputParsingError);
    end;
  end;
end;

procedure TIBCServerProperties.FetchVersionInfo;
var
  Params: TBytes;
  CurPos: Integer;
  i: Integer;
begin
  SetLength(Params, 3);
  Params[0] := isc_info_svc_version;
  Params[1] := isc_info_svc_server_version;
  Params[2] := isc_info_svc_implementation;
  InternalServiceQuery(Params);

  CurPos := 0;
  for i := 0 to 2 do begin
    Inc(CurPos);
    case Marshal.ReadByte(FOutputBuffer, CurPos - 1) of
      isc_info_svc_version:
        FVersionInfo.FServiceVersion := ParseInteger(CurPos);
      isc_info_svc_server_version:
        FVersionInfo.FServerVersion := ParseString(CurPos);
      isc_info_svc_implementation:
        FVersionInfo.FServerImplementation := ParseString(CurPos);
    else
      RaiseError(SOutputParsingError);
    end;
  end;
end;

procedure TIBCServerProperties.FetchAliasInfo;

  function IsMinimumVersion(ServerVersion, MinVersion: string): Boolean;
  var
    lServer: string;
    Idx: Integer;
    ServerAsInt, MinAsInt: Double;

    function GetNextNumber(var s: string): Integer;
    begin
      Idx := Pos('.', s);
      if Idx > 0 then begin
        Result := StrToInt(Copy(s, 1, Idx - 1));
        s := Copy(s, Idx + 1, Length(s));
      end
      else begin
        if s <> '' then
          Result := StrToInt(s)
        else
          Result := 0;
        s := '';
      end;
    end;

  begin
    if ServerVersion = '' then
      RaiseError(SNoVersionInfo);

    Result := True;
    Idx := 1;
    while (Idx <= Length(ServerVersion)) and
      not ((ServerVersion[Idx] >= '0') and (ServerVersion[Idx] <= '9')) do
      Inc(Idx);

    lServer := Copy(ServerVersion, Idx, Length(ServerVersion));
    if (Trim(lServer) = '') or (Trim(MinVersion) = '') then
      Result := False;

    ServerAsInt := 0;
    MinAsInt := 0;
    while Result and (MinVersion <> '') do begin
      ServerAsInt := (ServerAsInt * 1000) + GetNextNumber(lServer);
      MinAsInt := (MinAsInt * 1000) + GetNextNumber(MinVersion);
      Result := MinAsInt <= ServerAsInt;
    end;
  end;

  procedure FetchData;
  var
    CurPos: Integer;
    NewAliasInfo: TIBCAliasInfo;
  begin
    FAliasInfoList.Clear;
    InitServiceStartParams(isc_action_svc_display_db_alias);
    ServiceStart;
    InternalServiceQuery(isc_info_svc_get_db_alias);
    if Marshal.ReadByte(FOutputBuffer) <> isc_info_svc_get_db_alias then
      RaiseError(SOutputParsingError);

    CurPos := 3;
    while Marshal.ReadByte(FOutputBuffer, CurPos) <> isc_info_end do begin
      NewAliasInfo := TIBCAliasInfo.Create;
      FAliasInfoList.Add(NewAliasInfo);

      if Marshal.ReadByte(FOutputBuffer, CurPos) <> isc_spb_sec_db_alias_name then
        RaiseError(SOutputParsingError);
      Inc(CurPos);
      NewAliasInfo.FAlias := ParseString(CurPos);

      if Marshal.ReadByte(FOutputBuffer, CurPos) <> isc_spb_sec_db_alias_dbpath then
        RaiseError(SOutputParsingError);
      Inc(CurPos);
      NewAliasInfo.FDBPath := ParseString(CurPos);
    end;
  end;

begin
  FAliasInfoList.Clear;

  if FVersionInfo.ServerVersion = '' then
    FetchVersionInfo;

  if IsMinimumVersion(FVersionInfo.ServerVersion, '7.5.1.80') then
    try
      FetchData;
    except
      FetchData; // Necessary due to a bug in the API
    end;
end;

procedure TIBCServerProperties.AddAlias(const Alias, DBPath: string);
begin
  InitServiceStartParams(isc_action_svc_add_db_alias);
  AddServiceStartParam(isc_spb_sec_db_alias_name, Alias);
  AddServiceStartParam(isc_spb_sec_db_alias_dbpath, DBPath);
  ServiceStart;
end;

procedure TIBCServerProperties.DeleteAlias(const Alias: string);
begin
  InitServiceStartParams(isc_action_svc_delete_db_alias);
  AddServiceStartParam(isc_spb_sec_db_alias_name, Alias);
  ServiceStart;
end;

function TIBCServerProperties.GetAliasInfo(Index: Integer): TIBCAliasInfo;
begin
  Result := TIBCAliasInfo(FAliasInfoList.Items[Index]);
end;

function TIBCServerProperties.GetAliasCount: Integer;
begin
  Result := FAliasInfoList.Count;
end;

{ TIBCConfigService }

constructor TIBCConfigService.Create(AOwner: TComponent);
begin
  inherited;
  FJournalInformation := TIBCJournalInformation.Create(Self);
end;

procedure TIBCConfigService.ServiceStart;
begin
  RaiseError(SUseSpecificProcedures);
end;

procedure TIBCConfigService.SetTransactionParams(Transaction: TIBCTransaction);
begin
  Transaction.Params.Add('read_committed');
  Transaction.Params.Add('rec_version');
  Transaction.Params.Add('nowait');
end;

procedure TIBCConfigService.ExecuteSQL(const SQL: string);
var
  tConnection: TIBCConnection;
  tTransaction: TIBCTransaction;
  IBCSQL: TIBCSQL;
begin
  if Assigned(Connection) then
    tConnection := Connection
  else
    tConnection := CreateConnection(Database);

  if Assigned(Transaction) then
    tTransaction := Transaction
  else begin
    tTransaction := TIBCTransaction.Create(nil);
    SetTransactionParams(tTransaction);
    tTransaction.DefaultConnection := tConnection;
  end;

  IBCSQL := nil;
  try
    if not Assigned(Connection) then
      tConnection.DefaultTransaction := tTransaction;
    if GetFullODS(tConnection.DatabaseInfo) < 11.2 then
      RaiseError(SIB75feature);

    IBCSQL := TIBCSQL.Create(nil);
    IBCSQL.Connection := tConnection;
    IBCSQL.SQL.Text := SQL;

    if not tConnection.InTransaction then
      tConnection.StartTransaction;
    IBCSQL.Execute;
    tConnection.Commit;
    
  finally
    IBCSQL.Free;
    if not Assigned(Connection) then
      tConnection.Free;
    if not Assigned(Transaction) then
      tTransaction.Free;
  end;
end;

procedure TIBCConfigService.CongigServiceStart(Param: Byte; Value: Byte);
begin
  InitServiceStartParams(isc_action_svc_properties);
  AddServiceStartParam(SPBConstantValues[isc_spb_dbname], FDatabase);
  AddServiceStartParam(Param, Value);
  InternalServiceStart;
end;

procedure TIBCConfigService.Congig32ServiceStart(Param: Byte; Value: Integer);
begin
  InitServiceStartParams(isc_action_svc_properties);
  AddServiceStartParam(SPBConstantValues[isc_spb_dbname], FDatabase);
  AddServiceStartParam32(Param, Value);
  InternalServiceStart;
end;

procedure TIBCConfigService.ActivateShadow;
begin
  Congig32ServiceStart(SPBConstantValues[isc_spb_options], isc_spb_prp_activate);
end;

procedure TIBCConfigService.BringDatabaseOnline;
begin
  Congig32ServiceStart(SPBConstantValues[isc_spb_options], isc_spb_prp_db_online);
end;

procedure TIBCConfigService.SetDBSqlDialect(Value: Integer);
begin
  Congig32ServiceStart(isc_spb_prp_set_sql_dialect, Value);
end;

procedure TIBCConfigService.SetPageBuffers(Value: Integer);
begin
  Congig32ServiceStart(isc_spb_prp_page_buffers, Value);
end;

procedure TIBCConfigService.SetSweepInterval(Value: Integer);
begin
  Congig32ServiceStart(isc_spb_prp_sweep_interval, Value);
end;

procedure TIBCConfigService.SetAsyncMode(Value: Boolean);
var
  Prop: Byte;
begin
  if Value then
    Prop := isc_spb_prp_wm_async
  else
    Prop := isc_spb_prp_wm_sync;
  CongigServiceStart(isc_spb_prp_write_mode, Prop);
end;

procedure TIBCConfigService.SetReadOnly(Value: Boolean);
var
  Prop: Byte;
begin
  if Value then
    Prop := isc_spb_prp_am_readonly
  else
    Prop := isc_spb_prp_am_readwrite;
  CongigServiceStart(isc_spb_prp_access_mode, Prop);
end;

procedure TIBCConfigService.SetReserveSpace(Value: Boolean);
var
  Prop: Byte;
begin
  if Value then
    Prop := isc_spb_prp_res
  else
    Prop := isc_spb_prp_res_use_full;
  CongigServiceStart(isc_spb_prp_reserve_space, Prop);
end;

procedure TIBCConfigService.ShutdownDatabase(Options: TIBCShutdownMode; Wait: Integer);
var
  Param: Byte;
begin
  Param := 0;
  case Options of
    smForced:
      Param := isc_spb_prp_shutdown_db;
    smDenyTransaction:
      Param := isc_spb_prp_deny_new_transactions;
    smDenyAttachment:
      Param := isc_spb_prp_deny_new_attachments;
  end;

  Congig32ServiceStart(Param, Wait);
end;

procedure TIBCConfigService.SweepDatabase;
begin
  ExecuteSQL('UPDATE TMP$DATABASE SET TMP$STATE = ''SWEEP''');
end;

procedure TIBCConfigService.SetGroupCommit(Value: Boolean);
begin
  if Value then
    ExecuteSQL('ALTER DATABASE SET GROUP COMMIT')
  else
    ExecuteSQL('ALTER DATABASE SET NO GROUP COMMIT');
end;

procedure TIBCConfigService.SetLingerInterval(Value: Integer);
begin
  ExecuteSQL(Format('ALTER DATABASE SET LINGER INTERVAL %d', [Value]));
end;

procedure TIBCConfigService.SetFlushInterval(Value: Integer);
begin
  ExecuteSQL(Format('ALTER DATABASE SET FLUSH INTERVAL %d', [Value]));
end;

procedure TIBCConfigService.FlushDatabase;
begin
  ExecuteSQL('UPDATE TMP$DATABASE SET TMP$STATE = ''FLUSH''');
end;

procedure TIBCConfigService.DisableFlush;
begin
  ExecuteSQL('ALTER DATABASE SET NO RECLAIM INTERVAL');
end;

procedure TIBCConfigService.SetReclaimInterval(Value: Integer);
begin
  if Value > 0 then
    ExecuteSQL(Format('ALTER DATABASE SET RECLAIM INTERVAL %d', [Value]))
  else
    ExecuteSQL('ALTER DATABASE SET NO RECLAIM INTERVAL');
end;

procedure TIBCConfigService.ReclaimMemory;
begin
  ExecuteSQL('UPDATE TMP$DATABASE SET TMP$STATE = ''RECLAIM''');
end;

procedure TIBCConfigService.CreateJournal;
begin
  ExecuteSQL('CREATE JOURNAL ' + QuotedStr(JournalInformation.Directory) +
    JournalInformation.CreateJournalLength + JournalInformation.CreateJournalAttributes);
  JournalInformation.FHasJournal := True;
end;

procedure TIBCConfigService.AlterJournal;
begin
  ExecuteSQL('ALTER JOURNAL SET ' + JournalInformation.CreateJournalAttributes);
end;

procedure TIBCConfigService.DropJournal;
begin
  ExecuteSQL('DROP JOURNAL ');
  JournalInformation.FHasJournal := False;
end;

procedure TIBCConfigService.CreateJournalArchive(const Directory: string);
begin
  ExecuteSQL('CREATE JOURNAL ARCHIVE ' + QuotedStr(Directory));
  JournalInformation.FHasArchive := True;
end;

procedure TIBCConfigService.DropJournalArchive;
begin
  ExecuteSQL('DROP JOURNAL ARCHIVE');
  JournalInformation.FHasArchive := False;
end;

procedure TIBCConfigService.GetJournalInformation;

  function GetValue(S: string): Integer;
  var
    P: Integer;
  begin
    P := Length(S);
    while (S[P] >= '0') and (S[P] <= '9') do
      Dec(P);
    Delete(S, 1, P);
    if S <> '' then
      Result := StrToInt(S)
    else
      Result := 0;
  end;

  procedure GetAdditionalValues;
  var
    Connection: TIBCConnection;
    IBCQuery: TIBCQuery;
  begin
    Connection := CreateConnection(Database);
    IBCQuery := TIBCQuery.Create(nil);
    try
      SetTransactionParams(Connection.DefaultTransaction);
      Connection.StartTransaction;
      IBCQuery.Connection := Connection;
      IBCQuery.SQL.Text := 'SELECT RDB$FILE_NAME, RDB$FILE_LENGTH FROM RDB$LOG_FILES WHERE RDB$FILE_FLAGS = :Flags';
      IBCQuery.Params[0].AsInteger := 1;
      IBCQuery.Execute;
      if IBCQuery.Eof then begin
        FJournalInformation.FHasJournal := False;
        FJournalInformation.Directory := '';
        FJournalInformation.PageLength := 500;
      end
      else begin
        FJournalInformation.FHasJournal := True;
        FJournalInformation.Directory := TrimRight(IBCQuery.Fields[0].AsString);
        if IBCQuery.Fields[1].AsInteger > 0 then
          FJournalInformation.PageLength := IBCQuery.Fields[1].AsInteger
        else
          FJournalInformation.PageLength := 500;
        IBCQuery.Close;
        IBCQuery.Params[0].AsInteger := 24;
        IBCQuery.Execute;
        if IBCQuery.Eof then
          FJournalInformation.FHasArchive := False
        else
          FJournalInformation.FHasArchive := not IBCQuery.Fields[0].IsNull;
      end;
      Connection.Commit;
    finally
      IBCQuery.Free;
      Connection.Free;
    end;
  end;

var
  JournalStatistics: TIBCStatisticalService;
  sl: TStringList;
  S, FileName: string;
  JournalStart: Boolean;
  Conn: TIBCConnection;
  i: Integer;
begin
  Conn := CreateConnection(Database);
  try
    FJournalInformation.PageSize := 2 * Conn.DatabaseInfo.PageSize;
  finally
    Conn.Free;
  end;

  JournalStatistics := TIBCStatisticalService.Create(Self);
  sl := TStringList.Create;
  try
    JournalStatistics.Server := Server;
    JournalStatistics.Protocol := Protocol;
    JournalStatistics.Params.Assign(Params);
    JournalStatistics.Database := Database;
    JournalStatistics.LoginPrompt := False;
    JournalStatistics.Options := [soDbLog];
    JournalStatistics.Attach;
    try
      JournalStatistics.ServiceStart;
      sleep(100);

      while not JournalStatistics.Eof do begin
      {$IFDEF VER6P}
      {$IFNDEF FPC}
        DBApplication.ProcessMessages;
      {$ENDIF}
      {$ENDIF}
        S := Trim(JournalStatistics.GetNextLine);
        if S <> '' then
          sl.Add(UpperCase(S));
      end;

      JournalStart := False;
      for i := 0 to sl.Count - 1 do begin
        S := sl[i];
        if JournalStart then begin
          if Pos('*END*', S) > 0 then
            Break;

          if Pos('FILE NAME', S) > 0 then begin
            FileName := ExtractFileName(S);
            FJournalInformation.TimestampName := Pos('Z', S) > 1;
          end
          else
          if Pos('CHECK POINT LENGTH', S) > 0 then
            FJournalInformation.CheckpointLength := GetValue(S)
          else
          if Pos('NUMBER OF WAL BUFFERS', S) > 0 then
            FJournalInformation.PageCache := GetValue(S)
          else
          if Pos('WAL BUFFER SIZE', S) > 0 then
            FJournalInformation.PageSize := GetValue(S);
        end;

        if Pos('VARIABLE LOG DATA', S) > 0 then
          JournalStart := True;
      end;

      GetAdditionalValues;
    finally
      JournalStatistics.Detach;
    end;

    GetAdditionalValues;
  finally
    JournalStatistics.Free;
    sl.Free;
  end;
end;

{ TIBCJournalInformation }

constructor TIBCJournalInformation.Create(AOwner: TComponent);
begin
  inherited;
  FDirectory := '';
  FCheckpointInterval := 0;
  FCheckpointLength := 500;
  FTimestampName := True;
  FPageSize := 0;
  FPageCache := 100;
  FPageLength := 500;
  FHasArchive := False;
  FHasJournal := False;
end;

function TIBCJournalInformation.CreateJournalAttributes: string;
begin
  Result := ' CHECKPOINT LENGTH ' + IntToStr(CheckpointLength);
  Result := Result + ' CHECKPOINT INTERVAL ' + IntToStr(CheckpointInterval);
  Result := Result + ' PAGE SIZE ' + IntToStr(PageSize);
  Result := Result + ' PAGE CACHE ' + IntToStr(PageCache);
  if TimestampName then
    Result := Result + ' TIMESTAMP NAME'
  else
    Result := Result + ' NO TIMESTAMP NAME';
end;

function TIBCJournalInformation.CreateJournalLength: string;
begin
  Result := '';
  if PageLength <> 500 then
    Result := ' LENGTH ' + IntToStr(PageLength);
end;

{ TIBCLicensingService }

procedure TIBCLicensingService.SetAction(Value: TIBCLicensingAction);
begin
  FAction := Value;
  if Value = laRemove then
   FID := '';
end;

procedure TIBCLicensingService.SetServiceStartOptions;
begin
  if FAction = laAdd then begin
    InitServiceStartParams(isc_action_svc_add_license);
    AddServiceStartParam(isc_spb_lic_key, FKey);
    AddServiceStartParam(isc_spb_lic_id, FID);
  end
  else begin
    InitServiceStartParams(isc_action_svc_remove_license);
    AddServiceStartParam(isc_spb_lic_key, FKey);
  end;
end;

procedure TIBCLicensingService.AddLicense;
begin
  Action := laAdd;
  ServiceStart;
end;

procedure TIBCLicensingService.RemoveLicense;
begin
  Action := laRemove;
  ServiceStart;
end;

{ TIBCLogService }

procedure TIBCLogService.SetServiceStartOptions;
begin
  Action := isc_action_svc_get_ib_log;
  InitServiceStartParams(isc_action_svc_get_ib_log);
end;

{ TIBCStatisticalService }

procedure TIBCStatisticalService.SetServiceStartOptions;
const
  StatOptions: array[TIBCStatOption] of Integer = (
    isc_spb_sts_data_pages,
    isc_spb_sts_db_log,
    isc_spb_sts_hdr_pages,
    isc_spb_sts_idx_pages,
    isc_spb_sts_sys_relations,
    isc_spb_sts_record_versions,
    isc_spb_sts_table);

var
  Param: Integer;
  Option: TIBCStatOption;
begin
  Param := 0;
  for Option := Low(TIBCStatOption) to High(TIBCStatOption) do
    if Option in Options then
      Param := Param or StatOptions[Option];

  Action := isc_action_svc_db_stats;
  InitServiceStartParams(isc_action_svc_db_stats);
  AddServiceStartParam(SPBConstantValues[isc_spb_dbname], FDatabase);
  AddServiceStartParam32(SPBConstantValues[isc_spb_options], Param);
  if soStatTables in Options then
    AddServiceStartParam(SPBConstantValues[isc_spb_command_line], FTableNames);
end;

{ TIBCBackupRestoreService }

procedure TIBCBackupRestoreService.SetBackupFile(Value: TStrings);
begin
  FBackupFile.Assign(Value);
end;

{ TIBCBackupService }

constructor TIBCBackupService.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBackupFile := TStringList.Create;
end;

destructor TIBCBackupService.Destroy;
begin
  FBackupFile.Free;
  inherited;
end;

procedure TIBCBackupService.SetServiceStartOptions;
const
  BackupOptions: array[TIBCBackupOption] of Integer = (
    isc_spb_bkp_ignore_checksums,
    isc_spb_bkp_ignore_limbo,
    isc_spb_bkp_metadata_only,
    isc_spb_bkp_no_garbage_collect,
    isc_spb_bkp_old_descriptions,
    isc_spb_bkp_non_transportable,
    isc_spb_bkp_convert);

  NBackupOptions: array[TIBCNBackupOption] of Integer = (
    isc_spb_nbk_no_triggers);

var
  Param: Integer;
  Option: TIBCBackupOption;
  NOption: TIBCNBackupOption;
  i, p: Integer;
begin
  if FUseNBackup then
    Action := isc_action_svc_nbak
  else
    Action := isc_action_svc_backup;

  InitServiceStartParams(Action);
  AddServiceStartParam(SPBConstantValues[isc_spb_dbname], FDatabase);

  Param := 0;
  if FUseNBackup then begin
    for NOption := Low(TIBCNBackupOption) to High(TIBCNBackupOption) do
      if NOption in FNBackupOptions then
        Param := Param or NBackupOptions[NOption];
  end
  else begin
    for Option := Low(TIBCBackupOption) to High(TIBCBackupOption) do
      if Option in Options then
        Param := Param or BackupOptions[Option];
  end;

  AddServiceStartParam32(SPBConstantValues[isc_spb_options], Param);

  if FUseNBackup then begin
    AddServiceStartParam32(isc_spb_nbk_level, FNBackupLevel);

    if FBackupFile.Count = 0 then
      raise Exception.Create(SBackupFileNotSpecified);

    AddServiceStartParam(isc_spb_nbk_file, FBackupFile[0]);
  end
  else begin
    if Verbose then
      AddServiceStartParam(SPBConstantValues[isc_spb_verbose]);
    if FBlockingFactor > 0 then
      AddServiceStartParam32(isc_spb_bkp_factor, FBlockingFactor);

    for i := 0 to FBackupFile.Count - 1 do begin
      if Trim(FBackupFile[i]) = '' then
        Continue;

      p := Pos('=', FBackupFile[i]);
      if p <> 0 then begin
        AddServiceStartParam(isc_spb_bkp_file, Copy(FBackupFile[i], 1, p - 1));
        AddServiceStartParam32(isc_spb_bkp_length, StrToInt(Copy(FBackupFile[i], p + 1, MaxInt)));
      end
      else
        AddServiceStartParam(isc_spb_bkp_file, FBackupFile[i]);
    end;
  end;
end;

{ TIBCRestoreService }

constructor TIBCRestoreService.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDatabase := TStringList.Create;
  FBackupFile := TStringList.Create;
  FOptions := [roCreateNewDB];
  FPageSize := 4096;
end;

destructor TIBCRestoreService.Destroy;
begin
  FDatabase.Free;
  FBackupFile.Free;
  inherited;
end;

procedure TIBCRestoreService.SetServiceStartOptions;
const
  RestoreOptions: array[TIBCRestoreOption] of Integer = (
    isc_spb_res_deactivate_idx,
    isc_spb_res_no_shadow,
    isc_spb_res_no_validity,
    isc_spb_res_one_at_a_time,
    isc_spb_res_replace,
    isc_spb_res_create,
    isc_spb_res_use_all_space,
    isc_spb_res_validate);

  NBackupOptions: array[TIBCNBackupOption] of Integer = (
    isc_spb_nbk_no_triggers);

var
  Param: Integer;
  Option: TIBCRestoreOption;
  NOption: TIBCNBackupOption;
  i, p: Integer;
begin
  if FUseNBackup then
    Action := isc_action_svc_nrest
  else
    Action := isc_action_svc_restore;

  InitServiceStartParams(Action);

  Param := 0;
  if FUseNBackup then begin
    for NOption := Low(TIBCNBackupOption) to High(TIBCNBackupOption) do
      if NOption in FNBackupOptions then
        Param := Param or NBackupOptions[NOption];
  end
  else begin
    for Option := Low(TIBCRestoreOption) to High(TIBCRestoreOption) do
      if Option in Options then
        Param := Param or RestoreOptions[Option];
  end;

  AddServiceStartParam32(SPBConstantValues[isc_spb_options], Param);

  if FUseNBackup then begin
    AddServiceStartParam32(isc_spb_nbk_level, FNBackupLevel);

    if FBackupFile.Count = 0 then
      raise Exception.Create(SBackupFileNotSpecified);

    AddServiceStartParam(isc_spb_nbk_file, FBackupFile[0]);
  end
  else begin
    if Verbose then
      AddServiceStartParam(SPBConstantValues[isc_spb_verbose]);
    if FPageSize > 0 then
      AddServiceStartParam32(isc_spb_res_page_size, FPageSize);
    if FPageBuffers > 0 then
      AddServiceStartParam32(isc_spb_res_buffers, FPageBuffers);

    for i := 0 to FBackupFile.Count - 1 do begin
      if Trim(FBackupFile[i]) = '' then
        Continue;

      p := Pos('=', FBackupFile[i]);
      if p <> 0 then
        AddServiceStartParam(isc_spb_bkp_file, Copy(FBackupFile[i], 1, p - 1))
      else
        AddServiceStartParam(isc_spb_bkp_file, FBackupFile[i]);
    end;
  end;

  for i := 0 to FDatabase.Count - 1 do begin
    if Trim(FDatabase[i]) = '' then
      Continue;

    p := Pos('=', FDatabase[i]);
    if p <> 0 then begin
      AddServiceStartParam(SPBConstantValues[isc_spb_dbname], Copy(FDatabase[i], 1, p - 1));
      AddServiceStartParam32(isc_spb_res_length, StrToInt(Copy(FDatabase[i], p + 1, MaxInt)));
    end
    else
      AddServiceStartParam(SPBConstantValues[isc_spb_dbname], FDatabase[i]);
  end;
end;

procedure TIBCRestoreService.SetDatabase(Value: TStrings);
begin
  FDatabase.Assign(Value);
end;

{ TIBCValidationService }

constructor TIBCValidationService.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLimboTransactionInfoList := TObjectList.Create;
  FGlobalAction := tgNoGlobalAction;
end;

destructor TIBCValidationService.Destroy;
begin
  FLimboTransactionInfoList.Clear;
  FLimboTransactionInfoList.Free;

  inherited;
end;

procedure TIBCValidationService.SetServiceStartOptions;
const
  ValidateOptions: array[TIBCValidateOption] of Integer = (
    isc_spb_rpr_check_db,
    isc_spb_rpr_ignore_checksum,
    isc_spb_rpr_kill_shadows,
    isc_spb_rpr_mend_db,
    isc_spb_rpr_validate_db,
    isc_spb_rpr_full);

var
  Param: Integer;
  Option: TIBCValidateOption;
begin
  Param := 0;
  for Option := Low(TIBCValidateOption) to High(TIBCValidateOption) do
    if Option in Options then
      Param := Param or ValidateOptions[Option];

  Action := isc_action_svc_repair;
  InitServiceStartParams(isc_action_svc_repair);
  AddServiceStartParam(SPBConstantValues[isc_spb_dbname], FDatabase);
  if Param > 0 then
    AddServiceStartParam32(SPBConstantValues[isc_spb_options], Param);
end;

procedure TIBCValidationService.SweepDatabase;
begin
  InitServiceStartParams(isc_action_svc_repair);
  AddServiceStartParam(SPBConstantValues[isc_spb_dbname], FDatabase);
  AddServiceStartParam32(SPBConstantValues[isc_spb_options], isc_spb_rpr_sweep_db);
  InternalServiceStart;
end;

procedure TIBCValidationService.FixLimboTransactionErrors;
var
  Param: Byte;
  i: Integer;
begin
  if FLimboTransactionInfoList.Count = 0 then
    Exit;
    
  InitServiceStartParams(isc_action_svc_repair);
  AddServiceStartParam(SPBConstantValues[isc_spb_dbname], FDatabase);
  if RecoverTwoPhaseGlobal then
    AddServiceStartParam(isc_spb_rpr_recover_two_phase);

  if FGlobalAction = tgNoGlobalAction then begin
    for i := 0 to FLimboTransactionInfoList.Count - 1 do begin
      if LimboTransactionInfo[i].Action = taCommit then
        AddServiceStartParam32(isc_spb_rpr_commit_trans, LimboTransactionInfo[i].ID)
      else
        AddServiceStartParam32(isc_spb_rpr_rollback_trans, LimboTransactionInfo[i].ID);
    end;
  end
  else begin
    if FGlobalAction = tgCommitGlobal then
      Param := isc_spb_rpr_commit_trans
    else
      Param := isc_spb_rpr_rollback_trans;

    for i := 0 to FLimboTransactionInfoList.Count - 1 do begin
      AddServiceStartParam32(Param, LimboTransactionInfo[i].ID);
    end;
  end;

  InternalServiceStart;
end;

procedure TIBCValidationService.FetchLimboTransactionInfo;
var
  CurPos: Integer;
  NewLimboTransactionInfo: TIBCLimboTransactionInfo;
begin
  FLimboTransactionInfoList.Clear;
  InitServiceStartParams(isc_action_svc_repair);
  AddServiceStartParam(SPBConstantValues[isc_spb_dbname], FDatabase);
  AddServiceStartParam32(SPBConstantValues[isc_spb_options], isc_spb_rpr_list_limbo_trans);
  InternalServiceStart;
  InternalServiceQuery(isc_info_svc_limbo_trans);
  if Marshal.ReadByte(FOutputBuffer) <> isc_info_svc_limbo_trans then
    RaiseError(SOutputParsingError);

  CurPos := 3;
  while Marshal.ReadByte(FOutputBuffer, CurPos) <> isc_info_end do begin
    NewLimboTransactionInfo := TIBCLimboTransactionInfo.Create;
    FLimboTransactionInfoList.Add(NewLimboTransactionInfo);

    Inc(CurPos);
    with NewLimboTransactionInfo do begin
      case Marshal.ReadByte(FOutputBuffer, CurPos - 1) of
        isc_spb_single_tra_id: begin
          FMultiDatabase := False;
          FID := ParseInteger(CurPos);
        end;

        isc_spb_multi_tra_id: begin
          FMultiDatabase := True;
          FID := ParseInteger(CurPos);
          FHostSite := ParseString(CurPos);

          if Marshal.ReadByte(FOutputBuffer, CurPos) <> isc_spb_tra_state then
            RaiseError(SOutputParsingError);
          Inc(CurPos);
          case Marshal.ReadByte(FOutputBuffer, CurPos) of
            isc_spb_tra_state_limbo:
              FState := tsLimboState;
            isc_spb_tra_state_commit:
              FState := tsCommitState;
            isc_spb_tra_state_rollback:
              FState := tsRollbackState;
            isc_spb_tra_state_unknown:
              FState := tsUnknownState;
          else
            RaiseError(SOutputParsingError);
          end;

          Inc(CurPos);
          FRemoteSite := ParseString(CurPos);
          FRemoteDatabasePath := ParseString(CurPos);

          case Marshal.ReadByte(FOutputBuffer, CurPos) of
            isc_spb_tra_advise_commit: begin
              FAdvise := taCommitAdvise;
              FAction:= taCommit;
            end;
            isc_spb_tra_advise_rollback: begin
              FAdvise := taRollbackAdvise;
              FAction := taRollback;
            end;
            isc_spb_tra_advise_unknown: begin
              FAdvise := taUnknownAdvise;
              FAction:= taCommit;
            end;
          else
            RaiseError(SOutputParsingError);
          end;

          Inc(CurPos);
        end;
      else
        RaiseError(SOutputParsingError);
      end;
    end;
  end;
end;

function TIBCValidationService.GetLimboTransactionInfo(Index: Integer): TIBCLimboTransactionInfo;
begin
  Result := TIBCLimboTransactionInfo(FLimboTransactionInfoList.Items[Index]);
end;

function TIBCValidationService.GetLimboTransactionInfoCount: Integer;
begin
  Result := FLimboTransactionInfoList.Count;
end;

{ TIBCUserInfo }

procedure TIBCUserInfo.SetPassword(const Value: string);
begin
  FPassword := Value;
  Include(FModifiedParams, umPassword);
end;

procedure TIBCUserInfo.SetFirstName(const Value: string);
begin
  FFirstName := Value;
  Include(FModifiedParams, umFirstName);
end;

procedure TIBCUserInfo.SetMiddleName(const Value: string);
begin
  FMiddleName := Value;
  Include(FModifiedParams, umMiddleName);
end;

procedure TIBCUserInfo.SetLastName(const Value: string);
begin
  FLastName := Value;
  Include(FModifiedParams, umLastName);
end;

procedure TIBCUserInfo.SetUserID(Value: Integer);
begin
  FUserId := Value;
  Include(FModifiedParams, umUserId);
end;

procedure TIBCUserInfo.SetGroupID(Value: Integer);
begin
  FGroupId := Value;
  Include(FModifiedParams, umGroupId);
end;

procedure TIBCUserInfo.SetGroupName(const Value: string);
begin
  FGroupName := Value;
  Include(FModifiedParams, umGroupName);
end;

procedure TIBCUserInfo.SetSystemUserName(const Value: string);
begin
  FSystemUserName := Value;
  Include(FModifiedParams, umSystemUserName);
end;

procedure TIBCUserInfo.SetDefaultRole(const Value: string);
begin
  FDefaultRole := Value;
  Include(FModifiedParams, umDefaultRole);
end;

procedure TIBCUserInfo.SetDescription(const Value: string);
begin
  FDescription := Value;
  Include(FModifiedParams, umDescription);
end;

procedure TIBCUserInfo.SetSQLRole(const Value: string);
begin
  FSQLRole := Value;
  Include(FModifiedParams, umSQLRole);
end;

procedure TIBCUserInfo.SetActiveUser(Value: Boolean);
begin
  FActiveUser := Value;
  Include(FModifiedParams, umActiveUser);
end;

procedure TIBCUserInfo.Clear;
begin
  FModifiedParams := [];
  FPassword := '';
  FFirstName := '';
  FMiddleName := '';
  FLastName := '';
  FUserID := 0;
  FGroupID := 0;
  FGroupName := '';
  FSystemUserName := '';
  FDefaultRole := '';
  FDescription := '';
  FSQLRole := '';
  FActiveUser := False;
end;

{ TIBCSecurityService }

constructor TIBCSecurityService.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FUserInfoList := TObjectList.Create;
  FUserInfo := TIBCUserInfo.Create;
end;

destructor TIBCSecurityService.Destroy;
begin
  FUserInfoList.Clear;
  FUserInfoList.Free;
  FUserInfo.Free;

  inherited;
end;

procedure TIBCSecurityService.Loaded;
begin
  inherited;

  FUserInfo.Clear;
end;

procedure TIBCSecurityService.ExecuteSQL(const SQL: string);
var
  Connection: TIBCConnection;
  IBCSQL: TIBCSQL;
begin
  IBCSQL := nil;
  Connection := CreateConnection(UserDatabase);
  try
    if GetFullODS(Connection.DatabaseInfo) < 11.2 then
      RaiseError(SIB75feature);

    IBCSQL := TIBCSQL.Create(nil);
    IBCSQL.Connection := Connection;
    IBCSQL.SQL.Text := SQL;

    Connection.StartTransaction;
    IBCSQL.Execute;
    Connection.Commit;
  finally
    IBCSQL.Free;
    Connection.Free;
  end;
end;

procedure TIBCSecurityService.SetServiceStartOptions;
begin
  case FSecurityAction of
    saAddUser: begin
      if Length(FUserInfo.UserName) = 0 then
        RaiseError(SStartParamsError);
      if Pos(' ', FUserInfo.UserName) > 0 then
        RaiseError(SStartParamsError);

      Action := isc_action_svc_add_user;
      InitServiceStartParams(isc_action_svc_add_user);
      AddServiceStartParam(isc_spb_sec_username, FUserInfo.UserName);
      AddServiceStartParam(isc_spb_sec_password, FUserInfo.Password);
      AddServiceStartParam(isc_spb_sec_firstname, FUserInfo.FirstName);
      AddServiceStartParam(isc_spb_sec_middlename, FUserInfo.MiddleName);
      AddServiceStartParam(isc_spb_sec_lastname, FUserInfo.LastName);
      AddServiceStartParam32(isc_spb_sec_userid, FUserInfo.UserID);
      AddServiceStartParam32(isc_spb_sec_groupid, FUserInfo.GroupID);
      AddServiceStartParam(isc_spb_sec_groupname, FUserInfo.GroupName);
      AddServiceStartParam(SPBConstantValues[isc_spb_sql_role_name], FUserInfo.SQLRole);
    end;

    saModifyUser: begin
      if Length(FUserInfo.UserName) = 0 then
        RaiseError(SStartParamsError);

      Action := isc_action_svc_modify_user;
      InitServiceStartParams(isc_action_svc_modify_user);
      AddServiceStartParam(isc_spb_sec_username, FUserInfo.UserName);
      if umPassword in FUserInfo.ModifiedParams then
        AddServiceStartParam(isc_spb_sec_password, FUserInfo.Password);
      if umFirstName in FUserInfo.ModifiedParams then
        AddServiceStartParam(isc_spb_sec_firstname, FUserInfo.FirstName);
      if umMiddleName in FUserInfo.ModifiedParams then
        AddServiceStartParam(isc_spb_sec_middlename, FUserInfo.MiddleName);
      if umLastName in FUserInfo.ModifiedParams then
        AddServiceStartParam(isc_spb_sec_lastname, FUserInfo.LastName);
      if umUserId in FUserInfo.ModifiedParams then
        AddServiceStartParam32(isc_spb_sec_userid, FUserInfo.UserID);
      if umGroupId in FUserInfo.ModifiedParams then
        AddServiceStartParam32(isc_spb_sec_groupid, FUserInfo.GroupID);
      if umGroupName in FUserInfo.ModifiedParams then
        AddServiceStartParam(isc_spb_sec_groupname, FUserInfo.GroupName);
      if umSQLRole in FUserInfo.ModifiedParams then
        AddServiceStartParam(SPBConstantValues[isc_spb_sql_role_name], FUserInfo.SQLRole);
    end;

    saDeleteUser: begin
      if Length(FUserInfo.UserName) = 0 then
        RaiseError(SStartParamsError);

      Action := isc_action_svc_delete_user;
      InitServiceStartParams(isc_action_svc_delete_user);
      AddServiceStartParam(isc_spb_sec_username, FUserInfo.UserName);
      if umSQLRole in FUserInfo.ModifiedParams then
        AddServiceStartParam(SPBConstantValues[isc_spb_sql_role_name], FUserInfo.SQLRole);
    end;
  end;

  FUserInfo.Clear;
end;

procedure TIBCSecurityService.FetchUserInfo;
var
  CurPos: Integer;
  Connection: TIBCConnection;
  IBCQuery: TIBCQuery;
  NewUserInfo: TIBCUserInfo;
begin
  FUserInfoList.Clear;
  if UserDatabase = '' then begin
    InternalServiceQuery(isc_info_svc_get_users);
    if Marshal.ReadByte(FOutputBuffer) <> isc_info_svc_get_users then
      RaiseError(SOutputParsingError);

    CurPos := 3;
    while Marshal.ReadByte(FOutputBuffer, CurPos) <> isc_info_end do begin
      NewUserInfo := TIBCUserInfo.Create;
      FUserInfoList.Add(NewUserInfo);

      if Marshal.ReadByte(FOutputBuffer, CurPos) <> isc_spb_sec_username then
        RaiseError(SOutputParsingError);
      Inc(CurPos);
      NewUserInfo.FUserName := ParseString(CurPos);

      if Marshal.ReadByte(FOutputBuffer, CurPos) <> isc_spb_sec_firstname then
        RaiseError(SOutputParsingError);
      Inc(CurPos);
      NewUserInfo.FFirstName := ParseString(CurPos);

      if Marshal.ReadByte(FOutputBuffer, CurPos) <> isc_spb_sec_middlename then
        RaiseError(SOutputParsingError);
      Inc(CurPos);
      NewUserInfo.FMiddleName := ParseString(CurPos);

      if Marshal.ReadByte(FOutputBuffer, CurPos) <> isc_spb_sec_lastname then
        RaiseError(SOutputParsingError);
      Inc(CurPos);
      NewUserInfo.FLastName := ParseString(CurPos);

      if Marshal.ReadByte(FOutputBuffer, CurPos) <> isc_spb_sec_userId then
        RaiseError(SOutputParsingError);
      Inc(CurPos);
      NewUserInfo.FUserId := ParseInteger(CurPos);

      if Marshal.ReadByte(FOutputBuffer, CurPos) <> isc_spb_sec_groupid then
        RaiseError(SOutputParsingError);
      Inc(CurPos);
      NewUserInfo.FGroupID := ParseInteger(CurPos);
    end;
  end
  else begin
    Connection := CreateConnection(UserDatabase);
    IBCQuery := TIBCQuery.Create(nil);
    try
      IBCQuery.Connection := Connection;
      Connection.StartTransaction;
      IBCQuery.SQL.Text := 'SELECT * FROM RDB$USERS';
      IBCQuery.Execute;

      while not IBCQuery.Eof do begin
        NewUserInfo := TIBCUserInfo.Create;
        FUserInfoList.Add(NewUserInfo);

        NewUserInfo.FUserName := TrimRight(IBCQuery.FieldByName('RDB$USER_NAME').AsString);
        NewUserInfo.FGroupID := IBCQuery.FieldByName('RDB$GID').AsInteger;
        NewUserInfo.FUserID := IBCQuery.FieldByName('RDB$UID').AsInteger;
        NewUserInfo.FGroupName := TrimRight(IBCQuery.FieldByName('RDB$GROUP_NAME').AsString);
        NewUserInfo.FSystemUserName := TrimRight(IBCQuery.FieldByName('RDB$SYSTEM_USER_NAME').AsString);
        NewUserInfo.FDefaultRole := TrimRight(IBCQuery.FieldByName('RDB$DEFAULT_ROLE').AsString);
        NewUserInfo.FFirstName := TrimRight(IBCQuery.FieldByName('RDB$FIRST_NAME').AsString);
        NewUserInfo.FMiddleName := TrimRight(IBCQuery.FieldByName('RDB$MIDDLE_NAME').AsString);
        NewUserInfo.FLastName := TrimRight(IBCQuery.FieldByName('RDB$LAST_NAME').AsString);
        NewUserInfo.FDescription := TrimRight(IBCQuery.FieldByName('RDB$Description').AsString);
        NewUserInfo.FActiveUser := TrimRight(IBCQuery.FieldByName('RDB$USER_ACTIVE').AsString) = 'Y';
        IBCQuery.Next;
      end;
      Connection.Commit;
    finally
      IBCQuery.Free;
      Connection.Free;
    end;
  end;
end;

procedure TIBCSecurityService.AddUser;
var
  SQL: string;
begin
  if FUserDatabase = '' then begin
    SecurityAction := saAddUser;
    ServiceStart;
  end
  else begin
    SQL := 'CREATE USER ' + FUserInfo.UserName + ' SET PASSWORD ' + QuotedStr(FUserInfo.Password);
    if FUserInfo.DefaultRole <> '' then
      SQL := SQL + ' DEFAULT ROLE ' + QuotedStr(FUserInfo.DefaultRole);
    if FUserInfo.SystemUserName <> '' then
      SQL := SQL + ' SYSTEM USER NAME ' + QuotedStr(FUserInfo.SystemUserName);
    if FUserInfo.GroupName <> '' then
      SQL := SQL + ' GROUP NAME ' + QuotedStr(FUserInfo.GroupName);
    if FUserInfo.UserID > 0 then
      SQL := SQL + ' UID ' + IntToStr(FUserInfo.UserID);
    if FUserInfo.GroupID > 0 then
      SQL := SQL + ' GID ' + IntToStr(FUserInfo.GroupID);
    if FUserInfo.Description <> '' then
      SQL := SQL + ' DESCRIPTION ' + QuotedStr(FUserInfo.Description);
    if FUserInfo.FirstName <> '' then
      SQL := SQL + ' FIRST NAME ' + QuotedStr(FUserInfo.FirstName);
    if FUserInfo.MiddleName <> '' then
      SQL := SQL + ' MIDDLE NAME ' + QuotedStr(FUserInfo.MiddleName);
    if FUserInfo.LastName <> '' then
      SQL := SQL + ' LAST NAME ' + QuotedStr(FUserInfo.LastName);
    if FUserInfo.ActiveUser then
      SQL := SQL + ' ACTIVE'
    else
      SQL := SQL + ' INACTIVE';

    ExecuteSQL(SQL);
  end;
end;

procedure TIBCSecurityService.ModifyUser;
var
  SQL: string;
begin
  if FUserDatabase = '' then begin
    SecurityAction := saModifyUser;
    ServiceStart;
  end
  else begin
    SQL := 'ALTER USER ' + FUserInfo.UserName + ' SET';
    if umPassword in FUserInfo.ModifiedParams then
      SQL := SQL + ' PASSWORD ' + QuotedStr(FUserInfo.Password);
    if umDefaultRole in FUserInfo.ModifiedParams then
      if FUserInfo.DefaultRole <> '' then
        SQL := SQL + ' DEFAULT ROLE ' + QuotedStr(FUserInfo.DefaultRole)
      else
        SQL := SQL + ' NO DEFAULT ROLE';
    if umSystemUserName in FUserInfo.ModifiedParams then
      if FUserInfo.SystemUserName <> '' then
        SQL := SQL + ' SYSTEM USER NAME ' + QuotedStr(FUserInfo.SystemUserName)
      else
        SQL := SQL + ' NO SYSTEM USER NAME';
    if umGroupName in FUserInfo.ModifiedParams then
      if FUserInfo.GroupName <> '' then
        SQL := SQL + ' GROUP NAME ' + QuotedStr(FUserInfo.GroupName)
      else
        SQL := SQL + ' NO GROUP NAME';
    if umUserID in FUserInfo.ModifiedParams then
      if FUserInfo.UserID > 0 then
        SQL := SQL + ' UID ' + IntToStr(FUserInfo.UserID)
      else
        SQL := SQL + ' NO UID';
    if umGroupID in FUserInfo.ModifiedParams then
      if FUserInfo.GroupID > 0 then
        SQL := SQL + ' GID ' + IntToStr(FUserInfo.GroupID)
      else
        SQL := SQL + ' NO GID';
    if umDescription in FUserInfo.ModifiedParams then
      if FUserInfo.Description <> '' then
        SQL := SQL + ' DESCRIPTION ' + QuotedStr(FUserInfo.Description)
      else
        SQL := SQL + ' NO DESCRIPTION';
    if umFirstName in FUserInfo.ModifiedParams then
      if FUserInfo.FirstName <> '' then
        SQL := SQL + ' FIRST NAME ' + QuotedStr(FUserInfo.FirstName)
      else
        SQL := SQL + ' FIRST NAME';
    if umMiddleName in FUserInfo.ModifiedParams then
      if FUserInfo.MiddleName <> '' then
        SQL := SQL + ' MIDDLE NAME ' + QuotedStr(FUserInfo.MiddleName)
      else
        SQL := SQL + ' MIDDLE NAME';
    if umLastName in FUserInfo.ModifiedParams then
      if FUserInfo.LastName <> '' then
        SQL := SQL + ' LAST NAME ' + QuotedStr(FUserInfo.LastName)
      else
        SQL := SQL + ' LAST NAME';
    if umActiveUser in FUserInfo.ModifiedParams then
      if FUserInfo.ActiveUser then
        SQL := SQL + ' ACTIVE'
      else
        SQL := SQL + ' INACTIVE';

    ExecuteSQL(SQL);
  end;
end;

procedure TIBCSecurityService.DeleteUser;
begin
  if FUserDatabase = '' then begin
    SecurityAction := saDeleteUser;
    ServiceStart;
  end
  else
    ExecuteSQL('DROP USER ' + FUserInfo.UserName);
end;

procedure TIBCSecurityService.DisplayUser(const UserName: string);
begin
  if UserDatabase = '' then begin
    SecurityAction := saDisplayUser;
    InitServiceStartParams(isc_action_svc_display_user);
    AddServiceStartParam(isc_spb_sec_username, UserName);
    InternalServiceStart;
  end;

  FetchUserInfo;
end;

procedure TIBCSecurityService.DisplayUsers;
begin
  if UserDatabase = '' then begin
    SecurityAction := saDisplayUser;
    InitServiceStartParams(isc_action_svc_display_user);
    InternalServiceStart;
  end;

  FetchUserInfo;
end;

procedure TIBCSecurityService.EnableEUA(Value: Boolean);
begin
  if Value then
    ExecuteSQL('ALTER DATABASE DROP ADMIN OPTION')
  else
    ExecuteSQL('ALTER DATABASE ADD ADMIN OPTION');
end;

procedure TIBCSecurityService.SuspendEUA(Value: Boolean);
begin
  if Value then
    ExecuteSQL('ALTER DATABASE SET ADMIN OPTION INACTIVE')
  else
    ExecuteSQL('ALTER DATABASE SET ADMIN OPTION ACTIVE');
end;

function TIBCSecurityService.GetUserInfo(Index: Integer): TIBCUserInfo;
begin
  Result := TIBCUserInfo(FUserInfoList.Items[Index]);
end;

function TIBCSecurityService.GetUserInfosCount: Integer;
begin
  Result := FUserInfoList.Count;
end;

procedure TIBCSecurityService.SetSecurityAction(Value: TIBCSecurityAction);
begin
  FSecurityAction := Value;
  if Value = saDeleteUser then
    FUserInfo.Clear;
end;

{ TIBCTraceService }

constructor TIBCTraceService.Create(AOwner: TComponent);
begin
  inherited;

  FConfig := TStringList.Create;
end;

destructor TIBCTraceService.Destroy;
begin
  FConfig.Free;

  inherited;
end;

procedure TIBCTraceService.StartTrace;
begin
  ServiceStart;
end;

procedure TIBCTraceService.StopTrace(SessionID: integer);
begin
  TraceAction(isc_action_svc_trace_stop, SessionID);
end;

procedure TIBCTraceService.SuspendTrace(SessionID: integer);
begin
  TraceAction(isc_action_svc_trace_suspend, SessionID);
end;

procedure TIBCTraceService.ResumeTrace(SessionID: integer);
begin
  TraceAction(isc_action_svc_trace_resume, SessionID);
end;

procedure TIBCTraceService.ListTraceSessions;
begin
  CheckActive;

  Action := isc_action_svc_trace_list;
  InitServiceStartParams(isc_action_svc_trace_list);

  InternalServiceStart;
end;

procedure TIBCTraceService.SetServiceStartOptions;
begin
  Action := isc_action_svc_trace_start;
  InitServiceStartParams(isc_action_svc_trace_start);

  if Trim(FSessionName) <> '' then
    AddServiceStartParam(isc_spb_trc_name, Trim(FSessionName));

  AddServiceStartParam(isc_spb_trc_cfg, FConfig.Text);
end;

procedure TIBCTraceService.TraceAction(AnAction, SessionID: integer);
begin
  CheckActive;

  Action := AnAction;
  InitServiceStartParams(AnAction);

  AddServiceStartParam32(isc_spb_trc_id, SessionID);

  InternalServiceStart;
end;

function TIBCTraceService.GetConfig: TStrings;
begin
  Result := FConfig;
end;

procedure TIBCTraceService.SetConfig(Value: TStrings);
begin
  FConfig.Assign(Value);
end;

{$ENDIF}

end.
