inherited FrameAdress: TFrameAdress
  Width = 920
  Height = 450
  Constraints.MinHeight = 450
  inherited dckTop: TTBXDock
    Width = 920
  end
  inherited sb: TTBXStatusBar
    Top = 428
    Width = 920
  end
  inherited pnl1: TJvPanel
    Width = 920
    Height = 402
    object pnlRightOnAdress: TJvPanel
      Left = 626
      Top = 4
      Width = 290
      Height = 394
      HotTrackFont.Charset = DEFAULT_CHARSET
      HotTrackFont.Color = clWindowText
      HotTrackFont.Height = -11
      HotTrackFont.Name = 'MS Sans Serif'
      HotTrackFont.Style = []
      Align = alRight
      BorderWidth = 4
      Constraints.MaxWidth = 290
      Constraints.MinWidth = 290
      TabOrder = 0
      object grBoxAdress: TJvGroupBox
        Left = 5
        Top = 238
        Width = 280
        Height = 151
        Align = alBottom
        Caption = #1040#1076#1088#1077#1089' ('#1053#1086#1074#1099#1081')'
        TabOrder = 1
        object lblPostIndex: TLabel
          Left = 8
          Top = 16
          Width = 49
          Height = 21
          AutoSize = False
          Caption = #1048#1085#1076#1077#1082#1089
          Layout = tlCenter
        end
        object lblStreetType: TLabel
          Left = 8
          Top = 40
          Width = 49
          Height = 21
          AutoSize = False
          Caption = #1059#1083#1080#1094#1072
          Layout = tlCenter
        end
        object lblFlat: TLabel
          Left = 8
          Top = 112
          Width = 57
          Height = 21
          AutoSize = False
          Caption = #1050#1074#1072#1088#1090#1080#1088#1072
          Layout = tlCenter
        end
        object lblBuilding: TLabel
          Left = 8
          Top = 88
          Width = 49
          Height = 21
          AutoSize = False
          Caption = #1050#1086#1088#1087#1091#1089
          Layout = tlCenter
        end
        object lblHouse: TLabel
          Left = 8
          Top = 64
          Width = 49
          Height = 21
          AutoSize = False
          Caption = #1044#1086#1084
          Layout = tlCenter
        end
        object medPostIndex: TJvMaskEdit
          Left = 64
          Top = 16
          Width = 55
          Height = 21
          EditMask = '000000;0;_'
          MaxLength = 6
          TabOrder = 0
          OnEnter = SetKeyLayout
          OnKeyDown = EditKeyDown
        end
        object cbStreetType: TDBComboBoxEh
          Left = 64
          Top = 40
          Width = 57
          Height = 21
          EditButtons = <>
          TabOrder = 1
          Visible = True
          OnEnter = SetKeyLayout
          OnKeyDown = EditKeyDown
        end
        object dedStreetName: TDBEditEh
          Tag = 4
          Left = 144
          Top = 40
          Width = 105
          Height = 21
          EditButtons = <>
          TabOrder = 2
          Visible = True
          OnEnter = SetKeyLayout
          OnKeyDown = EditKeyDown
        end
        object dedFlat: TDBEditEh
          Left = 64
          Top = 112
          Width = 57
          Height = 21
          EditButtons = <>
          TabOrder = 5
          Visible = True
          OnEnter = SetKeyLayout
          OnKeyDown = EditKeyDown
        end
        object dedBuilding: TDBEditEh
          Left = 64
          Top = 88
          Width = 57
          Height = 21
          EditButtons = <>
          TabOrder = 4
          Visible = True
          OnEnter = SetKeyLayout
          OnKeyDown = EditKeyDown
        end
        object dedHouse: TDBEditEh
          Left = 64
          Top = 64
          Width = 57
          Height = 21
          EditButtons = <>
          TabOrder = 3
          Visible = True
          OnEnter = SetKeyLayout
          OnKeyDown = EditKeyDown
        end
      end
      object grBoxPlace: TJvGroupBox
        Left = 5
        Top = 118
        Width = 280
        Height = 120
        Align = alBottom
        Caption = #1053#1072#1089#1077#1083#1077#1085#1085#1099#1081' '#1087#1091#1085#1082#1090' ('#1053#1086#1074#1099#1081')'
        TabOrder = 0
        object lbl2: TLabel
          Left = 8
          Top = 16
          Width = 65
          Height = 21
          AutoSize = False
          Caption = #1058#1080#1087' '#1053#1055
          Layout = tlCenter
        end
        object lblPlace: TLabel
          Left = 8
          Top = 40
          Width = 65
          Height = 21
          AutoSize = False
          Caption = #1053#1072#1089#1077#1083'. '#1087#1091#1085#1082#1090
          Layout = tlCenter
        end
        object lblArea: TLabel
          Left = 8
          Top = 64
          Width = 65
          Height = 21
          AutoSize = False
          Caption = #1056#1072#1081#1086#1085
          Layout = tlCenter
        end
        object lblRegion: TLabel
          Left = 8
          Top = 88
          Width = 65
          Height = 21
          AutoSize = False
          Caption = #1054#1073#1083#1072#1089#1090#1100
          Layout = tlCenter
        end
        object cbPlaceType: TDBComboBoxEh
          Left = 80
          Top = 16
          Width = 57
          Height = 21
          EditButtons = <>
          TabOrder = 0
          Visible = True
          OnChange = cbPlaceTypeChange
          OnEnter = SetKeyLayout
          OnKeyDown = EditKeyDown
        end
        object dedPlaceName: TDBEditEh
          Tag = 4
          Left = 80
          Top = 40
          Width = 169
          Height = 19
          EditButtons = <
            item
              Style = ebsEllipsisEh
              Width = 16
            end>
          Flat = True
          TabOrder = 1
          Visible = True
          OnEnter = SetKeyLayout
          OnExit = dedPlaceNameExit
          OnKeyDown = EditKeyDown
        end
        object cbAreaName: TDBComboBoxEh
          Tag = 4
          Left = 80
          Top = 64
          Width = 167
          Height = 21
          EditButtons = <>
          TabOrder = 2
          Visible = True
          OnEnter = SetKeyLayout
          OnKeyDown = EditKeyDown
        end
        object dedRegionName: TDBEditEh
          Left = 80
          Top = 88
          Width = 169
          Height = 21
          TabStop = False
          Color = clBtnFace
          EditButtons = <>
          ReadOnly = True
          TabOrder = 3
          Visible = True
        end
      end
      object grBoxClient: TJvGroupBox
        Left = 5
        Top = 5
        Width = 280
        Height = 113
        Align = alClient
        Caption = #1050#1083#1080#1077#1085#1090' ('#1053#1086#1074#1099#1081')'
        TabOrder = 2
        PropagateEnable = True
        object txtClientName: TStaticText
          Left = 2
          Top = 15
          Width = 276
          Height = 96
          Align = alClient
          AutoSize = False
          BorderStyle = sbsSunken
          TabOrder = 0
        end
      end
    end
    object pnlCenterOnAdress: TPanel
      Left = 4
      Top = 4
      Width = 622
      Height = 394
      Align = alClient
      BorderWidth = 4
      Caption = 'pCenter'
      TabOrder = 1
      object split1: TJvNetscapeSplitter
        Left = 5
        Top = 203
        Width = 612
        Height = 10
        Cursor = crVSplit
        Align = alBottom
        Maximized = False
        Minimized = False
        ButtonCursor = crDefault
      end
      object grBoxgb2: TJvGroupBox
        Left = 5
        Top = 5
        Width = 612
        Height = 193
        Align = alTop
        Caption = #1053#1072#1089#1077#1083#1077#1085#1085#1099#1077' '#1087#1091#1085#1082#1090#1099
        TabOrder = 0
        object grdPlaces: TDBGridEh
          Left = 2
          Top = 15
          Width = 608
          Height = 176
          TabStop = False
          Align = alClient
          AutoFitColWidths = True
          Ctl3D = True
          DataGrouping.GroupLevels = <>
          DataSource = dsPlaces
          Flat = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          FooterColor = clWindow
          FooterFont.Charset = DEFAULT_CHARSET
          FooterFont.Color = clWindowText
          FooterFont.Height = -11
          FooterFont.Name = 'MS Sans Serif'
          FooterFont.Style = []
          Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
          OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking, dghIncSearch, dghPreferIncSearch, dghRowHighlight, dghExtendVertLines]
          ParentCtl3D = False
          ParentFont = False
          RowDetailPanel.Color = clBtnFace
          STFilter.InstantApply = True
          STFilter.Local = True
          STFilter.Location = stflInTitleFilterEh
          STFilter.Visible = True
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          OnDblClick = grdPlacesDblClick
          Columns = <
            item
              EditButtons = <>
              FieldName = 'PLACETYPE_SIGN'
              Footers = <>
              Title.Alignment = taCenter
              Title.Caption = #1058#1080#1087' '#1053#1055
              Title.TitleButton = True
              Width = 50
            end
            item
              EditButtons = <>
              FieldName = 'PLACE_NAME'
              Footers = <>
              Title.Alignment = taCenter
              Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
              Title.TitleButton = True
              Width = 250
            end
            item
              EditButtons = <>
              FieldName = 'AREA_NAME'
              Footers = <>
              Title.Alignment = taCenter
              Title.Caption = #1056#1072#1081#1086#1085
              Title.TitleButton = True
              Width = 120
            end
            item
              EditButtons = <>
              FieldName = 'REGION_NAME'
              Footers = <>
              Title.Alignment = taCenter
              Title.Caption = #1054#1073#1083#1072#1089#1090#1100
              Title.TitleButton = True
              Title.ToolTips = True
              Width = 120
            end>
          object RowDetailData: TRowDetailPanelControlEh
          end
        end
      end
      object grBoxgb1: TJvGroupBox
        Left = 5
        Top = 213
        Width = 612
        Height = 176
        Align = alBottom
        Caption = #1040#1076#1088#1077#1089#1072
        TabOrder = 1
        object grdAdresses: TDBGridEh
          Left = 2
          Top = 15
          Width = 608
          Height = 159
          TabStop = False
          Align = alBottom
          AutoFitColWidths = True
          DataGrouping.GroupLevels = <>
          DataSource = dsAdresses
          Flat = True
          FooterColor = clWindow
          FooterFont.Charset = DEFAULT_CHARSET
          FooterFont.Color = clWindowText
          FooterFont.Height = -11
          FooterFont.Name = 'MS Sans Serif'
          FooterFont.Style = []
          RowDetailPanel.Color = clBtnFace
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          OnDblClick = grdAdressesDblClick
          Columns = <
            item
              EditButtons = <>
              FieldName = 'ADRESS_ID'
              Footers = <>
              Title.Alignment = taCenter
              Visible = False
            end
            item
              EditButtons = <>
              FieldName = 'PLACE_ID'
              Footers = <>
              Title.Alignment = taCenter
              Visible = False
            end
            item
              EditButtons = <>
              FieldName = 'PLACE_TEXT'
              Footers = <>
              Title.Alignment = taCenter
              Title.Caption = #1052#1077#1089#1090#1086' '#1087#1088#1086#1078#1080#1074#1072#1085#1080#1103
              Width = 250
            end
            item
              EditButtons = <>
              FieldName = 'CLIENT_ID'
              Footers = <>
              Title.Alignment = taCenter
              Visible = False
            end
            item
              EditButtons = <>
              FieldName = 'ADRESS_TEXT'
              Footers = <>
              Title.Alignment = taCenter
              Title.Caption = #1040#1076#1088#1077#1089
              Width = 300
            end
            item
              EditButtons = <>
              FieldName = 'STATUS_ID'
              Footers = <>
              Title.Alignment = taCenter
              Visible = False
            end>
          object RowDetailData: TRowDetailPanelControlEh
          end
        end
      end
    end
  end
  inherited actList: TActionList
    object actPlaceSearch: TAction
      Caption = 'actPlaceSearch'
      OnExecute = actPlaceSearchExecute
    end
  end
  object qryAdresses: TpFIBDataSet
    SelectSQL.Strings = (
      'select a.*, vp.place_text, va.adress_text'
      'from adresses a'
      'inner join v_adress_text va on (va.adress_id = a.adress_id)'
      'inner join v_place_text vp on (vp.place_id = a.place_id)'
      'where a.client_id = :CLIENT_ID')
    Transaction = trnWrite
    Database = dmOtto.dbOtto
    Left = 128
    Top = 160
  end
  object dsAdresses: TDataSource
    AutoEdit = False
    DataSet = qryAdresses
    Left = 184
    Top = 160
  end
  object qryPlaces: TpFIBDataSet
    SelectSQL.Strings = (
      
        'select v.* from search(:i_value, '#39'v_places'#39', '#39'place_id'#39', '#39'place_' +
        'name'#39', null, 50) s'
      '  inner join v_places v on (v.place_id = s.o_object_id)'
      'order by v.place_name')
    Transaction = trnWrite
    Database = dmOtto.dbOtto
    Left = 128
    Top = 112
  end
  object dsPlaces: TDataSource
    AutoEdit = False
    DataSet = qryPlaces
    Left = 184
    Top = 112
  end
end
