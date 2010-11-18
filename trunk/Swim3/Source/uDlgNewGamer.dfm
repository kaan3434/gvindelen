object DlgNewGamer: TDlgNewGamer
  Left = 431
  Top = 175
  Width = 458
  Height = 573
  Caption = 'DlgNewGamer'
  Color = clBtnFace
  Constraints.MaxWidth = 458
  Constraints.MinHeight = 418
  Constraints.MinWidth = 458
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
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
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDeactivate = FormDeactivate
  PixelsPerInch = 96
  TextHeight = 13
  object lAbstractSport: TLabel
    Left = 8
    Top = 216
    Width = 112
    Height = 13
    Caption = #1040#1073#1089#1086#1083#1102#1090#1085#1099#1081' '#1091#1095#1072#1089#1090#1085#1080#1082
    Layout = tlCenter
  end
  object Label2: TLabel
    Left = 8
    Top = 263
    Width = 41
    Height = 21
    AutoSize = False
    Caption = #1057#1090#1088#1072#1085#1072
    Layout = tlCenter
  end
  object Label3: TLabel
    Left = 184
    Top = 263
    Width = 25
    Height = 21
    AutoSize = False
    Caption = #1055#1086#1083
    Layout = tlCenter
  end
  object Label1: TLabel
    Left = 8
    Top = 152
    Width = 31
    Height = 13
    Caption = #1048#1075#1088#1086#1082
  end
  object btnCancel: TButton
    Left = 320
    Top = 40
    Width = 123
    Height = 25
    Action = actSkipGamer
    TabOrder = 0
  end
  object btnOk: TButton
    Left = 320
    Top = 8
    Width = 123
    Height = 25
    Action = actAddGamer
    Default = True
    TabOrder = 1
  end
  object Button1: TButton
    Left = 320
    Top = 72
    Width = 123
    Height = 25
    Action = actSkipSport
    TabOrder = 2
  end
  object Button2: TButton
    Left = 320
    Top = 104
    Width = 121
    Height = 25
    Action = actSkipAll
    TabOrder = 3
  end
  object memTournirName: TMemo
    Left = 8
    Top = 48
    Width = 217
    Height = 65
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 4
  end
  object btnDelEvent: TButton
    Left = 320
    Top = 136
    Width = 121
    Height = 25
    Action = actDeleteEvent
    TabOrder = 5
  end
  object eBookmakerName: TLabeledEdit
    Left = 8
    Top = 24
    Width = 153
    Height = 21
    Color = clMoneyGreen
    EditLabel.Width = 50
    EditLabel.Height = 13
    EditLabel.Caption = #1041#1091#1082#1084#1077#1082#1077#1088
    TabOrder = 6
  end
  object eSportName: TLabeledEdit
    Left = 168
    Top = 24
    Width = 145
    Height = 21
    Color = clMoneyGreen
    EditLabel.Width = 30
    EditLabel.Height = 13
    EditLabel.Caption = #1057#1087#1086#1088#1090
    TabOrder = 7
  end
  object btnTournirAdd: TButton
    Left = 232
    Top = 48
    Width = 81
    Height = 33
    Action = actTournirAdd
    TabOrder = 8
    WordWrap = True
  end
  object eEventDate: TLabeledEdit
    Left = 8
    Top = 128
    Width = 97
    Height = 21
    Color = clMoneyGreen
    EditLabel.Width = 26
    EditLabel.Height = 13
    EditLabel.Caption = #1044#1072#1090#1072
    TabOrder = 9
  end
  object eOpponent: TLabeledEdit
    Left = 112
    Top = 128
    Width = 201
    Height = 21
    Color = clMoneyGreen
    EditLabel.Width = 49
    EditLabel.Height = 13
    EditLabel.Caption = #1054#1087#1087#1086#1085#1077#1085#1090
    TabOrder = 10
  end
  object Button3: TButton
    Left = 232
    Top = 88
    Width = 81
    Height = 33
    Action = actTournirIgnore
    TabOrder = 11
    WordWrap = True
  end
  object cbAbsGamer: TDBComboBoxEh
    Left = 8
    Top = 231
    Width = 433
    Height = 21
    DropDownBox.Rows = 15
    DropDownBox.Sizable = True
    EditButtons = <
      item
        Action = actAbsGamerAdd
        Style = ebsPlusEh
      end
      item
        Action = actAbsGamerDel
        Style = ebsMinusEh
      end
      item
        Action = actAbsGamerClear
        Style = ebsGlyphEh
      end>
    TabOrder = 12
    Visible = True
    OnChange = cbAbsGamerChange
  end
  object cbCountry: TDBComboBoxEh
    Left = 48
    Top = 263
    Width = 129
    Height = 21
    DropDownBox.Rows = 10
    DropDownBox.Sizable = True
    DropDownBox.Width = 200
    EditButtons = <
      item
        Style = ebsGlyphEh
        OnClick = cbCountryEditButtons0Click
      end>
    TabOrder = 13
    Visible = True
    OnExit = cbCountryExit
    OnKeyDown = cbCountryKeyDown
  end
  object cbSex: TDBComboBoxEh
    Left = 208
    Top = 263
    Width = 57
    Height = 21
    Alignment = taCenter
    DropDownBox.Sizable = True
    EditButtons = <
      item
        Style = ebsGlyphEh
        OnClick = cbSexEditButtons0Click
      end>
    Items.Strings = (
      'M'
      'W')
    KeyItems.Strings = (
      '1'
      '0')
    TabOrder = 14
    Visible = True
  end
  object btnCopy1: TButton
    Left = 272
    Top = 263
    Width = 41
    Height = 21
    Action = actCopyAbsGamer1
    TabOrder = 15
  end
  object btnCopy2: TButton
    Left = 320
    Top = 263
    Width = 43
    Height = 21
    Action = actCopyAbsGamer2
    TabOrder = 16
  end
  object cbFoundedGamer: TDBComboBoxEh
    Left = 40
    Top = 192
    Width = 401
    Height = 21
    Color = clGradientActiveCaption
    EditButtons = <
      item
        Action = actAbsGamerFoundedSet
        Style = ebsEllipsisEh
      end>
    TabOrder = 17
    Visible = True
    OnChange = cbFoundedGamerChange
  end
  object eFoundedCount: TEdit
    Left = 8
    Top = 192
    Width = 25
    Height = 21
    Color = clGradientActiveCaption
    ReadOnly = True
    TabOrder = 18
  end
  object eGamerName: TDBComboBoxEh
    Left = 8
    Top = 168
    Width = 433
    Height = 21
    Color = clGradientActiveCaption
    EditButton.Visible = False
    EditButtons = <>
    TabOrder = 19
    Text = 'eGamerName'
    Visible = True
  end
  object pcGamers: TPageControl
    Left = 0
    Top = 328
    Width = 450
    Height = 218
    ActivePage = tsOpponents
    Align = alBottom
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 20
    object tsGamerNames: TTabSheet
      Caption = #1042#1072#1088#1080#1072#1085#1090#1099' '#1085#1072#1079#1074#1072#1085#1080#1081
      object gridTournirs: TDBGridEh
        Left = 0
        Top = 0
        Width = 442
        Height = 195
        Align = alClient
        AutoFitColWidths = True
        Color = clInactiveBorder
        DataSource = dmSwim.dsAbsGamer
        Flat = False
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'MS Sans Serif'
        FooterFont.Style = []
        PopupMenu = PopupMenu1
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        Columns = <
          item
            EditButtons = <>
            FieldName = 'Gamer_Name'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = #1048#1075#1088#1086#1082
            Width = 276
          end
          item
            EditButtons = <>
            FieldName = 'Bookmaker_Name'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = #1041#1091#1082#1084#1077#1082#1077#1088
          end
          item
            DisplayFormat = 'DD.MM.YYYY'
            EditButtons = <>
            FieldName = 'LastUse_Dt'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = 'Last Used'
          end>
      end
    end
    object tsGamerTournirs: TTabSheet
      Caption = #1059#1095#1072#1089#1090#1080#1077' '#1074' '#1090#1091#1088#1085#1080#1088#1072#1093
      ImageIndex = 1
      object gridGamer: TDBGridEh
        Left = 0
        Top = 0
        Width = 442
        Height = 195
        Align = alClient
        AutoFitColWidths = True
        Color = clInactiveBorder
        DataSource = dmSwim.dsTourirs
        Flat = False
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
        Columns = <
          item
            EditButtons = <>
            FieldName = 'Tournir_Name'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = #1058#1091#1088#1085#1080#1088
            Width = 233
          end
          item
            EditButtons = <>
            FieldName = 'Bookmaker_Name'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = #1041#1091#1082#1084#1077#1082#1077#1088
          end
          item
            DisplayFormat = 'DD.MM.YYYY'
            EditButtons = <>
            FieldName = 'LastUse_Dt'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = 'Last Use'
          end
          item
            EditButtons = <>
            FieldName = 'Country_Alpha3'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = #1057#1090#1088#1072#1085#1072
            Width = 40
          end>
      end
    end
    object tsOpponents: TTabSheet
      Caption = #1054#1087#1087#1086#1085#1077#1085#1090#1099
      ImageIndex = 2
      object gridOpponents: TDBGridEh
        Left = 0
        Top = 0
        Width = 442
        Height = 190
        Align = alClient
        Color = clBtnFace
        DataSource = dmSwim.dsOpponents
        EvenRowColor = clBtnFace
        Flat = False
        FooterColor = clBtnFace
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'MS Sans Serif'
        FooterFont.Style = []
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        Columns = <
          item
            AutoFitColWidth = False
            EditButtons = <>
            FieldName = 'Event_Dt'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = #1044#1072#1090#1072
            Width = 100
          end
          item
            EditButtons = <>
            FieldName = 'AbsOpponent_Name'
            Footers = <>
            Title.Caption = #1048#1084#1103' '#1054#1087#1087#1086#1085#1077#1085#1090#1072
            Width = 250
          end
          item
            EditButtons = <>
            FieldName = 'Bookmaker_Name'
            Footers = <>
          end>
      end
    end
  end
  object cbTemporary: TCheckBox
    Left = 368
    Top = 264
    Width = 73
    Height = 17
    Caption = #1042#1088#1077#1084#1077#1085#1085#1086
    TabOrder = 21
  end
  object lcbAGamers: TDBLookupComboboxEh
    Left = 8
    Top = 296
    Width = 433
    Height = 21
    EditButtons = <>
    TabOrder = 22
    Visible = True
  end
  object ActionList: TActionList
    Left = 16
    Top = 56
    object actAddGamer: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      OnExecute = actAddGamerExecute
      OnUpdate = actAddGamerUpdate
    end
    object actSkipGamer: TAction
      Caption = #1057#1083#1077#1076#1091#1102#1097#1080#1081' '#1059#1095#1072#1089#1090#1085#1080#1082
      OnExecute = actSkipGamerExecute
    end
    object actAbsGamerAdd: TAction
      Category = 'AbsGamer_Combo'
      Caption = 'Add'
      OnExecute = actAbsGamerAddExecute
    end
    object actAbsGamerDel: TAction
      Category = 'AbsGamer_Combo'
      Caption = 'actAbsGamerDel'
      OnExecute = actAbsGamerDelExecute
    end
    object actSkipSport: TAction
      Caption = #1057#1083#1077#1076#1091#1102#1097#1080#1081' '#1057#1087#1086#1088#1090
      OnExecute = actSkipSportExecute
    end
    object actSkipAll: TAction
      Caption = #1055#1088#1077#1082#1088#1072#1090#1080#1090#1100' '#1086#1073#1091#1095#1077#1085#1080#1077
      OnExecute = actSkipAllExecute
    end
    object actCountryAdd: TAction
      Caption = 'actCountryAdd'
    end
    object actCopyAbsGamer1: TAction
      Caption = 'Copy 1'
    end
    object actCopyAbsGamer2: TAction
      Caption = 'Copy 2'
    end
    object actDeleteEvent: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1086#1073#1099#1090#1080#1077
      OnExecute = actDeleteEventExecute
    end
    object actTournirAdd: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1090#1091#1088#1085#1080#1088
      OnExecute = actTournirAddExecute
    end
    object actTournirIgnore: TAction
      Caption = #1055#1088#1086#1087#1091#1089#1082#1072#1090#1100' '#1090#1091#1088#1085#1080#1088
      OnExecute = actTournirIgnoreExecute
    end
    object actDeleteGamer: TAction
      Caption = #1059#1076#1072#1080#1090#1100' '#1080#1075#1088#1086#1082#1072
      OnExecute = actDeleteGamerExecute
      OnUpdate = actDeleteGamerUpdate
    end
    object actAbsGamerFoundedSet: TAction
      Caption = 'actAbsGamerFoundedSet'
      OnExecute = actAbsGamerFoundedSetExecute
    end
    object actAbsGamerClear: TAction
      Category = 'AbsGamer_Combo'
      Caption = 'actAbsGamerClear'
      OnExecute = actAbsGamerClearExecute
    end
    object actFindGamer: TAction
      Caption = 'FindGamer'
      OnExecute = actFindGamerExecute
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 32
    Top = 128
    object N1: TMenuItem
      Action = actDeleteGamer
    end
  end
end
