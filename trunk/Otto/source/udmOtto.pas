unit udmOtto;

interface

uses
  SysUtils, Classes, GvVars, FIBDatabase, pFIBDatabase, FIBQuery,
  pFIBQuery, pFIBStoredProc, DBLookupEh, NativeXml, MemTableEh, DB,
  FIBDataSet, pFIBDataSet, Variants, MemTableDataEh, IB_Services, 
  JvComponentBase, JvDesktopAlert, Dialogs, JvBaseDlg, ImgList, Controls,
  PngImageList, pngimage, gsFileVersionInfo, dbf;

type
  TdmOtto = class(TDataModule)
    dbOtto: TpFIBDatabase;
    spTemp: TpFIBStoredProc;
    qryParams: TpFIBQuery;
    qryTempRead: TpFIBQuery;
    qryReadObject: TpFIBQuery;
    qryObjectList: TpFIBQuery;
    tblTemp: TpFIBDataSet;
    spObjectSearch: TpFIBStoredProc;
    spTaxRateCalc: TpFIBStoredProc;
    spParamUnparse: TpFIBStoredProc;
    spParamsCreate: TpFIBStoredProc;
    trnAutonomouse: TpFIBTransaction;
    qryTempUpd: TpFIBQuery;
    spActionExecute: TpFIBStoredProc;
    spMessage: TpFIBStoredProc;
    mtblControlSets: TMemTableEh;
    fldControlSets_TAG: TIntegerField;
    fldControlSets_KEYLANG: TStringField;
    fldControlSets_CAPS: TBooleanField;
    spArticleGoC: TpFIBStoredProc;
    fibBackup: TpFIBBackupService;
    fibRestore: TpFIBRestoreService;
    AlertStock: TJvDesktopAlertStack;
    dbfCons: TDbf;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure dbOttoAfterConnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Build: Variant;
    procedure BackupDatabase(aFileName: string);
    procedure RestoreDatabase(aFileName: string);
    procedure ActionExecute(aTransaction: TpFIBTransaction;
      aObjectSign, aActionSign, aParams: string; aDealId: Integer;
      aObjectId: Integer = 0); overload;
    procedure ActionExecute(aTransaction: TpFIBTransaction; aNode: TXmlNode;
      aDealId: Integer = 0; aStatusSign: string = ''); overload;
    procedure ActionExecute(aTransaction: TpFIBTransaction; aActionSign: string;
      aNode: TXmlNode; aDealId: Integer = 0); overload;
    procedure ParamsGet(ParamId: int64; Vars: TVarList);
    function ParamsCreate(aObjectSign: string; aObjectId: Integer=0): Int64; overload;
    function ParamsCreate(aObjectSign: string; aParams: TVarList): Int64; overload;
    procedure FillComboStrings(aKeys, aValues: TStrings; aSQL: string; aTransaction: TpFIBTransaction);
    function GetActionParamId(ActionId: integer): Int64;
    procedure ReadObjectFromDB(aObjectSign: string; aObjectId: integer; aNode: TXmlNode);
    function GetNewObjectId(aObjectSign: string): int64;
    function GetDefaultStatusId(aObjectSign: string): Integer;
    procedure FillMemTable(aMemTable: TMemTableEh; aSQLClause: String);
    function MessageBusy(aTemplateId: Integer): Integer;
    procedure MessageRelease(aTransaction: TpFIBTransaction; aMessageId: Integer);
    procedure MessageSuccess(aTransaction: TpFIBTransaction; aMessageId: Integer);
    procedure MessagePostpone(aTransaction: TpFIBTransaction; aMessageId: Integer);
    procedure MessageError(aTransaction: TpFIBTransaction; aMessageId: Integer);
    function  MagazineDetect(aCatalogName: string): Integer;
    function  CatalogSearch(aCatalogName: string): Integer;
    function GetOrCreateArticleId(aCatalogName, aArticleCode, aDimension: String; aPrice: Single): integer;
    procedure ObjectGet(aNode: TXmlNode; aObjectId: Integer; aTransaction: TpFIBTransaction);
    procedure OrderItemsGet(ndOrderItems: TXmlNode; aOrderId: Integer;
      aTransaction: TpFIBTransaction);
    procedure OrderTaxsGet(ndOrderTaxs: TXmlNode; aOrderId: Integer; aTransaction: TpFIBTransaction);
    procedure ClientRead(ndClient: TxmlNode; aClientId: Integer; aTransaction: TpFIBTransaction);
    procedure AdressRead(ndAdress: TXmlNode; aAdressId: Integer; aTransaction: TpFIBTransaction);
    procedure PlaceRead(ndPlace: TXmlNode; aPlaceId: Integer; aTransaction: TpFIBTransaction);
    procedure MagazineRead(ndMagazine: TxmlNode; aMagazineId: Integer; aTransaction: TpFIBTransaction);
    procedure AccountRead(ndAccount: TxmlNode; aAccountId: Integer; aTransaction: TpFIBTransaction);
