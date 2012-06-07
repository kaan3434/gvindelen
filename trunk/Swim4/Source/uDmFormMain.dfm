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
      'FROM'
      '    V_SWIMS '
      'ORDER BY PROFICIT, EVENT_DTM')
    Active = True
    Transaction = trnRead
    Database = dbSwim
    UpdateTransaction = trnWrite
    Left = 128
    Top = 160
  end
end
