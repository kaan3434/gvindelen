object dlgAppendGamersEng: TdlgAppendGamersEng
  Left = 360
  Top = 204
  Width = 488
  Height = 303
  Caption = 'Append Gamer Eng'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    480
    276)
  PixelsPerInch = 96
  TextHeight = 13
  object Memo: TMemo
    Left = 8
    Top = 56
    Width = 465
    Height = 177
    Lines.Strings = (
      'Memo')
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
  end
  object eURL: TLabeledEdit
    Left = 8
    Top = 24
    Width = 386
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 44
    EditLabel.Height = 13
    EditLabel.Caption = 'URL with'
    TabOrder = 1
    Text = 'D:/Swim/Stevegtennis/a-chennai.txt'
  end
  object btnGetData: TButton
    Left = 401
    Top = 24
    Width = 73
    Height = 21
    Action = actGetData
    Anchors = [akTop, akRight]
    TabOrder = 2
  end
  object Button1: TButton
    Left = 8
    Top = 240
    Width = 75
    Height = 25
    Action = actOpenData
    TabOrder = 3
  end
  object Button2: TButton
    Left = 96
    Top = 240
    Width = 75
    Height = 25
    Action = actParse
    TabOrder = 4
  end
  object sp_IU: TADOStoredProc
    Connection = dmSwim.ADOConnection
    Parameters = <>
    Left = 16
    Top = 8
  end
  object ActionList: TActionList
    OnUpdate = ActionListUpdate
    Left = 48
    Top = 8
    object actGetData: TAction
      Caption = #1055#1086#1083#1091#1095#1080#1090#1100
      OnExecute = actGetDataExecute
    end
    object actOpenData: TAction
      Caption = #1054#1090#1082#1088#1099#1090#1100
      OnExecute = actOpenDataExecute
    end
    object actParse: TAction
      Caption = #1056#1072#1079#1086#1073#1088#1072#1090#1100
      OnExecute = actParseExecute
    end
  end
  object OpenDialog: TOpenDialog
    DefaultExt = '*.txt'
    Filter = 'Text files (*.txt)|*.txt'
    Left = 16
    Top = 40
  end
end
