object Frame2: TFrame2
  Left = 0
  Top = 0
  Width = 560
  Height = 382
  TabOrder = 0
  object grdParams: TDBGridEh
    Left = 0
    Top = 25
    Width = 560
    Height = 357
    Align = alClient
    DataSource = dsParams
    DynProps = <>
    Flat = True
    IndicatorOptions = [gioShowRowIndicatorEh]
    ReadOnly = True
    TabOrder = 0
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
        Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        Width = 150
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
        DynProps = <>
        EditButtons = <>
        FieldName = 'PARAM_VALUE'
        Footers = <>
        Title.Alignment = taCenter
        Title.Caption = #1047#1085#1072#1095#1077#1085#1080#1077'/'#1074#1099#1088#1072#1078#1077#1085#1080#1077
        Width = 300
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object dckParams: TTBXDock
    Left = 0
    Top = 0
    Width = 560
    Height = 25
    object tbParams: TTBXToolbar
      Left = 0
      Top = 0
      Caption = 'tbParams'
      DefaultDock = dckParams
      DockMode = dmCannotFloatOrChangeDocks
      DragHandleStyle = dhNone
      FullSize = True
      Stretch = True
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
      object tbsepseparator: TTBXSeparatorItem
      end
      object btnPaste: TTBXItem
        Action = actPaste
      end
      object btnCopy: TTBXItem
        Action = actCopy
      end
      object btnClear: TTBXItem
        Action = actClear
      end
    end
  end
  object actParams: TActionList
    Left = 104
    Top = 64
    object actNew: TAction
      Caption = 'actNew'
      OnExecute = actNewExecute
    end
    object actDelete: TAction
      Caption = 'actDelete'
    end
    object actEdit: TAction
      Caption = 'actEdit'
    end
    object actCopy: TAction
      Caption = 'actCopy'
    end
    object actPaste: TAction
      Caption = 'actPaste'
    end
    object actClear: TAction
      Caption = 'actClear'
    end
  end
  object dsParams: TDataSource
    AutoEdit = False
    Left = 160
    Top = 64
  end
end
