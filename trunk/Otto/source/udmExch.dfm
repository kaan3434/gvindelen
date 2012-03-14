object dmExch: TdmExch
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 609
  Top = 266
  Height = 290
  Width = 405
  object dbOtto: TpFIBDatabase
    DBName = 'localhost:D:\otto\Data\otto_ppz.fdb'
    DBParams.Strings = (
      'user_name=SYSDBA'
      'lc_ctype=CYRL'
      'password=masterkey'
      'sql_role_name=')
    DefaultTransaction = trnRead
    DefaultUpdateTransaction = trnWrite
    SQLDialect = 1
    Timeout = 0
    UseLoginPrompt = True
    LibraryName = 'fbclient.dll'
    GeneratorsCache.GeneratorList = <>
    AliasName = 'Otto'
    WaitForRestoreConnect = 0
    Left = 40
    Top = 32
  end
  object trnWrite: TpFIBTransaction
    DefaultDatabase = dbOtto
    TimeoutAction = TARollback
    TRParams.Strings = (
      'write'
      'nowait'
      'rec_version'
      'read_committed')
    MDTTransactionRole = mtrAutoDefine
    TPBMode = tpbDefault
    Left = 104
    Top = 32
  end
  object trnRead: TpFIBTransaction
    DefaultDatabase = dbOtto
    TimeoutAction = TARollback
    TRParams.Strings = (
      'read'
      'nowait'
      'rec_version'
      'read_committed')
    MDTTransactionRole = mtrAutoDefine
    TPBMode = tpbDefault
    Left = 160
    Top = 32
  end
  object qryWays: TpFIBDataSet
    SelectSQL.Strings = (
      'select *'
      'from ways w'
      'inner join ports p on (p.port_id = w.port_id)'
      'inner join statuses s on (s.status_id = w.status_id)'
      'order by w.port_id, w.port_path')
    Transaction = trnRead
    Database = dbOtto
    UpdateTransaction = trnWrite
    Left = 224
    Top = 32
  end
  object IdFtp: TIdFTP
    Intercept = logFile
    IPVersion = Id_IPv4
    Passive = True
    TransferType = ftBinary
    ProxySettings.ProxyType = fpcmNone
    ProxySettings.Port = 0
    Left = 40
    Top = 88
  end
  object logFile: TIdLogFile
    Active = True
    Filename = 'D:\Otto\Ftp.log'
    Left = 104
    Top = 88
  end
  object alertStockExcange: TJvDesktopAlertStack
    Left = 160
    Top = 88
  end
end
