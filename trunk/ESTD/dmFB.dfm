object dmFireBird: TdmFireBird
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 393
  Top = 274
  Height = 361
  Width = 416
  object dbData: TpFIBDatabase
    Connected = True
    DBName = 'D:\GOST\ESTD.FDB'
    DBParams.Strings = (
      'user_name=SYSDBA'
      'password=masterkey'
      'lc_ctype=UTF8')
    DefaultTransaction = trnRead
    DefaultUpdateTransaction = trnUpdate
    SQLDialect = 3
    Timeout = 0
    UpperOldNames = True
    AliasName = 'ESTD'
    WaitForRestoreConnect = 0
    Left = 32
    Top = 32
  end
  object trnUpdate: TpFIBTransaction
    DefaultDatabase = dbData
    TimeoutAction = TARollback
    Left = 32
    Top = 88
  end
  object trnRead: TpFIBTransaction
    Active = True
    DefaultDatabase = dbData
    TimeoutAction = TARollback
    Left = 32
    Top = 144
  end
  object tblTemp: TpFIBDataSet
    UniDirectional = True
    Transaction = trnRead
    Database = dbData
    UpdateTransaction = trnUpdate
    Left = 32
    Top = 200
  end
  object memQueries: TMemTableEh
    FieldDefs = <>
    IndexDefs = <
      item
        Name = 'memQueriesIndex_query_sign'
        CaseInsFields = 'query_sign'
        Fields = 'query_sign'
        Options = [ixPrimary, ixUnique, ixCaseInsensitive]
      end>
    Params = <>
    StoreDefs = True
    Left = 232
    Top = 32
    object wsfldQueries_query_sign: TWideStringField
      FieldName = 'query_sign'
      ReadOnly = True
      Required = True
      Size = 30
    end
    object wsfldQueries_query_text: TWideStringField
      FieldName = 'query_text'
      Size = 4000
    end
  end
end
