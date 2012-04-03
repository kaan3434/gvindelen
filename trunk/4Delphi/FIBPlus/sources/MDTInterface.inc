(******************************************************************************)
(*                     Проект "MIRROR DATABASE TOOLS"                         *)
(*============================================================================*)
(*                              Ядро системы                                  *)
(*                 Интрефейсы  межбиблиотечного взаимодействия                *)
(*                               inc реализация                               *)
(*                                                                            *)
(* Мишенков А.Г.                  г.Днепропетровск                12.06.2010. *)
(******************************************************************************)
uses Classes, SysUtils;

(******************************************************************************)
(*                                                                            *)
(*   Типы общего назначения                                                   *)
(*                                                                            *)
(******************************************************************************)

type
  // Тип для разметки внутреней структуры данных переменной
  TMDTVariableStructureType=byte;

const
  (****************************************************************************)
  (*    Констатнты разметки внутреней структуры данных для переменной         *)
  (****************************************************************************)
  mdt_vstUnknown    = 0;
  mdt_vstInteger    = 1;
  mdt_vstDouble     = 2;
  mdt_vstString     = 3;
  mdt_vstSmallInt   = 4;
  mdt_vstTimeStamp  = 5;
  mdt_vstBoolean    = 6;
  mdt_vstInt64      = 7;
  mdt_vstGUID       = 8;
  mdt_vstExtended   = 9;

  mdt_vstUnitMaxCode=9;
  mdt_vstReserveBorderCode = 1000;

  mdt_AllVariableMaxDinamicLength=High(Longint) - SizeOf(Integer);
  mdt_OneVariableMaxDinamicLength=mdt_AllVariableMaxDinamicLength div 255;

type
  // Тип для разметки методов сравнения строк
  TMDTVariableStringCompareType=byte;

  TMDTTimeStampMode=(
    tsmFull,
    tsmOnlyDate,
    tsmOnlyTime);

  TMDTFloatType=(
    tftDouble,
    tftFloat);

type
  (****************************************************************************)
  (*    Уровни изоляции транзакции                                            *)
  (****************************************************************************)
  TMDTIsolationLevel=(
    ilReadCommited,
    ilSnapshot);

  (****************************************************************************)
  (*    Маркеровка доступных операций                                         *)
  (****************************************************************************)
  TMDTEnableOper=(
    eoRead,
    eoReadWrite);

  PTimeStamp=^TTimeStamp;
  PBoolean=^boolean;

  (****************************************************************************)
  (*    Режимы выполнения SQL запроса                                         *)
  (****************************************************************************)
  TMDTSQLExecutor=(
    se_Server,              //Всегда выполняыется на сервере
    se_Local,               //Всегда выполняыется только средствами MDT на клиенте
    se_ServerAfterLocal);   //Выполняется средствами MDT на клиенте, в случае неудачнной попытки подготовки выполняется на сервере

  (****************************************************************************)
  (*    Разметка  состояния курсора                                           *)
  (****************************************************************************)
  TMDTCursorState=(
    csUnknow,
    csAfterLast,
    csBeforeFirst,
    csInside);

(******************************************************************************)
(*                                                                            *)
(*   Интерфейсы общего назначения                                              *)
(*                                                                            *)
(******************************************************************************)
  (****************************************************************************)
  (*    Главный объект, владеющего самостоятельно разрушаемыми объектами      *)
  (****************************************************************************)
const
  iid_MDTMasterObject: TGUID =
    '{1B075524-1204-4AB0-BF02-A75BC3D6A8B4}';
type
  IMDTMasterObject=interface(IUnknown)
  ['{1B075524-1204-4AB0-BF02-A75BC3D6A8B4}']
    //Метод вызываемый подчинееным элементом при своем разрушении
    procedure LinkedChieldDestroy(AIChield:IUnknown); stdcall;
    procedure LinkedChieldBeforeConnect(AIChield:IUnknown); stdcall;
    procedure LinkedChieldAfterConnect(AIChield:IUnknown); stdcall;
    procedure LinkedChieldBeforeDisconnect(AIChield:IUnknown); stdcall;
    procedure LinkedChieldAfterDisconnect(AIChield:IUnknown); stdcall;
    end;

  (****************************************************************************)
  (*    Подчиненный, самостоятельно разрушаемый  объект                       *)
  (****************************************************************************)
