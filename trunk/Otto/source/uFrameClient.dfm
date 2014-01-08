inherited FrameClient: TFrameClient
  inherited pnlFrame: TPanel
    Width = 145
    inherited sBarFrame: TTBXStatusBar
      Width = 135
    end
    inherited dckTop: TTBXDock
      Width = 135
    end
  end
  object pnlCenterOnClient: TPanel [1]
    Left = 0
    Top = 0
    Width = 145
    Height = 266
    Align = alClient
    BorderWidth = 4
    TabOrder = 1
    object splitClient: TJvNetscapeSplitter
      Left = 5
      Top = 106
      Width = 135
      Height = 10
      Cursor = crVSplit
      Align = alBottom
      Maximized = False
      Minimized = False
      ButtonCursor = crDefault
    end
    object grdClient: TDBGridEh
      Left = 5
      Top = 5
      Width = 135
      Height = 101
      Align = alClient
      AutoFitColWidths = True
      DataSource = dsClients
      DynProps = <>
      Flat = True
      FooterParams.Color = clWindow
      IndicatorOptions = [gioShowRowIndicatorEh]
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking, dghIncSearch, dghPreferIncSearch, dghRowHighlight, dghDialogFind, dghColumnResize, dghColumnMove, dghHotTrack, dghExtendVertLines]
      ReadOnly = True
      RowDetailPanel.Height = 34
      RowDetailPanel.ParentColor = True
      TabOrder = 0
      OnDblClick = grdClientDblClick
      Columns = <
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'FIO_TEXT'
          Footers = <>
          Title.Alignment = taCenter
          Title.Caption = #1060#1072#1084#1080#1083#1080#1103', '#1048#1084#1103', '#1054#1090#1095#1077#1089#1090#1074#1086
          Width = 300
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'PLACE_TEXT'
          Footers = <>
          Title.Alignment = taCenter
          Title.Caption = #1043#1086#1088#1086#1076' '#1087#1088#1086#1078#1080#1074#1072#1085#1080#1103
          Width = 230
          InRowLinePos = 1
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'ADRESS_TEXT'
          Footers = <>
          Title.Alignment = taCenter
          Title.Caption = #1040#1076#1088#1077#1089
          Width = 230
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'EMAIL'
          Footers = <>
          Title.Alignment = taCenter
          Title.Caption = 'e-Mail'
          Width = 150
          InRowLinePos = 1
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'STATUS_ID'
          Footers = <>
          Title.Alignment = taCenter
          Visible = False
          InRowLinePos = 1
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'MOBILE_PHONE'
          Footers = <>
          Title.Alignment = taCenter
          Title.Caption = #1052#1086#1073#1080#1083#1100#1085#1099#1081
          Width = 120
          InRowLinePos = 1
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'STATUS_NAME'
          Footers = <>
          Title.Alignment = taCenter
          Title.Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077
          Width = 110
          InRowLinePos = 1
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
    object grdClientOrders: TDBGridEh
      Left = 5
      Top = 116
      Width = 135
      Height = 145
      Align = alBottom
      AutoFitColWidths = True
      DataSource = dsClientOrders
      DynProps = <>
      Flat = True
      FooterRowCount = 1
      FooterParams.Color = clWindow
      IndicatorOptions = [gioShowRowIndicatorEh]
      RowDetailPanel.Active = True
      TabOrder = 1
      Columns = <
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'ORDER_ID'
          Footers = <>
          Title.Alignment = taCenter
          Visible = False
        end
        item
          AutoFitColWidth = False
          DynProps = <>
          EditButtons = <>
          FieldName = 'ORDER_CODE'
          Footers = <>
          Title.Alignment = taCenter
          Title.Caption = #1050#1086#1076' '#1079#1072#1103#1074#1082#1080
          Width = 80
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'PRODUCT_ID'
          Footers = <>
          Title.Alignment = taCenter
          Visible = False
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
          FieldName = 'ADRESS_ID'
          Footers = <>
          Title.Alignment = taCenter
          Visible = False
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'CREATE_DTM'
          Footers = <>
          Title.Alignment = taCenter
          Title.Caption = #1044#1072#1090#1072' '#1079#1072#1103#1074#1082#1080
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'STATUS_ID'
          Footers = <>
          Title.Alignment = taCenter
          Visible = False
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'STATUS_NAME'
          Footers = <>
          Title.Alignment = taCenter
          Title.Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077
          Width = 150
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'STATUS_DTM'
          Footers = <>
          Title.Alignment = taCenter
          Title.Caption = #1054#1073#1085#1086#1074#1083#1077#1085
        end
        item
          AutoFitColWidth = False
          DynProps = <>
          EditButtons = <>
          FieldName = 'BAR_CODE'
          Footers = <>
          Title.Caption = #1050#1086#1076' '#1087#1086#1089#1099#1083#1082#1080
          Width = 100
        end>
      object RowDetailData: TRowDetailPanelControlEh
        object grdClientOrderItems: TDBGridEh
          Left = 0
          Top = 0
          Width = 100
          Height = 93
          Align = alClient
          AutoFitColWidths = True
          DataSource = dsClientOrderItems
          DynProps = <>
          Flat = True
          FooterParams.Color = clWindow
          IndicatorOptions = [gioShowRowIndicatorEh]
          TabOrder = 0
          Columns = <
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'ORDER_ID'
              Footers = <>
              Visible = False
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'ORD'
              Footers = <>
              Visible = False
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'SUBJECT_ID'
              Footers = <>
              Visible = False
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'SUBJECT_NAME'
              Footers = <>
              Title.Caption = #1040#1088#1090#1080#1082#1091#1083', '#1057#1073#1086#1088
              Width = 200
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'DIMENSION'
              Footers = <>
              Title.Caption = #1056#1072#1079#1084#1077#1088
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'WEIGHT'
              Footers = <>
              Title.Caption = #1042#1077#1089', '#1075
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'PRICE_EUR'
              Footers = <>
              Title.Caption = #1062#1077#1085#1072', EUR'
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'AMOUNT'
              Footers = <>
              Title.Caption = #1050#1086#1083'-'#1074#1086
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'COST_EUR'
              Footers = <>
              Title.Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'NAME_RUS'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'KIND_RUS'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'STATUS_NAME'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'COUNT_WEIGHT'
              Footers = <>
              Visible = False
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'COST_BYR'
              Footers = <>
              Visible = False
            end>
          object RowDetailData: TRowDetailPanelControlEh
          end
        end
      end
    end
  end
  object pnlRightOnClient: TPanel [2]
    Left = 145
    Top = 0
    Width = 290
    Height = 266
    Align = alRight
    BorderWidth = 4
    Constraints.MaxWidth = 290
    Constraints.MinWidth = 290
    TabOrder = 2
    object grBoxClient: TJvGroupBox
      Left = 5
      Top = 5
      Width = 280
      Height = 184
      Align = alTop
      Caption = #1050#1083#1080#1077#1085#1090' ('#1053#1086#1074#1099#1081')'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 0
      PropagateEnable = True
      object lblLastName: TLabel
        Left = 8
        Top = 24
        Width = 65
        Height = 21
        AutoSize = False
        Caption = #1060#1072#1084#1080#1083#1080#1103
        Layout = tlCenter
      end
      object lblFirstName: TLabel
        Left = 8
        Top = 48
        Width = 65
        Height = 21
        AutoSize = False
        Caption = #1048#1084#1103
        Layout = tlCenter
      end
      object lblMidName: TLabel
        Left = 8
        Top = 72
        Width = 65
        Height = 21
        AutoSize = False
        Caption = #1054#1090#1095#1077#1089#1090#1074#1086
        Layout = tlCenter
      end
      object lblMobilePhone: TLabel
        Left = 8
        Top = 96
        Width = 65
        Height = 21
        AutoSize = False
        Caption = #1052#1086#1073#1080#1083#1100#1085#1099#1081
        Layout = tlCenter
      end
      object lbl1: TLabel
        Left = 8
        Top = 144
        Width = 65
        Height = 21
        AutoSize = False
        Caption = 'e-Mail'
        Layout = tlCenter
      end
      object lblStacionarPhone: TLabel
        Left = 8
        Top = 120
        Width = 65
        Height = 21
        AutoSize = False
        Caption = #1057#1090#1072#1094#1080#1086#1085#1072#1088'.'
        Layout = tlCenter
      end
      object dedLastName: TDBEditEh
        Tag = 4
        Left = 80
        Top = 24
        Width = 169
        Height = 21
        AutoSize = False
        DynProps = <>
        EditButtons = <
          item
            Action = actClientSearch
            Style = ebsEllipsisEh
          end>
        TabOrder = 0
        Visible = True
        OnEnter = EditEnter
        OnExit = dedLastNameExit
        OnKeyDown = EditKeyDown
        OnKeyPress = dedLastNameKeyPress
      end
      object dedFirstName: TDBEditEh
        Tag = 4
        Left = 80
        Top = 48
        Width = 169
        Height = 21
        DynProps = <>
        EditButtons = <>
        TabOrder = 1
        Visible = True
        OnEnter = EditEnter
        OnExit = NameExit
        OnKeyDown = EditKeyDown
        OnKeyPress = dedLastNameKeyPress
      end
      object dedMidName: TDBEditEh
        Tag = 4
        Left = 80
        Top = 72
        Width = 169
        Height = 21
        DynProps = <>
        EditButtons = <>
        TabOrder = 2
        Visible = True
        OnEnter = EditEnter
        OnExit = NameExit
        OnKeyDown = EditKeyDown
        OnKeyPress = dedLastNameKeyPress
      end
      object dedEmail: TDBEditEh
        Tag = 2
        Left = 80
        Top = 144
        Width = 169
        Height = 21
        DynProps = <>
        EditButtons = <>
        TabOrder = 5
        Visible = True
        OnEnter = EditEnter
        OnExit = dedEmailExit
        OnKeyDown = EditKeyDown
      end
      object dedStaticPhone: TDBEditEh
        Left = 80
        Top = 120
        Width = 169
        Height = 21
        DynProps = <>
        EditButtons = <>
        TabOrder = 4
        Visible = True
        OnEnter = EditEnter
        OnKeyDown = EditKeyDown
      end
      object dedMobilPhone: TDBEditEh
        Left = 80
        Top = 96
        Width = 169
        Height = 21
        DynProps = <>
        EditButtons = <>
        TabOrder = 3
        Visible = True
        OnEnter = EditEnter
        OnKeyDown = EditKeyDown
      end
    end
    object grBoxAdress: TJvGroupBox
      Left = 5
      Top = 189
      Width = 280
      Height = 72
      Align = alClient
      Caption = #1040#1076#1088#1077#1089
      TabOrder = 1
      object txtAdress: TStaticText
        Left = 2
        Top = 15
        Width = 276
        Height = 55
        Align = alClient
        AutoSize = False
        BorderStyle = sbsSunken
        TabOrder = 0
      end
    end
  end
  inherited actList: TActionList
    object actClientSearch: TAction
      Caption = #1053#1072#1081#1090#1080
      OnExecute = actClientSearchExecute
    end
  end
  object trnWrite: TpFIBTransaction
    TimeoutAction = TARollback
  end
  object qryClient: TpFIBDataSet
    SelectSQL.Strings = (
      'select ca.*, s2.status_name'
      
        'from search(:i_value, '#39'clients'#39', '#39'client_id'#39', '#39'last_name'#39', null,' +
        ' 50) s'
      'left join v_clientadress ca on (ca.client_id = s.o_object_id)'
      'inner join statuses s2 on (s2.status_id = ca.status_id)'
      'order by s.o_valid, ca.fio_text')
    Transaction = trnWrite
    Database = dmOtto.dbOtto
    Left = 152
    Top = 96
    object fldClientCLIENT_ID: TFIBIntegerField
      FieldName = 'CLIENT_ID'
    end
    object fldClientFIO_TEXT: TFIBStringField
      FieldName = 'FIO_TEXT'
      Size = 100
      EmptyStrToNull = True
    end
    object fldClientLAST_NAME: TFIBStringField
      FieldName = 'LAST_NAME'
      Size = 100
      EmptyStrToNull = True
    end
    object fldClientFIRST_NAME: TFIBStringField
      FieldName = 'FIRST_NAME'
      Size = 100
      EmptyStrToNull = True
    end
    object fldClientMID_NAME: TFIBStringField
      FieldName = 'MID_NAME'
      Size = 100
      EmptyStrToNull = True
    end
    object fldClientSTATUS_ID: TFIBIntegerField
      FieldName = 'STATUS_ID'
    end
    object fldClientMOBILE_PHONE: TFIBStringField
      FieldName = 'MOBILE_PHONE'
      Size = 50
      EmptyStrToNull = True
    end
    object fldClientEMAIL: TFIBStringField
      FieldName = 'EMAIL'
      Size = 4000
      EmptyStrToNull = True
    end
    object fldClientPLACE_ID: TFIBIntegerField
      FieldName = 'PLACE_ID'
    end
    object fldClientPLACE_TEXT: TFIBStringField
      FieldName = 'PLACE_TEXT'
      Size = 398
      EmptyStrToNull = True
    end
    object fldClientADRESS_ID: TFIBIntegerField
      FieldName = 'ADRESS_ID'
    end
    object fldClientADRESS_TEXT: TFIBStringField
      FieldName = 'ADRESS_TEXT'
      Size = 177
      EmptyStrToNull = True
    end
    object fldClientSTATUS_NAME: TFIBStringField
      FieldName = 'STATUS_NAME'
      Size = 100
      EmptyStrToNull = True
    end
  end
  object dsClients: TDataSource
    AutoEdit = False
    DataSet = qryClient
    Left = 208
    Top = 96
  end
  object qryClientOrders: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    o.ORDER_ID,'
      '    o.ORDER_CODE,'
      '    o.PRODUCT_ID,'
      '    o.CLIENT_ID,'
      '    o.ADRESS_ID,'
      '    o.CREATE_DTM,'
      '    o.STATUS_ID,'
      '    s.STATUS_NAME,'
      '    o.STATUS_DTM,'
      '    o.BAR_CODE'
      'FROM ORDERS o'
      '  inner join statuses s on (s.status_id = o.status_id)'
      'WHERE '
      '    CLIENT_ID = :CLIENT_ID'
      'ORDER BY'
      '    CREATE_DTM DESC')
    Transaction = trnWrite
    Database = dmOtto.dbOtto
    DataSource = dsClients
    Left = 152
    Top = 142
  end
  object dsClientOrders: TDataSource
    AutoEdit = False
    DataSet = qryClientOrders
    Left = 208
    Top = 144
  end
  object qryClientOrderItems: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    ORDER_ID,'
      '    ORD,'
      '    SUBJECT_ID,'
      '    SUBJECT_NAME,'
      '    DIMENSION,'
      '    WEIGHT,'
      '    PRICE_EUR,'
      '    AMOUNT,'
      '    COST_EUR,'
      '    NAME_RUS,'
      '    KIND_RUS,'
      '    STATUS_NAME,'
      '    COUNT_WEIGHT,'
      '    COST_BYR'
      'FROM'
      '    V_ORDER_FULL_SPECIFICATION '
      'WHERE ORDER_ID = :ORDER_ID'
      'ORDER BY ORD, SUBJECT_ID')
    Transaction = trnWrite
    Database = dmOtto.dbOtto
    DataSource = dsClientOrders
    Left = 152
    Top = 190
  end
  object dsClientOrderItems: TDataSource
    AutoEdit = False
    DataSet = qryClientOrderItems
    Left = 207
    Top = 190
  end
end
