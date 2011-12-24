object DlgManualPayment: TDlgManualPayment
  Left = 416
  Top = 311
  BorderStyle = bsDialog
  Caption = 'Dialog'
  ClientHeight = 75
  ClientWidth = 317
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  DesignSize = (
    317
    75)
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 217
    Height = 57
    Shape = bsFrame
  end
  object lblAmountEur: TLabel
    Left = 16
    Top = 16
    Width = 58
    Height = 13
    Caption = #1057#1091#1084#1084#1072', EUR'
    FocusControl = edtAmountEur
  end
  object lblByr2Eur: TLabel
    Left = 128
    Top = 16
    Width = 78
    Height = 13
    Caption = #1050#1091#1088#1089' BYR->EUR'
    FocusControl = edtByr2Eur
  end
  object btnOk: TButton
    Left = 233
    Top = 8
    Width = 75
    Height = 25
    Action = actOk
    Anchors = [akTop, akRight]
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 233
    Top = 38
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object edtAmountEur: TDBNumberEditEh
    Left = 16
    Top = 32
    Width = 89
    Height = 21
    DisplayFormat = '### ##0.00'
    EditButtons = <>
    TabOrder = 2
    Visible = True
  end
  object edtByr2Eur: TDBNumberEditEh
    Left = 128
    Top = 32
    Width = 81
    Height = 21
    DecimalPlaces = 0
    DisplayFormat = '### ##0'
    EditButtons = <>
    TabOrder = 3
    Visible = True
  end
  object actDialog: TActionList
    Left = 104
    Top = 40
    object actOk: TAction
      Caption = 'OK'
      OnExecute = actOkExecute
      OnUpdate = actOkUpdate
    end
  end
end