const
  iid_MDTChieldObject: TGUID =
    '{89FD382E-B601-4855-A674-111CD54DB723}';
type
  IMDTChieldObject=interface(IUnknown)
  ['{89FD382E-B601-4855-A674-111CD54DB723}']
    //Регистрацию объекта мастра (владельца)
    procedure AddMasterLink(
      AIMaster:IMDTMasterObject); stdcall;
    //Отмена регистрации объекта мастра (владельца)
    procedure DeleteMasterLink(AMaster:IMDTMasterObject); stdcall;
    end;

(******************************************************************************)
(*                                                                            *)
(*   Интерфейсы базовых классов MDT-библиотеки                                *)
(*                                                                            *)
(******************************************************************************)

  (****************************************************************************)
  (*   Переменная MDT                                                         *)
  (****************************************************************************)
const
  iid_MDTVariable: TGUID =
    '{CD40CA94-4FAB-4F9B-BA28-693797AF42CE}';
type
  IMDTVariable=interface(IUnknown)
  ['{CD40CA94-4FAB-4F9B-BA28-693797AF42CE}']
    function GetName: string;
    function GetStructureType: TMDTVariableStructureType;
    function GetMaxLength: integer;
    function GetAlwaysMaxLength: boolean;
    function GetPrecision: byte;
    function GetTimeStampMode: TMDTTimeStampMode;
    function GetNotNull: boolean;

    property Name: string read GetName;
    property StructureType: TMDTVariableStructureType read GetStructureType;
    property MaxLength: integer read GetMaxLength;
    property AlwaysMaxLength: boolean read GetAlwaysMaxLength;
    property Precision: byte read GetPrecision;
    property TimeStampMode: TMDTTimeStampMode read GetTimeStampMode;
    property NotNull: boolean read GetNotNull;
    end;

  (****************************************************************************)
  (*   Коллекция переменных MDT                                               *)
  (****************************************************************************)
const
  iid_MDTVariables: TGUID =
    '{E34783F8-C18F-4025-9D6E-F53F9949CD64}';
type
  IMDTVariables=interface(IUnknown)
  ['{E34783F8-C18F-4025-9D6E-F53F9949CD64}']
    function GetOwnerObject: TObject;
    function GetVariableCount: integer;
    function GetIVariable(AIndex: integer): IMDTVariable;

    property VariableCount: integer read GetVariableCount;
    property IVariable[AIndex: integer]: IMDTVariable read GetIVariable;
    end;

  (****************************************************************************)
  (*   Запись данных MDT                                                      *)
  (****************************************************************************)
const
  iid_MDTDataRecord: TGUID =
    '{6A4903A6-D57B-4B87-A051-C0EE7196ABE9}';
type
  IMDTDataRecord=interface(IUnknown)
  ['{6A4903A6-D57B-4B87-A051-C0EE7196ABE9}']
    function GetOwnerObject: TObject;
    function GetIVariables: IMDTVariables;
    function GetIsNullMark(AIndex: integer): boolean;
    procedure GetDataBuffer(AIndex: integer; var RDataBuffer: pointer;
      var RSize: integer);
    procedure ClearValue(AIndex: integer);
    procedure WriteDataToBuffer(AIndex: integer; ADataBuffer: pointer;
      ASize: integer); overload;
    procedure WriteDataToBuffer(AIndex: integer; AStream: TStream;
      ASize: integer = -1); overload;
    function GetIntegerValue(AIndex: integer): integer;
    procedure SetIntegerValue(AIndex:integer; AValue:integer);
    function GetSmallIntValue(AIndex: integer): smallInt;
    procedure SetSmallIntValue(AIndex: integer; AValue: smallInt);
    function GetDoubleValue(AIndex: integer): Double;
    procedure SetDoubleValue(AIndex: integer; AValue: Double);
    function GetExtendedValue(AIndex: integer): Extended;
    procedure SetExtendedValue(AIndex: integer; AValue: Extended);
    function GetBooleanValue(AIndex: integer): Boolean;
    procedure SetBooleanValue(AIndex: integer; AValue: Boolean);
    function GetTimeStampValue(AIndex: integer): TTimeStamp;
    procedure SetTimeStampValue(AIndex: integer; AValue: TTimeStamp);
    function GetInt64Value(AIndex: integer): int64;
    procedure SetInt64Value(AIndex: integer; AValue: int64);
    function GetStringValue(AIndex: integer): string;
    procedure SetStringValue(AIndex: integer; AValue: string);

    property IVariables: IMDTVariables read GetIVariables;
    property IsNull[AIndex: integer]: boolean read GetIsNullMark;
    property IntegerValue[AIndex: integer]: integer
      read GetIntegerValue write SetIntegerValue;
    property SmallIntValue[AIndex: integer]: smallInt
      read GetSmallIntValue write SetSmallIntValue;
    property DoubleValue[AIndex: integer]: Double
      read GetDoubleValue write SetDoubleValue;
    property ExtendedValue[AIndex: integer]: Extended
      read GetExtendedValue write SetExtendedValue;
    property BooleanValue[AIndex: integer]: Boolean
      read GetBooleanValue write SetBooleanValue;
    property TimeStampValue[AIndex: integer]: TTimeStamp
      read GetTimeStampValue write SetTimeStampValue;
    property Int64Value[AIndex: integer]: int64
      read GetInt64Value write SetInt64Value;
    property StringValue[AIndex: integer]: string
      read GetStringValue write SetStringValue;
    end;

  (****************************************************************************)
  (*   Выражение SQL                                                          *)
  (****************************************************************************)
