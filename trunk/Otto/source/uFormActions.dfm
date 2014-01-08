object frmActionCodeSetup: TfrmActionCodeSetup
  Left = 184
  Top = 71
  Width = 1092
  Height = 576
  Caption = 'frmActionCodeSetup'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  PixelsPerInch = 96
  TextHeight = 13
  object spl2: TSplitter
    Left = 550
    Top = 0
    Height = 538
  end
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 550
    Height = 538
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
      Top = 384
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
      object dckActionCode: TTBXDock
        Left = 1
        Top = 1
        Width = 546
        Height = 10
        object tbActionCodes: TTBXToolbar
          Left = 0
          Top = 0
          Caption = 'tbActionCodes'
          TabOrder = 0
          object TBXItem1: TTBXItem
          end
        end
      end
      object vsTreeActionCodes: TVirtualStringTree
        Left = 1
        Top = 11
        Width = 546
        Height = 238
        Align = alClient
        Header.AutoSizeIndex = -1
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.MainColumn = -1
        Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs]
        TabOrder = 1
        TreeOptions.AnimationOptions = [toAnimatedToggle]
        TreeOptions.AutoOptions = [toAutoDropExpand, toAutoExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes, toAutoChangeScale]
        OnFocusChanged = vsTreeActionCodesFocusChanged
        OnFreeNode = vsTreeActionCodesFreeNode
        OnGetText = vsTreeActionCodesGetText
        OnInitChildren = vsTreeActionCodesInitChildren
        OnInitNode = vsTreeActionCodesInitNode
        Columns = <>
      end
    end
    inline frmParamActionCode: TFrameParams
      Left = 1
      Top = 254
      Width = 548
      Height = 130
      Align = alClient
      TabOrder = 1
      inherited grdParams: TDBGridEh
        Width = 548
        Height = 105
        AutoFitColWidths = True
        ReadOnly = False
      end
      inherited dckParams: TTBXDock
        Width = 548
      end
      inherited dsParams: TDataSource
        DataSet = qryActionCodeParams
      end
    end
    inline frmCriteriaActionCode: TFrameCriterias
      Left = 1
      Top = 387
      Width = 548
      Height = 150
      Align = alBottom
      TabOrder = 2
      inherited dckTop: TTBXDock
        Width = 548
      end
      inherited grdCriterias: TDBGridEh
        Width = 548
        Height = 125
      end
      inherited dsCriterias: TDataSource
        DataSet = qryActionCodeCrit
      end
    end
  end
  object pnl4: TPanel
    Left = 553
    Top = 0
    Width = 523
    Height = 538
    Align = alClient
    Caption = 'pnl4'
    TabOrder = 1
    object spl3: TSplitter
      Left = 1
      Top = 251
      Width = 521
      Height = 3
      Cursor = crVSplit
      Align = alTop
    end
    object spl4: TSplitter
      Left = 1
      Top = 384
      Width = 521
      Height = 3
      Cursor = crVSplit
      Align = alBottom
    end
    object pnl5: TPanel
      Left = 1
      Top = 1
      Width = 521
      Height = 250
      Align = alTop
      Caption = 'pnl5'
      TabOrder = 0
      object grdActionTree: TDBGridEh
        Left = 1
        Top = 27
        Width = 519
        Height = 222
        Align = alClient
        AutoFitColWidths = True
        DataSource = dsActionTree
        DynProps = <>
        Flat = True
        IndicatorOptions = [gioShowRowIndicatorEh]
        TabOrder = 1
        OnDblClick = grdActionTreeDblClick
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
        Width = 519
        Height = 26
        object tbActionTree: TTBXToolbar
          Left = 0
          Top = 0
          Caption = 'tbActionTree'
          TabOrder = 0
        end
      end
    end
    inline frmParamActionTree: TFrameParams
      Left = 1
      Top = 254
      Width = 521
      Height = 130
      Align = alClient
      TabOrder = 1
      inherited grdParams: TDBGridEh
        Width = 521
        Height = 105
        AutoFitColWidths = True
      end
      inherited dckParams: TTBXDock
        Width = 521
      end
      inherited dsParams: TDataSource
        DataSet = qryActionTreeParams
      end
    end
    inline frmCriteriaActionTree: TFrameCriterias
      Left = 1
      Top = 387
      Width = 521
      Height = 150
      Align = alBottom
      TabOrder = 2
      inherited dckTop: TTBXDock
        Width = 521
      end
      inherited grdCriterias: TDBGridEh
        Width = 521
        Height = 125
      end
      inherited dsCriterias: TDataSource
        DataSet = qryActionTreeCrit
      end
    end
  end
  object dsActionTree: TDataSource
    AutoEdit = False
    DataSet = qryActionTree
    Left = 637
    Top = 153
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
    Transaction = trnWrite
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
    AfterScroll = qryActionTreeAfterScroll
    Transaction = trnWrite
    Database = dmOtto.dbOtto
    DataSource = dsActionCodes
    Left = 581
    Top = 153
    dcForceOpen = True
  end
  object qryActionCodeParams: TpFIBDataSet
    UpdateSQL.Strings = (
      'UPDATE ACTIONCODE_PARAMS'
      'SET '
      '    PARAM_VALUE = :PARAM_VALUE,'
      '    PARAM_NAME = :PARAM_NAME,'
      '    PARAM_KIND = :PARAM_KIND'
      'WHERE'
      '    OBJECT_ID = :OLD_OBJECT_ID'
      '    and PARAM_NAME = :OLD_PARAM_NAME'
      '    and PARAM_KIND = :OLD_PARAM_KIND'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      '    ACTIONCODE_PARAMS'
      'WHERE'
      '        OBJECT_ID = :OLD_OBJECT_ID'
      '    and PARAM_NAME = :OLD_PARAM_NAME'
      '    and PARAM_KIND = :OLD_PARAM_KIND'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO ACTIONCODE_PARAMS('
      '    OBJECT_ID,'
      '    PARAM_NAME,'
      '    PARAM_KIND,'
      '    PARAM_VALUE'
      ')'
      'VALUES('
      '    :OBJECT_ID,'
      '    :PARAM_NAME,'
      '    :PARAM_KIND,'
      '    :PARAM_VALUE'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    OBJECT_ID,'
      '    PARAM_NAME,'
      '    PARAM_KIND,'
      '    PARAM_VALUE'
      'FROM'
      '    ACTIONCODE_PARAMS '
      'WHERE OBJECT_ID = :ACTION_CODE'
      '    and ACTIONCODE_PARAMS.OBJECT_ID = :OLD_OBJECT_ID'
      '    and ACTIONCODE_PARAMS.PARAM_NAME = :OLD_PARAM_NAME'
      '    and ACTIONCODE_PARAMS.PARAM_KIND = :OLD_PARAM_KIND'
      '    ')
    SelectSQL.Strings = (
      'SELECT'
      '    OBJECT_ID,'
      '    PARAM_NAME,'
      '    PARAM_KIND,'
      '    PARAM_VALUE'
      'FROM'
      '    ACTIONCODE_PARAMS '
      'WHERE OBJECT_ID = :ACTION_CODE'
      'ORDER BY PARAM_NAME')
    Active = True
    BeforePost = qryActionCodeParamsBeforePost
    Transaction = trnWrite
    Database = dmOtto.dbOtto
    DataSource = dsActionCodes
    Left = 297
    Top = 201
    WaitEndMasterScroll = True
    dcForceOpen = True
  end
  object qryActionCodeCrit: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    OBJECT_ID,'
      '    ACTIONCODE_SIGN,'
      '    PARAM_NAME,'
      '    PARAM_KIND,'
      '    PARAM_ACTION,'
      '    PARAM_VALUE_1,'
      '    PARAM_VALUE_2'
      'FROM'
      '    ACTIONCODE_CRITERIAS '
      'WHERE OBJECT_ID = :ACTION_CODE')
    Active = True
    BeforePost = qryActionCodeCritBeforePost
    Transaction = trnWrite
    Database = dmOtto.dbOtto
    DataSource = dsActionCodes
    Left = 296
    Top = 256
    dcForceOpen = True
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
    Active = True
    BeforePost = qryActionTreeCritBeforePost
    Transaction = trnWrite
    Database = dmOtto.dbOtto
    DataSource = dsActionTree
    Left = 585
    Top = 256
    dcForceOpen = True
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
    Active = True
    BeforePost = qryActionTreeParamsBeforePost
    Transaction = trnWrite
    Database = dmOtto.dbOtto
    DataSource = dsActionTree
    Left = 585
    Top = 208
    dcForceOpen = True
  end
  object trnWrite: TpFIBTransaction
    Active = True
    DefaultDatabase = dmOtto.dbOtto
    TimeoutAction = TARollback
    Left = 474
    Top = 26
  end
  object qryObjects: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    OBJECT_SIGN,'
      '    OBJECT_NAME,'
      '    TABLE_NAME,'
      '    IDFIELD_NAME,'
      '    ATTR_TABLE_NAME,'
      '    PROCEDURE_READ,'
      '    OBJECT_CODE'
      'FROM'
      '    OBJECTS '
      'ORDER BY OBJECT_SIGN')
    Transaction = trnWrite
    Database = dmOtto.dbOtto
    Left = 297
    Top = 57
  end
  object qryTemp: TpFIBDataSet
    Transaction = dmOtto.trnAutonomouse
    Database = dmOtto.dbOtto
    Left = 169
    Top = 57
  end
end
