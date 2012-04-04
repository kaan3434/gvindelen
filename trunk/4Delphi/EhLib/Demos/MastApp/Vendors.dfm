object fVendors: TfVendors
  Left = 351
  Top = 301
  Width = 849
  Height = 575
  Caption = 'Vendors'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Default'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 833
    Height = 37
    Align = alTop
    TabOrder = 0
    object rgRowPanel: TRadioGroup
      Left = 4
      Top = 1
      Width = 233
      Height = 30
      Columns = 2
      ItemIndex = 1
      Items.Strings = (
        'Row panel'
        'Row line')
      TabOrder = 0
      OnClick = rgRowPanelClick
    end
    object DBNavigator1: TDBNavigator
      Left = 240
      Top = 6
      Width = 240
      Height = 25
      DataSource = dsVend
      Flat = True
      TabOrder = 1
    end
  end
  object DBGridEh1: TDBGridEh
    Left = 0
    Top = 37
    Width = 833
    Height = 500
    Align = alClient
    ColumnDefValues.AlwaysShowEditButton = True
    ColumnDefValues.Title.TitleButton = True
    ColumnDefValues.Title.ToolTips = True
    ColumnDefValues.ToolTips = True
    DataGrouping.GroupLevels = <>
    DataSource = dsVend
    Flat = True
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Default'
    FooterFont.Style = []
    IndicatorTitle.ShowDropDownSign = True
    IndicatorTitle.TitleButton = True
    OddRowColor = clInactiveBorder
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking, dghIncSearch, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove, dghHotTrack, dghExtendVertLines]
    ParentShowHint = False
    RowDetailPanel.Active = True
    RowDetailPanel.Height = 300
    RowDetailPanel.Color = clBtnFace
    ShowHint = True
    SortLocal = True
    STFilter.InstantApply = True
    STFilter.Local = True
    STFilter.Location = stflInTitleFilterEh
    STFilter.Visible = True
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Default'
    TitleFont.Style = []
    Columns = <
      item
        Color = clMenu
        EditButtons = <>
        FieldName = 'VendorNo'
        Footers = <>
        ReadOnly = True
        Width = 67
      end
      item
        EditButtons = <>
        FieldName = 'VendorName'
        Footers = <>
      end
      item
        EditButtons = <>
        FieldName = 'Address1'
        Footers = <>
      end
      item
        EditButtons = <>
        FieldName = 'Address2'
        Footers = <>
      end
      item
        EditButtons = <>
        FieldName = 'City'
        Footers = <>
      end
      item
        EditButtons = <>
        FieldName = 'State'
        Footers = <>
      end
      item
        EditButtons = <>
        FieldName = 'Zip'
        Footers = <>
      end
      item
        EditButtons = <>
        FieldName = 'Country'
        Footers = <>
      end
      item
        EditButtons = <>
        FieldName = 'Phone'
        Footers = <>
      end
      item
        EditButtons = <>
        FieldName = 'FAX'
        Footers = <>
      end
      item
        EditButtons = <>
        FieldName = 'Preferred'
        Footers = <>
      end>
    object RowDetailData: TRowDetailPanelControlEh
      object PageControl1: TPageControl
        Left = 0
        Top = 0
        Width = 697
        Height = 298
        ActivePage = TabSheet1
        Align = alClient
        TabOrder = 0
        object TabSheet1: TTabSheet
          Caption = 'Parts'
          object DBGridEh2: TDBGridEh
            Left = 0
            Top = 0
            Width = 689
            Height = 270
            Align = alClient
            ColumnDefValues.Title.ToolTips = True
            ColumnDefValues.ToolTips = True
            DataGrouping.GroupLevels = <>
            DataSource = dsParts
            EditActions = [geaCopyEh, geaSelectAllEh]
            Flat = True
            FooterColor = clWindow
            FooterFont.Charset = DEFAULT_CHARSET
            FooterFont.Color = clWindowText
            FooterFont.Height = -11
            FooterFont.Name = 'Default'
            FooterFont.Style = []
            IndicatorTitle.ShowDropDownSign = True
            IndicatorTitle.TitleButton = True
            Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
            OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove, dghExtendVertLines]
            RowDetailPanel.Color = clBtnFace
            RowPanel.Active = True
            STFilter.InstantApply = True
            STFilter.Local = True
            STFilter.Location = stflInTitleFilterEh
            STFilter.Visible = True
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'Default'
            TitleFont.Style = []
            Columns = <
              item
                EditButtons = <>
                FieldName = 'PartNo'
                Footers = <>
                InRowLineHeight = 2
              end
              item
                EditButtons = <>
                FieldName = 'OnHand'
                Footers = <>
                Width = 62
              end
              item
                EditButtons = <>
                FieldName = 'Description'
                Footers = <>
                Width = 257
                InRowLinePos = 1
              end
              item
                EditButtons = <>
                FieldName = 'OnOrder'
                Footers = <>
              end
              item
                EditButtons = <>
                FieldName = 'Cost'
                Footers = <>
              end
              item
                EditButtons = <>
                FieldName = 'ListPrice'
                Footers = <>
              end
              item
                EditButtons = <>
                FieldName = 'VendorNo'
                Footers = <>
                Width = 60
                InRowLineHeight = 2
              end>
            object RowDetailData: TRowDetailPanelControlEh
            end
          end
        end
      end
    end
  end
  object mtVend: TMemTableEh
    FetchAllOnOpen = True
    Params = <>
    DataDriver = ddrVend
    Left = 1072
    Top = 88
  end
  object ddrVend: TADODataDriverEh
    ADOConnection = MainForm.ADOConnection1
    SelectCommand.CommandText.Strings = (
      'select'
      '  VendorNo'
      '  ,VendorName'
      '  ,Address1'
      '  ,Address2'
      '  ,City'
      '  ,State'
      '  ,Zip'
      '  ,Country'
      '  ,Phone'
      '  ,FAX'
      '  ,Preferred'
      'from'
      '  vendors')
    SelectCommand.Parameters = <>
    UpdateCommand.CommandText.Strings = (
      'update vendors'
      'set'
      '  VendorName = :VendorName,'
      '  Address1 = :Address1,'
      '  Address2 = :Address2,'
      '  City = :City,'
      '  State = :State,'
      '  Zip = :Zip,'
      '  Country = :Country,'
      '  Phone = :Phone,'
      '  FAX = :FAX,'
      '  Preferred = :Preferred'
      'where'
      '  VendorNo = :OLD_VendorNo')
    UpdateCommand.Parameters = <
      item
        Name = 'VendorName'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'Address1'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'Address2'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'City'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'State'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'Zip'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'Country'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'Phone'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'FAX'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'Preferred'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'OLD_VendorNo'
        DataType = ftString
        Size = -1
        Value = ''
      end>
    InsertCommand.CommandText.Strings = (
      'insert into vendors'
      '  (VendorName, Address1, Address2, City, State, Zip, Country, '
      'Phone, FAX, '
      '   Preferred)'
      'values'
      '  (:VendorName, :Address1, :Address2, :City, :State, :Zip, '
      ':Country, :Phone, '
      '   :FAX, :Preferred)')
    InsertCommand.Parameters = <
      item
        Name = 'VendorName'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'Address1'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'Address2'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'City'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'State'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'Zip'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'Country'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'Phone'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'FAX'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'Preferred'
        DataType = ftString
        Size = -1
        Value = ''
      end>
    DeleteCommand.CommandText.Strings = (
      'delete from vendors'
      'where'
      '  VendorNo = :OLD_VendorNo')
    DeleteCommand.Parameters = <
      item
        Name = 'OLD_VendorNo'
        DataType = ftString
        Size = -1
        Value = ''
      end>
    GetrecCommand.CommandText.Strings = (
      'select'
      '  VendorNo'
      '  ,VendorName'
      '  ,Address1'
      '  ,Address2'
      '  ,City'
      '  ,State'
      '  ,Zip'
      '  ,Country'
      '  ,Phone'
      '  ,FAX'
      '  ,Preferred'
      'from'
      '  vendors'
      '  VendorNo = :OLD_VendorNo')
    GetrecCommand.Parameters = <
      item
        Name = 'OLD_VendorNo'
        DataType = ftString
        Size = -1
        Value = ''
      end>
    DynaSQLParams.Options = []
    SpecParams.Strings = (
      'AUTO_INCREMENT_FIELD=VendorNo')
    Left = 1072
    Top = 120
  end
  object dsVend: TDataSource
    DataSet = mtVend
    Left = 1072
    Top = 56
  end
  object dsParts: TDataSource
    DataSet = mtParts
    Left = 1112
    Top = 56
  end
  object mtParts: TMemTableEh
    DetailFields = 'VendorNo'
    FetchAllOnOpen = True
    MasterDetailSide = mdsOnProviderEh
    MasterFields = 'VendorNo'
    MasterSource = dsVend
    Params = <>
    DataDriver = ddrParts
    ReadOnly = True
    Left = 1112
    Top = 88
  end
  object ddrParts: TADODataDriverEh
    ADOConnection = MainForm.ADOConnection1
    SelectCommand.CommandText.Strings = (
      'select'
      '   PartNo'
      '  ,VendorNo'
      '  ,Description'
      '  ,OnHand'
      '  ,OnOrder'
      '  ,Cost'
      '  ,ListPrice'
      'from'
      '  parts'
      'where '
      '  VendorNo = :VendorNo')
    SelectCommand.Parameters = <
      item
        Name = 'VendorNo'
        DataType = ftInteger
        Value = 1
      end>
    UpdateCommand.CommandText.Strings = (
      'update customer'
      'set'
      '  Company = :Company,'
      '  Addr1 = :Addr1,'
      '  Addr2 = :Addr2,'
      '  City = :City,'
      '  State = :State,'
      '  Zip = :Zip,'
      '  Country = :Country,'
      '  Phone = :Phone,'
      '  FAX = :FAX,'
      '  TaxRate = :TaxRate,'
      '  Contact = :Contact,'
      '  LastInvoiceDate = :LastInvoiceDate'
      'where'
      '  CustNo = :OLD_CustNo')
    UpdateCommand.Parameters = <
      item
        Name = 'Company'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'Addr1'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'Addr2'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'City'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'State'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'Zip'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'Country'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'Phone'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'FAX'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'TaxRate'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'Contact'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'LastInvoiceDate'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'OLD_CustNo'
        DataType = ftString
        Size = -1
        Value = ''
      end>
    InsertCommand.CommandText.Strings = (
      'insert into customer'
      '  (Company, Addr1, Addr2, City, State, Zip, Country, Phone, '
      'FAX, TaxRate, '
      '   Contact, LastInvoiceDate)'
      'values'
      '  (:Company, :Addr1, :Addr2, :City, :State, :Zip, :Country, '
      ':Phone, :FAX, '
      '   :TaxRate, :Contact, :LastInvoiceDate)')
    InsertCommand.Parameters = <
      item
        Name = 'Company'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'Addr1'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'Addr2'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'City'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'State'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'Zip'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'Country'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'Phone'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'FAX'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'TaxRate'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'Contact'
        DataType = ftString
        Size = -1
        Value = ''
      end
      item
        Name = 'LastInvoiceDate'
        DataType = ftString
        Size = -1
        Value = ''
      end>
    DeleteCommand.CommandText.Strings = (
      'delete from customer'
      'where'
      '  CustNo = :OLD_CustNo')
    DeleteCommand.Parameters = <
      item
        Name = 'OLD_CustNo'
        DataType = ftString
        Size = -1
        Value = ''
      end>
    GetrecCommand.CommandText.Strings = (
      'select'
      '  CustNo'
      '  ,Company'
      '  ,Addr1'
      '  ,Addr2'
      '  ,City'
      '  ,State'
      '  ,Zip'
      '  ,Country'
      '  ,Phone'
      '  ,FAX'
      '  ,TaxRate'
      '  ,Contact'
      '  ,LastInvoiceDate'
      'from'
      '  customer'
      '  CustNo = :OLD_CustNo')
    GetrecCommand.Parameters = <
      item
        Name = 'OLD_CustNo'
        DataType = ftString
        Size = -1
        Value = ''
      end>
    DynaSQLParams.Options = []
    SpecParams.Strings = (
      'AUTO_INCREMENT_FIELD=CustNo')
    Left = 1112
    Top = 120
  end
end
