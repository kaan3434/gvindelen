inherited LongStringsFrame: TLongStringsFrame
  Width = 443
  Height = 277
  Align = alClient
  object Splitter1: TSplitter
    Left = 0
    Top = 182
    Width = 443
    Height = 2
    Cursor = crVSplit
    Align = alTop
  end
  object ToolBar: TPanel
    Left = 0
    Top = 0
    Width = 443
    Height = 26
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 499
      Height = 26
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
      object DBNavigator: TDBNavigator
        Left = 173
        Top = 1
        Width = 240
        Height = 24
        DataSource = DataSource
        Flat = True
        TabOrder = 0
      end
      object Panel5: TPanel
        Left = 414
        Top = 1
        Width = 84
        Height = 24
        BevelOuter = bvNone
        TabOrder = 1
        object cbLongStrings: TCheckBox
          Left = 5
          Top = 4
          Width = 77
          Height = 17
          Caption = 'LongStrings'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 0
          OnClick = cbLongStringsClick
        end
      end
    end
  end
  object meComments: TDBMemo
    Left = 0
    Top = 210
    Width = 443
    Height = 67
    Align = alClient
    DataField = 'VAL'
    DataSource = DataSource
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object Panel2: TPanel
    Left = 0
    Top = 184
    Width = 443
    Height = 26
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object Panel4: TPanel
      Left = 0
      Top = 0
      Width = 229
      Height = 26
      BevelOuter = bvNone
      Color = 6369932
      TabOrder = 0
      object btClear: TSpeedButton
        Left = 153
        Top = 1
        Width = 75
        Height = 24
        Caption = 'Clear'
        Flat = True
        Transparent = False
        OnClick = btClearClick
      end
      object btLoad: TSpeedButton
        Left = 1
        Top = 1
        Width = 75
        Height = 24
        Caption = 'Load from file'
        Flat = True
        Transparent = False
        OnClick = btLoadClick
      end
      object btSave: TSpeedButton
        Left = 77
        Top = 1
        Width = 75
        Height = 24
        Caption = 'Save to file'
        Flat = True
        Transparent = False
        OnClick = btSaveClick
      end
    end
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 26
    Width = 443
    Height = 156
    Align = alTop
    DataSource = DataSource
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object DataSource: TDataSource
    DataSet = IBCQuery
    Left = 288
    Top = 64
  end
  object OpenDialog: TOpenDialog
    Title = 'Open'
    Left = 264
    Top = 219
  end
  object SaveDialog: TSaveDialog
    Title = 'Save As'
    Left = 296
    Top = 219
  end
  object IBCQuery: TIBCQuery
    SQL.Strings = (
      'SELECT * FROM IbDAC_Long_char')
    AutoCommit = True
    Left = 230
    Top = 45
  end
end