const
  iid_MDTSQLEvalution: TGUID =
    '{1B34210F-2F37-493C-BAA8-ED08ABE33997}';
type
  IMDTSQLEvalution=interface(IUnknown)
  ['{1B34210F-2F37-493C-BAA8-ED08ABE33997}']
    end;

  (****************************************************************************)
  (*   Список выражений-параметров                                            *)
  (****************************************************************************)
const
  iid_MDTSQLParamEvalutions: TGUID =
    '{CE8BBCA2-6AD6-4C9C-83A9-AC1D0379363F}';
type
  IMDTSQLParamEvalutions=interface(IUnknown)
  ['{CE8BBCA2-6AD6-4C9C-83A9-AC1D0379363F}']
    function GetCount: integer;
    procedure FillVariables(AVariables:IMDTVariables); 

    property Count: integer read GetCount;
    end;

  (****************************************************************************)
  (*   Структура запроса                                                      *)
  (****************************************************************************)
const
  iid_MDTSQLSelect: TGUID =
    '{979A3C3C-D5E3-4FD0-B290-16663A1671B1}';
type
  IMDTSQLSelect=interface(IUnknown)
  ['{979A3C3C-D5E3-4FD0-B290-16663A1671B1}']
    function GetOwnerObject: TObject;
    end;

  (****************************************************************************)
  (*   Лексический анализатор                                                 *)
  (****************************************************************************)
const
  iid_MDTLexicalAnalizer: TGUID =
    '{AC061E8B-62F7-42ED-8ADC-9FE8FF0A2591}';
type
  IMDTLexicalAnalizer=interface(IUnknown)
  ['{AC061E8B-62F7-42ED-8ADC-9FE8FF0A2591}']
    procedure SetSourceText(ASourceText: TStringList);
    end;

  (****************************************************************************)
  (*   Транслятор                                                             *)
  (****************************************************************************)
const
  iid_MDTSQLSelectParser: TGUID =
    '{0D8EA340-813F-4D88-B711-82651176DE57}';
type
  IMDTSQLSelectParser=interface(IUnknown)
  ['{0D8EA340-813F-4D88-B711-82651176DE57}']
    function GetOwnerObject: TObject;
    function ITranslate(AStartErrorKey: boolean): IMDTSQLSelect;
    procedure CheckEndOfText;
    end;

  (****************************************************************************)
  (*   Интерфейс поиска таблицы по имени поля                                 *)
  (****************************************************************************)
const
  iid_MDTFindTableByField: TGUID =
    '{6FDB97B7-7B7B-4B6E-9AB9-4BA382263FB0}';
type
  IMDTFindTableByField=interface(IUnknown)
  ['{6FDB97B7-7B7B-4B6E-9AB9-4BA382263FB0}']
    function FindTableByField(AFieldIndex: integer): string;
    end;

  (****************************************************************************)
  (*   Данные построения источника данных                                     *)
  (****************************************************************************)
const
  iid_MDTSQLBuildDataOrderAddData: TGUID =
    '{9811EEF3-72A9-4032-91D1-DD827A1E8C1A}';
