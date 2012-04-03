object frmMasterDetail: TfrmMasterDetail
  Left = 184
  Top = 80
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Master-Detail'
  ClientHeight = 348
  ClientWidth = 536
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label5: TLabel
    Left = 4
    Top = 124
    Width = 77
    Height = 13
    Caption = 'Reopen count 0'
  end
  object Label6: TLabel
    Left = 4
    Top = 232
    Width = 77
    Height = 13
    Caption = 'Reopen count 0'
  end
  object Label1: TLabel
    Left = 4
    Top = 5
    Width = 74
    Height = 13
    Caption = 'Master DataSet'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 4
    Top = 109
    Width = 69
    Height = 13
    Caption = 'Detail DataSet'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 4
    Top = 218
    Width = 88
    Height = 13
    Caption = 'SubDetail DataSet'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
  end
  object DBGrid1: TDBGrid
    Left = 4
    Top = 34
    Width = 365
    Height = 70
    DataSource = dsMaster
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgConfirmDelete, dgCancelOnExit]
    TabOrder = 1
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
        Width = 173
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'COUNT_DETAIL'
        ReadOnly = True
        Title.Caption = 'CountDetailRecordsOnServer'
        Width = 147
        Visible = True
      end>
  end
  object DBNavigator1: TDBNavigator
    Left = 126
    Top = 5
    Width = 240
    Height = 25
    DataSource = dsMaster
    Flat = True
    TabOrder = 0
  end
  object GroupBox1: TGroupBox
    Left = 372
    Top = 5
    Width = 161
    Height = 312
    Caption = ' DetailConditions '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 6
    object Bevel5: TBevel
      Left = 4
      Top = 158
      Width = 153
      Height = 151
      Shape = bsFrame
    end
    object Bevel4: TBevel
      Left = 4
      Top = 74
      Width = 153
      Height = 83
      Shape = bsFrame
    end
    object Bevel1: TBevel
      Left = 4
      Top = 18
      Width = 153
      Height = 55
      Shape = bsFrame
    end
    object Label4: TLabel
      Left = 8
      Top = 285
      Width = 59
      Height = 13
      Caption = 'Scroll count:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 8
      Top = 183
      Width = 111
      Height = 13
      Caption = 'WaitEndMasterInterval:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object CheckBox1: TCheckBox
      Tag = 1
      Left = 8
      Top = 21
      Width = 89
      Height = 17
      Caption = 'dcForceOpen'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 0
      OnClick = CheckBox1Click
    end
    object CheckBox2: TCheckBox
      Tag = 2
      Left = 8
      Top = 77
      Width = 129
      Height = 17
      Caption = 'dcForceMasterRefresh'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 1
      OnClick = CheckBox1Click
    end
    object CheckBox3: TCheckBox
      Tag = 3
      Left = 8
      Top = 162
      Width = 133
      Height = 17
      Caption = 'dcWaitEndMasterScroll'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 2
      OnClick = CheckBox1Click
    end
    object ComboBox1: TComboBox
      Left = 8
      Top = 199
      Width = 57
      Height = 21
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      TabOrder = 3
      OnChange = ComboBox1Change
      Items.Strings = (
        '300 ms'
        '1000 ms'
        '5000 ms')
    end
    object SpinEdit1: TSpinEdit
      Left = 72
      Top = 281
      Width = 57
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      MaxValue = 0
      MinValue = 0
      ParentFont = False
      TabOrder = 4
      Value = 10
    end
    object btnReopen: TButton
      Left = 8
      Top = 40
      Width = 90
      Height = 25
      Caption = 'Reopen Master'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      OnClick = btnReopenClick
    end
    object btnInsert: TButton
      Left = 8
      Top = 96
      Width = 90
      Height = 25
      Caption = 'Insert [Detail]'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      OnClick = btnInsertClick
    end
    object btnDelete: TButton
      Left = 8
      Top = 124
      Width = 90
      Height = 25
      Caption = 'Delete [Detail]'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      OnClick = btnDeleteClick
    end
    object btnScrollMaster: TButton
      Left = 8
      Top = 225
      Width = 90
      Height = 25
      Caption = 'Do Scroll Master'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
      OnClick = btnScrollMasterClick
    end
    object btnScrollDetail: TButton
      Left = 8
      Top = 253
      Width = 90
      Height = 25
      Caption = 'Do Scroll Detail'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 9
      OnClick = btnScrollMasterClick
    end
  end
  object DBNavigator2: TDBNavigator
    Left = 126
    Top = 109
    Width = 240
    Height = 25
    DataSource = dsDetail
    Flat = True
    TabOrder = 2
  end
  object DBGrid2: TDBGrid
    Left = 4
    Top = 139
    Width = 365
    Height = 70
    DataSource = dsDetail
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgConfirmDelete, dgCancelOnExit]
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
        Width = 145
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'COUNT_SUB_DETAIL'
        Title.Caption = 'CountSubDetailRecordsOnServer'
        Width = 165
        Visible = True
      end>
  end
  object DBNavigator3: TDBNavigator
    Left = 126
    Top = 217
    Width = 240
    Height = 25
    DataSource = dsSubDetail
    Flat = True
    TabOrder = 4
  end
  object DBGrid3: TDBGrid
    Left = 4
    Top = 247
    Width = 365
    Height = 70
    DataSource = dsSubDetail
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgConfirmDelete, dgCancelOnExit]
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
        Width = 205
        Visible = True
      end>
  end
  object btnClose: TBitBtn
    Left = 456
    Top = 320
    Width = 75
    Height = 25
    Caption = 'Close'
    ModalResult = 1
    TabOrder = 7
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
  object dtMaster: TpFIBDataSet
    Database = dmMain.dbDemo
    Transaction = dmMain.trRead
    Options = [poRefreshAfterPost, poStartTransaction]
    UpdateTransaction = dmMain.trWrite
    AutoCommit = True
    BufferChunks = 32
    CachedUpdates = False
    UniDirectional = False
    UpdateRecordTypes = [cusUnmodified, cusModified, cusInserted]
    UpdateSQL.Strings = (
      'UPDATE MASTER M'
      'SET '
      '    M.NAME = :NAME'
      'WHERE M.ID = :OLD_ID'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM MASTER M WHERE M.ID = :OLD_ID'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO MASTER ('
      '    ID,'
      '    NAME'
      ')'
      'VALUES('
      '    :ID,'
      '    :NAME'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '  M.ID,'
      '  M.NAME,'
      '  M.COUNT_DETAIL'
      'FROM MASTER M'
      'WHERE M.ID = :OLD_ID')
    SelectSQL.Strings = (
      'SELECT'
      '  M.ID,'
      '  M.NAME,'
      '  M.COUNT_DETAIL'
      'FROM MASTER M'
      'ORDER BY M.NAME')
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    AutoUpdateOptions.UpdateTableName = 'MASTER'
    AutoUpdateOptions.KeyFields = 'ID'
    AutoUpdateOptions.GeneratorName = 'GEN_MASTER_ID'
    AutoUpdateOptions.WhenGetGenID = wgBeforePost
    Left = 60
    Top = 56
    poImportDefaultValues = False
    poGetOrderInfo = False
  end
  object dtDetail: TpFIBDataSet
    Database = dmMain.dbDemo
    Transaction = dmMain.trRead
    Options = [poRefreshAfterPost, poStartTransaction]
    UpdateTransaction = dmMain.trWrite
    AutoCommit = True
    BufferChunks = 32
    CachedUpdates = False
    UniDirectional = False
    UpdateRecordTypes = [cusUnmodified, cusModified, cusInserted]
    UpdateSQL.Strings = (
      'UPDATE DETAIL D '
      'SET '
      '    D.NAME = :NAME'
      'WHERE D.ID = :OLD_ID'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM DETAIL D WHERE D.ID = :OLD_ID'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO DETAIL ('
      '    ID,'
      '    MASTER_ID,'
      '    NAME'
      ')'
      'VALUES('
      '    :ID,'
      '    :MAS_ID,'
      '    :NAME'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '  D.ID,'
      '  D.MASTER_ID,'
      '  D.NAME,'
      '  D.COUNT_SUB_DETAIL'
      'FROM DETAIL D'
      'WHERE D.ID = :OLD_ID')
    SelectSQL.Strings = (
      'SELECT'
      '  D.ID,'
      '  D.MASTER_ID,'
      '  D.NAME,'
      '  D.COUNT_SUB_DETAIL'
      'FROM DETAIL D'
      'WHERE D.MASTER_ID = :ID')
    DataSource = dsMaster
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    AutoUpdateOptions.UpdateTableName = 'DETAIL'
    AutoUpdateOptions.KeyFields = 'ID'
    AutoUpdateOptions.GeneratorName = 'GEN_DETAIL_ID'
    AutoUpdateOptions.WhenGetGenID = wgBeforePost
    Left = 80
    Top = 160
    poImportDefaultValues = False
    poGetOrderInfo = False
    WaitEndMasterScroll = True
    dcForceMasterRefresh = True
    dcForceOpen = True
  end
  object dsMaster: TDataSource
    DataSet = dtMaster
    Left = 108
    Top = 60
  end
  object dsDetail: TDataSource
    DataSet = dtDetail
    Left = 124
    Top = 160
  end
  object dtSubDetail: TpFIBDataSet
    Database = dmMain.dbDemo
    Transaction = dmMain.trRead
    Options = [poStartTransaction]
    UpdateTransaction = dmMain.trWrite
    AutoCommit = True
    BufferChunks = 32
    CachedUpdates = False
    UniDirectional = False
    UpdateRecordTypes = [cusUnmodified, cusModified, cusInserted]
    UpdateSQL.Strings = (
      'UPDATE SUB_DETAIL  SD'
      'SET '
      '    SD.NAME = :NAME'
      'WHERE SD.ID = :OLD_ID'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM SUB_DETAIL SD WHERE SD.ID = :OLD_ID'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO SUB_DETAIL('
      '    ID,'
      '    DETAIL_ID,'
      '    NAME'
      ')'
      'VALUES('
      '    :ID,'
      '    :MAS_ID,'
      '    :NAME'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '  SD.ID,'
      '  SD.DETAIL_ID,'
      '  SD.NAME'
      'FROM SUB_DETAIL SD'
      'WHERE SD.ID = :OLD_ID')
    SelectSQL.Strings = (
      'SELECT'
      '  SD.ID,'
      '  SD.DETAIL_ID,'
      '  SD.NAME'
      'FROM SUB_DETAIL SD'
      'WHERE SD.DETAIL_ID = :ID')
    DataSource = dsDetail
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    AutoUpdateOptions.UpdateTableName = 'SUB_DETAIL'
    AutoUpdateOptions.KeyFields = 'ID'
    AutoUpdateOptions.GeneratorName = 'GEN_SUB_DETAIL_ID'
    AutoUpdateOptions.WhenGetGenID = wgBeforePost
    Left = 100
    Top = 268
    poImportDefaultValues = False
    poGetOrderInfo = False
    WaitEndMasterScroll = True
    dcForceMasterRefresh = True
    dcForceOpen = True
  end
  object dsSubDetail: TDataSource
    DataSet = dtSubDetail
    Left = 168
    Top = 276
  end
end