//    function GetStatusByFlag(aNode: TXmlNode; aFlagSign: string; aTransaction: TpFIBTransaction): variant;
    function GetStatusBySign(aNode: TXmlNode; aStatusSign: string): Variant; overload;
    function GetStatusBySign(aObjectSign, aStatusSign: string): Variant; overload;
    function GetFlagListById(aStatusId: Integer): string;
    function FlagExists(aNode: TXmlNode; aFlagSign: string): Boolean;
    function SettingGet(aTransaction: TpFIBTransaction; aSettingSign: string): variant;
    function ArticleGoC(aMagazineId: integer; aArticleCode, aDimension: String;
      aPriceEUR: Single; aWeight: Variant; aDescription, aBrand : string;
      aTransaction: TpFIBTransaction): integer;
    procedure SetKeyLayout(aTag: Integer);
    function Recode(aObjectSign, aAttrSign, aValue: String): String;
    function GetNextCounterValue(aObjectSign, aCounterSign: string; aObjectId: Integer): WideString;
    function CreateDeal(aTransaction: TpFIBTransaction): Integer;
    function GetArticleSign(aArticleCode: string; aMagazineId: Integer): string;
    procedure ClearNotify(aMessageId: integer);
    procedure Notify(aMessageId: integer; aNotifyText: string; aNotifyClass: string = 'I'; aParams: string = '');
    procedure GetInvoices(aInvoicesNode: TXmlNode; aOrderId: Integer; aTransaction: TpFIBTransaction);
    procedure CreateAlert(aHeaderText, aMessageText: string;
      DlgType: TMsgDlgType; Duration: Integer=0);
  end;

var
  dmOtto: TdmOtto;
  Path: TVarList;

implementation

{$R *.dfm}
uses
  GvStr, GvFile, GvNativeXml, GvKbd, Windows, GvMath, Forms, uMain;

procedure TdmOtto.ActionExecute(aTransaction: TpFIBTransaction;
  aObjectSign, aActionSign, aParams: string; aDealId: Integer;
  aObjectId: Integer = 0);
var
  stBlob: TStringStream;
begin
  if not aTransaction.Active then
    aTransaction.StartTransaction;
  try
    with spActionExecute do
    begin
      Params.ClearValues;
      Transaction:= aTransaction;
      ParamByName('I_OBJECT_SIGN').AsString:= aObjectSign;
      ParamByName('I_ACTION_SIGN').Value:= IfThen(aActionSign = '', null, aActionSign);
      ParamByName('I_OBJECT_ID').Value:= IfThen(aObjectId=0, null, aObjectId);
      ParamByName('I_DEAL_ID').Value:= IfThen(aDealId = 0, null, aDealId);
      stBlob:= TStringStream.Create(aParams);
      try
        ParamByName('I_PARAMS').LoadFromStream(stBlob);   
        SaveStringAsFile(aParams, 'params.txt');
      finally
        stBlob.Free;
      end;
      ExecProc;
    end;
  except
    aTransaction.Rollback;
    raise;
  end;
end;

procedure TdmOtto.ActionExecute(aTransaction: TpFIBTransaction; aNode: TXmlNode;
  aDealId: Integer = 0; aStatusSign: string = '');
