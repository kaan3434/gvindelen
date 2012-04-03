object dmMain: TdmMain
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 192
  Top = 107
  Height = 300
  Width = 539
  object trReadDLL: TpFIBTransaction
    DefaultDatabase = dbDemoDLL
    TimeoutAction = TACommit
    TRParams.Strings = (
      'read'
      'nowait'
      'rec_version'
      'read_committed')
    TPBMode = tpbDefault
    Left = 95
    Top = 4
  end
  object trWriteDLL: TpFIBTransaction
    DefaultDatabase = dbDemoDLL
    TimeoutAction = TACommit
    TRParams.Strings = (
      'write'
      'nowait'
      'rec_version'
      'read_committed')
    TPBMode = tpbDefault
    Left = 151
    Top = 4
  end
  object dtCountry: TpFIBDataSet
    Database = dbDemoDLL
    Transaction = trReadDLL
    Options = [poStartTransaction]
    UpdateTransaction = trWriteDLL
    AutoCommit = True
    BufferChunks = 32
    CachedUpdates = False
    UniDirectional = False
    UpdateRecordTypes = [cusUnmodified, cusModified, cusInserted]
    UpdateSQL.Strings = (
      'UPDATE COUNTRY SET '
      '    NAME = :NAME,'
      '    CAPITAL = :CAPITAL,'
      '    CONTINENT = :CONTINENT,'
      '    AREA = :AREA,'
      '    POPULATION = :POPULATION'
      ' WHERE     '
      '            ID = :OLD_ID'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM COUNTRY'
      'WHERE     '
      '            ID = :OLD_ID'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO COUNTRY('
      '    ID,'
      '    NAME,'
      '    CAPITAL,'
      '    CONTINENT,'
      '    AREA,'
      '    POPULATION'
      ')'
      'VALUES('
      '    :ID,'
      '    :NAME,'
      '    :CAPITAL,'
      '    :CONTINENT,'
      '    :AREA,'
      '    :POPULATION'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    C.ID,'
      '    C.NAME,'
      '    C.CAPITAL,'
      '    C.CONTINENT,'
      '    C.AREA,'
      '    C.POPULATION'
      'FROM'
      '    COUNTRY C'
      ' WHERE '
      '            C.ID = :OLD_ID')
    SelectSQL.Strings = (
      'SELECT'
      '    C.ID,'
      '    C.NAME,'
      '    C.CAPITAL,'
      '    C.CONTINENT,'
      '    C.AREA,'
      '    C.POPULATION'
      'FROM'
      '    COUNTRY C'
      'ORDER BY C.NAME')
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    AutoUpdateOptions.UpdateTableName = 'COUNTRY'
    AutoUpdateOptions.KeyFields = 'ID'
    AutoUpdateOptions.GeneratorName = 'GEN_COUNTRY_ID'
    AutoUpdateOptions.WhenGetGenID = wgBeforePost
    Left = 23
    Top = 56
    poImportDefaultValues = False
    poGetOrderInfo = False
    object dtCountryID: TFIBIntegerField
      FieldName = 'ID'
    end
    object dtCountryNAME: TFIBStringField
      FieldName = 'NAME'
      Size = 30
    end
    object dtCountryCAPITAL: TFIBStringField
      FieldName = 'CAPITAL'
      Size = 30
    end
    object dtCountryCONTINENT: TFIBStringField
      FieldName = 'CONTINENT'
      Size = 30
    end
    object dtCountryAREA: TFIBFloatField
      FieldName = 'AREA'
      DisplayFormat = '###,###,###,##0.00'
      EditFormat = '0.##'
    end
    object dtCountryPOPULATION: TFIBFloatField
      FieldName = 'POPULATION'
      DisplayFormat = '###,###,###,##0.00'
      EditFormat = '0.##'
    end
  end
  object dsCountry: TDataSource
    DataSet = dtCountry
    Left = 23
    Top = 100
  end
  object dbDemoDLL: TpFIBDatabase
    DBName = 'DMITRIY:C:\FIBPlusDemoPack\GDB\DEMOPACK.GDB'
    DBParams.Strings = (
      'lc_ctype=WIN1251'
      'user_name=SYSDBA'
      'password=masterkey')
    DefaultTransaction = trReadDLL
    SQLDialect = 3
    Timeout = 0
    UpperOldNames = True
    DesignDBOptions = []
    Left = 23
    Top = 4
  end
end
