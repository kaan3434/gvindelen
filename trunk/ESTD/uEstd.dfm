object Form1: TForm1
  Left = 454
  Top = 212
  Width = 1142
  Height = 656
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object btn1: TButton
    Left = 96
    Top = 136
    Width = 75
    Height = 25
    Caption = 'btn1'
    TabOrder = 0
    OnClick = btn1Click
  end
  object btn2: TButton
    Left = 96
    Top = 192
    Width = 75
    Height = 25
    Caption = 'btn2'
    TabOrder = 1
    OnClick = btn2Click
  end
  object pFIBDatabase1: TpFIBDatabase
    DBName = 'D:\GOST\ESTD.FDB'
    DBParams.Strings = (
      'lc_ctype=UNICODE_FSS'
      'user_name=SYSDBA'
      'password=masterkey')
    SQLDialect = 3
    Timeout = 0
    LibraryName = 'fbclient.dll'
    WaitForRestoreConnect = 0
    Left = 104
    Top = 72
  end
  object frxrprt1: TfrxReport
    Version = '4.9.64'
    DotMatrixReport = False
    EngineOptions.ConvertNulls = False
    EngineOptions.DoublePass = True
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 40270.470834375000000000
    ReportOptions.LastChange = 40402.791147870400000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      ''
      'procedure PageHeader1OnBeforePrint(Sender: TfrxComponent);'
      'begin    '
      
        '  if <Page> = 1 then mB0_2.Text:= '#39#1060#1086#1088#1084#1072' 2'#39' else mB0_2.Text:= '#39#1060 +
        #1086#1088#1084#1072' 1'#1073#39';                                                       ' +
        '                                                                ' +
        '                                             '
      '  mB5F1a_1.visible:= <Page> > 1;'
      '  mB5F1a_2.visible:= <Page> > 1;'
      '  mB5F1a_3.visible:= <Page> > 1;'
      '  mB5F1a_4.visible:= <Page> > 1;'
      
        '  lB5F1a.visible:= <Page> > 1;                                  ' +
        '                           '
      '  mB5F1_1.visible:= <Page> = 1;'
      '  mB5F1_2.visible:= <Page> = 1;'
      '  mB5F1_3.visible:= <Page> = 1;'
      '  mB5F1_4.visible:= <Page> = 1;'
      '  mB5F1_5.visible:= <Page> = 1;'
      '  lB5F1.visible:= <Page> = 1;'
      'end;'
      ''
      'procedure Page1OnBeforePrint(Sender: TfrxComponent);'
      'var'
      '  LenOperNum: String;'
      
        '  ParamItem: TfrxParamItem;                                     ' +
        '      '
      'begin'
      '  Set('#39'Document_ID'#39', 18);'
      '  qryMaxOperNum.Open;'
      '  LenOperNum:= IntToStr(Length(<qryMaxOperNum."Max_Oper_Num">));'
      '  qryMaxOperNum.Close;'
      
        '  m25_5.DisplayFormat.FormatStr:= '#39'%'#39'+LenOperNum+'#39'.'#39'+LenOperNum+' +
        #39'u'#39';                                                            ' +
        '                                                                ' +
        '                                 '
      'end;'
      ''
      'begin'
      ''
      'end.')
    Left = 248
    Top = 144
    Datasets = <
      item
        DataSet = frxrprt1.qryForms
        DataSetName = 'qryForms'
      end
      item
        DataSet = frxrprt1.qryLines
        DataSetName = 'qryLines'
      end
      item
        DataSet = frxrprt1.qryBand18
        DataSetName = 'qryBand19'
      end
      item
        DataSet = frxrprt1.qryBand25
        DataSetName = 'qryBand25'
      end
      item
        DataSet = frxrprt1.qryBand11
        DataSetName = 'qryBand11'
      end
      item
        DataSet = frxrprt1.qryMaxOperNum
        DataSetName = 'qryMaxOperNum'
      end
      item
        DataSet = frxrprt1.qryBand34
        DataSetName = 'qryBand34'
      end
      item
        DataSet = frxrprt1.qryBand13
        DataSetName = 'qryBand13'
      end
      item
        DataSet = frxrprt1.qryBand00
        DataSetName = 'qryBand00'
      end>
    Variables = <
      item
        Name = ' Common'
        Value = Null
      end
      item
        Name = 'Document_ID'
        Value = Null
      end>
    Style = <
      item
        Name = 'Text11'
        Color = clNone
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Mipgost'
        Font.Style = [fsBold, fsItalic]
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
      end
      item
        Name = 'B10'
        Color = clNone
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'GOST type B'
        Font.Style = [fsItalic]
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
      end
      item
        Name = 'Mipgost18'
        Color = clNone
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -24
        Font.Name = 'Mipgost'
        Font.Style = [fsBold, fsItalic]
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
      end>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
      object ESTD: TfrxFIBDatabase
        DatabaseName = 'D:\GOST\ESTD.FDB'
        LoginPrompt = False
        Params.Strings = (
          'user_name=SYSDBA'
          'password=masterkey')
        SQLDialect = 3
        Connected = True
        pLeft = 76
        pTop = 44
      end
      object qryForms: TfrxFIBQuery
        UserName = 'qryForms'
        CloseDataSource = True
        BCDToCurrency = False
        IgnoreDupParams = False
        Params = <
          item
            Name = 'Document_ID'
            DataType = ftInteger
            Expression = '<Document_ID>'
          end>
        SQL.Strings = (
          'select f.*'
          'from forms f'
          'where document_id = :Document_ID                             '
          'order by f.page_no                                        ')
        Database = frxrprt1.ESTD
        pLeft = 164
        pTop = 44
        Parameters = <
          item
            Name = 'Document_ID'
            DataType = ftInteger
            Expression = '<Document_ID>'
          end>
      end
      object qryLines: TfrxFIBQuery
        UserName = 'qryLines'
        CloseDataSource = True
        BCDToCurrency = False
        Master = frxrprt1.qryForms
        IgnoreDupParams = False
        Params = <
          item
            Name = 'form_id'
            DataType = ftSmallint
            Expression = '<qryForms."FORM_ID">'
          end>
        SQL.Strings = (
          
            'select l.line_id, br.litera, l.block_rowno, l.line_no           ' +
            '                                                                ' +
            '                                 '
          'from lines l'
          '  inner join blocks bl on (bl.block_id = l.block_id)'
          '  inner join block_ref br on (br.block_sign = bl.block_sign)'
          
            '  inner join forms f on (f.form_id = l.form_id)                 ' +
            '                                                                ' +
            '                             '
          'where l.form_id = :form_id'
          
            '  and l.line_no <= f.form_size                                  ' +
            '                                               '
          
            'order by l.line_no                                              ' +
            '       ')
        Database = frxrprt1.ESTD
        pLeft = 264
        pTop = 44
        Parameters = <
          item
            Name = 'form_id'
            DataType = ftSmallint
            Expression = '<qryForms."FORM_ID">'
          end>
      end
      object qryBand18: TfrxFIBQuery
        UserName = 'qryBand19'
        CloseDataSource = True
        BCDToCurrency = False
        Master = frxrprt1.qryLines
        IgnoreDupParams = False
        Params = <
          item
            Name = 'line_id'
            DataType = ftInteger
          end>
        SQL.Strings = (
          'select b.* '
          'from band_18 b     '
          
            'where b.line_id = :line_id                                      ' +
            '                           ')
        Database = frxrprt1.ESTD
        pLeft = 76
        pTop = 100
        Parameters = <
          item
            Name = 'line_id'
            DataType = ftInteger
          end>
      end
      object qryBand25: TfrxFIBQuery
        UserName = 'qryBand25'
        CloseDataSource = True
        BCDToCurrency = False
        Master = frxrprt1.qryLines
        IgnoreDupParams = False
        Params = <
          item
            Name = 'line_id'
            DataType = ftInteger
          end>
        SQL.Strings = (
          'select b.* '
          'from band_25 b     '
          'where b.line_id = :line_id        ')
        Database = frxrprt1.ESTD
        pLeft = 104
        pTop = 148
        Parameters = <
          item
            Name = 'line_id'
            DataType = ftInteger
          end>
      end
      object qryBand11: TfrxFIBQuery
        UserName = 'qryBand11'
        CloseDataSource = True
        BCDToCurrency = False
        Master = frxrprt1.qryLines
        IgnoreDupParams = False
        Params = <
          item
            Name = 'line_id'
            DataType = ftInteger
          end>
        SQL.Strings = (
          'select b.* '
          'from band_11 b     '
          'where b.line_id = :line_id        ')
        Database = frxrprt1.ESTD
        pLeft = 132
        pTop = 196
        Parameters = <
          item
            Name = 'line_id'
            DataType = ftInteger
          end>
      end
      object qryMaxOperNum: TfrxFIBQuery
        UserName = 'qryMaxOperNum'
        CloseDataSource = True
        BCDToCurrency = False
        IgnoreDupParams = False
        Params = <
          item
            Name = 'Document_Id'
            DataType = ftInteger
            Expression = '<Document_ID>'
          end>
        SQL.Strings = (
          'select max(b25.oper_num) Max_Oper_Num '
          '  from band_25 b25 '
          '    inner join lines l on (l.line_id = b25.line_id) '
          '  where document_id = :Document_Id')
        Database = frxrprt1.ESTD
        UniDirectional = True
        pLeft = 352
        pTop = 44
        Parameters = <
          item
            Name = 'Document_Id'
            DataType = ftInteger
            Expression = '<Document_ID>'
          end>
      end
      object qryBand34: TfrxFIBQuery
        UserName = 'qryBand34'
        CloseDataSource = True
        BCDToCurrency = False
        Master = frxrprt1.qryLines
        IgnoreDupParams = False
        Params = <
          item
            Name = 'line_id'
            DataType = ftInteger
          end>
        SQL.Strings = (
          'select b.* '
          'from band_34 b     '
          'where b.line_id = :line_id        ')
        Database = frxrprt1.ESTD
        pLeft = 132
        pTop = 252
        Parameters = <
          item
            Name = 'line_id'
            DataType = ftInteger
          end>
      end
      object qryBand13: TfrxFIBQuery
        UserName = 'qryBand13'
        CloseDataSource = True
        BCDToCurrency = False
        Master = frxrprt1.qryLines
        IgnoreDupParams = False
        Params = <
          item
            Name = 'line_id'
            DataType = ftInteger
          end>
        SQL.Strings = (
          'select b.* '
          'from band_13 b     '
          'where b.line_id = :line_id        ')
        Database = frxrprt1.ESTD
        pLeft = 132
        pTop = 304
        Parameters = <
          item
            Name = 'line_id'
            DataType = ftInteger
          end>
      end
      object qryBand00: TfrxFIBQuery
        UserName = 'qryBand00'
        CloseDataSource = True
        BCDToCurrency = False
        Master = frxrprt1.qryLines
        IgnoreDupParams = False
        Params = <
          item
            Name = 'line_id'
            DataType = ftInteger
          end>
        SQL.Strings = (
          'select b.* '
          'from lines l'
          
            '  inner join bands b on (b.band_id = l.band_id)                 ' +
            '                                                                ' +
            '                           '
          'where l.line_id = :line_id'
          
            '  and b.band_sign = '#39'00'#39'                                        ' +
            '                ')
        Database = frxrprt1.ESTD
        pLeft = 76
        pTop = 352
        Parameters = <
          item
            Name = 'line_id'
            DataType = ftInteger
          end>
      end
    end
    object Page1: TfrxReportPage
      Orientation = poLandscape
      PaperWidth = 297.000000000000000000
      PaperHeight = 210.000000000000000000
      PaperSize = 9
      LeftMargin = 5.500000000000000000
      RightMargin = 5.500000000000000000
      BottomMargin = 5.000000000000000000
      BackPictureVisible = False
      BackPicturePrintable = False
      Frame.Width = 2.000000000000000000
      LargeDesignHeight = True
      TitleBeforeHeader = False
      HGuides.Strings = (
        '102,04731'
        '398,740415'
        '845,858814'
        '799,748548'
        '440,693198'
        '525,35467'
        '641,764194')
      VGuides.Strings = (
        '1080,94558'
        '49,13389'
        '501,165678'
        '88,441002'
        '127,748114'
        '167,055226'
        '216,189116'
        '786,14224'
        '835,27613'
        '884,41002'
        '933,54391'
        '1002,331356')
      OnBeforePrint = 'Page1OnBeforePrint'
      object ReportTitle1: TfrxReportTitle
        Height = 87.685096000000000000
        Top = 157.228448000000000000
        Width = 1080.945580000000000000
        Stretched = True
        object mB1F1_2_5: TfrxMemoView
          Left = 1041.638468000000000000
          Top = 48.377984000000000000
          Width = 39.307112000000000000
          Height = 31.748052000000000000
          GroupIndex = 1
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB1F1_2_4: TfrxMemoView
          Left = 1002.331356000000000000
          Top = 48.377984000000000000
          Width = 39.307112000000000000
          Height = 31.748052000000000000
          GroupIndex = 1
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB1F1_2_3: TfrxMemoView
          Left = 963.024244000000000000
          Top = 48.377984000000000000
          Width = 39.307112000000000000
          Height = 31.748052000000000000
          GroupIndex = 1
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB1F1_2_1: TfrxMemoView
          Left = 363.590786000000000000
          Top = 48.377984000000000000
          Width = 49.133858270000000000
          Height = 31.748052000000000000
          GroupIndex = 1
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB1F1_2_2: TfrxMemoView
          Left = 412.724676000000000000
          Top = 48.377984000000000000
          Width = 550.299568000000000000
          Height = 31.748052000000000000
          GroupIndex = 1
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB2F1_2_2: TfrxMemoView
          Left = 88.441002000000000000
          Top = 15.874025999999990000
          Width = 137.574892000000000000
          Height = 16.251979000000000000
          GroupIndex = 1
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          Style = 'B10'
          VAlign = vaCenter
        end
        object mB2F1_2_1: TfrxMemoView
          Top = 15.874025999999990000
          Width = 88.441002000000000000
          Height = 16.251979000000000000
          GroupIndex = 1
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8 = (
            #1056#1119#1057#1026#1056#1109#1056#1030#1056#181#1057#1026#1056#1105#1056#187)
          ParentFont = False
          Style = 'B10'
          VAlign = vaCenter
        end
        object mB2F1_2_3: TfrxMemoView
          Left = 226.015894000000000000
          Top = 15.874025999999990000
          Width = 78.614224000000000000
          Height = 16.251979000000000000
          GroupIndex = 1
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          Style = 'B10'
          VAlign = vaCenter
        end
        object mB2F1_2_4: TfrxMemoView
          Left = 304.630118000000000000
          Top = 15.874025999999990000
          Width = 58.960668000000000000
          Height = 16.251979000000000000
          GroupIndex = 1
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          Style = 'B10'
          VAlign = vaCenter
        end
        object mB2F1_3_2: TfrxMemoView
          Left = 88.441002000000000000
          Top = 32.126004999999990000
          Width = 137.574892000000000000
          Height = 15.874026000000000000
          GroupIndex = 1
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          Style = 'B10'
          VAlign = vaCenter
        end
        object mB2F1_3_1: TfrxMemoView
          Top = 32.126004999999990000
          Width = 88.441002000000000000
          Height = 15.874026000000000000
          GroupIndex = 1
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          Style = 'B10'
          VAlign = vaCenter
        end
        object mB2F1_3_3: TfrxMemoView
          Left = 226.015894000000000000
          Top = 32.126004999999990000
          Width = 78.614224000000000000
          Height = 15.874026000000000000
          GroupIndex = 1
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          Style = 'B10'
          VAlign = vaCenter
        end
        object mB2F1_3_4: TfrxMemoView
          Left = 304.630118000000000000
          Top = 32.126004999999990000
          Width = 58.960668000000000000
          Height = 15.874026000000000000
          GroupIndex = 1
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          Style = 'B10'
          VAlign = vaCenter
        end
        object mB2F1_4_2: TfrxMemoView
          Left = 88.441002000000000000
          Top = 48.000031000000010000
          Width = 137.574892000000000000
          Height = 16.251979000000000000
          GroupIndex = 1
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          Style = 'B10'
          VAlign = vaCenter
        end
        object mB2F1_4_1: TfrxMemoView
          Top = 48.000031000000010000
          Width = 88.441002000000000000
          Height = 16.251979000000000000
          GroupIndex = 1
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          Style = 'B10'
          VAlign = vaCenter
        end
        object mB2F1_4_3: TfrxMemoView
          Left = 226.015894000000000000
          Top = 48.000031000000010000
          Width = 78.614224000000000000
          Height = 16.251979000000000000
          GroupIndex = 1
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          Style = 'B10'
          VAlign = vaCenter
        end
        object mB2F1_4_4: TfrxMemoView
          Left = 304.630118000000000000
          Top = 48.000031000000010000
          Width = 58.960668000000000000
          Height = 16.251979000000000000
          GroupIndex = 1
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          Style = 'B10'
          VAlign = vaCenter
        end
        object mB2F1_5_2: TfrxMemoView
          Left = 88.441002000000000000
          Top = 64.252010000000010000
          Width = 137.574892000000000000
          Height = 15.874026000000000000
          GroupIndex = 1
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          Style = 'B10'
          VAlign = vaCenter
        end
        object mB2F1_5_1: TfrxMemoView
          Top = 64.252010000000010000
          Width = 88.441002000000000000
          Height = 15.874026000000000000
          GroupIndex = 1
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8 = (
            #1056#1116'. '#1056#1108#1056#1109#1056#1029#1057#8218#1057#1026'.')
          ParentFont = False
          Style = 'B10'
          VAlign = vaCenter
        end
        object mB2F1_5_3: TfrxMemoView
          Left = 226.015894000000000000
          Top = 64.252010000000010000
          Width = 78.614224000000000000
          Height = 15.874026000000000000
          GroupIndex = 1
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          Style = 'B10'
          VAlign = vaCenter
        end
        object mB2F1_5_4: TfrxMemoView
          Left = 304.630118000000000000
          Top = 64.252010000000010000
          Width = 58.960668000000000000
          Height = 15.874026000000000000
          GroupIndex = 1
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          Style = 'B10'
          VAlign = vaCenter
        end
        object Line1: TfrxLineView
          Left = 412.724676000000000000
          Top = 48.000031000000010000
          Height = 12.094496000000000000
          GroupIndex = 1
          ShowHint = False
          Diagonal = True
        end
        object mB1F1_0_1: TfrxMemoView
          Left = 520.819234000000000000
          Width = 560.126346000000000000
          Height = 48.377984000000000000
          GroupIndex = 1
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Frame.Width = 2.000000000000000000
          ParentFont = False
          VAlign = vaCenter
        end
        object mB1F1_1_4: TfrxMemoView
          Left = 904.063690240000000000
          Top = 0.000031239999998434
          Width = 176.881889760000000000
          Height = 48.377952760000000000
          GroupIndex = 1
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB1F1_1_3: TfrxMemoView
          Left = 746.835229540000000000
          Top = 0.000031239999998434
          Width = 157.228346460000000000
          Height = 48.377952760000000000
          GroupIndex = 1
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB1F1_1_2: TfrxMemoView
          Left = 520.819379970000000000
          Top = 0.000031239999998434
          Width = 226.015748030000000000
          Height = 48.377952760000000000
          GroupIndex = 1
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB1F1_1_1: TfrxMemoView
          Left = 363.590786000000000000
          Top = 0.000031239999998434
          Width = 157.228448000000000000
          Height = 48.377952760000000000
          GroupIndex = 1
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB2F1_1_2: TfrxMemoView
          Left = 88.441002000000000000
          Width = 137.574892000000000000
          Height = 15.874026000000000000
          GroupIndex = 1
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          Style = 'B10'
          VAlign = vaCenter
        end
        object mB2F1_1_1: TfrxMemoView
          Width = 88.441002000000000000
          Height = 15.874026000000000000
          GroupIndex = 1
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8 = (
            #1056#160#1056#176#1056#183#1057#1026#1056#176#1056#177'.')
          ParentFont = False
          Style = 'B10'
          VAlign = vaCenter
        end
        object mB2F1_1_3: TfrxMemoView
          Left = 226.015894000000000000
          Width = 78.614224000000000000
          Height = 15.874026000000000000
          GroupIndex = 1
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          Style = 'B10'
          VAlign = vaCenter
        end
        object mB2F1_1_4: TfrxMemoView
          Left = 304.630118000000000000
          Width = 58.960668000000000000
          Height = 15.874026000000000000
          GroupIndex = 1
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          Style = 'B10'
          VAlign = vaCenter
        end
      end
      object MasterData1: TfrxMasterData
        Height = 18.897650000000000000
        Top = 398.740415000000000000
        Width = 1080.945580000000000000
        DataSet = frxrprt1.qryForms
        DataSetName = 'qryForms'
        RowCount = 0
        StartNewPage = True
        Stretched = True
      end
      object PageFooter1: TfrxPageFooter
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -24
        Font.Name = 'GOST type B'
        Font.Style = [fsBold, fsItalic]
        Height = 34.015770000000000000
        ParentFont = False
        Restrictions = [rfDontSize, rfDontDelete]
        Top = 912.378542000000000000
        Width = 1080.945580000000000000
        object mB6F1_1: TfrxMemoView
          Width = 88.440944880000000000
          Height = 32.125984250000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'GOST type B'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#1114#1056#1113)
          ParentFont = False
          VAlign = vaCenter
        end
        object mB6F1_2: TfrxMemoView
          Left = 88.441002000000000000
          Width = 992.504578000000000000
          Height = 32.125984250000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          ParentFont = False
        end
      end
      object Header1: TfrxHeader
        Height = 69.921305000000000000
        Restrictions = [rfDontModify, rfDontSize, rfDontMove, rfDontDelete, rfDontEdit]
        Top = 305.763977000000000000
        Width = 1080.945580000000000000
        ReprintOnNewPage = True
        Stretched = True
        object mAh_1: TfrxMemoView
          Width = 49.133890000000000000
          Height = 15.874015750000000000
          Restrictions = [rfDontSize, rfDontMove, rfDontDelete]
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#1106)
          ParentFont = False
          VAlign = vaCenter
        end
        object mBh_1: TfrxMemoView
          Top = 15.874026000000020000
          Width = 49.133890000000000000
          Height = 16.251968500000000000
          Restrictions = [rfDontSize, rfDontMove, rfDontDelete]
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#8216)
          ParentFont = False
          VAlign = vaCenter
        end
        object mKMh_1: TfrxMemoView
          Top = 32.126005000000080000
          Width = 49.133890000000000000
          Height = 15.874015750000000000
          Restrictions = [rfDontSize, rfDontMove, rfDontDelete]
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#1113'/'#1056#1114)
          ParentFont = False
          VAlign = vaCenter
        end
        object mAh_2: TfrxMemoView
          Left = 49.133890000000000000
          Top = 0.000010250000002543
          Width = 39.307086610000000000
          Height = 15.874015750000000000
          Restrictions = [rfDontSize, rfDontMove, rfDontDelete]
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#166#1056#181#1057#8230)
          ParentFont = False
          Style = 'B10'
          VAlign = vaCenter
        end
        object mAh_3: TfrxMemoView
          Left = 88.441002000000000000
          Top = 0.000010250000002543
          Width = 39.307086610000000000
          Height = 15.874015750000000000
          Restrictions = [rfDontSize, rfDontMove, rfDontDelete]
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#1032#1057#8225'.')
          ParentFont = False
          Style = 'B10'
          VAlign = vaCenter
        end
        object mAh_4: TfrxMemoView
          Left = 127.748114000000000000
          Top = 0.000010250000002543
          Width = 39.307086610000000000
          Height = 15.874015750000000000
          Restrictions = [rfDontSize, rfDontMove, rfDontDelete]
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#160#1056#1114)
          ParentFont = False
          Style = 'B10'
          VAlign = vaCenter
        end
        object mAh_5: TfrxMemoView
          Left = 167.055226000000000000
          Top = 0.000010250000002543
          Width = 49.133858270000000000
          Height = 15.874015750000000000
          Restrictions = [rfDontSize, rfDontMove, rfDontDelete]
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#1115#1056#1111#1056#181#1057#1026'.')
          ParentFont = False
          Style = 'B10'
          VAlign = vaCenter
        end
        object mAh_6: TfrxMemoView
          Left = 216.189116000000000000
          Top = 0.000010250000002543
          Width = 284.976377950000000000
          Height = 15.874015750000000000
          Restrictions = [rfDontSize, rfDontMove, rfDontDelete]
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#1113#1056#1109#1056#1169', '#1056#1029#1056#176#1056#1105#1056#1112#1056#181#1056#1029#1056#1109#1056#1030#1056#176#1056#1029#1056#1105#1056#181' '#1056#1109#1056#1111#1056#181#1057#1026#1056#176#1057#8224#1056#1105#1056#1105)
          ParentFont = False
          Style = 'B10'
          VAlign = vaCenter
        end
        object mAh_7: TfrxMemoView
          Left = 501.165678000000000000
          Top = 0.000010250000059386
          Width = 579.779527560000000000
          Height = 15.874015750000000000
          Restrictions = [rfDontSize, rfDontMove, rfDontDelete]
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#1115#1056#177#1056#1109#1056#183#1056#1029#1056#176#1057#8225#1056#181#1056#1029#1056#1105#1056#181' '#1056#1169#1056#1109#1056#1108#1057#1107#1056#1112#1056#181#1056#1029#1057#8218#1056#176)
          ParentFont = False
          Style = 'B10'
          VAlign = vaCenter
        end
        object mBh_2: TfrxMemoView
          Left = 49.134181940000000000
          Top = 15.874026000000020000
          Width = 452.031496060000000000
          Height = 16.251979000000000000
          Restrictions = [rfDontSize, rfDontMove, rfDontDelete]
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#1113#1056#1109#1056#1169', '#1056#1029#1056#176#1056#1105#1056#1112#1056#181#1056#1029#1056#1109#1056#1030#1056#176#1056#1029#1056#1105#1056#181' '#1056#1109#1056#177#1056#1109#1057#1026#1057#1107#1056#1169#1056#1109#1056#1030#1056#176#1056#1029#1056#1105#1057#1039)
          ParentFont = False
          Style = 'B10'
          VAlign = vaCenter
        end
        object mBh_3: TfrxMemoView
          Left = 501.165678000000000000
          Top = 15.874026000000020000
          Width = 39.307086610000000000
          Height = 16.251979000000000000
          Restrictions = [rfDontSize, rfDontMove, rfDontDelete]
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#1038#1056#1114)
          ParentFont = False
          VAlign = vaCenter
        end
        object mBh_4: TfrxMemoView
          Left = 540.472790000000000000
          Top = 15.874026000000020000
          Width = 68.787401570000000000
          Height = 16.251979000000000000
          Restrictions = [rfDontSize, rfDontMove, rfDontDelete]
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#1119#1057#1026#1056#1109#1057#8222'.')
          ParentFont = False
          VAlign = vaCenter
        end
        object mBh_6: TfrxMemoView
          Left = 648.567348000000000000
          Top = 15.874026000000020000
          Width = 49.133858270000000000
          Height = 16.251979000000000000
          Restrictions = [rfDontSize, rfDontMove, rfDontDelete]
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#1032#1056#1118)
          ParentFont = False
          VAlign = vaCenter
        end
        object mBh_5: TfrxMemoView
          Left = 609.260236000000000000
          Top = 15.874026000000020000
          Width = 39.307086610000000000
          Height = 16.251979000000000000
          Restrictions = [rfDontSize, rfDontMove, rfDontDelete]
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#160)
          ParentFont = False
          VAlign = vaCenter
        end
        object mBh_7: TfrxMemoView
          Left = 697.701238000000000000
          Top = 15.874026000000020000
          Width = 39.307086610000000000
          Height = 16.251979000000000000
          Restrictions = [rfDontSize, rfDontMove, rfDontDelete]
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#1113#1056#160)
          ParentFont = False
          VAlign = vaCenter
        end
        object mBh_8: TfrxMemoView
          Left = 737.008350000000000000
          Top = 15.874026000000020000
          Width = 49.133858270000000000
          Height = 16.251979000000000000
          Restrictions = [rfDontSize, rfDontMove, rfDontDelete]
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#1113#1056#1115#1056#152#1056#8221)
          ParentFont = False
          VAlign = vaCenter
        end
        object mBh_10: TfrxMemoView
          Left = 835.276161730000000000
          Top = 15.874026000000020000
          Width = 49.133858270000000000
          Height = 16.251979000000000000
          Restrictions = [rfDontSize, rfDontMove, rfDontDelete]
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#1115#1056#1119)
          ParentFont = False
          VAlign = vaCenter
        end
        object mBh_11: TfrxMemoView
          Left = 884.410051730000000000
          Top = 15.874026000000020000
          Width = 49.133858270000000000
          Height = 16.251979000000000000
          Restrictions = [rfDontSize, rfDontMove, rfDontDelete]
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#1113#1057#8364#1057#8218'.')
          ParentFont = False
          VAlign = vaCenter
        end
        object mBh_12: TfrxMemoView
          Left = 933.543954430000000000
          Top = 15.874026000000020000
          Width = 68.787401570000000000
          Height = 16.251979000000000000
          Restrictions = [rfDontSize, rfDontMove, rfDontDelete]
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#1118#1056#1111#1056#183)
          ParentFont = False
          VAlign = vaCenter
        end
        object mBh_13: TfrxMemoView
          Left = 1002.331356000000000000
          Top = 15.874026000000020000
          Width = 78.614173230000000000
          Height = 16.251979000000000000
          Restrictions = [rfDontSize, rfDontMove, rfDontDelete]
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#1118#1057#8364#1057#8218'.')
          ParentFont = False
          VAlign = vaCenter
        end
        object mBh_9: TfrxMemoView
          Left = 786.142271730000000000
          Top = 15.874026000000020000
          Width = 49.133858270000000000
          Height = 16.251979000000000000
          Restrictions = [rfDontSize, rfDontMove, rfDontDelete]
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#8226#1056#1116)
          ParentFont = False
          VAlign = vaCenter
        end
        object mKMh_2: TfrxMemoView
          Left = 49.133915390000000000
          Top = 32.126005000000080000
          Width = 452.031762610000000000
          Height = 15.874015750000000000
          Restrictions = [rfDontSize, rfDontMove, rfDontDelete]
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            
              #1056#1116#1056#176#1056#1105#1056#1112#1056#181#1056#1029#1056#1109#1056#1030#1056#176#1056#1029#1056#1105#1056#181' '#1056#1169#1056#181#1057#8218#1056#176#1056#187#1056#1105', '#1057#1027#1056#177'. '#1056#181#1056#1169#1056#1105#1056#1029#1056#1105#1057#8224#1057#8249' '#1056#1105#1056#187 +
              #1056#1105' '#1056#1112#1056#176#1057#8218#1056#181#1057#1026#1056#1105#1056#176#1056#187#1056#176)
          ParentFont = False
          Style = 'B10'
          VAlign = vaCenter
        end
        object mKMh_3: TfrxMemoView
          Left = 501.165678000000000000
          Top = 32.126005000000080000
          Width = 284.976377950000000000
          Height = 15.874015750000000000
          Restrictions = [rfDontSize, rfDontMove, rfDontDelete]
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#1115#1056#177#1056#1109#1056#183#1056#1029#1056#176#1057#8225#1056#181#1056#1029#1056#1105#1056#181', '#1056#1108#1056#1109#1056#1169)
          ParentFont = False
          Style = 'B10'
          VAlign = vaCenter
        end
        object mKMh_4: TfrxMemoView
          Left = 786.142240000000000000
          Top = 32.126005000000080000
          Width = 49.133858270000000000
          Height = 15.874015750000000000
          Restrictions = [rfDontSize, rfDontMove, rfDontDelete]
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#1115#1056#1119#1056#1119)
          ParentFont = False
          Style = 'B10'
          VAlign = vaCenter
        end
        object mKMh_5: TfrxMemoView
          Left = 835.276161730000000000
          Top = 32.126005000000080000
          Width = 49.133858270000000000
          Height = 15.874015750000000000
          Restrictions = [rfDontSize, rfDontMove, rfDontDelete]
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#8226#1056#8217)
          ParentFont = False
          Style = 'B10'
          VAlign = vaCenter
        end
        object mKMh_6: TfrxMemoView
          Left = 884.410051730000000000
          Top = 32.126005000000080000
          Width = 49.133858270000000000
          Height = 15.874015750000000000
          Restrictions = [rfDontSize, rfDontMove, rfDontDelete]
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#8226#1056#1116)
          ParentFont = False
          Style = 'B10'
          VAlign = vaCenter
        end
        object mKMh_7: TfrxMemoView
          Left = 933.543910000000000000
          Top = 32.126005000000080000
          Width = 68.787446000000000000
          Height = 15.874015750000000000
          Restrictions = [rfDontSize, rfDontMove, rfDontDelete]
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#1113#1056#152)
          ParentFont = False
          Style = 'B10'
          VAlign = vaCenter
        end
        object mKMh_8: TfrxMemoView
          Left = 1002.331356000000000000
          Top = 32.126005000000080000
          Width = 78.614173230000000000
          Height = 15.874015750000000000
          Restrictions = [rfDontSize, rfDontMove, rfDontDelete]
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#1116'.'#1057#1026#1056#176#1057#1027#1057#8230'.')
          ParentFont = False
          Style = 'B10'
          VAlign = vaCenter
        end
      end
      object PageHeader1: TfrxPageHeader
        Height = 115.275665000000000000
        Top = 18.897650000000000000
        Width = 1080.945580000000000000
        OnBeforePrint = 'PageHeader1OnBeforePrint'
        Stretched = True
        object mB5F1a_1: TfrxMemoView
          Top = 83.149660000000000000
          Width = 619.086868030000000000
          Height = 32.125984250000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB5F1_5: TfrxMemoView
          Left = 1021.984950080000000000
          Top = 83.149680750000000000
          Width = 58.960629920000000000
          Height = 32.125984250000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB5F1_4: TfrxMemoView
          Left = 963.024282080000000000
          Top = 83.149680750000000000
          Width = 58.960629920000000000
          Height = 32.125984250000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB5F1_3: TfrxMemoView
          Left = 786.142354240000000000
          Top = 83.149680750000000000
          Width = 176.881889760000000000
          Height = 32.125984250000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB5F1_2: TfrxMemoView
          Left = 560.126491970000000000
          Top = 83.149680750000000000
          Width = 226.015748030000000000
          Height = 32.125984250000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB5F1_1: TfrxMemoView
          Left = 0.000145970000000000
          Top = 83.149680750000000000
          Width = 560.126200030000000000
          Height = 32.125984250000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object lB5F1: TfrxLineView
          Left = 560.126346000000000000
          Top = 83.149660000000000000
          Height = 12.094496000000000000
          ShowHint = False
          Diagonal = True
        end
        object mB4F1_1_1: TfrxMemoView
          Top = 35.149629000000000000
          Width = 68.787446000000000000
          Height = 15.874026000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8 = (
            #1056#8221#1057#1107#1056#177#1056#187'.')
          ParentFont = False
          VAlign = vaCenter
        end
        object mB4F1_1_2: TfrxMemoView
          Left = 68.787446000000000000
          Top = 35.149629000000000000
          Width = 78.614224000000000000
          Height = 15.874026000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB4F1_1_3: TfrxMemoView
          Left = 147.401670000000000000
          Top = 35.149629000000000000
          Width = 78.614224000000000000
          Height = 15.874026000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB4F1_1_4: TfrxMemoView
          Left = 226.015894000000000000
          Top = 35.149629000000000000
          Width = 58.960668000000000000
          Height = 15.874026000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB4F1_2_1: TfrxMemoView
          Top = 51.023655000000010000
          Width = 68.787446000000000000
          Height = 16.251979000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8 = (
            #1056#8217#1056#183#1056#176#1056#1112'.')
          ParentFont = False
          VAlign = vaCenter
        end
        object mB4F1_2_2: TfrxMemoView
          Left = 68.787446000000000000
          Top = 51.023655000000010000
          Width = 78.614224000000000000
          Height = 16.251979000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB4F1_2_3: TfrxMemoView
          Left = 147.401670000000000000
          Top = 51.023655000000010000
          Width = 78.614224000000000000
          Height = 16.251979000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB4F1_2_4: TfrxMemoView
          Left = 226.015894000000000000
          Top = 51.023655000000010000
          Width = 58.960668000000000000
          Height = 16.251979000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB4F1_3_1: TfrxMemoView
          Top = 67.275634000000000000
          Width = 68.787446000000000000
          Height = 15.874026000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8 = (
            #1056#1119#1056#1109#1056#1169#1056#187'.')
          ParentFont = False
          VAlign = vaCenter
        end
        object mB4F1_3_2: TfrxMemoView
          Left = 68.787446000000000000
          Top = 67.275634000000000000
          Width = 78.614224000000000000
          Height = 15.874026000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB4F1_3_3: TfrxMemoView
          Left = 147.401670000000000000
          Top = 67.275634000000000000
          Width = 78.614224000000000000
          Height = 15.874026000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB4F1_3_4: TfrxMemoView
          Left = 226.015894000000000000
          Top = 67.275634000000000000
          Width = 58.960668000000000000
          Height = 15.874026000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB3F1a_1_1: TfrxMemoView
          Left = 776.315462000000000000
          Top = 18.897650000000000000
          Width = 39.307112000000000000
          Height = 15.874026000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB3F1a_1_2: TfrxMemoView
          Left = 815.622574000000000000
          Top = 18.897650000000000000
          Width = 39.307112000000000000
          Height = 15.874026000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB3F1a_1_3: TfrxMemoView
          Left = 854.929686000000000000
          Top = 18.897650000000000000
          Width = 88.441002000000000000
          Height = 15.874026000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB3F1a_1_4: TfrxMemoView
          Left = 943.370688000000000000
          Top = 18.897650000000000000
          Width = 78.614224000000000000
          Height = 15.874026000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB3F1a_1_5: TfrxMemoView
          Left = 1021.984912000000000000
          Top = 18.897650000000000000
          Width = 58.960668000000000000
          Height = 15.874026000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB3F1a_2_1: TfrxMemoView
          Left = 776.315462000000000000
          Top = 34.771676000000000000
          Width = 39.307112000000000000
          Height = 16.251979000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB3F1a_2_2: TfrxMemoView
          Left = 815.622574000000000000
          Top = 34.771676000000000000
          Width = 39.307112000000000000
          Height = 16.251979000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB3F1a_2_3: TfrxMemoView
          Left = 854.929686000000000000
          Top = 34.771676000000000000
          Width = 88.441002000000000000
          Height = 16.251979000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB3F1a_2_4: TfrxMemoView
          Left = 943.370688000000000000
          Top = 34.771676000000000000
          Width = 78.614224000000000000
          Height = 16.251979000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB3F1a_2_5: TfrxMemoView
          Left = 1021.984912000000000000
          Top = 34.771676000000000000
          Width = 58.960668000000000000
          Height = 16.251979000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB3F1a_3_1: TfrxMemoView
          Left = 776.315462000000000000
          Top = 51.023655000000010000
          Width = 39.307112000000000000
          Height = 15.874026000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB3F1a_3_2: TfrxMemoView
          Left = 815.622574000000000000
          Top = 51.023655000000010000
          Width = 39.307112000000000000
          Height = 15.874026000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB3F1a_3_3: TfrxMemoView
          Left = 854.929686000000000000
          Top = 51.023655000000010000
          Width = 88.441002000000000000
          Height = 15.874026000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB3F1a_3_4: TfrxMemoView
          Left = 943.370688000000000000
          Top = 51.023655000000010000
          Width = 78.614224000000000000
          Height = 15.874026000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB3F1a_3_5: TfrxMemoView
          Left = 1021.984912000000000000
          Top = 51.023655000000010000
          Width = 58.960668000000000000
          Height = 15.874026000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB3F1a_4_1: TfrxMemoView
          Left = 776.315462000000000000
          Top = 66.897681000000000000
          Width = 39.307112000000000000
          Height = 16.251979000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB3F1a_4_2: TfrxMemoView
          Left = 815.622574000000000000
          Top = 66.897681000000000000
          Width = 39.307112000000000000
          Height = 16.251979000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB3F1a_4_3: TfrxMemoView
          Left = 854.929686000000000000
          Top = 66.897681000000000000
          Width = 88.441002000000000000
          Height = 16.251979000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB3F1a_4_4: TfrxMemoView
          Left = 943.370688000000000000
          Top = 66.897681000000000000
          Width = 78.614224000000000000
          Height = 16.251979000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB3F1a_4_5: TfrxMemoView
          Left = 1021.984912000000000000
          Top = 66.897681000000000000
          Width = 58.960668000000000000
          Height = 16.251979000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB3F1c_1_1: TfrxMemoView
          Left = 471.685344000000000000
          Top = 51.023655000000010000
          Width = 39.307112000000000000
          Height = 15.874026000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
        end
        object mB3F1c_1_2: TfrxMemoView
          Left = 510.992456000000000000
          Top = 51.023655000000010000
          Width = 39.307112000000000000
          Height = 15.874026000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
        end
        object mB3F1c_1_3: TfrxMemoView
          Left = 550.299568000000000000
          Top = 51.023655000000010000
          Width = 88.441002000000000000
          Height = 15.874026000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB3F1c_1_4: TfrxMemoView
          Left = 638.740570000000000000
          Top = 51.023655000000010000
          Width = 78.614224000000000000
          Height = 15.874026000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB3F1c_1_5: TfrxMemoView
          Left = 717.354794000000000000
          Top = 51.023655000000010000
          Width = 58.960668000000000000
          Height = 15.874026000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB3F1c_2_1: TfrxMemoView
          Left = 471.685344000000000000
          Top = 66.897681000000000000
          Width = 39.307112000000000000
          Height = 16.251979000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
        end
        object mB3F1c_2_2: TfrxMemoView
          Left = 510.992456000000000000
          Top = 66.897681000000000000
          Width = 39.307112000000000000
          Height = 16.251979000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
        end
        object mB3F1c_2_3: TfrxMemoView
          Left = 550.299568000000000000
          Top = 66.897681000000000000
          Width = 88.441002000000000000
          Height = 16.251979000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB3F1c_2_4: TfrxMemoView
          Left = 638.740570000000000000
          Top = 66.897681000000000000
          Width = 78.614224000000000000
          Height = 16.251979000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB3F1c_2_5: TfrxMemoView
          Left = 717.354794000000000000
          Top = 66.897681000000000000
          Width = 58.960668000000000000
          Height = 16.251979000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB0_1: TfrxMemoView
          Left = 777.449321000000000000
          Width = 167.055226000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#8220#1056#1115#1056#1038#1056#1118' 3.1118-82')
          ParentFont = False
          VAlign = vaBottom
        end
        object mB0_2: TfrxMemoView
          Left = 943.370688000000000000
          Width = 137.574892000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'GOST type B'
          Font.Style = [fsItalic]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#164#1056#1109#1057#1026#1056#1112#1056#176' 2')
          ParentFont = False
          VAlign = vaBottom
        end
        object mB5F1a_4: TfrxMemoView
          Left = 1021.984950080000000000
          Top = 83.149680750000000000
          Width = 58.960629920000000000
          Height = 32.125984250000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB5F1a_3: TfrxMemoView
          Left = 845.102908000000000000
          Top = 83.149660000000000000
          Width = 176.881889760000000000
          Height = 32.125984250000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object mB5F1a_2: TfrxMemoView
          Left = 619.087014000000000000
          Top = 83.149660000000000000
          Width = 226.015748030000000000
          Height = 32.125984250000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftRight, ftTop, ftBottom]
          ParentFont = False
          VAlign = vaCenter
        end
        object lB5F1a: TfrxLineView
          Left = 619.087014000000000000
          Top = 83.149660000000000000
          Height = 12.094496000000000000
          ShowHint = False
          Diagonal = True
        end
      end
      object DetailData1: TfrxDetailData
        Height = 61.606339000000000000
        Top = 440.693198000000000000
        Width = 1080.945580000000000000
        DataSet = frxrprt1.qryLines
        DataSetName = 'qryLines'
        RowCount = 0
        Stretched = True
      end
      object Band18: TfrxSubdetailData
        Height = 34.393702250000000000
        Top = 525.354670000000100000
        Width = 1080.945580000000000000
        DataSet = frxrprt1.qryBand18
        DataSetName = 'qryBand19'
        RowCount = 0
        Stretched = True
        object m18_0: TfrxMemoView
          Width = 49.133890000000000000
          Height = 31.748031496063000000
          ShowHint = False
          DataSet = frxrprt1.qryForms
          DataSetName = 'qryForms'
          DisplayFormat.FormatStr = '%2.2u '
          DisplayFormat.Kind = fkNumeric
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -19
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          Memo.UTF8 = (
            '[qryLines."LINE_NO"]')
          ParentFont = False
          VAlign = vaBottom
        end
        object m18_1: TfrxMemoView
          Width = 49.133890000000000000
          Height = 31.748031496063000000
          ShowHint = False
          DataSet = frxrprt1.qryForms
          DataSetName = 'qryForms'
          DisplayFormat.FormatStr = '%2.2u '
          DisplayFormat.Kind = fkNumeric
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8 = (
            '[<qryLines."LITERA">]')
          ParentFont = False
          VAlign = vaBottom
        end
        object Memo2: TfrxMemoView
          Left = 49.133890000000000000
          Width = 452.031788000000000000
          Height = 31.748031500000000000
          ShowHint = False
          DataField = 'DET_NAME'
          DataSet = frxrprt1.qryBand18
          DataSetName = 'qryBand19'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[qryBand19."DET_NAME"]')
          ParentFont = False
          Style = 'Mipgost18'
          VAlign = vaBottom
        end
        object Memo4: TfrxMemoView
          Left = 501.165678000000000000
          Width = 579.779902000000000000
          Height = 31.748031500000000000
          ShowHint = False
          DataField = 'DET_LABELS'
          DataSet = frxrprt1.qryBand18
          DataSetName = 'qryBand19'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8 = (
            '[qryBand19."DET_LABELS"]')
          ParentFont = False
          Style = 'Mipgost18'
          VAlign = vaBottom
        end
      end
      object Band25: TfrxSubdetailData
        Height = 35.905535000000000000
        Top = 582.803526000000000000
        Width = 1080.945580000000000000
        DataSet = frxrprt1.qryBand25
        DataSetName = 'qryBand25'
        RowCount = 0
        Stretched = True
        object m25_0: TfrxMemoView
          Width = 49.133890000000000000
          Height = 31.748031496063000000
          ShowHint = False
          DataSet = frxrprt1.qryForms
          DataSetName = 'qryForms'
          DisplayFormat.FormatStr = '%2.2u'
          DisplayFormat.Kind = fkNumeric
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -19
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          Memo.UTF8 = (
            '[qryLines."LINE_NO"] ')
          ParentFont = False
          VAlign = vaBottom
        end
        object m25_2: TfrxMemoView
          Left = 49.133890000000000000
          Width = 39.307112000000000000
          Height = 31.748031500000000000
          ShowHint = False
          DataSet = frxrprt1.qryForms
          DataSetName = 'qryForms'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[qryBand25."SHOP_CODE"]')
          ParentFont = False
          Style = 'Mipgost18'
          VAlign = vaBottom
        end
        object m25_3: TfrxMemoView
          Left = 88.441002000000000000
          Width = 39.307112000000000000
          Height = 31.748031496063000000
          ShowHint = False
          DataSet = frxrprt1.qryForms
          DataSetName = 'qryForms'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[qryBand25."AREA_CODE"]')
          ParentFont = False
          Style = 'Mipgost18'
          VAlign = vaBottom
        end
        object m25_4: TfrxMemoView
          Left = 127.748114000000000000
          Width = 39.307112000000000000
          Height = 31.748031496063000000
          ShowHint = False
          DataSet = frxrprt1.qryForms
          DataSetName = 'qryForms'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            
              '[IIF(<qryBand25."WORKPLACE_CODE"> = null, '#39'-'#39', <qryBand25."WORKP' +
              'LACE_CODE">)]'
            '[qryBand25."WORKPLACE_CODE"]')
          ParentFont = False
          Style = 'Mipgost18'
          VAlign = vaBottom
        end
        object m25_5: TfrxMemoView
          Left = 167.055226000000000000
          Width = 49.133890000000000000
          Height = 31.748031496063000000
          ShowHint = False
          DataSet = frxrprt1.qryForms
          DataSetName = 'qryForms'
          DisplayFormat.Kind = fkNumeric
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[qryBand25."OPER_NUM"]')
          ParentFont = False
          Style = 'Mipgost18'
          VAlign = vaBottom
        end
        object m25_6: TfrxMemoView
          Left = 216.189116000000000000
          Width = 284.976562000000000000
          Height = 31.748031500000000000
          ShowHint = False
          DataSet = frxrprt1.qryForms
          DataSetName = 'qryForms'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[qryBand25."OPER_NAME"]')
          ParentFont = False
          Style = 'Mipgost18'
          VAlign = vaBottom
        end
        object m25_7: TfrxMemoView
          Left = 501.165678000000000000
          Width = 579.779902000000000000
          Height = 31.748031496063000000
          ShowHint = False
          DataSet = frxrprt1.qryForms
          DataSetName = 'qryForms'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          Style = 'Mipgost18'
          VAlign = vaBottom
        end
        object m25_1: TfrxMemoView
          Width = 49.133890000000000000
          Height = 31.748031496063000000
          ShowHint = False
          DataSet = frxrprt1.qryForms
          DataSetName = 'qryForms'
          DisplayFormat.FormatStr = '%2.2u '
          DisplayFormat.Kind = fkNumeric
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8 = (
            '[<qryLines."LITERA">]')
          ParentFont = False
          VAlign = vaBottom
        end
      end
      object Band11: TfrxSubdetailData
        Height = 35.149629000000000000
        Top = 641.764194000000000000
        Width = 1080.945580000000000000
        DataSet = frxrprt1.qryBand11
        DataSetName = 'qryBand11'
        RowCount = 0
        Stretched = True
        object m11_0: TfrxMemoView
          Width = 49.133890000000000000
          Height = 31.748031496063000000
          ShowHint = False
          DataSet = frxrprt1.qryForms
          DataSetName = 'qryForms'
          DisplayFormat.FormatStr = '%2.2u'
          DisplayFormat.Kind = fkNumeric
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -19
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          Memo.UTF8 = (
            '[qryLines."LINE_NO"] ')
          ParentFont = False
          VAlign = vaBottom
        end
        object Memo12: TfrxMemoView
          Left = 49.133890000000000000
          Width = 452.031788000000000000
          Height = 31.748031496063000000
          ShowHint = False
          DataSet = frxrprt1.qryForms
          DataSetName = 'qryForms'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8 = (
            '[qryBand11."DET_NAME"]')
          ParentFont = False
          Style = 'Mipgost18'
          VAlign = vaBottom
        end
        object Memo13: TfrxMemoView
          Left = 501.165678000000000000
          Width = 284.976562000000000000
          Height = 31.748031496063000000
          ShowHint = False
          DataSet = frxrprt1.qryForms
          DataSetName = 'qryForms'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[qryBand11."DET_LABEL"]')
          ParentFont = False
          Style = 'Mipgost18'
          VAlign = vaBottom
        end
        object Memo14: TfrxMemoView
          Left = 786.142240000000000000
          Width = 49.133890000000000000
          Height = 31.748031496063000000
          ShowHint = False
          DataSet = frxrprt1.qryForms
          DataSetName = 'qryForms'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[qryBand11."OPP"]')
          ParentFont = False
          Style = 'Mipgost18'
          VAlign = vaBottom
        end
        object Memo15: TfrxMemoView
          Left = 835.276130000000000000
          Width = 49.133890000000000000
          Height = 31.748031496063000000
          ShowHint = False
          DataSet = frxrprt1.qryForms
          DataSetName = 'qryForms'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[qryBand11."KEI"]')
          ParentFont = False
          Style = 'Mipgost18'
          VAlign = vaBottom
        end
        object Memo16: TfrxMemoView
          Left = 884.410020000000000000
          Width = 49.133890000000000000
          Height = 31.748031496063000000
          ShowHint = False
          DataSet = frxrprt1.qryForms
          DataSetName = 'qryForms'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[qryBand11."EN"]')
          ParentFont = False
          Style = 'Mipgost18'
          VAlign = vaBottom
        end
        object Memo17: TfrxMemoView
          Left = 933.543910000000000000
          Width = 68.787446000000000000
          Height = 31.748031496063000000
          ShowHint = False
          DataSet = frxrprt1.qryForms
          DataSetName = 'qryForms'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[qryBand11."KI"]')
          ParentFont = False
          Style = 'Mipgost18'
          VAlign = vaBottom
        end
        object Memo18: TfrxMemoView
          Left = 1002.331356000000000000
          Width = 78.614224000000000000
          Height = 31.748031496063000000
          ShowHint = False
          DataSet = frxrprt1.qryForms
          DataSetName = 'qryForms'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          Style = 'Mipgost18'
          VAlign = vaBottom
        end
        object m11_1: TfrxMemoView
          Width = 49.133890000000000000
          Height = 31.748031496063000000
          ShowHint = False
          DataSet = frxrprt1.qryForms
          DataSetName = 'qryForms'
          DisplayFormat.FormatStr = '%2.2u '
          DisplayFormat.Kind = fkNumeric
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8 = (
            '[IIF(<qryLines."BLOCK_ROWNO">=1,<qryLines."LITERA">,'#39#39')]')
          ParentFont = False
          VAlign = vaBottom
        end
      end
      object Band34: TfrxSubdetailData
        Height = 35.149629000000000000
        Top = 699.968956000000000000
        Width = 1080.945580000000000000
        DataSet = frxrprt1.qryBand34
        DataSetName = 'qryBand34'
        RowCount = 0
        Stretched = True
        object m34_0: TfrxMemoView
          Width = 49.133890000000000000
          Height = 31.748031496063000000
          ShowHint = False
          DataSet = frxrprt1.qryForms
          DataSetName = 'qryForms'
          DisplayFormat.FormatStr = '%2.2u'
          DisplayFormat.Kind = fkNumeric
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -19
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          Memo.UTF8 = (
            '[qryLines."LINE_NO"] ')
          ParentFont = False
          VAlign = vaBottom
        end
        object Memo5: TfrxMemoView
          Left = 49.133890000000000000
          Width = 452.031788000000000000
          Height = 31.748031500000000000
          ShowHint = False
          DataSet = frxrprt1.qryForms
          DataSetName = 'qryForms'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8 = (
            '[qryBand34."HALF_NAME"]')
          ParentFont = False
          Style = 'Mipgost18'
          VAlign = vaBottom
        end
        object Memo6: TfrxMemoView
          Left = 501.165678000000000000
          Width = 284.976562000000000000
          Height = 31.748031500000000000
          ShowHint = False
          DataSet = frxrprt1.qryForms
          DataSetName = 'qryForms'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[qryBand34."HALF_LABEL"]')
          ParentFont = False
          Style = 'Mipgost18'
          VAlign = vaBottom
        end
        object Memo7: TfrxMemoView
          Left = 786.142240000000000000
          Width = 49.133890000000000000
          Height = 31.748031496063000000
          ShowHint = False
          DataSet = frxrprt1.qryForms
          DataSetName = 'qryForms'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[qryBand34."OPP"]')
          ParentFont = False
          Style = 'Mipgost18'
          VAlign = vaBottom
        end
        object Memo8: TfrxMemoView
          Left = 835.276130000000000000
          Width = 49.133890000000000000
          Height = 31.748031496063000000
          ShowHint = False
          DataSet = frxrprt1.qryForms
          DataSetName = 'qryForms'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[qryBand34."KEI"]')
          ParentFont = False
          Style = 'Mipgost18'
          VAlign = vaBottom
        end
        object Memo9: TfrxMemoView
          Left = 884.410020000000000000
          Width = 49.133890000000000000
          Height = 31.748031496063000000
          ShowHint = False
          DataSet = frxrprt1.qryForms
          DataSetName = 'qryForms'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[qryBand34."EN"]')
          ParentFont = False
          Style = 'Mipgost18'
          VAlign = vaBottom
        end
        object Memo10: TfrxMemoView
          Left = 933.543910000000000000
          Width = 68.787446000000000000
          Height = 31.748031496063000000
          ShowHint = False
          DataSet = frxrprt1.qryForms
          DataSetName = 'qryForms'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[qryBand34."KI"]')
          ParentFont = False
          Style = 'Mipgost18'
          VAlign = vaBottom
        end
        object Memo19: TfrxMemoView
          Left = 1002.331356000000000000
          Width = 78.614224000000000000
          Height = 31.748031496063000000
          ShowHint = False
          DataSet = frxrprt1.qryForms
          DataSetName = 'qryForms'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          Style = 'Mipgost18'
          VAlign = vaBottom
        end
        object m34_1: TfrxMemoView
          Width = 49.133890000000000000
          Height = 31.748031496063000000
          ShowHint = False
          DataSet = frxrprt1.qryForms
          DataSetName = 'qryForms'
          DisplayFormat.FormatStr = '%2.2u '
          DisplayFormat.Kind = fkNumeric
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8 = (
            '[IIF(<qryLines."BLOCK_ROWNO">=1,<qryLines."LITERA">,'#39#39')]')
          ParentFont = False
          VAlign = vaBottom
        end
      end
      object Band13: TfrxSubdetailData
        Height = 35.149629000000000000
        Top = 758.173718000000000000
        Width = 1080.945580000000000000
        DataSet = frxrprt1.qryBand13
        DataSetName = 'qryBand13'
        RowCount = 0
        Stretched = True
        object m13_0: TfrxMemoView
          Width = 49.133890000000000000
          Height = 31.748031496063000000
          ShowHint = False
          DataSet = frxrprt1.qryForms
          DataSetName = 'qryForms'
          DisplayFormat.FormatStr = '%2.2u'
          DisplayFormat.Kind = fkNumeric
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -19
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          Memo.UTF8 = (
            '[qryLines."LINE_NO"] ')
          ParentFont = False
          VAlign = vaBottom
        end
        object Memo21: TfrxMemoView
          Left = 49.133890000000000000
          Width = 452.031788000000000000
          Height = 31.748031496063000000
          ShowHint = False
          DataSet = frxrprt1.qryForms
          DataSetName = 'qryForms'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8 = (
            '[qryBand13."MAT_NAME"]')
          ParentFont = False
          Style = 'Mipgost18'
          VAlign = vaBottom
        end
        object Memo22: TfrxMemoView
          Left = 501.165678000000000000
          Width = 284.976562000000000000
          Height = 31.748031496063000000
          ShowHint = False
          DataSet = frxrprt1.qryForms
          DataSetName = 'qryForms'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[qryBand13."MAT_LABEL"]')
          ParentFont = False
          Style = 'Mipgost18'
          VAlign = vaBottom
        end
        object Memo23: TfrxMemoView
          Left = 786.142240000000000000
          Width = 49.133890000000000000
          Height = 31.748031496063000000
          ShowHint = False
          DataSet = frxrprt1.qryForms
          DataSetName = 'qryForms'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[qryBand13."OPP"]')
          ParentFont = False
          Style = 'Mipgost18'
          VAlign = vaBottom
        end
        object Memo24: TfrxMemoView
          Left = 835.276130000000000000
          Width = 49.133890000000000000
          Height = 31.748031496063000000
          ShowHint = False
          DataSet = frxrprt1.qryForms
          DataSetName = 'qryForms'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[qryBand13."KEI"]')
          ParentFont = False
          Style = 'Mipgost18'
          VAlign = vaBottom
        end
        object Memo25: TfrxMemoView
          Left = 884.410020000000000000
          Width = 49.133890000000000000
          Height = 31.748031496063000000
          ShowHint = False
          DataSet = frxrprt1.qryForms
          DataSetName = 'qryForms'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[qryBand13."EN"]')
          ParentFont = False
          Style = 'Mipgost18'
          VAlign = vaBottom
        end
        object Memo26: TfrxMemoView
          Left = 933.543910000000000000
          Width = 68.787446000000000000
          Height = 31.748031496063000000
          ShowHint = False
          DataSet = frxrprt1.qryForms
          DataSetName = 'qryForms'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          ParentFont = False
          Style = 'Mipgost18'
          VAlign = vaBottom
        end
        object Memo27: TfrxMemoView
          Left = 1002.331356000000000000
          Width = 78.614224000000000000
          Height = 31.748031496063000000
          ShowHint = False
          DataField = 'NORMRASH'
          DataSet = frxrprt1.qryBand13
          DataSetName = 'qryBand13'
          DisplayFormat.FormatStr = '%g'
          DisplayFormat.Kind = fkNumeric
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[qryBand13."NORMRASH"]')
          ParentFont = False
          Style = 'Mipgost18'
          VAlign = vaBottom
        end
        object m13_1: TfrxMemoView
          Top = 0.000020749999976033
          Width = 49.133890000000000000
          Height = 31.748031496063000000
          ShowHint = False
          DataSet = frxrprt1.qryForms
          DataSetName = 'qryForms'
          DisplayFormat.FormatStr = '%2.2u '
          DisplayFormat.Kind = fkNumeric
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8 = (
            '[IIF(<qryLines."BLOCK_ROWNO">=1,<qryLines."LITERA">,'#39#39')]')
          ParentFont = False
          VAlign = vaBottom
        end
      end
      object Band00: TfrxSubdetailData
        Height = 35.149629000000000000
        Top = 816.378480000000000000
        Width = 1080.945580000000000000
        DataSet = frxrprt1.qryBand00
        DataSetName = 'qryBand00'
        RowCount = 0
        Stretched = True
        object Memo1: TfrxMemoView
          Width = 49.133890000000000000
          Height = 31.748031496063000000
          ShowHint = False
          DataSet = frxrprt1.qryForms
          DataSetName = 'qryForms'
          DisplayFormat.FormatStr = '%2.2u'
          DisplayFormat.Kind = fkNumeric
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -19
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          Memo.UTF8 = (
            '[qryLines."LINE_NO"] ')
          ParentFont = False
          VAlign = vaBottom
        end
        object Memo3: TfrxMemoView
          Left = 49.133890000000000000
          Width = 1031.811690000000000000
          Height = 31.748031496063000000
          ShowHint = False
          DataSet = frxrprt1.qryForms
          DataSetName = 'qryForms'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -24
          Font.Name = 'Mipgost'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
          Style = 'Mipgost18'
          VAlign = vaBottom
        end
      end
    end
  end
  object frxfbcmpnts1: TfrxFIBComponents
    Left = 232
    Top = 88
  end
  object frxdbdtst1: TfrxDBDataset
    UserName = 'frxDBDataset1'
    CloseDataSource = False
    BCDToCurrency = False
    Left = 304
    Top = 104
  end
  object frxpdfxprt1: TfrxPDFExport
    FileName = 'D:\GOST\Test.pdf'
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    EmbeddedFonts = True
    OpenAfterExport = True
    PrintOptimized = False
    Outline = False
    Background = False
    HTMLTags = True
    Author = 'FastReport'
    Subject = 'FastReport PDF export'
    ProtectionFlags = [ePrint, eModify, eCopy, eAnnot]
    HideToolbar = False
    HideMenubar = False
    HideWindowUI = False
    FitWindow = False
    CenterWindow = False
    PrintScaling = False
    Left = 360
    Top = 104
  end
end
