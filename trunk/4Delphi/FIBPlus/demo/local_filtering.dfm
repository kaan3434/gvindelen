object frmLocalFiltering: TfrmLocalFiltering
  Left = 196
  Top = 188
  ActiveControl = edtFilter
  BorderStyle = bsDialog
  Caption = 'Local Filtering'
  ClientHeight = 348
  ClientWidth = 536
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 5
    Top = 1
    Width = 22
    Height = 13
    Caption = 'Filter'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
  end
  object dbgCountry: TDBGrid
    Left = 0
    Top = 40
    Width = 536
    Height = 277
    DataSource = dsCountry
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
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
  object btnClose: TBitBtn
    Left = 459
    Top = 320
    Width = 75
    Height = 25
    Caption = 'Close'
    ModalResult = 1
    TabOrder = 4
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
  object edtFilter: TEdit
    Left = 5
    Top = 16
    Width = 121
    Height = 21
    TabOrder = 0
    OnChange = edtFilterChange
  end
  object RadioButton1: TRadioButton
    Left = 134
    Top = 18
    Width = 61
    Height = 17
    Caption = 'Name'
    Checked = True
    TabOrder = 1
    TabStop = True
    OnClick = RadioButton1Click
  end
  object RadioButton2: TRadioButton
    Left = 202
    Top = 18
    Width = 61
    Height = 17
    Caption = 'Capital'
    TabOrder = 2
    OnClick = RadioButton1Click
  end
  object dtCountry: TpFIBDataSet
    Database = dmMain.dbDemo
    Transaction = dmMain.trRead
    Options = [poStartTransaction]
    AutoCommit = True
    BufferChunks = 32
    CachedUpdates = False
    UniDirectional = False
    UpdateRecordTypes = [cusUnmodified, cusModified, cusInserted]
    UpdateSQL.Strings = (
      'UPDATE COUNTRY SET '
      '    NAME = :NAME,'
      '    CAPITAL = :CAPITAL,'
      '    CONTINENT = :CONTINENT,'
      '    AREA = :AREA,'
      '    POPULATION = :POPULATION'
      ' WHERE     '
      '            ID = :OLD_ID'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM COUNTRY'
      'WHERE     '
      '            ID = :OLD_ID'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO COUNTRY('
      '    ID,'
      '    NAME,'
      '    CAPITAL,'
      '    CONTINENT,'
      '    AREA,'
      '    POPULATION'
      ')'
      'VALUES('
      '    :ID,'
      '    :NAME,'
      '    :CAPITAL,'
      '    :CONTINENT,'
      '    :AREA,'
      '    :POPULATION'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    C.ID,'
      '    C.NAME,'
      '    C.CAPITAL,'
      '    C.CONTINENT,'
      '    C.AREA,'
      '    C.POPULATION'
      'FROM'
      '    COUNTRY C'
      ' WHERE '
      '            C.ID = :OLD_ID')
    SelectSQL.Strings = (
      'SELECT'
      '    C.ID,'
      '    C.NAME,'
      '    C.CAPITAL,'
      '    C.CONTINENT,'
      '    C.AREA,'
      '    C.POPULATION'
      'FROM'
      '    COUNTRY C'
      'ORDER BY C.NAME')
    OnFilterRecord = dtCountryFilterRecord
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    AutoUpdateOptions.UpdateTableName = 'COUNTRY'
    AutoUpdateOptions.KeyFields = 'ID'
    AutoUpdateOptions.GeneratorName = 'GEN_COUNTRY_ID'
    AutoUpdateOptions.WhenGetGenID = wgBeforePost
    Left = 40
    Top = 156
    poImportDefaultValues = False
    poGetOrderInfo = False
    object dtCountryID: TFIBIntegerField
      FieldName = 'ID'
    end
    object dtCountryNAME: TFIBStringField
      FieldName = 'NAME'
      Size = 30
    end
    object dtCountryCAPITAL: TFIBStringField
      FieldName = 'CAPITAL'
      Size = 30
    end
    object dtCountryCONTINENT: TFIBStringField
      FieldName = 'CONTINENT'
      Size = 30
    end
    object dtCountryAREA: TFIBFloatField
      FieldName = 'AREA'
      DisplayFormat = '###,###,###,##0.00'
      EditFormat = '0.##'
    end
    object dtCountryPOPULATION: TFIBFloatField
      FieldName = 'POPULATION'
      DisplayFormat = '###,###,###,##0.00'
      EditFormat = '0.##'
    end
  end
  object dsCountry: TDataSource
    DataSet = dtCountry
    Left = 40
    Top = 200
  end
end
