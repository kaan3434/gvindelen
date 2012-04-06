object fmClient: TfmClient
  Left = 355
  Top = 103
  Width = 574
  Height = 379
  Caption = 'InterBase Data Access Demo - MIDAS Client'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ToolBar: TToolBar
    Left = 0
    Top = 0
    Width = 566
    Height = 26
    Caption = 'ToolBar'
    TabOrder = 0
    object brConnect: TButton
      Left = 0
      Top = 2
      Width = 75
      Height = 22
      Caption = 'Connect'
      TabOrder = 0
      OnClick = brConnectClick
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
    object btApplyUpd: TButton
      Left = 300
      Top = 2
      Width = 75
      Height = 22
      Caption = 'ApplyUpd'
      TabOrder = 4
      OnClick = btApplyUpdClick
    end
    object btCancelUpd: TButton
      Left = 375
      Top = 2
      Width = 75
      Height = 22
      Caption = 'CancelUpd'
      TabOrder = 5
      OnClick = btCancelUpdClick
    end
  end
  object DBGrid: TDBGrid
    Left = 0
    Top = 52
    Width = 566
    Height = 281
    Align = alClient
    DataSource = DataSource
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 26
    Width = 566
    Height = 26
    Caption = 'ToolBar1'
    TabOrder = 2
    object DBNavigator1: TDBNavigator
      Left = 0
      Top = 2
      Width = 240
      Height = 22
      DataSource = DataSource
      TabOrder = 0
    end
    object DeptNo: TLabel
      Left = 240
      Top = 2
      Width = 71
      Height = 22
      Alignment = taCenter
      AutoSize = False
      Caption = 'DeptNo'
      Layout = tlCenter
    end
    object edDeptNo: TEdit
      Left = 311
      Top = 2
      Width = 121
      Height = 22
      TabOrder = 1
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 333
    Width = 566
    Height = 19
    Panels = <
      item
        Width = 50
      end>
    SimplePanel = False
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 328
    Top = 60
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'DeptNo'
        ParamType = ptUnknown
        Value = 35
      end>
    ProviderName = 'DataSetProvider'
    RemoteServer = RemoteServer
    Left = 296
    Top = 60
  end
  object RemoteServer: TRemoteServer
    ServerName = 'Server.Datas'
    AfterConnect = RemoteServerAfterConnect
    AfterDisconnect = RemoteServerAfterDisconnect
    Left = 264
    Top = 60
  end
end
