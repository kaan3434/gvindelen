object FrameCriterias: TFrameCriterias
  Left = 0
  Top = 0
  Width = 495
  Height = 240
  TabOrder = 0
  object dckTop: TTBXDock
    Left = 0
    Top = 0
    Width = 495
    Height = 25
    object tb1: TTBXToolbar
      Left = 0
      Top = 0
      Caption = 'tb1'
      DockMode = dmCannotFloatOrChangeDocks
      DragHandleStyle = dhNone
      FullSize = True
      TabOrder = 0
      object btnNew: TTBXItem
        Action = actNew
      end
      object btnEdit: TTBXItem
        Action = actEdit
      end
      object btnDelete: TTBXItem
        Action = actDelete
      end
      object tbsep1: TTBXSeparatorItem
      end
      object btnCopy: TTBXItem
        Action = actCopy
      end
      object btnPaste: TTBXItem
        Action = actPaste
      end
      object btnClear: TTBXItem
        Action = actClear
      end
    end
  end
  object grdCriterias: TDBGridEh
    Left = 0
    Top = 25
    Width = 495
    Height = 215
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
    Left = 232
    Top = 64
  end
  object actCriterias: TActionList
    Left = 136
    Top = 64
    object actNew: TAction
      Caption = #1053#1086#1074#1099#1081
      OnExecute = actNewExecute
      OnUpdate = actNewUpdate
    end
    object actEdit: TAction
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      OnExecute = actEditExecute
      OnUpdate = actEditUpdate
    end
    object actDelete: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnExecute = actDeleteExecute
      OnUpdate = actDeleteUpdate
    end
    object actCopy: TAction
      Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100
      OnExecute = actCopyExecute
      OnUpdate = actCopyUpdate
    end
    object actPaste: TAction
      Caption = #1042#1089#1090#1072#1074#1080#1090#1100
      OnExecute = actPasteExecute
      OnUpdate = actPasteUpdate
    end
    object actClear: TAction
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      OnExecute = actClearExecute
      OnUpdate = actClearUpdate
    end
  end
end
