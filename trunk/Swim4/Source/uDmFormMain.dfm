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
      '    s.swim_id,'
      '    s.aevent_id,'
      '    e.event_dtm,'
      '    e.agamer1_id,'
      '    e.agamer2_id,'
      '    s.booker1_id,'
      '    b1.booker_name booker1_name,'
      '    b1.valute_sign valute1_sign,'
      '    b1.show_flg,'
      '    s.betkind1_sign,'
      '    bk1.betkind_name betkind1_name,'
      '    s.bet1_id,'
      '    bt1.koef koef1,'
      '    s.s1,'
      '    s.sv1,'
      '    s.sp1,'
      '    s.booker2_id,'
      '    b2.booker_name booker2_name,'
      '    b2.valute_sign valute2_sign,'
      '    s.betkind2_sign,'
      '    bk2.betkind_name betkind2_name,'
      '    s.bet2_id,'
      '    bt2.koef koef2,'
      '    s.s2,'
      '    s.sv2,'
      '    s.sp2,'
      '    s.proficit,'
      '    s.ignore_flg'
      'FROM swims s'
      
        '  inner join bookers b1 on (b1.booker_id = s.booker1_id and b1.s' +
        'how_flg = 1)'
      
        '  inner join bookers b2 on (b2.booker_id = s.booker2_id and b2.s' +
        'how_flg = 1)'
      '  inner join aevents e on (e.aevent_id = s.aevent_id)'
      '  inner join bets bt1 on (bt1.bet_id = s.bet1_id)'
      
        '  inner join betkinds bk1 on (bk1.betkind_sign = s.betkind1_sign' +
        ')'
      '  inner join bets bt2 on (bt2.bet_id = s.bet2_id)'
      
        '  inner join betkinds bk2 on (bk2.betkind_sign = s.betkind2_sign' +
        ')'
      'ORDER BY proficit desc, event_dtm'
      '')
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
