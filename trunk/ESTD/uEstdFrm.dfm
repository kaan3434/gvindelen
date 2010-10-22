object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 404
  ClientWidth = 587
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter3: TSplitter
    Left = 129
    Top = 143
    Height = 261
    ExplicitLeft = 136
    ExplicitTop = 232
    ExplicitHeight = 100
  end
  object Ribbon1: TRibbon
    Left = 0
    Top = 0
    Width = 587
    Height = 143
    Caption = 'Ribbon1'
    Tabs = <
      item
        Caption = 'RibbonPage1'
        Page = RibbonPage1
      end
      item
        Caption = 'RibbonPage2'
        Page = RibbonPage2
      end>
    ExplicitTop = -6
    DesignSize = (
      587
      143)
    StyleName = 'Ribbon - Luna'
    object RibbonPage2: TRibbonPage
      Left = 0
      Top = 50
      Width = 586
      Height = 93
      Caption = 'RibbonPage2'
      Index = 1
    end
    object RibbonPage1: TRibbonPage
      Left = 0
      Top = 50
      Width = 586
      Height = 93
      Caption = 'RibbonPage1'
      Index = 0
    end
  end
  object PageControl1: TPageControl
    Left = 132
    Top = 143
    Width = 455
    Height = 261
    ActivePage = tsDocSets
    Align = alClient
    TabOrder = 1
    object tsDocSets: TTabSheet
      Caption = #1053#1072#1073#1086#1088#1099
      object Splitter1: TSplitter
        Left = 225
        Top = 0
        Height = 233
        ExplicitLeft = 304
        ExplicitTop = 88
        ExplicitHeight = 100
      end
      object DBGridEh1: TDBGridEh
        Left = 0
        Top = 0
        Width = 225
        Height = 233
        Align = alLeft
        DataGrouping.GroupLevels = <>
        Flat = False
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'Tahoma'
        FooterFont.Style = []
        RowDetailPanel.Color = clBtnFace
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
      object DBGridEh2: TDBGridEh
        Left = 228
        Top = 0
        Width = 219
        Height = 233
        Align = alClient
        DataGrouping.GroupLevels = <>
        Flat = False
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'Tahoma'
        FooterFont.Style = []
        RowDetailPanel.Color = clBtnFace
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
    object tsOperations: TTabSheet
      Caption = #1054#1087#1077#1088#1072#1094#1080#1080
      ImageIndex = 1
      object Splitter2: TSplitter
        Left = 185
        Top = 0
        Height = 233
        ExplicitLeft = 208
        ExplicitTop = 88
        ExplicitHeight = 100
      end
      object DBGridEh3: TDBGridEh
        Left = 0
        Top = 0
        Width = 185
        Height = 233
        Align = alLeft
        DataGrouping.GroupLevels = <>
        Flat = False
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'Tahoma'
        FooterFont.Style = []
        RowDetailPanel.Color = clBtnFace
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
      object DBGridEh4: TDBGridEh
        Left = 188
        Top = 0
        Width = 259
        Height = 233
        Align = alClient
        DataGrouping.GroupLevels = <>
        Flat = False
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'Tahoma'
        FooterFont.Style = []
        RowDetailPanel.Color = clBtnFace
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1054#1073#1086#1088#1091#1076#1086#1074#1072#1085#1080#1077
      ImageIndex = 2
      object DBGridEh5: TDBGridEh
        Left = 0
        Top = 0
        Width = 447
        Height = 233
        Align = alClient
        DataGrouping.GroupLevels = <>
        Flat = False
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'Tahoma'
        FooterFont.Style = []
        RowDetailPanel.Color = clBtnFace
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
  end
  object VirtualStringTree1: TVirtualStringTree
    Left = 0
    Top = 143
    Width = 129
    Height = 261
    Align = alLeft
    Header.AutoSizeIndex = 0
    Header.DefaultHeight = 17
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.MainColumn = -1
    TabOrder = 2
    ExplicitLeft = 1
    ExplicitTop = 149
    Columns = <>
  end
  object ActionManager1: TActionManager
    Left = 80
    Top = 224
    StyleName = 'Platform Default'
  end
  object memDocSets: TMemTableEh
    Params = <>
    Left = 32
    Top = 152
  end
  object DataSource1: TDataSource
    Left = 72
    Top = 152
  end
end
