object frmActionCodeSetup: TfrmActionCodeSetup
  Left = 122
  Top = 0
  Width = 1166
  Height = 680
  Caption = 'frmActionCodeSetup'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object spl2: TSplitter
    Left = 550
    Top = 0
    Height = 642
  end
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 550
    Height = 642
    Align = alLeft
    Caption = 'pnl1'
    TabOrder = 0
    object spl1: TSplitter
      Left = 1
      Top = 251
      Width = 548
      Height = 3
      Cursor = crVSplit
      Align = alTop
    end
    object spl5: TSplitter
      Left = 1
      Top = 488
      Width = 548
      Height = 3
      Cursor = crVSplit
      Align = alBottom
    end
    object pnl3: TPanel
      Left = 1
      Top = 1
      Width = 548
      Height = 250
      Align = alTop
      Caption = 'pnl3'
      TabOrder = 0
      object grdActionCodes: TDBGridEh
        Left = 1
        Top = 27
        Width = 546
        Height = 222
        Align = alClient
        DataSource = dsActionCodes
        DynProps = <>
        Flat = True
        IndicatorOptions = [gioShowRowIndicatorEh]
        TabOrder = 0
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
      object dckActionCode: TTBXDock
        Left = 1
        Top = 1
        Width = 546
        Height = 26
        object tbActionCodes: TTBXToolbar
          Left = 0
          Top = 0
          Caption = 'tbActionCodes'
          TabOrder = 0
        end
      end
    end
    inline frmParamActionCode: TFrame2
      Left = 1
      Top = 254
      Width = 548
      Height = 234
      Align = alClient
      TabOrder = 1
      inherited grdParams: TDBGridEh
        Width = 548
        Height = 209
      end
      inherited dckParams: TTBXDock
        Width = 548
      end
      inherited dsParams: TDataSource
        DataSet = qryActionCodeParams
      end
    end
    inline frmCritActionCode: TFrame1
      Left = 1
      Top = 491
      Width = 548
      Height = 150
      Align = alBottom
      TabOrder = 2
      inherited dckTop: TTBXDock
        Width = 548
      end
      inherited grdCriterias: TDBGridEh
        Width = 548
        Height = 124
      end
      inherited dsCriterias: TDataSource
        DataSet = qryActionCodeCrit
      end
    end
  end
  object pnl4: TPanel
    Left = 553
    Top = 0
    Width = 597
    Height = 642
    Align = alClient
    Caption = 'pnl4'
    TabOrder = 1
    object spl3: TSplitter
      Left = 1
      Top = 251
      Width = 595
      Height = 3
      Cursor = crVSplit
      Align = alTop
    end
    object spl4: TSplitter
      Left = 1
      Top = 488
      Width = 595
      Height = 3
      Cursor = crVSplit
      Align = alBottom
    end
    object pnl5: TPanel
      Left = 1
      Top = 1
      Width = 595
      Height = 250
      Align = alTop
      Caption = 'pnl5'
      TabOrder = 0
      object grdActionTree: TDBGridEh
        Left = 1
        Top = 27
        Width = 593
        Height = 222
        Align = alClient
        DataSource = dsActionTree
        DynProps = <>
        Flat = True
        IndicatorOptions = [gioShowRowIndicatorEh]
        TabOrder = 0
        Columns = <
          item
            Alignment = taCenter
            AutoFitColWidth = False
            DynProps = <>
            EditButtons = <>
            FieldName = 'ORDER_NO'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = #8470' '#1087'/'#1087
            Width = 40
          end
          item
            AutoFitColWidth = False
            DynProps = <>
            EditButtons = <>
            FieldName = 'CHILD_CODE'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = #1044#1077#1081#1089#1090#1074#1080#1077
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ACTION_SIGN'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = #1057#1080#1075#1085#1072#1090#1091#1088#1072
            Width = 100
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ACTION_NAME'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            Width = 150
          end
          item
            AutoFitColWidth = False
            DynProps = <>
            EditButtons = <>
            FieldName = 'OBJECT_SIGN'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = #1054#1073#1098#1077#1082#1090
            Width = 90
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
      object dckActionTree: TTBXDock
        Left = 1
        Top = 1
        Width = 593
        Height = 26
        object tbActionTree: TTBXToolbar
          Left = 0
          Top = 0
          Caption = 'tbActionTree'
          TabOrder = 0
        end
      end
    end
    inline frmCritActionTree: TFrame1
      Left = 1
      Top = 491
      Width = 595
      Height = 150
      Align = alBottom
      TabOrder = 1
      inherited dckTop: TTBXDock
        Width = 595
      end
      inherited grdCriterias: TDBGridEh
        Width = 595
        Height = 124
      end
    end
    inline frmParamActionTree: TFrame2
      Left = 1
      Top = 254
      Width = 595
      Height = 234
      Align = alClient
      TabOrder = 2
      inherited grdParams: TDBGridEh
        Width = 595
        Height = 209
      end
      inherited dckParams: TTBXDock
        Width = 595
      end
      inherited dsParams: TDataSource
        DataSet = qryActionTreeParams
      end
    end
  end
  object dsActionTree: TDataSource
    AutoEdit = False
    DataSet = qryActionTree
    Left = 1037
    Top = 17
  end
  object dsActionCodes: TDataSource
    DataSet = qryActionCodes
    Left = 417
    Top = 145
  end
  object qryActionCodes: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    ACTION_CODE,'
      '    ACTION_SIGN,'
      '    ACTION_NAME,'
      '    OBJECT_SIGN,'
      '    PROCEDURE_NAME,'
      '    VENDOR_ID'
      'FROM'
      '    ACTIONCODES '
      'WHERE /*FILTER*/ 1=1'
      'ORDER by OBJECT_SIGN')
    Active = True
    Transaction = dmOtto.trnAutonomouse
    Database = dmOtto.dbOtto
    Left = 297
    Top = 145
  end
  object qryActionTree: TpFIBDataSet
    SelectSQL.Strings = (
      'select atr.actiontreeitem_id, '
      '       atr.action_code, '
      '       atr.order_no, '
      '       atr.child_code, '
      '       ac.action_sign, '
      '       ac.action_name, '
      '       ac.object_sign'
      'from actiontree atr'
      '  inner join actioncodes ac on (ac.action_code = atr.child_code)'
      'where atr.action_code = :action_code'
      'order by atr.order_no'
      '')
    Active = True
    Transaction = dmOtto.trnAutonomouse
    Database = dmOtto.dbOtto
    DataSource = dsActionCodes
    Left = 1005
    Top = 113
  end
  object qryActionCodeParams: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    OBJECT_ID,'
      '    ACTION_SIGN,'
      '    PARAM_NAME,'
      '    PARAM_KIND,'
      '    PARAM_VALUE'
      'FROM'
      '    ACTIONCODE_PARAMS '
      'WHERE OBJECT_ID = :ACTION_CODE'
      'ORDER BY PARAM_NAME')
    Transaction = dmOtto.trnAutonomouse
    Database = dmOtto.dbOtto
    DataSource = dsActionCodes
    Left = 337
    Top = 425
  end
  object qryActionCodeCrit: TpFIBDataSet
    Transaction = dmOtto.trnAutonomouse
    Database = dmOtto.dbOtto
    DataSource = dsActionCodes
    Left = 336
    Top = 600
  end
  object qryActionTreeCrit: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    OBJECT_ID,'
      '    PARAM_NAME,'
      '    PARAM_KIND,'
      '    PARAM_ACTION,'
      '    PARAM_VALUE_1,'
      '    PARAM_VALUE_2'
      'FROM'
      '    ACTIONTREE_CRITERIAS '
      'WHERE OBJECT_ID = :ACTIONTREEITEM_ID'
      'ORDER BY PARAM_NAME')
    Transaction = dmOtto.trnAutonomouse
    Database = dmOtto.dbOtto
    DataSource = dsActionTree
    Left = 1041
    Top = 624
  end
  object qryActionTreeParams: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    OBJECT_ID,'
      '    PARAM_NAME,'
      '    PARAM_KIND,'
      '    PARAM_VALUE'
      'FROM'
      '    ACTIONTREE_PARAMS '
      'WHERE OBJECT_ID = :ACTIONTREEITEM_ID'
      'ORDER BY PARAM_NAME')
    Transaction = dmOtto.trnAutonomouse
    Database = dmOtto.dbOtto
    Left = 1017
    Top = 424
  end
end
