inherited FrameOrder: TFrameOrder
  Left = 253
  Top = 114
  Width = 699
  Height = 423
  PixelsPerInch = 96
  TextHeight = 13
  object split1: TJvNetscapeSplitter [0]
    Left = 361
    Top = 26
    Height = 341
    Align = alLeft
    Maximized = False
    Minimized = False
    ButtonCursor = crDefault
  end
  inherited dckTop: TTBXDock
    Width = 691
  end
  inherited sb: TTBXStatusBar
    Top = 367
    Width = 691
  end
  object grBoxOrder: TJvGroupBox [3]
    Left = 0
    Top = 26
    Width = 361
    Height = 341
    Align = alLeft
    Caption = 'grBoxOrder'
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
  object grBox1: TJvGroupBox [4]
    Left = 371
    Top = 26
    Width = 320
    Height = 341
    Align = alClient
    Caption = #1048#1089#1090#1086#1088#1080#1103' '#1076#1074#1080#1078#1077#1085#1080#1103' '#1079#1072#1103#1074#1082#1080
    TabOrder = 2
    object grd1: TDBGridEh
      Left = 2
      Top = 15
      Width = 316
      Height = 324
      Align = alClient
      AutoFitColWidths = True
      DataGrouping.GroupLevels = <>
      DataSource = dsOrderDates
      Flat = True
      FooterColor = clWindow
      FooterFont.Charset = DEFAULT_CHARSET
      FooterFont.Color = clWindowText
      FooterFont.Height = -11
      FooterFont.Name = 'MS Sans Serif'
      FooterFont.Style = []
      RowDetailPanel.Color = clBtnFace
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      Columns = <
        item
          EditButtons = <>
          FieldName = 'ATTR_NAME'
          Footers = <>
          Title.Alignment = taCenter
          Title.Caption = #1044#1077#1081#1089#1090#1074#1080#1077
          Width = 200
        end
        item
          Alignment = taCenter
          AutoFitColWidth = False
          EditButtons = <>
          FieldName = 'EVENT_DTM'
          Footers = <>
          Title.Alignment = taCenter
          Title.Caption = #1044#1072#1090#1072
          Width = 100
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
  end
  object qryTaxPlans: TpFIBDataSet
    SelectSQL.Strings = (
      'select p.taxplan_id,'
      '       p.taxplan_name,'
      '       s.status_id,'
      '       s.status_sign'
      'from taxplans p'
      'inner join statuses s on (s.status_id = p.status_id)'
      
        'inner join flags2statuses f2s on (f2s.status_id = p.status_id an' +
        'd f2s.flag_sign = '#39'ACTIVE'#39')'
      'order by s.status_id')
    Transaction = trnWrite
    Database = dmOtto.dbOtto
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
    Transaction = trnWrite
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
  object qryOrderDates: TpFIBDataSet
    SelectSQL.Strings = (
      
        'select a.attr_name, cast(oa.o_param_value as timestamp) event_dt' +
        'm'
      'from Object_Read('#39'ORDER'#39', 1) oa'
      
        'inner join attrs a on (a.object_sign = '#39'ORDER'#39' and a.attr_sign =' +
        ' oa.o_param_name)'
      'where replace(o_param_name, '#39'_'#39', '#39'-'#39') like '#39'%-DTM'#39
      'order by event_dtm')
    Transaction = trnWrite
    Database = dmOtto.dbOtto
    Left = 424
    Top = 248
  end
  object dsOrderDates: TDataSource
    AutoEdit = False
    DataSet = qryOrderDates
    Left = 480
    Top = 248
  end
end
