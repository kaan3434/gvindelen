object FrameBase1: TFrameBase1
  Left = 449
  Top = 366
  Width = 530
  Height = 413
  Align = alClient
  Caption = 'FrameBase1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object dckTop: TTBXDock
    Left = 0
    Top = 0
    Width = 522
    Height = 26
    object tlBarTop: TTBXToolbar
      Left = 0
      Top = 0
      Caption = 'tlBarTop'
      Images = imgList
      Stretch = True
      TabOrder = 0
    end
  end
  object sb: TTBXStatusBar
    Left = 0
    Top = 357
    Width = 522
    Panels = <>
    UseSystemFont = False
  end
  object trnRead: TpFIBTransaction
    DefaultDatabase = dmOtto.dbOtto
    TimeoutAction = TARollback
    Left = 40
    Top = 24
  end
  object trnWrite: TpFIBTransaction
    DefaultDatabase = dmOtto.dbOtto
    TimeoutAction = TARollback
    Left = 112
    Top = 24
  end
  object actlstList: TActionList
    Images = imgList
    Left = 24
    Top = 176
  end
  object imgList: TPngImageList
    PngImages = <>
    Left = 72
    Top = 176
  end
end