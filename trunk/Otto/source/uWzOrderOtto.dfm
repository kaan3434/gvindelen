inherited WzOrderOtto: TWzOrderOtto
  Left = 245
  Top = 160
  ActiveControl = btnClientPageFirst
  Caption = #1047#1072#1103#1074#1082#1072' OTTO'
  OnCloseQuery = FormCloseQuery
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited wzForm: TJvWizard
    ActivePage = wzWPageWelcome
    DefaultButtons = False
    object wzWPageWelcome: TJvWizardWelcomePage
      Header.Height = 0
      Header.Title.Color = clNone
      Header.Title.Visible = False
      Header.Title.Text = 'Welcome'
      Header.Title.Anchors = [akLeft, akTop, akRight]
      Header.Title.Font.Charset = DEFAULT_CHARSET
      Header.Title.Font.Color = clWindowText
      Header.Title.Font.Height = -16
      Header.Title.Font.Name = 'MS Sans Serif'
      Header.Title.Font.Style = [fsBold]
      Header.Subtitle.Color = clNone
      Header.Subtitle.Visible = False
      Header.Subtitle.Text = 'Subtitle'
      Header.Subtitle.Anchors = [akLeft, akTop, akRight, akBottom]
      Header.Subtitle.Font.Charset = DEFAULT_CHARSET
      Header.Subtitle.Font.Color = clWindowText
      Header.Subtitle.Font.Height = -11
      Header.Subtitle.Font.Name = 'MS Sans Serif'
      Header.Subtitle.Font.Style = []
      Header.ShowDivider = False
      Panel.Visible = True
      VisibleButtons = [bkNext, bkCancel]
      Caption = 'wzWPageWelcome'
      WaterMark.Visible = False
      DesignSize = (
        1016
        479)
      object btnClientPageFirst: TButton
        Left = 192
        Top = 104
        Width = 153
        Height = 25
        Action = actClientPageFirst
        Anchors = [akLeft]
        TabOrder = 0
      end
    end
    object wzIPageOrderItems: TJvWizardInteriorPage
      Header.Title.Color = clNone
      Header.Title.Text = #1040#1088#1090#1080#1082#1091#1083#1099
      Header.Title.Anchors = [akLeft, akTop, akRight]
      Header.Title.Font.Charset = DEFAULT_CHARSET
      Header.Title.Font.Color = clWindowText
      Header.Title.Font.Height = -16
      Header.Title.Font.Name = 'MS Sans Serif'
      Header.Title.Font.Style = [fsBold]
      Header.Subtitle.Color = clNone
      Header.Subtitle.Text = 'Subtitle'
      Header.Subtitle.Anchors = [akLeft, akTop, akRight, akBottom]
      Header.Subtitle.Font.Charset = DEFAULT_CHARSET
      Header.Subtitle.Font.Color = clWindowText
      Header.Subtitle.Font.Height = -11
      Header.Subtitle.Font.Name = 'MS Sans Serif'
      Header.Subtitle.Font.Style = []
      Panel.Visible = True
      Caption = 'wzIPageOrderItems'
      OnEnterPage = wzIPageOrderItemsEnterPage
      OnNextButtonClick = wzIPageOrderItemsNextButtonClick
      object pnlCenterOnOrderItems: TJvPanel
        Left = 0
        Top = 70
        Width = 1016
        Height = 409
        HotTrackFont.Charset = DEFAULT_CHARSET
        HotTrackFont.Color = clWindowText
        HotTrackFont.Height = -11
        HotTrackFont.Name = 'MS Sans Serif'
        HotTrackFont.Style = []
        Align = alClient
        BorderWidth = 4
        Caption = 'pnlCenterOnOrderItems'
        TabOrder = 0
        object grdOrderItems: TDBGridEh
          Left = 5
          Top = 31
          Width = 1006
          Height = 373
          Align = alClient
          AutoFitColWidths = True
          BorderStyle = bsNone
          DataGrouping.GroupLevels = <>
          DataSource = dsOrderItems
          Flat = True
          FooterColor = clWindow
          FooterFont.Charset = DEFAULT_CHARSET
          FooterFont.Color = clWindowText
          FooterFont.Height = -11
          FooterFont.Name = 'MS Sans Serif'
          FooterFont.Style = []
          FooterRowCount = 1
          Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
          OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghEnterAsTab, dghRowHighlight, dghDialogFind, dghColumnResize, dghColumnMove, dghExtendVertLines]
          RowDetailPanel.Active = True
          RowDetailPanel.Height = 200
          RowDetailPanel.Color = clBtnFace
          STFilter.InstantApply = False
          SumList.Active = True
          SumList.ExternalRecalc = True
          SumList.VirtualRecords = True
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          OnColEnter = grdOrderItemsColEnter
          OnEnter = grdOrderItemsColEnter
          OnRowDetailPanelShow = grdOrderItemsRowDetailPanelShow
          Columns = <
            item
              AutoFitColWidth = False
              EditButtons = <>
              FieldName = 'ARTICLE_CODE'
              Footers = <>
              Tag = 1
              Title.Alignment = taCenter
              Width = 102
            end
            item
              AutoDropDown = True
              AutoFitColWidth = False
              EditButtons = <>
              FieldName = 'MAGAZINE_NAME'
              Footer.Alignment = taRightJustify
              Footer.Value = #1048#1090#1086#1075#1086':'
              Footer.ValueType = fvtStaticText
              Footers = <>
              Title.Alignment = taCenter
              Title.Caption = #1050#1072#1090#1072#1083#1086#1075
              Width = 270
            end
            item
              EditButtons = <>
              FieldName = 'PAGE_NO'
              Footers = <>
              MinWidth = 22
              Title.Alignment = taCenter
              Title.Caption = #1057#1090#1088
              Width = 27
            end
            item
              EditButtons = <>
              FieldName = 'POSITION_SIGN'
              Footers = <>
              MinWidth = 16
              Title.Alignment = taCenter
              Title.Caption = #1055#1086#1079
              Width = 21
            end
            item
              AutoFitColWidth = False
              EditButtons = <>
              FieldName = 'DIMENSION'
              Footers = <>
              Tag = 1
              Title.Alignment = taCenter
              Width = 50
            end
            item
              AutoFitColWidth = False
              EditButtons = <>
              FieldName = 'PRICE_EUR'
              Footer.DisplayFormat = '#0 '#1096#1090'.'
              Footer.FieldName = 'AMOUNT'
              Footer.ValueType = fvtSum
              Footers = <>
              Title.Alignment = taCenter
            end
            item
              AutoFitColWidth = False
              EditButtons = <>
              FieldName = 'WEIGHT'
              Footer.DisplayFormat = '# ##0 '#1075
              Footer.FieldName = 'WEIGHT'
              Footer.ValueType = fvtSum
              Footers = <>
              Title.Alignment = taCenter
              Title.Caption = #1042#1077#1089', '#1075
              Width = 50
            end
            item
              AutoFitColWidth = False
              EditButtons = <>
              FieldName = 'COST_EUR'
              Footer.DisplayFormat = '0.## EUR'
              Footer.FieldName = 'COST_EUR'
              Footer.ValueType = fvtSum
              Footers = <>
              ReadOnly = True
              Title.Alignment = taCenter
              Title.Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100
            end
            item
              EditButtons = <>
              FieldName = 'NAME_RUS'
              Footers = <>
              Tag = 4
              Title.Alignment = taCenter
            end
            item
              EditButtons = <>
              FieldName = 'KIND_RUS'
              Footers = <>
              Tag = 4
              Title.Alignment = taCenter
            end
            item
              EditButtons = <>
              FieldName = 'STATE_NAME'
              Footers = <>
              ReadOnly = True
              Title.Alignment = taCenter
              Title.Caption = #1044#1086#1089#1090#1091#1087#1085#1086#1089#1090#1100
              Width = 150
            end
            item
              AutoDropDown = True
              EditButtons = <>
              FieldName = 'STATUS_NAME'
              Footers = <>
              ReadOnly = True
              Title.Alignment = taCenter
              Title.Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077
              Width = 100
            end
            item
              EditButtons = <>
              FieldName = 'STATUS_DTM'
              Footers = <>
              Title.Alignment = taCenter
              Title.Caption = #1054#1073#1085#1086#1074#1083#1077#1085
              Visible = False
            end>
          object RowDetailData: TRowDetailPanelControlEh
            object imgArticle: TJvImage
              Left = 819
              Top = 0
              Width = 154
              Height = 198
              Align = alRight
              AutoSize = True
            end
            object grdArticles: TDBGridEh
              Left = 0
              Top = 0
              Width = 819
              Height = 198
              Align = alClient
              AutoFitColWidths = True
              DataGrouping.GroupLevels = <>
              DataSource = dsArticles
              Flat = True
              FooterColor = clWindow
              FooterFont.Charset = DEFAULT_CHARSET
              FooterFont.Color = clWindowText
              FooterFont.Height = -11
              FooterFont.Name = 'MS Sans Serif'
              FooterFont.Style = []
              Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
              OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghPreferIncSearch, dghRowHighlight, dghDialogFind, dghColumnResize, dghColumnMove, dghExtendVertLines]
              ReadOnly = True
              RowDetailPanel.Color = clBtnFace
              SortLocal = True
              STFilter.InstantApply = True
              STFilter.Local = True
              STFilter.Location = stflInTitleFilterEh
              STFilter.Visible = True
              TabOrder = 0
              TitleFont.Charset = DEFAULT_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -11
              TitleFont.Name = 'MS Sans Serif'
              TitleFont.Style = []
              OnDblClick = grdArticlesDblClick
              OnKeyDown = grdArticlesKeyDown
              Columns = <
                item
                  AutoFitColWidth = False
                  EditButtons = <>
                  FieldName = 'ARTICLE_CODE'
                  Footers = <>
                  Title.Alignment = taCenter
                  Title.Caption = #1040#1088#1090#1080#1082#1091#1083
                  Width = 70
                end
                item
                  AutoFitColWidth = False
                  EditButtons = <>
                  FieldName = 'MAGAZINE_NAME'
                  Footers = <>
                  Title.Alignment = taCenter
                  Title.Caption = #1050#1072#1090#1072#1083#1086#1075
                  Width = 320
                end
                item
                  AutoFitColWidth = False
                  EditButtons = <>
                  FieldName = 'DIMENSION'
                  Footers = <>
                  Title.Alignment = taCenter
                  Title.Caption = #1056#1072#1079#1084#1077#1088
                  Width = 50
                end
                item
                  AutoFitColWidth = False
                  EditButtons = <>
                  FieldName = 'PRICE_EUR'
                  Footers = <>
                  Title.Alignment = taCenter
                  Title.Caption = #1062#1077#1085#1072', EUR'
                end
                item
                  AutoFitColWidth = False
                  EditButtons = <>
                  FieldName = 'WEIGHT'
                  Footers = <>
                  Title.Alignment = taCenter
                  Title.Caption = #1042#1077#1089', '#1075
                  Width = 50
                end
                item
                  EditButtons = <>
                  FieldName = 'AVAILABILITY_TEXT'
                  Footers = <>
                  Title.Alignment = taCenter
                  Visible = False
                  Width = 150
                end
                item
                  EditButtons = <>
                  FieldName = 'COLOR'
                  Footers = <>
                  Width = 100
                end
                item
                  EditButtons = <>
                  FieldName = 'DESCRIPTION'
                  Footers = <>
                  Width = 200
                end
                item
                  EditButtons = <>
                  FieldName = 'STATUS_NAME'
                  Footers = <>
                  Title.Alignment = taCenter
                  Title.Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077
                  Width = 150
                end
                item
                  EditButtons = <>
                  FieldName = 'STATUS_DTM'
                  Footers = <>
                  Title.Alignment = taCenter
                  Title.Caption = #1054#1073#1085#1086#1074#1083#1077#1085
                end>
              object RowDetailData: TRowDetailPanelControlEh
              end
            end
          end
        end
        object dck1: TTBXDock
          Left = 5
          Top = 5
          Width = 1006
          Height = 26
          object tbrBarOrderItems: TTBXToolbar
            Left = 0
            Top = 0
            Caption = 'tbrBarOrderItems'
            DockPos = -8
            Images = imgListOrderItems
            Stretch = True
            TabOrder = 0
            object btnOrderItemDublicate: TTBXItem
              Action = actOrderItemDelete
              DisplayMode = nbdmImageAndText
              ImageIndex = 0
            end
            object btn1: TTBXItem
              Action = actOrderItemAnnul
              DisplayMode = nbdmImageAndText
              ImageIndex = 0
            end
            object btnOrderItemDelete: TTBXItem
              Action = actOrderItemDublicate
              DisplayMode = nbdmImageAndText
              ImageIndex = 1
            end
            object btnCheckAvailable: TTBXItem
              Action = actCheckAvailable
              DisplayMode = nbdmImageAndText
              ImageIndex = 2
            end
          end
        end
      end
    end
    object wzIPageOrder: TJvWizardInteriorPage
      Header.Title.Color = clNone
      Header.Title.Text = #1047#1072#1103#1074#1082#1072
      Header.Title.Anchors = [akLeft, akTop, akRight]
      Header.Title.Font.Charset = DEFAULT_CHARSET
      Header.Title.Font.Color = clWindowText
      Header.Title.Font.Height = -16
      Header.Title.Font.Name = 'MS Sans Serif'
      Header.Title.Font.Style = [fsBold]
      Header.Subtitle.Color = clNone
      Header.Subtitle.Text = 'Subtitle'
      Header.Subtitle.Anchors = [akLeft, akTop, akRight, akBottom]
      Header.Subtitle.Font.Charset = DEFAULT_CHARSET
      Header.Subtitle.Font.Color = clWindowText
      Header.Subtitle.Font.Height = -11
      Header.Subtitle.Font.Name = 'MS Sans Serif'
      Header.Subtitle.Font.Style = []
      OnEnterPage = wzIPageOrderEnterPage
      OnNextButtonClick = wzIPageOrderNextButtonClick
      object pnlLeftOnOrder: TJvPanel
        Left = 0
        Top = 70
        Width = 390
        Height = 409
        HotTrackFont.Charset = DEFAULT_CHARSET
        HotTrackFont.Color = clWindowText
        HotTrackFont.Height = -11
        HotTrackFont.Name = 'MS Sans Serif'
        HotTrackFont.Style = []
        Align = alLeft
        BorderWidth = 4
        Constraints.MaxWidth = 390
        Constraints.MinWidth = 390
        TabOrder = 0
        object grBoxProductOnOrder: TJvGroupBox
          Left = 5
          Top = 5
          Width = 380
          Height = 399
          Align = alClient
          Caption = 'grBoxProductOnOrder'
          TabOrder = 0
          object lblVendor: TLabel
            Left = 8
            Top = 24
            Width = 81
            Height = 19
            AutoSize = False
            Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
            Layout = tlCenter
          end
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
          object lblCreateDate: TLabel
            Left = 8
            Top = 96
            Width = 89
            Height = 19
            AutoSize = False
            Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103
            FocusControl = dtedCreateDate
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
          object lcbVendor: TDBLookupComboboxEh
            Left = 104
            Top = 24
            Width = 121
            Height = 19
            AlwaysShowBorder = True
            EditButtons = <>
            Flat = True
            KeyField = 'VENDOR_ID'
            ListField = 'VENDOR_NAME'
            ListSource = dsVendors
            TabOrder = 0
            Visible = True
            OnChange = lcbVendorChange
          end
          object lcbProduct: TDBLookupComboboxEh
            Left = 104
            Top = 48
            Width = 241
            Height = 19
            EditButtons = <>
            Flat = True
            KeyField = 'PRODUCT_ID'
            ListField = 'PRODUCT_NAME'
            ListSource = dsProducts
            TabOrder = 1
            Visible = True
          end
          object lcbTaxPlan: TDBLookupComboboxEh
            Left = 104
            Top = 72
            Width = 242
            Height = 19
            EditButtons = <>
            Flat = True
            KeyField = 'TAXPLAN_ID'
            ListField = 'TAXPLAN_NAME'
            ListSource = dsTaxPlans
            TabOrder = 2
            Visible = True
          end
          object dtedCreateDate: TDBDateTimeEditEh
            Left = 104
            Top = 96
            Width = 121
            Height = 21
            Color = clBtnFace
            EditButton.Visible = False
            EditButtons = <>
            Kind = dtkDateEh
            ReadOnly = True
            TabOrder = 3
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
            TabOrder = 4
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
            TabOrder = 5
            Visible = False
          end
        end
      end
      object pnlCenterOnOrder: TJvPanel
        Left = 390
        Top = 70
        Width = 626
        Height = 409
        HotTrackFont.Charset = DEFAULT_CHARSET
        HotTrackFont.Color = clWindowText
        HotTrackFont.Height = -11
        HotTrackFont.Name = 'MS Sans Serif'
        HotTrackFont.Style = []
        Align = alClient
        BorderWidth = 4
        TabOrder = 1
        object grBoxOrderTaxs: TJvGroupBox
          Left = 5
          Top = 5
          Width = 616
          Height = 399
          Align = alClient
          Caption = 'grBoxOrderTaxs'
          TabOrder = 0
          Visible = False
          object grd1: TDBGridEh
            Left = 2
            Top = 15
            Width = 612
            Height = 382
            Align = alClient
            DataGrouping.GroupLevels = <>
            Flat = False
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
            object RowDetailData: TRowDetailPanelControlEh
            end
          end
        end
      end
    end
    object wzIPageClient: TJvWizardInteriorPage
      Header.Title.Color = clNone
      Header.Title.Text = #1050#1083#1080#1077#1085#1090
      Header.Title.Anchors = [akLeft, akTop, akRight]
      Header.Title.Font.Charset = DEFAULT_CHARSET
      Header.Title.Font.Color = clWindowText
      Header.Title.Font.Height = -16
      Header.Title.Font.Name = 'MS Sans Serif'
      Header.Title.Font.Style = [fsBold]
      Header.Subtitle.Color = clNone
      Header.Subtitle.Text = #1047#1072#1088#1077#1075#1080#1089#1090#1088#1080#1088#1091#1081#1090#1077' '#1080#1083#1080' '#1074#1099#1073#1077#1088#1080#1090#1077' '#1082#1083#1077#1085#1090#1072' '#1080#1079' '#1087#1088#1077#1076#1083#1086#1078#1077#1085#1085#1099#1093
      Header.Subtitle.Anchors = [akLeft, akTop, akRight, akBottom]
      Header.Subtitle.Font.Charset = DEFAULT_CHARSET
      Header.Subtitle.Font.Color = clWindowText
      Header.Subtitle.Font.Height = -11
      Header.Subtitle.Font.Name = 'MS Sans Serif'
      Header.Subtitle.Font.Style = []
      Panel.BorderWidth = 10
      Caption = 'wzIPageClient'
      OnEnterPage = wzIPageClientEnterPage
      OnNextButtonClick = wzIPageClientNextButtonClick
      object pnlCenterOnClient: TPanel
        Left = 0
        Top = 70
        Width = 726
        Height = 409
        Align = alClient
        BorderWidth = 4
        TabOrder = 0
        object splitClient: TJvNetscapeSplitter
          Left = 5
          Top = 161
          Width = 716
          Height = 10
          Cursor = crVSplit
          Align = alBottom
          Maximized = False
          Minimized = False
          ButtonCursor = crDefault
        end
        object grdClient: TDBGridEh
          Left = 5
          Top = 5
          Width = 716
          Height = 156
          Align = alClient
          AutoFitColWidths = True
          DataGrouping.GroupLevels = <>
          DataSource = dsClients
          Flat = True
          FooterColor = clWindow
          FooterFont.Charset = DEFAULT_CHARSET
          FooterFont.Color = clWindowText
          FooterFont.Height = -11
          FooterFont.Name = 'MS Sans Serif'
          FooterFont.Style = []
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
          OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking, dghIncSearch, dghPreferIncSearch, dghRowHighlight, dghDialogFind, dghColumnResize, dghColumnMove, dghHotTrack, dghExtendVertLines]
          ReadOnly = True
          RowDetailPanel.Height = 34
          RowDetailPanel.ParentColor = True
          RowPanel.Active = True
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          OnDblClick = grdClientDblClick
          Columns = <
            item
              EditButtons = <>
              FieldName = 'FIO_TEXT'
              Footers = <>
              Title.Alignment = taCenter
              Title.Caption = #1060#1072#1084#1080#1083#1080#1103', '#1048#1084#1103', '#1054#1090#1095#1077#1089#1090#1074#1086
              Width = 300
            end
            item
              EditButtons = <>
              FieldName = 'PLACE_TEXT'
              Footers = <>
              Title.Alignment = taCenter
              Title.Caption = #1043#1086#1088#1086#1076' '#1087#1088#1086#1078#1080#1074#1072#1085#1080#1103
              Width = 230
              InRowLinePos = 1
            end
            item
              EditButtons = <>
              FieldName = 'ADRESS_TEXT'
              Footers = <>
              Title.Alignment = taCenter
              Title.Caption = #1040#1076#1088#1077#1089
              Width = 230
              InRowLinePos = 1
            end
            item
              EditButtons = <>
              FieldName = 'MOBILE_PHONE'
              Footers = <>
              Title.Alignment = taCenter
              Title.Caption = #1052#1086#1073#1080#1083#1100#1085#1099#1081
              Width = 120
            end
            item
              EditButtons = <>
              FieldName = 'EMAIL'
              Footers = <>
              Title.Alignment = taCenter
              Title.Caption = 'e-Mail'
              Width = 150
            end
            item
              EditButtons = <>
              FieldName = 'STATUS_ID'
              Footers = <>
              Title.Alignment = taCenter
              Visible = False
              InRowLinePos = 1
            end
            item
              EditButtons = <>
              FieldName = 'STATUS_NAME'
              Footers = <>
              Title.Alignment = taCenter
              Title.Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077
              Width = 110
              InRowLinePos = 1
            end>
          object RowDetailData: TRowDetailPanelControlEh
          end
        end
        object grdClientOrders: TDBGridEh
          Left = 5
          Top = 171
          Width = 716
          Height = 233
          Align = alBottom
          AutoFitColWidths = True
          DataGrouping.GroupLevels = <>
          DataSource = dsClientOrders
          Flat = True
          FooterColor = clWindow
          FooterFont.Charset = DEFAULT_CHARSET
          FooterFont.Color = clWindowText
          FooterFont.Height = -11
          FooterFont.Name = 'MS Sans Serif'
          FooterFont.Style = []
          FooterRowCount = 1
          RowDetailPanel.Active = True
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
              FieldName = 'ORDER_ID'
              Footers = <>
              Title.Alignment = taCenter
              Visible = False
            end
            item
              AutoFitColWidth = False
              EditButtons = <>
              FieldName = 'ORDER_CODE'
              Footers = <>
              Title.Alignment = taCenter
              Title.Caption = #1050#1086#1076' '#1079#1072#1103#1074#1082#1080
              Width = 80
            end
            item
              EditButtons = <>
              FieldName = 'PRODUCT_ID'
              Footers = <>
              Title.Alignment = taCenter
              Visible = False
            end
            item
              EditButtons = <>
              FieldName = 'CLIENT_ID'
              Footers = <>
              Title.Alignment = taCenter
              Visible = False
            end
            item
              EditButtons = <>
              FieldName = 'ADRESS_ID'
              Footers = <>
              Title.Alignment = taCenter
              Visible = False
            end
            item
              EditButtons = <>
              FieldName = 'CREATE_DTM'
              Footers = <>
              Title.Alignment = taCenter
              Title.Caption = #1044#1072#1090#1072' '#1079#1072#1103#1074#1082#1080
            end
            item
              EditButtons = <>
              FieldName = 'STATUS_ID'
              Footers = <>
              Title.Alignment = taCenter
              Visible = False
            end
            item
              EditButtons = <>
              FieldName = 'STATUS_NAME'
              Footers = <>
              Title.Alignment = taCenter
              Title.Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077
              Width = 150
            end
            item
              EditButtons = <>
              FieldName = 'STATUS_DTM'
              Footers = <>
              Title.Alignment = taCenter
              Title.Caption = #1054#1073#1085#1086#1074#1083#1077#1085
            end>
          object RowDetailData: TRowDetailPanelControlEh
            object grdClientOrderItems: TDBGridEh
              Left = 0
              Top = 0
              Width = 341
              Height = 118
              Align = alClient
              AutoFitColWidths = True
              DataGrouping.GroupLevels = <>
              DataSource = dsClientOrderItems
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
                  Visible = False
                end
                item
                  EditButtons = <>
                  FieldName = 'ORD'
                  Footers = <>
                  Visible = False
                end
                item
                  EditButtons = <>
                  FieldName = 'SUBJECT_ID'
                  Footers = <>
                  Visible = False
                end
                item
                  EditButtons = <>
                  FieldName = 'SUBJECT_NAME'
                  Footers = <>
                  Title.Caption = #1040#1088#1090#1080#1082#1091#1083', '#1057#1073#1086#1088
                  Width = 200
                end
                item
                  EditButtons = <>
                  FieldName = 'DIMENSION'
                  Footers = <>
                  Title.Caption = #1056#1072#1079#1084#1077#1088
                end
                item
                  EditButtons = <>
                  FieldName = 'WEIGHT'
                  Footers = <>
                  Title.Caption = #1042#1077#1089', '#1075
                end
                item
                  EditButtons = <>
                  FieldName = 'PRICE_EUR'
                  Footers = <>
                  Title.Caption = #1062#1077#1085#1072', EUR'
                end
                item
                  EditButtons = <>
                  FieldName = 'AMOUNT'
                  Footers = <>
                  Title.Caption = #1050#1086#1083'-'#1074#1086
                end
                item
                  EditButtons = <>
                  FieldName = 'COST_EUR'
                  Footers = <>
                  Title.Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100
                end
                item
                  EditButtons = <>
                  FieldName = 'NAME_RUS'
                  Footers = <>
                end
                item
                  EditButtons = <>
                  FieldName = 'KIND_RUS'
                  Footers = <>
                end
                item
                  EditButtons = <>
                  FieldName = 'STATUS_NAME'
                  Footers = <>
                end
                item
                  EditButtons = <>
                  FieldName = 'COUNT_WEIGHT'
                  Footers = <>
                  Visible = False
                end
                item
                  EditButtons = <>
                  FieldName = 'COST_BYR'
                  Footers = <>
                  Visible = False
                end>
              object RowDetailData: TRowDetailPanelControlEh
              end
            end
          end
        end
      end
      object pnlRightOnClient: TPanel
        Left = 726
        Top = 70
        Width = 290
        Height = 409
        Align = alRight
        BorderWidth = 4
        Constraints.MaxWidth = 290
        Constraints.MinWidth = 290
        TabOrder = 1
        object grBoxClientOnClient: TJvGroupBox
          Left = 5
          Top = 5
          Width = 280
          Height = 184
          Align = alTop
          Caption = #1050#1083#1080#1077#1085#1090' ('#1053#1086#1074#1099#1081')'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 0
          PropagateEnable = True
          object lblLastName: TLabel
            Left = 8
            Top = 24
            Width = 65
            Height = 21
            AutoSize = False
            Caption = #1060#1072#1084#1080#1083#1080#1103
            Layout = tlCenter
          end
          object lblFirstName: TLabel
            Left = 8
            Top = 48
            Width = 65
            Height = 21
            AutoSize = False
            Caption = #1048#1084#1103
            Layout = tlCenter
          end
          object lblMidName: TLabel
            Left = 8
            Top = 72
            Width = 65
            Height = 21
            AutoSize = False
            Caption = #1054#1090#1095#1077#1089#1090#1074#1086
            Layout = tlCenter
          end
          object lblMobilePhone: TLabel
            Left = 8
            Top = 96
            Width = 65
            Height = 21
            AutoSize = False
            Caption = #1052#1086#1073#1080#1083#1100#1085#1099#1081
            Layout = tlCenter
          end
          object lbl1: TLabel
            Left = 8
            Top = 144
            Width = 65
            Height = 21
            AutoSize = False
            Caption = 'e-Mail'
            Layout = tlCenter
          end
          object lblStacionarPhone: TLabel
            Left = 8
            Top = 120
            Width = 65
            Height = 21
            AutoSize = False
            Caption = #1057#1090#1072#1094#1080#1086#1085#1072#1088'.'
            Layout = tlCenter
          end
          object medMobilePhone: TJvMaskEdit
            Left = 80
            Top = 96
            Width = 93
            Height = 21
            CharCase = ecUpperCase
            EditMask = '!\(999\)000-0000;0;_'
            Flat = False
            ParentFlat = False
            MaxLength = 13
            TabOrder = 3
            OnEnter = EditEnter
            OnKeyDown = EditKeyDown
          end
          object dedLastName: TDBEditEh
            Tag = 4
            Left = 80
            Top = 24
            Width = 169
            Height = 21
            AutoSize = False
            EditButtons = <
              item
                Action = actOrderCancel
                Style = ebsEllipsisEh
              end>
            TabOrder = 0
            Visible = True
            OnEnter = EditEnter
            OnExit = dedLastNameExit
            OnKeyDown = EditKeyDown
          end
          object dedFirstName: TDBEditEh
            Tag = 4
            Left = 80
            Top = 48
            Width = 169
            Height = 21
            EditButtons = <>
            TabOrder = 1
            Visible = True
            OnEnter = EditEnter
            OnExit = xNameExit
            OnKeyDown = EditKeyDown
          end
          object dedMidName: TDBEditEh
            Tag = 4
            Left = 80
            Top = 72
            Width = 169
            Height = 21
            EditButtons = <>
            TabOrder = 2
            Visible = True
            OnEnter = EditEnter
            OnExit = xNameExit
            OnKeyDown = EditKeyDown
          end
          object dedEmail: TDBEditEh
            Tag = 2
            Left = 80
            Top = 144
            Width = 169
            Height = 21
            EditButtons = <>
            TabOrder = 5
            Visible = True
            OnEnter = EditEnter
            OnKeyDown = EditKeyDown
          end
          object dedStaticPhone: TDBEditEh
            Left = 80
            Top = 120
            Width = 169
            Height = 21
            EditButtons = <>
            TabOrder = 4
            Visible = True
            OnEnter = EditEnter
            OnKeyDown = EditKeyDown
          end
        end
        object grBoxAdressOnClient: TJvGroupBox
          Left = 5
          Top = 189
          Width = 280
          Height = 215
          Align = alClient
          Caption = 'grBoxAdressOnClient'
          TabOrder = 1
          object txtAdress: TStaticText
            Left = 2
            Top = 15
            Width = 276
            Height = 198
            Align = alClient
            AutoSize = False
            BorderStyle = sbsSunken
            TabOrder = 0
          end
        end
      end
    end
    object wzIPageAdress: TJvWizardInteriorPage
      Header.Title.Color = clNone
      Header.Title.Text = #1040#1076#1088#1077#1089' '#1076#1086#1089#1090#1072#1074#1082#1080
      Header.Title.Anchors = [akLeft, akTop, akRight]
      Header.Title.Font.Charset = DEFAULT_CHARSET
      Header.Title.Font.Color = clWindowText
      Header.Title.Font.Height = -16
      Header.Title.Font.Name = 'MS Sans Serif'
      Header.Title.Font.Style = [fsBold]
      Header.Subtitle.Color = clNone
      Header.Subtitle.Text = 
        #1042#1074#1077#1076#1080#1090#1077' '#1085#1086#1074#1086#1077' '#1085#1072#1079#1074#1072#1085#1080#1077' '#1085#1072#1089#1077#1083#1077#1085#1085#1086#1075#1086' '#1087#1091#1085#1082#1090#1072', '#1077#1089#1083#1080' '#1077#1075#1086' '#1085#1077#1090#1091' '#1089#1088#1077#1076#1080' '#1087 +
        #1086#1093#1086#1078#1080#1093' '#1080#1083#1080' '#1076#1074#1086#1081#1085#1099#1084' '#1097#1077#1083#1095#1082#1086#1084' '#1074#1099#1073#1077#1088#1080#1090#1077' '#1085#1072#1089#1077#1083#1077#1085#1085#1099#1081' '#1087#1091#1082#1085#1090' '#1080#1079' '#1087#1088#1077#1076#1083#1086#1078#1077 +
        #1085#1085#1099#1093'.'
      Header.Subtitle.Anchors = [akLeft, akTop, akRight, akBottom]
      Header.Subtitle.Font.Charset = DEFAULT_CHARSET
      Header.Subtitle.Font.Color = clWindowText
      Header.Subtitle.Font.Height = -11
      Header.Subtitle.Font.Name = 'MS Sans Serif'
      Header.Subtitle.Font.Style = []
      Caption = 'wzIPageAdress'
      OnEnterPage = wzIPageAdressEnterPage
      OnNextButtonClick = wzIPageAdressNextButtonClick
      object pnlCenterOnAdress: TPanel
        Left = 0
        Top = 70
        Width = 726
        Height = 409
        Align = alClient
        BorderWidth = 4
        Caption = 'pCenter'
        TabOrder = 0
        object split1: TJvNetscapeSplitter
          Left = 5
          Top = 198
          Width = 716
          Height = 10
          Cursor = crVSplit
          Align = alTop
          Maximized = False
          Minimized = False
          ButtonCursor = crDefault
        end
        object gb1: TJvGroupBox
          Left = 5
          Top = 208
          Width = 716
          Height = 196
          Align = alClient
          TabOrder = 0
          object grdAdresses: TDBGridEh
            Left = 2
            Top = 15
            Width = 712
            Height = 179
            Align = alClient
            AutoFitColWidths = True
            DataGrouping.GroupLevels = <>
            DataSource = dsAdresses
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
            OnDblClick = grdAdressesDblClick
            Columns = <
              item
                EditButtons = <>
                FieldName = 'ADRESS_ID'
                Footers = <>
                Title.Alignment = taCenter
                Visible = False
              end
              item
                EditButtons = <>
                FieldName = 'PLACE_ID'
                Footers = <>
                Title.Alignment = taCenter
                Visible = False
              end
              item
                EditButtons = <>
                FieldName = 'PLACE_TEXT'
                Footers = <>
                Title.Alignment = taCenter
                Title.Caption = #1052#1077#1089#1090#1086' '#1087#1088#1086#1078#1080#1074#1072#1085#1080#1103
                Width = 250
              end
              item
                EditButtons = <>
                FieldName = 'CLIENT_ID'
                Footers = <>
                Title.Alignment = taCenter
                Visible = False
              end
              item
                EditButtons = <>
                FieldName = 'ADRESS_TEXT'
                Footers = <>
                Title.Alignment = taCenter
                Title.Caption = #1040#1076#1088#1077#1089
                Width = 300
              end
              item
                EditButtons = <>
                FieldName = 'STATUS_ID'
                Footers = <>
                Title.Alignment = taCenter
                Visible = False
              end>
            object RowDetailData: TRowDetailPanelControlEh
            end
          end
        end
        object gb2: TJvGroupBox
          Left = 5
          Top = 5
          Width = 716
          Height = 193
          Align = alTop
          Caption = #1053#1072#1089#1077#1083#1077#1085#1085#1099#1077' '#1087#1091#1085#1082#1090#1099
          TabOrder = 1
          object grdPlaces: TDBGridEh
            Left = 2
            Top = 15
            Width = 712
            Height = 176
            Align = alClient
            AutoFitColWidths = True
            Ctl3D = True
            DataGrouping.GroupLevels = <>
            DataSource = dsPlaces
            Flat = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            FooterColor = clWindow
            FooterFont.Charset = DEFAULT_CHARSET
            FooterFont.Color = clWindowText
            FooterFont.Height = -11
            FooterFont.Name = 'MS Sans Serif'
            FooterFont.Style = []
            Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
            OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking, dghIncSearch, dghPreferIncSearch, dghRowHighlight, dghExtendVertLines]
            ParentCtl3D = False
            ParentFont = False
            RowDetailPanel.Color = clBtnFace
            STFilter.InstantApply = True
            STFilter.Local = True
            STFilter.Location = stflInTitleFilterEh
            STFilter.Visible = True
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'MS Sans Serif'
            TitleFont.Style = []
            OnDblClick = grdPlacesDblClick
            Columns = <
              item
                EditButtons = <>
                FieldName = 'PLACETYPE_SIGN'
                Footers = <>
                Title.Alignment = taCenter
                Title.Caption = #1058#1080#1087' '#1053#1055
                Title.TitleButton = True
                Width = 50
              end
              item
                EditButtons = <>
                FieldName = 'PLACE_NAME'
                Footers = <>
                Title.Alignment = taCenter
                Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
                Title.TitleButton = True
                Width = 250
              end
              item
                EditButtons = <>
                FieldName = 'AREA_NAME'
                Footers = <>
                Title.Alignment = taCenter
                Title.Caption = #1056#1072#1081#1086#1085
                Title.TitleButton = True
                Width = 120
              end
              item
                EditButtons = <>
                FieldName = 'REGION_NAME'
                Footers = <>
                Title.Alignment = taCenter
                Title.Caption = #1054#1073#1083#1072#1089#1090#1100
                Title.TitleButton = True
                Title.ToolTips = True
                Width = 120
              end>
            object RowDetailData: TRowDetailPanelControlEh
            end
          end
        end
      end
      object pnlRightOnAdress: TJvPanel
        Left = 726
        Top = 70
        Width = 290
        Height = 409
        HotTrackFont.Charset = DEFAULT_CHARSET
        HotTrackFont.Color = clWindowText
        HotTrackFont.Height = -11
        HotTrackFont.Name = 'MS Sans Serif'
        HotTrackFont.Style = []
        Align = alRight
        BorderWidth = 4
        Constraints.MaxWidth = 290
        Constraints.MinWidth = 290
        TabOrder = 1
        object grBoxAdressOnAdress: TJvGroupBox
          Left = 5
          Top = 253
          Width = 280
          Height = 151
          Align = alBottom
          Caption = #1040#1076#1088#1077#1089' ('#1053#1086#1074#1099#1081')'
          TabOrder = 0
          object lblPostIndex: TLabel
            Left = 8
            Top = 16
            Width = 49
            Height = 21
            AutoSize = False
            Caption = #1048#1085#1076#1077#1082#1089
            Layout = tlCenter
          end
          object lblStreetType: TLabel
            Left = 8
            Top = 40
            Width = 49
            Height = 21
            AutoSize = False
            Caption = #1059#1083#1080#1094#1072
            Layout = tlCenter
          end
          object lblFlat: TLabel
            Left = 8
            Top = 112
            Width = 57
            Height = 21
            AutoSize = False
            Caption = #1050#1074#1072#1088#1090#1080#1088#1072
            Layout = tlCenter
          end
          object lblBuilding: TLabel
            Left = 8
            Top = 88
            Width = 49
            Height = 21
            AutoSize = False
            Caption = #1050#1086#1088#1087#1091#1089
            Layout = tlCenter
          end
          object lblHouse: TLabel
            Left = 8
            Top = 64
            Width = 49
            Height = 21
            AutoSize = False
            Caption = #1044#1086#1084
            Layout = tlCenter
          end
          object medPostIndex: TJvMaskEdit
            Left = 64
            Top = 16
            Width = 55
            Height = 21
            EditMask = '000000;0;_'
            MaxLength = 6
            TabOrder = 0
            OnEnter = EditEnter
            OnKeyDown = EditKeyDown
          end
          object cbStreetType: TDBComboBoxEh
            Left = 64
            Top = 40
            Width = 57
            Height = 21
            EditButtons = <>
            TabOrder = 1
            Visible = True
            OnEnter = EditEnter
            OnKeyDown = EditKeyDown
          end
          object dedStreetName: TDBEditEh
            Tag = 4
            Left = 144
            Top = 40
            Width = 105
            Height = 21
            EditButtons = <>
            TabOrder = 2
            Visible = True
            OnEnter = EditEnter
            OnKeyDown = EditKeyDown
          end
          object dedFlat: TDBEditEh
            Left = 64
            Top = 112
            Width = 57
            Height = 21
            EditButtons = <>
            TabOrder = 5
            Visible = True
            OnEnter = EditEnter
            OnKeyDown = EditKeyDown
          end
          object dedBuilding: TDBEditEh
            Left = 64
            Top = 88
            Width = 57
            Height = 21
            EditButtons = <>
            TabOrder = 4
            Visible = True
            OnEnter = EditEnter
            OnKeyDown = EditKeyDown
          end
          object dedHouse: TDBEditEh
            Left = 64
            Top = 64
            Width = 57
            Height = 21
            EditButtons = <>
            TabOrder = 3
            Visible = True
            OnEnter = EditEnter
            OnKeyDown = EditKeyDown
          end
        end
        object grBoxPlaceOnAdress: TJvGroupBox
          Left = 5
          Top = 133
          Width = 280
          Height = 120
          Align = alBottom
          Caption = #1053#1072#1089#1077#1083#1077#1085#1085#1099#1081' '#1087#1091#1085#1082#1090' ('#1053#1086#1074#1099#1081')'
          TabOrder = 1
          object lbl2: TLabel
            Left = 8
            Top = 16
            Width = 65
            Height = 21
            AutoSize = False
            Caption = #1058#1080#1087' '#1053#1055
            Layout = tlCenter
          end
          object lblPlace: TLabel
            Left = 8
            Top = 40
            Width = 65
            Height = 21
            AutoSize = False
            Caption = #1053#1072#1089#1077#1083'. '#1087#1091#1085#1082#1090
            Layout = tlCenter
          end
          object lblArea: TLabel
            Left = 8
            Top = 64
            Width = 65
            Height = 21
            AutoSize = False
            Caption = #1056#1072#1081#1086#1085
            Layout = tlCenter
          end
          object lblRegion: TLabel
            Left = 8
            Top = 88
            Width = 65
            Height = 21
            AutoSize = False
            Caption = #1054#1073#1083#1072#1089#1090#1100
            Layout = tlCenter
          end
          object cbPlaceType: TDBComboBoxEh
            Left = 80
            Top = 16
            Width = 57
            Height = 21
            EditButtons = <>
            TabOrder = 0
            Visible = True
            OnChange = cbPlaceTypeChange
            OnEnter = EditEnter
            OnKeyDown = EditKeyDown
          end
          object dedPlaceName: TDBEditEh
            Tag = 4
            Left = 80
            Top = 40
            Width = 169
            Height = 19
            EditButtons = <
              item
                Action = actPlaceSearch
                Style = ebsEllipsisEh
                Width = 16
              end>
            Flat = True
            TabOrder = 1
            Visible = True
            OnChange = dedPlaceNameChange
            OnEnter = EditEnter
            OnExit = dedPlaceNameExit
            OnKeyDown = EditKeyDown
          end
          object cbAreaName: TDBComboBoxEh
            Tag = 4
            Left = 80
            Top = 64
            Width = 167
            Height = 21
            EditButtons = <>
            TabOrder = 2
            Visible = True
            OnEnter = EditEnter
            OnKeyDown = EditKeyDown
          end
          object dedRegionName: TDBEditEh
            Left = 80
            Top = 88
            Width = 169
            Height = 21
            Color = clBtnFace
            EditButtons = <>
            ReadOnly = True
            TabOrder = 3
            Visible = True
          end
        end
        object grBoxClientOnAdress: TJvGroupBox
          Left = 6
          Top = 5
          Width = 279
          Height = 128
          Align = alRight
          Caption = #1050#1083#1080#1077#1085#1090' ('#1053#1086#1074#1099#1081')'
          TabOrder = 2
          PropagateEnable = True
          object txtClientName: TStaticText
            Left = 2
            Top = 15
            Width = 275
            Height = 111
            Align = alClient
            AutoSize = False
            BorderStyle = sbsSunken
            TabOrder = 0
          end
        end
      end
    end
    object wzIPageFinal: TJvWizardInteriorPage
      Header.Title.Color = clNone
      Header.Title.Text = 'Title'
      Header.Title.Anchors = [akLeft, akTop, akRight]
      Header.Title.Font.Charset = DEFAULT_CHARSET
      Header.Title.Font.Color = clWindowText
      Header.Title.Font.Height = -16
      Header.Title.Font.Name = 'MS Sans Serif'
      Header.Title.Font.Style = [fsBold]
      Header.Subtitle.Color = clNone
      Header.Subtitle.Text = 'Subtitle'
      Header.Subtitle.Anchors = [akLeft, akTop, akRight, akBottom]
      Header.Subtitle.Font.Charset = DEFAULT_CHARSET
      Header.Subtitle.Font.Color = clWindowText
      Header.Subtitle.Font.Height = -11
      Header.Subtitle.Font.Name = 'MS Sans Serif'
      Header.Subtitle.Font.Style = []
      VisibleButtons = [bkCancel]
      Caption = 'wzIPageFinal'
      OnEnterPage = wzIPageFinalEnterPage
      object grBoxSummaryOrderItems: TJvGroupBox
        Left = 0
        Top = 201
        Width = 1016
        Height = 236
        Align = alClient
        Caption = 'grBoxSummaryOrderItems'
        TabOrder = 0
        object grdOrderFullSpecification: TDBGridEh
          Left = 2
          Top = 15
          Width = 1012
          Height = 219
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
      object JvFooter1: TJvFooter
        Left = 0
        Top = 437
        Width = 1016
        Height = 42
        Align = alBottom
        DesignSize = (
          1016
          42)
        object btnFtCommit: TJvFooterBtn
          Left = 468
          Top = 8
          Width = 74
          Height = 25
          Action = actOrderCreate
          Anchors = [akBottom]
          ModalResult = 1
          TabOrder = 0
          Alignment = taCenter
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'MS Sans Serif'
          HotTrackFont.Style = []
          ButtonIndex = 0
          SpaceInterval = 6
        end
        object btnFtDraft: TJvFooterBtn
          Left = 8
          Top = 8
          Width = 74
          Height = 25
          Action = actOrderDraft
          Anchors = [akLeft, akBottom]
          ModalResult = 1
          TabOrder = 1
          Alignment = taLeftJustify
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'MS Sans Serif'
          HotTrackFont.Style = []
          ButtonIndex = 1
          SpaceInterval = 6
        end
        object btnFtBack: TJvFooterBtn
          Left = 772
          Top = 8
          Width = 74
          Height = 25
          Anchors = [akRight, akBottom]
          Caption = '< '#1053#1072#1079#1072#1076
          TabOrder = 2
          OnClick = btnFtBackClick
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'MS Sans Serif'
          HotTrackFont.Style = []
          ButtonIndex = 2
          SpaceInterval = 4
        end
        object btnFtStore: TJvFooterBtn
          Left = 850
          Top = 8
          Width = 74
          Height = 25
          Action = actOrderStore
          Anchors = [akRight, akBottom]
          Default = True
          ModalResult = 1
          TabOrder = 3
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'MS Sans Serif'
          HotTrackFont.Style = []
          ButtonIndex = 3
          SpaceInterval = 12
        end
        object btnFtCancel: TJvFooterBtn
          Left = 934
          Top = 8
          Width = 74
          Height = 25
          Action = actOrderCancel
          Anchors = [akRight, akBottom]
          Cancel = True
          Caption = #1047#1072#1082#1088#1099#1090#1100
          TabOrder = 4
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'MS Sans Serif'
          HotTrackFont.Style = []
          ButtonIndex = 4
          SpaceInterval = 6
        end
      end
      object pnlTopOnFinal: TJvPanel
        Left = 0
        Top = 70
        Width = 1016
        Height = 131
        HotTrackFont.Charset = DEFAULT_CHARSET
        HotTrackFont.Color = clWindowText
        HotTrackFont.Height = -11
        HotTrackFont.Name = 'MS Sans Serif'
        HotTrackFont.Style = []
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 2
        object pnlClientOnFinal: TJvPanel
          Left = 0
          Top = 0
          Width = 504
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
            Width = 494
            Height = 121
            Align = alClient
            Caption = #1050#1083#1080#1077#1085#1090
            TabOrder = 0
            DesignSize = (
              494
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
              Width = 417
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
              Width = 417
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
            object txtClientPhoneOnFinal: TStaticText
              Left = 72
              Top = 32
              Width = 417
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
            object txtClientGsmOnFinal: TStaticText
              Left = 72
              Top = 48
              Width = 417
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
            object txtClientEmailOnFinal: TStaticText
              Left = 72
              Top = 64
              Width = 417
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
            object txtAccountRest: TStaticText
              Left = 72
              Top = 96
              Width = 417
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
          Left = 504
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
              TabOrder = 0
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
          end
        end
      end
    end
  end
  object dsProducts: TDataSource [1]
    AutoEdit = False
    DataSet = qryProducts
    Left = 424
    Top = 160
  end
  object dsVendors: TDataSource [2]
    AutoEdit = False
    DataSet = qryVendors
    Left = 160
    Top = 160
  end
  object dsClients: TDataSource [3]
    AutoEdit = False
    DataSet = qryClient
    Left = 160
    Top = 264
  end
  object dsOrderItems: TDataSource [4]
    DataSet = mtblOrderItems
    Left = 17
    Top = 478
  end
  object dsArticles: TDataSource [5]
    AutoEdit = False
    DataSet = qryArticles
    Left = 57
    Top = 480
  end
  object dsOrderTaxs: TDataSource [6]
    AutoEdit = False
    DataSet = mtblOrderTaxs
    Left = 144
    Top = 488
  end
  inherited actListWzrdBtn: TActionList
    OnUpdate = actListWzrdBtnUpdate
    Left = 32
    Top = 360
    object actClientPageFirst: TAction
      Caption = #1053#1072#1095#1080#1085#1072#1090#1100' '#1089' '#1082#1083#1080#1077#1085#1090#1072
      OnExecute = actClientPageFirstExecute
    end
    object actOrderCreate: TAction
      Caption = #1054#1092#1086#1088#1084#1080#1090#1100
      OnExecute = actOrderCreateExecute
    end
    object actOrderDraft: TAction
      Caption = #1063#1077#1088#1085#1086#1074#1080#1082
      OnExecute = actOrderDraftExecute
    end
    object actOrderError: TAction
      Caption = #1041#1088#1072#1082
    end
    object actOrderStore: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      OnExecute = actOrderStoreExecute
    end
    object actOrderCancel: TAction
      Caption = 'actOrderCancel'
      OnExecute = actOrderCancelExecute
    end
    object actClientSearch: TAction
      Caption = #1053#1072#1081#1090#1080
      OnExecute = actClientSearchExecute
    end
    object actPlaceSearch: TAction
      Caption = #1053#1072#1081#1090#1080
      OnExecute = actPlaceSearchExecute
    end
    object actOrderItemDelete: TAction
      Category = 'OrderItem'
      Caption = #1059#1076#1072#1083#1080#1090#1100
    end
    object actOrderItemDublicate: TAction
      Category = 'OrderItem'
      Caption = #1044#1091#1073#1083#1080#1088#1086#1074#1072#1090#1100
    end
    object actCheckAvailable: TAction
      Category = 'OrderItem'
      Caption = #1055#1088#1086#1074#1077#1088#1080#1090#1100' '#1076#1086#1089#1090#1091#1087#1085#1086#1089#1090#1100
      OnExecute = actCheckAvailableExecute
    end
    object actOrderItemAnnul: TAction
      Category = 'OrderItem'
      Caption = #1040#1085#1091#1083#1080#1088#1086#1074#1072#1090#1100
    end
  end
  object mtblOrderItems: TMemTableEh [8]
    Active = True
    FieldDefs = <
      item
        Name = 'ORDERITEM_ID'
        DataType = ftInteger
      end
      item
        Name = 'MAGAZINE_ID'
        DataType = ftInteger
      end
      item
        Name = 'PAGE_NO'
        DataType = ftInteger
      end
      item
        Name = 'POSITION_SIGN'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'ARTICLE_ID'
        DataType = ftInteger
      end
      item
        Name = 'ARTICLE_CODE'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'DIMENSION'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'PRICE_EUR'
        DataType = ftFloat
      end
      item
        Name = 'WEIGHT'
        DataType = ftInteger
      end
      item
        Name = 'NAME_RUS'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'KIND_RUS'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'STATUS_ID'
        DataType = ftInteger
      end
      item
        Name = 'STATE_ID'
        DataType = ftInteger
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    BeforePost = mtblOrderItemsBeforePost
    BeforeDelete = mtblOrderItemsBeforeDelete
    OnCalcFields = mtblOrderItemsCalcFields
    OnSetFieldValue = mtblOrderItemsSetFieldValue
    Left = 17
    Top = 438
    object fldOrderItems_ORDERITEM_ID: TIntegerField
      DisplayLabel = 'Id'
      DisplayWidth = 6
      FieldName = 'ORDERITEM_ID'
    end
    object fldOrderItems_MAGAZINE_ID: TIntegerField
      DisplayWidth = 6
      FieldName = 'MAGAZINE_ID'
    end
    object fldOrderItems_MAGAZINE_NAME: TStringField
      FieldKind = fkLookup
      FieldName = 'MAGAZINE_NAME'
      LookupDataSet = qryMagazines
      LookupKeyFields = 'MAGAZINE_ID'
      LookupResultField = 'MAGAZINE_NAME'
      KeyFields = 'MAGAZINE_ID'
      Size = 50
      Lookup = True
    end
    object fldOrderItems_PAGE_NO: TIntegerField
      DisplayWidth = 3
      FieldName = 'PAGE_NO'
    end
    object fldOrderItems_POSITION_SIGN: TStringField
      FieldName = 'POSITION_SIGN'
      Size = 2
    end
    object fldOrderItems_ARTICLE_ID: TIntegerField
      FieldName = 'ARTICLE_ID'
      Visible = False
    end
    object fldOrderItems_ARTICLE_CODE: TStringField
      DisplayLabel = #1040#1088#1090#1080#1082#1091#1083
      FieldName = 'ARTICLE_CODE'
      Size = 30
    end
    object fldOrderItems_DIMENSION: TStringField
      DisplayLabel = #1056#1072#1079#1084#1077#1088
      DisplayWidth = 4
      FieldName = 'DIMENSION'
      Size = 10
    end
    object fldOrderItems_PRICE_EUR: TFloatField
      DisplayLabel = #1062#1077#1085#1072', EUR'
      FieldName = 'PRICE_EUR'
    end
    object fldOrderItems_WEIGHT: TIntegerField
      FieldName = 'WEIGHT'
    end
    object fldOrderItems_COST_EUR: TFloatField
      FieldKind = fkCalculated
      FieldName = 'COST_EUR'
      Calculated = True
    end
    object fldOrderItems_NAME_RUS: TStringField
      DisplayLabel = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
      FieldName = 'NAME_RUS'
      Size = 30
    end
    object fldOrderItems_KIND_RUS: TStringField
      DisplayLabel = #1055#1088#1080#1079#1085#1072#1082#1080
      DisplayWidth = 30
      FieldName = 'KIND_RUS'
      Size = 50
    end
    object fldOrderItems_STATUS_ID: TIntegerField
      FieldName = 'STATUS_ID'
    end
    object fldOrderItems_STATUS_NAME: TStringField
      FieldKind = fkLookup
      FieldName = 'STATUS_NAME'
      LookupDataSet = qryStatuses
      LookupKeyFields = 'STATUS_ID'
      LookupResultField = 'STATUS_NAME'
      KeyFields = 'STATUS_ID'
      LookupCache = True
      Lookup = True
    end
    object fldOrderItems_COUNT_WEIGHT: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'COUNT_WEIGHT'
      Calculated = True
    end
    object fldOrderItems_STATUS_SIGN: TStringField
      FieldKind = fkLookup
      FieldName = 'STATUS_SIGN'
      LookupDataSet = qryStatuses
      LookupKeyFields = 'STATUS_ID'
      LookupResultField = 'STATUS_SIGN'
      KeyFields = 'STATUS_ID'
      Size = 30
      Lookup = True
    end
    object fldOrderItems_FLAG_SIGN_LIST: TStringField
      FieldKind = fkLookup
      FieldName = 'FLAG_SIGN_LIST'
      LookupDataSet = qryStatuses
      LookupKeyFields = 'STATUS_ID'
      LookupResultField = 'FLAG_SIGN_LIST'
      KeyFields = 'STATUS_ID'
      Size = 255
      Lookup = True
    end
    object fldOrderItems_AMOUNT: TSmallintField
      FieldKind = fkCalculated
      FieldName = 'AMOUNT'
      Calculated = True
    end
    object fldOrderItems_STATUS_DTM: TDateTimeField
      FieldKind = fkCalculated
      FieldName = 'STATUS_DTM'
      Calculated = True
    end
    object fldOrderItems_STATE_ID: TIntegerField
      FieldName = 'STATE_ID'
    end
    object fldOrderItems_STATE_NAME: TStringField
      FieldKind = fkLookup
      FieldName = 'STATE_NAME'
      LookupDataSet = qryStatuses
      LookupKeyFields = 'STATUS_ID'
      LookupResultField = 'STATUS_NAME'
      KeyFields = 'STATE_ID'
      Size = 100
      Lookup = True
    end
    object MemTableData: TMemTableDataEh
      object DataStruct: TMTDataStructEh
        object ORDERITEM_ID: TMTNumericDataFieldEh
          FieldName = 'ORDERITEM_ID'
          NumericDataType = fdtIntegerEh
          Alignment = taLeftJustify
          DisplayWidth = 0
          Required = False
          Visible = False
          currency = False
          Precision = 0
        end
        object MAGAZINE_ID: TMTNumericDataFieldEh
          FieldName = 'MAGAZINE_ID'
          NumericDataType = fdtIntegerEh
          Alignment = taLeftJustify
          DisplayWidth = 0
          Required = False
          Visible = False
          currency = False
          Precision = 0
        end
        object PAGE_NO: TMTNumericDataFieldEh
          FieldName = 'PAGE_NO'
          NumericDataType = fdtIntegerEh
          Alignment = taLeftJustify
          DisplayWidth = 0
          Required = False
          Visible = False
          currency = False
          Precision = 0
        end
        object POSITION_SIGN: TMTStringDataFieldEh
          FieldName = 'POSITION_SIGN'
          StringDataType = fdtStringEh
          Alignment = taLeftJustify
          DisplayWidth = 0
          Required = False
          Visible = False
          Size = 2
          Transliterate = False
        end
        object ARTICLE_ID: TMTNumericDataFieldEh
          FieldName = 'ARTICLE_ID'
          NumericDataType = fdtIntegerEh
          Alignment = taLeftJustify
          DisplayWidth = 0
          Required = False
          Visible = False
          currency = False
          Precision = 0
        end
        object ARTICLE_CODE: TMTStringDataFieldEh
          FieldName = 'ARTICLE_CODE'
          StringDataType = fdtStringEh
          Alignment = taLeftJustify
          DisplayWidth = 0
          Required = False
          Visible = False
          Size = 30
          Transliterate = False
        end
        object DIMENSION: TMTStringDataFieldEh
          FieldName = 'DIMENSION'
          StringDataType = fdtStringEh
          Alignment = taLeftJustify
          DisplayWidth = 0
          Required = False
          Visible = False
          Size = 10
          Transliterate = False
        end
        object PRICE_EUR: TMTNumericDataFieldEh
          FieldName = 'PRICE_EUR'
          NumericDataType = fdtFloatEh
          Alignment = taLeftJustify
          DisplayWidth = 0
          Required = False
          Visible = False
          currency = False
          Precision = 0
        end
        object WEIGHT: TMTNumericDataFieldEh
          FieldName = 'WEIGHT'
          NumericDataType = fdtIntegerEh
          Alignment = taLeftJustify
          DisplayWidth = 0
          Required = False
          Visible = False
          currency = False
          Precision = 0
        end
        object NAME_RUS: TMTStringDataFieldEh
          FieldName = 'NAME_RUS'
          StringDataType = fdtStringEh
          Alignment = taLeftJustify
          DisplayWidth = 0
          Required = False
          Visible = False
          Size = 30
          Transliterate = False
        end
        object KIND_RUS: TMTStringDataFieldEh
          FieldName = 'KIND_RUS'
          StringDataType = fdtStringEh
          Alignment = taLeftJustify
          DisplayWidth = 0
          Required = False
          Visible = False
          Size = 50
          Transliterate = False
        end
        object STATUS_ID: TMTNumericDataFieldEh
          FieldName = 'STATUS_ID'
          NumericDataType = fdtIntegerEh
          Alignment = taLeftJustify
          DisplayWidth = 0
          Required = False
          Visible = False
          currency = False
          Precision = 0
        end
        object STATE_ID: TMTNumericDataFieldEh
          FieldName = 'STATE_ID'
          NumericDataType = fdtIntegerEh
          Alignment = taLeftJustify
          DisplayWidth = 0
          Required = False
          Visible = False
          currency = False
          Precision = 0
        end
      end
      object RecordsList: TRecordsListEh
      end
    end
  end
  object qryArticles: TpFIBDataSet [9]
    SelectSQL.Strings = (
      'select * '
      'from v_articles a'
      'where a.article_sign = :article_sign'
      'order by a.dimension, a.article_code')
    CacheModelOptions.CacheModelKind = cmkLimitedBufferSize
    CacheModelOptions.BufferChunks = 100
    AutoCalcFields = False
    Transaction = trnWrite
    Database = dmOtto.dbOtto
    DataSource = dsOrderItems
    Left = 57
    Top = 440
  end
  object qryMagazines: TpFIBDataSet [10]
    SelectSQL.Strings = (
      'SELECT'
      '    MAGAZINE_ID,'
      '    CATALOG_ID,'
      '    MAGAZINE_NAME,'
      '    VALID_DATE,'
      '    STATUS_ID'
      'FROM'
      '    MAGAZINES ')
    Active = True
    Transaction = trnWrite
    Database = dmOtto.dbOtto
    Left = 225
    Top = 144
  end
  object qryProducts: TpFIBDataSet [11]
    SelectSQL.Strings = (
      'SELECT'
      '    PRODUCT_ID,'
      '    PRODUCT_NAME,'
      '    PRODUCT_CODE,'
      '    VENDOR_ID,'
      '    STATUS_ID'
      'FROM'
      '    PRODUCTS '
      'WHERE '
      '    VENDOR_ID = :VENDOR_ID')
    Transaction = trnWrite
    Database = dmOtto.dbOtto
    DataSource = dsVendors
    Left = 368
    Top = 160
  end
  object qryVendors: TpFIBDataSet [12]
    SelectSQL.Strings = (
      'SELECT'
      '    VENDOR_ID,'
      '    VENDOR_NAME'
      'FROM'
      '    VENDORS ')
    Transaction = trnWrite
    Database = dmOtto.dbOtto
    Left = 104
    Top = 160
  end
  object qryClient: TpFIBDataSet [13]
    SelectSQL.Strings = (
      'select ca.*, s2.status_name'
      
        'from search(:i_value, '#39'clients'#39', '#39'client_id'#39', '#39'last_name'#39', null,' +
        ' 50) s'
      'inner join v_clientadress ca on (ca.client_id = s.o_object_id)'
      'inner join statuses s2 on (s2.status_id = ca.status_id)'
      'order by ca.last_name')
    Transaction = trnWrite
    Database = dmOtto.dbOtto
    Left = 104
    Top = 264
    object fldClientCLIENT_ID: TFIBIntegerField
      FieldName = 'CLIENT_ID'
    end
    object fldClientFIO_TEXT: TFIBStringField
      FieldName = 'FIO_TEXT'
      Size = 100
      EmptyStrToNull = True
    end
    object fldClientLAST_NAME: TFIBStringField
      FieldName = 'LAST_NAME'
      Size = 100
      EmptyStrToNull = True
    end
    object fldClientFIRST_NAME: TFIBStringField
      FieldName = 'FIRST_NAME'
      Size = 100
      EmptyStrToNull = True
    end
    object fldClientMID_NAME: TFIBStringField
      FieldName = 'MID_NAME'
      Size = 100
      EmptyStrToNull = True
    end
    object fldClientSTATUS_ID: TFIBIntegerField
      FieldName = 'STATUS_ID'
    end
    object fldClientMOBILE_PHONE: TFIBStringField
      FieldName = 'MOBILE_PHONE'
      Size = 50
      EmptyStrToNull = True
    end
    object fldClientEMAIL: TFIBStringField
      FieldName = 'EMAIL'
      Size = 4000
      EmptyStrToNull = True
    end
    object fldClientPLACE_ID: TFIBIntegerField
      FieldName = 'PLACE_ID'
    end
    object fldClientPLACE_TEXT: TFIBStringField
      FieldName = 'PLACE_TEXT'
      Size = 398
      EmptyStrToNull = True
    end
    object fldClientADRESS_ID: TFIBIntegerField
      FieldName = 'ADRESS_ID'
    end
    object fldClientADRESS_TEXT: TFIBStringField
      FieldName = 'ADRESS_TEXT'
      Size = 177
      EmptyStrToNull = True
    end
    object fldClientSTATUS_NAME: TFIBStringField
      FieldName = 'STATUS_NAME'
      Size = 100
      EmptyStrToNull = True
    end
  end
  object vldEdits: TJvValidators [14]
    ErrorIndicator = erIndEdits
    Left = 32
    Top = 408
    object vldRequireLastName: TJvRequiredFieldValidator
      ControlToValidate = dedLastName
      PropertyToValidate = 'Text'
      GroupName = 'Client'
      ErrorMessage = #1053#1077' '#1091#1082#1072#1079#1072#1085#1072' '#1092#1072#1084#1080#1083#1080#1103
    end
    object vldRequireFirstName: TJvRequiredFieldValidator
      ControlToValidate = dedFirstName
      PropertyToValidate = 'Text'
      GroupName = 'Client'
      ErrorMessage = #1053#1077' '#1091#1082#1072#1079#1072#1085#1086' '#1080#1084#1103
    end
    object vldRequiredPlaceType: TJvRequiredFieldValidator
      ControlToValidate = cbPlaceType
      PropertyToValidate = 'Text'
      GroupName = 'Adress'
      ErrorMessage = #1053#1077' '#1091#1082#1072#1079#1072#1085' '#1090#1080#1087' '#1085#1072#1089#1077#1083#1077#1085#1085#1086#1075#1086' '#1087#1091#1085#1082#1090#1072
    end
    object vldRequiredPlaceName: TJvRequiredFieldValidator
      ControlToValidate = dedPlaceName
      PropertyToValidate = 'Text'
      GroupName = 'Adress'
      ErrorMessage = #1053#1077' '#1091#1082#1072#1079#1072#1085' '#1085#1072#1089#1077#1083#1077#1085#1085#1099#1081' '#1087#1091#1085#1082#1090
    end
    object vldRequiredAreaName: TJvRequiredFieldValidator
      ControlToValidate = cbAreaName
      PropertyToValidate = 'Text'
      GroupName = 'Adress'
      ErrorMessage = #1053#1077' '#1091#1082#1072#1079#1072#1085' '#1056#1072#1081#1086#1085
    end
    object vldRequiredStreetType: TJvRequiredFieldValidator
      ControlToValidate = cbStreetType
      PropertyToValidate = 'Text'
      GroupName = 'Adress'
      ErrorMessage = #1053#1077' '#1091#1082#1072#1079#1072#1085' '#1090#1080#1087' '#1091#1083#1080#1094#1099
    end
    object vldRequiredStreetName: TJvRequiredFieldValidator
      ControlToValidate = dedStreetName
      PropertyToValidate = 'Text'
      GroupName = 'Adress'
      ErrorMessage = #1053#1077' '#1059#1082#1072#1079#1072#1085#1072' '#1091#1083#1080#1094#1072
    end
    object vldCustomProduct: TJvCustomValidator
      ControlToValidate = lcbProduct
      GroupName = 'Order'
      ErrorMessage = #1053#1077' '#1074#1099#1073#1088#1072#1085' '#1090#1080#1087' '#1087#1088#1086#1076#1091#1082#1090#1072
      OnValidate = vldCustomProductValidate
    end
    object vldCustomTaxPlan: TJvCustomValidator
      ControlToValidate = lcbTaxPlan
      GroupName = 'Order'
      ErrorMessage = #1053#1077' '#1074#1099#1073#1088#1072#1085' '#1090#1072#1088#1080#1092#1085#1099#1081' '#1087#1083#1072#1085
      OnValidate = vldCustomTaxPlanValidate
    end
    object vldCompareBYR2EUR: TJvCompareValidator
      ControlToValidate = edtBYR2EUR
      PropertyToValidate = 'Text'
      GroupName = 'Order'
      Enabled = False
      ErrorMessage = #1053#1077' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085' '#1082#1091#1088#1089' EUR'
      ValueToCompare = 0
      Operator = vcoNotEqual
    end
  end
  object erIndEdits: TJvErrorIndicator [15]
    ImageIndex = 0
    Left = 64
    Top = 408
  end
  object qryPlaces: TpFIBDataSet [16]
    SelectSQL.Strings = (
      
        'select v.* from search(:i_value, '#39'v_places'#39', '#39'place_id'#39', '#39'place_' +
        'name'#39', null, 50) s'
      '  inner join v_places v on (v.place_id = s.o_object_id)'
      'order by v.place_name')
    Transaction = trnWrite
    Database = dmOtto.dbOtto
    Left = 104
    Top = 320
  end
  object dsPlaces: TDataSource [17]
    AutoEdit = False
    DataSet = qryPlaces
    Left = 160
    Top = 320
  end
  object qryAdresses: TpFIBDataSet [18]
    SelectSQL.Strings = (
      'select a.*, vp.place_text, va.adress_text'
      'from adresses a'
      'inner join v_adress_text va on (va.adress_id = a.adress_id)'
      'inner join v_place_text vp on (vp.place_id = a.place_id)'
      'where a.client_id = :CLIENT_ID')
    Transaction = trnWrite
    Database = dmOtto.dbOtto
    Left = 104
    Top = 368
  end
  object dsAdresses: TDataSource [19]
    AutoEdit = False
    DataSet = qryAdresses
    Left = 160
    Top = 368
  end
  object qryTaxPlans: TpFIBDataSet [20]
    SelectSQL.Strings = (
      'SELECT'
      '    TAXPLAN_ID,'
      '    TAXPLAN_NAME,'
      '    STATUS_ID'
      'FROM'
      '    TAXPLANS ')
    Transaction = trnWrite
    Database = dmOtto.dbOtto
    Left = 288
    Top = 272
  end
  object dsTaxPlans: TDataSource [21]
    AutoEdit = False
    DataSet = qryTaxPlans
    Left = 344
    Top = 272
  end
  object mtblOrderTaxs: TMemTableEh [22]
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 144
    Top = 440
    object fldOrderTaxs_ORDERTAX_ID: TIntegerField
      FieldName = 'ORDERTAX_ID'
    end
    object fldOrderTaxs_TAXPLAN_ID: TIntegerField
      FieldName = 'TAXPLAN_ID'
    end
    object fldOrderTaxs_TAXSERV_ID: TIntegerField
      FieldName = 'TAXSERV_ID'
    end
    object fldOrderTaxs_TAXSERV_NAME: TStringField
      FieldKind = fkLookup
      FieldName = 'TAXSERV_NAME'
      LookupKeyFields = 'TAXSERV_ID'
      LookupResultField = 'TAXSERV_NAME'
      KeyFields = 'TAXSERV_ID'
      Size = 50
      Lookup = True
    end
    object fldOrderTaxs_TAXRATE_ID: TIntegerField
      FieldName = 'TAXRATE_ID'
    end
    object fldOrderTaxs_COST_EUR: TFloatField
      FieldName = 'COST_EUR'
    end
    object fldOrderTaxs_STATUS_ID: TIntegerField
      FieldName = 'STATUS_ID'
    end
    object fldOrderTaxsSTATUS_NAME: TStringField
      FieldKind = fkLookup
      FieldName = 'STATUS_NAME'
      LookupKeyFields = 'STATUS_ID'
      LookupResultField = 'STATUS_NAME'
      KeyFields = 'STATUS_ID'
      Size = 50
      Lookup = True
    end
  end
  object qryClientOrders: TpFIBDataSet [23]
    SelectSQL.Strings = (
      'SELECT'
      '    o.ORDER_ID,'
      '    o.ORDER_CODE,'
      '    o.PRODUCT_ID,'
      '    o.CLIENT_ID,'
      '    o.ADRESS_ID,'
      '    o.CREATE_DTM,'
      '    o.STATUS_ID,'
      '    s.STATUS_NAME,'
      '    o.STATUS_DTM'
      'FROM ORDERS o'
      'inner join statuses s on (s.status_id = o.status_id)'
      'WHERE '
      '    CLIENT_ID = :CLIENT_ID'
      'ORDER BY'
      '    CREATE_DTM DESC')
    Transaction = trnWrite
    Database = dmOtto.dbOtto
    DataSource = dsClients
    Left = 528
    Top = 166
  end
  object dsClientOrders: TDataSource [24]
    AutoEdit = False
    DataSet = qryClientOrders
    Left = 568
    Top = 174
  end
  object qryClientOrderItems: TpFIBDataSet [25]
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
      '    STATUS_NAME,'
      '    COUNT_WEIGHT,'
      '    COST_BYR'
      'FROM'
      '    V_ORDER_FULL_SPECIFICATION '
      'WHERE ORDER_ID = :ORDER_ID'
      'ORDER BY ORD, SUBJECT_ID')
    Transaction = trnWrite
    Database = dmOtto.dbOtto
    DataSource = dsClientOrders
    Left = 528
    Top = 214
  end
  object dsClientOrderItems: TDataSource [26]
    AutoEdit = False
    DataSet = qryClientOrderItems
    Left = 567
    Top = 214
  end
  object dsOrderFullSpecifications: TDataSource [27]
    AutoEdit = False
    DataSet = qryOrderFullSpecification
    Left = 832
    Top = 8
  end
  object imgListOrderItems: TPngImageList [28]
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002554944415478DA8D935F4853511CC7BF77FFDA9B41F4E7
          6E3662A80C7A09A1888CB4285F22A25E8AA44C4D7338B4C40C9D4B6A36CBC272
          68336D6986210845846005D5624A250A0591A88D58DBAE69D6AC1ED6BDEEAE73
          4FA2EBB6B0F3F43B9FF33D9FFB3B977398A10B0003E4015887FF1F1F62408754
          30AFEA2938B7F1C4031B44118846FFBD4DA904140A0C5DDD6327B33354F0D241
          97EA7419366B727A3A6282008809240A2518B51A8191118406ECE709A9A182C1
          3ABAEC48DBD754C54D4C607D56266209BA60C8D7DF3EF3804D49C1D8BD32A9EF
          6ACABD76BA7E7173F19D4ACEE7837F6C7C615324128156AB5D981BD252C11A8D
          78D17AA8814C4F5381E72C5DBBB4E5F8ED0A51E0173B566BE01F1D85C164829C
          0F5E3F7C9994A7A8E0492DE58D1945374F46F9C5A052A3C16C681249BA3590F3
          81B6FC2BA42CA782C736CA9BB61E6B2F8DF23FE382CB10E626B19C95047F72EF
          8D422729CBA8A0DF4A79F3B60257C95C5C50458233210E2B742CE4FCB9DBDC42
          4A0B15F45551EECACC7316CB83D3E4082BC911E4DCD351DA4A4A33EF2582FB95
          94B76D3FDA5828C405D524F829C861B59E859C3FED2C6F177A5024F889E06E05
          E5EE1DB90DF9021F890B6AC105426093757853DB8BEFEF82BFEF03A3C0B75060
          2616A6D77998E9A5FF129D3B8FD4E7F271020D11043F06A15FABC7C3834EECDD
          B4EBAFCB75ABAB6B98B1EE074C3AF46CC8B61C10C5C4EFE0F5350FBEBC9F9EEF
          80C18FCF535F85307C2AA903C2925A0AD09D6371EC8ECE09586A28556A743757
          F795B8919305CC4A0283391B35C655485D72F7FCF04D61DCF508D22BF2FF02D8
          F1E51282420A150000000049454E44AE426082}
        Name = 'PngImage2'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C0000027A4944415478DA8D935D48935118C7FF67737344641456
          9B1FC5501BD845084264F8952C282AEA2628CCD42C25510B336CAEC8D92C0B4B
          492CD3169521459694100596A592892B2F1231B53175EFA6A9EDC25A7BF7D1D9
          0975ADF571AE9EF37B9EF33BCF79DF7348CF398000E900D6E0FF87C10DE83C01
          795BCE40696CC163355C2EC0E9FCF332A1101008D07379BB86CE4E3141B796A5
          CA64716A55684C0CDC3C0FB8FC480442109108637A3D4C9D9AB3949430415719
          4B6BA3765515734343884E4C80DB4F1784EEFEE1653BA41111187C98EFE9FB24
          E31D1A963FBF21FB6E11373202E3E0C7F945369B0D1289647E1E1E1509A95C8E
          3757F756D0E90926683FC37217361EBE5DE8E2ED0B1D8BC4300E0C205CA1802F
          EFBA967A9186C799A0ED34E39571876E1C75DA170A856231AC26338264ABE0CB
          3BEB322ED1F018133C57335EB5E9E0F53CA7FDBB576120BE70662C957A04BFF2
          8EFAAC6A1AE633C15315E357E2336B8F38BC0A0368E19489C3729914BEFC5543
          4E0D0D7399A0B598F1DA84F4EA6CDFC2497A84607A84395EC03D439FCD822526
          43FFDA593E7A96FE2CD252C4727549072AB3782F81880A2CE31C56864831C793
          87EF2036692B9E3CAAFF3C4D48B09DDE3BD25CC8720DC9691519BCDDE6259080
          1B33411A2A43DE702BFABE59188F4A89C7EB07F7A6CC2281016EF492FBEC5BE2
          66CAFEF234BB97404C05E3A3E308090B41E27B1D966D59F7DBE57AD1DCD64B54
          BB01850C4DEB95B97B5C2EFFEF4033D98D7EDBF4CF7BB0330C938DEF662C22C1
          087D85BDF42122A826138DFB72B5DB9C0E1E7F1B9BBB6E616287040EDD27EB44
          E9D7D550065A3D82F01C254AE42B10897F8CA645018A514216F366B77EA6C591
          4A91F107EBBCF55649D8DD0B0000000049454E44AE426082}
        Name = 'PngImage1'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C0000026A4944415478DA8D93DF6B526118C79FE339B15D858A95
          A514FD80A02E8C494191186C483F5C1775D71FA0A208C29820921179E5AE6220
          14ECA60B83A48D6CB5098ED58C8222C98B49413BB9505B66EA76A662A9A7E77D
          3907CE0EBBE88187F3BCDFE7BC9FF3BCCFFB1C86611850D85DF4D3E8ABE87760
          A7ED9A635480A7C160F0463C1E5FD26834632CCB52B1DFEFC36030C878BDDED1
          582C368BD2CDDD00F70C06C3558BC53292CFE773B8FE88EE92720FD1AD72AE56
          ABBDC4F56D3520158D46C7EBF53AF47A0089C4A3BCB2B4402060D9DADA844EE7
          0F4C4FDF7F8ED27535603E12895CE3F93568B74528163F83CD66A3896C360B4E
          A7134AA512341A02CCCD255FA0EC540316C2E1F065022816D7A1DBEDEEE8A05E
          AF0793C94401A9D4EC224A57948029AD563B6EB55A4F361A0DBAC16C36D30DC4
          CAE532FDBA4EA7454013789EFFD26C36C93126654026140A8DB65ADBF872857A
          A1B0FA555981C3E13861341AB1071D5C713033F36009833119F06A6262C25EAD
          6E40A5B20143433A585959FC86B95B24298A62C2E3F11CADD77F63BE82EB6148
          A79FBDC6D4251990C52E5F5401BEA37E442A601D018795804C66FE0DEA3619F0
          D6EFF79F5702B2D97499B4420294DC6EB74909585E5E7887FA0519F0DEE7F39D
          253D10846D60D961BCAA273F503F24012A2E97EB2039BF2008B407C9E4E30F18
          9C93019FEC76BB856535D06C6ED21D3871557C1C90003F7126F6731C0764D088
          E57239326867E42158C3128FB55A2D5A01C7D10A6AD8BC7DD25DFFC20A0C9D4E
          9B56208A1C19261E53C719E99C64D64794D7869B0A089894E2298C4FA9FE4EF2
          BFB808602F3D14C01E7416FECFFAE87FD17BFF009812227113773F3F00000000
          49454E44AE426082}
        Name = 'PngImage2'
        Background = clWindow
      end>
    Left = 40
    Top = 24
    Bitmap = {}
  end
  object qryStatuses: TpFIBDataSet [29]
    SelectSQL.Strings = (
      'select *'
      'from statuses s'
      'order by s.status_id')
    Active = True
    Transaction = trnRead
    Database = dmOtto.dbOtto
    Left = 560
    Top = 16
  end
  object qryOrderFullSpecification: TpFIBDataSet [30]
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
    Left = 680
    Top = 8
  end
  object ProgressCheckAvail: TJvProgressComponent [31]
    Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1076#1086#1089#1090#1091#1087#1085#1086#1089#1090#1080
    OnShow = ProgressCheckAvailShow
    Left = 480
    Top = 16
  end
  inherited trnWrite: TpFIBTransaction
    Active = True
  end
  inherited trnRead: TpFIBTransaction
    Active = True
  end
end
