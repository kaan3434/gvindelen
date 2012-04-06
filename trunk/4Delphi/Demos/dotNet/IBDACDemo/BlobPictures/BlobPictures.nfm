inherited BlobPicturesFrame: TBlobPicturesFrame
  Width = 789
  Height = 409
  Align = alClient
  object Splitter1: TSplitter
    Left = 0
    Top = 252
    Width = 789
    Height = 3
    Cursor = crVSplit
    Align = alTop
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 26
    Width = 789
    Height = 136
    Align = alTop
    DataSource = DataSource
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object DBImage: TDBImage
    Left = 0
    Top = 255
    Width = 789
    Height = 154
    Align = alClient
    DataField = 'PIC'
    DataSource = DataSource
    TabOrder = 1
  end
  object ToolBar: TPanel
    Left = 0
    Top = 0
    Width = 789
    Height = 26
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 414
      Height = 26
      BevelOuter = bvNone
      Color = 6369932
      TabOrder = 0
      object btClose: TSpeedButton
        Left = 87
        Top = 1
        Width = 85
        Height = 24
        Caption = 'Close'
        Flat = True
        Transparent = False
        OnClick = btCloseClick
      end
      object btOpen: TSpeedButton
        Left = 1
        Top = 1
        Width = 85
        Height = 24
        Caption = 'Open'
        Flat = True
        Transparent = False
        OnClick = btOpenClick
      end
      object DBNavigator: TDBNavigator
        Left = 173
        Top = 1
        Width = 240
        Height = 24
        DataSource = DataSource
        Flat = True
        TabOrder = 0
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 162
    Width = 789
    Height = 90
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object Label1: TLabel
      Left = 4
      Top = 56
      Width = 90
      Height = 13
      Caption = 'Blob properties:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbBlobProps: TLabel
      Left = 4
      Top = 72
      Width = 56
      Height = 13
      Caption = 'lbBlobProps'
      Visible = False
    end
    object Panel4: TPanel
      Left = 0
      Top = 0
      Width = 259
      Height = 25
      BevelOuter = bvNone
      Color = 6369932
      TabOrder = 0
      object btLoad: TSpeedButton
        Left = 1
        Top = 1
        Width = 85
        Height = 24
        Caption = 'Load from file'
        Flat = True
        Transparent = False
        OnClick = btLoadClick
      end
      object btSave: TSpeedButton
        Left = 87
        Top = 1
        Width = 85
        Height = 24
        Caption = 'Save to file'
        Flat = True
        Transparent = False
        OnClick = btSaveClick
      end
      object btClear: TSpeedButton
        Left = 173
        Top = 1
        Width = 85
        Height = 24
        Caption = 'Clear'
        Flat = True
        Transparent = False
        OnClick = btClearClick
      end
    end
    object Panel5: TPanel
      Left = 0
      Top = 25
      Width = 569
      Height = 26
      BevelOuter = bvNone
      Color = 6369932
      TabOrder = 1
      object btAddRecord: TSpeedButton
        Left = 1
        Top = 1
        Width = 85
        Height = 24
        Caption = 'Add Record'
        Flat = True
        Transparent = False
        OnClick = btAddRecordClick
      end
      object Panel3: TPanel
        Left = 87
        Top = 1
        Width = 481
        Height = 24
        BevelOuter = bvNone
        TabOrder = 0
        object cbCacheBlobs: TCheckBox
          Left = 8
          Top = 2
          Width = 81
          Height = 21
          Caption = 'Cache Blobs'
          TabOrder = 0
          OnClick = cbCacheBlobsClick
        end
        object cbStreamedBlobs: TCheckBox
          Left = 224
          Top = 2
          Width = 94
          Height = 21
          Caption = 'Streamed Blobs'
          TabOrder = 2
          OnClick = cbStreamedBlobsClick
        end
        object cbDefBlobRead: TCheckBox
          Left = 102
          Top = 2
          Width = 117
          Height = 21
          Caption = 'Deferred Blob Read'
          TabOrder = 1
          OnClick = cbDefBlobReadClick
        end
        object cbxCompression: TComboBox
          Left = 320
          Top = 2
          Width = 152
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 3
          OnChange = cbxCompressionChange
          Items.Strings = (
            'Without compression'
            'Compression on client side'
            'Compression on server side'
            'Compression on both sides')
        end
      end
    end
  end
  object IBCQuery: TIBCQuery
    SQLInsert.Strings = (
      'INSERT INTO IbDAC_BLOB'
      '  (ID, TITLE, PIC)'
      'VALUES'
      '  (:ID, :TITLE, :PIC)'
      '  ')
    SQLDelete.Strings = (
      'DELETE FROM IbDAC_BLOB'
      'WHERE'
      '  ID = :ID')
    SQLUpdate.Strings = (
      'UPDATE IbDAC_BLOB'
      'SET'
      '  ID = :ID,'
      '  TITLE = :TITLE,'
      '  PIC = :PIC'
      'WHERE'
      '  ID = :OLD_ID'
      '')
    SQLRefresh.Strings = (
      
        'SELECT IBDAC_BLOB.ID AS "_0", IBDAC_BLOB.TITLE AS "_1", IBDAC_BL' +
        'OB.PIC AS "_2" FROM IBDAC_BLOB'
      'WHERE IBDAC_BLOB.ID = :Old_1 ')
    SQL.Strings = (
      'SELECT * FROM IBDAC_BLOB')
    AutoCommit = True
    RefreshOptions = [roAfterInsert, roAfterUpdate]
    AfterClose = IBCQueryAfterClose
    AfterPost = IBCQueryAfterScroll
    AfterScroll = IBCQueryAfterScroll
    OnCalcFields = IBCQueryCalcFields
    Left = 250
    Top = 113
    object IBCQueryID: TIntegerField
      FieldName = 'ID'
      Required = True
    end
    object IBCQueryTITLE: TStringField
      FieldName = 'TITLE'
      Size = 30
    end
    object IBCQueryPIC: TBlobField
      FieldName = 'PIC'
    end
    object IBCQuerySize: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'Size'
      Calculated = True
    end
    object IBCQueryCompressedSize: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'CompressedSize'
      Calculated = True
    end
    object IBCQueryServerSize: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'ServerSize'
      Calculated = True
    end
  end
  object IBCStoredProc: TIBCStoredProc
    StoredProcName = 'IBDAC_BLOB_INSERT'
    Left = 212
    Top = 113
  end
  object DataSource: TDataSource
    DataSet = IBCQuery
    Left = 285
    Top = 113
  end
end
