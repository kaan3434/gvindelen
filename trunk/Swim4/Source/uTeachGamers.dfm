object frmTeachGamers: TfrmTeachGamers
  Left = 0
  Top = 0
  Caption = #1053#1077#1080#1079#1074#1077#1089#1090#1085#1099#1077' '#1091#1095#1072#1089#1090#1085#1080#1082#1080
  ClientHeight = 598
  ClientWidth = 810
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXSplitter1: TSpTBXSplitter
    Left = 0
    Top = 274
    Width = 810
    Height = 5
    Cursor = crSizeNS
    Align = alBottom
  end
  object SpTBXPanel1: TSpTBXPanel
    Left = 0
    Top = 279
    Width = 810
    Height = 319
    Caption = 'SpTBXPanel1'
    Align = alBottom
    TabOrder = 1
    object SpTBXSplitter2: TSpTBXSplitter
      Left = 2
      Top = 2
      Height = 315
      Cursor = crSizeWE
    end
    object SpTBXDockablePanel3: TSpTBXDockablePanel
      Left = 7
      Top = 2
      Width = 792
      Height = 315
      Caption = #1048#1079#1074#1077#1090#1089#1085#1099#1077' '#1091#1095#1072#1089#1090#1085#1080#1082#1080
      Align = alClient
      TabOrder = 1
      Options.Close = False
      object gridAGamers: TDBGridEh
        Left = 0
        Top = 40
        Width = 467
        Height = 275
        Align = alClient
        AutoFitColWidths = True
        Color = clBtnFace
        DataGrouping.GroupLevels = <>
        DataSource = dsAGamers
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
        OnDblClick = gridAGamersDblClick
        Columns = <
          item
            EditButtons = <>
            FieldName = 'AGAMER_NAME'
            Footers = <>
            Width = 200
          end
          item
            AutoFitColWidth = False
            EditButtons = <>
            FieldName = 'COUNTRY_SIGN'
            Footers = <>
            Width = 30
          end
          item
            DisplayFormat = 'dd.mm.yyyy'
            EditButtons = <>
            FieldName = 'USED_DT'
            Footers = <>
          end
          item
            EditButtons = <>
            FieldName = 'AGAMER_ID'
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
      object SpTBXToolbar1: TSpTBXToolbar
        Left = 0
        Top = 19
        Width = 792
        Height = 21
        Align = alTop
        FullSize = True
        TabOrder = 2
        Caption = 'SpTBXToolbar1'
        DesignSize = (
          792
          21)
        object SpTBXLabelItem1: TSpTBXLabelItem
          Caption = 'Gamer'
        end
        object TBControlItem1: TTBControlItem
          Control = edAGamerName
        end
        object SpTBXLabelItem2: TSpTBXLabelItem
          Caption = 'Country'
        end
        object TBControlItem2: TTBControlItem
          Control = lcbCountry
        end
        object cbTemporary: TSpTBXItem
          Caption = #1042#1088#1077#1084#1077#1085#1085#1086
          AutoCheck = True
        end
        object cbGamerOnTournir: TSpTBXItem
          Action = actFilterByTournir
        end
        object SpTBXSeparatorItem1: TSpTBXSeparatorItem
        end
        object SpTBXItem1: TSpTBXItem
          Action = actAGamerAdd
        end
        object edAGamerName: TDBEditEh
          Left = 41
          Top = 0
          Width = 400
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          EditButtons = <
            item
              Action = actAppendCountry
              Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1090#1088#1072#1085#1091
              Style = ebsPlusEh
            end
            item
              Action = actTranslit
              Hint = 'Translit'
              Style = ebsEllipsisEh
            end
            item
              Action = aUpCaseFirst
              Hint = 'UpCase First'
              Style = ebsUpDownEh
            end
            item
              Action = actSearchPair
              Hint = 'Search Pair'
              Style = ebsMinusEh
            end>
          ParentShowHint = False
          TabOrder = 0
          Visible = True
          OnChange = edAGamerNameChange
        end
        object lcbCountry: TDBLookupComboboxEh
          Left = 490
          Top = 0
          Width = 89
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DropDownBox.Options = []
          DropDownBox.Sizable = True
          DropDownBox.Width = 200
          EditButtons = <>
          KeyField = 'COUNTRY_SIGN'
          ListField = 'COUNTRY_NAME_ENG'
          ListSource = dsCountry
          TabOrder = 1
          Visible = True
          OnChange = lcbCountryChange
        end
      end
      object SpTBXSplitter3: TSpTBXSplitter
        Left = 467
        Top = 40
        Height = 275
        Cursor = crSizeWE
        Align = alRight
      end
      object DBGridEh1: TDBGridEh
        Left = 472
        Top = 40
        Width = 320
        Height = 275
        Align = alRight
        AutoFitColWidths = True
        Color = clBtnFace
        DataGrouping.GroupLevels = <>
        DataSource = dsOpponents
        Flat = False
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'Tahoma'
        FooterFont.Style = []
        IndicatorOptions = [gioShowRowIndicatorEh]
        TabOrder = 4
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        Columns = <
          item
            EditButtons = <>
            FieldName = 'ATOURNIR_NAME'
            Footers = <>
            Width = 100
          end
          item
            EditButtons = <>
            FieldName = 'AGAMER_NAME'
            Footers = <>
            Width = 100
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
    object SpTBXMultiDock1: TSpTBXMultiDock
      Left = 799
      Top = 2
      Width = 9
      Height = 315
      Position = dpxRight
    end
  end
  object gridBGamers: TDBGridEh
    Left = 0
    Top = 0
    Width = 810
    Height = 274
    Align = alClient
    AutoFitColWidths = True
    Color = clBtnFace
    DataGrouping.GroupLevels = <>
    DataSource = dsBGamers
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
    STFilter.InstantApply = False
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        AutoFitColWidth = False
        DisplayFormat = 'dd.mm.yyyy hh:nn'
        EditButtons = <>
        FieldName = 'EVENT_DTM'
        Footers = <>
        Width = 100
      end
      item
        EditButtons = <>
        FieldName = 'GAMER_NAME'
        Footers = <>
        Width = 250
      end
      item
        EditButtons = <>
        FieldName = 'ATOURNIR_NAME'
        Footers = <>
        Width = 200
      end
      item
        EditButtons = <>
        FieldName = 'COUNTRY_SIGN'
        Footers = <>
        Width = 30
      end
      item
        EditButtons = <>
        FieldName = 'ASPORT_NAME'
        Footers = <>
        Width = 150
      end
      item
        EditButtons = <>
        FieldName = 'BOOKER_NAME'
        Footers = <>
      end
      item
        EditButtons = <>
        FieldName = 'BEVENT_ID'
        Footers = <>
      end
      item
        EditButtons = <>
        FieldName = 'OPPONENT_NAME'
        Footers = <>
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object dsBGamers: TDataSource
    AutoEdit = False
    DataSet = qryBGamers
    Left = 200
    Top = 56
  end
  object dsAGamers: TDataSource
    AutoEdit = False
    DataSet = qryAGamers
    Left = 200
    Top = 104
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
    Left = 40
    Top = 56
  end
  object trnRead: TpFIBTransaction
    Active = True
    DefaultDatabase = dmFormMain.dbSwim
    TimeoutAction = TARollback
    TRParams.Strings = (
      'read'
      'nowait'
      'rec_version'
      'read_committed')
    AfterStart = trnReadAfterStart
    TPBMode = tpbDefault
    Left = 40
    Top = 104
  end
  object qryBGamers: TpFIBDataSet
    SelectSQL.Strings = (
      
        'select bt.asport_id, bt.asport_name, bt.atournir_id, bt.atournir' +
        '_name, '
      
        '  bt.country_sign, gmr.event_dtm, gmr.gamer_name, bt.booker_name' +
        ', gmr.bevent_id, gmr.opponent_name'
      
        'from (select be1.bevent_id, be1.btournir_id, be1.event_dtm, be1.' +
        'bgamer1_name gamer_name, be1.bgamer2_name opponent_name'
      '  from bevents be1'
      '  where be1.agamer1_id is null'
      '    and nullif(be1.bgamer1_name, '#39#39') is not null'
      '  union'
      
        '  select be2.bevent_id, be2.btournir_id, be2.event_dtm, be2.bgam' +
        'er2_name, be2.bgamer1_name'
      '  from bevents be2'
      '  where be2.agamer2_id is null'
      '    and nullif(be2.bgamer2_name, '#39#39') is not null) gmr'
      
        'inner join v_btournirs bt on (bt.btournir_id = gmr.btournir_id a' +
        'nd bt.atournir_id is not null)'
      
        'order by bt.teach_order, bt.asport_id, bt.country_sign, bt.atour' +
        'nir_lvl')
    AfterScroll = qryBGamersAfterScroll
    Transaction = trnRead
    Database = dmFormMain.dbSwim
    Left = 136
    Top = 56
  end
  object qryAGamers: TpFIBDataSet
    SelectSQL.Strings = (
      'select distinct ag.agamer_id, ag.agamer_name, ag.used_dt'
      'from agamers ag '
      '  left join v_atournir c on (c.agamer_id = ag.agamer_id)'
      'where ag.asport_id = :asport_id'
      '  and (coalesce(:atournir_id, 0) = 0 or'
      '       coalesce(:atournir_id, c.atournir_id) = c.atournir_id or'
      
        '       c.atournir_id in (select a.atournir_id from atournirs a w' +
        'here a.mtournir_id = :atournir_id))'
      '  and (ag.country_sign = :country_sign or'
      '       ag.country_sign in (select r.country_sign'
      '                          from regions r '
      '                          where r.region_sign = :country_sign))'
      'order by ag.agamer_name')
    CacheModelOptions.CacheModelKind = cmkLimitedBufferSize
    CacheModelOptions.BufferChunks = 100
    BeforeOpen = qryAGamersBeforeOpen
    Transaction = trnRead
    Database = dmFormMain.dbSwim
    Left = 136
    Top = 104
  end
  object ActionList: TActionList
    Left = 80
    Top = 56
    object actAGamerAdd: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      OnExecute = actAGamerAddExecute
    end
    object actAGamerLink: TAction
      Caption = #1057#1074#1103#1079#1072#1090#1100' '#1080#1075#1088#1086#1082#1086#1074
      OnExecute = actAGamerLinkExecute
    end
    object actFillEditForm: TAction
      Caption = 'actFillEditForm'
      OnExecute = actFillEditFormExecute
    end
    object actFilterByTournir: TAction
      AutoCheck = True
      Caption = 'In tournir'
      OnExecute = actFilterByTournirExecute
    end
    object actAppendCountry: TAction
      Caption = 'actAppendCountry'
      OnExecute = actAppendCountryExecute
      OnUpdate = actAppendCountryUpdate
    end
    object actSearchAGamer: TAction
      Caption = 'actSearchAGamer'
      OnExecute = actSearchAGamerExecute
    end
    object actTranslit: TAction
      Caption = 'actTranslit'
      OnExecute = actTranslitExecute
    end
    object aUpCaseFirst: TAction
      Caption = 'aUpCaseFirst'
      OnExecute = aUpCaseFirstExecute
    end
    object actSearchPair: TAction
      Caption = 'actSearchPair'
      OnExecute = actSearchPairExecute
    end
    object Action1: TAction
      Caption = 'Action1'
    end
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
    Left = 136
    Top = 152
    oStartTransaction = False
  end
  object dsCountry: TDataSource
    AutoEdit = False
    DataSet = qryCountries
    Left = 200
    Top = 152
  end
  object spTempSignle: TpFIBStoredProc
    Transaction = trnWrite
    Database = dmFormMain.dbSwim
    Left = 40
    Top = 160
    qoAutoCommit = True
    qoStartTransaction = True
  end
  object spTemp: TpFIBStoredProc
    Transaction = trnRead
    Database = dmFormMain.dbSwim
    Left = 40
    Top = 208
  end
  object dsOpponents: TDataSource
    AutoEdit = False
    DataSet = qryOpponents
    Left = 208
    Top = 208
  end
  object qryOpponents: TpFIBDataSet
    SelectSQL.Strings = (
      'select *'
      
        'from (select ae1.aevent_id, ae1.atournir_id, ae1.agamer2_id agam' +
        'er_id'
      'from aevents ae1'
      'union'
      'select ae2.aevent_id, ae2.atournir_id, ae2.agamer1_id'
      'from aevents ae2) ae'
      'inner join atournirs t on (t.atournir_id = ae.atournir_id)'
      'inner join agamers g on (g.agamer_id = ae.agamer_id)'
      'where ae.agamer_id = :agamer_id')
    Active = True
    Transaction = trnRead
    Database = dmFormMain.dbSwim
    UpdateTransaction = dmFormMain.trnWrite
    DataSource = dsAGamers
    Left = 136
    Top = 208
  end
end
