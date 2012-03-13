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
      'user_name=sysdba'
      'lc_ctype=CYRL'
      'password=masterkey')
    DefaultTransaction = trnRead
    DefaultUpdateTransaction = trnWrite
    SQLDialect = 3
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
    Left = 152
    Top = 32
  end
  object tmrScan: TJvTimer
    Enabled = False
    Interval = 600000
    OnTimer = tmrScanTimer
    Left = 216
    Top = 32
  end
  object qryPorts: TpFIBDataSet
    SelectSQL.Strings = (
      'select *'
      'from Ports p'
      'inner join port2template p2t on (p2t.port_id = p.port_id)'
      'inner join templates t on (t.template_id = p2t.template_id)'
      'order by p.port_id')
    Database = dbOtto
    UpdateTransaction = trnWrite
    Left = 264
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
    Left = 152
    Top = 88
  end
end
