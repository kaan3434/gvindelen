inherited FrameMoneyBack: TFrameMoneyBack
  inherited pnlFrame: TPanel
    Top = 346
    Width = 418
    Height = 25
    inherited sBarFrame: TTBXStatusBar
      Top = -2
      Width = 408
    end
    inherited dckTop: TTBXDock
      Width = 408
      Height = 25
      inherited tbBarTop: TTBXToolbar
        object btnMakeReturn: TTBXItem
          Action = actCreateReturn
        end
      end
    end
  end
  object grpBankMovement: TJvGroupBox [1]
    Left = 0
    Top = 194
    Width = 418
    Height = 152
    Align = alTop
    Caption = #1040#1090#1088#1080#1073#1091#1090#1099' '#1073#1072#1085#1082#1086#1074#1089#1082#1086#1075#1086' '#1087#1077#1088#1077#1074#1086#1076#1072
    Enabled = False
    TabOrder = 3
    object edBankAccount: TLabeledEdit
      Left = 8
      Top = 40
      Width = 201
      Height = 21
      EditLabel.Width = 144
      EditLabel.Height = 13
      EditLabel.Caption = #8470' '#1089#1095#1077#1090#1072' '#1074' '#1073#1072#1085#1082#1077' (13 '#1079#1085#1072#1082#1086#1074')'
      MaxLength = 13
      TabOrder = 0
    end
    object edClientAccount: TLabeledEdit
      Left = 216
      Top = 40
      Width = 161
      Height = 21
      EditLabel.Width = 67
      EditLabel.Height = 13
      EditLabel.Caption = #1057#1095#1077#1090' '#1082#1083#1080#1077#1085#1090#1072
      TabOrder = 1
    end
    object edBankName: TLabeledEdit
      Left = 8
      Top = 80
      Width = 369
      Height = 21
      EditLabel.Width = 83
      EditLabel.Height = 13
      EditLabel.Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1073#1072#1085#1082#1072
      TabOrder = 2
    end
    object edBankUNP: TLabeledEdit
      Left = 440
      Top = 80
      Width = 97
      Height = 21
      EditLabel.Width = 24
      EditLabel.Height = 13
      EditLabel.Caption = #1059#1053#1055
      MaxLength = 9
      TabOrder = 4
    end
    object edBankMFO: TLabeledEdit
      Left = 392
      Top = 80
      Width = 33
      Height = 21
      EditLabel.Width = 28
      EditLabel.Height = 13
      EditLabel.Caption = #1052#1060#1054
      MaxLength = 9
      TabOrder = 3
    end
    object edPersonalNum: TLabeledEdit
      Left = 8
      Top = 120
      Width = 177
      Height = 21
      CharCase = ecUpperCase
      EditLabel.Width = 74
      EditLabel.Height = 13
      EditLabel.Caption = #1051#1080#1095#1085#1099#1081' '#1085#1086#1084#1077#1088
      MaxLength = 14
      TabOrder = 5
    end
  end
  object grpCommon: TJvGroupBox [2]
    Left = 0
    Top = 0
    Width = 418
    Height = 146
    Align = alTop
    Caption = #1054#1073#1097#1080#1077' '#1072#1090#1088#1080#1073#1091#1090#1099
    TabOrder = 1
    object lblPasportIssued: TLabel
      Left = 256
      Top = 24
      Width = 66
      Height = 13
      Caption = #1044#1072#1090#1072' '#1074#1099#1076#1072#1095#1080
    end
    object edBelPostBarCode: TLabeledEdit
      Left = 152
      Top = 104
      Width = 145
      Height = 21
      EditLabel.Width = 120
      EditLabel.Height = 13
      EditLabel.Caption = #1050#1086#1076' '#1087#1086#1089#1099#1083#1082#1080' '#1041#1077#1083#1055#1086#1095#1090#1099
      TabOrder = 5
    end
    object edPassportNum: TLabeledEdit
      Left = 152
      Top = 40
      Width = 89
      Height = 21
      EditLabel.Width = 84
      EditLabel.Height = 13
      EditLabel.Caption = #1053#1086#1084#1077#1088' '#1087#1072#1089#1087#1086#1088#1090#1072
      MaxLength = 9
      TabOrder = 1
    end
    object edtPassportIssued: TDBDateTimeEditEh
      Left = 256
      Top = 40
      Width = 97
      Height = 21
      DynProps = <>
      EditButtons = <>
      Kind = dtkDateEh
      TabOrder = 2
      Visible = True
    end
    object edPassportIssuer: TLabeledEdit
      Left = 368
      Top = 40
      Width = 281
      Height = 21
      EditLabel.Width = 250
      EditLabel.Height = 13
      EditLabel.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1080' '#1074#1099#1076#1072#1074#1096#1077#1081' '#1076#1086#1082#1091#1084#1077#1085#1090
      TabOrder = 3
    end
    object chkPayByFirm: TCheckBox
      Left = 368
      Top = 72
      Width = 369
      Height = 17
      Caption = #1054#1087#1083#1072#1090#1072' '#1087#1077#1088#1077#1074#1086#1076#1072' '#1079#1072' '#1089#1095#1077#1090' '#1092#1080#1088#1084#1099
      TabOrder = 4
    end
    object rgArtReturnKind: TRadioGroup
      Left = 16
      Top = 24
      Width = 129
      Height = 105
      Caption = #1042#1080#1076' '#1074#1086#1079#1074#1088#1072#1090#1072
      Items.Strings = (
        #1051#1080#1095#1085#1086
        #1055#1086#1089#1099#1083#1082#1086#1081
        #1055#1086' '#1079#1072#1103#1074#1083#1077#1085#1080#1102
        #1055#1086#1089#1099#1083#1082#1072' '#1074' '#1051#1080#1090#1074#1091)
      TabOrder = 0
      OnClick = rgArtReturnKindClick
    end
  end
  object rgMoneyBackKind: TRadioGroup [3]
    Left = 0
    Top = 146
    Width = 418
    Height = 48
    Align = alTop
    Caption = #1044#1077#1081#1089#1090#1074#1080#1103' '#1089' '#1086#1089#1090#1072#1090#1082#1086#1084
    Columns = 3
    Items.Strings = (
      #1054#1089#1090#1072#1074#1080#1090#1100' '#1085#1072' '#1089#1095#1077#1090#1077
      #1055#1086#1095#1090#1086#1074#1099#1084' '#1087#1077#1088#1077#1074#1086#1076#1086#1084
      #1041#1072#1085#1082#1086#1074#1089#1082#1080#1084' '#1087#1077#1088#1077#1074#1086#1076#1086#1084' '#1085#1072' '#1089#1095#1077#1090)
    TabOrder = 2
    OnClick = rgMoneyBackKindClick
  end
  inherited actList: TActionList
    object actCreateReturn: TAction
      Caption = #1054#1092#1086#1088#1084#1080#1090#1100' '#1074#1086#1079#1074#1088#1072#1090
      OnExecute = actCreateReturnExecute
    end
  end
  inherited imgList: TPngImageList
    Top = 192
  end
  object trnRead: TpFIBTransaction
    TimeoutAction = TARollback
    Left = 48
  end
  object trnWrite: TpFIBTransaction
    TimeoutAction = TARollback
    Left = 88
  end
end
