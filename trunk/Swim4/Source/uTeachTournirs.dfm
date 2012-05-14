object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Form3'
  ClientHeight = 442
  ClientWidth = 865
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Visible = True
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 201
    Width = 865
    Height = 3
    Cursor = crVSplit
    Align = alTop
    ExplicitWidth = 241
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 865
    Height = 201
    Align = alTop
    Caption = #1053#1077#1080#1079#1074#1077#1089#1090#1085#1099#1077' '#1090#1091#1088#1085#1080#1088#1099
    TabOrder = 0
    object DBGridEh1: TDBGridEh
      Left = 2
      Top = 15
      Width = 861
      Height = 184
      Align = alClient
      DataGrouping.GroupLevels = <>
      DataSource = dsBTournirs
      Flat = True
      FooterColor = clWindow
      FooterFont.Charset = DEFAULT_CHARSET
      FooterFont.Color = clWindowText
      FooterFont.Height = -11
      FooterFont.Name = 'Tahoma'
      FooterFont.Style = []
      IndicatorOptions = [gioShowRowIndicatorEh]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      Columns = <
        item
          EditButtons = <>
          FieldName = 'BTOURNIR_ID'
          Footers = <>
        end
        item
          EditButtons = <>
          FieldName = 'BTOURNIR_NAME'
          Footers = <>
          Width = 200
        end
        item
          EditButtons = <>
          FieldName = 'ATOURNIR_ID'
          Footers = <>
          Visible = False
        end
        item
          EditButtons = <>
          FieldName = 'BSPORT_ID'
          Footers = <>
          Visible = False
        end
        item
          EditButtons = <>
          FieldName = 'BOOKER_ID'
          Footers = <>
        end
        item
          EditButtons = <>
          FieldName = 'BTOURNIR_MASK'
          Footers = <>
          Width = 200
        end
        item
          EditButtons = <>
          FieldName = 'ASPORT_ID'
          Footers = <>
        end
        item
          EditButtons = <>
          FieldName = 'COUNTRY_SIGN'
          Footers = <>
        end
        item
          EditButtons = <>
          FieldName = 'USED_DT'
          Footers = <>
        end
        item
          EditButtons = <>
          FieldName = 'IGNORE_FLG'
          Footers = <>
        end
        item
          EditButtons = <>
          FieldName = 'COMPLETE_FLG'
          Footers = <>
        end
        item
          EditButtons = <>
          FieldName = 'TEMPORARY_DT'
          Footers = <>
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 204
    Width = 865
    Height = 238
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
      object Splitter2: TSplitter
        Left = 345
        Top = 0
        Height = 210
        ExplicitLeft = 440
        ExplicitTop = 64
        ExplicitHeight = 100
      end
      object DBGridEh2: TDBGridEh
        Left = 0
        Top = 0
        Width = 345
        Height = 210
        Align = alLeft
        DataGrouping.GroupLevels = <>
        DataSource = dsATournirs
        Flat = False
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'Tahoma'
        FooterFont.Style = []
        IndicatorOptions = [gioShowRowIndicatorEh]
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
      object Panel1: TPanel
        Left = 348
        Top = 0
        Width = 509
        Height = 210
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        ExplicitLeft = 512
        ExplicitTop = 40
        ExplicitWidth = 185
        ExplicitHeight = 41
        object edTournirName: TDBEditEh
          Left = 96
          Top = 16
          Width = 393
          Height = 21
          EditButtons = <>
          TabOrder = 0
          Text = 'edTournirName'
          Visible = True
        end
        object DBEditEh2: TDBEditEh
          Left = 96
          Top = 56
          Width = 393
          Height = 21
          EditButtons = <>
          TabOrder = 1
          Text = 'DBEditEh2'
          Visible = True
        end
      end
    end
  end
  object trnWrite: TpFIBTransaction
    Active = True
    DefaultDatabase = dmFormMain.dbSwim
    TimeoutAction = TARollback
    TRParams.Strings = (
      'write'
      'nowait'
      'rec_version'
      'read_committed')
    TPBMode = tpbDefault
    Left = 48
    Top = 24
  end
  object qryBTournirs: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    BTOURNIR_ID,'
      '    BTOURNIR_NAME,'
      '    ATOURNIR_ID,'
      '    BSPORT_ID,'
      '    BOOKER_ID,'
      '    BTOURNIR_MASK,'
      '    ASPORT_ID,'
      '    COUNTRY_SIGN,'
      '    USED_DT,'
      '    IGNORE_FLG,'
      '    COMPLETE_FLG,'
      '    TEMPORARY_DT'
      'FROM '
      '    BTOURNIRS'
      'ORDER BY '
      '    ASPORT_ID')
    Active = True
    Transaction = trnWrite
    Database = dmFormMain.dbSwim
    UpdateTransaction = dmFormMain.trnWrite
    Left = 112
    Top = 24
  end
  object dsBTournirs: TDataSource
    AutoEdit = False
    DataSet = qryBTournirs
    Left = 160
    Top = 24
  end
  object qryASports: TpFIBDataSet
    Transaction = trnWrite
    Database = dmFormMain.dbSwim
    Left = 112
    Top = 80
  end
  object qryATournirs: TpFIBDataSet
    SelectSQL.Strings = (
      'select a.*'
      'from atournirs a'
      '  inner join regions r '
      '     on (r.country_sign = a.country_sign)'
      'where r.region_sign = :region_sign'
      'order by a.start_dt desc')
    Transaction = trnWrite
    Database = dmFormMain.dbSwim
    Left = 112
    Top = 128
  end
  object qryCountries: TpFIBDataSet
    AllowedUpdateKinds = []
    Transaction = trnWrite
    Database = dmFormMain.dbSwim
    Left = 112
    Top = 184
  end
  object dsASports: TDataSource
    AutoEdit = False
    DataSet = qryASports
    Left = 160
    Top = 80
  end
  object dsATournirs: TDataSource
    AutoEdit = False
    DataSet = qryATournirs
    Left = 160
    Top = 128
  end
  object dsCountries: TDataSource
    AutoEdit = False
    DataSet = qryCountries
    Left = 160
    Top = 184
  end
end
