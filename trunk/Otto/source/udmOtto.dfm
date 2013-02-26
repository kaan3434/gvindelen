object dmOtto: TdmOtto
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 419
  Top = 137
  Height = 444
  Width = 589
  object dbOtto: TpFIBDatabase
    Connected = True
    DBName = 'localhost:D:\otto\Data\otto_ppz.fdb'
    DBParams.Strings = (
      'lc_ctype=CYRL'
      'user_name=sysdba'
      'password=masterkey'
      'sql_role_name=rdb$admin')
    DefaultTransaction = trnAutonomouse
    DefaultUpdateTransaction = trnAutonomouse
    SQLDialect = 3
    Timeout = 0
    UseLoginPrompt = True
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
    Transaction = trnAutonomouse
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
    Active = True
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
        'ACTION_SIGN, ?I_OBJECT_ID)')
    StoredProcName = 'ACTION_EXECUTE'
    Left = 360
    Top = 176
  end
  object spMessage: TpFIBStoredProc
    Transaction = trnAutonomouse
    Database = dbOtto
    Left = 408
    Top = 96
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
    LibraryName = 'fbclient.dll'
    Protocol = TCP
    Params.Strings = (
      'user_name=sysdba'
      'password=masterkey')
    LoginPrompt = False
    BlockingFactor = 0
    Options = [ConvertExtTables]
    Left = 456
    Top = 128
  end
  object fibRestore: TpFIBRestoreService
    LibraryName = 'fbclient.dll'
    Protocol = TCP
    Params.Strings = (
      'user_name=sysdba'
      'password=masterkey')
    LoginPrompt = False
    PageBuffers = 0
    Options = [Replace, CreateNewDB, ValidationCheck, FixFssMetadata, FixFssData]
    Left = 456
    Top = 176
  end
  object AlertStock: TJvDesktopAlertStack
    Left = 24
    Top = 216
  end
  object dbfCons: TDbf
    IndexDefs = <>
    TableLevel = 4
    Left = 144
    Top = 224
  end
  object errHandler: TpFibErrorHandler
    OnFIBErrorEvent = errHandlerFIBErrorEvent
    Options = [oeException, oeForeignKey, oeLostConnect, oeCheck, oeUniqueViolation]
    Left = 240
    Top = 224
  end
  object frxProtocol: TfrxReport
    Version = '4.9.64'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.AllowEdit = False
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.MDIChild = True
    PreviewOptions.Modal = False
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 40998.100363171300000000
    ReportOptions.LastChange = 40998.137294224540000000
    ScriptLanguage = 'PascalScript'
    ShowProgress = False
    StoreInDFM = False
    Left = 344
    Top = 248
  end
  object frxFIBComponents1: TfrxFIBComponents
    DefaultDatabase = dbOtto
    Left = 432
    Top = 248
  end
  object frxPDFExport: TfrxPDFExport
    ShowDialog = False
    UseFileCache = True
    ShowProgress = False
    OverwritePrompt = False
    OpenAfterExport = True
    PrintOptimized = False
    Outline = False
    Background = False
    HTMLTags = True
    Author = 'FastReport'
    Subject = 'FastReport PDF export'
    ProtectionFlags = [ePrint, eModify, eCopy, eAnnot]
    HideToolbar = False
    HideMenubar = False
    HideWindowUI = False
    FitWindow = False
    CenterWindow = False
    PrintScaling = False
    Left = 352
    Top = 312
  end
  object smtpMain: TIdSMTP
    SASLMechanisms = <>
    Left = 24
    Top = 304
  end
  object frxReport: TfrxReport
    Version = '4.9.64'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.AllowEdit = False
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.ShowCaptions = True
    PreviewOptions.Zoom = 1.000000000000000000
    PreviewOptions.ZoomMode = zmManyPages
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 40773.818275636600000000
    ReportOptions.LastChange = 41052.624095972200000000
    ScriptLanguage = 'PascalScript'
    StoreInDFM = False
    Left = 280
    Top = 312
  end
  object frxExportXLS: TfrxXMLExport
    ShowDialog = False
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    Background = True
    Creator = 'FastReport'
    EmptyLines = True
    SuppressPageHeadersFooters = False
    RowsCount = 0
    Split = ssRPages
    Left = 440
    Top = 312
  end
  object svnZipBackup: TSevenZip
    SFXCreate = False
    SFXModule = '7z.sfx'
    AddOptions = [AddStoreOnlyFilename]
    ExtractOptions = []
    LZMACompressType = LZMA
    LZMACompressStrength = NORMAL
    LZMAStrength = 0
    LPPMDmem = 30
    LPPMDsize = 10
    NumberOfFiles = -1
    VolumeSize = 0
    Left = 168
    Top = 320
  end
  object frxdlgcntrls1: TfrxDialogControls
    Left = 272
    Top = 264
  end
end
