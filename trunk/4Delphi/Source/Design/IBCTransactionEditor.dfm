inherited IBCTransactionEditorForm: TIBCTransactionEditorForm
  Width = 338
  Height = 264
  ActiveControl = edIsolationLevel
  Caption = 'IBCTransaction Editor'
  Constraints.MinHeight = 230
  Constraints.MinWidth = 330
  PixelsPerInch = 96
  TextHeight = 13
  inherited BtnPanel: TPanel
    Top = 198
    Width = 330
    Height = 39
    inherited imCorner: TImage
      Left = 318
      Top = 27
    end
    inherited btOk: TBitBtn
      Left = 166
      Top = 6
    end
    inherited btCancel: TBitBtn
      Left = 247
      Top = 6
    end
  end
  object TopPanel: TPanel
    Left = 0
    Top = 0
    Width = 330
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object lbTransactionKind: TLabel
      Left = 16
      Top = 14
      Width = 64
      Height = 13
      Caption = 'Isolation level'
    end
    object edIsolationLevel: TComboBox
      Left = 120
      Top = 10
      Width = 202
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 0
      OnChange = edIsolationLevelChange
    end
  end
  object pnlClient: TPanel
    Left = 0
    Top = 41
    Width = 330
    Height = 157
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object gbParams: TGroupBox
      Left = 8
      Top = 3
      Width = 314
      Height = 140
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = 'Params '
      TabOrder = 0
      object meParams: TMemo
        Left = 8
        Top = 16
        Width = 298
        Height = 116
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 0
        OnChange = meParamsChange
      end
    end
  end
end
