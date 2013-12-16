object Frame1: TFrame1
  Left = 0
  Top = 0
  Width = 495
  Height = 240
  TabOrder = 0
  object dckTop: TTBXDock
    Left = 0
    Top = 0
    Width = 495
    Height = 26
    object tb1: TTBXToolbar
      Left = 0
      Top = 0
      Caption = 'tb1'
      TabOrder = 0
    end
  end
  object grdCriterias: TDBGridEh
    Left = 0
    Top = 26
    Width = 495
    Height = 214
    Align = alClient
    DataSource = dsCriterias
    DynProps = <>
    Flat = True
    IndicatorOptions = [gioShowRowIndicatorEh]
    TabOrder = 1
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'OBJECT_ID'
        Footers = <>
        Visible = False
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'PARAM_NAME'
        Footers = <>
        Title.Alignment = taCenter
        Title.Caption = #1055#1072#1088#1072#1084#1077#1090#1088
        Width = 100
      end
      item
        Alignment = taCenter
        AutoFitColWidth = False
        DynProps = <>
        EditButtons = <>
        FieldName = 'PARAM_KIND'
        Footers = <>
        Title.Alignment = taCenter
        Title.Caption = #1042#1080#1076
        Width = 30
      end
      item
        Alignment = taCenter
        DynProps = <>
        EditButtons = <>
        FieldName = 'PARAM_ACTION'
        Footers = <>
        Title.Alignment = taCenter
        Title.Caption = #1044#1077#1081#1089#1090#1074#1080#1077
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'PARAM_VALUE_1'
        Footers = <>
        Title.Alignment = taCenter
        Title.Caption = #1047#1085#1072#1095#1077#1085#1080#1077' 1'
        Width = 150
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'PARAM_VALUE_2'
        Footers = <>
        Title.Alignment = taCenter
        Title.Caption = #1047#1085#1072#1095#1077#1085#1080#1077' 2'
        Width = 150
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object dsCriterias: TDataSource
    AutoEdit = False
    Left = 392
    Top = 152
  end
end
