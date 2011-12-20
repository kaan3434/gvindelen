inherited FormWizardOrder: TFormWizardOrder
  Left = 182
  Top = 76
  ActiveControl = wzIPageOrderSummary
  Caption = 'FormWizardOrder'
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inherited wzForm: TJvWizard
    ActivePage = wzIPageOrderSummary
    DefaultButtons = False
    OnActivePageChanging = wzFormActivePageChanging
    object wzWPage: TJvWizardWelcomePage
      Header.ParentFont = False
      Header.Title.Color = clNone
      Header.Title.Text = 'Welcome'
      Header.Title.Anchors = [akLeft, akTop, akRight]
      Header.Title.Font.Charset = DEFAULT_CHARSET
      Header.Title.Font.Color = clWindowText
      Header.Title.Font.Height = -16
      Header.Title.Font.Name = 'MS Sans Serif'
      Header.Title.Font.Style = [fsBold]
      Header.Subtitle.Color = clNone
      Header.Subtitle.Text = 'Subtitle'
      Header.Subtitle.Anchors = [akLeft, akTop, akRight, akBottom]
      Header.Subtitle.Font.Charset = DEFAULT_CHARSET
      Header.Subtitle.Font.Color = clWindowText
      Header.Subtitle.Font.Height = -11
      Header.Subtitle.Font.Name = 'MS Sans Serif'
      Header.Subtitle.Font.Style = []
      Panel.Visible = True
      VisibleButtons = [bkNext, bkCancel]
      DesignSize = (
        1016
        479)
      object btnClientPageFirst: TButton
        Left = 192
        Top = 104
        Width = 153
        Height = 25
        Action = actClientPageFirst
        Anchors = [akLeft]
        TabOrder = 0
      end
    end
    object wzIPageOrderItems: TJvWizardInteriorPage
      Header.Height = 30
      Header.ParentFont = False
      Header.Title.Color = clNone
      Header.Title.Text = #1040#1088#1090#1080#1082#1091#1083#1099
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
    end
    object wzIPageOrder: TJvWizardInteriorPage
      Header.Height = 30
      Header.ParentFont = False
      Header.Title.Color = clNone
      Header.Title.Text = #1047#1072#1103#1074#1082#1072
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
    end
    object wzIPageClient: TJvWizardInteriorPage
      Header.Height = 30
      Header.ParentFont = False
      Header.Title.Color = clNone
      Header.Title.Text = #1050#1083#1080#1077#1085#1090
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
    end
    object wzIPageAdress: TJvWizardInteriorPage
      Header.Height = 30
      Header.ParentFont = False
      Header.Title.Color = clNone
      Header.Title.Text = #1040#1076#1088#1077#1089
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
      Caption = 'wzIPageAdress'
    end
    object wzIPageOrderSummary: TJvWizardInteriorPage
      Header.Height = 30
      Header.ParentFont = False
      Header.Title.Color = clNone
      Header.Title.Text = #1047#1072#1103#1074#1082#1072
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
      VisibleButtons = [bkBack, bkCancel]
      Color = clWindow
      Caption = 'wzIPageOrderSummary'
    end
  end
  inherited actListWzrdBtn: TActionList
    object actClientPageFirst: TAction
      Caption = #1053#1072#1095#1072#1090#1100' '#1089' '#1082#1083#1080#1077#1085#1090#1072
      OnExecute = actClientPageFirstExecute
    end
  end
  inherited trnWrite: TpFIBTransaction
    BeforeEnd = trnWriteBeforeEnd
  end
end
