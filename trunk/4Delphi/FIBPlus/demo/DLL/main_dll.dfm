object frmMain: TfrmMain
  Left = 192
  Top = 113
  ActiveControl = dbgCountry
  BorderStyle = bsDialog
  Caption = 'Form from DLL'
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object btnClose: TBitBtn
    Left = 460
    Top = 320
    Width = 75
    Height = 25
    Caption = 'Close'
    ModalResult = 1
    TabOrder = 2
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
    DataSource = dmMain.dsCountry
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 1
    TitleFont.Charset = RUSSIAN_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDblClick = dbgCountryDblClick
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
    Top = 4
    Width = 192
    Height = 25
    DataSource = dmMain.dsCountry
    VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbDelete, nbEdit, nbRefresh]
    Flat = True
    TabOrder = 0
    OnClick = dbnCountryClick
  end
end
