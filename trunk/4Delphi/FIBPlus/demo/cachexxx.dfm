object frmCachexxx: TfrmCachexxx
  Left = 192
  Top = 107
  BorderStyle = bsDialog
  Caption = 'Cache***()'
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
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 536
    Height = 316
    ActivePage = TabSheet3
    Align = alTop
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Common'
      object Label1: TLabel
        Left = 4
        Top = 5
        Width = 76
        Height = 13
        Caption = 'Source DataSet'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
      end
      object Label2: TLabel
        Left = 4
        Top = 148
        Width = 73
        Height = 13
        Caption = 'Target DataSet'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
      end
      object Label7: TLabel
        Left = 482
        Top = 136
        Width = 41
        Height = 11
        Caption = 'Source ID'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'MS Serif'
        Font.Style = []
        ParentFont = False
      end
      object DBGrid1: TDBGrid
        Left = 4
        Top = 21
        Width = 320
        Height = 120
        DataSource = dsSource1
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = RUSSIAN_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'ID'
            Width = 40
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'NAME'
            Width = 235
            Visible = True
          end>
      end
      object DBGrid2: TDBGrid
        Left = 4
        Top = 164
        Width = 320
        Height = 120
        DataSource = dsTarget1
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        ReadOnly = True
        TabOrder = 1
        TitleFont.Charset = RUSSIAN_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'ID'
            Width = 40
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'NAME'
            Width = 235
            Visible = True
          end>
      end
      object btnOpen: TButton
        Left = 380
        Top = 101
        Width = 100
        Height = 25
        Caption = 'CacheOpen'
        TabOrder = 2
        OnClick = btnOpenClick
      end
      object btnInsert: TButton
        Left = 380
        Top = 147
        Width = 100
        Height = 25
        Caption = 'CacheInsert ->'
        Enabled = False
        TabOrder = 3
        OnClick = btnInsertClick
      end
      object btnEdit: TButton
        Left = 380
        Top = 175
        Width = 100
        Height = 25
        Caption = 'CacheEdit'
        Enabled = False
        TabOrder = 5
        OnClick = btnEditClick
      end
      object btnDelete: TButton
        Left = 380
        Top = 231
        Width = 100
        Height = 25
        Caption = 'CacheDelete'
        Enabled = False
        TabOrder = 7
        OnClick = btnDeleteClick
      end
      object btnRefresh: TButton
        Left = 380
        Top = 203
        Width = 100
        Height = 25
        Caption = 'CacheRefresh'
        Enabled = False
        TabOrder = 6
        OnClick = btnRefreshClick
      end
      object btnCloseOpen: TButton
        Left = 380
        Top = 259
        Width = 100
        Height = 25
        Caption = 'Close/CacheOpen'
        Enabled = False
        TabOrder = 8
        OnClick = btnCloseOpenClick
      end
      object SpinEdit1: TSpinEdit
        Left = 484
        Top = 149
        Width = 41
        Height = 22
        MaxValue = 30
        MinValue = 1
        TabOrder = 4
        Value = 1
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Dialog'
      ImageIndex = 1
      object Label3: TLabel
        Left = 4
        Top = 5
        Width = 76
        Height = 13
        Caption = 'Source DataSet'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
      end
      object Label4: TLabel
        Left = 4
        Top = 148
        Width = 73
        Height = 13
        Caption = 'Target DataSet'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
      end
      object DBGrid3: TDBGrid
        Left = 4
        Top = 21
        Width = 320
        Height = 120
        DataSource = dsSource2
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = RUSSIAN_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'ID'
            Width = 40
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'NAME'
            Width = 235
            Visible = True
          end>
      end
      object DBGrid4: TDBGrid
        Left = 4
        Top = 164
        Width = 320
        Height = 120
        DataSource = dsTarget2
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        ReadOnly = True
        TabOrder = 1
        TitleFont.Charset = RUSSIAN_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'ID'
            Width = 40
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'NAME'
            Width = 235
            Visible = True
          end>
      end
      object btnDialog: TButton
        Left = 380
        Top = 101
        Width = 100
        Height = 25
        Caption = 'Dialog'
        TabOrder = 2
        OnClick = btnDialogClick
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Clone DataSet'
      ImageIndex = 3
      object Label5: TLabel
        Left = 4
        Top = 5
        Width = 76
        Height = 13
        Caption = 'Source DataSet'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
      end
      object Label6: TLabel
        Left = 4
        Top = 148
        Width = 73
        Height = 13
        Caption = 'Target DataSet'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
      end
      object DBGrid5: TDBGrid
        Left = 4
        Top = 21
        Width = 320
        Height = 120
        DataSource = dsSource3
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = RUSSIAN_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'ID'
            Width = 40
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'NAME'
            Width = 235
            Visible = True
          end>
      end
      object DBGrid6: TDBGrid
        Left = 4
        Top = 164
        Width = 320
        Height = 120
        DataSource = dsTarget3
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        ReadOnly = True
        TabOrder = 1
        TitleFont.Charset = RUSSIAN_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'ID'
            Width = 40
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'NAME'
            Width = 235
            Visible = True
          end>
      end
      object btnClone: TButton
        Left = 380
        Top = 101
        Width = 100
        Height = 25
        Caption = 'Open as Clone'
        TabOrder = 2
        OnClick = btnCloneClick
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Local Functions'
      ImageIndex = 3
      object Label8: TLabel
        Left = 4
        Top = 5
        Width = 76
        Height = 13
        Caption = 'Source DataSet'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
      end
      object Label9: TLabel
        Left = 4
        Top = 148
        Width = 73
        Height = 13
        Caption = 'Target DataSet'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
      end
      object DBGrid7: TDBGrid
        Left = 4
        Top = 21
        Width = 320
        Height = 120
        DataSource = dsSource4
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = RUSSIAN_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'CAPITAL'
            Width = 59
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CONTINENT'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'AREA'
            Width = 124
            Visible = True
          end>
      end
      object DBGrid8: TDBGrid
        Left = 4
        Top = 164
        Width = 320
        Height = 120
        DataSource = dsTarget4
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        ReadOnly = True
        TabOrder = 1
        TitleFont.Charset = RUSSIAN_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'CONTINENT'
            Width = 88
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'SUM_'
            Width = 96
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'AVG_'
            Width = 96
            Visible = True
          end>
      end
      object Button1: TButton
        Left = 380
        Top = 101
        Width = 141
        Height = 25
        Caption = 'Sum(Area) South America'
        TabOrder = 2
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 380
        Top = 129
        Width = 141
        Height = 25
        Caption = 'Avg(Area) South America'
        TabOrder = 3
        OnClick = Button2Click
      end
      object Button3: TButton
        Left = 380
        Top = 157
        Width = 141
        Height = 25
        Caption = 'Sum(Area) North America'
        TabOrder = 4
        OnClick = Button3Click
      end
      object Button4: TButton
        Left = 380
        Top = 185
        Width = 141
        Height = 25
        Caption = 'Avg(Area) North America'
        TabOrder = 5
        OnClick = Button4Click
      end
      object Button5: TButton
        Left = 380
        Top = 213
        Width = 141
        Height = 25
        Caption = 'Clear SUM_ && AVG_'
        TabOrder = 6
        OnClick = Button5Click
      end
    end
  end
  object btnClose: TBitBtn
    Left = 456
    Top = 320
    Width = 75
    Height = 25
    Caption = 'Close'
    ModalResult = 1
    TabOrder = 1
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
  object dtSource1: TpFIBDataSet
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
    Top = 66
    poImportDefaultValues = False
    poGetOrderInfo = False
  end
  object dsSource1: TDataSource
    DataSet = dtSource1
    Left = 80
    Top = 113
  end
  object dtTarget1: TpFIBDataSet
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
      '    DEMOS_CACHE D')
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    AutoUpdateOptions.UpdateTableName = 'DEMOS_CACHE'
    AutoUpdateOptions.KeyFields = 'ID'
    AutoUpdateOptions.GeneratorName = 'GEN_DEMOS_CACHE_ID'
    AutoUpdateOptions.WhenGetGenID = wgBeforePost
    Left = 52
    Top = 218
    poImportDefaultValues = False
    poGetOrderInfo = False
  end
  object dsTarget1: TDataSource
    DataSet = dtTarget1
    Left = 51
    Top = 271
  end
  object dtSource2: TpFIBDataSet
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
    Left = 138
    Top = 66
    poImportDefaultValues = False
    poGetOrderInfo = False
  end
  object dtTarget2: TpFIBDataSet
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
      '    DEMOS_CACHE D')
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    AutoUpdateOptions.UpdateTableName = 'DEMOS_CACHE'
    AutoUpdateOptions.KeyFields = 'ID'
    AutoUpdateOptions.GeneratorName = 'GEN_DEMOS_CACHE_ID'
    AutoUpdateOptions.WhenGetGenID = wgBeforePost
    Left = 113
    Top = 218
    poImportDefaultValues = False
    poGetOrderInfo = False
  end
  object dsSource2: TDataSource
    DataSet = dtSource2
    Left = 137
    Top = 111
  end
  object dsTarget2: TDataSource
    DataSet = dtTarget2
    Left = 112
    Top = 269
  end
  object dtSource3: TpFIBDataSet
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
    Left = 251
    Top = 65
    poImportDefaultValues = False
    poGetOrderInfo = False
  end
  object dtTarget3: TpFIBDataSet
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
      '    DEMOS_CACHE D')
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    AutoUpdateOptions.UpdateTableName = 'DEMOS_CACHE'
    AutoUpdateOptions.KeyFields = 'ID'
    AutoUpdateOptions.GeneratorName = 'GEN_DEMOS_CACHE_ID'
    AutoUpdateOptions.WhenGetGenID = wgBeforePost
    Left = 230
    Top = 219
    poImportDefaultValues = False
    poGetOrderInfo = False
  end
  object dsSource3: TDataSource
    DataSet = dtSource3
    Left = 252
    Top = 116
  end
  object dsTarget3: TDataSource
    DataSet = dtTarget3
    Left = 231
    Top = 274
  end
  object dtSource4: TpFIBDataSet
    Database = dmMain.dbDemo
    Transaction = dmMain.trRead
    Options = [poStartTransaction]
    UpdateTransaction = dmMain.trWrite
    BufferChunks = 32
    CachedUpdates = False
    UniDirectional = False
    UpdateRecordTypes = [cusUnmodified, cusModified, cusInserted]
    UpdateSQL.Strings = (
      '')
    RefreshSQL.Strings = (
      'SELECT'
      '    C.ID,'
      '    C.CAPITAL,'
      '    C.CONTINENT,'
      '    C.AREA,'
      '    C.POPULATION'
      'FROM'
      '    COUNTRY C'
      'WHERE '
      '    C.ID = :OLD_ID')
    SelectSQL.Strings = (
      'SELECT'
      '    C.ID,'
      '    C.CAPITAL,'
      '    C.CONTINENT,'
      '    C.AREA,'
      '    C.POPULATION'
      'FROM'
      '    COUNTRY C')
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    AutoUpdateOptions.UpdateTableName = 'DEMOS_CACHE'
    AutoUpdateOptions.KeyFields = 'ID'
    AutoUpdateOptions.GeneratorName = 'GEN_DEMOS_CACHE_ID'
    AutoUpdateOptions.WhenGetGenID = wgBeforePost
    Left = 323
    Top = 65
    poImportDefaultValues = False
    poGetOrderInfo = False
    object dtSource4ID: TFIBIntegerField
      FieldName = 'ID'
    end
    object dtSource4CAPITAL: TFIBStringField
      FieldName = 'CAPITAL'
      Size = 30
      EmptyStrToNull = True
    end
    object dtSource4CONTINENT: TFIBStringField
      FieldName = 'CONTINENT'
      Size = 30
      EmptyStrToNull = True
    end
    object dtSource4AREA: TFIBFloatField
      FieldName = 'AREA'
      DisplayFormat = '###,###,###,##0.00'
    end
    object dtSource4POPULATION: TFIBFloatField
      FieldName = 'POPULATION'
      DisplayFormat = '###,###,###,##0.00'
    end
  end
  object dsSource4: TDataSource
    DataSet = dtSource4
    Left = 324
    Top = 116
  end
  object dtTarget4: TpFIBDataSet
    Database = dmMain.dbDemo
    Transaction = dmMain.trRead
    Options = [poStartTransaction]
    UpdateTransaction = dmMain.trWrite
    BufferChunks = 32
    CachedUpdates = False
    UniDirectional = False
    UpdateRecordTypes = [cusUnmodified, cusModified, cusInserted]
    UpdateSQL.Strings = (
      '')
    SelectSQL.Strings = (
      'SELECT'
      '    CAST('#39' '#39' AS VARCHAR(30)) AS CONTINENT,'
      '    0 AS SUM_,'
      '    0 AS AVG_'
      'FROM '
      'RDB$DATABASE')
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    AutoUpdateOptions.UpdateTableName = 'DEMOS_CACHE'
    AutoUpdateOptions.KeyFields = 'ID'
    AutoUpdateOptions.GeneratorName = 'GEN_DEMOS_CACHE_ID'
    AutoUpdateOptions.WhenGetGenID = wgBeforePost
    Left = 330
    Top = 219
    poImportDefaultValues = False
    poGetOrderInfo = False
    object dtTarget4CONTINENT: TFIBStringField
      FieldName = 'CONTINENT'
      Size = 30
      EmptyStrToNull = True
    end
    object dtTarget4SUM_: TFIBIntegerField
      FieldName = 'SUM_'
      DisplayFormat = '###,###,###,##0.00'
    end
    object dtTarget4AVG_: TFIBIntegerField
      FieldName = 'AVG_'
      DisplayFormat = '###,###,###,##0.00'
    end
  end
  object dsTarget4: TDataSource
    DataSet = dtTarget4
    Left = 331
    Top = 270
  end
end
