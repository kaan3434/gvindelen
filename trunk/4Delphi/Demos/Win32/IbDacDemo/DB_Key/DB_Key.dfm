inherited DB_KeyFrame: TDB_KeyFrame
  Width = 443
  Height = 277
  Align = alClient
  object DBGrid: TDBGrid
    Left = 0
    Top = 53
    Width = 443
    Height = 224
    Align = alClient
    DataSource = DataSource
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object ToolBar: TPanel
    Left = 0
    Top = 0
    Width = 443
    Height = 25
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 356
      Height = 25
      BevelOuter = bvNone
      Color = 6369932
      TabOrder = 0
      object btClose: TSpeedButton
        Left = 87
        Top = 1
        Width = 85
        Height = 24
        Caption = 'Close'
        Flat = True
        Transparent = False
        OnClick = btCloseClick
      end
      object btOpen: TSpeedButton
        Left = 1
        Top = 1
        Width = 85
        Height = 24
        Caption = 'Open'
        Flat = True
        Transparent = False
        OnClick = btOpenClick
      end
      object Panel3: TPanel
        Left = 173
        Top = 1
        Width = 182
        Height = 24
        BevelOuter = bvNone
        TabOrder = 0
        object Label1: TLabel
          Left = 52
          Top = 6
          Width = 118
          Height = 13
          Caption = 'Use Firebird 2.0 or higher'
        end
        object Label2: TLabel
          Left = 18
          Top = 6
          Width = 32
          Height = 13
          Caption = 'Note:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Pitch = fpVariable
          Font.Style = [fsBold]
          ParentFont = False
        end
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 25
    Width = 443
    Height = 28
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object Panel4: TPanel
      Left = 0
      Top = 0
      Width = 394
      Height = 26
      BevelOuter = bvNone
      Color = 6369932
      TabOrder = 0
      object btRefreshRecord: TSpeedButton
        Left = 308
        Top = 1
        Width = 85
        Height = 24
        Caption = 'Refresh Record'
        Flat = True
        Transparent = False
        OnClick = btRefreshRecordClick
      end
      object btAddRecord: TSpeedButton
        Left = 222
        Top = 1
        Width = 85
        Height = 24
        Caption = 'Add Record'
        Flat = True
        Transparent = False
        OnClick = btAddRecordClick
      end
      object DBNavigator1: TDBNavigator
        Left = 1
        Top = 1
        Width = 220
        Height = 24
        DataSource = DataSource
        Flat = True
        TabOrder = 0
      end
    end
  end
  object DataSource: TDataSource
    DataSet = IBCQuery
    Left = 68
    Top = 34
  end
  object IBCQuery: TIBCQuery
    DMLRefresh = True
    SQL.Strings = (
      'SELECT T.RDB$DB_KEY, T.* FROM DB_KEY_TABLE T')
    AutoCommit = True
    AfterInsert = IBCQueryAfterInsert
    Left = 38
    Top = 34
    object IBCQueryRDBDB_KEY: TIBCDbKeyField
      DisplayWidth = 20
      FieldName = 'RDB$DB_KEY'
      ReadOnly = True
      Size = 8
    end
    object IBCQueryTITLE: TStringField
      FieldName = 'TITLE'
      Size = 30
    end
    object IBCQueryVAL: TStringField
      FieldName = 'VAL'
      Size = 4000
    end
    object IBCQuerySTAMP_ADD: TDateTimeField
      FieldName = 'STAMP_ADD'
    end
  end
end
