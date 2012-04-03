object frmStartingWith: TfrmStartingWith
  Left = 170
  Top = 248
  ActiveControl = edtSearch
  BorderStyle = bsDialog
  Caption = 'STARTING WITH vs LOCATE()'
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
  object Label2: TLabel
    Left = 292
    Top = 32
    Width = 152
    Height = 13
    Caption = '[Field: '#39'Name'#39' | Timeout: 500 ms]'
  end
  object RadioButton1: TRadioButton
    Left = 4
    Top = 2
    Width = 113
    Height = 21
    Caption = 'SearchOnServer'
    Checked = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 0
    TabStop = True
    OnClick = RadioButton1Click
  end
  object RadioButton2: TRadioButton
    Tag = 1
    Left = 121
    Top = 2
    Width = 113
    Height = 21
    Caption = 'SearchOnClient'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 1
    OnClick = RadioButton1Click
  end
  object edtSearch: TEdit
    Left = 2
    Top = 28
    Width = 100
    Height = 21
    TabOrder = 2
    OnChange = edtSearchChange
    OnKeyDown = edtSearchKeyDown
  end
  object DBGrid1: TDBGrid
    Left = 1
    Top = 56
    Width = 532
    Height = 261
    DataSource = dsName
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 5
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
        Width = 489
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
    TabOrder = 6
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
  object btnContaining: TButton
    Left = 108
    Top = 26
    Width = 75
    Height = 25
    Caption = 'Containing'
    TabOrder = 3
    OnClick = btnContainingClick
  end
  object btnCancelContaining: TButton
    Left = 188
    Top = 26
    Width = 100
    Height = 25
    Caption = 'Cancel Containing'
    TabOrder = 4
    OnClick = btnCancelContainingClick
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 500
    Top = 65535
  end
  object dtName: TpFIBDataSet
    Database = dmMain.dbDemo
    Transaction = dmMain.trRead
    Options = [poStartTransaction]
    UpdateTransaction = dmMain.trWrite
    BufferChunks = 32
    CachedUpdates = False
    UniDirectional = False
    UpdateRecordTypes = [cusUnmodified, cusModified, cusInserted]
    UpdateSQL.Strings = (
      'UPDATE DEMOS_CACHE D'
      'SET '
      '    D.NAME = :NAME'
      'WHERE     '
      '    D.ID = :OLD_ID'
      '    ')
    DeleteSQL.Strings = (
      'DELETE '
      'FROM '
      '  DEMOS_CACHE D'
      'WHERE     '
      '  D.ID = :OLD_ID'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO DEMOS_CACHE('
      '    ID,'
      '    NAME'
      ')'
      'VALUES('
      '    :ID,'
      '    :NAME'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    D.ID,'
      '    D.NAME'
      'FROM'
      '    DEMOS_CACHE D'
      'WHERE '
      '    D.ID = :OLD_ID')
    SelectSQL.Strings = (
      'SELECT'
      '    D.ID,'
      '    D.NAME'
      'FROM'
      '    DEMOS_CACHE D'
      'ORDER BY D.NAME')
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    AutoUpdateOptions.UpdateTableName = 'DEMOS_CACHE'
    AutoUpdateOptions.KeyFields = 'ID'
    AutoUpdateOptions.GeneratorName = 'GEN_DEMOS_CACHE_ID'
    AutoUpdateOptions.WhenGetGenID = wgBeforePost
    Left = 83
    Top = 98
    poImportDefaultValues = False
    poGetOrderInfo = False
  end
  object dsName: TDataSource
    DataSet = dtName
    Left = 80
    Top = 145
  end
end
