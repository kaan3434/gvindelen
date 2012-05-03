inherited dmSwimThread: TdmSwimThread
  object spRequestBusyNext: TpFIBStoredProc
    Transaction = trnWrite
    Database = dbSwim
    SQL.Strings = (
      'EXECUTE PROCEDURE REQUEST_BUSYNEXT ')
    StoredProcName = 'REQUEST_BUSYNEXT'
    Left = 152
    Top = 40
    qoAutoCommit = True
    qoStartTransaction = True
    qoTrimCharFields = True
  end
  object spRequestAdd: TpFIBStoredProc
    Transaction = trnWrite
    Database = dbSwim
    Left = 152
    Top = 104
    qoAutoCommit = True
    qoStartTransaction = True
    qoTrimCharFields = True
  end
  object spRequestCommit: TpFIBStoredProc
    Left = 152
    Top = 160
    qoAutoCommit = True
    qoStartTransaction = True
    qoTrimCharFields = True
  end
end