begin
  if aStatusSign <> '' then
    aNode.WriteAttributeString('NEW.STATUS_SIGN', aStatusSign);
  if aNode.ValueAsString<>'' then
    ActionExecute(aTransaction, aNode.Name, '', AttrsAsString(aNode), aDealId, GetXmlAttrValue(aNode, 'ID'));
  aNode.ValueAsString:= '';
end;

procedure TdmOtto.ActionExecute(aTransaction: TpFIBTransaction;
  aActionSign: string; aNode: TXmlNode; aDealId: Integer = 0);
begin
  if aNode.ValueAsString <> '' then
    ActionExecute(aTransaction, aNode.Name, aActionSign, AttrsAsString(aNode), aDealId, GetXmlAttrValue(aNode, 'ID', '0'));
  aNode.ValueAsString:= '';
end;


procedure TdmOtto.DataModuleCreate(Sender: TObject);
var
  dbParams: TVarList;
  BackupFileName: String;
begin
//  GvFile.CopyFile(Path['Database']+'otto_ppz.fdb.old', Path['Database']+'otto_ppz.fdb');
  BackupFileName:= Format('%s%s_Dayly.fbk',
    [Path['Backup'], FormatDateTime('YYYYMMDD', Date)]);
  if not FileExists(BackupFileName) then
  try
    BackupDatabase(BackupFileName);
    CreateAlert('Ежедневная резервная копия', Format(
      'Успеспешно создана (%s)', [BackupFileName]), mtInformation);
  except
    CreateAlert('Ежедневная резервная копия', Format(
      'Ошибка создания (%s)', [BackupFileName]), mtError);
  end;
  if dbOtto.Connected then dbOtto.Close;
  dbParams:= TVarList.Create;
  try
    dbParams.LoadSectionFromIniFile(ProjectIniFileName, 'DataBase');
    dbOtto.DBName:= Path['DataBase']+dbParams['FileName'];
    dbOtto.ConnectParams.UserName:= dbParams['Login'];
    dbOtto.ConnectParams.Password:= dbParams['Password'];
    dbOtto.ConnectParams.CharSet:= 'CYRL';
    dbOtto.Open(true);
  finally
    dbParams.Free;
  end;
end;

procedure TdmOtto.DataModuleDestroy(Sender: TObject);
begin
  dbOtto.Close;
end;

procedure TdmOtto.FillComboStrings(aKeys, aValues: TStrings;
  aSQL: string; aTransaction: TpFIBTransaction);
begin
  with qryTempRead do
  begin
    SQL.Text:= aSQL;
    Transaction:= aTransaction;
    ExecQuery;
    try
      while not Eof do
      begin
        aKeys.Add(Fields[0].Value);
        aValues.Add(Fields[1].Value);
        Next;
      end;
    finally
      Close;
    end;
  end;
end;

function TdmOtto.GetActionParamId(ActionId: integer): Int64;
begin
  Result:= dbOtto.QueryValue(
    'select param_id from paramheads where action_id = :i_action_id', 1, [ActionId]);
end;

procedure TdmOtto.ReadObjectFromDB(aObjectSign: string; aObjectId: integer; aNode: TXmlNode);
var
  PrmName, PrmValue: string;
begin
  with qryReadObject do
  begin
    ExecWP([aObjectSign, aObjectId]);
    try
      while not Eof do
      begin
        PrmName:= Trim(FieldByName('o_Param_Name').AsString);
        PrmValue:= Trim(FieldByName('o_Param_Value').AsString);
        aNode.WriteAttributeString(PrmName , PrmValue);
        Next;
      end;
    finally
      Close;
    end;
  end;
end;

procedure TdmOtto.ParamsGet(ParamId: int64; Vars: TVarList);
begin
  with qryParams do
  begin
    ExecWP([ParamId]);
    try
      while not Eof do
      begin
        Vars[FieldByName('Param_Name').AsString]:= FieldByName('Param_Value').AsString;
        Next;
      end;
    finally
      Close;
    end;
  end;
