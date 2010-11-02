inherited frmAGamers: TfrmAGamers
  Caption = 'frmAGamers'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited TBXDockUp: TTBXDock
    inherited TBXToolbar: TTBXToolbar
      inherited DBNavigator: TDBNavigator
        Hints.Strings = ()
      end
    end
  end
  inherited gridMain: TDBGridEh
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
        Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1082#1086#1084#1072#1085#1076#1099'/'#1048#1075#1088#1086#1082#1072
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
        Width = 60
      end>
  end
end
