object fSwim: TfSwim
  Left = 518
  Top = 290
  Width = 783
  Height = 371
  Caption = #1042#1080#1083#1086#1095#1082#1080
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010002002020100000000000E80200002600000010101000000000002801
    00000E0300002800000020000000400000000100040000000000800200000000
    0000000000000000000000000000000000000000800000800000008080008000
    0000800080008080000080808000C0C0C0000000FF0000FF000000FFFF00FF00
    0000FF00FF00FFFF0000FFFFFF000CCCCCCCCCCCCCCCCCCCCCCCCCCCCCC0CCCC
    CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCFFFFFFFFFFFFFFFFFFFFFFFFCCCCCCCC
    FFFFFFFFFFFFFFFFFFFFFFFFCCCCCCCCFFFFFFF0FFFFF0F0F0F0FFFFCCCCCCCC
    FFFFFF707FFFF0F0F0F0FFFFCCCCCCCCFFFFFF707FFFF0F0F0F0FFFFCCCCCCCC
    FFFFFF707FFFF0F0F0F0FFFFCCCCCCCCFFFFFF707FFFF0F0F0F0FFFFCCCCCCCC
    FFFFFF707FFFF0F0F0F0FFFFCCCCCCCCFFFFFF707FFFF0F0F0F0FFFFCCCCCCCC
    FFFFFF707FFFF0F0F0F0FFFFCCCCCCCCFFFFFF707FFFF0000000FFFFCCCCCCCC
    FFFFFF707FFFFF00000FFFFFCCCCCCCCFFFFFF707FFFFFF707FFFFFFCCCCCCCC
    FFFFFF707FFFFFF707FFFFFFCCCCCCCCFFFFFF707FFFFFF707FFFFFFCCCCCCCC
    FFFFF00000FFFFF707FFFFFFCCCCCCCCFFFF0000000FFFF707FFFFFFCCCCCCCC
    FFFF0000000FFFF707FFFFFFCCCCCCCCFFFF0F0F0F0FFFF707FFFFFFCCCCCCCC
    FFFF0F0F0F0FFFF707FFFFFFCCCCCCCCFFFF0F0F0F0FFFF707FFFFFFCCCCCCCC
    FFFF0F0F0F0FFFF707FFFFFFCCCCCCCCFFFF0F0F0F0FFFF707FFFFFFCCCCCCCC
    FFFF0F0F0F0FFFF707FFFFFFCCCCCCCCFFFF0F0F0F0FFFF707FFFFFFCCCCCCCC
    FFFF0F0F0F0FFFFF0FFFFFFFCCCCCCCCFFFFFFFFFFFFFFFFFFFFFFFFCCCCCCCC
    FFFFFFFFFFFFFFFFFFFFFFFFCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC0CCC
    CCCCCCCCCCCCCCCCCCCCCCCCCCC0800000010000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000080000001280000001000000020000000010004000000
    0000C00000000000000000000000000000000000000000000000000080000080
    00000080800080000000800080008080000080808000C0C0C0000000FF0000FF
    000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000CCCCCCCCCCCCCC0CCFF
    FFFFFFFFFFCCCCFFF0FF0F0F0FCCCCFFF0FF0F0F0FCCCCFFF0FF0F0F0FCCCCFF
    F0FF0F0F0FCCCCFFF0FF00000FCCCCFFF0FFF000FFCCCCFF000FFF0FFFCCCCF0
    0000FF0FFFCCCCF0F0F0FF0FFFCCCCF0F0F0FF0FFFCCCCF0F0F0FF0FFFCCCCF0
    F0F0FF0FFFCCCCFFFFFFFFFFFFCC0CCCCCCCCCCCCCC080010000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    00000000000000000000000000000000000080010000}
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object sb: TStatusBar
    Left = 0
    Top = 318
    Width = 775
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object ProgressBar: TProgressBar
    Left = 0
    Top = 306
    Width = 775
    Height = 12
    Align = alBottom
    Step = 1
    TabOrder = 1
  end
  object TBXDock1: TTBXDock
    Left = 0
    Top = 0
    Width = 775
    Height = 65
    object ToolbarTop: TTBXToolbar
      Left = 0
      Top = 0
      BorderStyle = bsNone
      Caption = 'ToolbarTop'
      DockMode = dmCannotFloatOrChangeDocks
      DragHandleStyle = dhNone
      FullSize = True
      Images = TBImageList
      ParentShowHint = False
      ShowHint = True
      ShrinkMode = tbsmWrap
      TabOrder = 0
      object btnDefault: TTBXItem
        Caption = 'Default'
        DisplayMode = nbdmImageAndText
        ImageIndex = 0
        Layout = tbxlGlyphTop
        OnClick = btnLoadBetClick
      end
      object TBXItem4: TTBXItem
        Action = actDownloadAllLines
        DisplayMode = nbdmImageAndText
        Layout = tbxlGlyphTop
      end
      object TBXSeparatorItem2: TTBXSeparatorItem
      end
      object TBXItem5: TTBXItem
        Action = actTeach
        DisplayMode = nbdmImageAndText
        Layout = tbxlGlyphTop
      end
      object TBXVisibilityToggleItem2: TTBXVisibilityToggleItem
        Caption = #1050#1091#1088#1089#1099
        Control = tbValutes
        DisplayMode = nbdmImageAndText
        ImageIndex = 9
        Layout = tbxlGlyphTop
      end
      object TBXVisibilityToggleItem1: TTBXVisibilityToggleItem
        Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
        Control = tbTables
        DisplayMode = nbdmImageAndText
        ImageIndex = 6
        Layout = tbxlGlyphTop
      end
      object TBXItem21: TTBXItem
        Action = actExit
      end
    end
    object tbTables: TTBXToolbar
      Left = 0
      Top = 39
      Caption = 'tbTables'
      DockPos = 0
      DockRow = 1
      TabOrder = 1
      Visible = False
      object TBXItem14: TTBXItem
        Action = actBSports
      end
      object TBXItem13: TTBXItem
        Action = actASports
      end
      object TBXItem16: TTBXItem
        Action = actCountrys
      end
      object TBXItem15: TTBXItem
        Action = actTournirs
      end
      object TBXItem19: TTBXItem
        Action = actAGamers
      end
      object TBXItem18: TTBXItem
        Action = actBGamers
      end
      object TBXItem17: TTBXItem
        Action = actEvents
      end
      object TBXItem12: TTBXItem
        Action = actClearEvents
      end
      object TBXItem20: TTBXItem
        Action = actRenum
      end
    end
    object tbValutes: TTBXToolbar
      Left = 467
      Top = 39
      Caption = 'tbValutes'
      DockPos = 416
      DockRow = 1
      Images = TBImageList
      TabOrder = 2
      Visible = False
      object TBXItem11: TTBXItem
        Action = actKursUSD
      end
      object TBXItem6: TTBXItem
        Action = actKursEUR
      end
      object TBXItem3: TTBXItem
        Action = actKursBLR
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 65
    Width = 775
    Height = 241
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 3
    object DockBottom: TTBXDock
      Left = 0
      Top = 0
      Width = 775
      Height = 95
      object TBXToolbar3: TTBXToolbar
        Left = 0
        Top = 0
        Caption = 'TBXToolbar3'
        DockMode = dmCannotFloatOrChangeDocks
        DockPos = 0
        DragHandleStyle = dhNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Serif'
        Font.Style = []
        FullSize = True
        Images = ilMoney
        ParentFont = False
        ShrinkMode = tbsmWrap
        TabOrder = 0
        object TBXLabelItem2: TTBXLabelItem
          Caption = '1'
          FontSettings.Bold = tsTrue
          Margin = 2
        end
        object eiGamer1RUR: TTBXEditItem
          EditWidth = 90
          ImageIndex = 5
          Alignment = taRightJustify
          ReadOnly = True
          ShowImage = True
        end
        object eiWin1RUR: TTBXEditItem
          ImageIndex = 4
          Alignment = taRightJustify
          ReadOnly = True
          ShowImage = True
        end
        object eiGamer1: TTBXSpinEditItem
          EditWidth = 90
          ImageIndex = 5
          ShowImage = True
          ValueType = evtFloat
          Increment = 0.100000000000000000
          SpaceAfterPrefix = False
          SpaceBeforePostfix = False
          OnValueChange = eiGamer1ValueChange
        end
        object eiWin1: TTBXEditItem
          ImageIndex = 2
          Alignment = taRightJustify
          ReadOnly = True
          ShowImage = True
        end
        object TBXSeparatorItem4: TTBXSeparatorItem
          Size = 10
        end
        object TBXLabelItem3: TTBXLabelItem
          Caption = '2'
          FontSettings.Bold = tsTrue
          Margin = 2
        end
        object eiGamer2RUR: TTBXEditItem
          EditWidth = 90
          ImageIndex = 5
          Alignment = taRightJustify
          ReadOnly = True
          ShowImage = True
        end
        object eiWin2RUR: TTBXEditItem
          ImageIndex = 4
          Alignment = taRightJustify
          ReadOnly = True
          ShowImage = True
        end
        object eiGamer2: TTBXSpinEditItem
          EditWidth = 90
          ImageIndex = 5
          ShowImage = True
          ValueType = evtFloat
          Increment = 0.100000000000000000
          SpaceAfterPrefix = False
          SpaceBeforePostfix = False
          OnValueChange = eiGamer2ValueChange
        end
        object eiWin2: TTBXEditItem
          ImageIndex = 2
          Alignment = taRightJustify
          ReadOnly = True
          ShowImage = True
        end
        object TBXSeparatorItem7: TTBXSeparatorItem
          Size = 10
        end
        object btnSave: TTBXItem
          Action = actSaveSwim
          DisplayMode = nbdmImageAndText
          ImageIndex = 0
        end
      end
      object ToolbarBottom: TTBXToolbar
        Left = 0
        Top = 26
        BorderStyle = bsNone
        Caption = 'ToolbarBottom'
        DockPos = 0
        DockRow = 1
        DragHandleStyle = dhNone
        FullSize = True
        Images = ilState
        ShrinkMode = tbsmWrap
        TabOrder = 1
        object StateDefault: TTBXSubmenuItem
          Caption = 'Default'
          DisplayMode = nbdmImageAndText
          ImageIndex = 0
          Layout = tbxlGlyphTop
          object btnShow: TTBXItem
            Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100
            GroupIndex = 1
            ImageIndex = 9
            OnClick = btnShowStateClick
          end
          object btnLock: TTBXItem
            Tag = 1
            Caption = #1047#1072#1082#1088#1077#1087#1080#1090#1100
            GroupIndex = 1
            ImageIndex = 10
            OnClick = btnShowStateClick
          end
          object btnExclude: TTBXItem
            Tag = 2
            Caption = #1048#1089#1082#1083#1102#1095#1080#1090#1100
            GroupIndex = 1
            ImageIndex = 11
            OnClick = btnShowStateClick
          end
        end
      end
      object tbCalculate: TTBXToolbar
        Left = 0
        Top = 69
        Caption = 'tbCalculate'
        ChevronMoveItems = False
        CloseButton = False
        DockPos = 0
        DockRow = 3
        DragHandleStyle = dhNone
        FullSize = True
        Images = TBImageList
        TabOrder = 2
        object TBXLabelItem1: TTBXLabelItem
          Caption = #1041#1083#1080#1078#1072#1081#1096#1080#1077
        end
        object TBControlItem1: TTBControlItem
          Control = cbHour
        end
        object TBXSeparatorItem1: TTBXSeparatorItem
          Size = 10
        end
        object neBet: TTBXSpinEditItem
          EditWidth = 90
          ImageIndex = 9
          ExtendedAccept = True
          ShowImage = True
          ValueType = evtFloat
          SpaceAfterPrefix = False
          SpaceBeforePostfix = False
          Value = 50.000000000000000000
        end
        object TBXItem9: TTBXItem
          Action = actCalcFromMin
          DisplayMode = nbdmImageAndText
          ImageIndex = 3
          Layout = tbxlGlyphLeft
        end
        object TBXItem8: TTBXItem
          Action = actCalcFromMax
          DisplayMode = nbdmImageAndText
          ImageIndex = 3
          Layout = tbxlGlyphLeft
        end
        object TBXSeparatorItem3: TTBXSeparatorItem
          Size = 10
        end
        object neBetBLR: TTBXSpinEditItem
          EditWidth = 80
          ImageIndex = 10
          ShowImage = True
          Increment = 1000.000000000000000000
          SpaceAfterPrefix = False
          SpaceBeforePostfix = False
          OnValueChange = neBetBLRValueChange
        end
        object neBetUSD: TTBXSpinEditItem
          EditWidth = 80
          ImageIndex = 12
          ShowImage = True
          ValueType = evtFloat
          SpaceAfterPrefix = False
          SpaceBeforePostfix = False
          OnValueChange = neBetUSDValueChange
        end
        object TBXSeparatorItem5: TTBXSeparatorItem
          Size = 10
        end
        object btnAlreadyBet: TTBXItem
          Action = actSetAlreadyBet
          ImageIndex = 5
        end
        object TBXItem2: TTBXItem
          Action = actExcludeBet1
        end
        object TBXItem1: TTBXItem
          Action = actExcludeBet2
        end
        object TBXItem10: TTBXItem
          Action = actChangeK1
        end
        object TBXItem7: TTBXItem
          Action = actChangeK2
        end
        object btnDeficit: TTBXItem
          AutoCheck = True
          ImageIndex = 13
          OnClick = btnDeficitClick
        end
        object cbHour: TDBComboBoxEh
          Left = 59
          Top = 0
          Width = 110
          Height = 21
          EditButton.Action = actHourDec
          EditButton.Style = ebsMinusEh
          EditButtons = <
            item
              Action = actHourInc
              Style = ebsPlusEh
            end>
          Items.Strings = (
            '3 '#1095#1072#1089#1072
            '6 '#1095#1072#1089#1086#1074
            '12 '#1095#1072#1089#1086#1074
            #1089#1077#1075#1086#1076#1085#1103
            #1079#1072#1074#1090#1088#1072
            #1087#1086#1089#1083#1077#1079#1072#1074#1090#1088#1072
            #1074#1089#1077)
          KeyItems.Strings = (
            '3'
            '6'
            '12'
            '24'
            '48'
            '72'
            '744')
          TabOrder = 0
          Visible = True
          OnChange = cbHourChange
        end
      end
    end
    object gridSwim: TDBGridEh
      Left = 0
      Top = 95
      Width = 775
      Height = 96
      Align = alClient
      AutoFitColWidths = True
      Color = clBtnFace
      ColumnDefValues.Title.Alignment = taCenter
      ColumnDefValues.Title.ToolTips = True
      ColumnDefValues.ToolTips = True
      DataSource = dsSwim
      EvenRowColor = clWhite
      Flat = True
      FooterColor = clWindow
      FooterFont.Charset = DEFAULT_CHARSET
      FooterFont.Color = clWindowText
      FooterFont.Height = -11
      FooterFont.Name = 'MS Sans Serif'
      FooterFont.Style = []
      OddRowColor = clSilver
      Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghColumnResize, dghColumnMove]
      ParentShowHint = False
      RowDetailPanel.Color = clBtnFace
      ShowHint = True
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnGetCellParams = gridSwimGetCellParams
      Columns = <
        item
          EditButtons = <>
          FieldName = 'SWIM_ID'
          Footers = <>
          Visible = False
          Width = 30
        end
        item
          AutoFitColWidth = False
          DisplayFormat = 'DD.MM HH:NN'
          EditButtons = <>
          FieldName = 'EVENT_DTM'
          Footers = <>
          Title.Caption = #1044#1072#1090#1072
          Width = 60
        end
        item
          AutoFitColWidth = False
          EditButtons = <>
          FieldName = 'ASPORT_NM'
          Footers = <>
          Title.Caption = #1057#1087#1086#1088#1090
          Width = 97
        end
        item
          EditButtons = <>
          FieldName = 'AGAMER1_NM'
          Footers = <>
          Title.Caption = #1059#1095#1072#1089#1090#1085#1080#1082' 1'
          Width = 150
        end
        item
          EditButtons = <>
          FieldName = 'AGAMER2_NM'
          Footers = <>
          Title.Caption = #1059#1095#1072#1089#1090#1085#1080#1082' 2'
          Width = 150
        end
        item
          AutoFitColWidth = False
          EditButtons = <>
          FieldName = 'BOOKER1_NM'
          Footers = <>
          Title.Caption = #1050#1086#1085#1090#1086#1088#1072' 1'
          Width = 60
        end
        item
          Alignment = taCenter
          AutoFitColWidth = False
          EditButtons = <>
          FieldName = 'BETTYPE1_LBL'
          Footers = <>
          Title.Caption = #1058#1087'1'
          Width = 24
        end
        item
          Alignment = taCenter
          AutoFitColWidth = False
          DisplayFormat = '##0.#'
          EditButtons = <>
          FieldName = 'V1'
          Footers = <>
          Title.Caption = 'T/'#1060' 1'
          Width = 40
        end
        item
          AutoFitColWidth = False
          Color = clSkyBlue
          DisplayFormat = '0.00#'
          EditButtons = <>
          FieldName = 'K1'
          Footers = <>
          Title.Caption = 'K 1'
          Width = 30
        end
        item
          AutoFitColWidth = False
          Color = clMoneyGreen
          DisplayFormat = '0.00'
          EditButtons = <>
          FieldName = 'SV1'
          Footers = <>
          Title.Caption = '$ 1'
          Title.Color = clMoneyGreen
          Width = 50
        end
        item
          AutoFitColWidth = False
          EditButtons = <>
          FieldName = 'BOOKER2_NM'
          Footers = <>
          Title.Caption = #1050#1086#1085#1090#1086#1088#1072' 2'
          Width = 60
        end
        item
          Alignment = taCenter
          AutoFitColWidth = False
          EditButtons = <>
          FieldName = 'BETTYPE2_LBL'
          Footers = <>
          Title.Caption = #1058#1087'2'
          Width = 24
        end
        item
          Alignment = taCenter
          DisplayFormat = '##0.##'
          EditButtons = <>
          FieldName = 'V2'
          Footers = <>
          Title.Caption = #1058'/'#1060'2'
          Width = 40
        end
        item
          AutoFitColWidth = False
          Color = clSkyBlue
          DisplayFormat = '0.00#'
          EditButtons = <>
          FieldName = 'K2'
          Footers = <>
          Title.Caption = 'K 2'
          Width = 30
        end
        item
          AutoFitColWidth = False
          Color = clMoneyGreen
          DisplayFormat = '0.00'
          EditButtons = <>
          FieldName = 'SV2'
          Footers = <>
          Title.Caption = '$ 2'
          Title.Color = clMoneyGreen
          Width = 40
        end
        item
          AutoFitColWidth = False
          Color = clSkyBlue
          DisplayFormat = '0.00%'
          EditButtons = <>
          FieldName = 'K'
          Footers = <>
          Width = 35
        end
        item
          AutoFitColWidth = False
          Color = clMoneyGreen
          DisplayFormat = '0.00'
          EditButtons = <>
          FieldName = 'S'
          Footers = <>
          Title.Caption = '$'
          Title.Color = clMoneyGreen
          Width = 40
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
    object TBXDock2: TTBXDock
      Left = 0
      Top = 191
      Width = 775
      Height = 50
      Position = dpBottom
      object TopWindow: TTBXToolWindow
        Left = 0
        Top = 0
        BorderStyle = bsNone
        Caption = 'Swim'
        CloseButton = False
        ClientAreaHeight = 46
        ClientAreaWidth = 762
        DefaultDock = TBXDock2
        DockableTo = [dpBottom]
        DockPos = 0
        DockRow = 1
        DragHandleStyle = dhDouble
        FloatingMode = fmOnTopOfAllForms
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'S'
        Font.Pitch = fpFixed
        Font.Style = []
        FullSize = True
        HideWhenInactive = False
        ParentFont = False
        TabOrder = 0
        object rePanel: TRichEdit
          Left = 0
          Top = 0
          Width = 762
          Height = 46
          Align = alClient
          Color = clBtnFace
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Pitch = fpFixed
          Font.Style = []
          Lines.Strings = (
            '1'
            '2'
            '3')
          ParentFont = False
          ReadOnly = True
          TabOrder = 0
          WordWrap = False
        end
      end
    end
  end
  object ActionList1: TActionList
    Images = TBImageList
    Left = 8
    Top = 96
    object actExit: TAction
      Caption = #1042#1099#1093#1086#1076
      OnExecute = actExitExecute
    end
    object actDownloadAllLines: TAction
      Category = 'Bookmaker'
      Caption = #1057#1082#1072#1095#1072#1090#1100' '#1074#1089#1077
      ImageIndex = 2
      OnExecute = actDownloadAllLinesExecute
    end
    object actTeach: TAction
      Category = 'Bookmaker'
      Caption = #1054#1073#1091#1095#1077#1085#1080#1077
      ImageIndex = 4
      OnExecute = actTeachExecute
    end
    object actCalcFromMax: TAction
      Caption = #1054#1090' Max'
      ImageIndex = 2
      OnExecute = actCalcFromMaxExecute
    end
    object actCalcFromMin: TAction
      Caption = #1054#1090' Min'
      ImageIndex = 2
      OnExecute = actCalcFromMinExecute
    end
    object actDownloadBetsMarathon: TAction
      Caption = 'Marathon'
      ImageIndex = 1
    end
    object actIgnoreBetsMarathon: TAction
      Caption = 'Marathon'
      ImageIndex = 7
    end
    object actSetAlreadyBet: TAction
      Category = 'BetExclude'
      Caption = #1055#1086#1089#1090#1072#1074#1083#1077#1085#1086
      ImageIndex = 14
      OnExecute = actSetAlreadyBetExecute
    end
    object actExcludeBet1: TAction
      Category = 'BetExclude'
      Caption = '-1'
      OnExecute = actExcludeBet1Execute
    end
    object actExcludeBet2: TAction
      Category = 'BetExclude'
      Caption = '-2'
      OnExecute = actExcludeBet2Execute
    end
    object actHourDec: TAction
      Category = 'BetFilter'
      Caption = 'actHourDec'
      OnExecute = actHourDecExecute
    end
    object actHourInc: TAction
      Category = 'BetFilter'
      Caption = 'actHourInc'
      OnExecute = actHourIncExecute
    end
    object actChangeK1: TAction
      Caption = '= K1'
      OnExecute = actChangeK1Execute
      OnUpdate = actChangeK1Update
    end
    object actChangeK2: TAction
      Caption = '= K2'
      OnExecute = actChangeK2Execute
      OnUpdate = actChangeK2Update
    end
    object actKursUSD: TAction
      Category = #1050#1091#1088#1089#1099
      Caption = 'USD'
      ImageIndex = 12
      OnExecute = actKursUSDExecute
    end
    object actKursEUR: TAction
      Category = #1050#1091#1088#1089#1099
      Caption = 'EUR'
      ImageIndex = 11
      OnExecute = actKursEURExecute
    end
    object actKursBLR: TAction
      Category = #1050#1091#1088#1089#1099
      Caption = 'BLR'
      ImageIndex = 10
      OnExecute = actKursBLRExecute
    end
    object actASports: TAction
      Category = 'Bookmaker'
      Caption = 'ASports'
      OnExecute = actASportsExecute
    end
    object actBSports: TAction
      Category = 'Bookmaker'
      Caption = 'BSports'
      OnExecute = actBSportsExecute
    end
    object actTournirs: TAction
      Category = 'Bookmaker'
      Caption = 'Tournirs'
      OnExecute = actTournirsExecute
    end
    object actCountrys: TAction
      Category = 'Bookmaker'
      Caption = 'Countrys'
      OnExecute = actCountrysExecute
    end
    object actAGamers: TAction
      Category = 'Bookmaker'
      Caption = 'AGamers'
    end
    object actBGamers: TAction
      Category = 'Bookmaker'
      Caption = 'BGamers'
      OnExecute = actBGamersExecute
    end
    object actEvents: TAction
      Category = 'Bookmaker'
      Caption = 'Events'
    end
    object actSaveSwim: TAction
      Caption = 'Save'
      OnExecute = actSaveSwimExecute
    end
    object actClearEvents: TAction
      Category = 'Bookmaker'
      Caption = 'ClearEvents'
      OnExecute = actClearEventsExecute
    end
    object actRenum: TAction
      Category = 'Bookmaker'
      Caption = 'Renum'
      OnExecute = actRenumExecute
    end
  end
  object OpenDialog: TOpenDialog
    Filter = 'Html file (*.htm, * html)|*.html;*.htm'
    Left = 8
    Top = 128
  end
  object TBImageList: TTBImageList
    Left = 40
    Top = 128
    Bitmap = {
      494C01010E001300040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000004000000001002000000000000040
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000080000000
      8000000080000000800000008000000080000000800000008000000080000000
      8000000080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000800000008000000080000000
      8000000080000000800000008000000080000000800000008000000080000000
      80000000800000008000000080000000800000000000000080000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C0C0C000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C0C0C000000080000000FF000000FF000000
      FF000000FF000000800000008000000080000000800000008000000080000000
      8000000080000000FF0000008000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000080000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF0000008000000080000000FF000000FF000000
      FF000000FF000000FF0000008000000080000000800000008000000080000000
      8000000080000000FF0000008000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C0C0C000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C0C0C000000080000000FF000000FF000000
      FF000000FF000000FF000000FF00000080000000800000008000000080000000
      8000000080000000FF0000008000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000080000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF0000008000000080000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000800000008000000080000000
      8000000080000000FF0000008000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C0C0C000000080000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF0000008000000080000000
      8000000080000000FF0000008000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080000000FFFFFF00FF000000FFFF
      FF00FF000000FFFFFF00FF000000FF0000000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF0000008000000080000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF00000080000000
      8000000080000000FF0000008000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080000000FF000000FFFFFF00FF00
      0000FFFFFF00FF000000FFFFFF00FF000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C0C0C00000000000000080000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      80000000FF000000800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080000000FFFFFF00FF000000FFFF
      FF00FF000000FFFFFF00FF000000FF0000000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF0000008000000000000000FF00000080000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF00000080000000800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080000000FF000000FFFFFF00FF00
      0000FFFFFF00FF000000FFFFFF00FF000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C0C0C00000000000000080000000FF000000
      FF000000FF000000800000008000000080000000800000008000000080000000
      8000000000000000800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080000000FFFFFF00FF000000FFFF
      FF00FF000000FFFFFF00FF000000FF0000000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF0000008000000000000000FF000000FF000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000080000000800000008000
      000080000000800000008000000080000000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C00000000000000000000000FF000000
      FF000000FF000000800000008000000080000000800000008000000080000000
      8000000080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00000000000000
      FF00000000000000FF0000008000000000000000800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000008000000080000000800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000000000000000000000000
      0000FFFFFF0000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000800000008000000080000000
      8000000080000000800000008000000080000000800000008000000080000000
      800000008000000080000000800000008000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C0008000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000080000000800000007F7F7F0000000000000000000000
      000000000000000000000000000000000000000000007F7F7F00FFFFFF000000
      000000000000000000000000000000000000000080000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF0000008000C0C0C000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C0C0C00080000000FF000000FF000000FF00
      0000FF000000FF000000FF00000000FFFF0000FFFF00FF000000FF000000FF00
      0000FF000000FF000000FF000000800000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000000000FFFFFF000000
      0000FFFFFF00FFFFFF000000000000000000000080000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF0000008000C0C0C000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C0C0C00080000000FF000000FF000000FF00
      000000FFFF0000FFFF00FF00000000FFFF0000FFFF00FF00000000FFFF0000FF
      FF00FF000000FF000000FF000000800000000000000000FFFF007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F0000FFFF0000FFFF0000000000FFFFFF000000
      0000FFFFFF00000000000000000000000000000080000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF0000008000C0C0C000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C0C0C00080000000FF000000FF000000FF00
      000000FFFF0000FFFF00FF000000FF000000FF000000FF00000000FFFF0000FF
      FF00FF000000FF000000FF000000800000000000000000FFFF007F7F7F00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000FFFF0000000000FFFFFF000000
      0000000000000000000000000000000000008000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      000080000000800000008000000080000000000080000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000800080000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000800000000000000000FFFF007F7F7F00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000FFFF0000000000000000000000
      00000000FF0000000000000000000000000080000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF00000080000000000080000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000800080000000FF000000FF00000000FF
      FF0000FFFF00FF000000FF000000FF000000FF000000FF000000FF00000000FF
      FF0000FFFF00FF000000FF000000800000000000000000FFFF007F7F7F00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000FFFF0000000000000000000000
      FF000000FF000000FF00000000000000000080000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF00000080000000000080000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000800080000000FF000000FF00000000FF
      FF0000FFFF00FF000000FF000000FF000000FF000000FF000000FF00000000FF
      FF0000FFFF00FF000000FF000000800000000000000000FFFF007F7F7F00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000FFFF00000000000000FF000000
      FF000000FF000000FF000000FF00000000008000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      000080000000800000008000000080000000000080000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000800080000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000800000000000000000FFFF007F7F7F00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000FFFF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF00C0C0C000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C0C0C000C0C0C000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C0C0C00080000000FF000000FF000000FF00
      000000FFFF0000FFFF00FF000000FF000000FF000000FF00000000FFFF0000FF
      FF00FF000000FF000000FF000000800000000000000000FFFF007F7F7F00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000FFFF0000000000000000000000
      FF000000FF000000FF000000000000000000C0C0C000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C0C0C000C0C0C000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C0C0C00080000000FF000000FF000000FF00
      000000FFFF0000FFFF00FF00000000FFFF0000FFFF00FF00000000FFFF0000FF
      FF00FF000000FF000000FF00000080000000000000007F7F7F00000000000000
      00007F7F7F007F7F7F0000000000000000007F7F7F0000000000000000000000
      FF000000FF000000FF000000000000000000C0C0C000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C0C0C000C0C0C000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C0C0C00080000000FF000000FF000000FF00
      0000FF000000FF000000FF00000000FFFF0000FFFF00FF000000FF000000FF00
      0000FF000000FF000000FF000000800000000000000000FFFF007F7F7F007F7F
      7F0000000000000000007F7F7F007F7F7F0000FFFF0000000000000000000000
      FF000000FF000000FF000000000000000000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C0008000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000080000000800000000000000000FFFF0000FFFF007F7F
      7F0000000000000000007F7F7F0000FFFF0000FFFF000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007F7F7F0000000000000000000000
      000000000000000000000000000000000000000000007F7F7F00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000005E657A000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF007F7F7F00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000FF00000000000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000003FA5FF001673D0005E65
      7A007F585000896D5D00B2776D00B2776D00B2776D00B2776D00B2776D00B277
      6D00B2776D00B2776D00B2776D00B2776D000000000000000000000000000000
      000000000000000000000000000000FFFF007F7F7F00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000FFFF00000000000000000000000000000000000000
      000000000000FF000000FF00000000000000FFFFFF0000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000035A4FF001677
      DC005E657A0086665300897B6000CEB28900EBC79200EEC68A00EDC18100EBC1
      7F00EBC18000EDC28000F2CA8100B8806F000000000000000000000000000000
      000000000000000000000000000000FFFF007F7F7F00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000FFFF00000000000000000000000000000000000000
      0000FF0000000000000000000000FFFFFF0000000000FFFFFF0000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000035A3
      FF001375E0005E657A00866454008E7D6400BCA37D00C0A17700BC9A6E00C7A3
      6E00DDB57900E7BC7F00EEC58000B77F6F000000000000000000000000000000
      000000000000000000000000000000FFFF007F7F7F00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000FFFF0000000000000000000000000000000000FF00
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF00000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000DCA0
      89003FAFFF001377E0005E657A00725E4E00896D5B0081665300816551007B65
      4800AC8C5E00D9B17700EDC48000B87F6F000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F007F7F
      7F0000000000000000007F7F7F000000000000000000FF000000FF0000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF0000000000FF00000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000DCA0
      8900D9E5E2003AABFF004473A3009C786600E0C9AA00E5D5B200E2CCAF009375
      66006B563D00AB8B5E00E1BB7900B77E6E0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      00007F7F7F007F7F7F0000FFFF0000000000FF0000000000000000000000FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000FFFFFF0000000000FF0000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000DCA0
      8900FFFCEF00DDD4C700B8998600F6D8A600FBEEC100F8F7CA00FFFFDA00F8EE
      EA00937666007E664900CCA96F00B77D6D0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      00007F7F7F0000FFFF0000FFFF00000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF0000000000FF000000000000007F7F7F000000FF000000
      FF0000000000000000000000FF000000FF000000FF0000000000000000000000
      000000000000000000000000000000000000000000000000000000000000DCA0
      8900FFFFFF00D8C6C100D1AA8100FEE1A300FAE0AB00F7E6BC00F3EFC500FFFF
      DD00D5BBA40080655000C2A37000B67D700000000000FFFFFF00000000000000
      0000FFFFFF00000000000000000000000000FFFFFF0000000000000000000000
      00000000FF0000000000000000007F7F7F0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00000000007F7F7F000000FF00000000000000
      00000000000000000000000000000000FF000000FF0000000000000000000000
      000000000000000000000000000000000000000000000000000000000000DCA0
      8900FFFFFF00DCCFCC00D0A77F00FFE29E00F6D79F00FADEAA00F7E6BC00FAFA
      CB00DCC7A90083695400C9AB7D00B87F740000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF000000FF00000000000000
      000000000000000000000000000000000000000000000000000000000000DCA0
      8900FFFFFF00E2D7D700CEAB8700FFEDB100FBDA9A00F4D79E00FAE0AA00FCEE
      C000C7AC9300A3866E00E0C49300B781770000000000FFFFFF00000000000000
      00000000000000000000FFFFFF0000000000FFFFFF00000000000000FF000000
      FF000000FF000000FF000000FF0000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF00000000000000
      000000000000000000000000000000000000000000000000000000000000DCA0
      8900FFFFFF00FFFFFF00D7C4C000D5BDA500FFF6B600FEE39F00FFE1A300DDBB
      9600AA8F7E00D5BF9E00D8C09A009775700000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      000000000000000000000000000000000000000000000000000000000000DCA0
      8900FFFFFF00FFFFFF00FFFFFF00D8C6C100C09F8900C49E8000C0997E00BCA1
      9300D4C5B000C4B4A300A49A8C008B6E6E0000000000FFFFFF00000000000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F000000
      FF0000000000000000000000000000000000000000000000000000000000DCA0
      8900FFFFFF00FFFFFF00FFFFFF00FEFEFE00F2EFF000EDE6E300EDE3DD00DAC4
      B700AA6F6000AA6F6000AA6F6000AA6F600000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF000000000000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007F7F
      7F000000FF00000000000000000000000000000000000000000000000000DCA0
      8900FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFE00FFFF
      FE00AA6F6000FAB55600E28F3B000000000000000000FFFFFF0000000000BFBF
      BF00FFFFFF0000000000FFFFFF000000000000000000000000007F7F7F000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF0000000000000000000000000000000000DCA0
      8900FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FE00AA6F6000E2A06300000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000FF000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000DCA0
      8900DCA08900DCA08900DCA08900DCA08900DCA08900DCA08900DCA08900DCA0
      8900AA6F60000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000000000000000000000000000000000000000BFBF
      BF0000000000BFBFBF0000000000BFBFBF000000FF000000FF000000FF00BFBF
      BF000000000000000000000000000000000000000000000000000000FF000000
      FF000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000FF000000FF0000FFFF000000FF000000FF000000FF000000
      FF000000FF000000FF000000000000000000000000000000000000000000BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF0000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000FF0000FFFF0000FFFF0000FFFF000000FF000000FF000000
      FF000000FF000000FF000000000000000000000000000000000000000000BFBF
      BF0000000000BFBFBF0000000000BFBFBF0000000000BFBFBF0000000000BFBF
      BF0000000000000000000000000000000000000000000000FF00000000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      00000000FF000000FF00000000000000000000000000000000000000000000FF
      FF00BFBFBF0000FFFF00BFBFBF0000FFFF00BFBFBF0000FFFF00BFBFBF0000FF
      FF0000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF0000FFFF0000FFFF000000FF0000FFFF0000FFFF000000FF000000
      FF000000FF000000FF000000000000000000000000000000000000000000BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00000000000000000000000000000000000000FF000000FF00000000000000
      00000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000FF000000FF00000000000000000000000000FFFFFF000000
      000000FFFF00BFBFBF0000FFFF00BFBFBF0000FFFF00BFBFBF0000FFFF00BFBF
      BF0000FFFF00000000000000000000000000000000000000FF000000FF000000
      FF0000FFFF0000FFFF000000FF00FFFFFF000000FF0000FFFF0000FFFF000000
      FF000000FF000000FF000000000000000000000000000000000000000000BFBF
      BF0000000000BFBFBF0000000000BFBFBF0000000000BFBFBF0000000000BFBF
      BF00000000000000000000000000000000000000FF000000FF00000000000000
      0000000000000000FF000000FF000000FF000000000000000000000000000000
      0000000000000000FF000000FF0000000000000000000000000000FFFF00FFFF
      FF000000000000FFFF00BFBFBF0000FFFF00BFBFBF0000FFFF00BFBFBF0000FF
      FF00BFBFBF0000FFFF000000000000000000000000000000FF000000FF000000
      FF000000FF000000FF00FFFFFF00FFFFFF00FFFFFF000000FF000000FF000000
      FF000000FF000000FF000000000000000000000000000000000000000000BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00000000000000000000000000000000000000FF000000FF00000000000000
      000000000000000000000000FF000000FF000000FF0000000000000000000000
      0000000000000000FF000000FF00000000000000000000000000FFFFFF0000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF00FFFFFF00FFFFFF000000FF00FFFFFF00FFFFFF000000FF000000
      FF000000FF000000FF000000000000000000000000000000000000000000BFBF
      BF0000000000BFBFBF0000000000BFBFBF0000000000BFBFBF0000000000BFBF
      BF00000000000000000000000000000000000000FF000000FF00000000000000
      00000000000000000000000000000000FF000000FF000000FF00000000000000
      0000000000000000FF000000FF0000000000000000000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF00FFFFFF00FFFFFF000000FF00FFFFFF000000FF00FFFFFF00FFFFFF000000
      FF000000FF000000FF000000000000000000000000000000000000000000BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00000000000000000000000000000000000000FF000000FF00000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      0000000000000000FF000000FF00000000000000000000000000FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000FF00FFFFFF00FFFFFF00FFFFFF000000FF000000FF000000
      FF000000FF000000FF000000000000000000000000000000000000000000BFBF
      BF0000000000000000000000000000000000000000000000000000000000BFBF
      BF0000000000000000000000000000000000000000000000FF000000FF000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF00000000000000FF000000000000000000000000000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000FF000000
      FF000000FF000000FF000000000000000000000000000000000000000000BFBF
      BF00000000000000000000000000FFFF000000000000FFFF000000000000BFBF
      BF0000000000000000000000000000000000000000000000FF000000FF000000
      FF000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF00000000000000000000000000000000000000000000FF
      FF00FFFFFF0000FFFF00FFFFFF00000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      FF000000FF000000FF000000000000000000000000000000000000000000BFBF
      BF0000000000000000000000000000000000000000000000000000000000BFBF
      BF000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      FF000000FF0000000000000000000000000000000000000000007F7F7F000000
      00000000000000000000000000007F7F7F000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000000000000000000000000000000000000000BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000080000000FF00000080000000
      FF00000080000000FF00000080000000FF00000080000000FF00000080000000
      FF00000080000000FF000000800000000000000000000000000000000000BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F00000000000000000000000000424D3E000000000000003E000000
      2800000040000000400000000100010000000000000200000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFF00000000FFFFC00700000000
      0000800300000000000000010000000000000001000000000000000100000000
      0000000100000000000000010000000000000001000000000000800300000000
      00008003000000000000800B00000000000093FB000000000000C00700000000
      FFFFA97F00000000FFFFFC7F00000000FC00FFFFFFFFFFFFFC00FFFFFFFFFFFF
      FC00000000000000000000000000000000010000000000000003000000000000
      0007000000000000000700000000000000230000000000000001000000000000
      0000000000000000002300000000000000230000000000000023000000000000
      0007FFFFFFFFFFFF003FFFFFFFFFFFFFFFFFFFFFDFFFFC00FE3FFFFF8000FC00
      F81FF9FFC000FC00F40FF0FFE000FC00E007F0FFE00000008003E07FE0000000
      4001C07FE00000000000843FE000000000001E3FE00000238001FE1FE0000001
      C003FF1FE0000000E00FFF8FE0000023F07FFFC7E0000063F8FFFFE3E00100C3
      FFFFFFF8E0030107FFFFFFFFE00703FFFFFFFFFFFFFFC007F83FFFFF0001C007
      E00FFFFF0001C007CFC7FFFF0001C00787E3C00F0001C007A3F380070001C007
      31F980030001C00738F980010001C0073C7980010001C0073E39800F0001C007
      3F19800F0001C0079F8B801F0001C0078FC3C0FF0001C007C7E7C0FF0001C007
      E00FFFFF0001C007F83FFFFFFFFFC00700000000000000000000000000000000
      000000000000}
  end
  object dsSwim: TDataSource
    AutoEdit = False
    DataSet = tblSwims
    Left = 72
    Top = 96
  end
  object Version: TgsFileVersionInfo
    Filename = 'D:\swim2\Swim2.exe'
    Left = 104
    Top = 127
  end
  object ilState: TImageList
    Height = 20
    Width = 20
    Left = 136
    Top = 128
    Bitmap = {
      494C010110001300040014001400FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      000000000000360000002800000050000000640000000100200000000000007D
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF00000080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF00000080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF000000FF000000FF000000
      FF000000FF000000800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF000000FF000000FF000000
      FF000000FF000000800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF000000FF000000FF000000
      FF000000FF000000800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF000000FF000000FF000000
      FF000000FF000000800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000800000008000000080000000
      8000000080000000800000008000000080000000800000008000000080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF00000080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF00000080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000080000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF00000080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF00000080000000000000000000000000000000000000000000000000000000
      00000000000000000000000080000000FF000000FF000000FF000000FF000000
      8000000080000000800000008000000080000000800000008000000080000000
      FF00000080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF00000080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF00000080000000000000000000000000000000000000000000000000000000
      00000000000000000000000080000000FF000000FF000000FF000000FF000000
      FF00000080000000800000008000000080000000800000008000000080000000
      FF00000080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF00000080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF00000080000000000000000000000000000000000000000000000000000000
      00000000000000000000000080000000FF000000FF000000FF000000FF000000
      FF000000FF000000800000008000000080000000800000008000000080000000
      FF00000080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF00000080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF00000080000000000000000000000000000000000000000000000000000000
      00000000000000000000000080000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF0000008000000080000000800000008000000080000000
      FF00000080000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF000080800000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF000080800000000000000000000000000000000000000000000000
      00000000000000000000000080000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF00000080000000800000008000000080000000
      FF00000080000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF000080800000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF000080800000000000000000000000000000000000000000000000
      00000000000000000000000080000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000800000008000000080000000
      FF00000080000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF000000FF00
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF0000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000080000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF00000080000000FF000000
      8000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF000000FF00
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF0000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF00000080000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF00000080000000
      8000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF000000FF00
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF0000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000080000000FF000000FF000000FF000000
      8000000080000000800000008000000080000000800000008000000000000000
      8000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF000000FF00
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF0000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF00000000000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      8000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF000000FF00
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF0000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      8000000080000000800000008000000080000000800000008000000080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF000000FF000000FF000000FF00
      0000FF0000008000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF00000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000008080800000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF00000000000000FF00000000000000
      FF00000080000000000000008000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF000000FF000000FF000000FF00
      0000FF0000008000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF00000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000080000000800000008000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF000000FF00
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF0000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF0000008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C00080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C00080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C0C0C00080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0C0C0008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C0C0C00080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C0C0C00080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0C0C0008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C0C0C00080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080008080800080808000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000080000000800000008000000080
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080008080800080808000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080008080800080808000808080008080
      8000808080008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000C0C0C000C0C0C000C0C0C000C0C0C0008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000080000000FF000000FF000000FF000000FF
      0000008000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      80000000FF000000FF000000FF000000FF008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000008080800000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C00080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000080000000FF000000FF000000FF000000FF000000FF
      000000FF00000080000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      FF000000FF000000FF000000FF000000FF000000FF0080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000080000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF000000FF000000800000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000808080000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF00808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000080000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF000000FF000000800000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000808080000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF00808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000C0C0C000FFFF
      FF00C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000080000000FF0000FFFFFF0000FF000000FF000000FF000000FF
      000000FF000000FF000000800000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000808080000000FF00FFFF
      FF000000FF000000FF000000FF000000FF000000FF000000FF00808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000C0C0C000FFFF
      FF00C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000080000000FF0000FFFFFF0000FF000000FF000000FF000000FF
      000000FF000000FF000000800000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000808080000000FF00FFFF
      FF000000FF000000FF000000FF000000FF000000FF000000FF00808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000C0C0
      C000FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C00080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000080000000FF0000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000FF00000080000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000FF0080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000C0C0C000C0C0C000C0C0C000C0C0C0008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000080000000FF000000FF000000FF000000FF
      0000008000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      80000000FF000000FF000000FF000000FF008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080008080800080808000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000080000000800000008000000080
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080008080800080808000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000FFFF0000FFFF0000FF000080808000808080008080
      800000FF000000FFFF0000FFFF00FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000FFFF0000FF
      FF0000FF00000000FF000000FF000000800000FF000000FFFF0000FFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF0000FFFF0000FFFF0000FF00008080800000000000000000000000
      00008080800000FF000000FFFF0000FFFF00FFFFFF0000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF0000FFFF0000FF
      00000000FF000000FF000000FF000000FF000000800000FF000000FFFF0000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000000000008080800000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000FFFF0000FFFF0000FF0000808080000000000000000000000000000000
      0000000000008080800000FF000000FFFF0000FFFF00FFFFFF00000000000000
      0000000000000000000000000000FFFFFF0000FFFF0000FFFF0000FF00000000
      FF000000FF000000FF000000FF000000FF000000FF000000800000FF000000FF
      FF0000FFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000000000000000000000000000000000000000000080808000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000FFFF0000FFFF0000FF0000808080000000000000000000000000000000
      0000000000008080800000FF000000FFFF0000FFFF00FFFFFF00000000000000
      0000000000000000000000000000FFFFFF0000FFFF0000FFFF0000FF00000000
      FF000000FF000000FF000000FF000000FF000000FF000000800000FF000000FF
      FF0000FFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF0000FFFF0000FFFF0000FF00008080800000000000000000000000
      00008080800000FF000000FFFF0000FFFF00FFFFFF0000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF0000FFFF0000FF
      00000000FF000000FF000000FF000000FF000000800000FF000000FFFF0000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF0000FFFF0000FFFF0000FF00008080800000000000000000000000
      00008080800000FF000000FFFF0000FFFF00FFFFFF0000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF0000FFFF0000FF
      00000000FF000000FF000000FF000000FF000000800000FF000000FFFF0000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF0000FFFF0000FFFF0000FF00008080800000000000000000000000
      00008080800000FF000000FFFF0000FFFF00FFFFFF0000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF0000FFFF0000FF
      00000000FF000000FF000000FF000000FF000000800000FF000000FFFF0000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF0000FFFF0000FFFF0000FF00008080800000000000000000000000
      00008080800000FF000000FFFF0000FFFF00FFFFFF0000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF0000FFFF0000FF
      00000000FF000000FF000000FF000000FF000000800000FF000000FFFF0000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF0000FFFF0000FFFF0000FF00008080800000000000000000000000
      00008080800000FF000000FFFF0000FFFF00FFFFFF0000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF0000FFFF0000FF
      00000000FF000000FF000000FF000000FF000000800000FF000000FFFF0000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000000000008080800000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000FFFF0000FFFF0000FF000000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF000080800000FF000000FFFF0000FFFF00FFFFFF00000000000000
      0000000000000000000000000000FFFFFF0000FFFF0000FFFF0000FF000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000080800000FF000000FF
      FF0000FFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000808080008080800080808000808080008080
      8000808080008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000808080008080800080808000808080008080800080808000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000FFFF0000FFFF0000FF000000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF000080800000FF000000FFFF0000FFFF00FFFFFF00000000000000
      0000000000000000000000000000FFFFFF0000FFFF0000FFFF0000FF000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000080800000FF000000FF
      FF0000FFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF0000FFFF0000FFFF0000FF0000FF000000FF000000FF000000FF00
      00008000000000FF000000FFFF0000FFFF00FFFFFF0000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF0000FFFF0000FF
      0000808080000000000000000000000000008080800000FF000000FFFF0000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF0000FFFF0000FFFF0000FF0000FF000000FF000000FF000000FF00
      00008000000000FF000000FFFF0000FFFF00FFFFFF0000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF0000FFFF0000FF
      0000808080000000000000000000000000008080800000FF000000FFFF0000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF0000FFFF0000FFFF0000FF0000FF000000FF000000FF000000FF00
      00008000000000FF000000FFFF0000FFFF00FFFFFF0000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF0000FFFF0000FF
      0000808080000000000000000000000000008080800000FF000000FFFF0000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF0000FFFF0000FFFF0000FF0000FF000000FF000000FF000000FF00
      00008000000000FF000000FFFF0000FFFF00FFFFFF0000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF0000FFFF0000FF
      0000808080000000000000000000000000008080800000FF000000FFFF0000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF0000FFFF0000FFFF0000FF0000FF000000FF000000FF000000FF00
      00008000000000FF000000FFFF0000FFFF00FFFFFF0000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF0000FFFF0000FF
      0000808080000000000000000000000000008080800000FF000000FFFF0000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000000000008080800000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000FFFF0000FFFF0000FF0000FF000000FF000000FF000000FF000000FF00
      0000FF0000008000000000FF000000FFFF0000FFFF00FFFFFF00000000000000
      0000000000000000000000000000FFFFFF0000FFFF0000FFFF0000FF00008080
      800000000000000000000000000000000000000000008080800000FF000000FF
      FF0000FFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000000000000000000000000000000000000000000080808000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000FFFF0000FFFF0000FF0000FF000000FF000000FF000000FF000000FF00
      0000FF0000008000000000FF000000FFFF0000FFFF00FFFFFF00000000000000
      0000000000000000000000000000FFFFFF0000FFFF0000FFFF0000FF00008080
      800000000000000000000000000000000000000000008080800000FF000000FF
      FF0000FFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF0000FFFF0000FFFF0000FF0000FF000000FF000000FF000000FF00
      00008000000000FF000000FFFF0000FFFF00FFFFFF0000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF0000FFFF0000FF
      0000808080000000000000000000000000008080800000FF000000FFFF0000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000FFFF0000FFFF0000FF0000FF000000FF0000008000
      000000FF000000FFFF0000FFFF00FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000FFFF0000FF
      FF0000FF000080808000808080008080800000FF000000FFFF0000FFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000FFFF0000FF
      FF0000FF00000000FF000000FF000000800000FF000000FFFF0000FFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF00000080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF00000080000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF0000FFFF0000FF
      00000000FF000000FF000000FF000000FF000000800000FF000000FFFF0000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF000000FF000000FF000000
      FF000000FF000000800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF000000FF000000FF000000
      FF000000FF000000800000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF0000FFFF0000FFFF0000FF00000000
      FF000000FF000000FF000000FF000000FF000000FF000000800000FF000000FF
      FF0000FFFF00FFFFFF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF000000FF000000FF000000
      FF000000FF000000800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF000000FF000000FF000000
      FF000000FF000000800000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF0000FFFF0000FFFF0000FF00000000
      FF000000FF000000FF000000FF000000FF000000FF000000800000FF000000FF
      FF0000FFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF00000080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF00000080000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF0000FFFF0000FF
      00000000FF000000FF000000FF000000FF000000800000FF000000FFFF0000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF00000080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF00000080000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF0000FFFF0000FF
      00000000FF000000FF000000FF000000FF000000800000FF000000FFFF0000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF00000080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF00000080000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF0000FFFF0000FF
      00000000FF000000FF000000FF000000FF000000800000FF000000FFFF0000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF00000080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF00000080000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF0000FFFF0000FF
      00000000FF000000FF000000FF000000FF000000800000FF000000FFFF0000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF00000080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF00000080000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF0000FFFF0000FF
      00000000FF000000FF000000FF000000FF000000800000FF000000FFFF0000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF000080800000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF000080800000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF0000FFFF0000FFFF0000FF000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000080800000FF000000FF
      FF0000FFFF00FFFFFF0000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF000080800000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF000080800000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF0000FFFF0000FFFF0000FF000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000080800000FF000000FF
      FF0000FFFF00FFFFFF0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF000000FF00
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF0000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF0000FFFF0000FF
      0000FF000000FF000000FF000000FF0000008000000000FF000000FFFF0000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF000000FF00
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF0000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF0000FFFF0000FF
      0000FF000000FF000000FF000000FF0000008000000000FF000000FFFF0000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF000000FF00
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF0000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF0000FFFF0000FF
      0000FF000000FF000000FF000000FF0000008000000000FF000000FFFF0000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF000000FF00
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF0000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF0000FFFF0000FF
      0000FF000000FF000000FF000000FF0000008000000000FF000000FFFF0000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF000000FF00
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF0000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF0000FFFF0000FF
      0000FF000000FF000000FF000000FF0000008000000000FF000000FFFF0000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF000000FF000000FF000000FF00
      0000FF0000008000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF00000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF0000FFFF0000FFFF0000FF0000FF00
      0000FF000000FF000000FF000000FF000000FF0000008000000000FF000000FF
      FF0000FFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF000000FF000000FF000000FF00
      0000FF0000008000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF00000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF0000FFFF0000FFFF0000FF0000FF00
      0000FF000000FF000000FF000000FF000000FF0000008000000000FF000000FF
      FF0000FFFF00FFFFFF0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF000000FF00
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF0000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF0000FFFF0000FF
      0000FF000000FF000000FF000000FF0000008000000000FF000000FFFF0000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF0000008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000FFFF0000FF
      FF0000FF0000FF000000FF0000008000000000FF000000FFFF0000FFFF00FFFF
      FF0000000000000000000000000000000000424D3E000000000000003E000000
      2800000050000000640000000100010000000000B00400000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF8FFFF8FFFF8FFFFFFF0000FF07FFF77FFF07FFFFFF0000FE03FFEFBFFE03FF
      FFFF0000FE03FFEFBFFE03FF001F0000FF07FFF77FFF07FE000F0000FF07FFF7
      7FFF07FC00070000FF07FFF77FFF07FC00070000FF07FFF77FFF07FC00070000
      FF07FFF77FFF07FC00070000FE03FFE03FFE03FC00070000FE03FFE03FFE03FC
      00070000FF07FFF07FFF77FE000F0000FF07FFF07FFF77FE000F0000FF07FFF0
      7FFF77FE002F0000FF07FFF07FFF77FE4FEF0000FF07FFF07FFF77FF001F0000
      FE03FFE03FFEFBFEA5FF0000FE03FFE03FFEFBFFF1FF0000FF07FFF07FFF77FF
      FFFF0000FF8FFFF8FFFF8FFFFFFF0000FF8FFFFFFFFFFFFFFFFF0000FF77FFFF
      9FFFF9FFFF9F0000FEFBFFFF0FFFF0FFFF0F0000FEFBFFFF0FFFF0FFFF0F0000
      FF77FFFF1FFFF1FFFF1F0000FF77FFFE1FFFE1FFFE1F0000FF77FFFE1FFFE1FF
      FE1F0000FF77FFF03FFF03FFF03F0000FF77FFC03FFC03FFC03F0000FE03FF80
      1FF801FF801F0000FEFBFF801FF801FF801F0000FF77FF000FF000FF000F0000
      FF77FF000FF000FF000F0000FF77FF000FF000FF000F0000FF77FF000FF000FF
      000F0000FF77FF801FF801FF801F0000FEFBFF801FF801FF801F0000FEFBFFC0
      3FFC03FFC03F0000FF77FFF0FFFF0FFFF0FF0000FF8FFFFFFFFFFFFFFFFF0000
      F800FF800FFF8FFFF8FF0000F0707F0007FF77FFF77F0000E0F83E0003FEFBFF
      EFBF0000E0F83E0003FEFBFFEFBF0000F0707F0007FF77FFF77F0000F0707F00
      07FF77FFF77F0000F0707F0007FF77FFF77F0000F0707F0007FF77FFF77F0000
      F0707F0007FF77FFF77F0000E0003E0003FE03FFE03F0000E0003E0003FEFBFF
      EFBF0000F0007F0707FF77FFF77F0000F0007F0707FF77FFF77F0000F0007F07
      07FF77FFF77F0000F0007F0707FF77FFF77F0000F0007F0707FF77FFF77F0000
      E0003E0F83FEFBFFEFBF0000E0003E0F83FEFBFFEFBF0000F0007F0707FF77FF
      F77F0000F800FF800FFF8FFFF8FF0000FF8FFFF8FFFF8FFF800F0000FF07FFF7
      7FFF07FF00070000FE03FFEFBFFE03FE00030000FE03FFEFBFFE03FE00030000
      FF07FFF77FFF07FF00070000FF07FFF77FFF07FF00070000FF07FFF77FFF07FF
      00070000FF07FFF77FFF07FF00070000FF07FFF77FFF07FF00070000FE03FFE0
      3FFE03FE00030000FE03FFE03FFE03FE00030000FF07FFF07FFF77FF00070000
      FF07FFF07FFF77FF00070000FF07FFF07FFF77FF00070000FF07FFF07FFF77FF
      00070000FF07FFF07FFF77FF00070000FE03FFE03FFEFBFE00030000FE03FFE0
      3FFEFBFE00030000FF07FFF07FFF77FF00070000FF8FFFF8FFFF8FFF800F0000
      00000000000000000000000000000000000000000000}
  end
  object ilMoney: TTBImageList
    Left = 168
    Top = 127
    Bitmap = {
      494C010109000E00040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000800000008000000080000000
      8000000080000000800000008000000080000000800000008000000080000000
      8000000080000000800000008000000080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C0C0C000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000080000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF00000080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C0C0C000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000080000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF00000080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080000000FFFFFF00FF000000FFFF
      FF00FF000000FFFFFF00FF000000FF0000000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF00000080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080000000FF000000FFFFFF00FF00
      0000FFFFFF00FF000000FFFFFF00FF000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080000000FFFFFF00FF000000FFFF
      FF00FF000000FFFFFF00FF000000FF0000000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF00000080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080000000FF000000FFFFFF00FF00
      0000FFFFFF00FF000000FFFFFF00FF000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080000000FFFFFF00FF000000FFFF
      FF00FF000000FFFFFF00FF000000FF0000000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF00000080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000080000000800000008000
      000080000000800000008000000080000000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000080
      0000008000000080000000800000008000000080000000800000008000000080
      0000008000000080000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000080000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF000000FF000000800000000000000000800000008000000080000000
      8000000080000000800000008000000080000000800000008000000080000000
      800000008000000080000000800000008000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C0008000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      000080000000800000008000000080000000000000000080000000FF00000000
      FF000000FF000000FF0000008000000080000000800000008000000080000000
      8000000080000000800000FF000000800000000080000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF0000008000C0C0C000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C0C0C00080000000FF000000FF000000FF00
      0000FF000000FF000000FF00000000FFFF0000FFFF00FF000000FF000000FF00
      0000FF000000FF000000FF00000080000000000000000080000000FF00000000
      FF000000FF000000FF000000FF00000080000000800000008000000080000000
      8000000080000000800000FF000000800000000080000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF0000008000C0C0C000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C0C0C00080000000FF000000FF000000FF00
      000000FFFF0000FFFF00FF00000000FFFF0000FFFF00FF00000000FFFF0000FF
      FF00FF000000FF000000FF00000080000000000000000080000000FF0000FF00
      0000FF000000FF000000FF000000FF0000008000000080000000800000008000
      0000800000008000000000FF000000800000000080000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF0000008000C0C0C000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C0C0C00080000000FF000000FF000000FF00
      000000FFFF0000FFFF00FF000000FF000000FF000000FF00000000FFFF0000FF
      FF00FF000000FF000000FF00000080000000000000000080000000FF0000FF00
      0000FF000000FF000000FF000000FF000000FF00000080000000800000008000
      0000800000008000000000FF0000008000008000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      000080000000800000008000000080000000000080000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000800080000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF00000080000000000000000080000000FF00000000
      0000000000000000000000000000000000000000000000000000C0C0C000C0C0
      C000C0C0C000C0C0C00000FF00000080000080000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF00000080000000000080000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000800080000000FF000000FF00000000FF
      FF0000FFFF00FF000000FF000000FF000000FF000000FF000000FF00000000FF
      FF0000FFFF00FF000000FF00000080000000000000000080000000FF00000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000C0C0C000C0C0C00000FF00000080000080000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF00000080000000000080000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000800080000000FF000000FF00000000FF
      FF0000FFFF00FF000000FF000000FF000000FF000000FF000000FF00000000FF
      FF0000FFFF00FF000000FF0000008000000000000000000000000080000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      00000080000000FF000000800000000000008000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      000080000000800000008000000080000000000080000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000800080000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF00000080000000000000000000000000FF00000080
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF0000008000000080000000000000C0C0C000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C0C0C000C0C0C000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C0C0C00080000000FF000000FF000000FF00
      000000FFFF0000FFFF00FF000000FF000000FF000000FF00000000FFFF0000FF
      FF00FF000000FF000000FF0000008000000000000000000000000080000000FF
      000000FF000000FF000000800000008000000080000000800000008000000080
      000000800000000000000080000000000000C0C0C000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C0C0C000C0C0C000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C0C0C00080000000FF000000FF000000FF00
      000000FFFF0000FFFF00FF00000000FFFF0000FFFF00FF00000000FFFF0000FF
      FF00FF000000FF000000FF00000080000000000000000000000000FF000000FF
      00000000000000FF000000FF0000000000000000000000000000000000000000
      000000000000000000000080000000000000C0C0C000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C0C0C000C0C0C000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C0C0C00080000000FF000000FF000000FF00
      0000FF000000FF000000FF00000000FFFF0000FFFF00FF000000FF000000FF00
      0000FF000000FF000000FF0000008000000000000000000000000000000000FF
      000000FF000000FF000000800000008000000080000000800000008000000080
      000000800000008000000000000000000000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C0008000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      000080000000800000008000000080000000000000000000000000FF00000000
      000000FF00000000000000FF0000008000000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000008000000080000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F00000000000000000000000000000000000000000000000000000080000000
      8000000080000000800000008000000080000000800000008000000080000000
      8000000080000000000000000000000000000000000000000000008000000080
      0000008000000080000000800000008000000080000000800000008000000080
      0000008000000000000000000000000000000000000000000000008080000080
      8000008080000080800000808000008080000080800000808000008080000080
      8000008080000000000000000000000000000000000000000000000000000000
      0000000000007F7F7F00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF000000000000000000000000000000000000000000000080000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF00000080000000000000000000000000000080000000FF000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF0000008000000000000000000000000000000080800000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF000080800000000000000000000000000000000000000000000000
      0000000000007F7F7F00BFBFBF000000000000000000BFBFBF00BFBFBF00BFBF
      BF0000000000000000000000000000000000000080000000FF000000FF000000
      FF000000FF000000800000008000000080000000800000008000000080000000
      8000000080000000FF0000008000000000000080000000FF000000FF000000FF
      000000FF00000080000000800000008000000080000000800000008000000080
      00000080000000FF000000800000000000000080800000FFFF0000FFFF0000FF
      FF0000FFFF000080800000808000008080000080800000808000008080000080
      80000080800000FFFF0000808000000000000000000000000000000000000000
      0000000000007F7F7F00BFBFBF000000000000000000BFBFBF00BFBFBF00BFBF
      BF0000000000000000000000000000000000000080000000FF000000FF000000
      FF000000FF000000FF0000008000000080000000800000008000000080000000
      8000000080000000FF0000008000000000000080000000FF000000FF000000FF
      000000FF000000FF000000800000008000000080000000800000008000000080
      00000080000000FF000000800000000000000080800000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000808000008080000080800000808000008080000080
      80000080800000FFFF0000808000000000000000000000000000000000000000
      0000000000007F7F7F00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF0000000000000000000000000000000000000080000000FF000000FF000000
      FF000000FF000000FF000000FF00000080000000800000008000000080000000
      8000000080000000FF0000008000000000000080000000FF000000FF000000FF
      000000FF000000FF000000FF0000008000000080000000800000008000000080
      00000080000000FF000000800000000000000080800000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00008080000080800000808000008080000080
      80000080800000FFFF0000808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000080000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000800000008000000080000000
      8000000080000000FF0000008000000000000080000000FF000000FF000000FF
      000000FF000000FF000000FF000000FF00000080000000800000008000000080
      00000080000000FF000000800000000000000080800000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF000080800000808000008080000080
      80000080800000FFFF0000808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000080000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF0000008000000080000000
      8000000080000000FF0000008000000000000080000000FF000000FF000000FF
      000000FF000000FF000000FF000000FF000000FF000000800000008000000080
      00000080000000FF000000800000000000000080800000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000808000008080000080
      80000080800000FFFF000080800000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000000080000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF00000080000000
      8000000080000000FF0000008000000000000080000000FF000000FF000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF0000008000000080
      00000080000000FF000000800000000000000080800000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00008080000080
      80000080800000FFFF000080800000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000000080000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      80000000FF00000080000000000000000000000000000080000000FF000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF00000080
      000000FF0000008000000000000000000000000000000080800000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000080
      800000FFFF00008080000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000000000000000FF00000080000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF00000080000000800000000000000000000000000000FF00000080000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      0000008000000080000000000000000000000000000000FFFF000080800000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000808000008080000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000000080000000FF000000
      FF000000FF000000800000008000000080000000800000008000000080000000
      800000000000000080000000000000000000000000000080000000FF000000FF
      000000FF00000080000000800000008000000080000000800000008000000080
      000000000000008000000000000000000000000000000080800000FFFF0000FF
      FF0000FFFF000080800000808000008080000080800000808000008080000080
      800000000000008080000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000000000000000FF000000FF000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000800000000000000000000000000000FF000000FF00000000
      000000FF000000FF000000000000000000000000000000000000000000000000
      0000000000000080000000000000000000000000000000FFFF0000FFFF00FFFF
      FF0000FFFF0000FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      000000000000008080000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000007F7F7F00000000000000000000000000000000000000FF000000
      FF000000FF000000800000008000000080000000800000008000000080000000
      800000008000000000000000000000000000000000000000000000FF000000FF
      000000FF00000080000000800000008000000080000000800000008000000080
      000000800000000000000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF000080800000808000008080000080800000808000008080000080
      800000808000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000000000000000FF00000000000000
      FF00000000000000FF0000008000000000000000800000000000000000000000
      0000000000000000000000000000000000000000000000FF00000000000000FF
      00000000000000FF000000800000000000000080000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF000000000000FF
      FF000000000000FFFF0000808000FFFFFF000080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000008000000080000000800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000008000000080000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000808000008080000080800000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF00FFFF000000000000FFFF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FFFF000000000000FFFF000000000000FFFFFFFFFFFFFFFFE003FFFFFFFFFFFF
      C001000000000000800000000000000080000000000000008000000000000000
      80000000000000009FC00000000000009FE0000000000000C001000000000000
      C001000000000000C005000000000000C9FD000000000000E003000000000000
      D4BFFFFFFFFFFFFFFE3FFFFFFFFFFFFFFFFFFFFFFFFFFFFF8003C007C007C007
      0001800380038003000100010001000100010001000100010001000100010001
      0001000100010001000100010001000100010001000100010001800380038003
      00018003800380030001800B800B800B000193FB93FB801B0001C007C007C007
      0001A97FA97FA87F8003FC7FFC7FFC7F00000000000000000000000000000000
      000000000000}
  end
  object GvWebScript: TGvWebScript
    StatusBar = sb
    ProxyPort = 0
    Left = 232
    Top = 95
  end
  object IdAntiFreeze1: TIdAntiFreeze
    Left = 200
    Top = 127
  end
  object tblSwims: TpFIBDataSet
    UpdateSQL.Strings = (
      'UPDATE SWIMS'
      'SET '
      '    SWIM_ID = :SWIM_ID,'
      '    EVENT_ID = :EVENT_ID,'
      '    BET1_ID = :BET1_ID,'
      '    BOOKER1_ID = :BOOKER1_ID,'
      '    BETTYPE1_ID = :BETTYPE1_ID,'
      '    V1 = :V1,'
      '    K1 = :K1,'
      '    S1 = :S1,'
      '    SV1 = :SV1,'
      '    VALUTE1_SGN = :VALUTE1_SGN,'
      '    VALUTE1_KURS = :VALUTE1_KURS,'
      '    MIN1_MNY = :MIN1_MNY,'
      '    MAX1_MNY = :MAX1_MNY,'
      '    ONEBET1_FLG = :ONEBET1_FLG,'
      '    BET2_ID = :BET2_ID,'
      '    BOOKER2_ID = :BOOKER2_ID,'
      '    BETTYPE2_ID = :BETTYPE2_ID,'
      '    V2 = :V2,'
      '    K2 = :K2,'
      '    S2 = :S2,'
      '    SV2 = :SV2,'
      '    VALUTE2_SGN = :VALUTE2_SGN,'
      '    VALUTE2_KURS = :VALUTE2_KURS,'
      '    MIN2_MNY = :MIN2_MNY,'
      '    MAX2_MNY = :MAX2_MNY,'
      '    ONEBET2_FLG = :ONEBET2_FLG,'
      '    K = :K,'
      '    S = :S'
      'WHERE SWIM_ID = :OLD_SWIM_ID'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      '    SWIMS'
      'WHERE SWIM_ID = :OLD_SWIM_ID'
      '    '
      '        ')
    InsertSQL.Strings = (
      'INSERT INTO SWIMS('
      '    SWIM_ID,'
      '    EVENT_ID,'
      '    BET1_ID,'
      '    BOOKER1_ID,'
      '    BETTYPE1_ID,'
      '    V1,'
      '    K1,'
      '    S1,'
      '    SV1,'
      '    VALUTE1_SGN,'
      '    VALUTE1_KURS,'
      '    MIN1_MNY,'
      '    MAX1_MNY,'
      '    ONEBET1_FLG,'
      '    BET2_ID,'
      '    BOOKER2_ID,'
      '    BETTYPE2_ID,'
      '    V2,'
      '    K2,'
      '    S2,'
      '    SV2,'
      '    VALUTE2_SGN,'
      '    VALUTE2_KURS,'
      '    MIN2_MNY,'
      '    MAX2_MNY,'
      '    ONEBET2_FLG,'
      '    K,'
      '    S'
      ')'
      'VALUES('
      '    :SWIM_ID,'
      '    :EVENT_ID,'
      '    :BET1_ID,'
      '    :BOOKER1_ID,'
      '    :BETTYPE1_ID,'
      '    :V1,'
      '    :K1,'
      '    :S1,'
      '    :SV1,'
      '    :VALUTE1_SGN,'
      '    :VALUTE1_KURS,'
      '    :MIN1_MNY,'
      '    :MAX1_MNY,'
      '    :ONEBET1_FLG,'
      '    :BET2_ID,'
      '    :BOOKER2_ID,'
      '    :BETTYPE2_ID,'
      '    :V2,'
      '    :K2,'
      '    :S2,'
      '    :SV2,'
      '    :VALUTE2_SGN,'
      '    :VALUTE2_KURS,'
      '    :MIN2_MNY,'
      '    :MAX2_MNY,'
      '    :ONEBET2_FLG,'
      '    :K,'
      '    :S)')
    RefreshSQL.Strings = (
      'SELECT'
      '    SWIM_ID,'
      '    EVENT_ID,'
      '    BET1_ID,'
      '    BOOKER1_ID,'
      '    BOOKER1_NM,'
      '    BETTYPE1_ID,'
      '    BETTYPE1_LBL,'
      '    V1,'
      '    K1,'
      '    S1,'
      '    SV1,'
      '    VALUTE1_SGN,'
      '    VALUTE1_KURS,'
      '    MIN1_MNY,'
      '    MAX1_MNY,'
      '    ONEBET1_FLG,'
      '    BET2_ID,'
      '    BOOKER2_ID,'
      '    BOOKER2_NM,'
      '    BETTYPE2_ID,'
      '    BETTYPE2_LBL,'
      '    V2,'
      '    K2,'
      '    S2,'
      '    SV2,'
      '    VALUTE2_SGN,'
      '    VALUTE2_KURS,'
      '    MIN2_MNY,'
      '    MAX2_MNY,'
      '    ONEBET2_FLG,'
      '    K,'
      '    S,'
      '    ASPORT_ID,'
      '    ASPORT_NM,'
      '    ATOURNIR_ID,'
      '    ATOURNIR_NM,'
      '    EVENT_DTM,'
      '    AGAMER1_ID,'
      '    AGAMER1_NM,'
      '    GAMER1_NM,'
      '    AGAMER2_ID,'
      '    AGAMER2_NM,'
      '    GAMER2_NM'
      'FROM'
      '    VE_SWIMS'
      'WHERE SWIM_ID = :OLD_SWIM_ID'
      ' ')
    SelectSQL.Strings = (
      'SELECT'
      '    SWIM_ID,'
      '    EVENT_ID,'
      '    BET1_ID,'
      '    BOOKER1_ID,'
      '    BOOKER1_NM,'
      '    BETTYPE1_ID,'
      '    BETTYPE1_LBL,'
      '    V1,'
      '    K1,'
      '    S1,'
      '    SV1,'
      '    VALUTE1_SGN,'
      '    VALUTE1_KURS,'
      '    MIN1_MNY,'
      '    MAX1_MNY,'
      '    ONEBET1_FLG,'
      '    BET2_ID,'
      '    BOOKER2_ID,'
      '    BOOKER2_NM,'
      '    BETTYPE2_ID,'
      '    BETTYPE2_LBL,'
      '    V2,'
      '    K2,'
      '    S2,'
      '    SV2,'
      '    VALUTE2_SGN,'
      '    VALUTE2_KURS,'
      '    MIN2_MNY,'
      '    MAX2_MNY,'
      '    ONEBET2_FLG,'
      '    K,'
      '    S,'
      '    ASPORT_ID,'
      '    ASPORT_NM,'
      '    ATOURNIR_ID,'
      '    ATOURNIR_NM,'
      '    EVENT_DTM,'
      '    AGAMER1_ID,'
      '    AGAMER1_NM,'
      '    GAMER1_NM,'
      '    AGAMER2_ID,'
      '    AGAMER2_NM,'
      '    GAMER2_NM'
      'FROM'
      '    VE_SWIMS'
      'WHERE EVENT_DTM > :EVENT_DTM_FROM'
      '  AND EVENT_DTM <= :EVENT_DTM_TO'
      'ORDER BY '
      '    K DESC,'
      '    EVENT_DTM '
      ' ')
    AfterScroll = tblSwimsAfterScroll
    Transaction = dmSwim.ReadTran
    Database = dmSwim.Database
    UpdateTransaction = dmSwim.UpdateTran
    AutoCommit = True
    OnFilterRecord = tblSwimsFilterRecord
    DataSet_ID = 15
    Description = 'SWIMS'
    Left = 104
    Top = 97
    poApplyRepositary = True
  end
  object TimerRefresh: TTimer
    Interval = 60000
    OnTimer = TimerRefreshTimer
    Left = 136
    Top = 99
  end
end
