object ThreadsDataModule: TThreadsDataModule
  OldCreateOrder = False
  Left = 219
  Top = 191
  Height = 479
  Width = 741
  object IBCConnection: TIBCConnection
    Left = 24
    Top = 16
  end
  object IBCQuery: TIBCQuery
    Connection = IBCConnection
    SQL.Strings = (
      'SELECT * FROM Thread_Table')
    FetchAll = True
    CachedUpdates = True
    Left = 88
    Top = 16
  end
  object IBCSQL: TIBCSQL
    Connection = IBCConnection
    SQL.Strings = (
      'INSERT INTO Thread_Table(ID, Name)'
      'VALUES (:ID, '#39'Some name'#39')')
    Left = 144
    Top = 16
    ParamData = <
      item
        DataType = ftInteger
        Name = 'ID'
        ParamType = ptInput
      end>
  end
end