end;

function TdmOtto.GetNewObjectId(aObjectSign: string): int64;
begin
  result:= dbOtto.QueryValue(Format('select gen_id(seq_%s_id, 1) from rdb$database', [aObjectSign]), 0);
end;

procedure TdmOtto.FillMemTable(aMemTable: TMemTableEh; aSQLClause: String);
begin
  tblTemp.SQLs.SelectSQL.Text:= aSQLClause;
  tblTemp.Open;
  try
    aMemTable.LoadFromDataSet(tblTemp, 0, lmCopy, false)
  finally
    tblTemp.Close;
  end;
end;

function TdmOtto.MessageBusy(aTemplateId: Integer): Integer;
begin
  with spMessage do
  begin
    StoredProcName:= 'MESSAGE_BUSY';
    Params.ClearValues;
    ParamByName('I_TEMPLATE_ID').AsInteger:= aTemplateId;
    ExecProc;
    if not VarIsNull(ParamValue('O_MESSAGE_ID')) then
      Result:= ParamValue('O_MESSAGE_ID')
    else
      Result:= 0;
  end;
end;

procedure TdmOtto.MessageRelease(aTransaction: TpFIBTransaction; aMessageId: Integer);
begin
  with spMessage do
  begin
    StoredProcName:= 'MESSAGE_RELEASE';
    Params.ClearValues;
    ParamByName('I_MESSAGE_ID').AsInteger:= aMessageId;
    ExecProc;
  end;
end;

procedure TdmOtto.MessageError(aTransaction: TpFIBTransaction; aMessageId: Integer);
begin
  ActionExecute(aTransaction, 'MESSAGE', 'MESSAGE_ERROR',  '', 0, aMessageId);
  aTransaction.Commit;
end;

procedure TdmOtto.MessageSuccess(aTransaction: TpFIBTransaction; aMessageId: Integer);
var
  PathDest, FileName: string;
