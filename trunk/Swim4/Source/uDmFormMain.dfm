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
      'SELECT *'
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
    Top = 160
  end
end
