object fmMain: TfmMain
  Left = 213
  Top = 142
  Width = 711
  Height = 452
  ActiveControl = meSQL
  Caption = 'InterBase Data Access Demo - IBDAC for C++Builder'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 111
    Width = 703
    Height = 3
    Cursor = crVSplit
    Align = alTop
  end
  object ToolBar: TPanel
    Left = 0
    Top = 0
    Width = 703
    Height = 24
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object btOpen: TButton
      Left = 151
      Top = 0
      Width = 75
      Height = 25
      Caption = 'Open'
      TabOrder = 2
      OnClick = btOpenClick
    end
    object btClose: TButton
      Left = 226
      Top = 0
      Width = 75
      Height = 25
      Caption = 'Close'
      TabOrder = 3
      OnClick = btCloseClick
    end
    object btExecute: TButton
      Left = 301
      Top = 0
      Width = 75
      Height = 25
      Caption = 'Execute'
      TabOrder = 4
      OnClick = btExecuteClick
    end
    object DBNavigator: TDBNavigator
      Left = 376
      Top = 0
      Width = 240
      Height = 25
      DataSource = DataSource
      TabOrder = 5
    end
    object btDisconnect: TButton
      Left = 76
      Top = 0
      Width = 75
      Height = 25
      Caption = 'Disconnect'
      TabOrder = 1
      OnClick = btDisconnectClick
    end
    object btConnect: TButton
      Left = 1
      Top = 0
      Width = 75
      Height = 25
      Caption = 'Connect'
      TabOrder = 0
      OnClick = btConnectClick
    end
    object cbDebug: TCheckBox
      Left = 624
      Top = 6
      Width = 97
      Height = 17
      Caption = 'Debug'
      Checked = True
      State = cbChecked
      TabOrder = 6
      OnClick = cbDebugClick
    end
  end
  object meSQL: TMemo
    Left = 0
    Top = 24
    Width = 703
    Height = 87
    Align = alTop
    TabOrder = 1
    OnExit = meSQLExit
  end
  object DBGrid: TDBGrid
    Left = 0
    Top = 114
    Width = 703
    Height = 311
    Align = alClient
    DataSource = DataSource
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object DataSource: TDataSource
    DataSet = IBCQuery
    Left = 376
    Top = 72
  end
  object IBCTransaction: TIBCTransaction
    DefaultConnection = IBCConnection1
    Left = 280
    Top = 72
  end
  object IBCQuery: TIBCQuery
    Connection = IBCConnection1
    SQL.Strings = (
      'select * from dept')
    AutoCommit = True
    Left = 312
    Top = 72
  end
  object IBCConnectDialog1: TIBCConnectDialog
    DatabaseLabel = 'Database'
    ProtocolLabel = 'Protocol'
    Caption = 'Connect'
    UsernameLabel = 'User Name'
    PasswordLabel = 'Password'
    ServerLabel = 'Server'
    ConnectButton = 'Connect'
    CancelButton = 'Cancel'
    Left = 344
    Top = 72
  end
  object IBCConnection1: TIBCConnection
    Username = 'sysdba'
    ConnectDialog = IBCConnectDialog1
    Left = 248
    Top = 72
  end
end
