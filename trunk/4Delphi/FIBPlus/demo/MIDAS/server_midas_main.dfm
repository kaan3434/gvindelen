object Form1: TForm1
  Left = 192
  Top = 107
  Width = 544
  Height = 375
  Caption = 'Server MIDAS'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 308
    Top = 12
    Width = 221
    Height = 281
    ReadOnly = True
    TabOrder = 0
  end
  object Button1: TButton
    Left = 452
    Top = 300
    Width = 75
    Height = 25
    Caption = 'Clear Memo'
    TabOrder = 1
    OnClick = Button1Click
  end
end
