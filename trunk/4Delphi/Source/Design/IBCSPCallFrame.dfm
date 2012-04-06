inherited IBCSPCallFrame: TIBCSPCallFrame
  Width = 468
  Height = 328
  inherited Panel1: TPanel
    Width = 468
    Height = 182
    inherited meSQL: TMemo
      Width = 452
      Height = 160
    end
  end
  inherited pnlTop: TPanel
    Width = 468
    inherited btClear: TSpeedButton
      Left = 460
    end
    inherited gbStatementType: TGroupBox
      Width = 453
    end
  end
  inherited pnSQL: TPanel
    Width = 468
    inherited cbStoredProcName: TComboBox
      Width = 316
    end
    inherited btGenerate: TButton
      Left = 339
    end
  end
  inherited pnSQLSP: TPanel
    Width = 468
    inherited cbStoredProcNameSP: TComboBox
      Left = 120
      Width = 257
    end
    object cbIsQuery: TCheckBox
      Left = 381
      Top = 18
      Width = 84
      Height = 17
      Anchors = [akTop, akRight]
      Caption = 'Is Query'
      TabOrder = 1
      OnClick = cbIsQueryClick
      OnExit = cbStoredProcNameSelect
    end
  end
end
