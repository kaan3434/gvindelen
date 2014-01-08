object FrameParams: TFrameParams
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
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghColumnResize, dghColumnMove, dghExtendVertLines]
    ReadOnly = True
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
      Images = imgListParams
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
  object actParams: TActionList
    Left = 104
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
  object dsParams: TDataSource
    AutoEdit = False
    Left = 160
    Top = 64
  end
  object imgListParams: TPngImageList
    PngImages = <>
    Left = 216
    Top = 64
  end
end
