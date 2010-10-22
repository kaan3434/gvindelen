object Form1: TForm1
  Left = 260
  Top = 209
  Width = 799
  Height = 500
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 89
    Height = 13
    Caption = 'Book 1 page URL:'
  end
  object eURL: TEdit
    Left = 8
    Top = 24
    Width = 585
    Height = 21
    TabOrder = 0
  end
  object pages: TButton
    Left = 600
    Top = 16
    Width = 75
    Height = 25
    Action = actDownloadPages
    TabOrder = 1
  end
  object WebBrowser: TWebBrowser
    Left = 8
    Top = 80
    Width = 777
    Height = 345
    TabOrder = 2
    ControlData = {
      4C0000004E500000A82300000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object sb: TStatusBar
    Left = 0
    Top = 454
    Width = 791
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object pb: TProgressBar
    Left = 0
    Top = 438
    Width = 791
    Height = 16
    Align = alBottom
    TabOrder = 4
  end
  object stCurUrl: TStaticText
    Left = 8
    Top = 56
    Width = 777
    Height = 17
    AutoSize = False
    TabOrder = 5
  end
  object Text: TButton
    Left = 680
    Top = 16
    Width = 75
    Height = 25
    Action = actDownloadText
    TabOrder = 6
  end
  object GvWebScript: TGvWebScript
    WebBrowser = WebBrowser
    StatusBar = sb
    ProgressBar = pb
    Left = 16
    Top = 8
  end
  object ActionList1: TActionList
    Left = 16
    Top = 48
    object actDownloadPages: TAction
      Caption = #1059#1082#1072#1079#1072#1090#1077#1083#1100
      OnExecute = actDownloadPagesExecute
    end
    object actDownloadText: TAction
      Caption = #1058#1077#1082#1089#1090
      OnExecute = actDownloadTextExecute
      OnUpdate = actDownloadTextUpdate
    end
  end
end