type
  IMDTSQLBuildDataOrderAddData=interface(IUnknown)
  ['{9811EEF3-72A9-4032-91D1-DD827A1E8C1A}']
    function GetOwnerObject: TObject;
    function GetFindTableByField: IMDTFindTableByField;

    property FindTableByField: IMDTFindTableByField read GetFindTableByField;
    end;

  (****************************************************************************)
  (*    Источник данных MDT                                                   *)
  (****************************************************************************)
const
  iid_MDTDataOrder: TGUID =
    '{19DF9633-7A11-4718-9D02-02204DFED96E}';
type
  IMDTDataOrder=interface(IUnknown)
  ['{19DF9633-7A11-4718-9D02-02204DFED96E}']
    function GetOpened: boolean;
    procedure Close;
    procedure FreeWithSourceOrders;
    procedure ActualTablesLocalStorage;
    procedure Open;
    procedure Next;
    function GetCursorState: TMDTCursorState;
    procedure SetParamsDataRecord(ADataRecord: IMDTDataRecord);
    function GetIZeroLeavingRecord: IMDTDataRecord;

    property Opened: boolean read GetOpened;
    property CursorState: TMDTCursorState read GetCursorState;
    property IZeroLeavingRecord: IMDTDataRecord read GetIZeroLeavingRecord;
    end;

  (****************************************************************************)
  (*   Процессор SQL                                                          *)
  (****************************************************************************)
const
  iid_MDTSQLProcessor: TGUID =
    '{A63104C6-93FB-42BA-84B1-59458F7315BD}';
type
  IMDTSQLProcessor=interface(IUnknown)
  ['{A63104C6-93FB-42BA-84B1-59458F7315BD}']
    procedure ClientPrepareSelectData(ASelect: IMDTSQLSelect);
    function CreateBuildDataOrderAddData: IMDTSQLBuildDataOrderAddData;
    function BuildSelectDataOrder(ASelect: IMDTSQLSelect;
      RAddData: IMDTSQLBuildDataOrderAddData): IMDTDataOrder;
    function GetIParamEvalutions: IMDTSQLParamEvalutions;

    property IParamEvalutions: IMDTSQLParamEvalutions read GetIParamEvalutions;
    end;

  (****************************************************************************)
  (*   Компонент параметров соедигнения к реальной базе                       *)
  (****************************************************************************)
const
  iid_MDTDatabaseConnectParams: TGUID =
    '{BA1903CD-155E-4022-93C4-C057B5306C8E}';
type
  IMDTDatabaseConnectParams=interface(IUnknown)
  ['{BA1903CD-155E-4022-93C4-C057B5306C8E}']
   procedure SetUserName(AValue:string);
   function GetUserName:string;
   procedure SetPassword(AValue:string);
   function GetPassword:string;
   procedure SetRoleName(AValue:string);
   function GetRoleName:string;

   property UserName:string read GetUserName write SetUserName;
   property Password:string read GetPassword write SetPassword;
   property RoleName:string read GetRoleName write SetRoleName;
   end;

  (****************************************************************************)
  (*   Компонент реальной базы данных                                         *)
  (****************************************************************************)
const
  iid_MDTRealDataBase: TGUID =
    '{C66F622B-B883-4C70-A620-13791DF61DF0}';
type
  IMDTRealDataBase=interface(IUnknown)
  ['{C66F622B-B883-4C70-A620-13791DF61DF0}']
    end;

  (****************************************************************************)
  (*   Компонент параметров транзакции                                        *)
  (****************************************************************************)
const
  iid_MDTTransactionParams: TGUID =
    '{358A6CDA-8624-4553-BB26-28530D57192C}';
type
  IMDTTransactionParams=interface(IUnknown)
  ['{358A6CDA-8624-4553-BB26-28530D57192C}']
    function GetOwnerObject: TObject;
    function GetIsolationLevel: TMDTIsolationLevel;
    procedure SetIsolationLevel(AValue: TMDTIsolationLevel);
    function GetEnableOper: TMDTEnableOper;
    procedure SetEnableOper(AValue: TMDTEnableOper);

    property IsolationLevel: TMDTIsolationLevel
      read GetIsolationLevel write SetIsolationLevel;
    property EnableOper:TMDTEnableOper read GetEnableOper write SetEnableOper;
    end;

  (****************************************************************************)
  (*   Компонент реальной транзакции                                          *)
  (****************************************************************************)
