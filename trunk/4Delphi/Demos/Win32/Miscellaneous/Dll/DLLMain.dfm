object fmDllMain: TfmDllMain
  Left = 349
  Top = 278
  Width = 599
  Height = 337
  Caption = 'InterBase Data Access Demo - DLL'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefaultPosOnly
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object DBGrid: TDBGrid
    Left = 0
    Top = 28
    Width = 591
    Height = 269
    Align = alClient
    DataSource = DataSource
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object pnToolBar: TPanel
    Left = 0
    Top = 0
    Width = 591
    Height = 28
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object btOpen: TButton
      Left = 0
      Top = 0
      Width = 92
      Height = 30
      Caption = 'Open'
      TabOrder = 0
      OnClick = btOpenClick
    end
    object btClose: TButton
      Left = 92
      Top = 0
      Width = 93
      Height = 30
      Caption = 'Close'
      TabOrder = 1
      OnClick = btCloseClick
    end
    object DBNavigator: TDBNavigator
      Left = 185
      Top = 0
      Width = 290
      Height = 30
      DataSource = DataSource
      TabOrder = 2
    end
  end
  object IBCQuery: TIBCQuery
    SQL.Strings = (
      'SELECT * FROM Dept')
    Left = 24
    Top = 56
  end
  object DataSource: TDataSource
    DataSet = IBCQuery
    Left = 56
    Top = 56
  end
end
