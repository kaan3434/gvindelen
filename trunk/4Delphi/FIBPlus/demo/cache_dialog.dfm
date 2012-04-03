object frmCacheDialog: TfrmCacheDialog
  Left = 266
  Top = 160
  ActiveControl = Button1
  BorderStyle = bsDialog
  Caption = 'Dialog Form'
  ClientHeight = 313
  ClientWidth = 392
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 280
    Width = 392
    Height = 9
    Shape = bsTopLine
  end
  object btnOK: TButton
    Left = 230
    Top = 286
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object btnCancel: TButton
    Left = 314
    Top = 286
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object DBGrid5: TDBGrid
    Left = 0
    Top = 0
    Width = 170
    Height = 276
    DataSource = dsSource
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 2
    TitleFont.Charset = RUSSIAN_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDblClick = Button1Click
    Columns = <
      item
        Expanded = False
        FieldName = 'NAME'
        Title.Caption = 'NAME (Source)'
        Width = 135
        Visible = True
      end>
  end
  object Button1: TButton
    Left = 181
    Top = 88
    Width = 30
    Height = 25
    Caption = '>'
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 181
    Top = 116
    Width = 30
    Height = 25
    Caption = '<'
    TabOrder = 4
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 181
    Top = 155
    Width = 30
    Height = 25
    Caption = '>>'
    TabOrder = 5
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 181
    Top = 183
    Width = 30
    Height = 25
    Caption = '<<'
    TabOrder = 6
    OnClick = Button4Click
  end
  object DBGrid6: TDBGrid
    Left = 221
    Top = 0
    Width = 170
    Height = 276
    DataSource = dsTarget
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 7
    TitleFont.Charset = RUSSIAN_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDblClick = Button2Click
    Columns = <
      item
        Expanded = False
        FieldName = 'NAME'
        Title.Caption = 'NAME (Target)'
        Width = 135
        Visible = True
      end>
  end
  object dtSource: TpFIBDataSet
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
    Left = 53
    Top = 65
    poImportDefaultValues = False
    poGetOrderInfo = False
  end
  object dsSource: TDataSource
    DataSet = dtSource
    Left = 54
    Top = 112
  end
  object dtTarget: TpFIBDataSet
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
    Left = 249
    Top = 67
    poImportDefaultValues = False
    poGetOrderInfo = False
  end
  object dsTarget: TDataSource
    DataSet = dtTarget
    Left = 250
    Top = 114
  end
end
