inherited FilterAndIndexFrame: TFilterAndIndexFrame
  Width = 443
  Height = 270
  Align = alClient
  object DBGrid: TDBGrid
    Left = 139
    Top = 49
    Width = 304
    Height = 221
    Align = alClient
    DataSource = DataSource
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object Panel4: TPanel
    Left = 0
    Top = 0
    Width = 443
    Height = 49
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object ToolBar: TPanel
      Left = -8
      Top = 25
      Width = 628
      Height = 24
      BevelOuter = bvNone
      Color = 6369932
      TabOrder = 1
      object Panel5: TPanel
        Left = 369
        Top = 1
        Width = 149
        Height = 22
        BevelOuter = bvNone
        TabOrder = 2
        object cbCalcFields: TCheckBox
          Left = 5
          Top = 1
          Width = 142
          Height = 22
          Caption = 'Calculated/Lookup fields'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 0
          OnClick = cbCalcFieldsClick
        end
      end
      object Panel2: TPanel
        Left = 148
        Top = 1
        Width = 220
        Height = 22
        BevelOuter = bvNone
        TabOrder = 1
        object cbFilter: TCheckBox
          Left = 5
          Top = 1
          Width = 54
          Height = 21
          Caption = 'Filter'
          TabOrder = 0
          OnClick = cbFilterClick
        end
        object edFilter: TEdit
          Left = 70
          Top = 1
          Width = 144
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 1
          Text = 'DEPTNO = 10'
          OnExit = edFilterExit
        end
      end
      object Panel1: TPanel
        Left = 519
        Top = 1
        Width = 108
        Height = 22
        BevelOuter = bvNone
        TabOrder = 3
        object cbCacheCalcFields: TCheckBox
          Left = 6
          Top = 1
          Width = 103
          Height = 22
          Caption = 'CacheCalcFields'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 0
          OnClick = cbCacheCalcFieldsClick
        end
      end
      object Panle3: TPanel
        Left = 9
        Top = 1
        Width = 138
        Height = 22
        BevelOuter = bvNone
        TabOrder = 0
        object cbIndex: TCheckBox
          Left = 8
          Top = 1
          Width = 111
          Height = 20
          Caption = 'Index'
          TabOrder = 0
          OnClick = cbIndexClick
        end
      end
    end
    object Panel6: TPanel
      Left = 0
      Top = 0
      Width = 414
      Height = 25
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
      object DBNavigator1: TDBNavigator
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
  object Panel3: TPanel
    Left = 0
    Top = 49
    Width = 139
    Height = 221
    Align = alLeft
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object Panel8: TPanel
      Left = 0
      Top = 137
      Width = 139
      Height = 84
      Align = alBottom
      BevelOuter = bvNone
      Caption = 'Panel8'
      Color = 6369932
      TabOrder = 0
      object Panel7: TPanel
        Left = 1
        Top = 1
        Width = 137
        Height = 82
        BevelOuter = bvNone
        TabOrder = 0
        object Label1: TLabel
          Left = 6
          Top = 3
          Width = 93
          Height = 13
          Caption = 'IndexFieldNames ='
        end
        object lbIndexFieldNames: TLabel
          Left = 6
          Top = 22
          Width = 126
          Height = 54
          AutoSize = False
          WordWrap = True
        end
      end
    end
    object lbFields: TListBox
      Left = 0
      Top = 0
      Width = 139
      Height = 137
      Align = alClient
      ItemHeight = 13
      MultiSelect = True
      TabOrder = 1
      OnClick = lbFieldsClick
    end
  end
  object Query: TIBCQuery
    SQL.Strings = (
      'SELECT * FROM Emp')
    Debug = True
    LockMode = lmLockImmediate
    RefreshOptions = [roAfterInsert, roAfterUpdate]
    Left = 272
    Top = 55
  end
  object DataSource: TDataSource
    DataSet = Query
    Left = 304
    Top = 55
  end
  object Query2: TIBCQuery
    SQL.Strings = (
      'SELECT * FROM Emp')
    Debug = True
    OnCalcFields = Query2CalcFields
    Left = 272
    Top = 88
    object Query2CALCULATED: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'CALCULATED'
      Calculated = True
    end
    object Query2LOOKUP: TStringField
      FieldKind = fkLookup
      FieldName = 'LOOKUP'
      LookupDataSet = LookupQuery
      LookupKeyFields = 'DEPTNO'
      LookupResultField = 'DNAME'
      KeyFields = 'DEPTNO'
      Lookup = True
    end
    object Query2EMPNO: TIntegerField
      FieldName = 'EMPNO'
      Required = True
    end
    object Query2ENAME: TStringField
      FieldName = 'ENAME'
      Size = 10
    end
    object Query2JOB: TStringField
      FieldName = 'JOB'
      Size = 9
    end
    object Query2MGR: TIntegerField
      FieldName = 'MGR'
    end
    object Query2HIREDATE: TDateTimeField
      FieldName = 'HIREDATE'
    end
    object Query2SAL: TIntegerField
      FieldName = 'SAL'
    end
    object Query2COMM: TIntegerField
      FieldName = 'COMM'
    end
    object Query2DEPTNO: TIntegerField
      FieldName = 'DEPTNO'
    end
  end
  object LookupQuery: TIBCQuery
    SQL.Strings = (
      'SELECT * FROM Dept')
    Left = 304
    Top = 88
    object LookupQueryDEPTNO: TIntegerField
      FieldName = 'DEPTNO'
      Required = True
    end
    object LookupQueryDNAME: TStringField
      FieldName = 'DNAME'
      Size = 14
    end
    object LookupQueryLOC: TStringField
      FieldName = 'LOC'
      Size = 13
    end
  end
end
