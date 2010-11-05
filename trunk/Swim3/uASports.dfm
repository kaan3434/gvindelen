inherited frmASports: TfrmASports
  Left = 367
  Top = 279
  Height = 539
  Caption = 'frmASports'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited Splitter1: TSplitter
    Top = 209
  end
  inherited TBXDockUp: TTBXDock
    inherited TBXToolbar: TTBXToolbar
      inherited DBNavigator: TDBNavigator
        Hints.Strings = ()
      end
    end
  end
  inherited gridMain: TDBGridEh
    Height = 183
    Columns = <
      item
        AutoFitColWidth = False
        EditButtons = <>
        FieldName = 'ASPORT_ID'
        Footers = <>
        ReadOnly = True
        Width = 30
      end
      item
        EditButtons = <>
        FieldName = 'ASPORT_NM'
        Footers = <>
        HighlightRequired = True
        Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        Title.Hint = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1089#1087#1086#1088#1090#1072
        Width = 64
      end
      item
        AutoFitColWidth = False
        Checkboxes = True
        EditButtons = <>
        FieldName = 'DEFAULT_FLG'
        Footers = <>
        KeyList.Strings = (
          '1'
          '0')
        Title.Caption = 'Default'
        Title.Hint = #1057#1087#1086#1088#1090' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
        Width = 55
      end
      item
        AutoFitColWidth = False
        Checkboxes = True
        EditButtons = <>
        FieldName = 'COUNTRY_FLG'
        Footers = <>
        KeyList.Strings = (
          '1'
          '0')
        Title.Caption = 'Country'
        Title.Hint = #1048#1075#1088#1086#1082#1080' '#1086#1090#1073#1080#1088#1072#1102#1090#1089#1103' '#1087#1086' '#1089#1090#1088#1072#1085#1072#1084', '#1091#1082#1072#1079#1072#1085#1085#1099#1084' '#1074' '#1090#1091#1088#1085#1080#1088#1077
        Width = 55
      end
      item
        EditButtons = <>
        FieldName = 'ASUBSPORT1_ID'
        Footers = <>
        Visible = False
      end
      item
        EditButtons = <>
        FieldName = 'ASUBSPORT1_NM'
        Footers = <>
        Title.Caption = #1057#1087#1086#1088#1090' 1-'#1075#1086' '#1080#1075#1088#1086#1082#1072
      end
      item
        EditButtons = <>
        FieldName = 'ASUBSPORT2_ID'
        Footers = <>
        Visible = False
      end
      item
        EditButtons = <>
        FieldName = 'ASUBSPORT2_NM'
        Footers = <>
        Title.Caption = #1057#1087#1086#1088#1090' 2-'#1075#1086' '#1080#1075#1088#1086#1082#1072
        Width = 64
      end
      item
        AutoFitColWidth = False
        EditButtons = <>
        FieldName = 'WAYS_CNT'
        Footers = <>
        Title.Caption = #1048#1089#1093#1086#1076#1085#1086#1089#1090#1100
        Title.Hint = #1050#1086#1083'-'#1074#1086' '#1048#1089#1093#1086#1076#1086#1074' '#1086#1089#1085#1086#1074#1085#1086#1075#1086' '#1089#1086#1073#1099#1090#1080#1103' '#1089#1087#1086#1088#1090#1072
        Width = 80
      end
      item
        AutoFitColWidth = False
        EditButtons = <>
        FieldName = 'EVENT_OFS'
        Footers = <>
        Title.Caption = #1054#1076#1085#1086' '#1089#1086#1073#1099#1090#1080#1077
        Title.Hint = #1050#1086#1083'-'#1074#1086' '#1095#1072#1089#1086#1074' '#1089#1084#1077#1097#1077#1085#1080#1103' '#1089#1086#1073#1099#1090#1080#1103
        Width = 90
      end>
  end
  inherited Panel: TPanel
    Top = 212
    Height = 300
    Visible = False
    State = csExpand
    inherited pcDetail: TPageControl
      Height = 282
    end
  end
  object dsASubSports: TDataSource [5]
    AutoEdit = False
    DataSet = tblASubSports
    Left = 96
    Top = 104
  end
  inherited dsMain: TDataSource
    AutoEdit = False
  end
  inherited tblMain: TpFIBDataSet
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
    DataSet_ID = 1
    Description = 'ASPORTS'
    poApplyRepositary = True
    object tblMainASPORT_ID: TFIBIntegerField
      FieldName = 'ASPORT_ID'
    end
    object tblMainASPORT_NM: TFIBStringField
      FieldName = 'ASPORT_NM'
      Size = 25
      EmptyStrToNull = True
    end
    object tblMainDEFAULT_FLG: TFIBSmallIntField
      FieldName = 'DEFAULT_FLG'
    end
    object tblMainCOUNTRY_FLG: TFIBSmallIntField
      FieldName = 'COUNTRY_FLG'
    end
    object tblMainASUBSPORT1_ID: TFIBIntegerField
      FieldName = 'ASUBSPORT1_ID'
    end
    object tblMainASUBSPORT2_ID: TFIBIntegerField
      FieldName = 'ASUBSPORT2_ID'
    end
    object tblMainWAYS_CNT: TFIBSmallIntField
      FieldName = 'WAYS_CNT'
    end
    object tblMainEVENT_OFS: TFIBSmallIntField
      FieldName = 'EVENT_OFS'
    end
    object tblMainASUBSPORT1_NM: TStringField
      FieldKind = fkLookup
      FieldName = 'ASUBSPORT1_NM'
      LookupDataSet = tblASubSports
      LookupKeyFields = 'ASPORT_ID'
      LookupResultField = 'ASPORT_NM'
      KeyFields = 'ASUBSPORT1_ID'
      Size = 25
      Lookup = True
    end
    object tblMainASUBSPORT2_NM: TStringField
      FieldKind = fkLookup
      FieldName = 'ASUBSPORT2_NM'
      LookupDataSet = tblASubSports
      LookupKeyFields = 'ASPORT_ID'
      LookupResultField = 'ASPORT_NM'
      KeyFields = 'ASUBSPORT2_ID'
      Size = 25
      Lookup = True
    end
  end
  object tblASubSports: TpFIBDataSet
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
    Left = 96
    Top = 72
    poApplyRepositary = True
  end
end
