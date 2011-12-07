inherited FormTableClients: TFormTableClients
  Left = 481
  Top = 196
  Caption = 'FormTableClients'
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inherited dckTop: TTBXDock
    inherited tlBarNsiActions: TTBXToolbar
      Images = imgListMain
      object btnAccountUserCredit: TTBXItem
        Action = actAccountUserDebit
        DisplayMode = nbdmImageAndText
      end
      object btnAccountUserDebit: TTBXItem
        Action = actAccountUserCredit
        DisplayMode = nbdmImageAndText
      end
    end
  end
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
            ActivePage = tsClientAccountMovements
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
      
        '  left join accounts on (accounts.account_id = clients.account_i' +
        'd)'
      'WHERE '
      '/*FILTER*/1=1'
      'order by '
      '  clients.Last_name, clients.First_name, clients.Mid_name'
      '')
    Transaction = trnNSI
    UpdateTransaction = trnNSI
  end
  inherited actListMain: TActionList
    object actAccountUserDebit: TAction
      Caption = #1047#1072#1095#1080#1089#1083#1080#1090#1100' '#1085#1072' '#1089#1095#1077#1090
      ImageIndex = 0
      OnExecute = actAccountUserDebitExecute
    end
    object actAccountUserCredit: TAction
      Caption = #1057#1087#1080#1089#1072#1090#1100' '#1089#1086' '#1089#1095#1077#1090#1072
      ImageIndex = 1
    end
  end
  inherited imgListMain: TPngImageList
    PngImages = <
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
        Name = 'PngImage0'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000001B64944415478DA63FCFFFF3F032580916203EA43B57D81
          B41499FA9F31D6046B65362E3C30EDEFBFDF24E964666265A88F77C862AC0CD0
          C8AE5FB07BCAA6954B4932C02F3C9AA131C13587B1D4572DB761FECE49D7CF9F
          66101413832B78FDF225C3A3FBF719F8F8F81894D5D519989899E172EF5FBD62
          D0343465684874CF632CF4522E6898BFA3FFC6F9330C4ADADA704573A74E6590
          95916190959565B872F52A43686C2C5CEE1E90AF61680234C0A39031D74DA1B8
          61DEB69E1B17CE3208888B339C3D769CC1D8CA9261EBBAF50C56401A048E01C5
          BC8302E1721F80AED33030666848F22A61CC74962D6F98B7B5E3FA395417AC5E
          B2844117C87FF4E811C3A3C78F19527272505CA069047441927705638ABD5455
          E3BCCDAD37CE9F63101015852BFAF7F72FC3FD3B7718BE7CFECC200DF48608D0
          7530F0E1F56BA0178C18EA937CAB19E3ADC5EB9AE66D6ADCB5710349B1E0E61F
          C05097E457CF186C28D03661D5AECADFBF71A783BB759D0CDFAFDF4211636464
          64B8F9ECDE79466369D6427E0E46257CB6793FFA1D9E15192B8A2E3E63D9E227
          8C409A0D880580980597010D0C0C2D7F19188CD1C5D919184E519E9928350000
          0421A2A7F0C797500000000049454E44AE426082}
        Name = 'PngImage1'
        Background = clWindow
      end>
    Bitmap = {}
  end
  inherited trnNSI: TpFIBTransaction
    Active = True
  end
  object qryAccountMovements: TpFIBDataSet [8]
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
  object dsAccountMovements: TDataSource [9]
    AutoEdit = False
    DataSet = qryAccountMovements
    Left = 808
    Top = 16
  end
  object qryClientOrders: TpFIBDataSet [10]
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
  object dsClientOrders: TDataSource [11]
    AutoEdit = False
    DataSet = qryClientOrders
    Left = 816
    Top = 80
  end
end
