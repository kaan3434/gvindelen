object BaseNSIForm: TBaseNSIForm
  Left = 298
  Top = 29
  Width = 1024
  Height = 555
  Caption = 'BaseNSIForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poScreenCenter
  Visible = True
  WindowState = wsMaximized
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar: TStatusBar
    Left = 0
    Top = 498
    Width = 1008
    Height = 19
    Panels = <>
  end
  object dckTop: TTBXDock
    Left = 0
    Top = 0
    Width = 1008
    Height = 26
    object tlBarNsiActions: TTBXToolbar
      Left = 0
      Top = 0
      Caption = 'tlBarNsiActions'
      TabOrder = 0
    end
  end
  object pnlMain: TJvPanel
    Left = 0
    Top = 26
    Width = 1008
    Height = 472
    HotTrackFont.Charset = DEFAULT_CHARSET
    HotTrackFont.Color = clWindowText
    HotTrackFont.Height = -11
    HotTrackFont.Name = 'MS Sans Serif'
    HotTrackFont.Style = []
    Align = alClient
    BorderWidth = 4
    TabOrder = 1
    object grBoxMain: TJvGroupBox
      Left = 5
      Top = 5
      Width = 998
      Height = 462
      Align = alClient
      Caption = 'grBoxMain'
      TabOrder = 0
      object grdMain: TDBGridEh
        Left = 2
        Top = 15
        Width = 994
        Height = 445
        Align = alClient
        AutoFitColWidths = True
        DataSource = dsMain
        DynProps = <>
        EditActions = [geaCopyEh, geaPasteEh]
        Flat = True
        FooterParams.Color = clWindow
        IndicatorOptions = [gioShowRowIndicatorEh]
        IndicatorTitle.TitleButton = True
        TabOrder = 0
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
  end
  object qryMain: TpFIBDataSet
    Database = dmOtto.dbOtto
    Left = 432
    Top = 16
  end
  object dsMain: TDataSource
    AutoEdit = False
    DataSet = qryMain
    Left = 496
    Top = 16
  end
  object actListMain: TActionList
    Images = imgListMain
    Left = 576
    Top = 16
  end
  object imgListMain: TPngImageList
    PngImages = <>
    Left = 632
    Top = 16
  end
  object trnRead: TpFIBTransaction
    DefaultDatabase = dmOtto.dbOtto
    TimeoutAction = TARollback
    TRParams.Strings = (
      'read'
      'nowait'
      'concurrency')
    AfterStart = trnReadAfterStart
    BeforeEnd = trnReadBeforeEnd
    TPBMode = tpbDefault
    Left = 688
    Top = 16
  end
  object trnWrite: TpFIBTransaction
    DefaultDatabase = dmOtto.dbOtto
    TimeoutAction = TARollback
    TRParams.Strings = (
      'write'
      'nowait'
      'rec_version'
      'read_committed')
    TPBMode = tpbDefault
    Left = 637
    Top = 63
  end
end
