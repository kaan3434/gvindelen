object FrameClientView: TFrameClientView
  Left = 0
  Top = 0
  Width = 729
  Height = 192
  TabOrder = 0
  object grBoxClient: TGroupBox
    Left = 0
    Top = 0
    Width = 729
    Height = 192
    Align = alClient
    Caption = 'grBoxClient'
    TabOrder = 0
    object vsTreeClient: TVirtualStringTree
      Left = 2
      Top = 15
      Width = 725
      Height = 175
      Align = alClient
      BorderStyle = bsNone
      Color = clBtnFace
      Ctl3D = False
      Header.AutoSizeIndex = 0
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentCtl3D = False
      TabOrder = 0
      Columns = <
        item
          Position = 0
          WideText = #1055#1072#1088#1072#1084#1077#1090#1088
        end
        item
          CaptionAlignment = taCenter
          Options = [coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment]
          Position = 1
          WideText = #1047#1085#1072#1095#1077#1085#1080#1077
        end>
    end
  end
end
