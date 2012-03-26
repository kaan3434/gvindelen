object dmSwim: TdmSwim
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 463
  Top = 239
  Height = 312
  Width = 590
  object DataSet: TpFIBDataSet
    Transaction = trnWrite
    Database = Database
    Left = 88
    Top = 64
  end
  object StoredProc: TpFIBStoredProc
    Transaction = trnWrite
    Database = Database
    Left = 88
    Top = 16
    qoAutoCommit = True
    qoStartTransaction = True
  end
  object trnWrite: TpFIBTransaction
    DefaultDatabase = Database
    TimeoutAction = TARollback
    TRParams.Strings = (
      'write'
      'nowait'
      'rec_version'
      'read_committed')
    MDTTransactionRole = mtrNone
    TPBMode = tpbDefault
    Left = 32
    Top = 64
  end
  object Database: TpFIBDatabase
    DBName = '..\Data\SWIM.FDB'
    DBParams.Strings = (
      'sql_role_name=admin'
      'user_name=sysdba'
      'lc_ctype=CYRL'
      'password=masterkey')
    DefaultTransaction = trnRead
    DefaultUpdateTransaction = trnWrite
    SQLDialect = 3
    Timeout = 0
    DesignDBOptions = []
    LibraryName = 'fbclient.dll'
    GeneratorsCache.GeneratorList = <>
    AliasName = 'swim'
    WaitForRestoreConnect = 0
    Left = 32
    Top = 16
  end
  object trnRead: TpFIBTransaction
    DefaultDatabase = Database
    TimeoutAction = TARollback
    TRParams.Strings = (
      'read'
      'isc_tpb_nowait'
      'read_committed'
      'rec_version')
    MDTTransactionRole = mtrNone
    TPBMode = tpbDefault
    Left = 32
    Top = 112
  end
  object spPutEvent: TpFIBStoredProc
    Transaction = trnWrite
    Database = Database
    SQL.Strings = (
      
        'EXECUTE PROCEDURE PUT_EVENTBETS (?I_BTOURNIR_ID, ?I_EVENT_DTM, ?' +
        'I_BGAMER1_NM, ?I_BGAMER2_NM, ?I_S_0, ?I_V_0, ?I_K_0, ?I_S_1, ?I_' +
        'V_1, ?I_K_1, ?I_S_2, ?I_V_2, ?I_K_2, ?I_S_3, ?I_V_3, ?I_K_3, ?I_' +
        'S_4, ?I_V_4, ?I_K_4, ?I_S_5, ?I_V_5, ?I_K_5, ?I_S_6, ?I_V_6, ?I_' +
        'K_6, ?I_S_7, ?I_V_7, ?I_K_7, ?I_S_8, ?I_V_8, ?I_K_8, ?I_S_9, ?I_' +
        'V_9, ?I_K_9)')
    StoredProcName = 'PUT_EVENTBETS'
    Left = 88
    Top = 112
    qoAutoCommit = True
    qoStartTransaction = True
  end
end
