object frmLocalSorting: TfrmLocalSorting
  Left = 196
  Top = 188
  ActiveControl = dbgCountry
  BorderStyle = bsDialog
  Caption = 'Local Sorting'
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
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 4
    Top = 3
    Width = 33
    Height = 13
    Caption = 'Sorting'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 44
    Top = 4
    Width = 363
    Height = 13
    Caption = 
      'Click on title of a column to add it in order queue or to change' +
      ' order of sorting'
  end
  object dbgCountry: TDBGrid
    Left = 0
    Top = 52
    Width = 536
    Height = 265
    DataSource = dsCountry
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDblClick = btnDeleteFieldFromSortClick
    OnTitleClick = dbgCountryTitleClick
    Columns = <
      item
        Expanded = False
        FieldName = 'NAME'
        Width = 90
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CAPITAL'
        Width = 83
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CONTINENT'
        Width = 90
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'AREA'
        Width = 82
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'POPULATION'
        Width = 82
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'COMPUTED_FIELD'
        Width = 61
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
    TabOrder = 2
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
  object btnDeleteFieldFromSort: TButton
    Left = 0
    Top = 20
    Width = 245
    Height = 25
    Caption = 'Delete column from Sorting (DblClick on DBGrid)'
    TabOrder = 0
    OnClick = btnDeleteFieldFromSortClick
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
    OnCalcFields = dtCountryCalcFields
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
    object dtCountryCOMPUTED_FIELD: TFloatField
      FieldKind = fkCalculated
      FieldName = 'COMPUTED_FIELD'
      DisplayFormat = '###,###,###,##0.00'
      Calculated = True
    end
  end
  object dsCountry: TDataSource
    DataSet = dtCountry
    Left = 40
    Top = 200
  end
end
