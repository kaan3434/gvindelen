object frmFishFact: TfrmFishFact
  Left = 192
  Top = 107
  ActiveControl = DBGrid1
  BorderStyle = bsDialog
  Caption = 'Fish Fact'
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
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 4
    Top = 4
    Width = 302
    Height = 217
    Caption = 'Panel1'
    TabOrder = 0
    object DBLabel1: TDBText
      Left = 4
      Top = 183
      Width = 292
      Height = 24
      Alignment = taCenter
      DataField = 'NAME_COMMON'
      DataSource = dsFishfact
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clRed
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object DBImage1: TDBImage
      Left = 5
      Top = 8
      Width = 292
      Height = 168
      Hint = 'Scroll grid below to see other fish'
      DataField = 'GRAPHIC'
      DataSource = dsFishfact
      ReadOnly = True
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 310
    Top = 4
    Width = 223
    Height = 22
    TabOrder = 1
    object Label1: TLabel
      Left = 7
      Top = 4
      Width = 56
      Height = 13
      Caption = 'About the'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object DBLabel2: TDBText
      Left = 67
      Top = 4
      Width = 56
      Height = 13
      AutoSize = True
      DataField = 'NAME_COMMON'
      DataSource = dsFishfact
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object Panel3: TPanel
    Left = 311
    Top = 28
    Width = 223
    Height = 193
    BevelOuter = bvLowered
    TabOrder = 2
    object DBMemo1: TDBMemo
      Left = 1
      Top = 1
      Width = 221
      Height = 191
      Align = alClient
      BorderStyle = bsNone
      Color = clSilver
      Ctl3D = False
      DataField = 'NOTES'
      DataSource = dsFishfact
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 224
    Width = 536
    Height = 124
    Align = alBottom
    BevelInner = bvRaised
    BorderStyle = bsSingle
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    object DBGrid1: TDBGrid
      Left = 7
      Top = 8
      Width = 437
      Height = 104
      Hint = 'Scroll up/down to see other fish!'
      DataSource = dsFishfact
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clBlack
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'CATEGORY'
          Title.Caption = 'Category'
          Width = 93
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NAME_SPECIES'
          Title.Caption = 'Name Species'
          Width = 167
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'LENGTH_CM'
          Title.Caption = 'Lenght (cm)'
          Width = 72
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'LENGTH_IN'
          Title.Caption = 'Length (In)'
          Width = 67
          Visible = True
        end>
    end
    object BitBtn1: TBitBtn
      Left = 451
      Top = 88
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
  end
  object dtFishfact: TpFIBDataSet
    Database = dmMain.dbDemo
    Transaction = dmMain.trRead
    Options = [poStartTransaction, poAutoFormatFields]
    UpdateTransaction = dmMain.trWrite
    AutoCommit = True
    BufferChunks = 32
    CachedUpdates = False
    UniDirectional = False
    UpdateRecordTypes = [cusUnmodified, cusModified, cusInserted]
    UpdateSQL.Strings = (
      'UPDATE BIOLIFE SET '
      '    CATEGORY = :CATEGORY,'
      '    NAME_COMMON = :NAME_COMMON,'
      '    NAME_SPECIES = :NAME_SPECIES,'
      '    LENGTH_CM = :LENGTH_CM,'
      '    LENGTH_IN = :LENGTH_IN,'
      '    NOTES = :NOTES,'
      '    GRAPHIC = :GRAPHIC'
      ' WHERE     '
      '            ID = :OLD_ID'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM BIOLIFE'
      'WHERE     '
      '            ID = :OLD_ID'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO BIOLIFE('
      '    ID,'
      '    CATEGORY,'
      '    NAME_COMMON,'
      '    NAME_SPECIES,'
      '    LENGTH_CM,'
      '    LENGTH_IN,'
      '    NOTES,'
      '    GRAPHIC'
      ')'
      'VALUES('
      '    :ID,'
      '    :CATEGORY,'
      '    :NAME_COMMON,'
      '    :NAME_SPECIES,'
      '    :LENGTH_CM,'
      '    :LENGTH_IN,'
      '    :NOTES,'
      '    :GRAPHIC'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    BIO.ID,'
      '    BIO.CATEGORY,'
      '    BIO.NAME_COMMON,'
      '    BIO.NAME_SPECIES,'
      '    BIO.LENGTH_CM,'
      '    BIO.LENGTH_IN,'
      '    BIO.NOTES,'
      '    BIO.GRAPHIC'
      'FROM'
      '    BIOLIFE BIO'
      ' WHERE '
      '    (    '
      '            BIO.ID = :OLD_ID'
      '    )')
    SelectSQL.Strings = (
      'SELECT'
      '    BIO.ID,'
      '    BIO.CATEGORY,'
      '    BIO.NAME_COMMON,'
      '    BIO.NAME_SPECIES,'
      '    BIO.LENGTH_CM,'
      '    BIO.LENGTH_IN,'
      '    BIO.NOTES,'
      '    BIO.GRAPHIC'
      'FROM'
      '    BIOLIFE BIO')
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    AutoUpdateOptions.UpdateTableName = 'BIOLIFE'
    AutoUpdateOptions.KeyFields = 'ID'
    AutoUpdateOptions.GeneratorName = 'GEN_BIOLIFE_ID'
    AutoUpdateOptions.WhenGetGenID = wgBeforePost
    Left = 408
    Top = 68
    poImportDefaultValues = False
    poGetOrderInfo = False
    object dtFishfactID: TFIBIntegerField
      FieldName = 'ID'
    end
    object dtFishfactCATEGORY: TFIBStringField
      FieldName = 'CATEGORY'
      Size = 15
    end
    object dtFishfactNAME_COMMON: TFIBStringField
      FieldName = 'NAME_COMMON'
      Size = 30
    end
    object dtFishfactNAME_SPECIES: TFIBStringField
      FieldName = 'NAME_SPECIES'
      Size = 30
    end
    object dtFishfactLENGTH_CM: TFIBIntegerField
      FieldName = 'LENGTH_CM'
    end
    object dtFishfactLENGTH_IN: TFIBFloatField
      FieldName = 'LENGTH_IN'
      DisplayFormat = '###,###,###,##0.00'
    end
    object dtFishfactNOTES: TMemoField
      FieldName = 'NOTES'
      BlobType = ftMemo
      Size = 8
    end
    object dtFishfactGRAPHIC: TBlobField
      FieldName = 'GRAPHIC'
      BlobType = ftBlob
      Size = 8
    end
  end
  object dsFishfact: TDataSource
    DataSet = dtFishfact
    Left = 408
    Top = 116
  end
end
