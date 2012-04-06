object DM: TDM
  OldCreateOrder = False
  Height = 250
  Width = 225
  object Connection: TIBCConnection
    AfterConnect = ConnectionAfterConnect
    BeforeConnect = ConnectionBeforeConnect
    AfterDisconnect = ConnectionAfterDisconnect
    Left = 40
    Top = 24
  end
end
