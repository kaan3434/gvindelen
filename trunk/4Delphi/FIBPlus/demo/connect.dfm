object frmConnect: TfrmConnect
  Left = 349
  Top = 265
  ActiveControl = edtDBName
  BorderStyle = bsDialog
  Caption = 'Connect to Database'
  ClientHeight = 213
  ClientWidth = 342
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label12: TLabel
    Left = 34
    Top = 114
    Width = 105
    Height = 22
    Caption = 'Technology !'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWhite
    Font.Height = -19
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label10: TLabel
    Left = 50
    Top = 94
    Width = 67
    Height = 22
    Caption = 'FIBPlus'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWhite
    Font.Height = -19
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label11: TLabel
    Left = 74
    Top = 75
    Width = 16
    Height = 22
    Caption = 'to'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWhite
    Font.Height = -19
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label9: TLabel
    Left = 42
    Top = 57
    Width = 81
    Height = 22
    Caption = 'Wellcome'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWhite
    Font.Height = -19
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Bevel1: TBevel
    Left = 0
    Top = 176
    Width = 342
    Height = 4
    Shape = bsTopLine
  end
  object Label1: TLabel
    Left = 4
    Top = 4
    Width = 77
    Height = 13
    Caption = 'Database Name'
  end
  object Label2: TLabel
    Left = 176
    Top = 49
    Width = 53
    Height = 13
    Caption = 'User Name'
  end
  object Label3: TLabel
    Left = 176
    Top = 92
    Width = 46
    Height = 13
    Caption = 'Password'
  end
  object Label4: TLabel
    Left = 176
    Top = 132
    Width = 53
    Height = 13
    Caption = 'Role Name'
  end
  object Label5: TLabel
    Left = 41
    Top = 56
    Width = 81
    Height = 22
    Caption = 'Wellcome'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label6: TLabel
    Left = 49
    Top = 93
    Width = 67
    Height = 22
    Caption = 'FIBPlus'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label7: TLabel
    Left = 73
    Top = 74
    Width = 16
    Height = 22
    Caption = 'to'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label8: TLabel
    Left = 33
    Top = 113
    Width = 105
    Height = 22
    Caption = 'Technology !'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object btnOK: TButton
    Left = 185
    Top = 183
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 4
  end
  object btnCancel: TButton
    Left = 265
    Top = 183
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 5
  end
  object edtDBName: TEdit
    Left = 4
    Top = 20
    Width = 334
    Height = 21
    CharCase = ecUpperCase
    TabOrder = 0
    Text = 'D:\4DELPHI\FIBPLUS\DEMO\GDB\DEMOPACK.GBK'
  end
  object edtUserName: TEdit
    Left = 176
    Top = 64
    Width = 161
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 31
    TabOrder = 1
    Text = 'SYSDBA'
  end
  object edtPassword: TEdit
    Left = 176
    Top = 107
    Width = 161
    Height = 21
    PasswordChar = '*'
    TabOrder = 2
  end
  object edtRoleName: TEdit
    Left = 176
    Top = 147
    Width = 161
    Height = 21
    CharCase = ecUpperCase
    TabOrder = 3
  end
end
