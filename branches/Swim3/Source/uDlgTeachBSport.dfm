object DlgTeachBSport: TDlgTeachBSport
  Left = 354
  Top = 384
  Width = 293
  Height = 227
  BorderIcons = [biSystemMenu]
  Caption = #1053#1077#1080#1079#1074#1077#1089#1090#1085#1099#1081' '#1074#1080#1076' '#1089#1087#1086#1088#1090#1072
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  Icon.Data = {
    0000010002002020100000000000E80200002600000010101000000000002801
    00000E0300002800000020000000400000000100040000000000800200000000
    0000000000000000000000000000000000000000800000800000008080008000
    0000800080008080000080808000C0C0C0000000FF0000FF000000FFFF00FF00
    0000FF00FF00FFFF0000FFFFFF000CCCCCCCCCCCCCCCCCCCCCCCCCCCCCC0CCCC
    CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCFFFFFFFFFFFFFFFFFFFFFFFFCCCCCCCC
    FFFFFFFFFFFFFFFFFFFFFFFFCCCCCCCCFFFFFFF0FFFFF0F0F0F0FFFFCCCCCCCC
    FFFFFF707FFFF0F0F0F0FFFFCCCCCCCCFFFFFF707FFFF0F0F0F0FFFFCCCCCCCC
    FFFFFF707FFFF0F0F0F0FFFFCCCCCCCCFFFFFF707FFFF0F0F0F0FFFFCCCCCCCC
    FFFFFF707FFFF0F0F0F0FFFFCCCCCCCCFFFFFF707FFFF0F0F0F0FFFFCCCCCCCC
    FFFFFF707FFFF0F0F0F0FFFFCCCCCCCCFFFFFF707FFFF0000000FFFFCCCCCCCC
    FFFFFF707FFFFF00000FFFFFCCCCCCCCFFFFFF707FFFFFF707FFFFFFCCCCCCCC
    FFFFFF707FFFFFF707FFFFFFCCCCCCCCFFFFFF707FFFFFF707FFFFFFCCCCCCCC
    FFFFF00000FFFFF707FFFFFFCCCCCCCCFFFF0000000FFFF707FFFFFFCCCCCCCC
    FFFF0000000FFFF707FFFFFFCCCCCCCCFFFF0F0F0F0FFFF707FFFFFFCCCCCCCC
    FFFF0F0F0F0FFFF707FFFFFFCCCCCCCCFFFF0F0F0F0FFFF707FFFFFFCCCCCCCC
    FFFF0F0F0F0FFFF707FFFFFFCCCCCCCCFFFF0F0F0F0FFFF707FFFFFFCCCCCCCC
    FFFF0F0F0F0FFFF707FFFFFFCCCCCCCCFFFF0F0F0F0FFFF707FFFFFFCCCCCCCC
    FFFF0F0F0F0FFFFF0FFFFFFFCCCCCCCCFFFFFFFFFFFFFFFFFFFFFFFFCCCCCCCC
    FFFFFFFFFFFFFFFFFFFFFFFFCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC0CCC
    CCCCCCCCCCCCCCCCCCCCCCCCCCC0800000010000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000080000001280000001000000020000000010004000000
    0000C00000000000000000000000000000000000000000000000000080000080
    00000080800080000000800080008080000080808000C0C0C0000000FF0000FF
    000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000CCCCCCCCCCCCCC0CCFF
    FFFFFFFFFFCCCCFFF0FF0F0F0FCCCCFFF0FF0F0F0FCCCCFFF0FF0F0F0FCCCCFF
    F0FF0F0F0FCCCCFFF0FF00000FCCCCFFF0FFF000FFCCCCFF000FFF0FFFCCCCF0
    0000FF0FFFCCCCF0F0F0FF0FFFCCCCF0F0F0FF0FFFCCCCF0F0F0FF0FFFCCCCF0
    F0F0FF0FFFCCCCFFFFFFFFFFFFCC0CCCCCCCCCCCCCC080010000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    00000000000000000000000000000000000080010000}
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnDeactivate = FormDeactivate
  PixelsPerInch = 96
  TextHeight = 13
  object lAbstractSport: TLabel
    Left = 8
    Top = 96
    Width = 96
    Height = 13
    Caption = #1040#1073#1089#1086#1083#1102#1090#1085#1099#1081' '#1089#1087#1086#1088#1090
    Layout = tlCenter
  end
  object lblBookerName: TLabel
    Left = 8
    Top = 8
    Width = 50
    Height = 13
    Caption = #1041#1091#1082#1084#1077#1082#1077#1088
  end
  object lblBSportName: TLabel
    Left = 8
    Top = 48
    Width = 30
    Height = 13
    Caption = #1057#1087#1086#1088#1090
  end
  object btnOk: TButton
    Left = 200
    Top = 144
    Width = 73
    Height = 25
    Action = actModifyBSport
    TabOrder = 0
  end
  object lcbASports: TDBLookupComboboxEh
    Left = 8
    Top = 112
    Width = 265
    Height = 21
    DataField = 'ASPORT_ID'
    DataSource = dsUBSports
    EditButtons = <
      item
        Action = actShowASports
        Style = ebsEllipsisEh
      end>
    KeyField = 'ASport_Id'
    ListField = 'ASport_Nm'
    ListSource = dsASports
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    Visible = True
  end
  object dbeBookerName: TDBEdit
    Left = 8
    Top = 24
    Width = 121
    Height = 21
    Color = clMoneyGreen
    DataField = 'BOOKER_NM'
    DataSource = dsUBSports
    TabOrder = 3
  end
  object dbeBSportName: TDBEdit
    Left = 8
    Top = 64
    Width = 265
    Height = 21
    Color = clMoneyGreen
    DataField = 'BSPORT_NM'
    DataSource = dsUBSports
    TabOrder = 4
  end
  object Navigator: TDBNavigator
    Left = 8
    Top = 144
    Width = 184
    Height = 25
    DataSource = dsUBSports
    VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbDelete, nbPost, nbCancel, nbRefresh]
    TabOrder = 2
  end
  object sb: TStatusBar
    Left = 0
    Top = 181
    Width = 285
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object ActionList: TActionList
    Left = 16
    Top = 8
    object actModifyBSport: TAction
      Caption = 'Apply'
      OnExecute = actModifyBSportExecute
      OnUpdate = actModifyBSportUpdate
    end
    object actShowASports: TAction
      Caption = 'ASporta Manager'
    end
  end
  object cdsBSports: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'prvBSports'
    BeforeOpen = cdsBSportsBeforeOpen
    AfterOpen = cdsBSportsAfterOpen
    AfterScroll = cdsBSportsAfterScroll
    Left = 48
    Top = 8
  end
  object cdsASports: TClientDataSet
    Aggregates = <>
    AutoCalcFields = False
    Params = <>
    ProviderName = 'prvASports'
    Left = 48
    Top = 40
  end
  object dsASports: TDataSource
    AutoEdit = False
    DataSet = cdsASports
    Left = 80
    Top = 40
  end
  object prvASports: TDataSetProvider
    DataSet = dmSwim.tblASports
    ResolveToDataSet = True
    Left = 112
    Top = 40
  end
  object prvBSports: TDataSetProvider
    ResolveToDataSet = True
    Options = [poDisableInserts, poAutoRefresh]
    Left = 112
    Top = 8
  end
  object dsUBSports: TDataSource
    DataSet = cdsBSports
    Left = 80
    Top = 8
  end
end
