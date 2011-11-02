inherited FormTableClients: TFormTableClients
  Left = 264
  Top = 131
  Caption = 'FormTableClients'
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlMain: TJvPanel
    inherited grBoxMain: TJvGroupBox
      inherited grdMain: TDBGridEh
        RowDetailPanel.Active = True
        RowDetailPanel.Height = 200
        RowDetailPanel.BevelEdges = [beLeft, beTop, beBottom]
        Columns = <
          item
            EditButtons = <>
            FieldName = 'CLIENT_ID'
            Footers = <>
            Visible = False
          end
          item
            EditButtons = <>
            FieldName = 'LAST_NAME'
            Footers = <>
            Width = 150
          end
          item
            EditButtons = <>
            FieldName = 'FIRST_NAME'
            Footers = <>
            Width = 150
          end
          item
            EditButtons = <>
            FieldName = 'MID_NAME'
            Footers = <>
            Width = 150
          end
          item
            EditButtons = <>
            FieldName = 'MOBILE_PHONE'
            Footers = <>
            Width = 100
          end
          item
            EditButtons = <>
            FieldName = 'ACCOUNT_ID'
            Footers = <>
            Visible = False
          end
          item
            AutoFitColWidth = False
            DisplayFormat = '# ##0.## EUR'
            EditButtons = <>
            FieldName = 'REST_EUR'
            Footers = <>
            Width = 80
          end
          item
            EditButtons = <>
            FieldName = 'TAXPLAN_ID'
            Footers = <>
            Visible = False
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
            Width = 150
          end>
        inherited RowDetailData: TRowDetailPanelControlEh
          object pcClientDetail: TPageControl
            Left = 0
            Top = 0
            Width = 765
            Height = 198
            ActivePage = tsClientOrders
            Align = alClient
            TabOrder = 0
            object tsClientOrders: TTabSheet
              Caption = #1047#1072#1103#1074#1082#1080' '
              object grdClientOrders: TDBGridEh
                Left = 0
                Top = 0
                Width = 757
                Height = 170
                Align = alClient
                DataGrouping.GroupLevels = <>
                DataSource = dsClientOrders
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
                    FieldName = 'ORDER_ID'
                    Footers = <>
                  end
                  item
                    EditButtons = <>
                    FieldName = 'ORDER_CODE'
                    Footers = <>
                  end
                  item
                    EditButtons = <>
                    FieldName = 'PRODUCT_ID'
                    Footers = <>
                  end
                  item
                    EditButtons = <>
                    FieldName = 'CLIENT_ID'
                    Footers = <>
                  end
                  item
                    EditButtons = <>
                    FieldName = 'ADRESS_ID'
                    Footers = <>
                  end
                  item
                    EditButtons = <>
                    FieldName = 'CREATE_DTM'
                    Footers = <>
                  end
                  item
                    EditButtons = <>
                    FieldName = 'STATUS_ID'
                    Footers = <>
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
            object tsClientAccountMovements: TTabSheet
              Caption = #1044#1074#1080#1078#1077#1085#1080#1077' '#1087#1086' '#1089#1095#1077#1090#1091
              ImageIndex = 1
              object grdAccountMovements: TDBGridEh
                Left = 0
                Top = 0
                Width = 757
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
          end
        end
      end
    end
  end
  inherited qryMain: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    clients.CLIENT_ID,'
      '    clients.LAST_NAME,'
      '    clients.FIRST_NAME,'
      '    clients.MID_NAME,'
      '    clients.MOBILE_PHONE,'
      '    clients.ACCOUNT_ID,'
      '    accounts.REST_EUR,'
      '    clients.TAXPLAN_ID,'
      '    statuses.STATUS_ID,'
      '    statuses.STATUS_NAME'
      'FROM CLIENTS '
      
        '  inner join statuses on (statuses.status_id = clients.status_id' +
        ')'
      
        '  inner join accounts on (accounts.account_id = clients.account_' +
        'id)'
      'WHERE '
      '/*FILTER*/1=1'
      'order by '
      '  clients.Last_name, clients.First_name, clients.Mid_name'
      '')
    Transaction = trnNSI
    UpdateTransaction = trnNSI
  end
  inherited trnNSI: TpFIBTransaction
    Active = True
  end
  object qryAccountMovements: TpFIBDataSet
    SelectSQL.Strings = (
      'select '
      '  aos.account_id,'
      '  d.deal_date,'
      '  aos.amount_eur,'
      '  ac.action_name,'
      '  o.order_code'
      'from v_accoper_summary aos'
      '  inner join deals d on (d.deal_id = aos.deal_id)'
      
        '  inner join actioncodes ac on (ac.action_sign = aos.action_sign' +
        ')'
      '  left join orders o on (o.order_id = d.order_id)'
      'where aos.account_id = :account_id'
      'order by d.deal_date desc'
      '')
    Active = True
    Transaction = trnNSI
    Database = dmOtto.dbOtto
    DataSource = dsMain
    Left = 760
    Top = 16
  end
  object dsAccountMovements: TDataSource
    AutoEdit = False
    DataSet = qryAccountMovements
    Left = 808
    Top = 16
  end
  object qryClientOrders: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    ORDER_ID,'
      '    ORDER_CODE,'
      '    PRODUCT_ID,'
      '    CLIENT_ID,'
      '    ADRESS_ID,'
      '    CREATE_DTM,'
      '    STATUS_ID,'
      '    STATUS_DTM'
      'FROM'
      '    ORDERS '
      'WHERE '
      '    CLIENT_ID = :CLIENT_ID')
    Active = True
    Transaction = trnNSI
    Database = dmOtto.dbOtto
    DataSource = dsMain
    Left = 760
    Top = 80
  end
  object dsClientOrders: TDataSource
    AutoEdit = False
    DataSet = qryClientOrders
    Left = 816
    Top = 80
  end
end