const
  iid_MDTRealDBTransaction: TGUID =
    '{27F2A58B-355E-4BBE-A245-4DD9671645C8}';
type
  IMDTRealDBTransaction=interface(IUnknown)
  ['{27F2A58B-355E-4BBE-A245-4DD9671645C8}']
    function GetOwnerObject: TObject;
    function GetActive: boolean;
    procedure Rollback;

    property Active: boolean read GetActive;
    end;

  (****************************************************************************)
  (*   Компонент подключения MDT базы данных к реальнным базам                *)
  (****************************************************************************)
const
  iid_MDTRealDBCanal: TGUID =
    '{244A9528-959C-4B80-933F-9C2AA13A61CB}';
type
  IMDTRealDBCanal=interface(IUnknown)
  ['{244A9528-959C-4B80-933F-9C2AA13A61CB}']
    function GetOwnerObject: TObject;
    function GetIDatabaseConnectParams:IMDTDatabaseConnectParams;
    function GetIMDTRealDataBase:IMDTRealDataBase;
    function CreateIMDTTransactionParams:IMDTTransactionParams;
    function CreateIMDTRealDBTransaction:IMDTRealDBTransaction;

    property IDatabaseConnectParams:IMDTDatabaseConnectParams
      read GetIDatabaseConnectParams;
    property IMDTRealDataBase:IMDTRealDataBase
      read GetIMDTRealDataBase;
    end;

  (****************************************************************************)
  (*   Компонент защищенного блока                                            *)
  (****************************************************************************)
const
  iid_MDTProtectedBlock: TGUID =
    '{34DDF342-9EDD-4C14-9EB3-9DEC31EEE36E}';
type
  IMDTProtectedBlock=interface(IUnknown)
  ['{85D1F66F-71C2-49F6-B630-386F6C314CA3}']
    function GetOwnerObject: TObject;
    end;

  (****************************************************************************)
  (*   Компонент стека защищенных блоков                                      *)
  (****************************************************************************)
const
  iid_MDTProtectedBlocks: TGUID =
    '{B288C36C-FD78-41A3-8D54-7F7D3CDB2C9F}';
type
  IMDTProtectedBlocks=interface(IUnknown)
  ['{B288C36C-FD78-41A3-8D54-7F7D3CDB2C9F}']
    function GetBlockCount: integer;
    function FindByName(AName: string): IMDTProtectedBlock;
    function ILast: IMDTProtectedBlock;

    property BlockCount: integer read GetBlockCount;
    end;

  (****************************************************************************)
  (*    Головной компонент MDT база данных                                    *)
  (****************************************************************************)
const
  iid_MDTDatabase: TGUID =
    '{D2678073-531D-4EBB-972C-A6A5EC0BCBF0}';
type
  IMDTDatabase=interface(IUnknown)
  ['{D2678073-531D-4EBB-972C-A6A5EC0BCBF0}']
    procedure SetConnected(AConnect:boolean);
    function GetConnected:boolean;

    function GetChieldObject:IMDTChieldObject;
    function GetRealDBCanalCount:integer;
    function GetIRealDBCanal(AIndex:integer):IMDTRealDBCanal;
    function GetProtectedBlocks: IMDTProtectedBlocks;
    procedure NewProtectedBlock(var RTransactionParams:IMDTTransactionParams;
      AAtomic:boolean=false); overload;
    procedure NewProtectedBlock(AAtomic:boolean; AName: string = ''); overload;
    procedure PrepareRealDBCanalForDirrectSQL(ARealDBCanal:IMDTRealDBCanal);
    procedure CommitSepareteTransaction(ARealDBTransaction:IMDTRealDBTransaction);
    procedure CommitProtectedBlock;
    procedure RollbackProtectedBlock;
    function GetISQLLexicalAnalizer: IMDTLexicalAnalizer;
    function GetISQLProcessor: IMDTSQLProcessor;
    function CreateISQLClientSelectParser: IMDTSQLSelectParser;
    function CreateVariables: IMDTVariables;
    function CreateDataRecord(AVariables: IMDTVariables): IMDTDataRecord;

    property Connected:boolean read GetConnected write SetConnected;
    property ChieldObject:IMDTChieldObject read GetChieldObject;
    property RealDBCanalCount:integer read GetRealDBCanalCount;
    property IRealDBCanals[AIndex:integer]:IMDTRealDBCanal read GetIRealDBCanal;
    property ProtectedBlocks: IMDTProtectedBlocks read GetProtectedBlocks;
    property ISQLLexicalAnalizer: IMDTLexicalAnalizer read GetISQLLexicalAnalizer;
    property ISQLProcessor: IMDTSQLProcessor read GetISQLProcessor;
    end;

