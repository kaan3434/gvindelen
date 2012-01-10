inherited FrameBase2: TFrameBase2
  Left = 253
  Top = 148
  Width = 859
  Height = 487
  Caption = 'FrameBase2'
  PixelsPerInch = 96
  TextHeight = 13
  inherited dckTop: TTBXDock
    Width = 843
  end
  inherited sb: TTBXStatusBar
    Top = 427
    Width = 843
  end
  object rgReturnKind: TRadioGroup [2]
    Left = 0
    Top = 26
    Width = 843
    Height = 47
    Align = alTop
    Caption = #1044#1077#1081#1089#1090#1074#1080#1103' '#1089' '#1086#1089#1090#1072#1090#1082#1086#1084
    Columns = 3
    Items.Strings = (
      #1054#1089#1090#1072#1074#1080#1090#1100' '#1085#1072' '#1089#1095#1077#1090#1077
      #1055#1086#1095#1090#1086#1074#1099#1084' '#1087#1077#1088#1077#1074#1086#1076#1086#1084
      #1041#1072#1085#1082#1086#1074#1089#1082#1080#1084' '#1087#1077#1088#1077#1074#1086#1076#1086#1084' '#1085#1072' '#1089#1095#1077#1090)
    TabOrder = 2
  end
  object grpPostMovement: TJvGroupBox [3]
    Left = 0
    Top = 73
    Width = 843
    Height = 136
    Align = alTop
    Caption = #1040#1090#1088#1080#1073#1091#1090#1099' '#1087#1086#1095#1090#1086#1074#1086#1075#1086' '#1087#1077#1088#1077#1074#1086#1076#1072
    TabOrder = 3
  end
  object grpBankMovement: TJvGroupBox [4]
    Left = 0
    Top = 209
    Width = 843
    Height = 160
    Align = alTop
    Caption = #1040#1090#1088#1080#1073#1091#1090#1099' '#1073#1072#1085#1082#1086#1074#1089#1082#1086#1075#1086' '#1087#1077#1088#1077#1074#1086#1076#1072
    TabOrder = 4
    object edBankAccount: TLabeledEdit
      Left = 96
      Top = 48
      Width = 121
      Height = 21
      EditLabel.Width = 77
      EditLabel.Height = 13
      EditLabel.Caption = 'edBankAccount'
      TabOrder = 0
    end
  end
end
