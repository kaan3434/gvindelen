inherited FrameAdress: TFrameAdress
  Height = 450
  Constraints.MinHeight = 450
  inherited pnlFrame: TPanel
    Width = 145
    Height = 450
    inherited sBarFrame: TTBXStatusBar
      Width = 135
    end
    inherited dckTop: TTBXDock
      Width = 135
    end
  end
  object pnlRightOnAdress: TJvPanel [1]
    Left = 145
    Top = 0
    Width = 290
    Height = 450
    HotTrackFont.Charset = DEFAULT_CHARSET
    HotTrackFont.Color = clWindowText
    HotTrackFont.Height = -11
    HotTrackFont.Name = 'MS Sans Serif'
    HotTrackFont.Style = []
    Align = alRight
    BorderWidth = 4
    Constraints.MaxWidth = 290
    Constraints.MinWidth = 290
    TabOrder = 2
    object grBoxAdress: TJvGroupBox
      Left = 5
      Top = 294
      Width = 280
      Height = 151
      Align = alBottom
      Caption = #1040#1076#1088#1077#1089' ('#1053#1086#1074#1099#1081')'
      TabOrder = 2
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
        OnKeyPress = AddressChanged
      end
      object cbStreetType: TDBComboBoxEh
        Left = 64
        Top = 40
        Width = 57
        Height = 21
        DynProps = <>
        EditButtons = <>
        TabOrder = 1
        Visible = True
        OnEnter = SetKeyLayout
        OnKeyDown = EditKeyDown
        OnKeyPress = AddressChanged
      end
      object dedStreetName: TDBEditEh
        Tag = 4
        Left = 128
        Top = 40
        Width = 145
        Height = 21
        DynProps = <>
        EditButtons = <>
        TabOrder = 2
        Visible = True
        OnEnter = SetKeyLayout
        OnKeyDown = EditKeyDown
        OnKeyPress = AddressChanged
      end
      object dedFlat: TDBEditEh
        Left = 64
        Top = 112
        Width = 57
        Height = 21
        DynProps = <>
        EditButtons = <>
        TabOrder = 5
        Visible = True
        OnEnter = SetKeyLayout
        OnKeyDown = EditKeyDown
        OnKeyPress = AddressChanged
      end
      object dedBuilding: TDBEditEh
        Left = 64
        Top = 88
        Width = 57
        Height = 21
        DynProps = <>
        EditButtons = <>
        TabOrder = 4
        Visible = True
        OnEnter = SetKeyLayout
        OnKeyDown = EditKeyDown
        OnKeyPress = AddressChanged
      end
      object dedHouse: TDBEditEh
        Left = 64
        Top = 64
        Width = 57
        Height = 21
        DynProps = <>
        EditButtons = <>
        TabOrder = 3
        Visible = True
        OnEnter = SetKeyLayout
        OnKeyDown = EditKeyDown
        OnKeyPress = AddressChanged
      end
    end
    object grBoxPlace: TJvGroupBox
      Left = 5
      Top = 174
      Width = 280
      Height = 120
      Align = alBottom
      Caption = #1053#1072#1089#1077#1083#1077#1085#1085#1099#1081' '#1087#1091#1085#1082#1090' ('#1053#1086#1074#1099#1081')'
      TabOrder = 1
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
        DynProps = <>
        EditButtons = <>
        TabOrder = 0
        Visible = True
        OnChange = cbPlaceTypeChange
        OnEnter = SetKeyLayout
        OnKeyDown = EditKeyDown
        OnKeyPress = AddressChanged
      end
      object dedPlaceName: TDBEditEh
        Tag = 4
        Left = 80
        Top = 40
        Width = 193
        Height = 21
        DynProps = <>
        EditButtons = <
          item
            Style = ebsEllipsisEh
            Width = 16
          end>
        TabOrder = 1
        Visible = True
        OnEnter = SetKeyLayout
        OnExit = dedPlaceNameExit
        OnKeyDown = EditKeyDown
        OnKeyPress = AddressChanged
      end
      object cbAreaName: TDBComboBoxEh
        Tag = 4
        Left = 80
        Top = 64
        Width = 193
        Height = 21
        DynProps = <>
        EditButtons = <>
        TabOrder = 2
        Visible = False
        OnEnter = SetKeyLayout
        OnKeyDown = EditKeyDown
        OnKeyPress = AddressChanged
      end
      object dedRegionName: TDBEditEh
        Left = 80
        Top = 88
        Width = 193
        Height = 21
        TabStop = False
        Color = clBtnFace
        DynProps = <>
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
      Height = 169
      Align = alClient
      Caption = #1050#1083#1080#1077#1085#1090' ('#1053#1086#1074#1099#1081')'
      TabOrder = 0
      PropagateEnable = True
      object txtClientName: TStaticText
        Left = 2
        Top = 15
        Width = 276
        Height = 152
        Align = alClient
        AutoSize = False
        BorderStyle = sbsSunken
        TabOrder = 0
      end
    end
  end
  object pnlCenterOnAdress: TPanel [2]
    Left = 0
    Top = 0
    Width = 145
    Height = 450
    Align = alClient
    BorderWidth = 4
    Caption = 'pCenter'
    TabOrder = 1
    object split1: TJvNetscapeSplitter
      Left = 5
      Top = 259
      Width = 135
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
      Width = 135
      Height = 254
      Align = alClient
      Caption = #1053#1072#1089#1077#1083#1077#1085#1085#1099#1077' '#1087#1091#1085#1082#1090#1099
      TabOrder = 0
      object grdPlaces: TDBGridEh
        Left = 2
        Top = 15
        Width = 131
        Height = 237
        TabStop = False
        Align = alClient
        AutoFitColWidths = True
        Ctl3D = True
        DataSource = dsPlaces
        DynProps = <>
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        FooterParams.Color = clWindow
        IndicatorOptions = [gioShowRowIndicatorEh]
        Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking, dghIncSearch, dghPreferIncSearch, dghRowHighlight, dghExtendVertLines]
        ParentCtl3D = False
        ParentFont = False
        STFilter.InstantApply = True
        STFilter.Local = True
        STFilter.Location = stflInTitleFilterEh
        STFilter.Visible = True
        TabOrder = 0
        OnDblClick = grdPlacesDblClick
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'PLACETYPE_SIGN'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = #1058#1080#1087' '#1053#1055
            Title.TitleButton = True
            Width = 50
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'PLACE_NAME'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            Title.TitleButton = True
            Width = 250
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'AREA_NAME'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = #1056#1072#1081#1086#1085
            Title.TitleButton = True
            Width = 120
          end
          item
            DynProps = <>
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
      Top = 269
      Width = 135
      Height = 176
      Align = alBottom
      Caption = #1040#1076#1088#1077#1089#1072
      TabOrder = 1
      object grdAdresses: TDBGridEh
        Left = 2
        Top = 15
        Width = 131
        Height = 159
        TabStop = False
        Align = alBottom
        AutoFitColWidths = True
        DataSource = dsAdresses
        DynProps = <>
        Flat = True
        FooterParams.Color = clWindow
        IndicatorOptions = [gioShowRowIndicatorEh]
        TabOrder = 0
        OnDblClick = grdAdressesDblClick
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ADRESS_ID'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = 'Id'
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'PLACE_ID'
            Footers = <>
            Title.Alignment = taCenter
            Visible = False
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'PLACE_TEXT'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = #1052#1077#1089#1090#1086' '#1087#1088#1086#1078#1080#1074#1072#1085#1080#1103
            Width = 250
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'CLIENT_ID'
            Footers = <>
            Title.Alignment = taCenter
            Visible = False
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ADRESS_TEXT'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = #1040#1076#1088#1077#1089
            Width = 300
          end
          item
            DynProps = <>
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
  inherited actList: TActionList
    object actPlaceSearch: TAction
      Caption = 'actPlaceSearch'
      OnExecute = actPlaceSearchExecute
    end
  end
  object trnWrite: TpFIBTransaction
    TimeoutAction = TARollback
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
      
        'select v.*, s.o_valid from search(:i_value, '#39'v_places'#39', '#39'place_i' +
        'd'#39', '#39'place_name'#39', null, 50) s'
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
