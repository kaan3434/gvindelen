inherited dmFormMain: TdmFormMain
  OldCreateOrder = True
  inherited dbSwim: TpFIBDatabase
    Connected = True
  end
  inherited trnRead: TpFIBTransaction
    Active = True
    AfterStart = trnReadAfterStart
  end
  object qrySwim: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      #9's.SWIM_ID,'
      #9's.AEVENT_ID,'
      #9's.BOOKER1_ID,'
      #9'b1.BOOKER_NAME BOOKER1_NAME,'
      #9'b1.VALUTE_SIGN VALUTE1_SIGN,'
      #9'b1.SHOW_FLG,'
      #9's.BETKIND1_SIGN,'
      #9'SWIMS.BET1_ID,'
      #9'SWIMS.S1,'
      #9'SWIMS.SV1,'
      #9'SWIMS.SP1,'
      #9'SWIMS.BOOKER2_ID,'
      #9'SWIMS.BETKIND2_SIGN,'
      #9'SWIMS.BET2_ID,'
      #9'SWIMS.S2,'
      #9'SWIMS.SV2,'
      #9'SWIMS.SP2,'
      #9'SWIMS.PROFICIT,'
      #9'SWIMS.IGNORE_FLG,'
      #9'BOOKERS.BOOKER_ID,'
      #9'BOOKERS.BOOKER_SIGN,'
      #9'BOOKERS.BOOKER_NAME,'
      #9'BOOKERS.VALUTE_SIGN,'
      #9'BOOKERS.HOURS_OFS,'
      #9'BOOKERS.MINBET_MONEY,'
      #9'BOOKERS.MAXBET_MONEY,'
      #9'BOOKERS.TEACH_ORDER,'
      #9'BOOKERS.SCAN_FLG,'
      #9'BOOKERS.SHOW_FLG,'
      #9'BOOKERS.SMALL_ICON,'
      #9'AEVENTS.AEVENT_ID,'
      #9'AEVENTS.ATOURNIR_ID,'
      #9'AEVENTS.EVENT_DTM,'
      #9'AEVENTS.AGAMER1_ID,'
      #9'AEVENTS.AGAMER2_ID'
      'FROM SWIMS S'
      
        '  inner join bookers b1 on (b1.booker_id = s.booker1_id and b1.s' +
        'how_flg = 1)'
      
        '  inner join bookers b2 on (b2.booker_id = s.booker2_id and b2.s' +
        'how_flg = 1)'
      '  inner join aevents e on (e.aevent_id = s.aevent_id)'
      'ORDER BY PROFICIT, EVENT_DTM')
    Transaction = trnRead
    Database = dbSwim
    UpdateTransaction = trnWrite
    Left = 128
    Top = 168
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
end
