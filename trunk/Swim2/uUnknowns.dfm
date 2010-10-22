inherited frmUnknowns: TfrmUnknowns
  Left = 500
  Top = 190
  Width = 873
  Height = 624
  Caption = 'frmUnknowns'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited Splitter1: TSplitter
    Top = 287
    Width = 865
  end
  inherited TBXDockUp: TTBXDock
    Width = 865
    inherited TBXToolbar: TTBXToolbar
      object TBXVisibilityToggleItem1: TTBXVisibilityToggleItem [4]
        Caption = 'History'
        Control = pnlHistory
      end
      inherited DBNavigator: TDBNavigator
        Hints.Strings = ()
      end
    end
  end
  inherited gridMain: TDBGridEh
    Width = 586
    Height = 261
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    Columns = <
      item
        EditButtons = <>
        FieldName = 'EVENT_ID'
        Footers = <>
        Visible = False
      end
      item
        EditButtons = <>
        FieldName = 'ASPORT_ID'
        Footers = <>
        Visible = False
      end
      item
        EditButtons = <>
        FieldName = 'ASPORT_NM'
        Footers = <>
        MaxWidth = 150
        MinWidth = 50
        Width = 150
      end
      item
        Alignment = taCenter
        AutoFitColWidth = False
        DisplayFormat = 'DD.MM.YYYY HH:MM'
        EditButtons = <>
        FieldName = 'EVENT_DTM'
        Footers = <>
        Width = 96
      end
      item
        EditButtons = <>
        FieldName = 'GAMER_NM'
        Footers = <>
        Width = 200
      end
      item
        Alignment = taCenter
        AutoFitColWidth = False
        EditButtons = <>
        FieldName = 'COUNTRY_SGN'
        Footers = <>
        Width = 40
      end
      item
        EditButtons = <>
        FieldName = 'BTOURNIR_ID'
        Footers = <>
        Visible = False
      end
      item
        EditButtons = <>
        FieldName = 'ATOURNIR_ID'
        Footers = <>
        Visible = False
      end
      item
        EditButtons = <>
        FieldName = 'ATOURNIR_NM'
        Footers = <>
        Width = 200
      end
      item
        EditButtons = <>
        FieldName = 'BOOKER_ID'
        Footers = <>
        Visible = False
      end
      item
        EditButtons = <>
        FieldName = 'BOOKER_NM'
        Footers = <>
        MaxWidth = 64
        MinWidth = 30
      end>
  end
  inherited Panel: TGvCollapsePanel
    Top = 290
    Width = 865
    Height = 300
    State = csExpand
    inherited pcDetail: TPageControl
      Width = 863
      Height = 282
      ActivePage = tsAGamers
      object tsAGamers: TTabSheet
        Caption = 'tsAGamers'
        object Splitter2: TSplitter
          Left = 502
          Top = 25
          Height = 229
          Align = alRight
        end
        object gridAGamers: TDBGridEh
          Left = 0
          Top = 25
          Width = 502
          Height = 229
          Align = alClient
          AutoFitColWidths = True
          Color = clBtnFace
          ColumnDefValues.Title.Alignment = taCenter
          ColumnDefValues.Title.ToolTips = True
          ColumnDefValues.ToolTips = True
          DataSource = dsAGamers
          Flat = True
          FooterColor = clWindow
          FooterFont.Charset = DEFAULT_CHARSET
          FooterFont.Color = clWindowText
          FooterFont.Height = -11
          FooterFont.Name = 'MS Sans Serif'
          FooterFont.Style = []
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
          OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghIncSearch, dghPreferIncSearch, dghRowHighlight, dghColumnResize, dghColumnMove]
          STFilter.Visible = True
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          OnApplyFilter = gridAGamersApplyFilter
          OnDblClick = gridAGamersDblClick
          OnKeyDown = f
          OnTitleBtnClick = gridAGamersTitleBtnClick
          Columns = <
            item
              EditButtons = <>
              FieldName = 'AGAMER_NM'
              Footers = <>
            end
            item
              Alignment = taCenter
              AutoFitColWidth = False
              ButtonStyle = cbsEllipsis
              EditButtons = <
                item
                  Style = ebsEllipsisEh
                end>
              FieldName = 'COUNTRY_SGN'
              Footers = <>
              STFilter.DataField = 'COUNTRY_SGN'
              STFilter.KeyField = 'ACOUNTRY_SGN'
              STFilter.ListField = 'ACOUNTRY_NM'
              STFilter.ListSource = dsACountrys
              Title.Caption = #1057#1090#1088#1072#1085#1072
              Title.TitleButton = True
              Width = 60
            end>
        end
        object TBXDock1: TTBXDock
          Left = 0
          Top = 0
          Width = 855
          Height = 25
          object TBXToolbar1: TTBXToolbar
            Left = 0
            Top = 0
            Caption = 'TBXToolbar1'
            TabOrder = 0
            object TBControlItem2: TTBControlItem
              Control = eAGamerName
            end
            object TBXItem1: TTBXItem
              Action = actAddAGamer
            end
            object TBXItem4: TTBXItem
              Action = actEditAGamers
            end
            object cbTemporary: TTBXItem
              AutoCheck = True
              Caption = #1042#1088#1077#1084#1077#1085#1085#1086
            end
            object eAGamerName: TEdit
              Left = 0
              Top = 0
              Width = 300
              Height = 21
              TabOrder = 0
              OnChange = eAGamerNameChange
            end
          end
        end
        object Panel1: TPanel
          Left = 505
          Top = 25
          Width = 350
          Height = 229
          Align = alRight
          Caption = 'Panel1'
          TabOrder = 2
          object Splitter3: TSplitter
            Left = 1
            Top = 75
            Width = 348
            Height = 3
            Cursor = crVSplit
            Align = alBottom
          end
          object gridHistoryByGamer: TDBGridEh
            Left = 1
            Top = 1
            Width = 348
            Height = 74
            Align = alClient
            AutoFitColWidths = True
            BorderStyle = bsNone
            Color = clBtnFace
            DataSource = dsHistoryByGamer
            Flat = True
            FooterColor = clWindow
            FooterFont.Charset = DEFAULT_CHARSET
            FooterFont.Color = clWindowText
            FooterFont.Height = -11
            FooterFont.Name = 'MS Sans Serif'
            FooterFont.Style = []
            Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'MS Sans Serif'
            TitleFont.Style = []
            VertScrollBar.VisibleMode = sbNeverShowEh
            Columns = <
              item
                EditButtons = <>
                FieldName = 'AGAMER_NM'
                Footers = <>
                Visible = False
                Width = 200
              end
              item
                EditButtons = <>
                FieldName = 'ATOURNIR_ID'
                Footers = <>
                Visible = False
              end
              item
                EditButtons = <>
                FieldName = 'ATOURNIR_NM'
                Footers = <>
                Width = 200
              end
              item
                EditButtons = <>
                FieldName = 'AGAMER_ID'
                Footers = <>
                Visible = False
              end
              item
                Alignment = taCenter
                AutoFitColWidth = False
                EditButtons = <>
                FieldName = 'COUNTRY_SGN'
                Footers = <>
                Width = 40
              end
              item
                AutoFitColWidth = False
                EditButtons = <>
                FieldName = 'USED_DT'
                Footers = <>
              end>
          end
          object gridBGamerByAGamer: TDBGridEh
            Left = 1
            Top = 78
            Width = 348
            Height = 150
            Align = alBottom
            AllowedOperations = [alopDeleteEh]
            AutoFitColWidths = True
            BorderStyle = bsNone
            Color = clBtnFace
            DataSource = dsBGamerByAGamer
            Flat = True
            FooterColor = clWindow
            FooterFont.Charset = DEFAULT_CHARSET
            FooterFont.Color = clWindowText
            FooterFont.Height = -11
            FooterFont.Name = 'MS Sans Serif'
            FooterFont.Style = []
            Options = [dgEditing, dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
            TabOrder = 1
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'MS Sans Serif'
            TitleFont.Style = []
            VertScrollBar.VisibleMode = sbNeverShowEh
            OnKeyDown = gridBGamerByAGamerKeyDown
            Columns = <
              item
                EditButtons = <>
                FieldName = 'BGAMER_ID'
                Footers = <>
                Visible = False
              end
              item
                EditButtons = <>
                FieldName = 'BGAMER_NM'
                Footers = <>
              end
              item
                EditButtons = <>
                FieldName = 'AGAMER_ID'
                Footers = <>
                Visible = False
              end
              item
                AutoFitColWidth = False
                EditButtons = <>
                FieldName = 'BOOKER_ID'
                Footers = <>
                Width = 40
              end
              item
                EditButtons = <>
                FieldName = 'BGAMER_UNM'
                Footers = <>
                Visible = False
              end
              item
                AutoFitColWidth = False
                EditButtons = <>
                FieldName = 'USED_DT'
                Footers = <>
              end
              item
                EditButtons = <>
                FieldName = 'TEMPORARY_DT'
                Footers = <>
                Visible = False
              end
              item
                EditButtons = <>
                FieldName = 'COMPLETE_FLG'
                Footers = <>
                Visible = False
              end>
          end
        end
      end
      object tsAGamers1: TTabSheet
        Caption = 'tsAGamers1'
        ImageIndex = 2
        object TBXDock2: TTBXDock
          Left = 0
          Top = 0
          Width = 855
          Height = 25
          object TBXToolbar2: TTBXToolbar
            Left = 0
            Top = 0
            Caption = 'TBXToolbar2'
            TabOrder = 0
            object TBControlItem3: TTBControlItem
              Control = eASubGamer1Name
            end
            object TBXItem2: TTBXItem
              Action = actAddASubGamer1
            end
            object eASubGamer1Name: TEdit
              Left = 0
              Top = 0
              Width = 300
              Height = 21
              TabOrder = 0
              OnChange = eASubGamer1NameChange
            end
          end
        end
        object gridAGamers1: TDBGridEh
          Left = 0
          Top = 25
          Width = 855
          Height = 229
          Align = alClient
          AutoFitColWidths = True
          Color = clBtnFace
          DataSource = dsAGamers1
          Flat = True
          FooterColor = clWindow
          FooterFont.Charset = DEFAULT_CHARSET
          FooterFont.Color = clWindowText
          FooterFont.Height = -11
          FooterFont.Name = 'MS Sans Serif'
          FooterFont.Style = []
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
          OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghIncSearch, dghRowHighlight, dghDialogFind, dghColumnResize, dghColumnMove]
          ReadOnly = True
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          OnDblClick = gridAGamers1DblClick
          OnGetCellParams = gridMainGetCellParams
          Columns = <
            item
              EditButtons = <>
              FieldName = 'AGAMER_ID'
              Footers = <>
              Visible = False
            end
            item
              EditButtons = <>
              FieldName = 'AGAMER_NM'
              Footers = <>
            end
            item
              EditButtons = <>
              FieldName = 'ASPORT_ID'
              Footers = <>
              Visible = False
            end
            item
              EditButtons = <>
              FieldName = 'COUNTRY_SGN'
              Footers = <>
            end>
        end
      end
      object tsAGamers2: TTabSheet
        Caption = 'tsAGamers2'
        ImageIndex = 3
        object TBXDock3: TTBXDock
          Left = 0
          Top = 0
          Width = 855
          Height = 25
          object TBXToolbar3: TTBXToolbar
            Left = 0
            Top = 0
            Caption = 'TBXToolbar2'
            TabOrder = 0
            object TBControlItem4: TTBControlItem
              Control = eASubGamer2Name
            end
            object TBXItem3: TTBXItem
              Action = actAddASubGamer2
            end
            object eASubGamer2Name: TEdit
              Left = 0
              Top = 0
              Width = 300
              Height = 21
              TabOrder = 0
              OnChange = eASubGamer2NameChange
            end
          end
        end
        object gridAGamers2: TDBGridEh
          Left = 0
          Top = 25
          Width = 855
          Height = 229
          Align = alClient
          AutoFitColWidths = True
          Color = clBtnFace
          DataSource = dsAGamers2
          Flat = True
          FooterColor = clWindow
          FooterFont.Charset = DEFAULT_CHARSET
          FooterFont.Color = clWindowText
          FooterFont.Height = -11
          FooterFont.Name = 'MS Sans Serif'
          FooterFont.Style = []
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
          OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghIncSearch, dghRowHighlight, dghDialogFind, dghColumnResize, dghColumnMove]
          ReadOnly = True
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          OnDblClick = gridAGamers2DblClick
          OnGetCellParams = gridMainGetCellParams
          Columns = <
            item
              EditButtons = <>
              FieldName = 'AGAMER_ID'
              Footers = <>
              Visible = False
            end
            item
              EditButtons = <>
              FieldName = 'AGAMER_NM'
              Footers = <>
            end
            item
              EditButtons = <>
              FieldName = 'ASPORT_ID'
              Footers = <>
              Visible = False
            end
            item
              EditButtons = <>
              FieldName = 'COUNTRY_SGN'
              Footers = <>
            end>
        end
      end
      object tsEvents: TTabSheet
        Caption = 'tsEvents'
        ImageIndex = 4
        object gridBEvents: TDBGridEh
          Left = 0
          Top = 0
          Width = 855
          Height = 254
          Align = alClient
          AutoFitColWidths = True
          Color = clBtnFace
          ColumnDefValues.Title.Alignment = taCenter
          ColumnDefValues.Title.TitleButton = True
          ColumnDefValues.Title.ToolTips = True
          DataSource = dsBEvents
          Flat = True
          FooterColor = clWindow
          FooterFont.Charset = DEFAULT_CHARSET
          FooterFont.Color = clWindowText
          FooterFont.Height = -11
          FooterFont.Name = 'MS Sans Serif'
          FooterFont.Style = []
          OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghColumnResize, dghColumnMove]
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          OnDblClick = gridBEventsDblClick
          OnGetCellParams = gridMainGetCellParams
          Columns = <
            item
              AutoFitColWidth = False
              EditButtons = <>
              FieldName = 'EVENT_ID'
              Footers = <>
              ReadOnly = True
              Visible = False
            end
            item
              EditButtons = <>
              FieldName = 'ASPORT_ID'
              Footers = <>
              ReadOnly = True
              Visible = False
            end
            item
              EditButtons = <>
              FieldName = 'ASPORT_NM'
              Footers = <>
              ReadOnly = True
              Visible = False
            end
            item
              EditButtons = <>
              FieldName = 'BTOURNIR_ID'
              Footers = <>
              ReadOnly = True
              Visible = False
            end
            item
              Alignment = taCenter
              AutoFitColWidth = False
              EditButtons = <>
              FieldName = 'EVENT_DTM'
              Footers = <>
              ReadOnly = True
              Width = 90
            end
            item
              EditButtons = <>
              FieldName = 'AGAMER1_ID'
              Footers = <>
              ReadOnly = True
              Visible = False
            end
            item
              EditButtons = <>
              FieldName = 'BGAMER1_ID'
              Footers = <>
              ReadOnly = True
              Visible = False
            end
            item
              EditButtons = <>
              FieldName = 'GAMER1_NM'
              Footers = <>
              ReadOnly = True
              Width = 100
            end
            item
              EditButtons = <>
              FieldName = 'AGAMER1_NM'
              Footers = <>
              ReadOnly = True
              Width = 100
            end
            item
              EditButtons = <>
              FieldName = 'AGAMER2_ID'
              Footers = <>
              ReadOnly = True
              Visible = False
            end
            item
              EditButtons = <>
              FieldName = 'BGAMER2_ID'
              Footers = <>
              ReadOnly = True
              Visible = False
            end
            item
              EditButtons = <>
              FieldName = 'GAMER2_NM'
              Footers = <>
              ReadOnly = True
              Width = 100
            end
            item
              EditButtons = <>
              FieldName = 'AGAMER2_NM'
              Footers = <>
              ReadOnly = True
              Width = 100
            end
            item
              AutoFitColWidth = False
              EditButtons = <>
              FieldName = 'COMPLETE_FLG'
              Footers = <>
              ReadOnly = True
              Visible = False
            end
            item
              AutoFitColWidth = False
              EditButtons = <>
              FieldName = 'IGNORE_FLG'
              Footers = <>
              ReadOnly = True
              Visible = False
            end>
        end
      end
    end
  end
  inherited dckRight: TTBXMultiDock
    Left = 586
    Width = 279
    Height = 261
    object pnlHistory: TTBXDockablePanel
      Left = 0
      Top = 0
      MinClientHeight = 200
      MinClientWidth = 200
      BorderSize = 5
      Caption = 'History'
      DockedWidth = 275
      DockPos = 0
      SupportedDocks = [dkStandardDock, dkMultiDock]
      TabOrder = 0
      object gridHistoryByTournir: TDBGridEh
        Left = 5
        Top = 5
        Width = 265
        Height = 213
        Align = alClient
        AutoFitColWidths = True
        Color = clBtnFace
        DataSource = dsHistoryByTournir
        Flat = True
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'MS Sans Serif'
        FooterFont.Style = []
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghIncSearch, dghPreferIncSearch, dghRowHighlight, dghDialogFind, dghColumnResize, dghColumnMove]
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        OnDblClick = gridHistoryByTournirDblClick
        OnKeyDown = gridHistoryByTournirKeyDown
        Columns = <
          item
            EditButtons = <>
            FieldName = 'AGAMER_NM'
            Footers = <>
            Width = 200
          end
          item
            AutoFitColWidth = False
            EditButtons = <>
            FieldName = 'USED_DT'
            Footers = <>
          end>
      end
    end
  end
  inherited tblMain: TpFIBDataSet
    RefreshSQL.Strings = (
      'SELECT'
      '    EVENT_ID,'
      '    EVENT_DTM,'
      '    ASPORT_ID,'
      '    ASPORT_NM,'
      '    ASUBSPORT1_ID,'
      '    ASUBSPORT2_ID,'
      '    COUNTRY_FLG,'
      '    BTOURNIR_ID,'
      '    BOOKER_ID,'
      '    BOOKER_NM,'
      '    ATOURNIR_ID,'
      '    ATOURNIR_NM,'
      '    COUNTRY_SGN,'
      '    AGAMER_ID,'
      '    GAMER_NM'
      'FROM'
      '    VE_UNKNOWN'
      'WHERE EVENT_ID = :OLD_EVENT_ID'
      '  AND GAMER_NM = :OLD_GAMER_NM'
      '')
    SelectSQL.Strings = (
      'SELECT'
      '    EVENT_ID,'
      '    EVENT_DTM,'
      '    ASPORT_ID,'
      '    ASPORT_NM,'
      '    ASUBSPORT1_ID,'
      '    ASUBSPORT2_ID,'
      '    COUNTRY_FLG,'
      '    BTOURNIR_ID,'
      '    BOOKER_ID,'
      '    BOOKER_NM,'
      '    ATOURNIR_ID,'
      '    MTOURNIR_ID,'
      '    ATOURNIR_NM,'
      '    COUNTRY_SGN,'
      '    AGAMER_ID,'
      '    GAMER_NM'
      'FROM'
      '    VE_UNKNOWN'
      'ORDER BY '
      '    ASPORT_NM,'
      '    COUNTRY_SGN,'
      '    ATOURNIR_NM,'
      '    GAMER_NM ')
    CacheModelOptions.CacheModelKind = cmkLimitedBufferSize
    CacheModelOptions.BufferChunks = 100
    AfterScroll = tblMainAfterScroll
    DataSet_ID = 12
    Description = 'UNKNOWNS'
    poApplyRepositary = True
  end
  object tblAGamers: TpFIBDataSet
    UpdateSQL.Strings = (
      'UPDATE AGAMERS'
      'SET '
      '    AGAMER_NM = :AGAMER_NM,'
      '    COUNTRY_SGN = :COUNTRY_SGN'
      'WHERE'
      '    AGAMER_ID = :OLD_AGAMER_ID'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      '    AGAMERS'
      'WHERE'
      '        AGAMER_ID = :OLD_AGAMER_ID'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO AGAMERS('
      '    AGAMER_ID,'
      '    AGAMER_NM,'
      '    COUNTRY_SGN'
      ')'
      'VALUES('
      '    :AGAMER_ID,'
      '    :AGAMER_NM,'
      '    :COUNTRY_SGN'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    g.AGAMER_ID,'
      '    g.AGAMER_NM,'
      '    g.ASPORT_ID,'
      '    g.COUNTRY_SGN'
      'FROM'
      '    AGAMERS g'
      ''
      ' WHERE '
      '        G.AGAMER_ID = :OLD_AGAMER_ID'
      '    ')
    SelectSQL.Strings = (
      'SELECT'
      '    AGAMER_ID,'
      '    AGAMER_NM,'
      '    ASPORT_ID,'
      '    COUNTRY_SGN'
      'FROM'
      '    AGAMERS '
      'WHERE ASPORT_ID = :ASPORT_ID'
      '  AND :COUNTRY_SGN IN ('#39'ANY'#39', COUNTRY_SGN)'
      'ORDER BY '
      '    AGAMER_NM')
    CacheModelOptions.CacheModelKind = cmkLimitedBufferSize
    CacheModelOptions.BufferChunks = 100
    AutoUpdateOptions.UpdateTableName = 'AGAMERS'
    AutoUpdateOptions.KeyFields = 'AGAMER_ID'
    AutoUpdateOptions.GeneratorName = 'GEN_AGAMER_ID'
    AutoUpdateOptions.WhenGetGenID = wgBeforePost
    Transaction = dmSwim.ReadTran
    Database = dmSwim.Database
    UpdateTransaction = dmSwim.UpdateTran
    AutoCommit = True
    DataSource = dsMain
    DataSet_ID = 107
    Description = 'AGAMERS_BY_ASPORT'
    Left = 88
    Top = 72
    poApplyRepositary = True
  end
  object dsAGamers: TDataSource
    DataSet = tblAGamers
    Left = 88
    Top = 104
  end
  object dsHistoryByTournir: TDataSource
    AutoEdit = False
    DataSet = tblHistoryByTournir
    Left = 120
    Top = 104
  end
  object tblHistoryByTournir: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    ATOURNIR_ID,'
      '    ATOURNIR_NM,'
      '    COUNTRY_SGN,'
      '    AGAMER_ID,'
      '    AGAMER_NM,'
      '    USED_DT'
      'FROM'
      '    VE_HISTORY '
      'WHERE'
      '    :ATOURNIR_ID IN (ATOURNIR_ID, MTOURNIR_ID)'
      'ORDER BY'
      '    AGAMER_NM')
    Transaction = dmSwim.ReadTran
    Database = dmSwim.Database
    UpdateTransaction = dmSwim.UpdateTran
    DataSource = dsMain
    DataSet_ID = 114
    Description = 'HISTORY_BY_ATOURNIR'
    Left = 120
    Top = 72
    poApplyRepositary = True
  end
  object DetailActionList: TActionList
    Left = 120
    Top = 40
    object actAddAGamer: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      OnExecute = actAddAGamerExecute
    end
    object actAddASubGamer1: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' 1-'#1075#1086' '#1080#1075#1088#1086#1082#1072
      OnExecute = actAddASubGamer1Execute
    end
    object actAddASubGamer2: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' 2-'#1075#1086' '#1080#1075#1088#1086#1082#1072
      OnExecute = actAddASubGamer2Execute
    end
    object actEditAGamers: TAction
      AutoCheck = True
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      OnExecute = actEditAGamersExecute
    end
  end
  object tblAGamers1: TpFIBDataSet
    UpdateSQL.Strings = (
      'UPDATE AGAMERS'
      'SET '
      '    AGAMER_NM = :AGAMER_NM,'
      '    COUNTRY_SGN = :COUNTRY_SGN'
      'WHERE'
      '    AGAMER_ID = :OLD_AGAMER_ID'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      '    AGAMERS'
      'WHERE'
      '        AGAMER_ID = :OLD_AGAMER_ID'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO AGAMERS('
      '    AGAMER_ID,'
      '    AGAMER_NM,'
      '    COUNTRY_SGN'
      ')'
      'VALUES('
      '    :AGAMER_ID,'
      '    :AGAMER_NM,'
      '    :COUNTRY_SGN'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    g.AGAMER_ID,'
      '    g.AGAMER_NM,'
      '    g.ASPORT_ID,'
      '    g.COUNTRY_SGN'
      'FROM'
      '    AGAMERS g'
      ''
      ' WHERE '
      '        G.AGAMER_ID = :OLD_AGAMER_ID'
      '    ')
    SelectSQL.Strings = (
      'SELECT'
      '    AGAMER_ID,'
      '    AGAMER_NM,'
      '    ASPORT_ID,'
      '    COUNTRY_SGN'
      'FROM'
      '    AGAMERS '
      'WHERE ASPORT_ID = :ASUBSPORT1_ID'
      'ORDER BY '
      '    AGAMER_NM')
    AutoUpdateOptions.UpdateTableName = 'AGAMERS'
    AutoUpdateOptions.KeyFields = 'AGAMER_ID'
    AutoUpdateOptions.GeneratorName = 'GEN_AGAMER_ID'
    AutoUpdateOptions.WhenGetGenID = wgBeforePost
    Transaction = dmSwim.ReadTran
    Database = dmSwim.Database
    UpdateTransaction = dmSwim.UpdateTran
    DataSource = dsMain
    DataSet_ID = 117
    Description = 'AGAMERS_BY_ASUBSPORT1'
    Left = 152
    Top = 72
    poApplyRepositary = True
  end
  object dsAGamers1: TDataSource
    AutoEdit = False
    DataSet = tblAGamers1
    Left = 152
    Top = 104
  end
  object dsAGamers2: TDataSource
    AutoEdit = False
    DataSet = tblAGamers2
    Left = 184
    Top = 104
  end
  object tblAGamers2: TpFIBDataSet
    UpdateSQL.Strings = (
      'UPDATE AGAMERS'
      'SET '
      '    AGAMER_NM = :AGAMER_NM,'
      '    COUNTRY_SGN = :COUNTRY_SGN'
      'WHERE'
      '    AGAMER_ID = :OLD_AGAMER_ID'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      '    AGAMERS'
      'WHERE'
      '        AGAMER_ID = :OLD_AGAMER_ID'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO AGAMERS('
      '    AGAMER_ID,'
      '    AGAMER_NM,'
      '    COUNTRY_SGN'
      ')'
      'VALUES('
      '    :AGAMER_ID,'
      '    :AGAMER_NM,'
      '    :COUNTRY_SGN'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    g.AGAMER_ID,'
      '    g.AGAMER_NM,'
      '    g.ASPORT_ID,'
      '    g.COUNTRY_SGN'
      'FROM'
      '    AGAMERS g'
      ''
      ' WHERE '
      '        G.AGAMER_ID = :OLD_AGAMER_ID'
      '    ')
    SelectSQL.Strings = (
      'SELECT'
      '    AGAMER_ID,'
      '    AGAMER_NM,'
      '    ASPORT_ID,'
      '    COUNTRY_SGN'
      'FROM'
      '    AGAMERS '
      'WHERE ASPORT_ID = :ASUBSPORT2_ID'
      'ORDER BY '
      '    AGAMER_NM')
    AutoUpdateOptions.UpdateTableName = 'AGAMERS'
    AutoUpdateOptions.KeyFields = 'AGAMER_ID'
    AutoUpdateOptions.GeneratorName = 'GEN_AGAMER_ID'
    AutoUpdateOptions.WhenGetGenID = wgBeforePost
    Transaction = dmSwim.ReadTran
    Database = dmSwim.Database
    UpdateTransaction = dmSwim.UpdateTran
    DataSource = dsMain
    DataSet_ID = 127
    Description = 'AGAMERS_BY_ASUBSPORT2'
    Left = 184
    Top = 72
    poApplyRepositary = True
  end
  object tblBEvents: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    EVENT_ID,'
      '    ASPORT_ID,'
      '    BTOURNIR_ID,'
      '    ATOURNIR_ID,'
      '    EVENT_DTM,'
      '    AGAMER1_ID,'
      '    AGAMER1_NM,'
      '    GAMER1_NM,'
      '    AGAMER2_ID,'
      '    AGAMER2_NM,'
      '    GAMER2_NM,'
      '    COMPLETE_FLG,'
      '    IGNORE_FLG'
      'FROM'
      '    VE_EVENTS'
      'WHERE ATOURNIR_ID = :ATOURNIR_ID'
      '   OR BTOURNIR_ID = :BTOURNIR_ID'
      'ORDER BY'
      '    EVENT_DTM,'
      '    AGAMER1_NM ')
    Transaction = dmSwim.ReadTran
    Database = dmSwim.Database
    UpdateTransaction = dmSwim.UpdateTran
    DataSource = dsMain
    DataSet_ID = 113
    Description = 'EVENTS_BY_ATOURNIR'
    Left = 216
    Top = 72
    poApplyRepositary = True
    dcIgnoreMasterClose = True
  end
  object dsBEvents: TDataSource
    AutoEdit = False
    DataSet = tblBEvents
    Left = 216
    Top = 104
  end
  object tblHistoryByGamer: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    ATOURNIR_ID,'
      '    ATOURNIR_NM,'
      '    COUNTRY_SGN,'
      '    AGAMER_ID,'
      '    AGAMER_NM,'
      '    USED_DT'
      'FROM'
      '    VE_HISTORY '
      'WHERE'
      '    AGAMER_ID = :AGAMER_ID'
      'ORDER BY'
      '    COUNTRY_SGN,'
      '    ATOURNIR_NM')
    Transaction = dmSwim.ReadTran
    Database = dmSwim.Database
    UpdateTransaction = dmSwim.UpdateTran
    DataSource = dsAGamers
    DataSet_ID = 115
    Description = 'HISTORY_BY_AGAMER'
    Left = 248
    Top = 72
    poApplyRepositary = True
    dcForceOpen = True
  end
  object dsHistoryByGamer: TDataSource
    AutoEdit = False
    DataSet = tblHistoryByGamer
    Left = 248
    Top = 104
  end
  object tblACountrys: TpFIBDataSet
    UpdateSQL.Strings = (
      'UPDATE COUNTRYS'
      'SET '
      '    ACOUNTRY_NM = :ACOUNTRY_NM,'
      '    MCOUNTRY_SGN = :MCOUNTRY_SGN'
      'WHERE'
      '    ACOUNTRY_SGN = :OLD_ACOUNTRY_SGN'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      '    COUNTRYS'
      'WHERE'
      '        ACOUNTRY_SGN = :OLD_ACOUNTRY_SGN'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO COUNTRYS('
      '    ACOUNTRY_SGN,'
      '    ACOUNTRY_NM,'
      '    MCOUNTRY_SGN'
      ')'
      'VALUES('
      '    :ACOUNTRY_SGN,'
      '    :ACOUNTRY_NM,'
      '    :MCOUNTRY_SGN'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    ACOUNTRY_SGN,'
      '    ACOUNTRY_NM,'
      '    MCOUNTRY_SGN'
      'FROM'
      '    COUNTRYS '
      ''
      ' WHERE '
      '        COUNTRYS.ACOUNTRY_SGN = :OLD_ACOUNTRY_SGN'
      '    ')
    SelectSQL.Strings = (
      'SELECT'
      '    ACOUNTRY_SGN,'
      '    ACOUNTRY_NM,'
      '    MCOUNTRY_SGN'
      'FROM'
      '    COUNTRYS '
      'ORDER BY ACOUNTRY_NM')
    Transaction = dmSwim.ReadTran
    Database = dmSwim.Database
    UpdateTransaction = dmSwim.UpdateTran
    DataSet_ID = 4
    Description = 'COUNTRYS'
    Left = 280
    Top = 72
    poApplyRepositary = True
  end
  object dsACountrys: TDataSource
    AutoEdit = False
    DataSet = tblACountrys
    Left = 280
    Top = 104
  end
  object tblBGamerByAGamer: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    BGAMER_ID,'
      '    BGAMER_NM,'
      '    AGAMER_ID,'
      '    BOOKER_ID,'
      '    BGAMER_UNM,'
      '    USED_DT,'
      '    TEMPORARY_DT,'
      '    COMPLETE_FLG'
      'FROM'
      '    BGAMERS '
      'WHERE AGAMER_ID = :AGAMER_ID'
      'ORDER BY BGAMER_NM')
    Transaction = dmSwim.ReadTran
    Database = dmSwim.Database
    UpdateTransaction = dmSwim.UpdateTran
    DataSource = dsAGamers
    DataSet_ID = 118
    Description = 'BGAMERS_BY_AGAMER'
    Left = 312
    Top = 72
    poApplyRepositary = True
    dcForceMasterRefresh = True
    dcIgnoreMasterClose = True
  end
  object dsBGamerByAGamer: TDataSource
    DataSet = tblBGamerByAGamer
    Left = 312
    Top = 104
  end
end
