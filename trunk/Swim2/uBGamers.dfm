inherited frmBGamers: TfrmBGamers
  Left = 300
  Top = 161
  Caption = 'frmBGamers'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited Splitter1: TSplitter
    Top = 103
  end
  inherited TBXDockUp: TTBXDock
    inherited TBXToolbar: TTBXToolbar
      inherited DBNavigator: TDBNavigator
        Hints.Strings = ()
      end
    end
  end
  inherited gridMain: TDBGridEh
    Height = 77
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    Columns = <
      item
        AutoFitColWidth = False
        EditButtons = <>
        FieldName = 'ASPORT_NM'
        Footers = <>
        ReadOnly = True
        Width = 100
      end
      item
        EditButtons = <>
        FieldName = 'BGAMER_ID'
        Footers = <>
        Visible = False
      end
      item
        EditButtons = <>
        FieldName = 'BTOURNIR_ID'
        Footers = <>
        Visible = False
      end
      item
        EditButtons = <>
        FieldName = 'BGAMER_NM'
        Footers = <>
        ReadOnly = True
        Width = 200
      end
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
        FieldName = 'BTOURNIR_NM'
        Footers = <>
        ReadOnly = True
        Width = 200
      end
      item
        EditButtons = <>
        FieldName = 'ASPORT_ID'
        Footers = <>
        Visible = False
      end
      item
        Alignment = taCenter
        AutoFitColWidth = False
        EditButtons = <>
        FieldName = 'COUNTRY_SGN'
        Footers = <>
        ReadOnly = True
        Title.Caption = #1057#1090#1088#1072#1085#1072
        Width = 40
      end
      item
        EditButtons = <>
        FieldName = 'BOOKER_NM'
        Footers = <>
        ReadOnly = True
        Title.Caption = #1050#1086#1085#1090#1086#1088#1072
        Width = 100
      end
      item
        AutoFitColWidth = False
        EditButtons = <>
        FieldName = 'USED_DT'
        Footers = <>
        ReadOnly = True
        Width = 60
      end
      item
        EditButtons = <>
        FieldName = 'TEMPORARY_DT'
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
        FieldName = 'COMPLETE_FLG'
        Footers = <>
        Visible = False
      end
      item
        EditButtons = <>
        FieldName = 'ASUBSPORT1_ID'
        Footers = <>
        Visible = False
      end
      item
        EditButtons = <>
        FieldName = 'ASUBSPORT2_ID'
        Footers = <>
        Visible = False
      end
      item
        EditButtons = <>
        FieldName = 'ATOURNIR_NM'
        Footers = <>
        Width = 200
      end>
  end
  inherited Panel: TGvCollapsePanel
    Top = 106
    Height = 300
    ExpandedHeight = 300
    State = csExpand
    inherited pcDetail: TPageControl
      Height = 282
      ActivePage = tsAGamers
      object tsAGamers: TTabSheet
        Caption = 'tsAGamers'
        object TBXDock1: TTBXDock
          Left = 0
          Top = 0
          Width = 689
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
        object gridAGamers: TDBGridEh
          Left = 0
          Top = 25
          Width = 689
          Height = 229
          Align = alClient
          AutoFitColWidths = True
          Color = clBtnFace
          ColumnDefValues.Title.Alignment = taCenter
          ColumnDefValues.Title.TitleButton = True
          DataSource = dsAGamers
          Flat = True
          FooterColor = clWindow
          FooterFont.Charset = DEFAULT_CHARSET
          FooterFont.Color = clWindowText
          FooterFont.Height = -11
          FooterFont.Name = 'MS Sans Serif'
          FooterFont.Style = []
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
          OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghIncSearch, dghRowHighlight, dghDialogFind]
          ReadOnly = True
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          OnApplyFilter = gridAGamersApplyFilter
          OnDblClick = gridAGamersDblClick
          OnGetCellParams = gridMainGetCellParams
          OnKeyDown = gridAGamersKeyDown
          OnTitleBtnClick = gridAGamersTitleBtnClick
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
              Title.Caption = #1059#1095#1072#1089#1090#1085#1080#1082#1080
            end
            item
              EditButtons = <>
              FieldName = 'ASPORT_ID'
              Footers = <>
              Visible = False
            end
            item
              Alignment = taCenter
              AutoFitColWidth = False
              EditButtons = <>
              FieldName = 'COUNTRY_SGN'
              Footers = <>
              Title.Caption = #1057#1090#1088#1072#1085#1072
              Title.ToolTips = True
              Width = 60
            end>
        end
      end
      object tsHistory: TTabSheet
        Caption = 'tsHistory'
        ImageIndex = 1
        object gridHistory: TDBGridEh
          Left = 0
          Top = 0
          Width = 689
          Height = 254
          Align = alClient
          AutoFitColWidths = True
          Color = clBtnFace
          DataSource = dsHistory
          Flat = True
          FooterColor = clWindow
          FooterFont.Charset = DEFAULT_CHARSET
          FooterFont.Color = clWindowText
          FooterFont.Height = -11
          FooterFont.Name = 'MS Sans Serif'
          FooterFont.Style = []
          ReadOnly = True
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          OnDblClick = gridHistoryDblClick
          OnGetCellParams = gridMainGetCellParams
          Columns = <
            item
              EditButtons = <>
              FieldName = 'ASPORT_ID'
              Footers = <>
              Visible = False
            end
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
              Width = 500
            end
            item
              EditButtons = <>
              FieldName = 'ATOURNIR_NM'
              Footers = <>
              Width = 300
            end
            item
              EditButtons = <>
              FieldName = 'ATOURNIR_ID'
              Footers = <>
              Visible = False
            end>
        end
      end
      object tsAGamer1: TTabSheet
        Caption = 'tsAGamer1'
        ImageIndex = 2
        object gridAGamers1: TDBGridEh
          Left = 0
          Top = 25
          Width = 689
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
          OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghIncSearch, dghRowHighlight, dghDialogFind]
          ReadOnly = True
          TabOrder = 0
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
        object TBXDock2: TTBXDock
          Left = 0
          Top = 0
          Width = 689
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
      end
      object tsAGamer2: TTabSheet
        Caption = 'tsAGamer2'
        ImageIndex = 3
        object gridAGamers2: TDBGridEh
          Left = 0
          Top = 25
          Width = 689
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
          OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghIncSearch, dghRowHighlight, dghDialogFind]
          ReadOnly = True
          TabOrder = 0
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
        object TBXDock3: TTBXDock
          Left = 0
          Top = 0
          Width = 689
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
      end
    end
  end
  inherited dsMain: TDataSource
    AutoEdit = False
  end
  inherited tblMain: TpFIBDataSet
    UpdateSQL.Strings = (
      'UPDATE BGAMERS'
      'SET '
      '    AGAMER_ID = :AGAMER_ID'
      'WHERE'
      '    BGAMER_ID = :OLD_BGAMER_ID'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      '    BGAMERS'
      'WHERE'
      '    BGAMER_ID = :OLD_BGAMER_ID'
      '        ')
    InsertSQL.Strings = (
      'INSERT INTO BGAMERS('
      '    BGAMER_ID,'
      '    BGAMER_NM,'
      '    AGAMER_ID,'
      '    BTOURNIR_ID,'
      '    USED_DT'
      ')'
      'VALUES('
      '    :BGAMER_ID,'
      '    :BGAMER_NM,'
      '    :AGAMER_ID,'
      '    :BTOURNIR_ID,'
      '    :USED_DT'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    BGAMER_ID,'
      '    BGAMER_NM,'
      '    AGAMER_ID,'
      '    AGAMER_NM,'
      '    ASPORT_ID,'
      '    ASPORT_NM,'
      '    COUNTRY_SGN,'
      '    BTOURNIR_ID,'
      '    BTOURNIR_NM,'
      '    ATOURNIR_ID,'
      '    USED_DT,'
      '    COMPLETE_FLG,'
      '    COUNTRY_FLG,'
      '    ASUBSPORT1_ID,'
      '    ASUBSPORT2_ID'
      'FROM'
      '    VE_BGAMERS'
      'WHERE'
      '    BGAMER_ID = :OLD_BGAMER_ID ')
    SelectSQL.Strings = (
      'SELECT'
      '    BGAMER_ID,'
      '    BGAMER_NM,'
      '    AGAMER_ID,'
      '    AGAMER_NM,'
      '    ASPORT_ID,'
      '    ASPORT_NM,'
      '    COUNTRY_SGN,'
      '    BTOURNIR_ID,'
      '    BTOURNIR_NM,'
      '    ATOURNIR_ID,'
      '    ATOURNIR_NM,'
      '    USED_DT,'
      '    COMPLETE_FLG,'
      '    COUNTRY_FLG,'
      '    ASUBSPORT1_ID,'
      '    ASUBSPORT2_ID,'
      '    BOOKER_NM'
      'FROM'
      '    VE_BGAMERS '
      'ORDER BY COMPLETE_FLG'
      '       , ASPORT_NM'
      '       , BTOURNIR_NM'
      '       , AGAMER_NM'
      '       , BGAMER_NM')
    AllowedUpdateKinds = [ukModify]
    DataSet_ID = 8
    Description = 'BGAMERS'
    poApplyRepositary = True
  end
  object dsAGamers: TDataSource
    AutoEdit = False
    DataSet = tblAGamers
    Left = 96
    Top = 104
  end
  object DetailActionList: TActionList
    Left = 168
    Top = 40
    object actAddAGamer: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      OnExecute = actAddAGamerExecute
      OnUpdate = actAddAGamerUpdate
    end
    object actAddASubGamer1: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' 1-'#1075#1086' '#1080#1075#1088#1086#1082#1072
      OnExecute = actAddASubGamer1Execute
    end
    object actAddASubGamer2: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' 2-'#1075#1086' '#1080#1075#1088#1086#1082#1072
      OnExecute = actAddASubGamer2Execute
    end
  end
  object dsHistory: TDataSource
    AutoEdit = False
    DataSet = tblAHistory
    Left = 128
    Top = 104
  end
  object dsAGamers1: TDataSource
    AutoEdit = False
    DataSet = tblAGamers1
    Left = 160
    Top = 104
  end
  object dsAGamers2: TDataSource
    AutoEdit = False
    DataSet = tblAGamers2
    Left = 192
    Top = 104
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
    Filter = 'COUNTRY_SGN = '#39'GER'#39
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
    Filtered = True
    DataSet_ID = 107
    Description = 'AGAMERS_BY_ASPORT'
    Left = 96
    Top = 72
    poApplyRepositary = True
  end
  object tblAHistory: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    ATOURNIR_ID,'
      '    ATOURNIR_NM,'
      '    COUNTRY_SGN,'
      '    AGAMER_ID,'
      '    AGAMER_NM'
      'FROM'
      '    VE_HISTORY '
      'WHERE'
      '    ATOURNIR_ID = :ATOURNIR_ID'
      'ORDER BY'
      '    AGAMER_NM')
    Transaction = dmSwim.ReadTran
    Database = dmSwim.Database
    UpdateTransaction = dmSwim.UpdateTran
    DataSource = dsMain
    DataSet_ID = 114
    Description = 'HISTORY_BY_ATOURNIR'
    Left = 128
    Top = 72
    poApplyRepositary = True
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
    DataSet_ID = 117
    Description = 'AGAMERS_BY_ASUBSPORT1'
    Left = 160
    Top = 72
    poApplyRepositary = True
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
    DataSet_ID = 127
    Description = 'AGAMERS_BY_ASUBSPORT2'
    Left = 192
    Top = 72
    poApplyRepositary = True
  end
end
