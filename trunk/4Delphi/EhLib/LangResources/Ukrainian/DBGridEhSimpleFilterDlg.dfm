object DBGridEhSimpleFilterDialog: TDBGridEhSimpleFilterDialog
  Left = 734
  Top = 312
  BorderStyle = bsDialog
  Caption = #1050#1086#1088#1080#1089#1090#1091#1074#1072#1094#1100#1082#1080#1081' '#1092#1110#1083#1100#1090#1088
  ClientHeight = 218
  ClientWidth = 410
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 6
    Top = 7
    Width = 229
    Height = 13
    Caption = #1042#1110#1076#1086#1073#1088#1072#1078#1072#1090#1080' '#1090#1110#1083#1100#1082#1080' '#1090#1110' '#1079#1072#1087#1080#1089#1080', '#1079#1085#1072#1095#1077#1085#1085#1103' '#1103#1082#1080#1093':'
  end
  object Bevel1: TBevel
    Left = 4
    Top = 27
    Width = 399
    Height = 8
    Shape = bsTopLine
  end
  object Label2: TLabel
    Left = 6
    Top = 131
    Width = 217
    Height = 13
    Caption = #1057#1080#1084#1074#1086#1083' '#39'_'#39' '#1086#1079#1085#1072#1095#1072#1108' '#1086#1076#1080#1085' '#1073#1091#1076#1100'-'#1103#1082#1080#1081' '#1089#1080#1084#1074#1086#1083
  end
  object Label3: TLabel
    Left = 6
    Top = 151
    Width = 271
    Height = 13
    Caption = #1057#1080#1084#1074#1086#1083' '#39'%'#39' '#1086#1079#1085#1072#1095#1072#1108' '#1087#1086#1089#1083#1110#1076#1086#1074#1085#1110#1089#1090#1100' '#1073#1091#1076#1100'-'#1103#1082#1080#1093' '#1089#1080#1084#1074#1086#1083#1110#1074
  end
  object ComboBox2: TComboBox
    Left = 8
    Top = 92
    Width = 191
    Height = 21
    Style = csDropDownList
    DropDownCount = 13
    ItemHeight = 13
    TabOrder = 4
    Items.Strings = (
      ''
      'equals'
      'does not equal'
      'is greate than'
      'is greate than or equall to'
      'is less than'
      'is less than or equall to'
      'like'
      'not like'
      'in'
      'not in'
      'is blank'
      'is not blank')
  end
  object ComboBox1: TComboBox
    Left = 8
    Top = 39
    Width = 191
    Height = 21
    Style = csDropDownList
    DropDownCount = 13
    ItemHeight = 13
    TabOrder = 0
    Items.Strings = (
      ''
      'equals'
      'does not equal'
      'is greate than'
      'is greate than or equall to'
      'is less than'
      'is less than or equall to'
      'like'
      'not like'
      'in'
      'not in'
      'is blank'
      'is not blank')
  end
  object Edit2: TEdit
    Left = 207
    Top = 92
    Width = 191
    Height = 21
    TabOrder = 5
    Visible = False
  end
  object Edit1: TEdit
    Left = 207
    Top = 39
    Width = 191
    Height = 21
    TabOrder = 1
    Visible = False
  end
  object rbOr: TRadioButton
    Left = 105
    Top = 69
    Width = 53
    Height = 17
    Caption = #1040'&'#1073#1086
    TabOrder = 3
  end
  object rbAnd: TRadioButton
    Left = 46
    Top = 69
    Width = 35
    Height = 17
    Caption = '&'#1030
    Checked = True
    TabOrder = 2
    TabStop = True
  end
  object bOk: TButton
    Left = 237
    Top = 188
    Width = 78
    Height = 22
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 6
  end
  object bCancel: TButton
    Left = 323
    Top = 188
    Width = 78
    Height = 22
    Cancel = True
    Caption = #1057#1082#1072#1089#1091#1074#1072#1090#1080
    ModalResult = 2
    TabOrder = 7
  end
  object DBComboBoxEh1: TDBComboBoxEh
    Left = 215
    Top = 46
    Width = 190
    Height = 21
    DropDownBox.Rows = 17
    DropDownBox.Sizable = True
    EditButtons = <>
    TabOrder = 8
    Text = 'DBComboBoxEh1'
    Visible = False
    OnChange = DBComboBoxEh1Change
  end
  object DBComboBoxEh2: TDBComboBoxEh
    Left = 213
    Top = 98
    Width = 191
    Height = 21
    DropDownBox.Rows = 17
    DropDownBox.Sizable = True
    EditButtons = <>
    TabOrder = 9
    Text = 'DBComboBoxEh2'
    Visible = False
    OnChange = DBComboBoxEh1Change
  end
  object DBDateTimeEditEh1: TDBDateTimeEditEh
    Left = 221
    Top = 52
    Width = 191
    Height = 21
    EditButtons = <>
    Kind = dtkDateEh
    TabOrder = 10
    Visible = False
  end
  object DBDateTimeEditEh2: TDBDateTimeEditEh
    Left = 219
    Top = 106
    Width = 191
    Height = 21
    EditButtons = <>
    Kind = dtkDateEh
    TabOrder = 11
    Visible = False
  end
  object DBNumberEditEh1: TDBNumberEditEh
    Left = 228
    Top = 59
    Width = 190
    Height = 21
    EditButtons = <>
    TabOrder = 12
    Visible = False
  end
  object DBNumberEditEh2: TDBNumberEditEh
    Left = 226
    Top = 115
    Width = 191
    Height = 21
    EditButtons = <>
    TabOrder = 13
    Visible = False
  end
end
