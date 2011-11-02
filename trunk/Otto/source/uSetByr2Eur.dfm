object FormSetByr2Eur: TFormSetByr2Eur
  Left = 548
  Top = 293
  Width = 202
  Height = 135
  Caption = #1050#1091#1088#1089' BYR -> EUR'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lbl1: TLabel
    Left = 16
    Top = 16
    Width = 83
    Height = 13
    Caption = #1042#1074#1077#1076#1080#1090#1077' '#1082#1091#1088#1089' '#1085#1072
  end
  object edtByr2Eur: TDBNumberEditEh
    Left = 16
    Top = 32
    Width = 161
    Height = 21
    DecimalPlaces = 0
    EditButtons = <>
    TabOrder = 0
    Visible = True
  end
  object btnOk: TButton
    Left = 24
    Top = 64
    Width = 75
    Height = 25
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 1
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 104
    Top = 64
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object trnWrite: TpFIBTransaction
    DefaultDatabase = dmOtto.dbOtto
    TimeoutAction = TARollback
    TRParams.Strings = (
      'write'
      'nowait'
      'rec_version'
      'read_committed')
    TPBMode = tpbDefault
    Left = 8
    Top = 8
  end
end
