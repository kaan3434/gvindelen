inherited FrameOrder: TFrameOrder
  object grBoxOrder: TJvGroupBox [1]
    Left = 0
    Top = 0
    Width = 435
    Height = 266
    Align = alClient
    Caption = #1061#1072#1088#1072#1082#1090#1077#1088#1080#1089#1090#1080#1082#1080' '#1079#1072#1103#1074#1082#1080
    TabOrder = 1
    object lblOrderProduct: TLabel
      Left = 8
      Top = 48
      Width = 89
      Height = 19
      AutoSize = False
      Caption = #1042#1080#1076' '#1087#1088#1086#1076#1091#1082#1090#1072
      Layout = tlCenter
    end
    object lbl3: TLabel
      Left = 8
      Top = 72
      Width = 89
      Height = 19
      AutoSize = False
      Caption = #1058#1072#1088#1080#1092#1085#1099#1081' '#1055#1083#1072#1085
      Layout = tlCenter
    end
    object lblExchEUR: TLabel
      Left = 8
      Top = 120
      Width = 89
      Height = 19
      AutoSize = False
      Caption = #1050#1091#1088#1089' EUR'
      FocusControl = edtBYR2EUR
      Layout = tlCenter
    end
    object lbl4: TLabel
      Left = 8
      Top = 176
      Width = 89
      Height = 19
      AutoSize = False
      Caption = #1042#1077#1089' '#1087#1086#1089#1099#1083#1082#1080
      FocusControl = edtOrderWeight
      Layout = tlCenter
      Visible = False
    end
    object lcbProduct: TDBLookupComboboxEh
      Left = 104
      Top = 48
      Width = 241
      Height = 21
      EditButtons = <>
      KeyField = 'PRODUCT_ID'
      ListField = 'PRODUCT_NAME'
      ListSource = dsProducts
      TabOrder = 0
      Visible = True
    end
    object lcbTaxPlan: TDBLookupComboboxEh
      Left = 104
      Top = 72
      Width = 242
      Height = 21
      EditButtons = <>
      KeyField = 'TAXPLAN_ID'
      ListField = 'TAXPLAN_NAME'
      ListSource = dsTaxPlans
      TabOrder = 1
      Visible = True
    end
    object edtBYR2EUR: TJvValidateEdit
      Left = 104
      Top = 120
      Width = 121
      Height = 21
      CriticalPoints.MaxValueIncluded = False
      CriticalPoints.MinValueIncluded = False
      DisplaySuffix = ' BYR'
      ParentColor = True
      ReadOnly = True
      TabOrder = 2
    end
    object edtOrderWeight: TJvValidateEdit
      Left = 104
      Top = 176
      Width = 121
      Height = 21
      Color = clBtnFace
      CriticalPoints.MaxValueIncluded = False
      CriticalPoints.MinValueIncluded = False
      DisplayFormat = dfDecimal
      DisplaySuffix = ' '#1082#1075
      EditText = '0'
      ReadOnly = True
      TabOrder = 3
      Visible = False
    end
  end
  object qryTaxPlans: TpFIBDataSet
    SelectSQL.Strings = (
      'select p.taxplan_id,'
      '       p.taxplan_name,'
      '       s.status_id,'
      '       s.status_sign'
      'from taxplans p'
      '  inner join statuses s on (s.status_id = p.status_id)'
      
        '  inner join flags2statuses f2s on (f2s.status_id = p.status_id ' +
        'and f2s.flag_sign = '#39'ACTIVE'#39')'
      
        '  inner join product2taxplan p2tp on (p2tp.taxplan_id = p.taxpla' +
        'n_id)'
      'where p2tp.product_id = :product_id'
      'order by s.status_id')
    Database = dmOtto.dbOtto
    DataSource = dsProducts
    Left = 40
    Top = 344
  end
  object dsTaxPlans: TDataSource
    AutoEdit = False
    DataSet = qryTaxPlans
    Left = 96
    Top = 344
  end
  object qryProducts: TpFIBDataSet
    SelectSQL.Strings = (
      'select p.product_id, '
      '       p.product_name, '
      '       p.product_code,'
      '       s.status_sign'
      'from products p'
      'inner join statuses s on (s.status_id = p.status_id)'
      
        'inner join flags2statuses f2s on (f2s.status_id = p.status_id an' +
        'd f2s.flag_sign = '#39'ACTIVE'#39')'
      'order by s.status_id')
    Database = dmOtto.dbOtto
    Left = 40
    Top = 296
  end
  object dsProducts: TDataSource
    AutoEdit = False
    DataSet = qryProducts
    Left = 96
    Top = 296
  end
end
