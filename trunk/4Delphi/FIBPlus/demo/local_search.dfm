object frmLocalSearch: TfrmLocalSearch
  Left = 242
  Top = 110
  ActiveControl = dbgCustomer
  BorderStyle = bsDialog
  Caption = 'Local Search'
  ClientHeight = 348
  ClientWidth = 536
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 4
    Top = 4
    Width = 34
    Height = 13
    Caption = 'Search'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 132
    Top = 24
    Width = 152
    Height = 13
    Caption = '[Field: '#39'Name'#39' | Timeout: 500 ms]'
  end
  object btnClose: TBitBtn
    Left = 459
    Top = 320
    Width = 75
    Height = 25
    Caption = 'Close'
    ModalResult = 1
    TabOrder = 2
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      1800000000000003000000000000000000000000000000000000FF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FF000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FFFFFF8080800000
      00000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00000000
      0000000000000000FFFFFF808080808080000000000000FF00FFFF00FFFF00FF
      FF00FF000000000000FF00FF000000FFFFFFFFFFFF000000FFFFFF8080808080
      80808080000000FF00FFFF00FFFF00FFFF00FF000000FFFFFF000000FFFFFFFF
      FFFFFFFFFF000000FFFFFF808080808080808080000000FF00FF000000000000
      000000000000FFFFFFFFFFFF000000FFFFFFFFFFFF000000FFFFFF8080808080
      80808080000000FF00FF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
      0000FFFFFF000000FFFFFF000000000000808080000000FF00FF000000FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFF8080800000
      00808080000000FF00FF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
      0000FFFFFF000000FFFFFF808080808080808080000000FF00FF000000000000
      000000000000FFFFFFFFFFFF000000FFFFFFFFFFFF000000FFFFFF8080808080
      80808080000000FF00FFFF00FFFF00FFFF00FF000000FFFFFF000000FFFFFFFF
      FFFFFFFFFF000000FFFFFF808080808080808080000000FF00FFFF00FFFF00FF
      FF00FF000000000000FF00FF000000FFFFFFFFFFFF000000FFFFFF8080808080
      80808080000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FF
      FFFFFFFFFF000000000000FFFFFF808080808080000000FF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FF000000FFFFFFFFFFFFFFFFFF000000000000FFFF
      FF808080000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00000000
      0000000000000000000000000000000000000000000000FF00FF}
  end
  object dbgCustomer: TDBGrid
    Left = 0
    Top = 44
    Width = 536
    Height = 273
    DataSource = dsLocate
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnKeyPress = dbgCustomerKeyPress
    Columns = <
      item
        Expanded = False
        FieldName = 'NAME'
        Title.Caption = 'Name'
        Width = 160
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ADDRESS_1'
        Title.Caption = 'Address 1'
        Width = 126
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ADDRESS_2'
        Title.Caption = 'Address 2'
        Width = 67
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CITY'
        Title.Caption = 'City'
        Width = 83
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'STATE'
        Title.Caption = 'State'
        Width = 53
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ZIP'
        Title.Caption = 'Zip'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'COUNTRY'
        Title.Caption = 'Country'
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CONTACT'
        Title.Caption = 'Contact'
        Width = 113
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PHONE'
        Title.Caption = 'Phone'
        Width = 73
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'FAX'
        Title.Caption = 'Fax'
        Width = 76
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'TAX_RATE'
        Title.Caption = 'Tax Rate'
        Width = 52
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'LAST_INVOICE_DATE'
        Title.Caption = 'Last Invoice Date'
        Width = 98
        Visible = True
      end>
  end
  object edtSearch: TEdit
    Left = 5
    Top = 20
    Width = 120
    Height = 21
    TabOrder = 0
    OnChange = edtSearchChange
    OnKeyDown = edtSearchKeyDown
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 500
    Top = 8
  end
  object dtLocate: TpFIBDataSet
    Database = dmMain.dbDemo
    Transaction = dmMain.trRead
    Options = [poStartTransaction]
    UpdateTransaction = dmMain.trWrite
    AutoCommit = True
    BufferChunks = 32
    CachedUpdates = False
    UniDirectional = False
    UpdateRecordTypes = [cusUnmodified, cusModified, cusInserted]
    UpdateSQL.Strings = (
      'UPDATE CUSTOMER SET '
      '    NAME = :NAME,'
      '    ADDRESS_1 = :ADDRESS_1,'
      '    ADDRESS_2 = :ADDRESS_2,'
      '    CITY = :CITY,'
      '    STATE = :STATE,'
      '    ZIP = :ZIP,'
      '    COUNTRY = :COUNTRY,'
      '    PHONE = :PHONE,'
      '    FAX = :FAX,'
      '    TAX_RATE = :TAX_RATE,'
      '    CONTACT = :CONTACT,'
      '    LAST_INVOICE_DATE = :LAST_INVOICE_DATE'
      ' WHERE     '
      '            ID = :OLD_ID'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM CUSTOMER'
      'WHERE     '
      '            ID = :OLD_ID'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO CUSTOMER('
      '    ID,'
      '    NAME,'
      '    ADDRESS_1,'
      '    ADDRESS_2,'
      '    CITY,'
      '    STATE,'
      '    ZIP,'
      '    COUNTRY,'
      '    PHONE,'
      '    FAX,'
      '    TAX_RATE,'
      '    CONTACT,'
      '    LAST_INVOICE_DATE'
      ')'
      'VALUES('
      '    :ID,'
      '    :NAME,'
      '    :ADDRESS_1,'
      '    :ADDRESS_2,'
      '    :CITY,'
      '    :STATE,'
      '    :ZIP,'
      '    :COUNTRY,'
      '    :PHONE,'
      '    :FAX,'
      '    :TAX_RATE,'
      '    :CONTACT,'
      '    :LAST_INVOICE_DATE'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    C.ID,'
      '    C.NAME,'
      '    C.ADDRESS_1,'
      '    C.ADDRESS_2,'
      '    C.CITY,'
      '    C.STATE,'
      '    C.ZIP,'
      '    C.COUNTRY,'
      '    C.PHONE,'
      '    C.FAX,'
      '    C.TAX_RATE,'
      '    C.CONTACT,'
      '    C.LAST_INVOICE_DATE'
      'FROM'
      '    CUSTOMER C'
      ' WHERE '
      '    (    '
      '            C.ID = :OLD_ID'
      '    )')
    SelectSQL.Strings = (
      'SELECT'
      '    C.ID,'
      '    C.NAME,'
      '    C.ADDRESS_1,'
      '    C.ADDRESS_2,'
      '    C.CITY,'
      '    C.STATE,'
      '    C.ZIP,'
      '    C.COUNTRY,'
      '    C.PHONE,'
      '    C.FAX,'
      '    C.TAX_RATE,'
      '    C.CONTACT,'
      '    C.LAST_INVOICE_DATE'
      'FROM'
      '    CUSTOMER C'
      'ORDER BY C.NAME')
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    AutoUpdateOptions.UpdateTableName = 'CUSTOMER'
    AutoUpdateOptions.KeyFields = 'ID'
    AutoUpdateOptions.GeneratorName = 'GEN_CUSTOMER_ID'
    Left = 84
    Top = 160
    poImportDefaultValues = False
    poGetOrderInfo = False
    object dtLocateID: TFIBIntegerField
      FieldName = 'ID'
    end
    object dtLocateNAME: TFIBStringField
      FieldName = 'NAME'
      Size = 30
    end
    object dtLocateADDRESS_1: TFIBStringField
      FieldName = 'ADDRESS_1'
      Size = 30
    end
    object dtLocateADDRESS_2: TFIBStringField
      FieldName = 'ADDRESS_2'
      Size = 30
    end
    object dtLocateCITY: TFIBStringField
      FieldName = 'CITY'
      Size = 15
    end
    object dtLocateSTATE: TFIBStringField
      FieldName = 'STATE'
      Size = 30
    end
    object dtLocateZIP: TFIBStringField
      FieldName = 'ZIP'
      Size = 15
    end
    object dtLocateCOUNTRY: TFIBStringField
      FieldName = 'COUNTRY'
      Size = 30
    end
    object dtLocatePHONE: TFIBStringField
      FieldName = 'PHONE'
      Size = 15
    end
    object dtLocateFAX: TFIBStringField
      FieldName = 'FAX'
      Size = 15
    end
    object dtLocateTAX_RATE: TFIBFloatField
      FieldName = 'TAX_RATE'
      DisplayFormat = '###,###,###,##0.00'
    end
    object dtLocateCONTACT: TFIBStringField
      FieldName = 'CONTACT'
      Size = 30
    end
    object dtLocateLAST_INVOICE_DATE: TDateTimeField
      FieldName = 'LAST_INVOICE_DATE'
      DisplayFormat = 'dd.mm.yyyy'
    end
  end
  object dsLocate: TDataSource
    DataSet = dtLocate
    Left = 84
    Top = 208
  end
end
