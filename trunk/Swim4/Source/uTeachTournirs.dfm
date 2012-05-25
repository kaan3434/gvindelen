object frmTeachTournirs: TfrmTeachTournirs
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'frmTeachTournirs'
  ClientHeight = 679
  ClientWidth = 961
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 217
    Width = 961
    Height = 3
    Cursor = crVSplit
    Align = alTop
    ExplicitTop = 201
    ExplicitWidth = 241
  end
  object Label4: TLabel
    Left = 56
    Top = 376
    Width = 31
    Height = 13
    Caption = 'Label4'
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 961
    Height = 217
    Align = alTop
    Caption = #1053#1077#1080#1079#1074#1077#1089#1090#1085#1099#1077' '#1090#1091#1088#1085#1080#1088#1099
    TabOrder = 0
    object gridBTournirs: TDBGridEh
      Left = 2
      Top = 15
      Width = 957
      Height = 200
      Align = alClient
      AutoFitColWidths = True
      Color = clBtnFace
      DataGrouping.GroupLevels = <>
      DataSource = dsBTournirs
      Flat = True
      FooterColor = clWindow
      FooterFont.Charset = DEFAULT_CHARSET
      FooterFont.Color = clWindowText
      FooterFont.Height = -11
      FooterFont.Name = 'Tahoma'
      FooterFont.Style = []
      IndicatorOptions = [gioShowRowIndicatorEh]
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghColumnResize, dghColumnMove, dghExtendVertLines]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      Columns = <
        item
          EditButtons = <>
          FieldName = 'ASPORT_NAME'
          Footers = <>
        end
        item
          EditButtons = <>
          FieldName = 'BTOURNIR_NAME'
          Footers = <>
          Width = 200
        end
        item
          EditButtons = <>
          FieldName = 'ATOURNIR_NAME'
          Footers = <>
          Width = 200
        end
        item
          AutoFitColWidth = False
          EditButtons = <>
          FieldName = 'COUNTRY_SIGN'
          Footers = <>
          Width = 25
        end
        item
          AutoFitColWidth = False
          EditButtons = <>
          FieldName = 'BOOKER_NAME'
          Footers = <>
          Width = 100
        end
        item
          EditButtons = <>
          FieldName = 'BTOURNIR_MASK'
          Footers = <>
          Width = 100
        end
        item
          AutoFitColWidth = False
          Checkboxes = True
          EditButtons = <>
          FieldName = 'IGNORE_FLG'
          Footers = <>
          Width = 16
        end
        item
          AutoFitColWidth = False
          EditButtons = <>
          FieldName = 'USED_DT'
          Footers = <>
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 220
    Width = 961
    Height = 459
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 1
    object SpTBXMultiDock2: TSpTBXMultiDock
      Left = 0
      Top = 0
      Width = 313
      Height = 459
      object SpTBXDockablePanel1: TSpTBXDockablePanel
        Left = 0
        Top = 0
        Width = 313
        Height = 459
        Caption = #1056#1077#1075#1080#1089#1090#1088#1072#1094#1080#1103' '#1090#1091#1088#1085#1080#1088#1072
        DockPos = 1
        TabOrder = 0
        Options.Close = False
        DesignSize = (
          309
          455)
        object Label1: TLabel
          Left = 12
          Top = 26
          Width = 73
          Height = 13
          Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        end
        object Label2: TLabel
          Left = 12
          Top = 66
          Width = 31
          Height = 13
          Caption = #1052#1072#1089#1082#1072
        end
        object Label3: TLabel
          Left = 12
          Top = 106
          Width = 31
          Height = 13
          Caption = #1057#1087#1086#1088#1090
        end
        object Label5: TLabel
          Left = 11
          Top = 146
          Width = 37
          Height = 13
          Caption = #1057#1090#1088#1072#1085#1072
        end
        object Label6: TLabel
          Left = 12
          Top = 186
          Width = 43
          Height = 13
          Caption = #1059#1088#1086#1074#1077#1085#1100
        end
        object SpTBXButton1: TSpTBXButton
          Left = 223
          Top = 227
          Width = 75
          Height = 25
          Action = actATournirNew
          Anchors = [akTop, akRight]
          TabOrder = 1
          DrawPushedCaption = False
        end
        object edTournirName: TDBEditEh
          Left = 12
          Top = 40
          Width = 286
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          EditButtons = <>
          TabOrder = 2
          Visible = True
        end
        object edTournirMask: TDBEditEh
          Left = 12
          Top = 80
          Width = 286
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          EditButtons = <>
          TabOrder = 3
          Visible = True
        end
        object lcbASport: TDBLookupComboboxEh
          Left = 12
          Top = 120
          Width = 286
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          EditButtons = <>
          KeyField = 'ASPORT_ID'
          ListField = 'ASPORT_NAME'
          ListSource = dsASports
          TabOrder = 4
          Visible = True
          OnChange = lcbASportChange
        end
        object lcbCountry: TDBLookupComboboxEh
          Left = 12
          Top = 160
          Width = 286
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DropDownBox.ListSource = dsCountries
          DropDownBox.Options = []
          EditButtons = <>
          KeyField = 'COUNTRY_SIGN'
          ListField = 'COUNTRY_NAME_ENG'
          ListSource = dsCountries
          TabOrder = 5
          Visible = True
          OnChange = lcbCountryChange
        end
        object edTournirLevel: TDBNumberEditEh
          Left = 12
          Top = 200
          Width = 43
          Height = 21
          EditButton.Style = ebsAltUpDownEh
          EditButton.Visible = True
          EditButtons = <>
          TabOrder = 6
          Value = 1.000000000000000000
          Visible = True
        end
        object cbSwapable: TCheckBox
          Left = 77
          Top = 202
          Width = 92
          Height = 17
          Caption = #1055#1077#1088#1077#1074#1077#1088#1090#1099#1096
          TabOrder = 7
        end
        object cbIgnore: TCheckBox
          Left = 201
          Top = 202
          Width = 97
          Height = 17
          Caption = #1048#1075#1085#1086#1088#1080#1088#1086#1074#1072#1090#1100
          TabOrder = 8
        end
        object SpTBXButton2: TSpTBXButton
          Left = 120
          Top = 227
          Width = 75
          Height = 25
          Action = actBTournirMaskAdd
          TabOrder = 9
          DrawPushedCaption = False
        end
        object SpTBXButton3: TSpTBXButton
          Left = 12
          Top = 227
          Width = 75
          Height = 25
          Action = actBTournirPostpone
          TabOrder = 10
          DrawPushedCaption = False
        end
      end
    end
    object SpTBXDockablePanel2: TSpTBXDockablePanel
      Left = 313
      Top = 0
      Width = 648
      Height = 459
      Caption = #1047#1072#1088#1077#1075#1080#1089#1090#1088#1080#1088#1086#1074#1072#1085#1085#1099#1077' '#1090#1091#1088#1085#1080#1088#1099
      Align = alClient
      TabOrder = 1
      Options.Close = False
      object gridATournirs: TDBGridEh
        Left = 0
        Top = 19
        Width = 648
        Height = 440
        Align = alClient
        AutoFitColWidths = True
        Color = clBtnFace
        DataGrouping.GroupLevels = <>
        DataSource = dsATournirs
        Flat = True
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'Tahoma'
        FooterFont.Style = []
        IndicatorOptions = [gioShowRowIndicatorEh]
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghColumnResize, dghColumnMove, dghExtendVertLines]
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnDblClick = gridATournirsDblClick
        Columns = <
          item
            AutoFitColWidth = False
            EditButtons = <>
            FieldName = 'ATOURNIR_LVL'
            Footers = <>
            Width = 25
          end
          item
            EditButtons = <>
            FieldName = 'ATOURNIR_NAME'
            Footers = <>
            Width = 200
          end
          item
            AutoFitColWidth = False
            EditButtons = <>
            FieldName = 'COUNTRY_SIGN'
            Footers = <>
            Width = 25
          end
          item
            AutoFitColWidth = False
            EditButtons = <>
            FieldName = 'START_DT'
            Footers = <>
          end
          item
            AutoFitColWidth = False
            EditButtons = <>
            FieldName = 'END_DT'
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
  end
  object trnWrite: TpFIBTransaction
    DefaultDatabase = dmFormMain.dbSwim
    TimeoutAction = TARollback
    TRParams.Strings = (
      'write'
      'nowait'
      'rec_version'
      'read_committed')
    AfterEnd = trnWriteAfterEnd
    TPBMode = tpbDefault
    Left = 48
    Top = 24
  end
  object qryBTournirs: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    BTOURNIR_ID,'
      '    BTOURNIR_NAME,'
      '    ATOURNIR_ID,'
      '    ATOURNIR_LVL,'
      '    ATOURNIR_NAME,'
      '    COUNTRY_SIGN,'
      '    SWAPABLE,'
      '    ASPORT_ID,'
      '    ASPORT_NAME,'
      '    BSPORT_ID,'
      '    BOOKER_ID,'
      '    BOOKER_NAME,'
      '    IGNORE_FLG,'
      '    USED_DT    '
      'FROM'
      '    V_BTOURNIRS '
      'WHERE ATOURNIR_ID is null and coalesce(IGNORE_FLG, 0)=0'
      'ORDER BY IGNORE_FLG, ATOURNIR_ID, ASPORT_ID, USED_DT DESC')
    CacheModelOptions.CacheModelKind = cmkLimitedBufferSize
    CacheModelOptions.BufferChunks = 100
    AfterScroll = qryBTournirsAfterScroll
    AllowedUpdateKinds = []
    Transaction = trnRead
    Database = dmFormMain.dbSwim
    Left = 112
    Top = 24
    oStartTransaction = False
  end
  object dsBTournirs: TDataSource
    AutoEdit = False
    DataSet = qryBTournirs
    Left = 160
    Top = 24
  end
  object qryASports: TpFIBDataSet
    SelectSQL.Strings = (
      'select *'
      'from asports a'
      'order by a.asport_id')
    CacheModelOptions.BufferChunks = 100
    AllowedUpdateKinds = []
    Transaction = trnRead
    Database = dmFormMain.dbSwim
    Left = 112
    Top = 80
    oStartTransaction = False
  end
  object qryATournirs: TpFIBDataSet
    SelectSQL.Strings = (
      'select a.atournir_id, '
      '       a.atournir_name, '
      '       a.atournir_lvl, '
      '       a.country_sign, '
      '       a.start_dt, '
      '       a.end_dt'
      'from atournirs a'
      'where a.asport_id = coalesce(:asport_id, a.asport_id)'
      '  and a.country_sign = :region_sign'
      'order by a.start_dt desc')
    CacheModelOptions.CacheModelKind = cmkLimitedBufferSize
    CacheModelOptions.BufferChunks = 100
    AllowedUpdateKinds = []
    Transaction = trnRead
    Database = dmFormMain.dbSwim
    Left = 112
    Top = 128
    oStartTransaction = False
  end
  object qryCountries: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    COUNTRY_SIGN,'
      '    COUNTRY_NAME_ENG,'
      '    COUNTRY_NAME_RUS'
      'FROM COUNTRIES '
      'ORDER BY COUNTRY_NAME_ENG')
    CacheModelOptions.BufferChunks = 100
    AllowedUpdateKinds = []
    Transaction = trnRead
    Database = dmFormMain.dbSwim
    Left = 112
    Top = 184
    oStartTransaction = False
  end
  object dsASports: TDataSource
    AutoEdit = False
    DataSet = qryASports
    Left = 160
    Top = 80
  end
  object dsATournirs: TDataSource
    AutoEdit = False
    DataSet = qryATournirs
    Left = 160
    Top = 128
  end
  object dsCountries: TDataSource
    AutoEdit = False
    DataSet = qryCountries
    Left = 160
    Top = 184
  end
  object ActionList: TActionList
    Left = 48
    Top = 128
    object actATournirNew: TAction
      Caption = #1057#1086#1079#1076#1072#1090#1100
      OnExecute = actATournirNewExecute
      OnUpdate = actATournirNewUpdate
    end
    object actBTournirIgnore: TAction
      Caption = #1048#1075#1085#1086#1088#1080#1088#1086#1074#1072#1090#1100
    end
    object actBTournirLink: TAction
      Caption = #1057#1074#1103#1079#1072#1090#1100
      OnExecute = actBTournirLinkExecute
    end
    object actFillEditForm: TAction
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1092#1086#1088#1084#1091
      OnExecute = actFillEditFormExecute
    end
    object actBTournirMaskAdd: TAction
      Caption = #1054#1073#1091#1095#1080#1090#1100
      OnExecute = actBTournirMaskAddExecute
      OnUpdate = actBTournirMaskAddUpdate
    end
    object actBTournirPostpone: TAction
      Caption = #1054#1090#1083#1086#1078#1080#1090#1100
      OnExecute = actBTournirPostponeExecute
    end
  end
  object trnRead: TpFIBTransaction
    DefaultDatabase = dmFormMain.dbSwim
    TimeoutAction = TARollback
    AfterStart = trnReadAfterStart
    Left = 48
    Top = 72
  end
  object spTempSignle: TpFIBStoredProc
    Transaction = trnWrite
    Database = dmFormMain.dbSwim
    Left = 48
    Top = 176
    qoAutoCommit = True
    qoStartTransaction = True
  end
  object spTemp: TpFIBStoredProc
    Transaction = trnRead
    Database = dmFormMain.dbSwim
    Left = 48
    Top = 224
  end
end
