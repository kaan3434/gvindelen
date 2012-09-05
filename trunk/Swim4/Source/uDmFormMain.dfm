inherited dmFormMain: TdmFormMain
  OldCreateOrder = True
  inherited dbSwim: TpFIBDatabase
    Connected = True
  end
  inherited trnRead: TpFIBTransaction
    Active = True
    AfterStart = trnReadAfterStart
  end
  object qrySwimEvents: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    AEVENT_ID,'
      '    ATOURNIR_ID,'
      '    ATOURNIR_NAME,'
      '    ASPORT_ID,'
      '    ASPORT_NAME,'
      '    EVENT_DTM,'
      '    AGAMER1_ID,'
      '    AGAMER1_NAME,'
      '    AGAMER2_ID,'
      '    AGAMER2_NAME,'
      '    PROFICIT,'
      '    SWIM_CNT'
      'FROM'
      '    V_SWIMEVENTS '
      'ORDER BY PROFICIT desc')
    Active = True
    Transaction = trnRead
    Database = dbSwim
    UpdateTransaction = trnWrite
    Left = 152
    Top = 224
  end
  object qryTemp: TpFIBDataSet
    Transaction = trnRead
    Database = dbSwim
    UpdateTransaction = trnWrite
    Left = 208
    Top = 40
  end
  object qryBookers: TpFIBDataSet
    SelectSQL.Strings = (
      'select * '
      'from bookers'
      'order by teach_order')
    Transaction = trnRead
    Database = dbSwim
    UpdateTransaction = trnWrite
    Left = 208
    Top = 104
  end
  object qrySwimItems: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    SWIM_ID,'
      '    AEVENT_ID,'
      '    BOOKER1_ID,'
      '    BOOKER1_NAME,'
      '    VALUTE1_SIGN,'
      '    BETKIND1_SIGN,'
      '    BETKIND1_NAME,'
      '    BET1_ID,'
      '    KOEF1,'
      '    S1,'
      '    SP1,'
      '    SV1,'
      '    SVP1,'
      '    BOOKER2_ID,'
      '    BOOKER2_NAME,'
      '    VALUTE2_SIGN,'
      '    BETKIND2_SIGN,'
      '    BETKIND2_NAME,'
      '    BET2_ID,'
      '    KOEF2,'
      '    S2,'
      '    SP2,'
      '    SV2,'
      '    SVP2,'
      '    PROFICIT'
      'FROM'
      '    V_SWIMITEMS '
      'WHERE'
      '  AEVENT_ID = :AEVENT_ID'
      'ORDER BY PROFICIT desc')
    Active = True
    Transaction = trnRead
    Database = dbSwim
    UpdateTransaction = trnWrite
    DataSource = dsSwimEvents
    Left = 152
    Top = 280
  end
  object dsSwimItems: TDataSource
    AutoEdit = False
    DataSet = qrySwimItems
    Left = 232
    Top = 280
  end
  object dsSwimEvents: TDataSource
    AutoEdit = False
    DataSet = qrySwimEvents
    Left = 232
    Top = 224
  end
end
