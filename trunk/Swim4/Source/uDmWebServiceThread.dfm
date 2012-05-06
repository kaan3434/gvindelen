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
    Left = 152
    Top = 40
    qoAutoCommit = True
    qoStartTransaction = True
    qoTrimCharFields = True
  end
  object spRequestAdd: TpFIBStoredProc
    Transaction = trnWrite
    Database = dbSwim
    SQL.Strings = (
      
        'EXECUTE PROCEDURE REQUEST_ADD (?I_ACTION_SIGN, ?I_PARTS, ?I_SCAN' +
        '_ID)')
    StoredProcName = 'REQUEST_ADD'
    Left = 152
    Top = 104
    qoAutoCommit = True
    qoStartTransaction = True
    qoTrimCharFields = True
  end
  object spRequestCommit: TpFIBStoredProc
    Transaction = trnWrite
    Database = dbSwim
    SQL.Strings = (
      'EXECUTE PROCEDURE REQUEST_COMMIT (?I_REQUEST_ID, ?I_SCAN_ID)')
    StoredProcName = 'REQUEST_COMMIT'
    Left = 152
    Top = 160
    qoAutoCommit = True
    qoStartTransaction = True
    qoTrimCharFields = True
  end
  object spRequestRollback: TpFIBStoredProc
    Transaction = trnWrite
    Database = dbSwim
    SQL.Strings = (
      'EXECUTE PROCEDURE REQUEST_ROLLBACK (?I_REQUEST_ID)')
    StoredProcName = 'REQUEST_ROLLBACK'
    Left = 152
    Top = 216
    qoAutoCommit = True
    qoStartTransaction = True
    qoTrimCharFields = True
  end
end
