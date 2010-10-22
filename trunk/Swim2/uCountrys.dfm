inherited frmCountrys: TfrmCountrys
  Left = 385
  Top = 275
  Caption = 'frmCountrys'
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
    Columns = <
      item
        AutoFitColWidth = False
        EditButtons = <>
        FieldName = 'ACOUNTRY_SGN'
        Footers = <>
        Title.Caption = 'Alfa3'
        Width = 40
      end
      item
        EditButtons = <>
        FieldName = 'ACOUNTRY_NM'
        Footers = <>
        Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1089#1090#1088#1072#1085#1099
      end
      item
        AutoFitColWidth = False
        EditButtons = <>
        FieldName = 'MCOUNTRY_SGN'
        Footers = <>
        Title.Caption = 'Alfa3'
        Width = 40
      end
      item
        EditButtons = <>
        FieldName = 'MCOUNTRY_NM'
        Footers = <>
        ReadOnly = True
        STFilter.DataField = 'MCOUNTRY_SGN'
        STFilter.KeyField = 'ACOUNTRY_SGN'
        STFilter.ListField = 'ACOUNTRY_NM'
        STFilter.ListSource = dsMCountrys
        Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1089#1090#1088#1072#1085#1099'-'#1089#1080#1085#1086#1085#1080#1084#1072
      end>
  end
  inherited Panel: TGvCollapsePanel
    Top = 106
    Height = 300
    State = csExpand
    inherited pcDetail: TPageControl
      Height = 282
    end
  end
  inherited dckRight: TTBXMultiDock
    Height = 77
  end
  object cdsMCountrys: TpFIBClientDataSet [7]
    Aggregates = <>
    Params = <>
    ProviderName = 'dspMain'
    ReadOnly = True
    Left = 32
    Top = 104
  end
  object dsMCountrys: TDataSource [8]
    AutoEdit = False
    DataSet = cdsMCountrys
    Enabled = False
    Left = 96
    Top = 104
  end
  inherited tblMain: TpFIBDataSet
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
    DataSet_ID = 4
    Description = 'COUNTRYS'
    poApplyRepositary = True
  end
end
