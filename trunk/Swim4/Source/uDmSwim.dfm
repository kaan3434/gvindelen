object dmSwim: TdmSwim
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 494
  Width = 765
  object dbSwim: TpFIBDatabase
    DBName = 'D:\Swim4\Data\SWIM.FDB'
    DBParams.Strings = (
      'user_name=SYSDBA'
      'lc_ctype=UNICODE_FSS'
      'sql_role_name=ADMIN'
      'password=masterkey')
    DefaultTransaction = trnRead
    DefaultUpdateTransaction = trnWrite
    SQLDialect = 3
    Timeout = 0
    LibraryName = 'fbclient.dll'
    AliasName = 'Swim4'
    WaitForRestoreConnect = 0
    Left = 48
    Top = 40
  end
  object trnRead: TpFIBTransaction
    DefaultDatabase = dbSwim
    TimeoutAction = TARollback
    TRParams.Strings = (
      'read'
      'nowait'
      'rec_version'
      'read_committed')
    TPBMode = tpbDefault
    Left = 48
    Top = 104
  end
  object trnWrite: TpFIBTransaction
    DefaultDatabase = dbSwim
    TimeoutAction = TARollback
    TRParams.Strings = (
      'write'
      'nowait'
      'rec_version'
      'read_committed')
    TPBMode = tpbDefault
    Left = 48
    Top = 168
  end
  object spRequestAdd: TpFIBStoredProc
    Transaction = trnWrite
    Database = dbSwim
    SQL.Strings = (
      
        'EXECUTE PROCEDURE REQUEST_ADD (?I_ACTION_SIGN, ?I_PARTS, ?I_SCAN' +
        '_ID)')
    StoredProcName = 'REQUEST_ADD'
    Left = 128
    Top = 40
  end
  object spTemp: TpFIBStoredProc
    Transaction = trnWrite
    Database = dbSwim
    Left = 128
    Top = 96
  end
end
