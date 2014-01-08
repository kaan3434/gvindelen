object FormParamEdit: TFormParamEdit
  Left = 368
  Top = 177
  Width = 352
  Height = 319
  Caption = 'FormParamEdit'
  Color = clBtnFace
  Constraints.MinHeight = 250
  Constraints.MinWidth = 250
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  DesignSize = (
    336
    281)
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
    Top = 48
    Width = 105
    Height = 13
    Caption = #1047#1085#1072#1095#1077#1085#1080#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1072
    FocusControl = mmoParamValue
  end
  object lblParamKind: TLabel
    Left = 16
    Top = 185
    Width = 76
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = #1042#1080#1076' '#1087#1072#1088#1072#1084#1077#1090#1088#1072
    FocusControl = cbParamKind
  end
  object mmoParamValue: TMemo
    Left = 16
    Top = 64
    Width = 304
    Height = 113
    Anchors = [akLeft, akTop, akRight, akBottom]
    Constraints.MinHeight = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object cbParamName: TDBComboBoxEh
    Left = 16
    Top = 24
    Width = 304
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
  object cbParamKind: TDBComboBoxEh
    Left = 16
    Top = 200
    Width = 302
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    DynProps = <>
    EditButtons = <>
    TabOrder = 2
    Text = 'cbParamKind'
    Visible = True
  end
  object btnOk: TButton
    Left = 159
    Top = 240
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 3
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 247
    Top = 240
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 4
  end
end
