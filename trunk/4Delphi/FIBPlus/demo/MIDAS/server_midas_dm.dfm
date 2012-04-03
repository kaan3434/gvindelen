object FIBPlusDemoServer: TFIBPlusDemoServer
  OldCreateOrder = False
  Left = 163
  Top = 119
  Height = 375
  Width = 544
  object dbMidas: TpFIBDatabase
    Connected = True
    DBName = 'C:\FIBPlusDemoPack\GDB\DEMOPACK.GDB'
    DBParams.Strings = (
      'lc_ctype=WIN1251'
      'user_name=SYSDBA'
      'password=masterkey')
    DefaultTransaction = trRead
    SQLDialect = 3
    Timeout = 0
    UpperOldNames = True
    Left = 36
    Top = 12
  end
  object dspMidas: TDataSetProvider
    DataSet = dtMidas
    Constraints = True
    ResolveToDataSet = True
    Left = 96
    Top = 64
  end
  object trRead: TpFIBTransaction
    DefaultDatabase = dbMidas
    TimeoutAction = TACommit
    TRParams.Strings = (
      'read'
      'nowait'
      'rec_version'
      'read_committed')
    TPBMode = tpbDefault
    Left = 88
    Top = 12
  end
  object trWrite: TpFIBTransaction
    DefaultDatabase = dbMidas
    TimeoutAction = TACommit
    TRParams.Strings = (
      'write'
      'nowait'
      'rec_version'
      'read_committed')
    TPBMode = tpbDefault
    Left = 132
    Top = 12
  end
  object dtMidas: TpFIBDataSet
    Database = dbMidas
    Transaction = trRead
    AfterFetchRecord = dtMidasAfterFetchRecord
    Options = [poStartTransaction]
    UpdateTransaction = trWrite
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
    AfterClose = dtMidasAfterClose
    AfterOpen = dtMidasAfterOpen
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    AutoUpdateOptions.UpdateTableName = 'COUNTRY'
    AutoUpdateOptions.KeyFields = 'ID'
    AutoUpdateOptions.GeneratorName = 'GEN_COUNTRY_ID'
    AutoUpdateOptions.WhenGetGenID = wgBeforePost
    Left = 40
    Top = 64
    poImportDefaultValues = False
    poGetOrderInfo = False
    object dtMidasID: TFIBIntegerField
      FieldName = 'ID'
    end
    object dtMidasNAME: TFIBStringField
      FieldName = 'NAME'
      Size = 30
      EmptyStrToNull = True
    end
    object dtMidasCAPITAL: TFIBStringField
      FieldName = 'CAPITAL'
      Size = 30
      EmptyStrToNull = True
    end
    object dtMidasCONTINENT: TFIBStringField
      FieldName = 'CONTINENT'
      Size = 30
      EmptyStrToNull = True
    end
    object dtMidasAREA: TFIBFloatField
      FieldName = 'AREA'
      DisplayFormat = '###,###,###,##0.00'
      EditFormat = '0.##'
    end
    object dtMidasPOPULATION: TFIBFloatField
      FieldName = 'POPULATION'
      DisplayFormat = '###,###,###,##0.00'
      EditFormat = '0.##'
    end
  end
end
