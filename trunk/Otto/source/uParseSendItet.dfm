object Form1: TForm1
  Left = 651
  Top = 326
  Width = 310
  Height = 179
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object pb: TProgressBar
    Left = 0
    Top = 128
    Width = 302
    Height = 17
    Align = alBottom
    Step = 1
    TabOrder = 0
  end
  object dlgOpen: TOpenDialog
    FileName = 'Send_Inet'
    Filter = 'xBase files (*.dbf)|*.dbf'
    Left = 72
    Top = 40
  end
  object dbfSendInet: TDbf
    IndexDefs = <>
    TableLevel = 4
    Left = 136
    Top = 40
  end
end
