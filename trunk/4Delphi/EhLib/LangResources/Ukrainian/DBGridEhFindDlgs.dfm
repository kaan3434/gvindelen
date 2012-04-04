object DBGridEhFindDlg: TDBGridEhFindDlg
  Left = 273
  Top = 305
  BorderStyle = bsDialog
  Caption = #1047#1085#1072#1081#1090#1080' '#1090#1077#1082#1089#1090
  ClientHeight = 139
  ClientWidth = 466
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 9
    Top = 11
    Width = 37
    Height = 12
    Caption = '&'#1047#1088#1072#1079#1086#1082':'
  end
  object Label2: TLabel
    Left = 9
    Top = 32
    Width = 45
    Height = 12
    Caption = '&'#1055#1086#1096#1091#1082' '#1074':'
  end
  object cbMatchType: TLabel
    Left = 9
    Top = 54
    Width = 63
    Height = 12
    Caption = '&'#1057#1087#1110#1074#1087#1072#1076#1072#1085#1085#1103':'
  end
  object Label3: TLabel
    Left = 9
    Top = 76
    Width = 37
    Height = 12
    Caption = #1055#1086'&'#1096#1091#1082':'
  end
  object Label4: TLabel
    Left = 9
    Top = 118
    Width = 78
    Height = 12
    Caption = #1047#1085#1072#1081#1090#1080' '#1074' '#1076#1077'&'#1088#1077#1074#1110':'
  end
  object cbText: TDBComboBoxEh
    Left = 81
    Top = 8
    Width = 292
    Height = 20
    DropDownBox.Rows = 17
    DropDownBox.Sizable = True
    EditButtons = <>
    TabOrder = 0
    Text = 'cbText'
    Visible = True
    OnChange = cbTextChange
  end
  object bFind: TButton
    Left = 381
    Top = 8
    Width = 76
    Height = 22
    Caption = #1047#1085#1072#1081#1090#1080' &'#1076#1072#1083#1110
    TabOrder = 6
    OnClick = bFindClick
  end
  object bCancel: TButton
    Left = 381
    Top = 34
    Width = 76
    Height = 20
    Cancel = True
    Caption = #1047#1072#1082#1088#1080#1090#1080
    ModalResult = 2
    TabOrder = 7
    OnClick = bCancelClick
  end
  object cbFindIn: TDBComboBoxEh
    Left = 81
    Top = 30
    Width = 177
    Height = 20
    DropDownBox.Rows = 17
    DropDownBox.Sizable = True
    EditButtons = <>
    TabOrder = 1
    Text = 'cbFindIn'
    Visible = True
    OnChange = cbFindInChange
  end
  object cbMatchinType: TDBComboBoxEh
    Left = 81
    Top = 51
    Width = 133
    Height = 20
    EditButtons = <>
    Items.Strings = (
      #1047' '#1073#1091#1076#1100'-'#1103#1082#1086#1111' '#1095#1072#1089#1090#1080#1085#1080' '#1087#1086#1083#1103
      #1042#1089#1100#1086#1075#1086' '#1087#1086#1083#1103
      #1047' '#1087#1086#1095#1072#1090#1082#1091' '#1087#1086#1083#1103)
    KeyItems.Strings = (
      #1047' '#1073#1091#1076#1100'-'#1103#1082#1086#1111' '#1095#1072#1089#1090#1080#1085#1080' '#1087#1086#1083#1103
      #1042#1089#1100#1086#1075#1086' '#1087#1086#1083#1103
      #1047' '#1087#1086#1095#1072#1090#1082#1091' '#1087#1086#1083#1103)
    TabOrder = 2
    Text = #1047' '#1073#1091#1076#1100'-'#1103#1082#1086#1111' '#1095#1072#1089#1090#1080#1085#1080' '#1087#1086#1083#1103
    Visible = True
  end
  object cbFindDirection: TDBComboBoxEh
    Left = 81
    Top = 73
    Width = 133
    Height = 20
    EditButtons = <>
    Items.Strings = (
      #1042#1074#1077#1088#1093
      #1042#1085#1080#1079
      #1059#1089#1110)
    KeyItems.Strings = (
      #1042#1074#1077#1088#1093
      #1042#1085#1080#1079
      #1059#1089#1110)
    TabOrder = 3
    Text = #1059#1089#1110
    Visible = True
    OnChange = cbTextChange
  end
  object cbCharCase: TDBCheckBoxEh
    Left = 81
    Top = 97
    Width = 133
    Height = 13
    Caption = #1042#1088#1072#1093#1086#1074#1091#1102#1095#1080' &'#1088#1077#1075#1110#1089#1090#1088
    TabOrder = 4
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object cbUseFormat: TDBCheckBoxEh
    Left = 240
    Top = 97
    Width = 133
    Height = 13
    Caption = #1042#1088#1072#1093#1086#1074#1091#1102#1095#1080' &'#1092#1086#1088#1084#1072#1090
    Checked = True
    State = cbChecked
    TabOrder = 5
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object dbcTreeFindRange: TDBComboBoxEh
    Left = 81
    Top = 114
    Width = 134
    Height = 20
    EditButtons = <>
    Items.Strings = (
      #1042' '#1091#1089#1110#1093' '#1074#1091#1079#1083#1072#1093
      #1042' '#1088#1086#1079#1082#1088#1080#1090#1080#1093' '#1074#1091#1079#1083#1072#1093
      #1042' '#1087#1086#1090#1086#1095#1085#1086#1084#1091' '#1088#1110#1074#1085#1110
      #1042' '#1087#1086#1090#1086#1095#1085#1086#1084#1091' '#1074#1091#1079#1083#1110)
    KeyItems.Strings = (
      #1042' '#1091#1089#1110#1093' '#1074#1091#1079#1083#1072#1093
      #1042' '#1088#1086#1079#1082#1088#1080#1090#1080#1093' '#1074#1091#1079#1083#1072#1093
      #1042' '#1087#1086#1090#1086#1095#1085#1086#1084#1091' '#1088#1110#1074#1085#1110
      #1042' '#1087#1086#1090#1086#1095#1085#1086#1084#1091' '#1074#1091#1079#1083#1110)
    TabOrder = 8
    Text = #1042' '#1091#1089#1110#1093' '#1074#1091#1079#1083#1072#1093
    Visible = True
    OnChange = cbTextChange
  end
end
