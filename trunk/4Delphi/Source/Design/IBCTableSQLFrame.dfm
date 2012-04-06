inherited IBCTableSQLFrame: TIBCTableSQLFrame
  Width = 443
  Height = 270
  inherited Label4: TLabel
    Top = 68
  end
  inherited Label1: TLabel
    Top = 91
  end
  object lbKeyFields: TLabel [3]
    Left = 8
    Top = 43
    Width = 48
    Height = 13
    Caption = 'Key Fields'
  end
  inherited cbTableName: TComboBox
    Width = 271
  end
  inherited edOrderFields: TEdit
    Top = 64
    Width = 271
    TabOrder = 3
  end
  inherited edFilter: TEdit
    Top = 88
    Width = 271
    TabOrder = 4
  end
  inherited meSQL: TMemo
    Top = 112
    Width = 432
    Height = 153
    TabOrder = 5
  end
  object cbSystem: TCheckBox
    Left = 379
    Top = 16
    Width = 67
    Height = 17
    Anchors = [akTop, akRight]
    Caption = 'System'
    TabOrder = 1
    OnClick = cbSystemClick
  end
  object cbKeyFields: TComboBox
    Left = 96
    Top = 40
    Width = 271
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 2
    OnDropDown = cbKeyFieldsDropDown
    OnExit = cbKeyFieldsExit
  end
end
