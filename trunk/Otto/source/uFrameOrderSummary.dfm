inherited FrameOrderSummary: TFrameOrderSummary
  Left = 234
  Top = 165
  Width = 896
  Height = 495
  PixelsPerInch = 96
  TextHeight = 13
  inherited dckTop: TTBXDock
    Width = 888
    Height = 23
    inherited tlBarTop: TTBXToolbar
      object btn2: TTBXItem
        Action = actSetStateDraft
      end
      object btn1: TTBXItem
        Action = actSetStateApproved
      end
      object btn3: TTBXItem
        Action = actStore
      end
    end
  end
  inherited sb: TTBXStatusBar
    Top = 439
    Width = 888
  end
  object pnlTopOnFinal: TJvPanel [2]
    Left = 0
    Top = 23
    Width = 888
    Height = 131
    HotTrackFont.Charset = DEFAULT_CHARSET
    HotTrackFont.Color = clWindowText
    HotTrackFont.Height = -11
    HotTrackFont.Name = 'MS Sans Serif'
    HotTrackFont.Style = []
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object pnlClientOnFinal: TJvPanel
      Left = 0
      Top = 0
      Width = 376
      Height = 131
      HotTrackFont.Charset = DEFAULT_CHARSET
      HotTrackFont.Color = clWindowText
      HotTrackFont.Height = -11
      HotTrackFont.Name = 'MS Sans Serif'
      HotTrackFont.Style = []
      Align = alClient
      BorderWidth = 4
      TabOrder = 0
      object grBoxClientOfFinal: TJvGroupBox
        Left = 5
        Top = 5
        Width = 366
        Height = 121
        Align = alClient
        Caption = #1050#1083#1080#1077#1085#1090
        TabOrder = 0
        DesignSize = (
          366
          121)
        object lblClientFIO: TLabel
          Left = 8
          Top = 16
          Width = 41
          Height = 13
          AutoSize = False
          Caption = #1060#1048#1054':'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
        end
        object lbl5: TLabel
          Left = 8
          Top = 80
          Width = 57
          Height = 13
          AutoSize = False
          Caption = #1040#1076#1088#1077#1089':'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblPhonesOnFinal: TLabel
          Left = 8
          Top = 32
          Width = 56
          Height = 13
          Caption = #1058#1077#1083#1077#1092#1086#1085#1099':'
        end
        object lbl6: TLabel
          Left = 8
          Top = 48
          Width = 57
          Height = 13
          AutoSize = False
          Caption = 'GSM:'
        end
        object lbl7: TLabel
          Left = 8
          Top = 64
          Width = 57
          Height = 13
          AutoSize = False
          Caption = 'E-mail:'
        end
        object lbl8: TLabel
          Left = 8
          Top = 96
          Width = 57
          Height = 13
          AutoSize = False
          Caption = #1054#1089#1090#1072#1090#1086#1082':'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object txtClientFioOnFinal: TStaticText
          Left = 72
          Top = 16
          Width = 289
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
        object txtAdressOnFinal: TStaticText
          Left = 72
          Top = 80
          Width = 289
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
        end
        object txtClientPhoneOnFinal: TStaticText
          Left = 72
          Top = 32
          Width = 289
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
        object txtClientGsmOnFinal: TStaticText
          Left = 72
          Top = 48
          Width = 289
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
        end
        object txtClientEmailOnFinal: TStaticText
          Left = 72
          Top = 64
          Width = 289
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
        end
        object txtAccountRest: TStaticText
          Left = 72
          Top = 96
          Width = 289
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
        end
      end
    end
    object pnlOrderOnFinal: TJvPanel
      Left = 376
      Top = 0
      Width = 512
      Height = 131
      HotTrackFont.Charset = DEFAULT_CHARSET
      HotTrackFont.Color = clWindowText
      HotTrackFont.Height = -11
      HotTrackFont.Name = 'MS Sans Serif'
      HotTrackFont.Style = []
      Align = alRight
      BorderWidth = 4
      Caption = 'pnlOrderOnFinal'
      TabOrder = 1
      object grBoxSummaryOrder: TJvGroupBox
        Left = 5
        Top = 5
        Width = 502
        Height = 121
        Align = alClient
        Caption = #1047#1072#1103#1074#1082#1072
        TabOrder = 0
        DesignSize = (
          502
          121)
        object lblOrderCode: TLabel
          Left = 8
          Top = 16
          Width = 89
          Height = 13
          AutoSize = False
          Caption = #1053#1086#1084#1077#1088' '#1079#1072#1103#1074#1082#1080':'
        end
        object chkUseRest: TJvCheckBox
          Left = 8
          Top = 96
          Width = 183
          Height = 17
          Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1086#1089#1090#1072#1090#1086#1082' '#1085#1072' '#1089#1095#1077#1090#1077
          TabOrder = 2
          LinkedControls = <>
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'MS Sans Serif'
          HotTrackFont.Style = []
        end
        object txtOrderCode: TStaticText
          Left = 88
          Top = 16
          Width = 289
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
        object mmoNote: TMemo
          Left = 224
          Top = 15
          Width = 276
          Height = 104
          Align = alRight
          ScrollBars = ssBoth
          TabOrder = 0
        end
      end
    end
  end
  object grBoxSummaryOrderItems: TJvGroupBox [3]
    Left = 0
    Top = 154
    Width = 888
    Height = 285
    Align = alClient
    Caption = 'grBoxSummaryOrderItems'
    TabOrder = 2
    object grdOrderFullSpecification: TDBGridEh
      Left = 2
      Top = 15
      Width = 884
      Height = 268
      Align = alClient
      AutoFitColWidths = True
      DataGrouping.GroupLevels = <>
      DataSource = dsOrderFullSpecifications
      Flat = True
      FooterColor = clWindow
      FooterFont.Charset = DEFAULT_CHARSET
      FooterFont.Color = clWindowText
      FooterFont.Height = -11
      FooterFont.Name = 'MS Sans Serif'
      FooterFont.Style = []
      FooterRowCount = 1
      ReadOnly = True
      RowDetailPanel.Color = clBtnFace
      SumList.Active = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      Columns = <
        item
          EditButtons = <>
          FieldName = 'ORDER_ID'
          Footers = <>
          Title.Alignment = taCenter
          Visible = False
        end
        item
          EditButtons = <>
          FieldName = 'ORD'
          Footers = <>
          Title.Alignment = taCenter
          Visible = False
        end
        item
          EditButtons = <>
          FieldName = 'SUBJECT_ID'
          Footers = <>
          Title.Alignment = taCenter
          Visible = False
        end
        item
          EditButtons = <>
          FieldName = 'SUBJECT_NAME'
          Footer.Alignment = taRightJustify
          Footer.Value = #1048#1090#1086#1075#1086':'
          Footer.ValueType = fvtStaticText
          Footers = <>
          Title.Alignment = taCenter
          Title.Caption = #1040#1088#1090#1080#1082#1091#1083', '#1057#1073#1086#1088
          Width = 200
        end
        item
          EditButtons = <>
          FieldName = 'DIMENSION'
          Footers = <>
          Title.Alignment = taCenter
          Title.Caption = #1056#1072#1079#1084#1077#1088
        end
        item
          EditButtons = <>
          FieldName = 'WEIGHT'
          Footer.Alignment = taRightJustify
          Footer.DisplayFormat = '## ##0 '#1075
          Footer.FieldName = 'WEIGHT'
          Footer.ValueType = fvtSum
          Footers = <>
          Title.Alignment = taCenter
          Title.Caption = #1042#1077#1089', '#1075
        end
        item
          EditButtons = <>
          FieldName = 'PRICE_EUR'
          Footers = <>
          Title.Alignment = taCenter
          Title.Caption = #1062#1077#1085#1072', EUR'
        end
        item
          EditButtons = <>
          FieldName = 'AMOUNT'
          Footer.DisplayFormat = '0 '#1096#1090
          Footer.FieldName = 'COUNT_WEIGHT'
          Footer.ValueType = fvtSum
          Footers = <>
          Title.Alignment = taCenter
          Title.Caption = #1050#1086#1083'-'#1074#1086
        end
        item
          EditButtons = <>
          FieldName = 'COST_EUR'
          Footer.DisplayFormat = '##0.## EUR'
          Footer.FieldName = 'COST_EUR'
          Footer.ValueType = fvtSum
          Footers = <>
          Title.Alignment = taCenter
          Title.Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100
        end
        item
          EditButtons = <>
          FieldName = 'NAME_RUS'
          Footer.Alignment = taRightJustify
          Footer.DisplayFormat = '### ### ##0 BYR'
          Footer.FieldName = 'COST_BYR'
          Footer.ValueType = fvtSum
          Footers = <>
          Title.Alignment = taCenter
          Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
          Width = 150
        end
        item
          EditButtons = <>
          FieldName = 'KIND_RUS'
          Footer.Alignment = taRightJustify
          Footers = <>
          Title.Alignment = taCenter
          Title.Caption = #1055#1088#1080#1079#1085#1072#1082#1080
          Width = 150
        end
        item
          EditButtons = <>
          FieldName = 'STATUS_NAME'
          Footers = <>
          Title.Alignment = taCenter
          Title.Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077
          Width = 100
        end
        item
          EditButtons = <>
          FieldName = 'STATE_NAME'
          Footers = <>
          Title.Alignment = taCenter
          Title.Caption = #1044#1086#1087'.'#1089#1086#1089#1090#1086#1103#1085#1080#1077
          Width = 120
        end
        item
          EditButtons = <>
          FieldName = 'COUNT_WEIGHT'
          Footers = <>
          Title.Alignment = taCenter
          Visible = False
        end
        item
          EditButtons = <>
          FieldName = 'COST_BYR'
          Footers = <>
          Title.Alignment = taCenter
          Visible = False
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
  end
  inherited actList: TActionList
    Top = 184
    object actSetStateDraft: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1080#1090#1100' '#1082#1072#1082' '#1063#1077#1088#1085#1086#1074#1080#1082
      OnExecute = actSetStateDraftExecute
    end
    object actSetStateApproved: TAction
      Caption = #1055#1088#1080#1089#1074#1086#1080#1090#1100' '#1085#1086#1084#1077#1088' '#1079#1072#1103#1074#1082#1077
      OnExecute = actSetStateApprovedExecute
    end
    object actStore: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      OnExecute = actStoreExecute
      OnUpdate = actStoreUpdate
    end
  end
  object qryOrderFullSpecification: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    ORDER_ID,'
      '    ORD,'
      '    SUBJECT_ID,'
      '    SUBJECT_NAME,'
      '    DIMENSION,'
      '    WEIGHT,'
      '    PRICE_EUR,'
      '    AMOUNT,'
      '    COST_EUR,'
      '    NAME_RUS,'
      '    KIND_RUS,'
      '    STATE_NAME,'
      '    STATUS_NAME,'
      '    COUNT_WEIGHT,'
      '    COST_BYR'
      'FROM'
      '    V_ORDER_FULL_SPECIFICATION '
      'WHERE ORDER_ID = :ORDER_ID'
      'ORDER BY ORD, SUBJECT_ID')
    Transaction = trnWrite
    Database = dmOtto.dbOtto
    Left = 160
    Top = 72
  end
  object dsOrderFullSpecifications: TDataSource
    AutoEdit = False
    DataSet = qryOrderFullSpecification
    Left = 200
    Top = 72
  end
end
