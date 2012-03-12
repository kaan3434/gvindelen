object dmExch: TdmExch
  OldCreateOrder = False
  Left = 609
  Top = 266
  Height = 290
  Width = 405
  object dbOtto: TpFIBDatabase
    DBName = 'localhost:D:\otto\Data\otto_ppz.fdb'
    DBParams.Strings = (
      'user_name=SYSDBA'
      'lc_ctype=CYRL'
      'password=masterkey')
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
end
