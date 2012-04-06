object fmServer: TfmServer
  Left = 218
  Top = 209
  Width = 582
  Height = 396
  Caption = 'InterBase Data Access Demo - MIDAS Server'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object ToolBar: TToolBar
    Left = 0
    Top = 0
    Width = 574
    Height = 26
    Caption = 'ToolBar'
    TabOrder = 0
    object btConnect: TButton
      Left = 0
      Top = 2
      Width = 75
      Height = 22
      Caption = 'Connect'
      TabOrder = 0
      OnClick = btConnectClick
    end
    object btDisconnect: TButton
      Left = 75
      Top = 2
      Width = 75
      Height = 22
      Caption = 'Disconnect'
      TabOrder = 1
      OnClick = btDisconnectClick
    end
    object btOpen: TButton
      Left = 150
      Top = 2
      Width = 75
      Height = 22
      Caption = 'Open'
      TabOrder = 2
      OnClick = btOpenClick
    end
    object btClose: TButton
      Left = 225
      Top = 2
      Width = 75
      Height = 22
      Caption = 'Close'
      TabOrder = 3
      OnClick = btCloseClick
    end
  end
  object meSQL: TMemo
    Left = 0
    Top = 52
    Width = 574
    Height = 76
    Align = alTop
    TabOrder = 1
    OnExit = meSQLExit
  end
  object DBGrid: TDBGrid
    Left = 0
    Top = 128
    Width = 574
    Height = 222
    Align = alClient
    DataSource = DataSource
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 26
    Width = 574
    Height = 26
    Caption = 'ToolBar1'
    TabOrder = 3
    object DBNavigator: TDBNavigator
      Left = 0
      Top = 2
      Width = 240
      Height = 22
      DataSource = DataSource
      TabOrder = 0
    end
    object ToolButton2: TToolButton
      Left = 240
      Top = 2
      Width = 25
      Caption = 'ToolButton2'
      ImageIndex = 0
      Style = tbsSeparator
    end
    object cbDebug: TCheckBox
      Left = 265
      Top = 2
      Width = 64
      Height = 22
      Caption = 'Debug'
      TabOrder = 1
      OnClick = cbDebugClick
    end
    object rbDSResolve: TRadioButton
      Left = 329
      Top = 2
      Width = 120
      Height = 22
      Caption = 'Resolve to Dataset'
      TabOrder = 2
      OnClick = rbDSResolveClick
    end
    object rbSQLResolve: TRadioButton
      Left = 449
      Top = 2
      Width = 104
      Height = 22
      Caption = 'Resolve by SQL'
      TabOrder = 3
      OnClick = rbSQLResolveClick
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 350
    Width = 574
    Height = 19
    Panels = <
      item
        Width = 50
      end>
    SimplePanel = False
  end
  object DataSource: TDataSource
    DataSet = Datas.Query
    Left = 8
    Top = 64
  end
end
