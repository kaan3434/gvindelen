object FrameBase1: TFrameBase1
  Left = 0
  Top = 0
  Width = 435
  Height = 266
  Align = alClient
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object pnlFrame: TPanel
    Left = 0
    Top = 0
    Width = 435
    Height = 266
    Align = alClient
    BorderWidth = 4
    TabOrder = 0
    object sBarFrame: TTBXStatusBar
      Left = 5
      Top = 239
      Width = 425
      Panels = <>
      UseSystemFont = False
    end
    object dckTop: TTBXDock
      Left = 5
      Top = 5
      Width = 425
      Height = 26
      object tbBarTop: TTBXToolbar
        Left = 0
        Top = 0
        Caption = 'tbBarTop'
        DockMode = dmCannotFloatOrChangeDocks
        DragHandleStyle = dhNone
        FullSize = True
        Images = imgList
        Stretch = True
        TabOrder = 0
      end
    end
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
