object Form1: TForm1
  Left = 325
  Top = 211
  Width = 276
  Height = 160
  Caption = 'Fast Report demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 76
    Top = 52
    Width = 121
    Height = 25
    Caption = 'Design report'
    TabOrder = 0
    OnClick = Button1Click
  end
  object BitBtn1: TBitBtn
    Left = 76
    Top = 80
    Width = 121
    Height = 25
    Caption = 'Show report'
    TabOrder = 1
    OnClick = BitBtn1Click
  end
  object frxReport1: TfrxReport
    DotMatrixReport = False
    EngineOptions.MaxMemSize = 10000000
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator]
    PreviewOptions.Zoom = 1
    PrintOptions.Printer = 'Default'
    ReportOptions.CreateDate = 38261.4964982986
    ReportOptions.LastChange = 38261.6989644792
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 24
    Top = 16
    Datasets = <
      item
        DataSet = frxReport1.IBDACTable1
        DataSetName = 'IBDACTable1'
      end
      item
        DataSet = frxReport1.IBDACQuery1
        DataSetName = 'IBDACQuery1'
      end>
    Variables = <>
    Style = <>
    object Page1: TfrxReportPage
      PaperWidth = 210
      PaperHeight = 297
      PaperSize = 9
      LeftMargin = 10
      RightMargin = 10
      TopMargin = 10
      BottomMargin = 10
      object ReportTitle1: TfrxReportTitle
        Height = 54.01577
        Top = 18.89765
        Width = 718.1107
        object Memo6: TfrxMemoView
          Left = 3.77953
          Top = 8.81890333
          Width = 714.33117
          Height = 40.31498667
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -27
          Font.Name = 'Arial'
          Font.Style = [fsBold, fsItalic]
          HAlign = haCenter
          Memo.UTF8 = (
            'Employees Report')
          ParentFont = False
        end
      end
      object MasterData1: TfrxMasterData
        Height = 31.33859
        Top = 177.63791
        Width = 718.1107
        DataSet = frxReport1.IBDACTable1
        DataSetName = 'IBDACTable1'
        RowCount = 0
        object Memo7: TfrxMemoView
          Left = 10.07874667
          Top = 7.55905999999999
          Width = 99.52762333
          Height = 21.41733667
          Memo.UTF8 = (
            'Departament')
        end
        object Memo8: TfrxMemoView
          Left = 249.44898
          Top = 7.55905999999999
          Width = 31.49608333
          Height = 21.41733667
          Memo.UTF8 = (
            'No')
        end
        object Memo9: TfrxMemoView
          Left = 415.7483
          Top = 7.55905999999999
          Width = 54.17326333
          Height = 21.41733667
          Memo.UTF8 = (
            'Location')
        end
        object Memo10: TfrxMemoView
          Left = 291.02381
          Top = 7.55905999999999
          Width = 79.37013
          Height = 18.89765
          DataField = 'DEPTNO'
          DataSet = frxReport1.IBDACTable1
          DataSetName = 'IBDACTable1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsItalic]
          Memo.UTF8 = (
            '[IBDACTable1."DEPTNO"]')
          ParentFont = False
        end
        object Memo11: TfrxMemoView
          Left = 117.16543
          Top = 7.55905999999999
          Width = 113.3859
          Height = 18.89765
          DataField = 'DNAME'
          DataSet = frxReport1.IBDACTable1
          DataSetName = 'IBDACTable1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsItalic]
          Memo.UTF8 = (
            '[IBDACTable1."DNAME"]')
          ParentFont = False
        end
        object Memo12: TfrxMemoView
          Left = 483.77984
          Top = 7.55905999999999
          Width = 105.82684
          Height = 18.89765
          DataField = 'LOC'
          DataSet = frxReport1.IBDACTable1
          DataSetName = 'IBDACTable1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsItalic]
          Memo.UTF8 = (
            '[IBDACTable1."LOC"]')
          ParentFont = False
        end
      end
      object PageFooter1: TfrxPageFooter
        Height = 38.89765
        Top = 498.89796
        Width = 718.1107
        object Memo1: TfrxMemoView
          Left = 642.5201
          Top = 18.8976500000001
          Width = 75.5906
          Height = 18.89765
          HAlign = haRight
          Memo.UTF8 = (
            '[Page#]')
        end
      end
      object DetailData1: TfrxDetailData
        Height = 26.45671
        Top = 291.02381
        Width = 718.1107
        DataSet = frxReport1.IBDACQuery1
        DataSetName = 'IBDACQuery1'
        RowCount = 0
        object Memo5: TfrxMemoView
          Left = 98.26778
          Top = 3.77953000000002
          Width = 109.60637
          Height = 18.89765
          DataField = 'ENAME'
          DataSet = frxReport1.IBDACQuery1
          DataSetName = 'IBDACQuery1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGreen
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8 = (
            '[IBDACQuery1."ENAME"]')
          ParentFont = False
        end
        object Memo17: TfrxMemoView
          Left = 230.55133
          Top = 3.77953000000002
          Width = 98.26778
          Height = 18.89765
          DataField = 'JOB'
          DataSet = frxReport1.IBDACQuery1
          DataSetName = 'IBDACQuery1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGreen
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8 = (
            '[IBDACQuery1."JOB"]')
          ParentFont = False
        end
        object Memo18: TfrxMemoView
          Left = 340.1577
          Top = 3.77953000000002
          Width = 98.26778
          Height = 18.89765
          DataField = 'MGR'
          DataSet = frxReport1.IBDACQuery1
          DataSetName = 'IBDACQuery1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGreen
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8 = (
            '[IBDACQuery1."MGR"]')
          ParentFont = False
        end
        object Memo19: TfrxMemoView
          Left = 453.5436
          Top = 3.77953000000002
          Width = 102.04731
          Height = 18.89765
          DataField = 'HIREDATE'
          DataSet = frxReport1.IBDACQuery1
          DataSetName = 'IBDACQuery1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGreen
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8 = (
            '[IBDACQuery1."HIREDATE"]')
          ParentFont = False
        end
        object Memo20: TfrxMemoView
          Left = 566.9295
          Top = 3.77953000000002
          Width = 79.37013
          Height = 18.89765
          DataField = 'SAL'
          DataSet = frxReport1.IBDACQuery1
          DataSetName = 'IBDACQuery1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGreen
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8 = (
            '[IBDACQuery1."SAL"]')
          ParentFont = False
        end
        object Memo4: TfrxMemoView
          Left = 11.33859
          Top = 3.77953000000002
          Width = 79.37013
          Height = 18.89765
          DataField = 'EMPNO'
          DataSet = frxReport1.IBDACQuery1
          DataSetName = 'IBDACQuery1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGreen
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8 = (
            '[IBDACQuery1."EMPNO"]')
          ParentFont = False
        end
      end
      object Footer1: TfrxFooter
        Height = 52.91342
        Top = 340.1577
        Width = 718.1107
        object Line2: TfrxLineView
          Top = 11.33859
          Width = 714.33117
          Frame.Typ = [ftTop]
          Frame.Width = 2
        end
        object Memo21: TfrxMemoView
          Left = 11.33859
          Top = 18.89765
          Width = 76.85044333
          Height = 21.41733667
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Memo.UTF8 = (
            'Summary')
          ParentFont = False
        end
        object Memo22: TfrxMemoView
          Left = 117.16543
          Top = 18.89765
          Width = 113.3859
          Height = 18.89765
          DataField = 'DNAME'
          DataSet = frxReport1.IBDACTable1
          DataSetName = 'IBDACTable1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsItalic]
          Memo.UTF8 = (
            '[IBDACTable1."DNAME"]')
          ParentFont = False
        end
        object Memo23: TfrxMemoView
          Left = 566.9295
          Top = 18.89765
          Width = 94.48825
          Height = 18.89765
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Memo.UTF8 = (
            '[SUM(<IBDACQuery1."SAL">,DetailData1)]')
          ParentFont = False
        end
      end
      object Header1: TfrxHeader
        Height = 37.7953
        Top = 230.55133
        Width = 718.1107
        object Line1: TfrxLineView
          Width = 718.1107
          Frame.Typ = [ftTop]
          Frame.Width = 2
        end
        object Memo2: TfrxMemoView
          Left = 11.33859
          Top = 7.55905999999999
          Width = 76.85044333
          Height = 21.41733667
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Memo.UTF8 = (
            'No')
          ParentFont = False
        end
        object Memo3: TfrxMemoView
          Left = 98.26778
          Top = 7.55905999999999
          Width = 114.64574333
          Height = 21.41733667
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Memo.UTF8 = (
            'Name')
          ParentFont = False
        end
        object Memo13: TfrxMemoView
          Left = 230.55133
          Top = 7.55905999999999
          Width = 99.52762333
          Height = 21.41733667
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Memo.UTF8 = (
            'Job')
          ParentFont = False
        end
        object Memo14: TfrxMemoView
          Left = 340.1577
          Top = 7.55905999999999
          Width = 99.52762333
          Height = 21.41733667
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Memo.UTF8 = (
            'Manager')
          ParentFont = False
        end
        object Memo15: TfrxMemoView
          Left = 453.5436
          Top = 7.55905999999999
          Width = 99.52762333
          Height = 21.41733667
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Memo.UTF8 = (
            'Hire Date')
          ParentFont = False
        end
        object Memo16: TfrxMemoView
          Left = 566.9295
          Top = 7.55905999999999
          Width = 99.52762333
          Height = 21.41733667
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Memo.UTF8 = (
            'Salary')
          ParentFont = False
        end
      end
      object GroupHeader1: TfrxGroupHeader
        Height = 22.67718
        Top = 132.28355
        Width = 718.1107
        Condition = 'True'
      end
      object GroupFooter1: TfrxGroupFooter
        Height = 22.67718
        Top = 415.7483
        Width = 718.1107
        object Memo25: TfrxMemoView
          Left = 566.9295
          Width = 94.48825
          Height = 18.89765
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Memo.UTF8 = (
            '[SUM(<IBDACQuery1."SAL">,DetailData1)]')
          ParentFont = False
        end
        object Memo24: TfrxMemoView
          Left = 11.33859
          Top = 3.77953000000002
          Width = 94.48825
          Height = 18.89765
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Memo.UTF8 = (
            'Total')
          ParentFont = False
        end
      end
    end
    object DialogPage1: TfrxDialogPage
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Height = 200
      Left = 265
      Top = 150
      Width = 300
      object IBDACDatabase1: TfrxIBDACDatabase
      end
      object IBDACTable1: TfrxIBDACTable
        UserName = 'IBDACTable1'
        CloseDataSource = True
        TableName = 'dept'
        Database = frxReport1.IBDACDatabase1
      end
      object IBDACQuery1: TfrxIBDACQuery
        UserName = 'IBDACQuery1'
        CloseDataSource = True
        Master = frxReport1.IBDACTable1
        Params = <>
        SQL.Strings = (
          'select * from emp')
        Database = frxReport1.IBDACDatabase1
        Parameters = <>
      end
    end
  end
  object frxDesigner1: TfrxDesigner
    DefaultScriptLanguage = 'PascalScript'
    DefaultFont.Charset = DEFAULT_CHARSET
    DefaultFont.Color = clWindowText
    DefaultFont.Height = -13
    DefaultFont.Name = 'Arial'
    DefaultFont.Style = []
    DefaultLeftMargin = 10
    DefaultRightMargin = 10
    DefaultTopMargin = 10
    DefaultBottomMargin = 10
    DefaultPaperSize = 9
    DefaultOrientation = poPortrait
    Restrictions = []
    RTLLanguage = False
    Left = 56
    Top = 16
  end
  object frxIBDACComponents1: TfrxIBDACComponents
    Left = 104
    Top = 16
  end
end
