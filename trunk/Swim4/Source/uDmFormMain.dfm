inherited dmFormMain: TdmFormMain
  OldCreateOrder = True
  inherited dbSwim: TpFIBDatabase
    Connected = True
  end
  object spTemp: TpFIBStoredProc [3]
    Transaction = trnWrite
    Database = dbSwim
    Left = 144
    Top = 104
    qoAutoCommit = True
    qoStartTransaction = True
    qoTrimCharFields = True
  end
end
