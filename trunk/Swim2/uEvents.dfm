inherited frmEvents: TfrmEvents
  Left = 294
  Top = 179
  Width = 830
  Height = 545
  Caption = 'frmEvents'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited Splitter1: TSplitter
    Top = 215
    Width = 822
  end
  inherited TBXDockUp: TTBXDock
    Width = 822
    inherited TBXToolbar: TTBXToolbar
      object btnShowPanel: TTBXVisibilityToggleItem [4]
      end
      inherited DBNavigator: TDBNavigator
        Hints.Strings = ()
      end
    end
  end
  inherited gridMain: TDBGridEh
    Width = 822
    Height = 189
    Columns = <
      item
        EditButtons = <>
        FieldName = 'EVENT_ID'
        Footers = <>
        Visible = False
      end
      item
        EditButtons = <>
        FieldName = 'ASPORT_ID'
        Footers = <>
        Visible = False
      end
      item
        AutoFitColWidth = False
        EditButtons = <>
        FieldName = 'ASPORT_NM'
        Footers = <>
        ReadOnly = True
        Title.Caption = #1057#1087#1086#1088#1090
        Width = 100
      end
      item
        EditButtons = <>
        FieldName = 'TOURNIR_ID'
        Footers = <>
        Visible = False
      end
      item
        AutoFitColWidth = False
        DisplayFormat = 'DD.MM.YYYY HH:NN'
        EditButtons = <>
        FieldName = 'EVENT_DTM'
        Footers = <>
        ReadOnly = True
        Title.Caption = #1044#1072#1090#1072
        Width = 90
      end
      item
        AutoFitColWidth = False
        EditButtons = <>
        FieldName = 'AGAMER1_ID'
        Footers = <>
        Visible = False
        Width = 20
      end
      item
        EditButtons = <
          item
            Action = actAGamer1
          end>
        FieldName = 'AGAMER1_NM'
        Footers = <>
        Title.Caption = #1059#1095#1072#1089#1090#1085#1080#1082' 1'
        Width = 200
      end
      item
        EditButtons = <>
        FieldName = 'AGAMER2_ID'
        Footers = <>
        Visible = False
      end
      item
        EditButtons = <
          item
            Action = actAGamer2
          end>
        FieldName = 'AGAMER2_NM'
        Footers = <>
        Title.Caption = #1059#1095#1072#1089#1090#1085#1080#1082' 2'
        Width = 200
      end
      item
        EditButtons = <>
        FieldName = 'COMPLETE_FLG'
        Footers = <>
        Visible = False
      end
      item
        AutoFitColWidth = False
        Checkboxes = True
        EditButtons = <>
        FieldName = 'IGNORE_FLG'
        Footers = <>
        KeyList.Strings = (
          '1'
          '0')
        Title.Caption = 'Ignore'
        Width = 40
      end>
  end
  inherited Panel: TGvCollapsePanel
    Top = 218
    Width = 822
    Height = 300
    ExpandedHeight = 300
    State = csExpand
    inherited pcDetail: TPageControl
      Width = 820
      Height = 282
      ActivePage = tsTournirs
      object tsTournirs: TTabSheet
        Caption = #1058#1091#1088#1085#1080#1088#1099
        object gridTournirs: TDBGridEh
          Left = 0
          Top = 0
          Width = 812
          Height = 254
          Align = alClient
          AutoFitColWidths = True
          Color = clBtnFace
          ColumnDefValues.Title.Alignment = taCenter
          DataSource = dsTournirs
          Flat = True
          FooterColor = clWindow
          FooterFont.Charset = DEFAULT_CHARSET
          FooterFont.Color = clWindowText
          FooterFont.Height = -11
          FooterFont.Name = 'MS Sans Serif'
          FooterFont.Style = []
          ReadOnly = True
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          OnGetCellParams = gridMainGetCellParams
          Columns = <
            item
              EditButtons = <>
              FieldName = 'TOURNIR_ID'
              Footers = <>
              Visible = False
            end
            item
              EditButtons = <>
              FieldName = 'BOOKER_ID'
              Footers = <>
              Visible = False
            end
            item
              AutoFitColWidth = False
              EditButtons = <>
              FieldName = 'BOOKER_NM'
              Footers = <>
              Title.Caption = #1041#1091#1082#1084#1077#1082#1077#1088
              Width = 100
            end
            item
              EditButtons = <>
              FieldName = 'BSPORT_ID'
              Footers = <>
              Visible = False
            end
            item
              EditButtons = <>
              FieldName = 'TOURNIR_NM'
              Footers = <>
              Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1090#1091#1088#1085#1080#1088#1072
              Width = 300
            end
            item
              EditButtons = <>
              FieldName = 'ASPORT_ID'
              Footers = <>
              Visible = False
            end
            item
              EditButtons = <>
              FieldName = 'ASPORT_NM'
              Footers = <>
              Visible = False
            end
            item
              AutoFitColWidth = False
              EditButtons = <>
              FieldName = 'COUNTRY_SGN'
              Footers = <>
              Title.Caption = #1057#1090#1088#1072#1085#1072
              Width = 40
            end
            item
              Alignment = taCenter
              AutoFitColWidth = False
              EditButtons = <>
              FieldName = 'USED_DT'
              Footers = <>
              Title.Caption = 'Last Use'
              Width = 60
            end
            item
              EditButtons = <>
              FieldName = 'IGNORE_FLG'
              Footers = <>
              Visible = False
            end>
        end
      end
      object tsEvents: TTabSheet
        Caption = 'tsEvents'
        ImageIndex = 1
        object DBGridEh1: TDBGridEh
          Left = 0
          Top = 0
          Width = 812
          Height = 254
          Align = alClient
          AutoFitColWidths = True
          Color = clBtnFace
          Flat = True
          FooterColor = clWindow
          FooterFont.Charset = DEFAULT_CHARSET
          FooterFont.Color = clWindowText
          FooterFont.Height = -11
          FooterFont.Name = 'MS Sans Serif'
          FooterFont.Style = []
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
        end
      end
      object tsAGamers: TTabSheet
        Caption = #1059#1095#1072#1089#1090#1085#1080#1082#1080
        ImageIndex = 2
        object DBGridEh2: TDBGridEh
          Left = 0
          Top = 0
          Width = 812
          Height = 254
          Align = alClient
          Color = clBtnFace
          Flat = True
          FooterColor = clWindow
          FooterFont.Charset = DEFAULT_CHARSET
          FooterFont.Color = clWindowText
          FooterFont.Height = -11
          FooterFont.Name = 'MS Sans Serif'
          FooterFont.Style = []
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
        end
      end
    end
  end
  inherited ActionList: TActionList
    object actAGamer1: TAction
      Caption = 'actAGamer1'
    end
    object actAGamer2: TAction
      Caption = 'actAGamer2'
    end
  end
  object cdsTournirs: TpFIBClientDataSet
    Aggregates = <>
    IndexFieldNames = 'TOURNIR_ID'
    MasterFields = 'TOURNIR_ID'
    MasterSource = dsMain
    PacketRecords = 0
    Params = <>
    ProviderName = 'dspTournirs'
    Left = 152
    Top = 72
    object cdsTournirsTOURNIR_ID: TIntegerField
      FieldName = 'TOURNIR_ID'
    end
    object cdsTournirsBOOKER_ID: TSmallintField
      FieldName = 'BOOKER_ID'
    end
    object cdsTournirsBOOKER_NM: TStringField
      FieldName = 'BOOKER_NM'
      Size = 25
    end
    object cdsTournirsBSPORT_ID: TIntegerField
      FieldName = 'BSPORT_ID'
    end
    object cdsTournirsTOURNIR_NM: TStringField
      FieldName = 'TOURNIR_NM'
      Size = 250
    end
    object cdsTournirsASPORT_ID: TIntegerField
      FieldName = 'ASPORT_ID'
    end
    object cdsTournirsASPORT_NM: TStringField
      FieldName = 'ASPORT_NM'
      Size = 25
    end
    object cdsTournirsCOUNTRY_SGN: TStringField
      FieldName = 'COUNTRY_SGN'
      Size = 3
    end
    object cdsTournirsUSED_DT: TDateField
      FieldName = 'USED_DT'
    end
    object cdsTournirsIGNORE_FLG: TSmallintField
      FieldName = 'IGNORE_FLG'
    end
  end
  object dspTournirs: TpFIBDataSetProvider
    Left = 184
    Top = 72
  end
  object dsTournirs: TDataSource
    DataSet = cdsTournirs
    Left = 216
    Top = 72
  end
  object cdsSubEvents: TpFIBClientDataSet
    Aggregates = <>
    Params = <>
    Left = 152
    Top = 104
  end
  object dspSubEvents: TpFIBDataSetProvider
    DataSet = dmSwim.tblEvents
    Left = 184
    Top = 104
  end
  object dsSubEvents: TDataSource
    AutoEdit = False
    DataSet = cdsSubEvents
    Left = 216
    Top = 104
  end
  object cdsAGamers: TpFIBClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspAGamers'
    Left = 152
    Top = 136
  end
  object dspAGamers: TpFIBDataSetProvider
    DataSet = dmSwim.tblAGamers
    Left = 184
    Top = 136
  end
end
