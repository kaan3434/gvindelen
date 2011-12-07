inherited FormTableOrders: TFormTableOrders
  Left = 285
  Top = 123
  Caption = #1047#1072#1103#1074#1082#1080
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlMain: TJvPanel
    inherited grBoxMain: TJvGroupBox
      inherited grdMain: TDBGridEh
        AllowedOperations = [alopDeleteEh]
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking, dghEnterAsTab, dghIncSearch, dghPreferIncSearch, dghRowHighlight, dghDialogFind, dghColumnResize, dghColumnMove, dghExtendVertLines]
        RowDetailPanel.Active = True
        RowDetailPanel.Height = 200
        STFilter.InstantApply = True
        STFilter.Visible = True
        OnDblClick = grdMainDblClick
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
          end>
        inherited RowDetailData: TRowDetailPanelControlEh
          object pcDetailInfo: TPageControl
            Left = 0
            Top = 0
            Width = 606
            Height = 198
            ActivePage = ts1
            Align = alClient
            TabOrder = 0
            object tsOrderAttrs: TTabSheet
              Caption = #1040#1090#1088#1080#1073#1091#1090#1099' '#1079#1072#1103#1074#1082#1080
              object grdOrderProperties: TDBGridEh
                Left = 0
                Top = 0
                Width = 598
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
                Width = 598
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
                    FieldName = 'ORDERITEM_ID'
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
                    FieldName = 'ARTICLE_ID'
                    Footers = <>
                    Visible = False
                  end
                  item
                    EditButtons = <>
                    FieldName = 'ARTICLE_CODE'
                    Footers = <>
                  end
                  item
                    EditButtons = <>
                    FieldName = 'DIMENSION'
                    Footers = <>
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
            object tsOrderTaxs: TTabSheet
              Caption = #1050#1086#1084#1080#1089#1089#1080#1086#1085#1085#1099#1077' '#1089#1073#1086#1088#1099
              ImageIndex = 2
              object grdOrderTaxs: TDBGridEh
                Left = 0
                Top = 0
                Width = 598
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
              Caption = #1041#1072#1083#1072#1085#1089' '#1089#1095#1077#1090#1072
              ImageIndex = 3
              object grdAccountMovements: TDBGridEh
                Left = 0
                Top = 0
                Width = 598
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
                    EditButtons = <>
                    FieldName = 'ACCOUNT_ID'
                    Footers = <>
                    Visible = False
                  end
                  item
                    Alignment = taCenter
                    AutoFitColWidth = False
                    EditButtons = <>
                    FieldName = 'DEAL_DATE'
                    Footers = <>
                    Title.Alignment = taCenter
                    Title.Caption = #1044#1072#1090#1072
                    Width = 100
                  end
                  item
                    AutoFitColWidth = False
                    DisplayFormat = '# ##0.## EUR'
                    EditButtons = <>
                    FieldName = 'AMOUNT_EUR'
                    Footers = <>
                    Title.Alignment = taCenter
                    Title.Caption = #1057#1091#1084#1084#1072
                    Width = 80
                  end
                  item
                    EditButtons = <>
                    FieldName = 'BALANCE_EUR'
                    Footers = <>
                    Title.Alignment = taCenter
                    Title.Caption = #1041#1072#1083#1072#1085#1089
                  end
                  item
                    AutoFitColWidth = False
                    EditButtons = <>
                    FieldName = 'ORDER_CODE'
                    Footers = <>
                    Title.Alignment = taCenter
                    Title.Caption = #1047#1072#1103#1074#1082#1072
                    Width = 80
                  end
                  item
                    EditButtons = <>
                    FieldName = 'ACTION_NAME'
                    Footers = <>
                    Title.Alignment = taCenter
                    Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1076#1077#1081#1089#1090#1074#1080#1103
                    Width = 300
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
                Width = 598
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
                  end>
                object RowDetailData: TRowDetailPanelControlEh
                end
              end
            end
          end
        end
      end
    end
  end
  inherited qryMain: TpFIBDataSet
    DeleteSQL.Strings = (
      'DELETE FROM'
      '    ORDERS'
      'WHERE'
      '    ORDER_ID = :OLD_ORDER_ID'
      '    ')
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
      '    v_order_summary.cost_byr'
      'FROM ORDERS '
      
        '  inner join v_clients_fio on (v_clients_fio.client_id = orders.' +
        'client_id)'
      '  inner join statuses on (statuses.status_id = orders.status_id)'
      
        '  inner join v_order_summary on (v_order_summary.order_id = orde' +
        'rs.order_id)'
      'where  '
      '/*FILTER*/ ORDERS.ORDER_ID = :OLD_ORDER_ID'
      ''
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
      '    v_order_summary.cost_eur,'
      '    v_order_summary.cost_byr'
      'FROM ORDERS '
      
        '  inner join v_clients_fio on (v_clients_fio.client_id = orders.' +
        'client_id)'
      '  inner join statuses on (statuses.status_id = orders.status_id)'
      
        '  inner join v_order_summary on (v_order_summary.order_id = orde' +
        'rs.order_id)'
      'where '
      '/*FILTER*/ 1=1'
      'order by Create_dtm')
    CacheModelOptions.CacheModelKind = cmkLimitedBufferSize
    CacheModelOptions.BufferChunks = 100
    Transaction = trnNSI
    UpdateTransaction = trnNSI
  end
  inherited actListMain: TActionList
    object actSendOrders: TAction
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1079#1072#1103#1074#1082#1080
      OnExecute = actSendOrdersExecute
    end
    object actFilterApproved: TAction
      Caption = #1054#1092#1086#1088#1084#1083#1077#1085#1085#1099#1077
      OnExecute = actFilterApprovedExecute
    end
    object actFilterAcceptRequest: TAction
      Caption = #1054#1090#1087#1088#1072#1074#1083#1077#1085#1085#1099#1077
      OnExecute = actFilterAcceptRequestExecute
    end
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
    Transaction = trnNSI
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
      '    s.STATUS_NAME,'
      '    oi.STATUS_DTM'
      'FROM ORDERITEMS oi'
      '  inner join statuses s on (s.status_id = oi.status_id)'
      'WHERE ORDER_ID = :ORDER_ID'
      'ORDER BY ORDERITEM_ID')
    Transaction = trnNSI
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
    Transaction = trnNSI
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
    Transaction = trnNSI
    Database = dmOtto.dbOtto
    Left = 736
    Top = 152
  end
  object qryAccountMovements: TpFIBDataSet
    SelectSQL.Strings = (
      'select '
      '  aos.account_id,'
      '  d.deal_date,'
      '  aos.amount_eur,'
      '  ac.action_name,'
      '  o.order_code,'
      '  ao.balance_eur'
      'from v_accoper_summary aos'
      '  inner join deals d on (d.deal_id = aos.deal_id)'
      
        '  inner join actioncodes ac on (ac.action_sign = aos.action_sign' +
        ')'
      '  left join orders o on (o.order_id = d.order_id)'
      '  inner join clients cl on (cl.account_id = aos.account_id)'
      '  inner join accopers ao on (ao.accoper_id = aos.accoper_id)'
      'where cl.client_id = :client_id'
      'order by d.deal_date desc'
      '')
    Transaction = trnNSI
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
      '  s2.status_name state_name'
      'from orderhistory oh'
      'inner join statuses s1 on (s1.status_id = oh.status_id)'
      'left join statuses s2 on (s2.status_id = oh.state_id)'
      'where oh.order_id = :order_id'
      'order by oh.action_dtm')
    Active = True
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
end
