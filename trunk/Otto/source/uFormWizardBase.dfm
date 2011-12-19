object FormWizardBase: TFormWizardBase
  Left = 187
  Top = 133
  Width = 1024
  Height = 555
  Caption = 'FormWizardBase'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefaultSizeOnly
  Visible = True
  WindowState = wsMaximized
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object wzForm: TJvWizard
    Left = 0
    Top = 0
    Width = 1008
    Height = 517
    ButtonBarHeight = 42
    ButtonStart.Caption = 'To &Start Page'
    ButtonStart.NumGlyphs = 1
    ButtonStart.Width = 85
    ButtonLast.Caption = 'To &Last Page'
    ButtonLast.NumGlyphs = 1
    ButtonLast.Width = 85
    ButtonBack.Caption = '< '#1053#1072#1079#1072#1076
    ButtonBack.NumGlyphs = 1
    ButtonBack.Width = 75
    ButtonNext.Caption = #1044#1072#1083#1077#1077' >'
    ButtonNext.NumGlyphs = 1
    ButtonNext.Width = 75
    ButtonFinish.Caption = '&Finish'
    ButtonFinish.NumGlyphs = 1
    ButtonFinish.Width = 75
    ButtonCancel.Caption = #1054#1090#1084#1077#1085#1072
    ButtonCancel.NumGlyphs = 1
    ButtonCancel.ModalResult = 2
    ButtonCancel.Width = 75
    ButtonHelp.Caption = '&Help'
    ButtonHelp.NumGlyphs = 1
    ButtonHelp.Width = 75
    ShowRouteMap = False
    OnCancelButtonClick = wzFormCancelButtonClick
    DesignSize = (
      1008
      517)
  end
  object actListWzrdBtn: TActionList
    Left = 24
    Top = 480
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
    Left = 352
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
    TPBMode = tpbDefault
    Left = 400
    Top = 16
  end
end
