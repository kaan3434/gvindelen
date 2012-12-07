inherited FormTableOrders: TFormTableOrders
  Left = 254
  Top = 141
  Caption = #1047#1072#1103#1074#1082#1080
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inherited dckTop: TTBXDock
    Height = 52
    inherited tlBarNsiActions: TTBXToolbar
      Top = 26
      FullSize = True
      Images = imgListMain
      TabOrder = 1
      object btnMakeInvoice: TTBXItem
        Action = actMakeInvoice
        DisplayMode = nbdmImageAndText
      end
      object btnAssignPayment: TTBXItem
        Action = actAssignPayment
        DisplayMode = nbdmImageAndText
      end
      object subSetStatuses: TTBXSubmenuItem
        Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1090#1072#1090#1091#1089
      end
      object btnDeleteOrder: TTBXItem
        Action = actDeleteOrder
        DisplayMode = nbdmImageAndText
      end
      object btnBalanceOrder: TTBXItem
        Action = actBalanceOrder
        DisplayMode = nbdmImageAndText
      end
      object btn1: TTBXItem
        Action = actSetServTax
      end
    end
    object barUserBar: TTBXToolbar
      Left = 0
      Top = 0
      Caption = 'barUserBar'
      FullSize = True
      Images = imgListMain
      TabOrder = 0
      object btnRest2Order: TTBXItem
        Action = actRest2Order
        DisplayMode = nbdmImageAndText
      end
    end
  end
  inherited pnlMain: TJvPanel
    Top = 52
    Height = 446
    inherited grBoxMain: TJvGroupBox
      Height = 436
      Caption = #1047#1072#1103#1074#1082#1080
      inherited grdMain: TDBGridEh
        Height = 419
        AllowedOperations = [alopDeleteEh]
        IndicatorTitle.ShowDropDownSign = True
        Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking, dghEnterAsTab, dghIncSearch, dghRowHighlight, dghDblClickOptimizeColWidth, dghColumnResize, dghHotTrack, dghExtendVertLines]
        ReadOnly = True
        RowDetailPanel.Active = True
        RowDetailPanel.Height = 200
        STFilter.InstantApply = True
        STFilter.Visible = True
        OnDblClick = grdMainDblClick
        OnFillSTFilterListValues = grdMainFillSTFilterListValues
        OnGetCellParams = grdMainGetCellParams
        OnRowDetailPanelHide = grdMainRowDetailPanelHide
        OnRowDetailPanelShow = grdMainRowDetailPanelShow
        Columns = <
          item
            EditButtons = <>
            FieldName = 'ORDER_ID'
            Footers = <>
            Title.Alignment = taCenter
            Title.TitleButton = True
            Visible = False
          end
          item
            EditButtons = <>
            FieldName = 'ORDER_CODE'
            Footer.ValueType = fvtCount
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = #1047#1072#1103#1074#1082#1072
            Title.TitleButton = True
          end
          item
            EditButtons = <>
            FieldName = 'CLIENT_ID'
            Footers = <>
            Title.Alignment = taCenter
            Title.TitleButton = True
            Visible = False
          end
          item
            EditButtons = <>
            FieldName = 'CLIENT_FIO'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = #1060#1072#1084#1080#1083#1080#1103' '#1048#1084#1103' '#1054#1090#1095#1077#1089#1090#1074#1086
            Title.TitleButton = True
            Width = 200
          end
          item
            EditButtons = <>
            FieldName = 'ADRESS_ID'
            Footers = <>
            Title.Alignment = taCenter
            Title.TitleButton = True
            Visible = False
          end
          item
            EditButtons = <>
            FieldName = 'CREATE_DTM'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = #1044#1072#1090#1072' '#1079#1072#1103#1074#1082#1080
            Title.TitleButton = True
          end
          item
            EditButtons = <>
            FieldName = 'STATUS_ID'
            Footers = <>
            Title.Alignment = taCenter
            Title.TitleButton = True
            Visible = False
          end
          item
            EditButtons = <>
            FieldName = 'STATUS_NAME'
            Footers = <>
            STFilter.DataField = 'STATUS_NAME'
            STFilter.KeyField = 'STATUS_NAME'
            STFilter.ListField = 'STATUS_NAME'
            Title.Alignment = taCenter
            Title.Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077
            Title.TitleButton = True
            Width = 100
          end
          item
            EditButtons = <>
            FieldName = 'STATUS_SIGN'
            Footers = <>
            Title.Alignment = taCenter
            Title.TitleButton = True
            Visible = False
            Width = 100
          end
          item
            EditButtons = <>
            FieldName = 'STATUS_DTM'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = #1054#1073#1085#1086#1074#1083#1077#1085
            Title.TitleButton = True
          end
          item
            DisplayFormat = '## ##0.## EUR'
            EditButtons = <>
            FieldName = 'COST_EUR'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100', EUR'
          end
          item
            DisplayFormat = '### ### ##0 BYR'
            EditButtons = <>
            FieldName = 'COST_BYR'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100', BYR'
          end
          item
            EditButtons = <>
            FieldName = 'BAR_CODE'
            Footers = <>
          end
          item
            EditButtons = <>
            FieldName = 'USER_SIGN'
            Footers = <>
            Title.Caption = #1054#1090#1089#1090#1072#1090#1086#1082', EUR'
          end
          item
            EditButtons = <>
            FieldName = 'SOURCE'
            Footers = <>
            Title.Caption = #1048#1089#1090#1086#1095#1085#1080#1082
          end
          item
            AutoFitColWidth = False
            Checkboxes = True
            EditButtons = <>
            FieldName = 'IS_INVOICED'
            Footers = <>
            Visible = False
            Width = 20
          end
          item
            AutoFitColWidth = False
            Checkboxes = True
            EditButtons = <>
            FieldName = 'IS_INVOICEPRINTED'
            Footers = <>
            Visible = False
            Width = 20
          end
          item
            EditButtons = <>
            FieldName = 'BYR2EUR'
            Footers = <>
          end
          item
            EditButtons = <>
            FieldName = 'REST_EUR'
            Footers = <>
          end
          item
            EditButtons = <>
            FieldName = 'PACKLIST_NO'
            Footers = <>
          end>
        inherited RowDetailData: TRowDetailPanelControlEh
          object pcDetailInfo: TPageControl
            Left = 0
            Top = 0
            Width = 959
            Height = 198
            ActivePage = tsOrderTaxs
            Align = alClient
            TabOrder = 0
            object tsOrderAttrs: TTabSheet
              Caption = #1040#1090#1088#1080#1073#1091#1090#1099' '#1079#1072#1103#1074#1082#1080
              object grdOrderProperties: TDBGridEh
                Left = 0
                Top = 0
                Width = 951
                Height = 170
                Align = alClient
                AutoFitColWidths = True
                DataGrouping.GroupLevels = <>
                DataSource = dsOrderAttrs
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
                    AutoFitColWidth = False
                    EditButtons = <>
                    FieldName = 'ATTR_NAME'
                    Footers = <>
                    Title.Alignment = taCenter
                    Title.Caption = #1040#1090#1088#1080#1073#1091#1090
                    Width = 250
                  end
                  item
                    EditButtons = <>
                    FieldName = 'O_PARAM_VALUE'
                    Footers = <>
                    Title.Alignment = taCenter
                    Title.Caption = #1047#1085#1072#1095#1077#1085#1080#1077
                    Width = 500
                  end
                  item
                    EditButtons = <>
                    FieldName = 'O_PARAM_NAME'
                    Footers = <>
                  end>
                object RowDetailData: TRowDetailPanelControlEh
                end
              end
            end
            object tsOrderItems: TTabSheet
              Caption = #1055#1086#1079#1080#1094#1080#1080' '#1079#1072#1103#1074#1082#1080
              ImageIndex = 1
              object grdOrderItems: TDBGridEh
                Left = 0
                Top = 0
                Width = 923
                Height = 170
                Align = alClient
                AutoFitColWidths = True
                DataGrouping.GroupLevels = <>
                DataSource = dsOrderItems
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
                    FieldName = 'AUFTRAG_ID'
                    Footers = <>
                    Title.Alignment = taCenter
                    Title.Caption = 'Auftrag'
                  end
                  item
                    EditButtons = <>
                    FieldName = 'ORDERITEM_ID'
                    Footers = <>
                    Visible = False
                  end
                  item
                    AutoFitColWidth = False
                    EditButtons = <>
                    FieldName = 'ORDERITEM_INDEX'
                    Footers = <>
                    Title.Alignment = taCenter
                    Title.Caption = #1055#1086#1079'.'
                    Width = 30
                  end
                  item
                    EditButtons = <>
                    FieldName = 'ARTICLE_CODE'
                    Footers = <>
                    Title.Alignment = taCenter
                    Title.Caption = #1040#1088#1090#1080#1082#1091#1083
                  end
                  item
                    EditButtons = <>
                    FieldName = 'NAME_RUS'
                    Footers = <>
                    Title.Alignment = taCenter
                    Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
                    Width = 100
                  end
                  item
                    EditButtons = <>
                    FieldName = 'DIMENSION'
                    Footers = <>
                    Title.Alignment = taCenter
                    Title.Caption = #1056#1072#1079#1084#1077#1088
                    Width = 30
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
                    Footers = <>
                    Visible = False
                  end
                  item
                    EditButtons = <>
                    FieldName = 'COST_EUR'
                    Footers = <>
                    Title.Alignment = taCenter
                    Title.Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100', EUR'
                  end
                  item
                    EditButtons = <>
                    FieldName = 'STATUS_ID'
                    Footers = <>
                    Visible = False
                  end
                  item
                    EditButtons = <>
                    FieldName = 'STATE_NAME'
                    Footers = <>
                    Title.Alignment = taCenter
                    Title.Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077
                    Width = 100
                  end
                  item
                    EditButtons = <>
                    FieldName = 'STATUS_NAME'
                    Footers = <>
                    Title.Alignment = taCenter
                    Title.Caption = #1057#1090#1072#1090#1091#1089
                    Width = 200
                  end
                  item
                    EditButtons = <>
                    FieldName = 'STATUS_DTM'
                    Footers = <>
                    Title.Alignment = taCenter
                    Title.Caption = #1044#1072#1090#1072' '#1076#1074#1080#1078#1077#1085#1080#1103
                  end>
                object RowDetailData: TRowDetailPanelControlEh
                end
              end
            end
            object tsOrderTaxs: TTabSheet
              Caption = #1050#1086#1084#1080#1089#1089#1080#1086#1085#1085#1099#1077' '#1089#1073#1086#1088#1099
              ImageIndex = 2
              object grdOrderTaxs: TDBGridEh
                Left = 0
                Top = 0
                Width = 951
                Height = 170
                Align = alClient
                AutoFitColWidths = True
                DataGrouping.GroupLevels = <>
                DataSource = dsOrderTaxs
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
                    FieldName = 'ORDERTAX_ID'
                    Footers = <>
                    Visible = False
                  end
                  item
                    EditButtons = <>
                    FieldName = 'ORDER_ID'
                    Footers = <>
                    Visible = False
                  end
                  item
                    EditButtons = <>
                    FieldName = 'TAXRATE_ID'
                    Footers = <>
                    Visible = False
                  end
                  item
                    EditButtons = <>
                    FieldName = 'TAXSERV_NAME'
                    Footers = <>
                    Width = 200
                  end
                  item
                    EditButtons = <>
                    FieldName = 'PRICE_EUR'
                    Footers = <>
                  end
                  item
                    EditButtons = <>
                    FieldName = 'AMOUNT'
                    Footers = <>
                  end
                  item
                    EditButtons = <>
                    FieldName = 'COST_EUR'
                    Footers = <>
                  end
                  item
                    EditButtons = <>
                    FieldName = 'STATUS_ID'
                    Footers = <>
                    Visible = False
                  end
                  item
                    EditButtons = <>
                    FieldName = 'STATUS_NAME'
                    Footers = <>
                    Width = 200
                  end
                  item
                    EditButtons = <>
                    FieldName = 'STATUS_DTM'
                    Footers = <>
                  end>
                object RowDetailData: TRowDetailPanelControlEh
                end
              end
            end
            object ts1: TTabSheet
              Caption = #1044#1074#1080#1078#1077#1085#1080#1077' '#1089#1088#1077#1076#1089#1090#1074
              ImageIndex = 3
              object spl1: TSplitter
                Left = 588
                Top = 0
                Height = 170
                Align = alRight
              end
              object grdAccountMovements: TDBGridEh
                Left = 0
                Top = 0
                Width = 588
                Height = 170
                Align = alClient
                AutoFitColWidths = True
                DataGrouping.GroupLevels = <>
                DataSource = dsAccountMovements
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
                    AutoFitColWidth = False
                    EditButtons = <>
                    FieldName = 'ACCOPER_DTM'
                    Footer.Alignment = taRightJustify
                    Footer.Value = #1054#1089#1090#1072#1090#1086#1082
                    Footer.ValueType = fvtStaticText
                    Footers = <>
                    Title.Alignment = taCenter
                    Title.Caption = #1044#1072#1090#1072
                  end
                  item
                    AutoFitColWidth = False
                    EditButtons = <>
                    FieldName = 'AMOUNT_EUR'
                    Footers = <>
                    Title.Alignment = taCenter
                    Title.Caption = #1057#1091#1084#1084#1072', EUR'
                    Width = 70
                  end
                  item
                    EditButtons = <>
                    FieldName = 'AMOUNT_BYR'
                    Footers = <>
                  end
                  item
                    AutoFitColWidth = False
                    EditButtons = <>
                    FieldName = 'BYR2EUR'
                    Footers = <>
                    Title.Alignment = taCenter
                    Title.Caption = #1050#1091#1088#1089
                  end
                  item
                    EditButtons = <>
                    FieldName = 'NOTES'
                    Footers = <>
                    Title.Alignment = taCenter
                    Title.Caption = #1054#1087#1080#1089#1072#1085#1080#1077
                    Width = 300
                  end>
                object RowDetailData: TRowDetailPanelControlEh
                end
              end
              object grdRests: TDBGridEh
                Left = 591
                Top = 0
                Width = 332
                Height = 170
                Align = alRight
                AutoFitColWidths = True
                DataGrouping.GroupLevels = <>
                DataSource = dsRest
                Flat = False
                FooterColor = clWindow
                FooterFont.Charset = DEFAULT_CHARSET
                FooterFont.Color = clWindowText
                FooterFont.Height = -11
                FooterFont.Name = 'MS Sans Serif'
                FooterFont.Style = []
                RowDetailPanel.Color = clBtnFace
                TabOrder = 1
                TitleFont.Charset = DEFAULT_CHARSET
                TitleFont.Color = clWindowText
                TitleFont.Height = -11
                TitleFont.Name = 'MS Sans Serif'
                TitleFont.Style = []
                Columns = <
                  item
                    EditButtons = <>
                    FieldName = 'BYR2EUR'
                    Footers = <>
                    Title.Alignment = taCenter
                    Title.Caption = #1050#1091#1088#1089
                  end
                  item
                    EditButtons = <>
                    FieldName = 'REST_EUR'
                    Footers = <>
                    Title.Alignment = taCenter
                    Title.Caption = 'EUR'
                  end
                  item
                    EditButtons = <>
                    FieldName = 'REST_BYR'
                    Footers = <>
                    Title.Alignment = taCenter
                    Title.Caption = 'BYR'
                  end
                  item
                    EditButtons = <>
                    FieldName = 'REST_DTM'
                    Footers = <>
                    Title.Alignment = taCenter
                    Title.Caption = #1044#1072#1090#1072
                  end>
                object RowDetailData: TRowDetailPanelControlEh
                end
              end
            end
            object tsHistory: TTabSheet
              Caption = #1048#1089#1090#1086#1088#1080#1103' '#1089#1090#1072#1090#1091#1089#1086#1074
              ImageIndex = 4
              object grdHistory: TDBGridEh
                Left = 0
                Top = 0
                Width = 900
                Height = 170
                Align = alClient
                AutoFitColWidths = True
                DataGrouping.GroupLevels = <>
                DataSource = dsHistory
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
                    AutoFitColWidth = False
                    EditButtons = <>
                    FieldName = 'ACTION_DTM'
                    Footers = <>
                  end
                  item
                    EditButtons = <>
                    FieldName = 'STATUS_NAME'
                    Footers = <>
                    Width = 300
                  end
                  item
                    EditButtons = <>
                    FieldName = 'STATE_NAME'
                    Footers = <>
                    Width = 300
                  end
                  item
                    AutoFitColWidth = False
                    EditButtons = <>
                    FieldName = 'USER_SIGN'
                    Footers = <>
                  end>
                object RowDetailData: TRowDetailPanelControlEh
                end
              end
            end
            object tsClientAttrs: TTabSheet
              Caption = #1040#1090#1088#1080#1073#1091#1090#1099' '#1082#1083#1080#1077#1085#1090#1072
              ImageIndex = 5
              object grdClientAttrs: TDBGridEh
                Left = 0
                Top = 0
                Width = 900
                Height = 170
                Align = alClient
                DataGrouping.GroupLevels = <>
                DataSource = dsClientAttrs
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
                    Width = 200
                  end
                  item
                    EditButtons = <>
                    FieldName = 'O_PARAM_VALUE'
                    Footers = <>
                    Width = 300
                  end>
                object RowDetailData: TRowDetailPanelControlEh
                end
              end
            end
            object tsNote: TTabSheet
              Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1103
              ImageIndex = 6
              object dbmmoATTR_VALUE: TDBMemo
                Left = 0
                Top = 0
                Width = 923
                Height = 170
                Align = alClient
                DataField = 'ATTR_VALUE'
                DataSource = dsNotes
                TabOrder = 0
              end
            end
          end
        end
      end
    end
  end
  inherited qryMain: TpFIBDataSet
    RefreshSQL.Strings = (
      'SELECT'
      '    orders.ORDER_ID,'
      '    orders.ORDER_CODE,'
      '    orders.CLIENT_ID,'
      '    v_clients_fio.client_fio,'
      '    orders.ADRESS_ID,'
      '    orders.CREATE_DTM,'
      '    orders.STATUS_ID,'
      '    statuses.STATUS_NAME,'
      '    statuses.STATUS_SIGN,'
      '    orders.STATUS_DTM,'
      '    v_order_summary.cost_eur,'
      '    v_order_summary.cost_byr,'
      '    orders.bar_code,'
      '    orders.user_sign,'
      '    orders.account_id,'
      '    orders.source,'
      '    1 is_invoiced,'
      '    0 is_invoiceprinted,'
      '    orders.byr2eur,'
      '    accounts.rest_eur,'
      '    v_order_attrs.attr_value note'
      'FROM ORDERS '
      
        '  inner join v_clients_fio on (v_clients_fio.client_id = orders.' +
        'client_id)'
      '  inner join statuses on (statuses.status_id = orders.status_id)'
      
        '  inner join v_order_summary on (v_order_summary.order_id = orde' +
        'rs.order_id)'
      
        '  left join v_order_attrs on (v_order_attrs.object_id = orders.o' +
        'rder_id and v_order_attrs.attr_sign='#39'NOTE'#39')'
      
        '  inner join accounts on (accounts.account_id = orders.account_i' +
        'd)'
      'where  '
      '/*FILTER*/ 1=1'
      'and ORDERS.ORDER_ID = :OLD_ORDER_ID  '
      '    ')
    SelectSQL.Strings = (
      'SELECT'
      '    orders.ORDER_ID,'
      '    orders.ORDER_CODE,'
      '    orders.CLIENT_ID,'
      '    v_clients_fio.client_fio,'
      '    orders.ADRESS_ID,'
      '    orders.CREATE_DTM,'
      '    orders.STATUS_ID,'
      '    statuses.STATUS_NAME,'
      '    statuses.STATUS_SIGN,'
      '    orders.STATUS_DTM,'
      '    orders.cost_eur,'
      '    orders.cost_byr,'
      '    orders.bar_code,'
      '    orders.user_sign,'
      '    orders.account_id,'
      '    orders.source,'
      '    orders.byr2eur,'
      '    accounts.rest_eur,'
      '    orders.packlist_no'
      'FROM ORDERS '
      
        '  inner join v_clients_fio on (v_clients_fio.client_id = orders.' +
        'client_id)'
      '  inner join statuses on (statuses.status_id = orders.status_id)'
      
        '  inner join accounts on (accounts.account_id = orders.account_i' +
        'd)'
      'where '
      '/*FILTER*/ 1=1'
      'order by Create_dtm desc')
    CacheModelOptions.CacheModelKind = cmkLimitedBufferSize
    CacheModelOptions.BufferChunks = 100
    AfterScroll = qryMainAfterScroll
    Transaction = trnRead
    UpdateTransaction = trnWrite
  end
  inherited actListMain: TActionList
    object actSendOrders: TAction
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1079#1072#1103#1074#1082#1080
    end
    object actFilterApproved: TAction
      Caption = #1054#1092#1086#1088#1084#1083#1077#1085#1085#1099#1077
      OnExecute = actFilterApprovedExecute
    end
    object actFilterAcceptRequest: TAction
      Caption = #1054#1090#1087#1088#1072#1074#1083#1077#1085#1085#1099#1077
      OnExecute = actFilterAcceptRequestExecute
    end
    object actMakeInvoice: TAction
      Caption = #1048#1079#1074#1077#1097#1077#1085#1080#1077
      ImageIndex = 0
      OnExecute = actMakeInvoiceExecute
    end
    object actAssignPayment: TAction
      Caption = #1047#1072#1095#1080#1089#1083#1080#1090#1100' '#1087#1083#1072#1090#1077#1078
      ImageIndex = 1
      OnExecute = actAssignPaymentExecute
    end
    object actSetStatus: TAction
      Caption = 'actSetStatus'
      OnExecute = actSetStatusExecute
    end
    object actDeleteOrder: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1079#1072#1103#1074#1082#1091
      ImageIndex = 2
      OnExecute = actDeleteOrderExecute
      OnUpdate = actDeleteOrderUpdate
    end
    object actBalanceOrder: TAction
      Caption = #1057#1073#1072#1083#1072#1085#1089#1080#1088#1086#1074#1072#1090#1100
      ImageIndex = 3
      OnExecute = actBalanceOrderExecute
      OnUpdate = actBalanceOrderUpdate
    end
    object actRest2Order: TAction
      Caption = #1054#1089#1090#1072#1090#1086#1082' '#1085#1072' '#1079#1072#1103#1074#1082#1091
      ImageIndex = 1
      OnExecute = actRest2OrderExecute
      OnUpdate = actRest2OrderUpdate
    end
    object actSetServTax: TAction
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1057'/'#1057
    end
  end
  inherited imgListMain: TPngImageList
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002944944415478DAA5537B48D351183DD76D3E92A6ABCD99
          B95E826F33B30729521039D1944CAC54D41C86583EC92C2DDC56584186121911
          382B35302BCB3052FF290A835227A52804495B94D3A9A9CDDAE67EEB0EDC0F34
          08AC03877BBFFB7DE770F8E012ABD58AFF01912707C5D3D3EB1FF55FC9B9A4C0
          5CE59D17372C8C79594A8E030FF2CC3DC749D901FF13F2DB5DD7DB9A9B966590
          70380DCAA3FBF2C8A978DF7C457DC7B521F53B083C3CD881719D0E9A9111F0F9
          7CF8F8F9C181C3617B5363630808DB0E4596B48014C7FA1429EA9F570FAB7BB0
          2928881DAAABAD85C4DB1B128904038383484E4F677B9F68ED1FB68D1AC41493
          FCE80D2715AA6755C3FDBD70178BD1DBFD06E111BBD0FEA81511F4B4A19BBEC5
          1D4C647BDF693AFF2DE150C8624B48EE5EC96985AAFDF250DFE2042D8D8D08A1
          B546A38146AB45765EDEA204015B690259DC1992BDDBAB5CA97A5A39ACEE83BB
          48C40E31160B463FDC035FE00C9ECB2A10BA75CCCFC091CC40AF27089696422E
          8B3F4B3223C515E7556DCACE278FE16AECC11A891016E282398311A6898F483C
          560093C18051ED1078D64908855CB43D7C8F9D29B5A89025C8495298FBC59AFB
          9D6566B3195FDEDE44648C941518267598E779C0683461EC9B164E5C60B5900F
          8688E0199A86A243D19748F85A5E899B33596F8B1DB88E094D2F2C8DB25818FC
          989E84582840F08E903F12545FB8DBDFD5EBF07AFA97F533A13A574A09A5634E
          14A9BCD1D2B0DF2ED08EE8E024D808BB218758E0BA828716D5ADAAAB1D4C1DD5
          68897D695E6EC0664F141C4991E670B89C59323FA7EF7BF572E24A5343C6D204
          E585F50D9A29643C505BC11A2CC0995260FB64B622DA1759A9A9D2540E974B0D
          0D7A8B69D685618CA2E6D601D5B80135B00FFE052B17B81453943F6D97DF60F1
          10F1CA2AAE1F0000000049454E44AE426082}
        Name = 'PngImage0'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002094944415478DA63FCFFFF3F032580916203EA43B57D81
          B41499FA9F31D6046B65362E3C30EDEFBFDF24E964666265A88F77C862AC0CD0
          C8AE5FB07BCAA6954B4932C02F3C9AA131C13587B1D4572DB761FECE49D7CF9F
          66101413832B78FDF225C3A3FBF719F8F8F81894D5D519989899E172EF5FBD62
          D0343465684874CF632CF4522E6898BFA3FFC6F9330C4ADADA704573A74E6590
          95916190959565B872F52A43686C2C5CEE1E90AF61680234C0A39031D74DA1B8
          61DEB69E1B17CE3208888B339C3D769CC1D8CA9261EBBAF50C56401A048E01C5
          BC8302E1721F80AED33030666848F22A61CC74962D6F98B7B5E3FA395417AC5E
          B2844117C87FF4E811C3A3C78F19527272505CA069047441927705638ABD5455
          E3BCCDAD37CE9F63101015852BFAF7F72FC3FD3B7718BE7CFECC200DF48608D0
          759DDF96335CFE7E9741F9AF38C34CA32686FA24DF6AC6786BF1BAA6799B1A77
          6DDC4030E45B44D733B8FAFB32ECDEB899E190D54286BA24BF7AC6604381B609
          AB7655FEFE8D3B1D54DD99CC70F5DB3D305BC3D980E1C6DE0B0C8C8C8C0CEF2F
          DC3ECF682CCD5AC8CFC1A884CFE6E3291CE116092EA2E8E2C716EF7DC208A4D9
          8058008859709AD0C1DBC2C0C8600C62EA441AE85D597EE112589C85F1142351
          C9AE9397810194E77EFF3F2315236FFC6CC9C3B30CAC8C264003188837E0C52F
          06863FFF6702B13150E359204E6790666700000EA4BC079831C9FD0000000049
          454E44AE426082}
        Name = 'PngImage1'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002744944415478DA8D92DF4B5A6118C7BFA7B2D4399647C8
          DC4D7703BB8BBCDAEDE8CA0DE695C466B8BAB0522B09A3081302A15A0D37B512
          94CDC3FC07DCCDEE76131B94D14544B13B591867663FB6D29352EE39EF383668
          440FBCBCCF79CEF37CDEEFF3BC2F170C06211BC771CF6833E16E7650ABD53EB1
          BA4020A0045DB3B3B3AB77A99E999919A42DCE00535353754028145A4DF63641
          AB6D814EA78146D32CA740922A383F97502A497895AE627A7AFA1AE0F7FB15C0
          E0DCDCDCCA8797CD30181EA0BD9D07CFEB18E0F4F40CA27882C3C31338521226
          272787E80753CBF97CBE3A6061616145E853E369F00B7EE5BE312555DD23143E
          8FD6012FDE97303131710DF0783C0A6068696969F9A3530BB5BA196D6D7AB4B6
          DEC3F1F119F47A5D1DD09B3CC3F8F8F830E5AF3080CBE55200C3E17038767979
          79EB001B1B1B313636E626779901FAFBFB957FEE4824124D2412E8EEEE463E9F
          FF7B5F0707703A9D585F5F27257A98CD6678BD5E59768C011C0E471D108BC5A2
          A228DE3895E7791C1D1D31DF6834C2ED765F03EC76BB92E789C7E391ADAD2D9A
          819AAE508372B9CC4E95013B3B3B2C2E2BA0B6BD941F35538CB3D96C0AC09B4C
          26DF552A95FFF65E2C16D96E329930303030F2646D2D622814C059AD56256724
          954ABD150481C9944D6EA7A7A707C5F9791437367075754557AB85B8B7F74373
          71F1B3066C72168B85C9241B4DA7D3616578FFDA2ECDE97957D78D784A103639
          D9E9ECECA4A7ABF365329937D96C96F52FF72B4912837F5F5C44617B9B153534
          34607F7777BFA552119B640514D3D0BADFD1D1D147C5AFABD5EAADEF40A55281
          54FB73B99C409FBF65004FEB21F5F698E87ADCC16816C7A552E92BB9F93F9C09
          F132680DE6BE0000000049454E44AE426082}
        Name = 'PngImage2'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002FB4944415478DA855369489441187EDF6F57CD2BCD73BD
          8F6C2D335A75F3A83CA9208FB01005AFA434353C4830FB15516499A928695946
          ABABFE103123914028287F48A25D485A2492E69591472A7B7DD3FBB9E68F3668
          E061669E79E69977DE99175B8B38109AB1580FA1599A2220423E02EC64005F18
          83BB2BEB6C634DADD5436869B53AC07F19883804D7DD071ECB8E17263EABCBAC
          D7EAA040C7FFDFC055C441220D03374C1CE5B2B894BC80A66B677B1DAC704EBF
          0586753C7493C1D49681B288BB4C21EEDD140CD0E19DD4FF729606751D8CCD89
          EAA8C9EB202E8F380B0A2289FA504148571C49AFD55DC596420ED41AE6485C23
          21D7D808E72864709106F64724E41C6AABCC7BC27198281681812EA38E22A8CF
          DE48580925CC9E6EF99DA2A9A613C1DD3760203C2E2BA4ADBAB89736C40929F8
          5B77FE010F589B85125AA8246410A92494D278D6CDC76F3028EA84BCBBE9661F
          191C23DE4057F4889FC5AA4CCCDA6E86B0CB09159F6758D6F2DA46B615AE5E3E
          6F646151B29EF6A617348F2118E84A9A79053ECCC70AB108BD1DAD71766E9149
          B43A364EE232535BCF0F21E191FE9D4A45BF9D25861367A03BD3C097E1BD73F8
          34FB4A73FCFCD751D8C64F4287A2B5675D0509F62E1E23D14723FC9AEFB70C98
          1A6398A90918E8721BF904AC48833B94A0C0CD67044AE030CD0B5C3D3D4663E3
          237C1B6A9583F402C1C41BE82EB6B202BC910AA0D182332D3A1139636B89D30B
          CB0CBC7DDCC74E9E8A9456DD520E915E6EB71DE1C70ADBD2198961FA521B033C
          B20FC0CD0E608F0B82A703070E56008BAB002B62E7B194E46869F9F596219997
          486E6D0E30BF043031CFC3C76F0C261700FADE93C19F9092421152C3B952FAD2
          DEC27CFCA7C5E188C8FD4EDD5D2F27E43EA2C1CD3A186F7FC557760EE8EB8231
          BD8148F8A604B39AD3D85A5CAE8851AB54A051AB606E6A14C46C05AC2C189853
          85D6D7289F5F6866E9A45D13BE3B19E8040323828460971C0CA5524F89BF8DBD
          C4C46A878D8918B4463ACD2ABFB6BAAC5E5A5C52BDFB34FFB6E335DC262D5D00
          66C840F31B6FC256F090DEB7B60000000049454E44AE426082}
        Name = 'PngImage3'
        Background = clWindow
      end>
    Bitmap = {}
  end
  inherited trnRead: TpFIBTransaction
    Active = True
    TPBMode = tpbReadCommitted
  end
  object qryOrderAttrs: TpFIBDataSet
    SelectSQL.Strings = (
      'select a.attr_name, o.o_param_name, o.o_param_value'
      'from object_read('#39'ORDER'#39', :order_id) o'
      
        'inner join attrs a on (a.attr_sign = o.o_param_name and a.object' +
        '_sign = '#39'ORDER'#39')'
      'where a.attr_sign in ('#39'PRODUCT_NAME'#39', '#39'WEIGHT'#39', '#39'COST_EUR'#39', '
      #39'PREPAID_EUR'#39', '#39'ADRESS_TEXT'#39')'
      'order by a.attr_name')
    CacheModelOptions.CacheModelKind = cmkLimitedBufferSize
    CacheModelOptions.BufferChunks = 100
    Transaction = trnRead
    Database = dmOtto.dbOtto
    DataSource = dsMain
    Left = 736
    Top = 16
    oStartTransaction = False
  end
  object dsOrderAttrs: TDataSource
    AutoEdit = False
    DataSet = qryOrderAttrs
    Left = 800
    Top = 16
  end
  object qryOrderItems: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    oi.ORDERITEM_ID,'
      '    oi.ORDER_ID,'
      '    oi.ARTICLE_ID,'
      '    oi.ARTICLE_CODE,'
      '    oi.DIMENSION,'
      '    oi.PRICE_EUR,'
      '    oi.AMOUNT,'
      '    oi.COST_EUR,'
      '    oi.STATUS_ID,'
      '    ss.STATUS_NAME STATE_NAME,'
      '    s.STATUS_NAME,'
      '    oi.STATUS_DTM,'
      '    oi.ORDERITEM_INDEX,'
      
        '    coalesce(oi.name_rus, '#39#39')||'#39' '#39'||coalesce(oi.kind_rus, '#39#39') na' +
        'me_rus,'
      '    oi.auftrag_id'
      'FROM ORDERITEMS oi'
      '  inner join statuses s on (s.status_id = oi.status_id)'
      '  left join statuses ss on (ss.status_id = oi.state_id)'
      'WHERE ORDER_ID = :ORDER_ID'
      'ORDER BY ORDERITEM_ID')
    CacheModelOptions.CacheModelKind = cmkLimitedBufferSize
    CacheModelOptions.BufferChunks = 100
    Transaction = trnRead
    Database = dmOtto.dbOtto
    DataSource = dsMain
    Left = 736
    Top = 56
  end
  object qryOrderTaxs: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    ot.ORDERTAX_ID,'
      '    ot.ORDER_ID,'
      '    ot.TAXRATE_ID,'
      '    ts.taxserv_name,'
      '    ot.PRICE_EUR,'
      '    ot.AMOUNT,'
      '    ot.COST_EUR,'
      '    ot.STATUS_ID,'
      '    s.STATUS_NAME,'
      '    ot.STATUS_DTM'
      'FROM ORDERTAXS ot'
      'inner join taxrates tr on (tr.taxrate_id = ot.taxrate_id)'
      'inner join taxservs ts on (ts.taxserv_id = tr.taxserv_id)'
      'inner join statuses s on (s.status_id = ot.status_id)'
      'WHERE ot.ORDER_ID = :ORDER_ID'
      'ORDER BY ORDERTAX_ID')
    CacheModelOptions.CacheModelKind = cmkLimitedBufferSize
    CacheModelOptions.BufferChunks = 100
    Transaction = trnRead
    Database = dmOtto.dbOtto
    DataSource = dsMain
    Left = 736
    Top = 104
  end
  object dsOrderItems: TDataSource
    AutoEdit = False
    DataSet = qryOrderItems
    Left = 800
    Top = 56
  end
  object dsOrderTaxs: TDataSource
    AutoEdit = False
    DataSet = qryOrderTaxs
    Left = 800
    Top = 104
  end
  object qryStatuses: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    STATUS_ID,'
      '    STATUS_NAME,'
      '    OBJECT_SIGN,'
      '    IS_DEFAULT,'
      '    STATUS_SIGN,'
      '    ACTION_SIGN,'
      '    FLAG_SIGN_LIST'
      'FROM'
      '    STATUSES ')
    Transaction = trnRead
    Database = dmOtto.dbOtto
    Left = 736
    Top = 152
  end
  object qryAccountMovements: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    ACCOPER_DTM,'
      '    -AMOUNT_EUR amount_eur,'
      '    -AMOUNT_BYR amount_byr,'
      '    BYR2EUR,'
      '    NOTES'
      'FROM accopers ao'
      'where ao.order_id = :order_id'
      'order by ao.accoper_dtm')
    CacheModelOptions.CacheModelKind = cmkLimitedBufferSize
    CacheModelOptions.BufferChunks = 100
    Transaction = trnRead
    Database = dmOtto.dbOtto
    DataSource = dsMain
    Left = 736
    Top = 200
  end
  object dsAccountMovements: TDataSource
    AutoEdit = False
    DataSet = qryAccountMovements
    Left = 808
    Top = 200
  end
  object qryHistory: TpFIBDataSet
    SelectSQL.Strings = (
      'select oh.action_dtm,'
      '  s1.status_name,'
      '  s2.status_name state_name,'
      '  oh.user_sign'
      'from orderhistory oh'
      'inner join statuses s1 on (s1.status_id = oh.status_id)'
      'left join statuses s2 on (s2.status_id = oh.state_id)'
      'where oh.order_id = :order_id'
      'order by oh.action_dtm desc')
    CacheModelOptions.CacheModelKind = cmkLimitedBufferSize
    CacheModelOptions.BufferChunks = 100
    Transaction = dmOtto.trnAutonomouse
    Database = dmOtto.dbOtto
    DataSource = dsMain
    Left = 736
    Top = 248
  end
  object dsHistory: TDataSource
    AutoEdit = False
    DataSet = qryHistory
    Left = 808
    Top = 248
  end
  object qryNextStatus: TpFIBDataSet
    SelectSQL.Strings = (
      'select s.status_id, s.status_name, s.status_sign'
      'from status_rules sr'
      '  inner join statuses s on (s.status_id = sr.new_status_id)'
      'where sr.old_status_id = :status_id')
    Transaction = trnWrite
    Database = dmOtto.dbOtto
    DataSource = dsMain
    Left = 736
    Top = 296
  end
  object frxPDFExport: TfrxPDFExport
    ShowDialog = False
    UseFileCache = True
    ShowProgress = False
    OverwritePrompt = False
    EmbeddedFonts = True
    PrintOptimized = False
    Outline = False
    Background = False
    HTMLTags = True
    Author = 'Otto.by'
    Subject = 'FastReport PDF export'
    ProtectionFlags = [eModify, eCopy, eAnnot]
    HideToolbar = False
    HideMenubar = False
    HideWindowUI = False
    FitWindow = False
    CenterWindow = False
    PrintScaling = False
    Left = 416
    Top = 96
  end
  object frxInvoice: TfrxReport
    Version = '4.9.64'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.MDIChild = True
    PreviewOptions.Modal = False
    PreviewOptions.ShowCaptions = True
    PreviewOptions.Zoom = 1.000000000000000000
    PreviewOptions.ZoomMode = zmManyPages
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 40773.818275636600000000
    ReportOptions.LastChange = 41088.116852141200000000
    ScriptLanguage = 'PascalScript'
    ShowProgress = False
    StoreInDFM = False
    OnAfterPrintReport = frxInvoiceAfterPrintReport
    Left = 352
    Top = 200
  end
  object frxFIBComponents1: TfrxFIBComponents
    DefaultDatabase = dmOtto.dbOtto
    Left = 512
    Top = 144
  end
  object qryClientAttrs: TpFIBDataSet
    SelectSQL.Strings = (
      'select *'
      'from object_read('#39'CLIENT'#39', :client_id) oa'
      
        'inner join attrs a on (a.attr_sign = oa.o_param_name and a.objec' +
        't_sign = '#39'CLIENT'#39')'
      'order by a.attr_id')
    Transaction = trnRead
    Database = dmOtto.dbOtto
    DataSource = dsMain
    Left = 741
    Top = 351
  end
  object dsClientAttrs: TDataSource
    AutoEdit = False
    DataSet = qryClientAttrs
    Left = 813
    Top = 351
  end
  object qryRest: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT *'
      'FROM accrests ar'
      'where ar.account_id = :account_id'
      '--  and ar.rest_byr <> 0'
      '--  and ar.rest_eur <> 0'
      'order by ar.account_id, ar.rest_dtm')
    Transaction = trnRead
    Database = dmOtto.dbOtto
    UpdateTransaction = trnWrite
    DataSource = dsMain
    Left = 741
    Top = 407
  end
  object dsRest: TDataSource
    AutoEdit = False
    DataSet = qryRest
    Left = 813
    Top = 407
  end
  object frxExportEmail: TfrxMailExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    ShowExportDialog = True
    SmtpPort = 25
    UseIniFile = True
    TimeOut = 60
    ConfurmReading = False
    Left = 417
    Top = 199
  end
  object qryNotes: TpFIBDataSet
    UpdateSQL.Strings = (
      'UPDATE ORDER_ATTRS'
      'SET '
      '    ATTR_VALUE = :ATTR_VALUE'
      'WHERE ATTR_ID = :OLD_ATTR_ID'
      'and OBJECT_ID = :ORDER_ID'
      ''
      '    ')
    DeleteSQL.Strings = (
      ''
      '    ')
    RefreshSQL.Strings = (
      'SELECT *'
      'FROM v_order_attrs oa'
      'where oa.object_id = :order_id'
      '  and oa.attr_sign = '#39'NOTE'#39)
    SelectSQL.Strings = (
      'SELECT *'
      'FROM v_order_attrs oa'
      'where oa.object_id = :order_id'
      '  and oa.attr_sign = '#39'NOTE'#39';')
    Transaction = trnRead
    Database = dmOtto.dbOtto
    UpdateTransaction = trnWrite
    DataSource = dsMain
    Left = 861
    Top = 407
  end
  object dsNotes: TDataSource
    DataSet = qryNotes
    Left = 901
    Top = 409
  end
end
