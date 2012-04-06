object fmExeMain: TfmExeMain
  Left = 214
  Top = 191
  Width = 645
  Height = 369
  Caption = 'InterBase Data Access Demo - Application'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object pnToolBar: TPanel
    Left = 0
    Top = 0
    Width = 637
    Height = 59
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object btConnect: TButton
      Left = 0
      Top = 0
      Width = 92
      Height = 30
      Caption = 'Connect'
      TabOrder = 0
      OnClick = btConnectClick
    end
    object btDisconnect: TButton
      Left = 92
      Top = 0
      Width = 93
      Height = 30
      Caption = 'Disconnect'
      TabOrder = 1
      OnClick = btDisconnectClick
    end
    object btOpen: TButton
      Left = 185
      Top = 0
      Width = 92
      Height = 30
      Caption = 'Open'
      TabOrder = 2
      OnClick = btOpenClick
    end
    object btClose: TButton
      Left = 277
      Top = 0
      Width = 92
      Height = 30
      Caption = 'Close'
      TabOrder = 3
      OnClick = btCloseClick
    end
    object DBNavigator: TDBNavigator
      Left = 369
      Top = 0
      Width = 290
      Height = 30
      DataSource = DataSource
      TabOrder = 8
    end
    object btLoadDLL: TButton
      Left = 0
      Top = 30
      Width = 110
      Height = 29
      Caption = '1. Load DLL'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      OnClick = btLoadDLLClick
    end
    object btShowForm: TButton
      Left = 110
      Top = 30
      Width = 109
      Height = 29
      Caption = '2. Show Form'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
      OnClick = btShowFormClick
    end
    object btHideForms: TButton
      Left = 219
      Top = 30
      Width = 110
      Height = 29
      Caption = '3. Hide Forms'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 6
      OnClick = btHideFormsClick
    end
    object btFreeDLL: TButton
      Left = 329
      Top = 30
      Width = 114
      Height = 29
      Caption = '4. Free DLL'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 7
      OnClick = btFreeDLLClick
    end
  end
  object DBGrid: TDBGrid
    Left = 0
    Top = 59
    Width = 637
    Height = 270
    Align = alClient
    DataSource = DataSource
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object IBCConnection: TIBCConnection
    Username = 'SYSDBA'
    ConnectDialog = ConnectDialog
    Left = 16
    Top = 88
  end
  object ConnectDialog: TIBCConnectDialog
    Left = 48
    Top = 88
  end
  object IBCQuery: TIBCQuery
    Connection = IBCConnection
    SQL.Strings = (
      'SELECT * FROM Dept')
    Left = 16
    Top = 120
  end
  object DataSource: TDataSource
    DataSet = IBCQuery
    Left = 48
    Top = 120
  end
end
