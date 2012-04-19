object DlgManualPayment: TDlgManualPayment
  Left = 637
  Top = 313
  BorderStyle = bsDialog
  Caption = 'Dialog'
  ClientHeight = 186
  ClientWidth = 341
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  DesignSize = (
    341
    186)
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 241
    Height = 169
    Shape = bsFrame
  end
  object lblAmountEur: TLabel
    Left = 16
    Top = 16
    Width = 63
    Height = 13
    Caption = #1057#1091#1084#1084#1072', EUR'
    FocusControl = edtAmountEur
  end
  object lblByr2Eur: TLabel
    Left = 160
    Top = 16
    Width = 81
    Height = 13
    Caption = #1050#1091#1088#1089' BYR->EUR'
    FocusControl = edtByr2Eur
  end
  object lblAnnotate: TLabel
    Left = 16
    Top = 64
    Width = 63
    Height = 13
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    FocusControl = memAnnotate
  end
  object btnOk: TButton
    Left = 257
    Top = 8
    Width = 75
    Height = 25
    Action = actOk
    Anchors = [akTop, akRight]
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object CancelBtn: TButton
    Left = 257
    Top = 38
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object edtAmountEur: TDBNumberEditEh
    Left = 16
    Top = 32
    Width = 121
    Height = 21
    DisplayFormat = '### ##0.00'
    EditButtons = <>
    TabOrder = 0
    Visible = True
  end
  object edtByr2Eur: TDBNumberEditEh
    Left = 160
    Top = 32
    Width = 81
    Height = 21
    DecimalPlaces = 0
    DisplayFormat = '### ##0'
    EditButtons = <>
    TabOrder = 1
    Visible = True
  end
  object memAnnotate: TMemo
    Left = 16
    Top = 80
    Width = 225
    Height = 89
    TabOrder = 2
  end
  object actDialog: TActionList
    Left = 96
    Top = 16
    object actOk: TAction
      Caption = 'OK'
      OnExecute = actOkExecute
      OnUpdate = actOkUpdate
    end
  end
end
