inherited WzArticlesOtto: TWzArticlesOtto
  Left = 261
  Top = 151
  ActiveControl = wzWPage1
  Caption = #1040#1088#1090#1080#1082#1091#1083#1099' OTTO'
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited wzForm: TJvWizard
    ActivePage = wzWPage1
    ButtonFinish.ModalResult = 6
    OnFinishButtonClick = wzFormFinishButtonClick
    object wzWPage1: TJvWizardWelcomePage
      Header.ParentFont = False
      Header.Title.Color = clNone
      Header.Title.Text = 'Welcome'
      Header.Title.Anchors = [akLeft, akTop, akRight]
      Header.Title.Font.Charset = DEFAULT_CHARSET
      Header.Title.Font.Color = clWindowText
      Header.Title.Font.Height = -16
      Header.Title.Font.Name = 'MS Sans Serif'
      Header.Title.Font.Style = [fsBold]
      Header.Subtitle.Color = clNone
      Header.Subtitle.Text = 
        #1048#1089#1087#1086#1100#1079#1091#1103' '#1076#1072#1085#1085#1099#1081' Wizard '#1074#1099' '#1084#1086#1078#1077#1090#1077' '#1088#1077#1075#1080#1089#1090#1088#1080#1088#1086#1074#1072#1090#1100' '#1080' '#1079#1072#1075#1088#1091#1078#1103#1090#1100' '#1082#1072#1090#1072 +
        #1083#1086#1075#1080
      Header.Subtitle.Anchors = [akLeft, akTop, akRight, akBottom]
      Header.Subtitle.Font.Charset = DEFAULT_CHARSET
      Header.Subtitle.Font.Color = clWindowText
      Header.Subtitle.Font.Height = -11
      Header.Subtitle.Font.Name = 'MS Sans Serif'
      Header.Subtitle.Font.Style = []
      Panel.Visible = True
      Caption = 'wzWPage1'
    end
    object wzIPageMagazines: TJvWizardInteriorPage
      Header.ParentFont = False
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
      VisibleButtons = [bkLast, bkBack, bkNext, bkCancel]
      OnEnterPage = wzIPageMagazinesEnterPage
      OnNextButtonClick = wzIPageMagazinesNextButtonClick
      object pnlCenterOnMagazines: TJvPanel
        Left = 0
        Top = 70
        Width = 608
        Height = 405
        HotTrackFont.Charset = DEFAULT_CHARSET
        HotTrackFont.Color = clWindowText
        HotTrackFont.Height = -11
        HotTrackFont.Name = 'MS Sans Serif'
        HotTrackFont.Style = []
        Align = alClient
        BorderWidth = 4
        TabOrder = 0
        object grBoxMagazines: TJvGroupBox
          Left = 5
          Top = 5
          Width = 606
          Height = 399
          Align = alClient
          Caption = #1046#1091#1088#1085#1072#1083#1099
          TabOrder = 0
          object grdMagazines: TDBGridEh
            Left = 2
            Top = 15
            Width = 602
            Height = 382
            Align = alClient
            AutoFitColWidths = True
            DataGrouping.GroupLevels = <>
            DataSource = dsMagazines
            Flat = True
            FooterColor = clWindow
            FooterFont.Charset = DEFAULT_CHARSET
            FooterFont.Color = clWindowText
            FooterFont.Height = -11
            FooterFont.Name = 'MS Sans Serif'
            FooterFont.Style = []
            Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
            OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghColumnResize, dghColumnMove, dghExtendVertLines]
            ReadOnly = True
            RowDetailPanel.Color = clBtnFace
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'MS Sans Serif'
            TitleFont.Style = []
            OnDblClick = grdMagazinesDblClick
            Columns = <
              item
                EditButtons = <>
                FieldName = 'MAGAZINE_NAME'
                Footers = <>
                Width = 300
              end
              item
                EditButtons = <>
                FieldName = 'VALID_DATE'
                Footers = <>
              end
              item
                EditButtons = <>
                FieldName = 'STATUS_NAME'
                Footers = <>
                Width = 200
              end>
            object RowDetailData: TRowDetailPanelControlEh
            end
          end
        end
      end
      object pnlLeftOnMagazines: TJvPanel
        Left = 608
        Top = 70
        Width = 400
        Height = 405
        HotTrackFont.Charset = DEFAULT_CHARSET
        HotTrackFont.Color = clWindowText
        HotTrackFont.Height = -11
        HotTrackFont.Name = 'MS Sans Serif'
        HotTrackFont.Style = []
        Align = alRight
        BorderWidth = 4
        Constraints.MaxWidth = 400
        Constraints.MinWidth = 400
        TabOrder = 1
        object grBoxMagazineOnMagazines: TJvGroupBox
          Left = 5
          Top = 5
          Width = 390
          Height = 395
          Align = alClient
          Caption = 'grBoxMagazineOnMagazines'
          TabOrder = 0
          object lblCatalog: TLabel
            Left = 16
            Top = 32
            Width = 81
            Height = 21
            AutoSize = False
            Caption = #1050#1072#1090#1072#1083#1086#1075
            Layout = tlCenter
          end
          object lblValidDate: TLabel
            Left = 16
            Top = 64
            Width = 81
            Height = 21
            AutoSize = False
            Caption = #1044#1077#1081#1089#1090#1074#1091#1077#1090' '#1076#1086':'
            Layout = tlCenter
          end
          object lblMagazineName: TLabel
            Left = 16
            Top = 96
            Width = 81
            Height = 21
            AutoSize = False
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1085#1072#1080#1077
            Layout = tlCenter
          end
          object cbCatalog: TDBComboBoxEh
            Left = 104
            Top = 32
            Width = 257
            Height = 21
            EditButtons = <>
            TabOrder = 0
            Visible = True
          end
          object dtedValidDate: TDBDateTimeEditEh
            Left = 104
            Top = 64
            Width = 121
            Height = 21
            EditButtons = <>
            Kind = dtkDateEh
            TabOrder = 1
            Visible = True
          end
          object dedMagazineName: TDBEditEh
            Left = 104
            Top = 96
            Width = 257
            Height = 21
            EditButtons = <>
            TabOrder = 2
            Visible = True
            OnEnter = dedMagazineNameEnter
          end
        end
      end
    end
    object wzIPageImport: TJvWizardInteriorPage
      Header.ParentFont = False
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
      VisibleButtons = [bkLast, bkBack, bkNext, bkCancel]
      Caption = 'wzIPageImport'
      OnNextButtonClick = wzIPageImportNextButtonClick
      object pnlCenterOnImport: TJvPanel
        Left = 0
        Top = 70
        Width = 1016
        Height = 115
        HotTrackFont.Charset = DEFAULT_CHARSET
        HotTrackFont.Color = clWindowText
        HotTrackFont.Height = -11
        HotTrackFont.Name = 'MS Sans Serif'
        HotTrackFont.Style = []
        Align = alTop
        BorderWidth = 4
        Caption = 'pnlCenterOnImport'
        TabOrder = 0
        object grBoxMagazineOnImport: TJvGroupBox
          Left = 5
          Top = 5
          Width = 1006
          Height = 105
          Align = alClient
          Caption = 'grBoxMagazineOnImport'
          TabOrder = 0
          object lblMagazineFileName: TLabel
            Left = 16
            Top = 32
            Width = 101
            Height = 13
            Caption = #1060#1072#1081#1083' '#1089' '#1072#1088#1090#1080#1082#1091#1083#1072#1084#1080
          end
          object edtFileName: TJvFilenameEdit
            Left = 16
            Top = 48
            Width = 953
            Height = 21
            TabOrder = 0
            OnChange = edtFileNameChange
          end
        end
      end
    end
    object wzIPageFinal: TJvWizardInteriorPage
      Header.ParentFont = False
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
      VisibleButtons = [bkBack, bkFinish, bkCancel]
      Caption = 'wzIPageFinal'
      OnEnterPage = wzIPageFinalEnterPage
      object pnl1: TJvPanel
        Left = 0
        Top = 70
        Width = 1008
        Height = 187
        HotTrackFont.Charset = DEFAULT_CHARSET
        HotTrackFont.Color = clWindowText
        HotTrackFont.Height = -11
        HotTrackFont.Name = 'MS Sans Serif'
        HotTrackFont.Style = []
        Align = alTop
        BorderWidth = 4
        Caption = 'pnlMagazineOnFinal'
        TabOrder = 0
        object grBoxMagazineOnFinal: TJvGroupBox
          Left = 5
          Top = 5
          Width = 998
          Height = 177
          Align = alClient
          Caption = 'grBoxMagazineOnFinal'
          TabOrder = 0
          object lbl1: TLabel
            Left = 16
            Top = 32
            Width = 81
            Height = 21
            AutoSize = False
            Caption = #1050#1072#1090#1072#1083#1086#1075
            Layout = tlCenter
          end
          object lbl3: TLabel
            Left = 16
            Top = 64
            Width = 81
            Height = 21
            AutoSize = False
            Caption = #1044#1077#1081#1089#1090#1074#1091#1077#1090' '#1076#1086':'
            Layout = tlCenter
          end
          object lbl4: TLabel
            Left = 16
            Top = 96
            Width = 97
            Height = 21
            AutoSize = False
            Caption = #1050#1086#1083'-'#1074#1086' '#1072#1088#1090#1080#1082#1091#1083#1086#1074
            Layout = tlCenter
          end
          object dtedValidDateOnFinal: TDBDateTimeEditEh
            Left = 120
            Top = 64
            Width = 89
            Height = 21
            Alignment = taCenter
            Color = clBtnFace
            EditButton.Visible = False
            EditButtons = <>
            Kind = dtkDateEh
            ReadOnly = True
            TabOrder = 1
            Value = 40544d
            Visible = True
          end
          object txtAtricleCounts: TStaticText
            Left = 120
            Top = 96
            Width = 257
            Height = 21
            AutoSize = False
            BorderStyle = sbsSunken
            TabOrder = 2
          end
          object txtCatalogNameOnFinal: TStaticText
            Left = 120
            Top = 32
            Width = 257
            Height = 21
            AutoSize = False
            BorderStyle = sbsSunken
            TabOrder = 0
          end
        end
      end
    end
  end
  inherited actListWzrdBtn: TActionList
    object actLoadMagazine: TAction
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
    end
  end
  object qryMagazines: TpFIBDataSet [2]
    SelectSQL.Strings = (
      'SELECT'
      '    M.MAGAZINE_ID,'
      '    M.CATALOG_ID,'
      '    M.MAGAZINE_NAME,'
      '    M.VALID_DATE,'
      '    M.STATUS_ID,'
      '    S.STATUS_NAME'
      'FROM MAGAZINES M'
      '  INNER JOIN STATUSES S ON (S.STATUS_ID = M.STATUS_ID)')
    Transaction = trnRead
    Database = dmOtto.dbOtto
    UpdateTransaction = trnWrite
    Left = 56
    Top = 16
    object fldMagazinesMAGAZINE_ID: TFIBIntegerField
      FieldName = 'MAGAZINE_ID'
    end
    object fldMagazinesCATALOG_ID: TFIBIntegerField
      FieldName = 'CATALOG_ID'
    end
    object fldMagazinesCATALOG_NAME: TFIBStringField
      FieldName = 'MAGAZINE_NAME'
      Size = 100
      EmptyStrToNull = True
    end
    object fldMagazinesVALID_DATE: TFIBDateField
      FieldName = 'VALID_DATE'
      DisplayFormat = 'dd.mm.yyyy'
    end
    object fldMagazinesSTATUS_ID: TFIBIntegerField
      FieldName = 'STATUS_ID'
    end
    object fldMagazinesSTATUS_NAME: TFIBStringField
      FieldName = 'STATUS_NAME'
      Size = 100
      EmptyStrToNull = True
    end
  end
  object dsMagazines: TDataSource [3]
    AutoEdit = False
    DataSet = qryMagazines
    Left = 112
    Top = 16
  end
  object vldEdits: TJvValidators [4]
    ErrorIndicator = vldIndEdits
    Left = 56
    Top = 480
    object vldRequiredCatalog: TJvRequiredFieldValidator
      ControlToValidate = cbCatalog
      PropertyToValidate = 'Text'
      GroupName = 'Magazine'
      ErrorMessage = #1053#1077' '#1091#1082#1072#1079#1072#1085#1072' '#1089#1077#1088#1080#1103' '#1082#1072#1090#1072#1083#1086#1075#1086#1074
    end
    object vldCustomValidDate: TJvCustomValidator
      ControlToValidate = dtedValidDate
      PropertyToValidate = 'Value'
      GroupName = 'Magazine'
      ErrorMessage = #1053#1077' '#1091#1082#1072#1079#1072#1085#1072' '#1076#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1076#1077#1081#1089#1090#1074#1080#1103
      OnValidate = vldCustomValidDateValidate
    end
    object vldRequiredFileName: TJvRequiredFieldValidator
      ControlToValidate = edtFileName
      PropertyToValidate = 'Text'
      GroupName = 'Import'
      ErrorMessage = #1053#1077' '#1091#1082#1072#1079#1072#1085' '#1092#1072#1081#1083' '#1089' '#1072#1088#1090#1080#1082#1091#1083#1072#1084#1080
    end
  end
  object vldIndEdits: TJvErrorIndicator [5]
    ImageIndex = 0
    Left = 96
    Top = 480
  end
  object qryTmpOttoArticle: TpFIBDataSet
    UpdateSQL.Strings = (
      'UPDATE '
      'SET '
      'WHERE'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      '    '
      'WHERE'
      '        ')
    InsertSQL.Strings = (
      'INSERT INTO ('
      ')'
      'VALUES('
      ')')
    SelectSQL.Strings = (
      'SELECT'
      '    MAGAZINE_ID,'
      '    ARTICLE_CODE,'
      '    DIMENSION,'
      '    PRICE_EUR,'
      '    WEIGHT,'
      '    DESCRIPTION'
      'FROM'
      '    TMP_OTTO_ARTICLE ')
    Transaction = trnWrite
    Database = dmOtto.dbOtto
    Left = 232
    Top = 16
  end
end
