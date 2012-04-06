inherited CachedUpdatesFrame: TCachedUpdatesFrame
  Width = 443
  Height = 277
  Align = alClient
  object DBGrid: TDBGrid
    Left = 0
    Top = 102
    Width = 443
    Height = 175
    Align = alClient
    DataSource = DataSource
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgCancelOnExit]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDrawDataCell = DBGridDrawDataCell
  end
  object ToolBar: TPanel
    Left = 0
    Top = 0
    Width = 443
    Height = 102
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Panel8: TPanel
      Left = 0
      Top = 0
      Width = 612
      Height = 102
      BevelOuter = bvNone
      Color = 6369932
      TabOrder = 0
      object RefreshRecord: TSpeedButton
        Left = 408
        Top = 1
        Width = 82
        Height = 22
        Caption = 'RefreshRecord'
        Flat = True
        Transparent = False
        OnClick = RefreshRecordClick
      end
      object btClose: TSpeedButton
        Left = 84
        Top = 1
        Width = 82
        Height = 22
        Caption = 'Close'
        Flat = True
        Transparent = False
        OnClick = btCloseClick
      end
      object btOpen: TSpeedButton
        Left = 1
        Top = 1
        Width = 82
        Height = 22
        Caption = 'Open'
        Flat = True
        Transparent = False
        OnClick = btOpenClick
      end
      object DBNavigator: TDBNavigator
        Left = 167
        Top = 1
        Width = 240
        Height = 22
        DataSource = DataSource
        Flat = True
        TabOrder = 0
      end
      object Panel10: TPanel
        Left = 1
        Top = 24
        Width = 212
        Height = 22
        BevelOuter = bvNone
        TabOrder = 1
        object cbCachedUpdates: TCheckBox
          Left = 4
          Top = 5
          Width = 97
          Height = 12
          Caption = 'CachedUpdates'
          TabOrder = 0
          OnClick = cbCachedUpdatesClick
        end
        object cbCustomUpdate: TCheckBox
          Left = 107
          Top = 5
          Width = 97
          Height = 14
          Caption = 'Custom Update'
          TabOrder = 1
          OnClick = cbCustomUpdateClick
        end
      end
      object Panel6: TPanel
        Left = 214
        Top = 24
        Width = 397
        Height = 22
        BevelOuter = bvNone
        TabOrder = 2
        object Label1: TLabel
          Left = 6
          Top = 4
          Width = 64
          Height = 13
          Caption = 'RecordTypes'
        end
        object cbDeleted: TCheckBox
          Left = 326
          Top = 4
          Width = 70
          Height = 17
          Caption = 'Deleted'
          TabOrder = 3
          OnClick = cbDeletedClick
        end
        object cbInserted: TCheckBox
          Left = 249
          Top = 4
          Width = 71
          Height = 17
          Caption = 'Inserted'
          TabOrder = 2
          OnClick = cbInsertedClick
        end
        object cbModified: TCheckBox
          Left = 168
          Top = 3
          Width = 75
          Height = 17
          Caption = 'Modified'
          TabOrder = 1
          OnClick = cbModifiedClick
        end
        object cbUnmodified: TCheckBox
          Left = 87
          Top = 3
          Width = 79
          Height = 17
          Caption = 'Unmodified'
          TabOrder = 0
          OnClick = cbUnmodifiedClick
        end
      end
      object Panel1: TPanel
        Left = 1
        Top = 47
        Width = 345
        Height = 54
        BevelOuter = bvNone
        TabOrder = 3
        object Label2: TLabel
          Left = 5
          Top = 5
          Width = 48
          Height = 13
          Caption = 'Updates'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Panel3: TPanel
          Left = 5
          Top = 23
          Width = 333
          Height = 24
          BevelOuter = bvNone
          Color = 6369932
          TabOrder = 0
          object btApply: TSpeedButton
            Left = 1
            Top = 1
            Width = 82
            Height = 22
            Caption = 'Apply'
            Flat = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            Transparent = False
            OnClick = btApplyClick
          end
          object btCommit: TSpeedButton
            Left = 84
            Top = 1
            Width = 82
            Height = 22
            Caption = 'Commit'
            Flat = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            Transparent = False
            OnClick = btCommitClick
          end
          object btCancel: TSpeedButton
            Left = 167
            Top = 1
            Width = 82
            Height = 22
            Caption = 'Cancel'
            Flat = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            Transparent = False
            OnClick = btCancelClick
          end
          object btRevertRecord: TSpeedButton
            Left = 250
            Top = 1
            Width = 82
            Height = 22
            Caption = 'Revert'
            Flat = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            Transparent = False
            OnClick = btRevertRecordClick
          end
        end
      end
      object Panel4: TPanel
        Left = 347
        Top = 47
        Width = 264
        Height = 54
        BevelOuter = bvNone
        TabOrder = 4
        object Label3: TLabel
          Left = 5
          Top = 5
          Width = 74
          Height = 13
          Caption = 'Transactions'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Panel5: TPanel
          Left = 5
          Top = 23
          Width = 250
          Height = 24
          BevelOuter = bvNone
          Color = 6369932
          TabOrder = 0
          object btStartTrans: TSpeedButton
            Left = 1
            Top = 1
            Width = 82
            Height = 22
            Caption = 'Start'
            Flat = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            Transparent = False
            OnClick = btStartTransClick
          end
          object btCommitTrans: TSpeedButton
            Left = 84
            Top = 1
            Width = 82
            Height = 22
            Caption = 'Commit'
            Flat = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            Transparent = False
            OnClick = btCommitTransClick
          end
          object btRollBackTrans: TSpeedButton
            Left = 167
            Top = 1
            Width = 82
            Height = 22
            Caption = 'Rollback'
            Flat = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            Transparent = False
            OnClick = btRollbackTransClick
          end
        end
      end
      object Panel2: TPanel
        Left = 491
        Top = 1
        Width = 120
        Height = 22
        BevelOuter = bvNone
        TabOrder = 5
        object cbAutoCommit: TCheckBox
          Left = 10
          Top = 3
          Width = 81
          Height = 17
          Caption = 'AutoCommit'
          TabOrder = 0
          OnClick = cbAutoCommitClick
        end
      end
    end
  end
  object DataSource: TDataSource
    DataSet = IBCQuery
    OnStateChange = DataSourceStateChange
    OnDataChange = DataSourceDataChange
    Left = 168
    Top = 152
  end
  object IBCQuery: TIBCQuery
    UpdateTransaction = UpdTransaction
    SQL.Strings = (
      'SELECT * FROM Dept')
    CachedUpdates = True
    AutoCommit = True
    OnUpdateError = IBCQueryUpdateError
    OnCalcFields = IBCQueryCalcFields
    Left = 168
    Top = 120
    object IBCQueryDEPTNO: TIntegerField
      FieldName = 'DEPTNO'
      Required = True
    end
    object IBCQueryDNAME: TStringField
      FieldName = 'DNAME'
      Size = 14
    end
    object IBCQueryLOC: TStringField
      FieldName = 'LOC'
      Size = 13
    end
    object IBCQueryStatus: TStringField
      FieldKind = fkCalculated
      FieldName = 'Status'
      Size = 10
      Calculated = True
    end
  end
  object UpdTransaction: TIBCTransaction
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    Left = 136
    Top = 120
  end
end
