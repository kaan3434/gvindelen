object frmMidas: TfrmMidas
  Left = 224
  Top = 128
  ActiveControl = Button1
  BorderStyle = bsDialog
  Caption = 'MIDAS'
  ClientHeight = 348
  ClientWidth = 536
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 224
    Top = 10
    Width = 149
    Height = 13
    Caption = 'MaxErrors (for ApplyUpdates) = '
  end
  object btnClose: TBitBtn
    Left = 460
    Top = 320
    Width = 75
    Height = 25
    Caption = 'Close'
    ModalResult = 1
    TabOrder = 5
    OnClick = btnCloseClick
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      1800000000000003000000000000000000000000000000000000FF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FF000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FFFFFF8080800000
      00000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00000000
      0000000000000000FFFFFF808080808080000000000000FF00FFFF00FFFF00FF
      FF00FF000000000000FF00FF000000FFFFFFFFFFFF000000FFFFFF8080808080
      80808080000000FF00FFFF00FFFF00FFFF00FF000000FFFFFF000000FFFFFFFF
      FFFFFFFFFF000000FFFFFF808080808080808080000000FF00FF000000000000
      000000000000FFFFFFFFFFFF000000FFFFFFFFFFFF000000FFFFFF8080808080
      80808080000000FF00FF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
      0000FFFFFF000000FFFFFF000000000000808080000000FF00FF000000FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFF8080800000
      00808080000000FF00FF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
      0000FFFFFF000000FFFFFF808080808080808080000000FF00FF000000000000
      000000000000FFFFFFFFFFFF000000FFFFFFFFFFFF000000FFFFFF8080808080
      80808080000000FF00FFFF00FFFF00FFFF00FF000000FFFFFF000000FFFFFFFF
      FFFFFFFFFF000000FFFFFF808080808080808080000000FF00FFFF00FFFF00FF
      FF00FF000000000000FF00FF000000FFFFFFFFFFFF000000FFFFFF8080808080
      80808080000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FF
      FFFFFFFFFF000000000000FFFFFF808080808080000000FF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FF000000FFFFFFFFFFFFFFFFFF000000000000FFFF
      FF808080000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00000000
      0000000000000000000000000000000000000000000000FF00FF}
  end
  object dbgCountry: TDBGrid
    Left = 0
    Top = 32
    Width = 536
    Height = 285
    DataSource = DataSource1
    Options = [dgEditing, dgAlwaysShowEditor, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete]
    TabOrder = 4
    TitleFont.Charset = RUSSIAN_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'NAME'
        Title.Caption = 'Name'
        Width = 90
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CAPITAL'
        Title.Caption = 'Capital'
        Width = 90
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CONTINENT'
        Title.Caption = 'Continent'
        Width = 90
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'AREA'
        Title.Caption = 'Area'
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'POPULATION'
        Title.Caption = 'Population'
        Width = 100
        Visible = True
      end>
  end
  object dbnCountry: TDBNavigator
    Left = 4
    Top = 320
    Width = 240
    Height = 25
    DataSource = DataSource1
    Flat = True
    TabOrder = 3
  end
  object Button1: TButton
    Left = 4
    Top = 4
    Width = 137
    Height = 25
    Caption = 'Connect to MIDAS Server'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 144
    Top = 4
    Width = 75
    Height = 25
    Caption = 'ApplyUpdates'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 458
    Top = 4
    Width = 75
    Height = 25
    Caption = 'ReOpen'
    TabOrder = 2
    OnClick = Button3Click
  end
  object SpinEdit1: TSpinEdit
    Left = 376
    Top = 6
    Width = 49
    Height = 22
    MaxValue = 10
    MinValue = -1
    TabOrder = 6
    Value = -1
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspMidas'
    RemoteServer = DCOMConnection1
    Left = 160
    Top = 120
    object ClientDataSet1ID: TIntegerField
      FieldName = 'ID'
    end
    object ClientDataSet1NAME: TStringField
      FieldName = 'NAME'
      Size = 30
    end
    object ClientDataSet1CAPITAL: TStringField
      FieldName = 'CAPITAL'
      Size = 30
    end
    object ClientDataSet1CONTINENT: TStringField
      FieldName = 'CONTINENT'
      Size = 30
    end
    object ClientDataSet1AREA: TFloatField
      FieldName = 'AREA'
      DisplayFormat = '###,###,###,##0.00'
      EditFormat = '0.##'
    end
    object ClientDataSet1POPULATION: TFloatField
      FieldName = 'POPULATION'
      DisplayFormat = '###,###,###,##0.00'
      EditFormat = '0.##'
    end
  end
  object DataSource1: TDataSource
    DataSet = ClientDataSet1
    Left = 164
    Top = 164
  end
  object DCOMConnection1: TDCOMConnection
    ServerGUID = '{D9EA72CA-E39E-492A-ABB3-C2F2A31F12C1}'
    ServerName = 'server_midas.FIBPlusDemoServer'
    Left = 72
    Top = 84
  end
end
