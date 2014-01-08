object FormCriteriaEdit: TFormCriteriaEdit
  Left = 787
  Top = 197
  Width = 300
  Height = 340
  Caption = 'FormCriteriaEdit'
  Color = clBtnFace
  Constraints.MinHeight = 340
  Constraints.MinWidth = 300
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  DesignSize = (
    284
    302)
  PixelsPerInch = 96
  TextHeight = 13
  object lblParamName: TLabel
    Left = 16
    Top = 8
    Width = 130
    Height = 13
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1072
    FocusControl = cbParamName
  end
  object lblParamValue: TLabel
    Left = 16
    Top = 128
    Width = 105
    Height = 13
    Caption = #1047#1085#1072#1095#1077#1085#1080#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1072
    FocusControl = mmoParamValue
  end
  object lblParamKind: TLabel
    Left = 16
    Top = 88
    Width = 60
    Height = 13
    Caption = #1058#1080#1087' '#1076#1072#1085#1085#1099#1093
  end
  object lblAction: TLabel
    Left = 16
    Top = 48
    Width = 105
    Height = 13
    Caption = #1044#1077#1081#1089#1090#1074#1080#1077' '#1089#1088#1072#1074#1085#1077#1085#1080#1103
    FocusControl = cbParamAction
  end
  object lblParamValue2: TLabel
    Left = 16
    Top = 216
    Width = 149
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = #1042#1077#1088#1093#1085#1077#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1076#1080#1072#1087#1072#1079#1086#1085#1072
  end
  object cbParamName: TDBComboBoxEh
    Left = 16
    Top = 24
    Width = 250
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    DynProps = <>
    EditButtons = <>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Visible = True
  end
  object mmoParamValue: TMemo
    Left = 16
    Top = 144
    Width = 250
    Height = 65
    Anchors = [akLeft, akTop, akRight, akBottom]
    Constraints.MinHeight = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 3
  end
  object btnOk: TButton
    Left = 104
    Top = 272
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 5
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 192
    Top = 272
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 6
  end
  object cbParamKind: TDBComboBoxEh
    Left = 16
    Top = 104
    Width = 250
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    DynProps = <>
    EditButtons = <>
    TabOrder = 2
    Text = 'cbParamKind'
    Visible = True
  end
  object cbParamAction: TDBComboBoxEh
    Left = 16
    Top = 64
    Width = 250
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    DynProps = <>
    EditButtons = <>
    TabOrder = 1
    Text = 'cbParamAction'
    Visible = True
  end
  object edParamValue2: TDBEditEh
    Left = 16
    Top = 232
    Width = 250
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    DynProps = <>
    EditButtons = <>
    TabOrder = 4
    Text = 'edParamValue2'
    Visible = True
  end
end
