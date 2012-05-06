inherited dmFormMain: TdmFormMain
  inherited dbSwim: TpFIBDatabase
    Connected = True
  end
  object spRequestAdd: TpFIBStoredProc
    Transaction = trnWrite
    Database = dbSwim
    SQL.Strings = (
      
        'EXECUTE PROCEDURE REQUEST_ADD (?I_ACTION_SIGN, ?I_PARTS, ?I_SCAN' +
        '_ID)')
    StoredProcName = 'REQUEST_ADD'
    Left = 144
    Top = 40
  end
end
