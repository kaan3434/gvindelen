inherited FormWizardBase1: TFormWizardBase1
  ActiveControl = wzIPageMoneyBack
  Caption = 'FormWizardBase1'
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inherited wzForm: TJvWizard
    ActivePage = wzIPageMoneyBack
    object wzIPageMoneyBack: TJvWizardInteriorPage
      Header.Title.Color = clNone
      Header.Title.Text = 'Title'
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
      Caption = 'wzIPageMoneyBack'
    end
  end
end