(******************************************************************************)
(*                                                                            *)
(*   Интерфейсы классов MDT-библиотеки для работы с базами IB/FB/YA           *)
(*                                                                            *)
(******************************************************************************)

  (****************************************************************************)
  (*   Дублированные константы и структуры Api сервера                        *)
  (****************************************************************************)
type
  PMDTVoid                      = ^Pointer;
  TMDTISC_DB_HANDLE             = PMDTVoid;
  PMDTISC_DB_HANDLE             = ^TMDTISC_DB_HANDLE;
  TMDTISC_TR_HANDLE             = PMDTVoid;
  PMDTISC_TR_HANDLE             = ^TMDTISC_TR_HANDLE;

  (****************************************************************************)
  (*   Компонент реальной базы данных                                         *)
  (****************************************************************************)
const
  iid_MDTIBRealDataBase: TGUID =
    '{1C8BED35-E362-45E1-8DF7-A5EAC2369D03}';
type
  IMDTIBRealDataBase=interface(IMDTRealDataBase)
  ['{1C8BED35-E362-45E1-8DF7-A5EAC2369D03}']
    procedure SetFileName(AValue:string);
    function GetFileName:string;
    function GetHandle: TMDTISC_DB_HANDLE;

    property FileName:string read GetFileName write SetFileName;
    property Handle:TMDTISC_DB_HANDLE read GetHandle;
   end;

  (****************************************************************************)
  (*   Компонент параметров транзакции IB/FB/YA                               *)
  (****************************************************************************)
const
  iid_MDTIBTransactionParams: TGUID =
    '{F0D24200-6631-4D3D-B5E2-040C2555FCD3}';
type
  IMDTIBTransactionParams=interface(IMDTTransactionParams)
  ['{F0D24200-6631-4D3D-B5E2-040C2555FCD3}']
    procedure ApplyByFullStrings(AParams: TStrings);
    end;

  (****************************************************************************)
  (*   Компонент реальной транзакции IB/FB/YA                                 *)
  (****************************************************************************)
const
  iid_MDTIBRealDBTransaction: TGUID =
    '{EB753871-1D9C-4729-841D-A85377CE8106}';
type
  IMDTIBRealDBTransaction=interface(IMDTRealDBTransaction)
  ['{EB753871-1D9C-4729-841D-A85377CE8106}']
    function GetHandle: TMDTISC_TR_HANDLE;
    function GetITransactionParams: IMDTTransactionParams;
    procedure StartWithNativeParams(
      AIBTransactionParams: IMDTIBTransactionParams);
    procedure CommitRetaining;
    procedure RollbackRetaining;
    function GetDataChange: boolean;
    procedure SetDataChange(AValue: boolean);

    property Handle:TMDTISC_TR_HANDLE read GetHandle;
    property ITransactionParams: IMDTTransactionParams
      read GetITransactionParams;
    property DataChange: boolean read GetDataChange write SetDataChange;
    end;

  (****************************************************************************)
  (*   Компонент подключения MDT-базы к базе IB/FB/YA                         *)
  (****************************************************************************)
const
  iid_MDTIBRealDBCanal: TGUID =
    '{E4EFCAA1-5632-4D91-8569-144FD567C1A4}';
type
  IMDTIBRealDBCanal=interface(IMDTRealDBCanal)
  ['{E4EFCAA1-5632-4D91-8569-144FD567C1A4}']

    function GetIMDTIBRealDataBase:IMDTIBRealDataBase;
    function GetIMDTIBRealCurrentTransaction: IMDTIBRealDBTransaction;
    function GetIMDTIBRealLongTransaction: IMDTIBRealDBTransaction;

    property IMDTIBRealDataBase:IMDTIBRealDataBase
      read GetIMDTIBRealDataBase;
    property IMDTIBRealCurrentTransaction:IMDTIBRealDBTransaction
      read GetIMDTIBRealCurrentTransaction;
    property IMDTIBRealLongTransaction:IMDTIBRealDBTransaction
      read GetIMDTIBRealLongTransaction;
    end;


