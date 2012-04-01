object dmSwim: TdmSwim
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 463
  Top = 239
  Height = 312
  Width = 590
  object Database: TpFIBDatabase
    DBName = '..\Data\SWIM.FDB'
    DBParams.Strings = (
      'sql_role_name=admin'
      'user_name=sysdba'
      'lc_ctype=CYRL'
      'password=masterkey')
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
end
