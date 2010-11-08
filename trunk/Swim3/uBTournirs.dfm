inherited frmBTournirs: TfrmBTournirs
  Left = 283
  Top = 187
  Width = 779
  Height = 536
  Caption = 'frmBTournirs'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited Splitter1: TSplitter
    Top = 199
    Width = 771
  end
  inherited TBXDockUp: TTBXDock
    Width = 771
    inherited TBXToolbar: TTBXToolbar
      inherited DBNavigator: TDBNavigator
        Hints.Strings = ()
      end
    end
  end
  inherited gridMain: TDBGridEh
    Width = 764
    Height = 173
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    Columns = <
      item
        EditButtons = <>
        FieldName = 'BTOURNIR_ID'
        Footers = <>
        Visible = False
      end
      item
        EditButtons = <>
        FieldName = 'BOOKER_ID'
        Footers = <>
        Visible = False
      end
      item
        AutoFitColWidth = False
        EditButtons = <>
        FieldName = 'BOOKER_NM'
        Footers = <>
        ReadOnly = True
        Title.Caption = #1041#1091#1082#1084#1077#1082#1077#1088
        Width = 60
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
        MinWidth = 100
        STFilter.DataField = 'ASPORT_ID'
        STFilter.KeyField = 'ASPORT_ID'
        STFilter.ListField = 'ASPORT_NM'
        STFilter.ListSource = dsASports
        Title.Caption = #1057#1087#1086#1088#1090
        Width = 100
      end
      item
        EditButtons = <>
        FieldName = 'BSPORT_ID'
        Footers = <>
        Visible = False
      end
      item
        EditButtons = <>
        FieldName = 'BTOURNIR_NM'
        Footers = <>
        ReadOnly = True
        Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1090#1091#1088#1085#1080#1088#1072
        Width = 300
      end
      item
        AutoFitColWidth = False
        EditButtons = <
          item
            Style = ebsEllipsisEh
          end>
        EndEllipsis = True
        FieldName = 'COUNTRY_SGN'
        Footers = <>
        STFilter.DataField = 'COUNTRY_SGN'
        STFilter.KeyField = 'MCOUNTRY_SGN'
        STFilter.ListField = 'ACOUNTRY_SGN'
        STFilter.ListSource = dsCountrys
        Title.Caption = #1057#1090#1088#1072#1085#1072
        Width = 40
      end
      item
        Alignment = taCenter
        AutoFitColWidth = False
        EditButtons = <>
        FieldName = 'USED_DT'
        Footers = <>
        ReadOnly = True
        Title.Caption = 'Last Use'
        Width = 60
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
        ReadOnly = True
        Title.Caption = #1058#1091#1088#1085#1080#1088
        Width = 200
      end
      item
        AutoFitColWidth = False
        Checkboxes = True
        EditButtons = <>
        FieldName = 'IGNORE_FLG'
        Footers = <>
        KeyList.Strings = (
          '1'
          '0')
        Title.Caption = 'Ignore'
        Visible = False
        Width = 40
      end>
  end
  inherited Panel: TPanel
    Top = 202
    Width = 771
    Height = 300
    inherited pcDetail: TPageControl
      Width = 769
      Height = 298
      ActivePage = tsTournirs
      object tsParts: TTabSheet
        Caption = 'tsParts'
        object TBXDock1: TTBXDock
          Left = 0
          Top = 0
          Width = 761
          Height = 25
          object TBXToolbar1: TTBXToolbar
            Left = 0
            Top = 0
            Caption = 'TBXToolbar1'
            TabOrder = 0
            object TBControlItem2: TTBControlItem
              Control = lcbASports
            end
            object TBXItem3: TTBXItem
              Action = actSporPart
            end
            object TBControlItem3: TTBControlItem
              Control = lcbCountrys
            end
            object TBXItem2: TTBXItem
              Action = actCountryPart
            end
            object TBXItem1: TTBXItem
              Action = actIgnorePart
            end
            object lcbASports: TDBLookupComboboxEh
              Left = 0
              Top = 0
              Width = 200
              Height = 21
              EditButtons = <>
              KeyField = 'ASPORT_ID'
              ListField = 'ASPORT_NM'
              ListSource = dsASports
              TabOrder = 0
              Visible = True
            end
            object lcbCountrys: TDBLookupComboboxEh
              Left = 279
              Top = 0
              Width = 200
              Height = 21
              EditButtons = <>
              KeyField = 'ACOUNTRY_SGN'
              ListField = 'ACOUNTRY_NM'
              ListSource = dsCountrys
              TabOrder = 1
              Visible = True
            end
          end
        end
        object gridParts: TDBGridEh
          Left = 0
          Top = 25
          Width = 761
          Height = 245
          Align = alClient
          AutoFitColWidths = True
          Color = clBtnFace
          DataGrouping.GroupLevels = <>
          DataSource = dsParts
          Flat = True
          FooterColor = clWindow
          FooterFont.Charset = DEFAULT_CHARSET
          FooterFont.Color = clWindowText
          FooterFont.Height = -11
          FooterFont.Name = 'MS Sans Serif'
          FooterFont.Style = []
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
          OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghIncSearch, dghRowHighlight, dghDialogFind, dghColumnResize, dghColumnMove]
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
              FieldName = 'BTOURNIR_ID'
              Footers = <>
              Visible = False
            end
            item
              EditButtons = <>
              FieldName = 'PART_LVL'
              Footers = <>
            end
            item
              EditButtons = <>
              FieldName = 'PART_TXT'
              Footers = <>
            end>
          object RowDetailData: TRowDetailPanelControlEh
          end
        end
      end
      object tsTournirs: TTabSheet
        Caption = 'tsTournirs'
        ImageIndex = 1
        object Splitter2: TSplitter
          Left = 438
          Top = 25
          Height = 245
          Align = alRight
        end
        object TBXDock2: TTBXDock
          Left = 0
          Top = 0
          Width = 761
          Height = 25
          object TBXToolbar2: TTBXToolbar
            Left = 0
            Top = 0
            Caption = 'TBXToolbar2'
            TabOrder = 0
            object TBControlItem4: TTBControlItem
              Control = eATournirName
            end
            object TBXItem4: TTBXItem
              Action = actAppendATournir
            end
            object TBXItem5: TTBXItem
              Action = actEditATournir
            end
            object TBXItem6: TTBXItem
              Action = actClearTournirHistory
            end
            object TBXItem7: TTBXItem
              Action = actCloseTournir
            end
            object cbTemporary: TTBXItem
              AutoCheck = True
              Caption = #1042#1088#1077#1084#1077#1085#1085#1086
            end
            object eATournirName: TEdit
              Left = 0
              Top = 0
              Width = 313
              Height = 21
              TabOrder = 0
            end
          end
        end
        object gridATournirs: TDBGridEh
          Left = 0
          Top = 25
          Width = 438
          Height = 245
          Align = alClient
          AutoFitColWidths = True
          Color = clBtnFace
          ColumnDefValues.Title.Alignment = taCenter
          ColumnDefValues.Title.TitleButton = True
          DataGrouping.GroupLevels = <>
          DataSource = dsATournirs
          Flat = True
          FooterColor = clWindow
          FooterFont.Charset = DEFAULT_CHARSET
          FooterFont.Color = clWindowText
          FooterFont.Height = -11
          FooterFont.Name = 'MS Sans Serif'
          FooterFont.Style = []
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
          OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghIncSearch, dghPreferIncSearch, dghRowHighlight, dghDialogFind, dghColumnResize, dghColumnMove]
          RowDetailPanel.Color = clBtnFace
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          OnDblClick = gridATournirsDblClick
          Columns = <
            item
              EditButtons = <>
              FieldName = 'ATOURNIR_ID'
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
              AutoFitColWidth = False
              EditButtons = <>
              FieldName = 'ATOURNIR_LVL'
              Footers = <>
              Title.Caption = 'lvl'
              Width = 20
            end
            item
              EditButtons = <>
              FieldName = 'ATOURNIR_NM'
              Footers = <>
              Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1090#1091#1088#1085#1080#1088#1072
              Width = 500
            end
            item
              Alignment = taCenter
              AutoFitColWidth = False
              EditButtons = <>
              FieldName = 'COUNTRY_SGN'
              Footers = <>
              Title.Caption = #1057#1090#1088#1072#1085#1072
              Width = 40
            end
            item
              AutoFitColWidth = False
              EditButtons = <>
              FieldName = 'START_DT'
              Footers = <>
              Title.Caption = #1053#1072#1095#1072#1083#1086
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
        object gridHistory: TDBGridEh
          Left = 441
          Top = 25
          Width = 320
          Height = 245
          Align = alRight
          AutoFitColWidths = True
          Color = clBtnFace
          DataGrouping.GroupLevels = <>
          DataSource = dsHistory
          Flat = True
          FooterColor = clWhite
          FooterFont.Charset = DEFAULT_CHARSET
          FooterFont.Color = clWindowText
          FooterFont.Height = -11
          FooterFont.Name = 'MS Sans Serif'
          FooterFont.Style = []
          RowDetailPanel.Color = clBtnFace
          TabOrder = 2
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          Columns = <
            item
              EditButtons = <>
              FieldName = 'ASPORT_ID'
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
              Width = 200
            end
            item
              EditButtons = <>
              FieldName = 'USED_DT'
              Footers = <>
            end>
          object RowDetailData: TRowDetailPanelControlEh
          end
        end
      end
      object tsBEvents: TTabSheet
        Caption = 'tsBEvents'
        ImageIndex = 2
        object gridBEvents: TDBGridEh
          Left = 0
          Top = 0
          Width = 761
          Height = 254
          Align = alClient
          AutoFitColWidths = True
          Color = clBtnFace
          ColumnDefValues.Title.Alignment = taCenter
          ColumnDefValues.Title.TitleButton = True
          ColumnDefValues.Title.ToolTips = True
          DataGrouping.GroupLevels = <>
          DataSource = dsBEvents
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
              Visible = False
            end
            item
              EditButtons = <>
              FieldName = 'BTOURNIR_ID'
              Footers = <>
              Visible = False
            end
            item
              AutoFitColWidth = False
              EditButtons = <>
              FieldName = 'EVENT_DTM'
              Footers = <>
            end
            item
              EditButtons = <>
              FieldName = 'AGAMER1_ID'
              Footers = <>
              Visible = False
            end
            item
              EditButtons = <>
              FieldName = 'BGAMER1_ID'
              Footers = <>
              Visible = False
            end
            item
              EditButtons = <>
              FieldName = 'GAMER1_NM'
              Footers = <>
              Width = 200
            end
            item
              EditButtons = <>
              FieldName = 'AGAMER2_ID'
              Footers = <>
              Visible = False
            end
            item
              EditButtons = <>
              FieldName = 'BGAMER2_ID'
              Footers = <>
              Visible = False
            end
            item
              EditButtons = <>
              FieldName = 'GAMER2_NM'
              Footers = <>
              Width = 200
            end
            item
              AutoFitColWidth = False
              EditButtons = <>
              FieldName = 'COMPLETE_FLG'
              Footers = <>
            end
            item
              AutoFitColWidth = False
              EditButtons = <>
              FieldName = 'IGNORE_FLG'
              Footers = <>
            end>
          object RowDetailData: TRowDetailPanelControlEh
          end
        end
      end
      object tsAEvents: TTabSheet
        Caption = 'tsAEvents'
        ImageIndex = 3
        object DBGridEh1: TDBGridEh
          Left = 0
          Top = 0
          Width = 761
          Height = 254
          Align = alClient
          AutoFitColWidths = True
          Color = clBtnFace
          DataGrouping.GroupLevels = <>
          DataSource = dsAEvents
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
              FieldName = 'EVENT_DTM'
              Footers = <>
            end
            item
              EditButtons = <>
              FieldName = 'AGAMER1_ID'
              Footers = <>
              Visible = False
            end
            item
              EditButtons = <>
              FieldName = 'GAMER1_NM'
              Footers = <>
              Width = 100
            end
            item
              EditButtons = <>
              FieldName = 'AGAMER1_NM'
              Footers = <>
              Width = 100
            end
            item
              EditButtons = <>
              FieldName = 'AGAMER2_ID'
              Footers = <>
              Visible = False
            end
            item
              EditButtons = <>
              FieldName = 'GAMER2_NM'
              Footers = <>
              Width = 100
            end
            item
              EditButtons = <>
              FieldName = 'AGAMER2_NM'
              Footers = <>
              Width = 100
            end
            item
              EditButtons = <>
              FieldName = 'COMPLETE_FLG'
              Footers = <>
              Visible = False
            end
            item
              EditButtons = <>
              FieldName = 'IGNORE_FLG'
              Footers = <>
              Visible = False
            end
            item
              EditButtons = <>
              FieldName = 'MEVENT_ID'
              Footers = <>
              Visible = False
            end>
          object RowDetailData: TRowDetailPanelControlEh
          end
        end
      end
    end
  end
  inherited dckRight: TTBXMultiDock
    Left = 764
    Height = 173
  end
  inherited tblMain: TpFIBDataSet
    UpdateSQL.Strings = (
      'UPDATE BTOURNIRS'
      'SET '
      '    ATOURNIR_ID = :ATOURNIR_ID,'
      '    ASPORT_ID = :ASPORT_ID,'
      '    COUNTRY_SGN = :COUNTRY_SGN,'
      '    USED_DT = :USED_DT,'
      '    IGNORE_FLG = :IGNORE_FLG'
      'WHERE'
      '    BTOURNIR_ID = :OLD_BTOURNIR_ID'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      '    BTOURNIRS'
      'WHERE'
      '        BTOURNIR_ID = :OLD_BTOURNIR_ID'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO BTOURNIRS('
      '    BTOURNIR_ID,'
      '    ATOURNIR_ID,'
      '    BOOKER_ID,'
      '    BSPORT_ID,'
      '    BTOURNIR_NM,'
      '    ASPORT_ID,'
      '    COUNTRY_SGN,'
      '    USED_DT,'
      '    IGNORE_FLG'
      ')'
      'VALUES('
      '    :BTOURNIR_ID,'
      '    :ATOURNIR_ID,'
      '    :BOOKER_ID,'
      '    :BSPORT_ID,'
      '    :BTOURNIR_NM,'
      '    :ASPORT_ID,'
      '    :COUNTRY_SGN,'
      '    :USED_DT,'
      '    :IGNORE_FLG'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    t.BTOURNIR_ID,'
      '    t.ATOURNIR_ID,'
      '    s.ATOURNIR_NM,'
      '    t.BOOKER_ID,'
      '    b.BOOKER_NM,'
      '    t.BSPORT_ID,'
      '    t.BTOURNIR_NM,'
      '    t.ASPORT_ID,'
      '    a.ASPORT_NM,'
      '    t.COUNTRY_SGN,'
      '    t.USED_DT,'
      '    t.IGNORE_FLG,'
      
        '    iif((t.COUNTRY_SGN IS NULL) OR (t.ATOURNIR_ID IS NULL), 0, 1' +
        ') COMPLETE_FLG'
      'FROM'
      '    BTOURNIRS t'
      '      LEFT JOIN BOOKERS b'
      '        ON (b.BOOKER_ID = t.BOOKER_ID)'
      '      LEFT JOIN ASPORTS a'
      '        ON (a.ASPORT_ID = t.ASPORT_ID)'
      '      LEFT JOIN ATOURNIRS s'
      '        ON (s.ATOURNIR_ID = t.ATOURNIR_ID)'
      ''
      ' WHERE '
      '        T.BTOURNIR_ID = :OLD_BTOURNIR_ID'
      '    ')
    SelectSQL.Strings = (
      'SELECT'
      '    t.BTOURNIR_ID,'
      '    t.ATOURNIR_ID,'
      '    s.ATOURNIR_NM,'
      '    t.BOOKER_ID,'
      '    b.BOOKER_NM,'
      '    t.BSPORT_ID,'
      '    t.BTOURNIR_NM,'
      '    t.ASPORT_ID,'
      '    a.ASPORT_NM,'
      '    t.COUNTRY_SGN,'
      '    t.USED_DT,'
      '    t.IGNORE_FLG,'
      
        '    iif((t.COUNTRY_SGN IS NULL) OR (t.ATOURNIR_ID IS NULL), 0, 1' +
        ') COMPLETE_FLG'
      'FROM'
      '    BTOURNIRS t'
      '      LEFT JOIN BOOKERS b'
      '        ON (b.BOOKER_ID = t.BOOKER_ID)'
      '      LEFT JOIN ASPORTS a'
      '        ON (a.ASPORT_ID = t.ASPORT_ID)'
      '      LEFT JOIN ATOURNIRS s'
      '        ON (s.ATOURNIR_ID = t.ATOURNIR_ID)'
      'ORDER BY '
      '  COMPLETE_FLG,'
      '  a.ASPORT_NM,'
      '  t.BTOURNIR_NM'
      '  ')
    AllowedUpdateKinds = [ukModify, ukDelete]
    DataSet_ID = 6
    Description = 'BTOURNIRS'
    poApplyRepositary = True
  end
  object dsCountrys: TDataSource
    AutoEdit = False
    DataSet = tblCountrys
    Left = 160
    Top = 104
  end
  object PartsAction: TActionList
    Left = 144
    Top = 40
    object actSporPart: TAction
      Caption = #1044#1088#1091#1075#1086#1081' '#1089#1087#1086#1088#1090
      OnExecute = actSporPartExecute
      OnUpdate = actSporPartUpdate
    end
    object actCountryPart: TAction
      Caption = #1059#1089#1090'. '#1089#1090#1088#1072#1085#1091
      OnExecute = actCountryPartExecute
      OnUpdate = actCountryPartUpdate
    end
    object actIgnorePart: TAction
      Caption = #1048#1075#1085#1086#1088#1080#1088#1086#1074#1072#1090#1100
      OnExecute = actIgnorePartExecute
    end
    object actAppendATournir: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1090#1091#1088#1085#1080#1088
      OnExecute = actAppendATournirExecute
      OnUpdate = actAppendATournirUpdate
    end
    object actSetATournir: TAction
      Caption = 'actSetATournir'
      OnExecute = actSetATournirExecute
    end
    object actEditATournir: TAction
      AutoCheck = True
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      OnExecute = actEditATournirExecute
    end
    object actClearTournirHistory: TAction
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1080#1089#1090#1086#1088#1080#1102
      OnExecute = actClearTournirHistoryExecute
    end
    object actCloseTournir: TAction
      Caption = #1047#1072#1082#1088#1099#1090#1100
      OnExecute = actCloseTournirExecute
    end
  end
  object dsParts: TDataSource
    AutoEdit = False
    DataSet = tblParts
    Left = 96
    Top = 104
  end
  object dsASports: TDataSource
    AutoEdit = False
    DataSet = tblASports
    Left = 128
    Top = 104
  end
  object dsATournirs: TDataSource
    DataSet = tblATournirs
    Left = 192
    Top = 104
  end
  object dsBEvents: TDataSource
    AutoEdit = False
    DataSet = tblBEvents
    Left = 256
    Top = 104
  end
  object dsHistory: TDataSource
    AutoEdit = False
    DataSet = tblHistory
    Left = 224
    Top = 104
  end
  object tblParts: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    BTOURNIR_ID,'
      '    PART_LVL,'
      '    PART_TXT,'
      '    PART_UTXT'
      'FROM'
      '    PARTS '
      'WHERE'
      '    BTOURNIR_ID = :BTOURNIR_ID'
      'ORDER BY PART_LVL, PART_UTXT')
    Transaction = dmSwim.ReadTran
    Database = dmSwim.Database
    UpdateTransaction = dmSwim.UpdateTran
    DataSource = dsMain
    DataSet_ID = 110
    Description = 'PARTS_BY_BTOURNIR'
    Left = 96
    Top = 72
    poApplyRepositary = True
    dcIgnoreMasterClose = True
  end
  object tblASports: TpFIBDataSet
    UpdateSQL.Strings = (
      'UPDATE ASPORTS'
      'SET '
      ' ASPORT_NM = :ASPORT_NM,'
      ' DEFAULT_FLG = :DEFAULT_FLG,'
      ' COUNTRY_FLG = :COUNTRY_FLG,'
      ' ASUBSPORT1_ID = :ASUBSPORT1_ID,'
      ' ASUBSPORT2_ID = :ASUBSPORT2_ID,'
      ' WAYS_CNT = :WAYS_CNT,'
      ' EVENT_OFS = :EVENT_OFS'
      'WHERE'
      ' ASPORT_ID = :OLD_ASPORT_ID'
      ' ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      ' ASPORTS'
      'WHERE'
      '  ASPORT_ID = :OLD_ASPORT_ID'
      ' ')
    InsertSQL.Strings = (
      'INSERT INTO ASPORTS('
      ' ASPORT_ID,'
      ' ASPORT_NM,'
      ' DEFAULT_FLG,'
      ' COUNTRY_FLG,'
      ' ASUBSPORT1_ID,'
      ' ASUBSPORT2_ID,'
      ' WAYS_CNT,'
      ' EVENT_OFS'
      ')'
      'VALUES('
      ' :ASPORT_ID,'
      ' :ASPORT_NM,'
      ' :DEFAULT_FLG,'
      ' :COUNTRY_FLG,'
      ' :ASUBSPORT1_ID,'
      ' :ASUBSPORT2_ID,'
      ' :WAYS_CNT,'
      ' :EVENT_OFS'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '  ASPORT_ID,'
      '  ASPORT_NM,'
      '  DEFAULT_FLG,'
      '  COUNTRY_FLG,'
      '  ASUBSPORT1_ID,'
      '  ASUBSPORT2_ID,'
      '  WAYS_CNT,'
      '  EVENT_OFS'
      'FROM'
      '  ASPORTS '
      'WHERE '
      '  ASPORTS.ASPORT_ID = :OLD_ASPORT_ID'
      ' ')
    SelectSQL.Strings = (
      'SELECT'
      ' ASPORT_ID,'
      ' ASPORT_NM,'
      ' DEFAULT_FLG,'
      ' COUNTRY_FLG,'
      ' ASUBSPORT1_ID,'
      ' ASUBSPORT2_ID,'
      ' WAYS_CNT,'
      ' EVENT_OFS'
      'FROM'
      ' ASPORTS '
      'ORDER BY ASPORT_NM'
      ''
      '')
    AutoUpdateOptions.UpdateTableName = 'ASPORTS'
    AutoUpdateOptions.KeyFields = 'ASPORT_ID'
    AutoUpdateOptions.GeneratorName = 'GEN_ASPORT_ID'
    AutoUpdateOptions.WhenGetGenID = wgBeforePost
    Transaction = dmSwim.ReadTran
    Database = dmSwim.Database
    UpdateTransaction = dmSwim.UpdateTran
    DataSet_ID = 1
    Description = 'ASPORTS'
    Left = 128
    Top = 72
    poApplyRepositary = True
    dcIgnoreMasterClose = True
  end
  object tblCountrys: TpFIBDataSet
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
    Left = 160
    Top = 72
    poApplyRepositary = True
    dcIgnoreMasterClose = True
  end
  object tblATournirs: TpFIBDataSet
    UpdateSQL.Strings = (
      'UPDATE ATOURNIRS'
      'SET '
      '    '
      '    ATOURNIR_NM = :ATOURNIR_NM,'
      '    ATOURNIR_LVL = :ATOURNIR_LVL'
      'WHERE'
      '    ATOURNIR_ID = :OLD_ATOURNIR_ID'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      '    ATOURNIRS'
      'WHERE'
      '        ATOURNIR_ID = :OLD_ATOURNIR_ID'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO ATOURNIRS('
      '    ATOURNIR_ID,'
      '    ASPORT_ID,'
      '    ATOURNIR_NM,'
      '    COUNTRY_SGN,'
      '    START_DT,'
      '    END_DT,'
      '    MTOURNIR_ID'
      ')'
      'VALUES('
      '    :ATOURNIR_ID,'
      '    :ASPORT_ID,'
      '    :ATOURNIR_NM,'
      '    :COUNTRY_SGN,'
      '    :START_DT,'
      '    :END_DT,'
      '    :MTOURNIR_ID'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    ATOURNIR_ID,'
      '    ASPORT_ID,'
      '    ATOURNIR_LVL,'
      '    ATOURNIR_NM,'
      '    COUNTRY_SGN,'
      '    START_DT,'
      '    END_DT,'
      '    MTOURNIR_ID'
      'FROM'
      '    ATOURNIRS '
      'WHERE ASPORT_ID = :ASPORT_ID'
      '  AND COUNTRY_SGN = :COUNTRY_SGN'
      '  AND ATOURNIRS.ATOURNIR_ID = :OLD_ATOURNIR_ID'
      '     '
      '    ')
    SelectSQL.Strings = (
      'SELECT'
      '    ATOURNIR_ID,'
      '    ASPORT_ID,'
      '    ATOURNIR_LVL,'
      '    ATOURNIR_NM,'
      '    COUNTRY_SGN,'
      '    START_DT,'
      '    END_DT,'
      '    MTOURNIR_ID'
      'FROM'
      '    ATOURNIRS '
      'WHERE ASPORT_ID = :ASPORT_ID'
      '  AND COUNTRY_SGN = :COUNTRY_SGN'
      'ORDER BY'
      '   END_DT,'
      '   ATOURNIR_LVL,'
      '   ATOURNIR_NM')
    Transaction = dmSwim.ReadTran
    Database = dmSwim.Database
    UpdateTransaction = dmSwim.UpdateTran
    AutoCommit = True
    DataSource = dsMain
    DataSet_ID = 105
    Description = 'ATOURNIRS_BY_ASPORT'
    Left = 192
    Top = 72
    poApplyRepositary = True
    dcIgnoreMasterClose = True
  end
  object tblHistory: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    ATOURNIR_ID,'
      '    ATOURNIR_NM,'
      '    COUNTRY_SGN,'
      '    AGAMER_ID,'
      '    AGAMER_NM,'
      '    USED_DT'
      'FROM'
      '    VE_HISTORY'
      'WHERE'
      '   ATOURNIR_ID = :ATOURNIR_ID'
      'ORDER BY'
      '   AGAMER_NM ')
    Transaction = dmSwim.ReadTran
    Database = dmSwim.Database
    UpdateTransaction = dmSwim.UpdateTran
    DataSource = dsATournirs
    DataSet_ID = 111
    Left = 224
    Top = 72
    poApplyRepositary = True
    dcIgnoreMasterClose = True
  end
  object tblBEvents: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    EVENT_ID,'
      '    ASPORT_ID,'
      '    BTOURNIR_ID,'
      '    EVENT_DTM,'
      '    GAMER1_NM,'
      '    GAMER2_NM,'
      '    COMPLETE_FLG,'
      '    IGNORE_FLG'
      'FROM'
      '    VE_EVENTS '
      'WHERE BTOURNIR_ID = :BTOURNIR_ID'
      'ORDER BY '
      '    EVENT_DTM')
    Transaction = dmSwim.ReadTran
    Database = dmSwim.Database
    UpdateTransaction = dmSwim.UpdateTran
    DataSource = dsMain
    DataSet_ID = 112
    Description = 'EVENTS_BY_BTOURNIR'
    Left = 256
    Top = 72
    poApplyRepositary = True
    dcIgnoreMasterClose = True
  end
  object tblAEvents: TpFIBDataSet
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
      'ORDER BY'
      '    EVENT_DTM,'
      '    AGAMER1_NM ')
    Transaction = dmSwim.ReadTran
    Database = dmSwim.Database
    UpdateTransaction = dmSwim.UpdateTran
    DataSource = dsATournirs
    DataSet_ID = 113
    Description = 'EVENTS_BY_ATOURNIR'
    Left = 288
    Top = 72
    poApplyRepositary = True
    dcIgnoreMasterClose = True
  end
  object dsAEvents: TDataSource
    AutoEdit = False
    DataSet = tblAEvents
    Left = 288
    Top = 104
  end
end
