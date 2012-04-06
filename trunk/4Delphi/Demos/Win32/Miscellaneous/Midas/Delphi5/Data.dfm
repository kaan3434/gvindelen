object Datas: TDatas
  OldCreateOrder = False
  OnCreate = DatasCreate
  OnDestroy = DatasDestroy
  Left = 285
  Top = 161
  Height = 479
  Width = 741
  object IBCConnection: TIBCConnection
    ConnectDialog = ConnectDialog
    AfterConnect = IBCConnectionAfterConnect
    AfterDisconnect = IBCConnectionAfterDisconnect
    Left = 24
    Top = 16
  end
  object Query: TIBCQuery
    KeyFields = 'DEPTNO'
    Connection = IBCConnection
    SQL.Strings = (
      'SELECT D.*'
      'FROM Dept D'
      'WHERE DeptNo < :DeptNo')
    Debug = True
    Left = 112
    Top = 16
    ParamData = <
      item
        DataType = ftInteger
        Name = 'DeptNo'
        Value = 35
      end>
  end
  object DataSetProvider: TDataSetProvider
    DataSet = Query
    Constraints = True
    ResolveToDataSet = True
    Options = [poNoReset]
    Left = 112
    Top = 64
  end
  object ConnectDialog: TIBCConnectDialog
    DatabaseLabel = 'Database'
    ProtocolLabel = 'Protocol'
    SavePassword = True
    Caption = 'Connect'
    UsernameLabel = 'User Name'
    PasswordLabel = 'Password'
    ServerLabel = 'Server'
    ConnectButton = 'Connect'
    CancelButton = 'Cancel'
    Left = 24
    Top = 64
  end
end