begin
  ActionExecute(aTransaction, 'MESSAGE', 'MESSAGE_SUCCESS', '', 0, aMessageId);
  FileName:= aTransaction.DefaultDatabase.QueryValue(
    'select file_name from messages m where m.message_id = :message_id',
    0, [aMessageId], aTransaction);
  if FileExists(Path['Messages.In']+FileName) then
  begin
    PathDest:= Path['Messages.Processed'] + FormatDateTime('YYYY.MM.DD\', Date);
    ForceDirectories(PathDest);
    GvFile.MoveFile(Path['Messages.In']+FileName, PathDest+FileName);
  end;
end;


function TdmOtto.MagazineDetect(aCatalogName: string): Integer;
begin
  with spTemp do
  begin
    StoredProcName:= 'MAGAZINE_DETECT';
    Params.ClearValues;
    ParamByName('I_CATALOG_NAME').AsString:= aCatalogName;
    try
      ExecProc;
      Result:= ParamValue('O_MAGAZINE_ID');
    except
      Result:= 0;
    end;
  end;
end;

function TdmOtto.CatalogSearch(aCatalogName: string): Integer;
var
  ObjectId: Variant;
begin
  with spObjectSearch do
  begin
    ParamByName('I_VALUE').AsString:= aCatalogName;
    ParamByName('I_FROM_CLAUSE').AsString:= 'catalogs';
    ParamByName('I_FIELDNAME_ID').AsString:= 'catalog_id';
    ParamByName('I_FIELDNAME_NAME').AsString:= 'catalog_name';
    ParamByName('I_THRESHOLD').AsInteger:= 50;
    try
      ExecProc;
      ObjectId:= ParamValue('O_OBJECT_ID');
      if VarIsNull(ObjectId) then
        Result:= 0
      else
        Result:= ObjectId;
    except
      Result:= 0;
    end
  end;
end;

function TdmOtto.GetDefaultStatusId(aObjectSign: string): Integer;
begin
  Result:= dbOtto.QueryValue(
    'select o_status_id from status_get_default(:object_sign)',
    0, [aObjectSign]);
end;

function TdmOtto.GetOrCreateArticleId(aCatalogName, aArticleCode,
  aDimension: String; aPrice: Single): integer;
begin
  result:= dbOtto.QueryValue('select o_article_id from article_goc(:catalog_name, :article_code, :dimension, :price)',
                  0, [aCatalogName, aArticleCode, aDimension, aPrice]);

end;

procedure TdmOtto.MessagePostpone(aTransaction: TpFIBTransaction; aMessageId: Integer);
begin

end;

procedure TdmOtto.ObjectGet(aNode: TXmlNode; aObjectId: Integer;
  aTransaction: TpFIBTransaction);
var
  PrmName, PrmValue: string;
begin
  aNode.AttributesClear;
  with qryReadObject do
  begin
    Transaction:= aTransaction;
    ExecWP([aNode.Name, aObjectId]);
    try
      while not Eof do
      begin
        PrmName:= trim(FieldByName('o_Param_Name').AsString);
        PrmValue:= trim(FieldByName('o_Param_Value').AsString);
        aNode.WriteAttributeString(PrmName, PrmValue);
        Next;
      end;
    finally
      Close;
    end;
  end;
end;

procedure TdmOtto.OrderItemsGet(ndOrderItems: TXmlNode; aOrderId: Integer;
  aTransaction: TpFIBTransaction);
var
  ndOrderItem: TXmlNode;
  OrderItemId: Integer;
begin
  with qryTempUpd do
  begin
    Transaction:= aTransaction;
    SQL.Text:= 'select * from OrderItems where Order_Id = :OrderId order by orderitem_id';
    ExecWP([aOrderId]);
    try
      while not Eof do
      begin
        OrderItemId:= FieldByName('ORDERITEM_ID').AsInteger;
        ndOrderItem:= ndOrderItems.NodeNew('ORDERITEM');
        ObjectGet(ndOrderItem, OrderItemId, aTransaction);
        Next;
      end;
    finally
      Close;
    end;
  end;
end;

procedure TdmOtto.OrderTaxsGet(ndOrderTaxs: TXmlNode; aOrderId: Integer; aTransaction: TpFIBTransaction);
var
  ndOrderItem: TXmlNode;
  OrderItemId: Integer;
begin
  with qryTempUpd do
  begin
    Transaction:= aTransaction;
    SQL.Text:= 'select * from OrderTaxs where Order_Id = :OrderId order by ordertax_id';
    ExecWP([aOrderId]);
    try
      while not Eof do
      begin
        OrderItemId:= FieldByName('ORDERTAX_ID').AsInteger;
        ndOrderItem:= ndOrderTaxs.NodeNew('ORDERTAX');
        ObjectGet(ndOrderItem, OrderItemId, aTransaction);
        Next;
      end;
    finally
      Close;
    end;
  end;
end;

function TdmOtto.ParamsCreate(aObjectSign: string; aObjectId: Integer=0): Int64;
begin
  with spParamsCreate do
  begin
    ParamByName('I_OBJECT_SIGN').AsString := aObjectSign;
    if aObjectId > 0 then
      ParamByName('I_OBJECT_ID').AsInteger:= aObjectId;
    try
      ExecProc;
      Result:= ParamValue('O_PARAM_ID');
    except
    end;
  end;
end;

function TdmOtto.ParamsCreate(aObjectSign: string; aParams: TVarList): Int64;
var
  stBlob: TStringStream;
begin
  Result:= ParamsCreate(aObjectSign);
  with spParamUnparse do
  begin
    ParamByName('I_PARAM_ID').AsInt64:= Result;
    stBlob:= TStringStream.Create(aParams.Text);
    try
      ParamByName('I_PARAMS').LoadFromStream(stBlob);
    finally
      stBlob.Free;
    end;
    ExecProc;
  end;
end;

procedure TdmOtto.AdressRead(ndAdress: TXmlNode; aAdressId: Integer;
  aTransaction: TpFIBTransaction);
begin
  ObjectGet(ndAdress, aAdressId, aTransaction);
  if ndAdress.ReadAttributeInteger('PLACE_ID', 0) <> 0 then
    PlaceRead(ndAdress.NodeByName('PLACE'), GetXmlAttrValue(ndAdress, 'PLACE_ID'), aTransaction);
end;

procedure TdmOtto.ClientRead(ndClient: TxmlNode; aClientId: Integer;
  aTransaction: TpFIBTransaction);
begin
  ObjectGet(ndClient, aClientId, aTransaction);
  if AttrExists(ndClient, 'ACCOUNT_ID') then
    AccountRead(ndClient.NodeFindOrCreate('ACCOUNT'), GetXmlAttrValue(ndClient, 'ACCOUNT_ID'), aTransaction);
end;

procedure TdmOtto.PlaceRead(ndPlace: TXmlNode; aPlaceId: Integer;
  aTransaction: TpFIBTransaction);
begin
  ObjectGet(ndPlace, aPlaceId, aTransaction);
end;

function TdmOtto.GetStatusBySign(aNode: TXmlNode; aStatusSign: string): Variant;
var
  ObjectSign: string;
  StatusId: Variant;
begin
  ObjectSign:= aNode.Name;
  StatusId:= dbOtto.QueryValue(
    'select status_id from statuses where object_sign = :object_sign and status_sign = :status_sign',
    0, [aNode.Name, aStatusSign]);
  if VarIsNull(StatusId) then
    Result:= GetXmlAttrValue(aNode, 'STATUS_ID')
  else
    Result:= StatusId;
end;

function TdmOtto.GetStatusBySign(aObjectSign, aStatusSign: string): Variant;
begin
  Result:= dbOtto.QueryValue(
    'select status_id from statuses where object_sign = :object_sign and status_sign = :status_sign',
    0, [aObjectSign, aStatusSign]);
end;

//function TdmOtto.GetStatusByFlag(aNode: TXmlNode; aFlagSign: string): Variant;
//var
//  ObjectSign: string;
//  StatusId: Variant;
//begin
//  ObjectSign:= aNode.Name;
//  StatusId:= qryStatuses.Lookup('OBJECT_SIGN;FLAG_SIGN', VarArrayOf([ObjectSign, aFlagSign]), 'STATUS_ID');
//  if VarIsNull(StatusId) then
//    Result:= GetXmlAttrValue(aNode, 'STATUS_ID')
//  else
//    Result:= StatusId;
//end;

function TdmOtto.SettingGet(aTransaction: TpFIBTransaction; aSettingSign: string): variant;
begin
  result:= dbOtto.QueryValue('select o_value from setting_get(:setting_sign)',
    0, [aSettingSign], aTransaction);
end;

function TdmOtto.ArticleGoC(aMagazineId: integer; aArticleCode,
  aDimension: String; aPriceEUR: single; aWeight: Variant; aDescription,
  aBrand: string; aTransaction: TpFIBTransaction): integer;
begin
  if aWeight = '' then aWeight:= null;
  with spArticleGoC do
  begin
    Transaction:= aTransaction;
    ParamByName('I_MAGAZINE_ID').AsInteger:= aMagazineId; //I_
    ParamByName('I_ARTICLE_CODE').AsString:= aArticleCode; //I_ARTICLE_CODE
    ParamByName('I_COLOR').Value:= null;
    ParamByName('I_DIMENSION').AsString:= aDimension; //I_DIMENSION
    ParamByName('I_PRICE_EUR').AsFloat:= aPriceEUR; //I_PRICE_EUR
    ParamByName('I_WEIGHT').Value:= aWeight; //I_WEIGHT
    ParamByName('I_DESCRIPTION').AsString:= aDescription; //I_DESCRIPTION
    ExecQuery;
    Result:= ParamValue('O_ARTICLE_ID');
  end;
end;

procedure TdmOtto.MagazineRead(ndMagazine: TxmlNode; aMagazineId: Integer;
  aTransaction: TpFIBTransaction);
begin
  ObjectGet(ndMagazine, aMagazineId, aTransaction);
end;

procedure TdmOtto.AccountRead(ndAccount: TxmlNode; aAccountId: Integer;
  aTransaction: TpFIBTransaction);
begin
  ObjectGet(ndAccount, aAccountId, aTransaction);
end;

procedure TdmOtto.SetKeyLayout(aTag: Integer);
var
  Keys: TKeyboardState;
begin
  if mtblControlSets.Locate('TAG', aTag, []) then
  begin
    if mtblControlSets['KEYLANG'] = 'RUS' then
      SetRusKbd
    else
    if mtblControlSets['KEYLANG'] = 'ENG' then
      SetEngKbd;
    GetKeyboardState(Keys);
    if Keys[VK_CAPITAL] <> mtblControlSets['CAPS'] then
    begin
      Keys[VK_CAPITAL]:= mtblControlSets['CAPS'];
      SetKeyboardState(Keys);
    end
  end
  else
    RestoreSysKbd;
end;

function TdmOtto.Recode(aObjectSign, aAttrSign, aValue: String): String;
var
  NewValue: variant;
begin
  NewValue:= dbOtto.QueryValue(
    'select recoded_value from recodes '+
    'where object_sign=:object_sign and attr_sign=:attr_sign '+
    ' and original_value=:original_value', 0,
    [aObjectSign, aAttrSign, aValue]);
  if NewValue = null then
    Result:= aValue
  else
    Result:= NewValue;
end;

function TdmOtto.GetNextCounterValue(aObjectSign, aCounterSign: string;
  aObjectId: Integer): WideString;
begin
  Result:= dbOtto.QueryValue(
    'select o_nextval from counter_nextval(:object_sign, :counter_sign, :object_id)',
    0, [aObjectSign, aCounterSign, aObjectId]);
end;

function TdmOtto.CreateDeal(aTransaction: TpFIBTransaction): Integer;
begin
  Result:= dbOtto.QueryValue(
    'insert into deals(deal_date) values(current_timestamp) returning deal_id',
    0, aTransaction);
end;

function TdmOtto.GetArticleSign(aArticleCode: string;
  aMagazineId: Integer): string;
begin
  Result:= dbOtto.QueryValue(
    'select o_article_sign from articlesign_detect(:article_code, :magazine_id)',
    0, [aArticleCode, aMagazineId]);
end;

procedure TdmOtto.Notify(aMessageId: integer;
  aNotifyText: string; aNotifyClass: string = 'I'; aParams: string = '');
var
  vl: TVarList;
  i: Integer;
begin
  vl:= TVarList.Create;
  try
    vl.Text:= aParams;
    for i:= 0 to vl.Count-1 do
      aNotifyText:= ReplaceAll(aNotifyText, '['+vl.Names[i]+']', vl.ValueFromIndex[i]);
  finally
    vl.Free;
  end;
  dbOtto.QueryValue(
    'select o_notify_id from notify_create(:Message_id, :notify_text, :params, :notify_class)',
    0, [aMessageId, aNotifyText, aParams, aNotifyClass]);
end;

procedure TdmOtto.ClearNotify(aMessageId: integer);
begin
  dbOtto.QueryValue(
    'delete from notifies where message_id = :message_id',
    0, [aMessageId]);
end;

function TdmOtto.GetFlagListById(aStatusId: Integer): string;
var
  SignList: Variant;
begin
  try
    Result:= dbOtto.QueryValue(
      'select s.flag_sign_list from statuses s where s.status_id = :status_id',
      0, [aStatusId]);
  except
    ShowMessage(Format('Нет флагов для статусa %u ', [aStatusId]));
  end;
end;

procedure TdmOtto.GetInvoices(aInvoicesNode: TXmlNode; aOrderId: Integer;
  aTransaction: TpFIBTransaction);
var
  InvoiceId: variant;
  ndInvoice: TXmlNode;
begin
  with qryTempUpd do
  begin
    Transaction:= aTransaction;
    SQL.Text:= 'select * from Invoices where Order_Id = :OrderId order by invoice_id';
    ExecWP([aOrderId]);
    try
      while not Eof do
      begin
        InvoiceId:= FieldByName('INVOICE_ID').AsInteger;
        ndInvoice:= aInvoicesNode.NodeByAttributeValue('INVOICE', 'ID', InvoiceId);
        if ndInvoice = nil then
          ndInvoice:= aInvoicesNode.NodeNew('INVOICE');
        ObjectGet(ndInvoice, InvoiceId, aTransaction);
        Next;
      end;
    finally
      Close;
    end;
  end;
end;

procedure TdmOtto.BackupDatabase(aFileName: string);
var
  dbParams: TVarList;
begin
  with fibBackup do
  begin
    dbParams:= TVarList.Create;
    try
      dbParams.LoadSectionFromIniFile(ProjectIniFileName, 'DataBase');
      DatabaseName := Path['DataBase']+dbParams['FileName'];
      Params.Values['user_name']:= dbParams['Login'];
      Params.Values['password']:= dbParams['Password'];
    finally
      dbParams.Free;
    end;
    BackupFile.Clear;
    BackupFile.Add(aFileName);
    Attach;
    try
      ServiceStart;
      while not Eof do
        GetNextLine;
    finally
      Active:= false;
    end;
  end;
end;

procedure TdmOtto.RestoreDatabase(aFileName: string);
var
  dbParams: TVarList;
begin
  with fibRestore do
  begin
    dbParams:= TVarList.Create;
    try
      dbParams.LoadSectionFromIniFile(ProjectIniFileName, 'DataBase');
      DatabaseName.Text := Path['DataBase']+dbParams['FileName'];
      Params.Values['user_name']:= dbParams['Login'];
      Params.Values['password']:= dbParams['Password'];
    finally
      dbParams.Free;
    end;
    BackupFile.Clear;
    BackupFile.Add(aFileName);
    dbOtto.Close;
    Attach;
    try
      ServiceStart;
      while not Eof do
        GetNextLine;
    finally
      Active:= false;
    end;
    dbOtto.Open;
  end;
end;

procedure TdmOtto.dbOttoAfterConnect(Sender: TObject);
begin
  try
    Build:= dbOtto.QueryValue(
      'select max(build) from builds', 0);
  except
    Build:= 0;
  end;
end;

function TdmOtto.FlagExists(aNode: TXmlNode; aFlagSign: string): Boolean;
var
  FlagList: string;
begin
  FlagList:= GetFlagListById(GetXmlAttrValue(aNode, 'STATUS_ID'));
  Result:= Pos(','+aFlagSign+',', FlagList) > 0;
end;

procedure TdmOtto.CreateAlert(aHeaderText, aMessageText: string;
  DlgType: TMsgDlgType; Duration: Integer = 0);
var
  DesktopAlert: TJvDesktopAlert;
  i: Integer;
begin
  DesktopAlert := TJvDesktopAlert.Create(nil);
  with DesktopAlert do
  begin
    AutoFree := True;
    HeaderText := aHeaderText;
    if Length(aMessageText) < 100 then
      MessageText := aMessageText
    else
    begin
      MessageText := Copy(aMessageText, 1, 100) + '...';
      ShowHint := True;
      Hint := aMessageText;
    end;
    StyleOptions.DisplayDuration := Duration;
    Options := [daoCanClose];
    ParentFont := True;
    //    Image.Bitmap.Canvas.FillRect(Image.BitmapClientRect); //очищаем канву
//    if DlgType = mtError then
//      imgListAlerts.Draw(Image.Bitmap.Canvas, 0, 0, 1)
//    else
//      imgListAlerts.Draw(Image.Bitmap.Canvas, 0, 0, 0);
    with StyleOptions do
    begin
      StartInterval := 1;
      StartSteps := 0;
    end;
    Execute;
  end;
  Sleep(100);
  for i := 0 to 100 do
    Application.ProcessMessages;
end;

initialization
  Path:= TVarList.Create;
  Path.LoadSectionFromIniFile(ProjectIniFileName, 'PATH');
  Path.Text:= ReplaceAll(Path.Text, '=.\', '='+ExtractFilePath(ParamStr(0)));
finalization
  Path.Free;
end.
