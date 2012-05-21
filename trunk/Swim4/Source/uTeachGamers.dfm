object frmTeachGamers: TfrmTeachGamers
  Left = 0
  Top = 0
  Caption = #1053#1077#1080#1079#1074#1077#1089#1090#1085#1099#1077' '#1091#1095#1072#1089#1090#1085#1080#1082#1080
  ClientHeight = 493
  ClientWidth = 784
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXSplitter1: TSpTBXSplitter
    Left = 0
    Top = 169
    Width = 784
    Height = 5
    Cursor = crSizeNS
    Align = alBottom
    ExplicitWidth = 227
  end
  object SpTBXPanel1: TSpTBXPanel
    Left = 0
    Top = 174
    Width = 784
    Height = 319
    Caption = 'SpTBXPanel1'
    Align = alBottom
    TabOrder = 1
    ExplicitLeft = 120
    ExplicitTop = 240
    ExplicitWidth = 100
    ExplicitHeight = 41
    object SpTBXDockablePanel2: TSpTBXDockablePanel
      Left = 2
      Top = 2
      Width = 313
      Height = 315
      Caption = #1053#1086#1074#1099#1081' '#1091#1095#1072#1089#1090#1085#1080#1082
      Align = alLeft
      TabOrder = 0
      Options.Close = False
      DesignSize = (
        313
        315)
      object Label1: TLabel
        Left = 12
        Top = 26
        Width = 73
        Height = 13
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
      end
      object Label5: TLabel
        Left = 12
        Top = 66
        Width = 37
        Height = 13
        Caption = #1057#1090#1088#1072#1085#1072
      end
      object edGamerName: TDBEditEh
        Left = 11
        Top = 40
        Width = 292
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        EditButtons = <>
        TabOrder = 1
        Visible = True
      end
      object lcbCountry: TDBLookupComboboxEh
        Left = 15
        Top = 85
        Width = 292
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        DropDownBox.Options = []
        EditButtons = <>
        KeyField = 'COUNTRY_SIGN'
        ListField = 'COUNTRY_NAME_ENG'
        ListSource = dsCountry
        TabOrder = 2
        Visible = True
      end
      object SpTBXButton1: TSpTBXButton
        Left = 228
        Top = 120
        Width = 75
        Height = 25
        Caption = 'btnAddGamer'
        TabOrder = 3
        DrawPushedCaption = False
      end
    end
    object SpTBXSplitter2: TSpTBXSplitter
      Left = 315
      Top = 2
      Height = 315
      Cursor = crSizeWE
      ExplicitLeft = 328
      ExplicitTop = 128
      ExplicitHeight = 100
    end
    object SpTBXDockablePanel3: TSpTBXDockablePanel
      Left = 320
      Top = 2
      Width = 453
      Height = 315
      Caption = #1048#1079#1074#1077#1090#1089#1085#1099#1077' '#1091#1095#1072#1089#1090#1085#1080#1082#1080
      Align = alClient
      TabOrder = 2
      Options.Close = False
      ExplicitLeft = 368
      ExplicitTop = 64
      ExplicitWidth = 160
      ExplicitHeight = 128
      object DBGridEh2: TDBGridEh
        Left = 0
        Top = 19
        Width = 453
        Height = 296
        Align = alClient
        AutoFitColWidths = True
        DataGrouping.GroupLevels = <>
        DataSource = dsAGamers
        Flat = False
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'Tahoma'
        FooterFont.Style = []
        IndicatorOptions = [gioShowRowIndicatorEh]
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        Columns = <
          item
            EditButtons = <>
            FieldName = 'AGAMER_NAME'
            Footers = <>
            Width = 200
          end
          item
            AutoFitColWidth = False
            EditButtons = <>
            FieldName = 'COUNTRY_SIGN'
            Footers = <>
            Width = 30
          end
          item
            DisplayFormat = 'dd.mm.yyyy'
            EditButtons = <>
            FieldName = 'USED_DT'
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
    object SpTBXMultiDock1: TSpTBXMultiDock
      Left = 773
      Top = 2
      Width = 9
      Height = 315
      Position = dpxRight
      ExplicitLeft = 246
    end
  end
  object gridBGamers: TDBGridEh
    Left = 0
    Top = 0
    Width = 784
    Height = 169
    Align = alClient
    AutoFitColWidths = True
    DataGrouping.GroupLevels = <>
    DataSource = dsBGamers
    Flat = False
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    IndicatorOptions = [gioShowRowIndicatorEh]
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        AutoFitColWidth = False
        DisplayFormat = 'dd.mm.yyyy hh:nn'
        EditButtons = <>
        FieldName = 'EVENT_DTM'
        Footers = <>
        Width = 100
      end
      item
        EditButtons = <>
        FieldName = 'GAMER_NAME'
        Footers = <>
        Width = 250
      end
      item
        EditButtons = <>
        FieldName = 'ATOURNIR_NAME'
        Footers = <>
        Width = 200
      end
      item
        EditButtons = <>
        FieldName = 'COUNTRY_SIGN'
        Footers = <>
        Width = 30
      end
      item
        EditButtons = <>
        FieldName = 'ASPORT_NAME'
        Footers = <>
        Width = 150
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object dsBGamers: TDataSource
    AutoEdit = False
    DataSet = qryBGamers
    Left = 200
    Top = 56
  end
  object dsAGamers: TDataSource
    AutoEdit = False
    DataSet = qryAGamers
    Left = 200
    Top = 104
  end
  object trnWrite: TpFIBTransaction
    DefaultDatabase = dmFormMain.dbSwim
    TimeoutAction = TARollback
    TRParams.Strings = (
      'write'
      'nowait'
      'rec_version'
      'read_committed')
    AfterEnd = trnWriteAfterEnd
    TPBMode = tpbDefault
    Left = 40
    Top = 56
  end
  object trnRead: TpFIBTransaction
    DefaultDatabase = dmFormMain.dbSwim
    TimeoutAction = TARollback
    TRParams.Strings = (
      'read'
      'nowait'
      'rec_version'
      'read_committed')
    AfterStart = trnReadAfterStart
    TPBMode = tpbDefault
    Left = 40
    Top = 104
  end
  object qryBGamers: TpFIBDataSet
    SelectSQL.Strings = (
      
        'select bt.asport_id, bt.asport_name, bt.atournir_id, bt.atournir' +
        '_name, '
      '  bt.country_sign, gmr.event_dtm, gmr.gamer_name'
      
        'from (select be1.btournir_id, be1.event_dtm, be1.bgamer1_name ga' +
        'mer_name'
      '  from bevents be1'
      '  where be1.agamer1_id is null'
      '    and nullif(be1.bgamer1_name, '#39#39') is not null'
      '  union'
      '  select be2.btournir_id, be2.event_dtm, be2.bgamer2_name'
      '  from bevents be2'
      '  where be2.agamer2_id is null'
      '    and nullif(be2.bgamer2_name, '#39#39') is not null) gmr'
      'inner join v_btournirs bt on (bt.btournir_id = gmr.btournir_id)'
      'order by bt.asport_id, bt.atournir_name')
    Transaction = dmSwim.trnRead
    Database = dmFormMain.dbSwim
    UpdateTransaction = dmSwim.trnWrite
    Left = 136
    Top = 56
  end
  object qryAGamers: TpFIBDataSet
    SelectSQL.Strings = (
      'select a.agamer_id, a.agamer_name, a.country_sign, a.used_dt'
      'from agamers a'
      'where a.asport_id = :asport_id'
      '  and (a.country_sign = :country_sign or'
      '       a.country_sign in (select r.country_sign '
      '                          from regions r '
      '                          where r.region_sign = :country_sign))'
      'order by a.agamer_name')
    Transaction = trnRead
    Database = dmFormMain.dbSwim
    UpdateTransaction = trnWrite
    Left = 136
    Top = 104
  end
  object ActionList: TActionList
    Left = 80
    Top = 56
    object actAGamerAdd: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    end
    object actAGamerLink: TAction
      Caption = #1057#1074#1103#1079#1072#1090#1100' '#1080#1075#1088#1086#1082#1086#1074
    end
    object actFillEditForm: TAction
      Caption = 'actFillEditForm'
      OnExecute = actFillEditFormExecute
    end
  end
  object qryCountries: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    COUNTRY_SIGN,'
      '    COUNTRY_NAME_ENG,'
      '    COUNTRY_NAME_RUS'
      'FROM COUNTRIES '
      'ORDER BY COUNTRY_NAME_ENG')
    CacheModelOptions.BufferChunks = 100
    AllowedUpdateKinds = []
    Transaction = trnRead
    Database = dmFormMain.dbSwim
    Left = 136
    Top = 152
    oStartTransaction = False
  end
  object dsCountry: TDataSource
    AutoEdit = False
    DataSet = qryCountries
    Left = 200
    Top = 152
  end
end
