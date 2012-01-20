inherited FormTableOrders: TFormTableOrders
  Left = 285
  Top = 123
  Caption = #1047#1072#1103#1074#1082#1080
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inherited dckTop: TTBXDock
    inherited tlBarNsiActions: TTBXToolbar
      Images = imgListMain
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
    end
  end
  inherited pnlMain: TJvPanel
    inherited grBoxMain: TJvGroupBox
      inherited grdMain: TDBGridEh
        AllowedOperations = [alopDeleteEh]
        Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking, dghEnterAsTab, dghIncSearch, dghRowHighlight, dghColumnResize, dghHotTrack, dghExtendVertLines]
        ReadOnly = True
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
          end
          item
            EditButtons = <>
            FieldName = 'BAR_CODE'
            Footers = <>
          end>
        inherited RowDetailData: TRowDetailPanelControlEh
          object pcDetailInfo: TPageControl
            Left = 0
            Top = 0
            Width = 671
            Height = 198
            ActivePage = tsOrderItems
            Align = alClient
            TabOrder = 0
            object tsOrderAttrs: TTabSheet
              Caption = #1040#1090#1088#1080#1073#1091#1090#1099' '#1079#1072#1103#1074#1082#1080
              object grdOrderProperties: TDBGridEh
                Left = 0
                Top = 0
                Width = 663
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
                Width = 663
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
                    FieldName = 'ORDERITEM_INDEX'
                    Footers = <>
                  end
                  item
                    EditButtons = <>
                    FieldName = 'ARTICLE_CODE'
                    Footers = <>
                  end
                  item
                    EditButtons = <>
                    FieldName = 'NAME_RUS'
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
              Caption = #1044#1074#1080#1078#1077#1085#1080#1077' '#1089#1088#1077#1076#1089#1090#1074
              ImageIndex = 3
              object grdAccountMovements: TDBGridEh
                Left = 0
                Top = 0
                Width = 663
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
      '    v_order_summary.cost_byr,'
      '    orders.bar_code'
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
    AfterScroll = qryMainAfterScroll
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
      end>
    Bitmap = {}
  end
  inherited trnNSI: TpFIBTransaction
    Active = True
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
      '    oi.STATUS_DTM,'
      '    oi.ORDERITEM_INDEX,'
      '    oia1.attr_value||oia2.attr_value name_rus'
      'FROM ORDERITEMS oi'
      '  inner join statuses s on (s.status_id = oi.status_id)'
      
        '  inner join v_orderitem_attrs oia1 on (oia1.object_id = oi.orde' +
        'ritem_id and oia1.attr_sign='#39'NAME_RUS'#39')'
      
        '  inner join v_orderitem_attrs oia2 on (oia2.object_id = oi.orde' +
        'ritem_id and oia2.attr_sign='#39'KIND_RUS'#39')'
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
      'SELECT'
      '    ACCOPER_DTM,'
      '    -AMOUNT_EUR amount_eur,'
      '    BYR2EUR,'
      '    NOTES'
      'FROM accopers ao'
      'where ao.order_id = :order_id'
      'order by ao.accoper_dtm')
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
end
