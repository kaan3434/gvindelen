inherited ConnectDialogFrame: TConnectDialogFrame
  Width = 441
  Height = 275
  Align = alClient
  object ToolBar: TPanel
    Left = 0
    Top = 0
    Width = 441
    Height = 49
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 414
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
    end
    object Panel2: TPanel
      Left = 0
      Top = 25
      Width = 274
      Height = 24
      BevelOuter = bvNone
      Color = 6369932
      TabOrder = 1
      object Panel3: TPanel
        Left = 1
        Top = 1
        Width = 272
        Height = 22
        BevelOuter = bvNone
        TabOrder = 0
        object rbDefault: TRadioButton
          Left = 8
          Top = 5
          Width = 65
          Height = 17
          Caption = 'Default'
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = rbDefaultClick
        end
        object rbMy: TRadioButton
          Left = 72
          Top = 6
          Width = 81
          Height = 14
          Caption = 'My connect'
          TabOrder = 1
          OnClick = rbMyClick
        end
        object rbInherited: TRadioButton
          Left = 160
          Top = 5
          Width = 106
          Height = 17
          Caption = 'Inherited connect'
          TabOrder = 2
          OnClick = rbInheritedClick
        end
      end
    end
  end
  object DBGrid: TDBGrid
    Left = 0
    Top = 49
    Width = 441
    Height = 226
    Align = alClient
    DataSource = DataSource
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object DataSource: TDataSource
    DataSet = IBCQuery
    Left = 58
    Top = 72
  end
  object IBCQuery: TIBCQuery
    SQL.Strings = (
      'select * from emp')
    Left = 22
    Top = 64
  end
end
