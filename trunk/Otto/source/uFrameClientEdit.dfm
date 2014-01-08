object FrameClientEdit: TFrameClientEdit
  Left = 0
  Top = 0
  Width = 733
  Height = 65
  TabOrder = 0
  object grBoxClientEdit: TGroupBox
    Left = 0
    Top = 0
    Width = 733
    Height = 65
    Align = alClient
    Caption = #1044#1072#1085#1085#1099#1077' '#1082#1083#1080#1077#1085#1090#1072
    TabOrder = 0
    object edLastName: TDBEditEh
      Left = 16
      Top = 32
      Width = 257
      Height = 21
      DataField = 'LAST_NAME'
      DataSource = dsClientEdit
      DynProps = <>
      EditButtons = <>
      TabOrder = 0
      Visible = True
    end
    object edFirstName: TDBEditEh
      Left = 280
      Top = 32
      Width = 257
      Height = 21
      DataField = 'FIRST_NAME'
      DataSource = dsClientEdit
      DynProps = <>
      EditButtons = <>
      TabOrder = 1
      Visible = True
    end
    object edMidName: TDBEditEh
      Left = 552
      Top = 32
      Width = 257
      Height = 21
      DataField = 'MID_NAME'
      DataSource = dsClientEdit
      DynProps = <>
      EditButtons = <>
      TabOrder = 2
      Visible = True
    end
  end
  object dsClientEdit: TDataSource
    DataSet = tblNodeClient
    Left = 72
    Top = 16
  end
  object tblNodeClient: TGvNodeDataSet
    BeforeScroll = tblNodeClientBeforeScroll
    InitFieldDefs.Strings = (
      'LAST_NAME,ftString,100'
      'FIRST_NAME,ftString,100'
      'MID_NAME,ftString,100'
      'STATIC_PHONE,ftString,50'
      'MOBILE_PHONE,ftString,50'
      'EMAIL,ftString,50')
    Left = 40
    Top = 16
  end
end
