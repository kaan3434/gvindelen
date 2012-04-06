inherited IBCAlerterEditorForm: TIBCAlerterEditorForm
  Width = 374
  Height = 324
  Caption = 'IBCAlerterEditorForm'
  Constraints.MinHeight = 200
  Constraints.MinWidth = 300
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  inherited BtnPanel: TPanel
    Top = 256
    Width = 366
    inherited imCorner: TImage
      Left = 354
    end
    inherited btOk: TBitBtn
      Left = 202
    end
    inherited btCancel: TBitBtn
      Left = 283
    end
    object cbAutoRegister: TCheckBox
      Left = 9
      Top = 12
      Width = 97
      Height = 17
      Caption = 'Auto register'
      TabOrder = 2
      OnClick = cbAutoRegisterClick
    end
  end
  object pnlClient: TPanel
    Left = 0
    Top = 0
    Width = 366
    Height = 256
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object lbEvents: TLabel
      Left = 8
      Top = 8
      Width = 33
      Height = 13
      Caption = 'Events'
    end
    object GroupBox: TGroupBox
      Left = 9
      Top = 24
      Width = 349
      Height = 219
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 0
      object EventList: TStringGrid
        Left = 10
        Top = 15
        Width = 329
        Height = 194
        Anchors = [akLeft, akTop, akRight, akBottom]
        ColCount = 2
        DefaultColWidth = 150
        DefaultRowHeight = 18
        RowCount = 1
        FixedRows = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing, goAlwaysShowEditor, goThumbTracking]
        TabOrder = 0
        OnKeyDown = EventListKeyDown
        OnSetEditText = EventListSetEditText
        ColWidths = (
          28
          295)
      end
    end
  end
end
