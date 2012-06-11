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
    Top = 502
    Width = 1016
    Height = 19
    Panels = <>
  end
  object dckTop: TTBXDock
    Left = 0
    Top = 0
    Width = 1016
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
    Width = 1016
    Height = 476
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
      Width = 1006
      Height = 466
      Align = alClient
      Caption = 'grBoxMain'
      TabOrder = 0
      object grdMain: TDBGridEh
        Left = 2
        Top = 15
        Width = 1002
        Height = 449
        Align = alClient
        AutoFitColWidths = True
        DataGrouping.GroupLevels = <>
        DataSource = dsMain
        EditActions = [geaCopyEh, geaPasteEh]
        Flat = True
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'MS Sans Serif'
        FooterFont.Style = []
        IndicatorTitle.TitleButton = True
        RowDetailPanel.Color = clBtnFace
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
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
    MDTTransactionRole = mtrAutoDefine
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
    MDTTransactionRole = mtrAutoDefine
    TPBMode = tpbDefault
    Left = 637
    Top = 63
  end
end
