object dmSwim: TdmSwim
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 494
  Width = 765
  object dbSwim: TpFIBDatabase
    Connected = True
    DBName = 'D:\Swim4\Data\SWIM.FDB'
    DBParams.Strings = (
      'user_name=SYSDBA'
      'lc_ctype=UTF8'
      'sql_role_name=ADMIN'
      'password=masterkey')
    SQLDialect = 3
    Timeout = 0
    LibraryName = 'fbclient.dll'
    AliasName = 'Swim4'
    WaitForRestoreConnect = 0
    Left = 48
    Top = 40
  end
  object trnRead: TpFIBTransaction
    Active = True
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
  object qrySwims: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    SWIM_ID,'
      '    EVENT_ID,'
      '    EVENT_DTM,'
      '    ASPORT_ID,'
      '    ASPORT_NAME,'
      '    ATOURNIR_ID,'
      '    ATOURNIR_NAME,'
      '    COUNTRY_SIGN,'
      '    AGAMER1_ID,'
      '    AGAMER1_NAME,'
      '    AGAMER2_ID,'
      '    AGAMER2_NAME,'
      '    BET1_ID,'
      '    BETTYPE1_ID,'
      '    BETTYPE1_SIGN,'
      '    BET1_VALUE,'
      '    BET1_KOEF,'
      '    BOOKER1_ID,'
      '    BOOKER1_NAME,'
      '    VALUTE1_SIGN,'
      '    BET2_ID,'
      '    BETTYPE2_ID,'
      '    BETTYPE2_SIGN,'
      '    BET2_VALUE,'
      '    BET2_KOEF,'
      '    BOOKER2_ID,'
      '    BOOKER2_NAME,'
      '    VALUTE2_SIGN'
      'FROM'
      '    V_SWIMS ')
    Active = True
    Transaction = trnRead
    Database = dbSwim
    UpdateTransaction = trnWrite
    Left = 176
    Top = 48
  end
end
