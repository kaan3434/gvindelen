object DM: TDM
  OldCreateOrder = False
  Left = 184
  Top = 103
  Height = 250
  Width = 225
  object Connection: TIBCConnection
    ClientLibrary = 'gds32.dll'
    AfterConnect = ConnectionAfterConnect
    BeforeConnect = ConnectionBeforeConnect
    AfterDisconnect = ConnectionAfterDisconnect
    Left = 40
    Top = 24
  end
end
