inherited frmBSports: TfrmBSports
  Left = 190
  Top = 238
  Width = 715
  Height = 442
  Caption = 'frmBSports'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited Splitter1: TSplitter
    Top = 112
    Width = 707
  end
  inherited TBXDockUp: TTBXDock
    Width = 707
    inherited TBXToolbar: TTBXToolbar
      inherited DBNavigator: TDBNavigator
        Hints.Strings = ()
      end
    end
  end
  inherited gridMain: TDBGridEh
    Width = 707
    Height = 86
    ColumnDefValues.AutoDropDown = False
    Columns = <
      item
        EditButtons = <>
        FieldName = 'BSPORT_ID'
        Footers = <>
        Visible = False
      end
      item
        EditButtons = <>
        FieldName = 'BSPORT_NM'
        Footers = <>
        ReadOnly = True
        Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1089#1087#1086#1088#1090#1072
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
        STFilter.DataField = 'ASPORT_ID'
        STFilter.KeyField = 'ASPORT_ID'
        STFilter.ListField = 'ASPORT_NM'
        STFilter.ListSource = dsASports
        Title.Caption = #1057#1087#1086#1088#1090
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
        ReadOnly = True
        Title.Caption = #1041#1091#1082#1084#1077#1082#1077#1088
      end
      item
        EditButtons = <>
        FieldName = 'IGNORE_FLG'
        Footers = <>
        Visible = False
      end>
  end
  inherited Panel: TPanel
    Top = 115
    Width = 707
    Height = 300
    ExpandedHeight = 300
    State = csExpand
    inherited pcDetail: TPageControl
      Width = 705
      Height = 282
      ActivePage = tsASports
      object tsASports: TTabSheet
        Caption = 'tsASports'
        ImageIndex = 1
        object gridASports: TDBGridEh
          Left = 0
          Top = 0
          Width = 697
          Height = 254
          Align = alClient
          AutoFitColWidths = True
          Color = clBtnFace
          DataSource = dsASports
          Flat = True
          FooterColor = clWindow
          FooterFont.Charset = DEFAULT_CHARSET
          FooterFont.Color = clWindowText
          FooterFont.Height = -11
          FooterFont.Name = 'MS Sans Serif'
          FooterFont.Style = []
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
          OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind]
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          OnDblClick = gridASportsDblClick
          Columns = <
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
            end
            item
              Checkboxes = True
              EditButtons = <>
              FieldName = 'DEFAULT_FLG'
              Footers = <>
              KeyList.Strings = (
                '1'
                '0')
            end
            item
              Checkboxes = True
              EditButtons = <>
              FieldName = 'COUNTRY_FLG'
              Footers = <>
              KeyList.Strings = (
                '1'
                '0')
            end
            item
              EditButtons = <>
              FieldName = 'WAYS_CNT'
              Footers = <>
            end
            item
              EditButtons = <>
              FieldName = 'EVENT_OFS'
              Footers = <>
            end>
        end
      end
      object tsTournirs: TTabSheet
        Caption = #1058#1091#1088#1085#1080#1088#1099
        object gridBTournirs: TDBGridEh
          Left = 0
          Top = 0
          Width = 697
          Height = 254
          Align = alClient
          AutoFitColWidths = True
          Color = clBtnFace
          ColumnDefValues.Title.Alignment = taCenter
          DataSource = dsBTournirs
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
          OnGetCellParams = gridMainGetCellParams
          Columns = <
            item
              AutoFitColWidth = False
              EditButtons = <>
              FieldName = 'BTOURNIR_ID'
              Footers = <>
              Visible = False
            end
            item
              AutoFitColWidth = False
              EditButtons = <>
              FieldName = 'BSPORT_ID'
              Footers = <>
              Visible = False
            end
            item
              EditButtons = <>
              FieldName = 'BTOURNIR_NM'
              Footers = <>
              Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1090#1091#1088#1085#1080#1088#1072
              Width = 500
            end
            item
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
              FieldName = 'USED_DT'
              Footers = <>
              Title.Caption = 'Last Use'
              Width = 60
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
              Width = 40
            end>
        end
      end
    end
  end
  inherited ActionList: TActionList
    object actSelectASports: TAction [2]
      Category = 'ColumnAction'
      Caption = #1042#1099#1073#1088#1072#1090#1100' '#1089#1087#1086#1088#1090
      OnExecute = actSelectASportsExecute
    end
  end
  inherited tblMain: TpFIBDataSet
    UpdateSQL.Strings = (
      'UPDATE BSPORTS'
      'SET '
      '    ASPORT_ID = :ASPORT_ID,'
      '    IGNORE_FLG = :IGNORE_FLG'
      'WHERE'
      '    BSPORT_ID = :OLD_BSPORT_ID'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      '    BSPORTS'
      'WHERE'
      '        BSPORT_ID = :OLD_BSPORT_ID'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO BSPORTS('
      '    BSPORT_ID,'
      '    BSPORT_NM,'
      '    ASPORT_ID,'
      '    BOOKER_ID,'
      '    IGNORE_FLG'
      ')'
      'VALUES('
      '    :BSPORT_ID,'
      '    :BSPORT_NM,'
      '    :ASPORT_ID,'
      '    :BOOKER_ID,'
      '    :IGNORE_FLG'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    s.BSPORT_ID,'
      '    s.BSPORT_NM,'
      '    s.ASPORT_ID,'
      '    a.ASPORT_NM,'
      '    s.BOOKER_ID,'
      '    b.BOOKER_NM,'
      '    s.IGNORE_FLG,'
      '    iif(a.ASPORT_ID IS NULL, 0, 1) COMPLETE_FLG'
      'FROM'
      '    BSPORTS s'
      '    LEFT JOIN ASPORTS a'
      '      ON (a.ASPORT_ID = s.ASPORT_ID)'
      '    LEFT JOIN BOOKERS b'
      '      ON (b.BOOKER_ID = s.BOOKER_ID) '
      ''
      ' WHERE '
      '        S.BSPORT_ID = :OLD_BSPORT_ID'
      '    ')
    SelectSQL.Strings = (
      'SELECT'
      '    s.BSPORT_ID,'
      '    s.BSPORT_NM,'
      '    s.ASPORT_ID,'
      '    a.ASPORT_NM,'
      '    s.BOOKER_ID,'
      '    b.BOOKER_NM,'
      '    s.IGNORE_FLG,'
      '    iif(a.ASPORT_ID IS NULL, 0, 1) COMPLETE_FLG'
      'FROM'
      '    BSPORTS s'
      '    LEFT JOIN ASPORTS a'
      '      ON (a.ASPORT_ID = s.ASPORT_ID)'
      '    LEFT JOIN BOOKERS b'
      '      ON (b.BOOKER_ID = s.BOOKER_ID) '
      'ORDER BY'
      '    COMPLETE_FLG,'
      '    s.BSPORT_NM,'
      '    a.ASPORT_NM')
  end
  object dsASports: TDataSource
    AutoEdit = False
    DataSet = tblASports
    Left = 96
    Top = 104
  end
  object dsBTournirs: TDataSource
    AutoEdit = False
    DataSet = tblBTournirs
    Left = 128
    Top = 104
  end
  object tblASports: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    ASPORT_ID,'
      '    ASPORT_NM,'
      '    DEFAULT_FLG,'
      '    COUNTRY_FLG,'
      '    WAYS_CNT,'
      '    EVENT_OFS'
      'FROM'
      '    ASPORTS '
      'ORDER BY '
      '    DEFAULT_FLG DESC,'
      '    ASPORT_NM')
    Transaction = dmSwim.ReadTran
    Database = dmSwim.Database
    UpdateTransaction = dmSwim.UpdateTran
    AutoCommit = True
    DataSet_ID = 101
    Description = 'ASPORTS_DETAIL'
    Left = 96
    Top = 72
    poApplyRepositary = True
  end
  object tblBTournirs: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    bt.BTOURNIR_ID,'
      '    bt.ATOURNIR_ID,'
      '    a.ATOURNIR_NM,'
      '    bt.BOOKER_ID,'
      '    bo.BOOKER_NM,'
      '    bt.BSPORT_ID,'
      '    bt.BTOURNIR_NM,'
      '    bt.ASPORT_ID,'
      '    aa.ASPORT_NM,'
      '    bt.COUNTRY_SGN,'
      '    bt.USED_DT,'
      '    bt.IGNORE_FLG'
      'FROM'
      '    BTOURNIRS bt'
      '    LEFT JOIN ATOURNIRS a'
      '      ON (a.ATOURNIR_ID = bt.ATOURNIR_ID)'
      '    LEFT JOIN ASPORTS aa'
      '      ON (aa.ASPORT_ID = bt.ASPORT_ID)'
      '    LEFT JOIN BOOKERS bo'
      '      ON (bo.BOOKER_ID = bt.BOOKER_ID)'
      'WHERE bt.BSPORT_ID = :BSPORT_ID'
      'ORDER BY '
      '    bt.BTOURNIR_NM  ')
    Transaction = dmSwim.ReadTran
    Database = dmSwim.Database
    UpdateTransaction = dmSwim.UpdateTran
    DataSource = dsMain
    DataSet_ID = 106
    Description = 'BTOURNIRS_BY_BSPORT'
    Left = 128
    Top = 72
    poApplyRepositary = True
  end
end
