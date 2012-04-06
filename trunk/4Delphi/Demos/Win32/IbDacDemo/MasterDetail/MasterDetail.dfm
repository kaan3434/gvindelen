inherited MasterDetailFrame: TMasterDetailFrame
  Width = 443
  Height = 277
  Align = alClient
  object Splitter1: TSplitter
    Left = 0
    Top = 141
    Width = 443
    Height = 1
    Cursor = crVSplit
    Align = alTop
  end
  object DBGrid: TDBGrid
    Left = 0
    Top = 25
    Width = 443
    Height = 116
    Align = alTop
    DataSource = dsMaster
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object ToolBar: TPanel
    Left = 0
    Top = 0
    Width = 443
    Height = 25
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 554
      Height = 24
      BevelOuter = bvNone
      Color = 6369932
      TabOrder = 0
      object btOpen: TSpeedButton
        Left = 1
        Top = 1
        Width = 85
        Height = 22
        Caption = 'Open'
        Flat = True
        Transparent = False
        OnClick = btOpenClick
      end
      object btClose: TSpeedButton
        Left = 87
        Top = 1
        Width = 85
        Height = 22
        Caption = 'Close'
        Flat = True
        Transparent = False
        OnClick = btCloseClick
      end
      object DBNavigator: TDBNavigator
        Left = 173
        Top = 1
        Width = 240
        Height = 22
        DataSource = dsMaster
        Flat = True
        TabOrder = 0
      end
      object Panel7: TPanel
        Left = 414
        Top = 1
        Width = 139
        Height = 22
        BevelOuter = bvNone
        TabOrder = 1
        object cbLocalMasterDetail: TCheckBox
          Left = 4
          Top = 3
          Width = 133
          Height = 17
          Caption = 'Use LocaMasterDetail'
          TabOrder = 0
          OnClick = cbLocalMasterDetailClick
        end
      end
    end
  end
  object ToolBar1: TPanel
    Left = 0
    Top = 142
    Width = 443
    Height = 26
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object Panel1: TPanel
      Left = 1
      Top = 1
      Width = 650
      Height = 24
      BevelOuter = bvNone
      Color = 6369932
      TabOrder = 0
      object DBNavigator1: TDBNavigator
        Left = 1
        Top = 1
        Width = 240
        Height = 22
        DataSource = dsDetail
        Flat = True
        TabOrder = 0
      end
      object Panel3: TPanel
        Left = 242
        Top = 1
        Width = 289
        Height = 22
        BevelOuter = bvNone
        TabOrder = 1
        object rbSQL: TRadioButton
          Left = 5
          Top = 3
          Width = 63
          Height = 17
          Caption = 'SQL link'
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = rbLinkTypeClick
        end
        object rbSimpleFields: TRadioButton
          Left = 72
          Top = 3
          Width = 97
          Height = 17
          Caption = 'Simple field link'
          TabOrder = 1
          OnClick = rbLinkTypeClick
        end
        object rbCalcFields: TRadioButton
          Left = 173
          Top = 3
          Width = 113
          Height = 17
          Caption = 'Calculated field link'
          TabOrder = 2
          OnClick = rbLinkTypeClick
        end
      end
      object Panel6: TPanel
        Left = 532
        Top = 1
        Width = 117
        Height = 22
        BevelOuter = bvNone
        TabOrder = 2
        object cbCacheCalcFields: TCheckBox
          Left = 5
          Top = 3
          Width = 108
          Height = 17
          Caption = 'CacheCalcFields'
          Enabled = False
          TabOrder = 0
          OnClick = cbCacheCalcFieldsClick
        end
      end
    end
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 168
    Width = 443
    Height = 109
    Align = alClient
    DataSource = dsDetail
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object dsDetail: TDataSource
    DataSet = quDetail
    Left = 408
    Top = 208
  end
  object dsMaster: TDataSource
    DataSet = quMaster
    Left = 408
    Top = 32
  end
  object quMaster: TIBCQuery
    SQL.Strings = (
      'SELECT * FROM Dept')
    Debug = True
    OnCalcFields = quCalcFields
    Left = 376
    Top = 32
    object quMasterDEPTNO: TIntegerField
      FieldName = 'DEPTNO'
      Required = True
    end
    object quMasterDNAME: TStringField
      FieldName = 'DNAME'
      Size = 14
    end
    object quMasterLOC: TStringField
      FieldName = 'LOC'
      Size = 13
    end
    object quMasterDEPTNO_CALCULATED: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'DEPTNO_CALCULATED'
      Calculated = True
    end
  end
  object quDetail: TIBCQuery
    SQL.Strings = (
      'SELECT * FROM Emp')
    MasterSource = dsMaster
    Debug = True
    OnCalcFields = quCalcFields
    Left = 376
    Top = 208
    object quDetailEMPNO: TIntegerField
      FieldName = 'EMPNO'
      Required = True
    end
    object quDetailENAME: TStringField
      FieldName = 'ENAME'
      Size = 10
    end
    object quDetailJOB: TStringField
      FieldName = 'JOB'
      Size = 9
    end
    object quDetailMGR: TIntegerField
      FieldName = 'MGR'
    end
    object quDetailHIREDATE: TDateTimeField
      FieldName = 'HIREDATE'
    end
    object quDetailSAL: TIntegerField
      FieldName = 'SAL'
    end
    object quDetailCOMM: TIntegerField
      FieldName = 'COMM'
    end
    object quDetailDEPTNO: TIntegerField
      FieldName = 'DEPTNO'
    end
    object quDetailDEPTNO_CALCULATED: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'DEPTNO_CALCULATED'
      Calculated = True
    end
  end
end
