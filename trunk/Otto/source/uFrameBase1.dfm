object FrameBase1: TFrameBase1
  Left = 530
  Top = 156
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
  OnActivate = FormActivate
  OnDeactivate = FormDeactivate
  PixelsPerInch = 96
  TextHeight = 13
  object dckTop: TTBXDock
    Left = 0
    Top = 0
    Width = 514
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
    Top = 353
    Width = 514
    Panels = <>
    UseSystemFont = False
  end
  object pnl1: TPanel
    Left = 0
    Top = 26
    Width = 514
    Height = 327
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    Caption = 'pnlContainer'
    TabOrder = 2
  end
  object trnRead: TpFIBTransaction
    DefaultDatabase = dmOtto.dbOtto
    TimeoutAction = TARollback
    MDTTransactionRole = mtrAutoDefine
    Left = 40
    Top = 24
  end
  object trnWrite: TpFIBTransaction
    DefaultDatabase = dmOtto.dbOtto
    TimeoutAction = TARollback
    MDTTransactionRole = mtrAutoDefine
    Left = 112
    Top = 24
  end
  object actList: TActionList
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
