inherited FormWizardReturn: TFormWizardReturn
  Left = 261
  Top = 129
  ActiveControl = wzIPageOrder
  Caption = 'FormWizardReturn'
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inherited wzForm: TJvWizard
    ActivePage = wzIPageOrder
    object wzIPageOrderItems: TJvWizardInteriorPage
      Header.Height = 30
      Header.ParentFont = False
      Header.Title.Color = clNone
      Header.Title.Text = 'Title'
      Header.Title.Anchors = [akLeft, akTop, akRight]
      Header.Title.Font.Charset = DEFAULT_CHARSET
      Header.Title.Font.Color = clWindowText
      Header.Title.Font.Height = -16
      Header.Title.Font.Name = 'MS Sans Serif'
      Header.Title.Font.Style = [fsBold]
      Header.Subtitle.Color = clNone
      Header.Subtitle.Visible = False
      Header.Subtitle.Text = 'Subtitle'
      Header.Subtitle.Anchors = [akLeft, akTop, akRight, akBottom]
      Header.Subtitle.Font.Charset = DEFAULT_CHARSET
      Header.Subtitle.Font.Color = clWindowText
      Header.Subtitle.Font.Height = -11
      Header.Subtitle.Font.Name = 'MS Sans Serif'
      Header.Subtitle.Font.Style = []
      Caption = 'wzIPageOrderItems'
    end
    object wzIPageOrder: TJvWizardInteriorPage
      Header.Height = 30
      Header.ParentFont = False
      Header.Title.Color = clNone
      Header.Title.Text = #1042#1086#1079#1074#1088#1072#1090' '#1089#1090#1086#1080#1084#1086#1089#1090#1080
      Header.Title.Anchors = [akLeft, akTop, akRight]
      Header.Title.Font.Charset = DEFAULT_CHARSET
      Header.Title.Font.Color = clWindowText
      Header.Title.Font.Height = -16
      Header.Title.Font.Name = 'MS Sans Serif'
      Header.Title.Font.Style = [fsBold]
      Header.Subtitle.Color = clNone
      Header.Subtitle.Visible = False
      Header.Subtitle.Text = 'Subtitle'
      Header.Subtitle.Anchors = [akLeft, akTop, akRight, akBottom]
      Header.Subtitle.Font.Charset = DEFAULT_CHARSET
      Header.Subtitle.Font.Color = clWindowText
      Header.Subtitle.Font.Height = -11
      Header.Subtitle.Font.Name = 'MS Sans Serif'
      Header.Subtitle.Font.Style = []
      Panel.Visible = True
      Color = clWindow
      Caption = 'wzIPageOrder'
    end
  end
end
