inherited TextBlobFrame: TTextBlobFrame
  Width = 723
  Height = 388
  Align = alClient
  object Splitter1: TSplitter
    Left = 0
    Top = 211
    Width = 723
    Height = 2
    Cursor = crVSplit
    Align = alTop
  end
  object DBGrid: TDBGrid
    Left = 0
    Top = 51
    Width = 723
    Height = 160
    Align = alTop
    DataSource = DataSource
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object meComments: TDBMemo
    Left = 0
    Top = 277
    Width = 723
    Height = 111
    Align = alClient
    DataField = 'VAL'
    DataSource = DataSource
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 723
    Height = 51
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object Panel2: TPanel
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
    object Panel3: TPanel
      Left = 0
      Top = 26
      Width = 304
      Height = 25
      BevelOuter = bvNone
      Color = 6369932
      TabOrder = 1
      object btCopyRecord: TSpeedButton
        Left = 1
        Top = 0
        Width = 100
        Height = 24
        Caption = 'CopyRecord'
        Flat = True
        Transparent = False
        OnClick = btCopyRecordClick
      end
      object btCopyRecord1: TSpeedButton
        Left = 102
        Top = 0
        Width = 100
        Height = 24
        Caption = 'CopyRecord Alt'
        Flat = True
        Transparent = False
        OnClick = btCopyRecord1Click
      end
      object btCopyRecord2: TSpeedButton
        Left = 203
        Top = 0
        Width = 100
        Height = 24
        Caption = 'CopyRecord More'
        Flat = True
        Transparent = False
        OnClick = btCopyRecord2Click
      end
    end
  end
  object ToolBar1: TPanel
    Left = 0
    Top = 213
    Width = 723
    Height = 64
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object Label1: TLabel
      Left = 4
      Top = 31
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
      Top = 47
      Width = 56
      Height = 13
      Caption = 'lbBlobProps'
      Visible = False
    end
    object Panel4: TPanel
      Left = 0
      Top = 0
      Width = 604
      Height = 26
      BevelOuter = bvNone
      Color = 6369932
      TabOrder = 0
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
      object btLoad: TSpeedButton
        Left = 1
        Top = 1
        Width = 85
        Height = 24
        Caption = 'Load from file'
        Flat = True
        Transparent = False
        OnClick = btLoad1Click
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
      object Panel5: TPanel
        Left = 259
        Top = 1
        Width = 344
        Height = 24
        BevelOuter = bvNone
        TabOrder = 0
        object cbCacheBlobs: TCheckBox
          Left = 257
          Top = 5
          Width = 80
          Height = 17
          Caption = 'Cache Blobs'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 0
          OnClick = cbCacheBlobsClick
        end
        object cbDefBlobRead: TCheckBox
          Left = 24
          Top = 5
          Width = 120
          Height = 17
          Caption = 'Deferred BLOB Read'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 1
          OnClick = cbDefBlobReadClick
        end
        object cbStreamedBlobs: TCheckBox
          Left = 153
          Top = 5
          Width = 97
          Height = 17
          Caption = 'Streamed Blobs'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 2
          OnClick = cbStreamedBlobsClick
        end
      end
    end
  end
  object OpenDialog: TOpenDialog
    InitialDir = '.'
    Title = 'Open'
    Left = 132
    Top = 163
  end
  object SaveDialog: TSaveDialog
    InitialDir = '.'
    Title = 'Save As'
    Left = 172
    Top = 163
  end
  object IBCQuery: TIBCQuery
    SQL.Strings = (
      'SELECT * FROM IBDAC_BLOB_TEXT')
    AutoCommit = True
    AfterClose = IBCQueryAfterClose
    AfterPost = IBCQueryAfterScroll
    AfterScroll = IBCQueryAfterScroll
    Left = 133
    Top = 90
  end
  object quInsertRecord: TIBCQuery
    SQL.Strings = (
      'INSERT INTO IBDAC_BLOB_TEXT'
      '  (CODE, TITLE, VAL)'
      'VALUES'
      '  (:CODE, :TITLE, :VAL)')
    AutoCommit = True
    Left = 203
    Top = 90
    ParamData = <
      item
        DataType = ftInteger
        Name = 'CODE'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'TITLE'
        ParamType = ptInput
      end
      item
        DataType = ftBlob
        Name = 'VAL'
      end>
  end
  object quCopyRecord: TIBCQuery
    SQL.Strings = (
      'INSERT INTO IBDAC_BLOB_TEXT (Code, Title, Val)'
      'SELECT &CodeNew, Title, Val FROM IBDAC_BLOB_TEXT '
      '  WHERE Code = :Code;')
    AutoCommit = True
    Left = 233
    Top = 90
    ParamData = <
      item
        DataType = ftInteger
        Name = 'Code'
      end>
    MacroData = <
      item
        Name = 'CodeNew'
      end>
  end
  object DataSource: TDataSource
    DataSet = IBCQuery
    Left = 133
    Top = 120
  end
  object spSelectRecord: TIBCStoredProc
    Left = 175
    Top = 90
  end
end
