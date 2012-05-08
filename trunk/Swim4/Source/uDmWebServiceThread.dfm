inherited dmSwimThread: TdmSwimThread
  OldCreateOrder = True
  inherited dbSwim: TpFIBDatabase
    Connected = True
  end
  object spRequestBusyNext: TpFIBStoredProc
    Transaction = trnWrite
    Database = dbSwim
    SQL.Strings = (
      'EXECUTE PROCEDURE REQUEST_BUSY (?I_THREAD_ID)')
    StoredProcName = 'REQUEST_BUSY'
    Left = 144
    Top = 96
    qoAutoCommit = True
    qoStartTransaction = True
    qoTrimCharFields = True
  end
  object spTemp: TpFIBStoredProc
    Transaction = trnWrite
    Database = dbSwim
    Left = 144
    Top = 168
    qoAutoCommit = True
    qoStartTransaction = True
    qoTrimCharFields = True
  end
  object qryTemp: TpFIBQuery
    Transaction = trnWrite
    Database = dbSwim
    Left = 232
    Top = 40
    qoAutoCommit = True
    qoStartTransaction = True
    qoTrimCharFields = True
  end
end
