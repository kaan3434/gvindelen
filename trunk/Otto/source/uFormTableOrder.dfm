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
                Width = 959
                Height = 170
                Align = alClient
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
                Width = 296
                Height = 170
                Align = alClient
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
  inherited imgListMain: TPngImageList
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000018000000180806000000E0773D
          F80000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C0000020A4944415478DAB5934148DB5018C7FFAFCA76137AF022
          9E8A1E9481A015E660E018858ECE61652A22E869750C841D761A838163CCC0D8
          717305850D0F521D8A8A82544A05412439085B9D1EAA1ED6C30EE6248BE0F2F6
          255148D376CD7BE0837FDE4BF2BEDFEF9197C738E7B8CEC6440BDA5A1846FAAC
          DEB9D70E5AA1FE6C453497B332408FFA2F80C00E3031609A7BBE055EF0557309
          7A28230D53538F91CF23A9286A82F3CEAA824A608F204CC3F6542AF5391F8920
          D4D1818F8AA23DE33CCC64C12EC15D12B458705DD7A1691A0E23118D5E254990
          64B260ABD1FF31747E8EE158DFBBD87C3A84603088783C3EF9E4EC6CBF89F3AF
          24004BCF0AEF73095CD7F3B056DFD6BD3E691846E681696E444D13D28272F0A5
          D4FCD6A7B99AF7C705B64202480B2AC1FF18F892D90DCC64D500A405FF8313CF
          864B0BAAC1AD39D2023F7069815FB89440042E2C10850B0944E1C7BF8023CA49
          8181CE019A09402719ABE50422F0CCAE93CA9FD823F00BAF062E127CFBE008E8
          DA7EA30E1377EE8DC700A32CDC2FB848F06210686AB457FFF2E92BF56D3AAD20
          1442115C145C24682678E211BB7FBB3BF1E656F861D7E96981E063367C73C781
          CB365B407DCDF37EB6F05A59EE5D594CE6B6B3ABB9EF2798DEDEE39BD61CF7FC
          0ABD775C22A8A7FC1E8DB2EC8F232CAA077CEDB2E02FC5BCECAD5CB8C6EE98AE
          9415D4516E526A9DBDB6E1DC53582D573525827F667F3CEF0C515AD100000000
          49454E44AE426082}
        Name = 'PngImage4'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000018000000180806000000E0773D
          F80000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C0000034C4944415478DAB5955D48936114C78F6ED2CCA9892282
          1B0AD6C582BC29FA24ADCC5A5F96D5455D653254D4648E3987D3BD6C3A9B53C6
          94294E54CCEBB2B2EFEF2FFAAE1B831112222ADE7821E2B773B3735EF6BC4C88
          94D73A70789EF7FFBC3BBF9DF3BCE779C2565656E07F5A181A8D16F4ED34B968
          363FDB48C09B566B7670EA45E718E0566D6DEDF9E5E565E0386E43FFD862B180
          542A859A9A9A3E7CBCC0007D66B339777E7E1EAEDBED101059B6708C959991F1
          332B2B4B65B55A09709E016E23F11C016C08F00702A20092F07030198D101919
          0958913B28E532C05D93C9944380BA8606A05289312A4D7565250FB0D96CFD28
          9D6580FEAAAAAA3304B060063E9F4F1420222202B86006F5F5F5F750CA6180FB
          46A3F1140138CC607161411460934C0696600676BBFD014AA719E0A1C1603841
          00330268146314D81A04381C8E47289D6480C77ABDFE3805AE7638606E765614
          60735414D4190C3CA0A9A9E9094A6A0678AAD3E9B219604624401E02703A9DD4
          B0C718E0B956ABCD22C095921250A4A68A028C0D0FC38DD6561EE072B95EA074
          94015E9695951D165BFB3FED454B4BCB2B9C1E6180D7A5A5A599FF12E076BBDF
          E0F41003BC2D2E2E3E488081810158EF091BFCED2A4B4F4FE7016D6D6DEFF031
          8301DE171515ED2780D7EBA5F4D66C366A2A2C2BA4A4A408DAC8C808A8542A1E
          D0DEDEFE01A5030CF0B1A0A0602F01060707B1491C6BF60205311A0DA0542A05
          6D7C7C1CD2D2D2F8B58E8E8E4F28ED6380CF1A8D6637051D1A1AC223D7C603F4
          7A2D482412F0FBFDD0DAEA5905A5201C6782E4E464419B9898008542C1AF7576
          767E41690F037CCBCFCFDF4901464747F19F717CB0E66607FF32CD99160AB0DB
          2D9094942468535353909090C0AF7577777F476917DBA501DCE41D9393937C9A
          5AAD890FE6F138412E97C3CCCC8CA085025C2E1B2426260ADADCDC1CC4C4C430
          C00FDA73062843BF861BBD95F6A0B0B0820FD6DBEB86E8E868989E9E16B45080
          C7D308F1F1F182B6B4B404323CF068ADA7A7E7174ADB42BF331D7AB95AAD56E4
          E595E39DE0C3975C101B1BCBA7AED154F01A33A93402EBDC087171718216C08B
          2A0A8F0BFAC2BABABAC6505212600B7A5C70BC847E152F8E9EF5F4015E4C797F
          59FE8A7E990032CA383886AD23EE7ACC8F4EF55CFC0D7D0A6A7067B32AFF0000
          000049454E44AE426082}
        Name = 'PngImage3'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000018000000180806000000E0773D
          F80000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000003514944415478DAB5964D48545114C7CF73C64945C68F85
          642E549070D1C2B8198365616608297DA112B55082C985B9D0851B172EDC0822
          64AE060523622CB0480C06135A0C6198F62186D4C210223F26C749C4AF71663A
          F7BEF35EF73D9F632DBA70E6E3CEF9FF7FF7DD73E6BEA7C46231F89F4379CC5F
          3012D4A8C4B74E0C4F540D8898820F9B2948EB0635DA51E7E3DA980920CCEBDA
          DAD893AEAE690DF29700617EBDA5853DEBE999D620324098DF44F3C5C545C8CE
          CE062F412226880540985F6D6E66A150089C4E278CF4F50908027CCA23553375
          1BCDE7E7E7F5BDCBCDCD056F77F73E085898573736B2D5D5555DCB21BE8101AE
          3DA53C54E7DC4873DF6A6D657373737A624141013CEDED3540C0645E595FCF56
          5656744D5A5A1ABCF67AA771573C5C27007CAFA204A96B6A62B3B3B306C88BFE
          7E1D029279596DADC19CAF7C62644498277073BEFD1A202241AE343418AE242F
          2F0FC686860484A6DC67AAAB592010D073525353E1FDF8B86E6EA3E6310028C4
          EA2ED5D4186AC20BEF1F1DE510385D51C182C1A0FE5B4A4A0ACCF8FD62013632
          8F0710107E25655555A2ABB4919E9E0ED16814D6D7D7F53987C30133131362E5
          B2795CC09E04395B5E2EDACF6AD86C36F83439A99BDB4D2D1C1720438A5D2EF6
          0B219B9B9B100E8745F02B09058306734BC05DFAE090229192ED548F732525EC
          8B54746D2CAFAD897DDF5303C218BB52C40E0108F3D2A222F67D61010E1ADF24
          C8BF0084F9F9C242F6737959374B4A4E86EDADAD7D90CF044180E7500037C7EF
          EE8BF9F96C432AAECD6E8737818068535746063343DE22246682EC0368E65539
          396C070BAA0D4551608C0A0AAAD05D610179658218009A796D56168B84C306E1
          300AB9792201C2D45D372C20C3124406883D6FC8CC64E63BDCA064EEA0B95D09
          526F0119A49A709072479D9BBA6791F880CCB1A33CFC487B47F3C51859EA7F45
          400ED2023FAEF99DE628DE7030B1B34D4AEC227334F67CC4EF3F4C06C7308A54
          90805868DB97F80D0754009C40082677766062072670633CB43D4B107F90D6CD
          4192B61DB5BEA53FF585640CE749800BC7019A71B5CFFD002F69BBB72968EB45
          73F093E008E992F8E75280CB7855D7BE02DCFF800D85731B5CA750B29D04DA1F
          99CF6B0F15D2D104DAC34202E9B453457BB888D2227668417BBF017DE6B9A038
          C4C6EF0000000049454E44AE426082}
        Name = 'PngImage2'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000018000000180806000000E0773D
          F80000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000004594944415478DA95967B4C9B5518C69F53CA2714695120
          2244CD44E7F8E61A2F33739B0A6258421017CC10293019DA2DD1C435048911FF
          703146F9473258245B45DCC0659868E6AC9288B6C56C5E129211748B73402877
          88DC5A5AA06BF97CCFA1608116F0244F7A722EBFE7F47DDF735A8630CD7090E1
          993DC0E30FAF0CBD44FAD2EF0766DD805A0D4447A1606E1E2D3E1F70FA9B4362
          D1C2C2025C2E1706070731373707160A6C7861A91F190968A200550489E1EB45
          052FD27ECC2F88E9125211E90B5253E3F787A028CA6E82EE713A9DD2E8E8E857
          D4EF67A1C0C1ED3649181918C3CB8A820BB76EE13C9D1ADCC8E3515ED5685843
          7B573A46271304DC62B19C9A9A9A825EAF3FE1F3F9DE63E1C0CB4D1D8162950A
          86DDFB8DD91D57CCAD8B8B38EFF3A399CF4D4E0257AEA763C2B51ADEDBDB8BCC
          CCCC0FFD7EFF3BEC929985631F2615F3CE5399C6ACE5C1CB56735BA0DBDCD523
          9FEBEC4E0B09A7311B85AC8D593E5D6DC0E3CE2512E6A530B8955728F6A5CF65
          1FCDF8A9F58C9D72F179849A9DBD6001BA7AD232B76DDB96160AFEE84EA54DBF
          43016B6D5C6D20113C562BBA05A49681019E54A58CE27F84F2D0F8771F3E3B51
          2BE65F27BD91959525B7B4B4AC837FF2BE5F14C33A031177357649123EF07A51
          4525F8C7D43499CC2BBF92C1DE236FFF07AFACAC94474646303434848E8E0E01
          DFF590D2F6F1BBFE95125E17A240F915EF7BD678E0179BF9071E6BA70B4D4E97
          72F43B3BCE7C6B5D82575454C8548A181E1E86D56A75A8D56A138D5FBC64F6AF
          2A6176F1F4FA6F4097E911AF57A99524F66644043A7BC7F6C36ABB0C8B6D095E
          5E5E2E8F8D8D819F9EC369EC646262620D95260EEC9BC4FD7775AE94F03A03AA
          734CCF28BC6BFC6BEC79B3A2DE4E498F447575B5809B4C26797C7C1CFCF41CAE
          D3E94EA6A6A6D624272743A3D1202626467CDE73C755D001C1F2F3F343D6A84A
          A5B2C7C6C6A66BB55A61C09F809999194C4C4C80578C780628297C2E2A2A4A40
          830D68AC9D1819ACB0B030DC3DC8206006C10E4E4F4F6FAFAFAFD7A4A4A4C0ED
          9E454F4F0F06060641978E80B1888B8B874E7727AAAADEB2EBF5723B379024C9
          4E0C7BD85B1668222C3939393219801BB85C4E7477DF447FFF20E54A4174F4ED
          D06A970C4CA663BFDFB871EDC9BCBC3C6E20006C33B8D16894FBFAFAD0D0D0B0
          A9C1F1E3C73ADADB7F7C82AF5B0E3DDB085E565626F3B85332919D9D8DA4A424
          82FAE170384479528C09AC43424202E2E3E3515757F733ED4B0F06B170F0D2D2
          52999E5D50FC61B3D9BC942B690B06BFD1DEBD1B1908784949893C3B3B8BC0E9
          1D542D6A3248D982C155DAFF583803012F2A2A1270FEABB47C8948AF190C0679
          3383DADADAEBB47667280301A753CA6EB71BDC20085E43BA49060F6CC1A09BD6
          3E18CAE05A414181ECF178C00DD6C0797390C1BD5B30E8A7B5F7AD35A05F5CFC
          999B9BBB23087E2A60802083BBB76030426B93D71A24919E267D14306B223587
          48FE616CDECE91CE92E881C73F24273788234563E34BF77F1A7F29E96F013CA4
          857F014986658C8E8AE9B80000000049454E44AE426082}
        Name = 'PngImage0'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000018000000180806000000E0773D
          F80000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000003FC4944415478DABD957F6C144514C7DF6EB99E77881E85
          685BD236066CA1460C59028116AA557BA934D01E36A489C6848668342142FD83
          3F1AF50FE00F92264248087F80F10F24D1145B4348134E8948282A47522CA5D0
          DA1F39E8D1ABD7EBEDDEDDEEDEEECEF866BBDEF5AE4B4E637036EF766FE6CDF7
          336FE6ED5B8E520A4FB271FF0B80E3B87F376B970BA0C56D29A4AD0A7FCF0181
          C360D01ED029D07DB339802A0740E51280FB3AC03DCD5E78A72B6789683CB712
          EF5FEDAEF3BDD67DA57B08284274DA930130E1269CB80EC5D98E11B461045C54
          0046757BE10CC08976BAF6E59AC6CAF2CAE758D7D9DEB301064140CF3CE0D472
          B60A8002C8003044D0D09660BFD3660B59D4F35B73A4A2B8624FDD86EDAB4551
          049EE7510BD40B97BB07E907D18DF901E80F853600E6CF437BD1B2A283DEADDE
          B5897882D7340D0825E4C640FF704C8A1DA51F45CFFD1740BDABD0D5E5ADF156
          EB29BD505114B3FBCEC8E01FA1F0D4D7F8F829DD3F07F9012C8D1D5CEEB65415
          F0055FD66FAE5FEF743CB554922473F8E1F483A9D1B1FB7E1CDF877F53F4E3D8
          3F0068241BC0839931B5EBB76DF63CED593136350EC420A0A8C9E86470FC26E5
          E01DF40933773B40338A7722E43C02BA6C0066C6949756BCB1B15C5875F5EE35
          3088817A9C3C371BF9DD308C761C1F04CB9D7E2266019A51B8B3B5A155F8B6EF
          9B8009D11884FC7DA0AC1D292A5AB9A7E995C6D57DC37ED0740DBB795D0A47EF
          A654B51385BF5F784CF490940698E2BB1BDE16262626A0ACAC0C7AFA2E5810D2
          656E5B01D7E176BBF7B66C695E7B65F2675E5665D4E3A81C1247E4B87C0649C7
          2027173280939E9BCD6FFA846030981E2C2929818B7DBD01CCBBF30848381C8E
          F77D75BE97AECFFCEA88CB71260EA96939187F14BB84EE1F5A27970DF82C6E01
          8E7B3A50A8ADA96197100A85CC410D2FE77227FC76F97A804D6D79DD577D4BB9
          ED1293A2396E44B43FC5E1483FAEFC5D8C2E66F79267005F78306B0842A0CDDB
          B0430847C210E242A0E255FA6C29AC73BD08B7C4DB30979CC360F08A1989D82F
          3303D420EFA1F8A8753E8B0147930B00EC30756A4236BD55238C2447D28E6E87
          1B644D36C541A19AF84378C848680751FCC7B4D30D03A05FCF0630ED2C809996
          F39035ADD542448964971F03A874297C4F0BAB2730754F9975CA467831A0112B
          A581E204AD162BAB6C74800E6D65ED95425C8FA727C8FEE8B832247D87E7DB01
          33D8D16B2FBC1890FBC1D98A657B038F10DA567C608DA012155201693AE19FFD
          091ED1BD30401378877CCD0EC01E3004ACF158E2C0CBEF87626EC78ACE1784D9
          CFC7AE523F3D00D3749225518E11EB4E2D7B2C80E503FBB23C83B68C9D2FBCCA
          B5C2F3E085003D06A370C7CC602C6439A65966E403644730FFCC2F5819B1597D
          FE089E64FB0B25534DEFEBACD8E50000000049454E44AE426082}
        Name = 'PngImage1'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000018000000180806000000E0773D
          F80000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000003624944415478DAB5957B48535118C0CFBD739BD74D2475
          05DA7F4E5DD381862222468294A0A1621819FE2392A65108F984A02415349202
          5757C4089D912825A4494846A221422AE99A8FFE30CAD4B589E8DCE6B4F59D4B
          BB8FDCC4091DF8F8BE73EF39E7F73DCE83703A9DE87F360203B26A6AB80F0481
          7C7C7C12C1D41C755158F3754F6DEDB22740624976764D6A5C5C86B7D1596C36
          D3EDB6B6074B2B2BBA9775754B2CE04265257FDCD59E8606DAB1B3E3D5E21035
          7A3A30F0ECCDD8D83D9224175FD5D773293A5F5626003C0780D566F30A40F9FA
          A2CBD5D545A448D44A429AFB9B9A38C0D9D2520140D7D8486F6D6D790590CBE5
          E84A45451198ADB8FFBEA585032416160A002F9A9BE9CDCD4DA4D7EB51505010
          32994CAC56ABD56E01FEFEFEE85259190BF8D8D6C6014EE7E70B007D5A2D03D8
          DDDBDB9F6B91C82320B3A484057CEAE8E000EADC5C01E06D7B3B0358331A05DE
          7BD2A7542A0670AEA08005E8BBBB39405866A600F0A1AB8BA981BB08DC351C15
          AEC199BC3C16F0B5AF8F039C4C4B1300267A7B698BC582F473732828301099CC
          E603F5098502C96432149F93C302BE0F0E7200454A8A0030D3DF4F5BB6B7BD8A
          40E6E787A2D3D359807178980304242509008B4343B4D56A453FA106BF20C7C1
          90EB83B4066A40511452A6A6B2808DD1510E40C5C70B003F46469883B673C808
          2410013E68A1C9C92CC03A31C101C431310280717C9CB6DBED68CA60400AF0D2
          085E1EA443A10652A9142912125880636A8A0390D1D17C40D1C6E4E4133BDC45
          B6DD5DB71EFBC2BDF36F934A24282036B6184C1AF77FCFCC70002232923FF6DA
          D6ECACD6E170A06FABAB680DBC3C0E5EF2759C9BD32C168B913C2AAA04CCC7B8
          EF841DC801C2C3F9636F580D8687BB1EBCF7B893202A4AA5BA09E62306B0B0C0
          032895FCB1B7ECF3F34D7B872CB0AB89A0D0D288887230EF3380C5451E00F630
          111282FE3E2FD5EBD3D3F5CC77B876B1902E4D92AC4D30B3091680FF89C3C3F1
          CBD5B01F802784856180E66246466D797171960F9E00614B40707EA520122CB8
          0F825322E20108182F522AEF8079172D2F23271C542120345415A5D194BED3E9
          F283030303BC490FC6683B3B47AE5755D523B379D00987D4F5DCBA00C7088A8A
          128584647895785E735A2C5FF656563E83B90E62867537F8000A6C3F10E95101
          2E0E087E6BADB02EF3E6FE01500EB9E0512528EC0000000049454E44AE426082}
        Name = 'PngImage5'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000018000000180806000000E0773D
          F80000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000004594944415478DAB5567F4C1B551CBF77D7EB51A0156881
          324A472AA323A8281096C15C233818B845D148B6E86012A598814A9824DB98CB
          5CC202D1107F455D1C8BC54130330AB1A16C0DE167B02D8DF0CF88D5196661C8
          886B296039E0EEFC1E2BA476F442667CC927DFCBFB7EDEE7F3EEBDEFBB7788E3
          38ECFF6C285842ABD5AE0321841104B11E01D1801448C702643EAA07300B139D
          00CCF113661806E3636767E783061BC29B33B86F4041CC92C7C6673C96A54B4E
          783465874A191D19152EA616E6DD9EF1F1F1C9E17EF3CDBF66A7ED206C0503FA
          018340613F035E3C3FFDE9827D99BAA2A74831258E08158BE2224342FD79B767
          DDAEDEEE2EBB7DD03408E2D701F4BA417272322697CB318542116CB57499FB0F
          3EB7F7407126C2719CC011A689090F171108F727AD311C7B6BD6B330DCF3FDA8
          ADBFFB47E8EAEFEAEAC250616161F00D422856A1541D3BF2E6E97C920A11F37D
          520949A8A224615BF1A7EE7997E61716E9B6CF1A4C7333CE56A3D1388B0A0A0A
          848A20F7C04BC78F3CB9F7192D2CE9B6CA0D26856EDAFA7E3376B45C35994CBD
          282F2F4F887FECC4B98F4A64910AD98601096B2497526418459062114EF893E9
          5576EDF7BB8B7FD38B2E6FF3D9AA36B3D9DC8A743A9D9041D5B94FDA5F6611BE
          795C34B1E1615480F04663588E75CC2C2C4A48449EA92C69EFEBEBFB14E5E4E4
          0819BCD570E95AC92A8B339CCF22255E26131A3031EDF1845378C8C9F2E2B6A1
          A1A18F5156569610FFB5F79A5B8E8645C448D61896D9AE015A76B3A7AB4A5B2D
          16CB15949E9E2EC42F38FAC6DBAFEE7FF6D06E8F777589EFD0EE9049A152B7FC
          02B0B04F93734BF4F890C979E5F3E616BBDDDE83D2D2D2840CE294AA9D15EF7F
          F8C5A1558C5CF3AE30349C81508AC4455B9157D658C6E55920EA6BF45D779CB7
          BF1C1B1B9B41D9D9D94206916EB7BB2CB7A838ADB2FA64E6FC32B314114A628F
          8492E240228E10CEB24CC8074D8D233F7CDB7A8D2449A3C3E1C0840CA25896D5
          2995CA83C5C52F560C587F6EAFAE79F709A954864319712CCBADC2AE73B05C04
          942E452F2F110D0D0D96B6AF2FDFA028AA432412799D4E6750030588E7AA5409
          B9A5A565FAA6A6C6D6D1519B232151237FA5ECF5E4E70F1725A8D50951B01168
          7A6ADA7DE37ACFF4E5AF2E4DFCEAF8A51F84BB653299172216CC2006C4F3D5EA
          9DFBCACB2BF4172F5E30D86CD6DE95951523E42400BEEC12F937F4F1EF012601
          5680532C1663608005335082786162A2664F6565B5FEFCF933068BE5A72110EF
          84DC5D6C1B4DC8200EC40F6B3449E9D5D575FAFAFA5AC3C8C8B015C4BF83DC9F
          FC39E3EF8687358807F1179292B48FD7D69ED5D7D59D300C0F0F8E81780708DF
          811CF63057EBFAA452535331A954FACEAE5D29BB4F9DBAA0AFA9A9300C0EF64D
          D034FD0D084FFD973B7BDD002291919151DBD1D1D3585575DC3030D07BCBEBF5
          5E85E41F1B3CFF31027D81CF9B06D16AB57A0FDCA3992E974B04E266484CF9C8
          2C80F18BC1C0FAB031E65F06FCC78B3F992476FF2F830B002B002EE099F37F0B
          DEE01FDF3D16EF5F8BE1360000000049454E44AE426082}
        Name = 'PngImage6'
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
    Left = 733
    Top = 151
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
    Left = 784
    Top = 200
  end
end
