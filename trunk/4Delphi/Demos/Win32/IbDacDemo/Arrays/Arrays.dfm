inherited ArraysFrame: TArraysFrame
  Width = 443
  Height = 277
  Align = alClient
  object DBGrid: TDBGrid
    Left = 0
    Top = 75
    Width = 443
    Height = 202
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
    Height = 75
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Panel5: TPanel
      Left = 0
      Top = 0
      Width = 414
      Height = 50
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
      object DBNavigator1: TDBNavigator
        Left = 173
        Top = 1
        Width = 240
        Height = 24
        DataSource = DataSource
        Flat = True
        TabOrder = 0
      end
      object Panel1: TPanel
        Left = 1
        Top = 26
        Width = 203
        Height = 23
        BevelOuter = bvNone
        TabOrder = 1
        object cbComplexArrayFields: TCheckBox
          Left = 86
          Top = 4
          Width = 113
          Height = 17
          Caption = 'ComplexArrayFields'
          Checked = True
          State = cbChecked
          TabOrder = 1
          OnClick = cbComplexArrayFieldsClick
        end
        object cbObjectView: TCheckBox
          Left = 7
          Top = 5
          Width = 76
          Height = 16
          Caption = 'ObjectView'
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = cbObjectViewClick
        end
      end
      object Panel2: TPanel
        Left = 205
        Top = 26
        Width = 208
        Height = 23
        BevelOuter = bvNone
        TabOrder = 2
        object cbCacheArrays: TCheckBox
          Left = 123
          Top = 4
          Width = 78
          Height = 17
          Caption = 'CacheArrays'
          Checked = True
          State = cbChecked
          TabOrder = 1
          OnClick = cbCacheArraysClick
        end
        object cbDeferredArrayRead: TCheckBox
          Left = 7
          Top = 4
          Width = 114
          Height = 17
          Caption = 'DeferredArrayRead'
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = cbDeferredArrayReadClick
        end
      end
    end
    object Panel3: TPanel
      Left = 0
      Top = 50
      Width = 307
      Height = 25
      BevelOuter = bvNone
      Color = 6369932
      TabOrder = 1
      object btAddRecord: TSpeedButton
        Left = 1
        Top = 0
        Width = 85
        Height = 24
        Caption = 'Add Record'
        Flat = True
        Transparent = False
        OnClick = btAddRecordClick
      end
      object btUpdateRecord: TSpeedButton
        Left = 87
        Top = 0
        Width = 85
        Height = 24
        Caption = 'Update Record'
        Flat = True
        Transparent = False
        OnClick = btUpdateRecordClick
      end
      object btUpdateSlice: TSpeedButton
        Left = 173
        Top = 0
        Width = 133
        Height = 24
        Caption = 'Update Record (Slice)'
        Flat = True
        Transparent = False
        OnClick = btUpdateSliceClick
      end
    end
  end
  object DataSource: TDataSource
    DataSet = IBCQuery
    Left = 244
    Top = 144
  end
  object IBCQuery: TIBCQuery
    KeyFields = 'ID'
    KeyGenerator = 'IBDAC_GEN'
    SQL.Strings = (
      'SELECT * FROM IBDAC_ARRAYS')
    AutoCommit = True
    ObjectView = True
    Left = 246
    Top = 112
  end
  object IBCSQL: TIBCSQL
    SQL.Strings = (
      'UPDATE IBDAC_ARRAYS'
      'SET INT_ARR1 = :ARR1, CHAR_ARR2 = :ARR2'
      'WHERE ID = :ID')
    AutoCommit = True
    Left = 280
    Top = 112
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'ARR1'
      end
      item
        DataType = ftUnknown
        Name = 'ARR2'
      end
      item
        DataType = ftUnknown
        Name = 'ID'
      end>
  end
end
