object DataModule1: TDataModule1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 494
  Width = 765
  object dbSwim: TIBDatabase
    DatabaseName = 'D:\Swim4\Data\SWIM.FDB'
    Params.Strings = (
      'user_name=SYSDBA'
      'password=masterkey'
      'lc_ctype=UTF8')
    LoginPrompt = False
    DefaultTransaction = trnWrite
    ServerType = 'IBServer'
    Left = 32
    Top = 24
  end
  object trnWrite: TIBTransaction
    AllowAutoStart = False
    DefaultDatabase = dbSwim
    DefaultAction = TARollback
    Left = 96
    Top = 24
  end
  object qrySwim: TIBQuery
    Database = dbSwim
    Transaction = trnWrite
    Left = 160
    Top = 24
  end
  object dsSwim: TDataSource
    DataSet = qrySwim
    Left = 224
    Top = 24
  end
end
