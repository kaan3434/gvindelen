object dmOtto: TdmOtto
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 581
  Top = 155
  Height = 312
  Width = 555
  object dbOtto: TpFIBDatabase
    DBName = 'D:\otto\Data\otto_ppz.fdb'
    DBParams.Strings = (
      'lc_ctype=CYRL'
      'password=masterkey'
      'user_name=sysdba')
    DefaultTransaction = trnAutonomouse
    DefaultUpdateTransaction = trnAutonomouse
    SQLDialect = 3
    Timeout = 0
    DesignDBOptions = [ddoIsDefaultDatabase, ddoStoreConnected]
    UseRepositories = []
    LibraryName = 'fbclient.dll'
    AliasName = 'Otto'
    WaitForRestoreConnect = 0
    AfterConnect = dbOttoAfterConnect
    Left = 24
    Top = 16
  end
  object spTemp: TpFIBStoredProc
    Database = dbOtto
    Left = 88
    Top = 64
  end
  object qryParams: TpFIBQuery
    Database = dbOtto
    SQL.Strings = (
      'SELECT'
      '    PARAM_NAME,'
      '    PARAM_VALUE'
      'FROM'
      '    PARAMS '
      'WHERE PARAM_ID = :PARAM_ID')
    Left = 152
    Top = 64
  end
  object qryTempRead: TpFIBQuery
    Database = dbOtto
    Left = 24
    Top = 112
  end
  object qryReadObject: TpFIBQuery
    Database = dbOtto
    SQL.Strings = (
      'SELECT'
      '    O_PARAM_NAME,'
      '    O_PARAM_VALUE'
      'FROM'
      '    OBJECT_READ(:OBJECT_SIGN, :OBJECT_ID) ')
    Left = 168
    Top = 112
  end
  object qryObjectList: TpFIBQuery
    Database = dbOtto
    Left = 104
    Top = 112
  end
  object tblTemp: TpFIBDataSet
    Database = dbOtto
    Left = 24
    Top = 160
  end
  object spObjectSearch: TpFIBStoredProc
    Database = dbOtto
    SQL.Strings = (
      
        'EXECUTE PROCEDURE SEARCH (?I_VALUE, ?I_FROM_CLAUSE, ?I_FIELDNAME' +
        '_ID, ?I_FIELDNAME_NAME, ?I_WHERE_CLAUSE, ?I_THRESHOLD)')
    StoredProcName = 'SEARCH'
    Left = 152
    Top = 168
    qoTrimCharFields = True
  end
  object spTaxRateCalc: TpFIBStoredProc
    Database = dbOtto
    SQL.Strings = (
      'EXECUTE PROCEDURE TAXRATE_CALC (?I_PARAM_ID)')
    StoredProcName = 'TAXRATE_CALC'
    Left = 208
    Top = 64
    qoAutoCommit = True
    qoStartTransaction = True
  end
  object spParamUnparse: TpFIBStoredProc
    Database = dbOtto
    SQL.Strings = (
      'EXECUTE PROCEDURE PARAM_UNPARSE (?I_PARAM_ID, ?I_PARAMS)')
    StoredProcName = 'PARAM_UNPARSE'
    Left = 240
    Top = 112
  end
  object spParamsCreate: TpFIBStoredProc
    Database = dbOtto
    SQL.Strings = (
      
        'EXECUTE PROCEDURE PARAM_CREATE (?I_OBJECT_SIGN, ?I_OBJECT_ID, ?I' +
        '_ACTION_ID)')
    StoredProcName = 'PARAM_CREATE'
    Left = 240
    Top = 176
  end
  object trnAutonomouse: TpFIBTransaction
    DefaultDatabase = dbOtto
    TimeoutAction = TARollback
    TRParams.Strings = (
      'write'
      'nowait'
      'concurrency')
    TPBMode = tpbDefault
    Left = 232
    Top = 16
  end
  object qryTempUpd: TpFIBQuery
    Database = dbOtto
    Left = 336
    Top = 96
  end
  object spActionExecute: TpFIBStoredProc
    Database = dbOtto
    SQL.Strings = (
      
        'EXECUTE PROCEDURE ACTION_EXECUTE (?I_OBJECT_SIGN, ?I_PARAMS, ?I_' +
        'ACTION_SIGN, ?I_DEAL_ID, ?I_OBJECT_ID)')
    StoredProcName = 'ACTION_EXECUTE'
    Left = 360
    Top = 176
  end
  object spMessage: TpFIBStoredProc
    Transaction = trnAutonomouse
    Database = dbOtto
    Left = 408
    Top = 96
    qoAutoCommit = True
    qoStartTransaction = True
  end
  object mtblControlSets: TMemTableEh
    Active = True
    FieldDefs = <
      item
        Name = 'TAG'
        DataType = ftInteger
      end
      item
        Name = 'KEYLANG'
        DataType = ftString
        Size = 3
      end
      item
        Name = 'CAPS'
        DataType = ftBoolean
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 288
    Top = 64
    object fldControlSets_TAG: TIntegerField
      DisplayWidth = 10
      FieldName = 'TAG'
    end
    object fldControlSets_KEYLANG: TStringField
      DisplayWidth = 3
      FieldName = 'KEYLANG'
      Size = 3
    end
    object fldControlSets_CAPS: TBooleanField
      DisplayWidth = 5
      FieldName = 'CAPS'
    end
    object MemTableData: TMemTableDataEh
      object DataStruct: TMTDataStructEh
        object TAG: TMTNumericDataFieldEh
          FieldName = 'TAG'
          NumericDataType = fdtIntegerEh
          Alignment = taLeftJustify
          DisplayWidth = 0
          Required = False
          Visible = False
          currency = False
          Precision = 0
        end
        object KEYLANG: TMTStringDataFieldEh
          FieldName = 'KEYLANG'
          StringDataType = fdtStringEh
          Alignment = taLeftJustify
          DisplayWidth = 0
          Required = False
          Visible = False
          Size = 3
          Transliterate = False
        end
        object CAPS: TMTBooleanDataFieldEh
          FieldName = 'CAPS'
          Alignment = taLeftJustify
          DisplayWidth = 0
          Required = False
          Visible = False
        end
      end
      object RecordsList: TRecordsListEh
        Data = (
          (
            1
            'ENG'
            True)
          (
            2
            'ENG'
            False)
          (
            3
            'RUS'
            True)
          (
            4
            'RUS'
            False))
      end
    end
  end
  object spArticleGoC: TpFIBStoredProc
    Database = dbOtto
    SQL.Strings = (
      
        'EXECUTE PROCEDURE ARTICLE_GOC (?I_MAGAZINE_ID, ?I_ARTICLE_CODE, ' +
        '?I_COLOR, ?I_DIMENSION, ?I_PRICE_EUR, ?I_WEIGHT, ?I_DESCRIPTION,' +
        ' ?I_IMAGE_URL)')
    StoredProcName = 'ARTICLE_GOC'
    Left = 352
    Top = 16
  end
  object fibBackup: TpFIBBackupService
    ServerName = 'localhost'
    LibraryName = 'fbclient.dll'
    Protocol = TCP
    Params.Strings = (
      'user_name=SYSDBA'
      'password=masterkey'
      'sql_role_name=')
    LoginPrompt = False
    BlockingFactor = 0
    DatabaseName = 'D:\otto\Data\otto-ppz.fdb'
    Options = [ConvertExtTables]
    Left = 456
    Top = 128
  end
  object fibRestore: TpFIBRestoreService
    ServerName = 'localhost'
    LibraryName = 'fbclient.dll'
    Protocol = TCP
    LoginPrompt = False
    PageBuffers = 0
    Options = [Replace, CreateNewDB]
    Left = 456
    Top = 176
  end
  object AlertStock: TJvDesktopAlertStack
    Left = 24
    Top = 216
  end
end
