object FrameBase0: TFrameBase0
  Left = 0
  Top = 0
  Width = 695
  Height = 376
  TabOrder = 0
  OnEnter = FrameEnter
  OnExit = FrameExit
  object dckTop: TTBXDock
    Left = 0
    Top = 0
    Width = 695
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
    Top = 354
    Width = 695
    Panels = <>
    UseSystemFont = False
  end
  object pnl1: TJvPanel
    Left = 0
    Top = 26
    Width = 695
    Height = 328
    HotTrackFont.Charset = DEFAULT_CHARSET
    HotTrackFont.Color = clWindowText
    HotTrackFont.Height = -11
    HotTrackFont.Name = 'MS Sans Serif'
    HotTrackFont.Style = []
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
