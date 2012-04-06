inherited QueryFrame: TQueryFrame
  Width = 733
  Height = 265
  Align = alClient
  object DBGrid: TDBGrid
    Left = 0
    Top = 143
    Width = 733
    Height = 122
    Align = alClient
    DataSource = DataSource
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object ToolBar: TPanel
    Left = 0
    Top = 0
    Width = 733
    Height = 26
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Panel5: TPanel
      Left = 1
      Top = 1
      Width = 645
      Height = 24
      BevelOuter = bvNone
      Color = 6369932
      TabOrder = 0
      object btClose: TSpeedButton
        Left = 84
        Top = 1
        Width = 82
        Height = 22
        Caption = 'Close'
        Flat = True
        Transparent = False
        OnClick = btCloseClick
      end
      object btOpen: TSpeedButton
        Left = 1
        Top = 1
        Width = 82
        Height = 22
        Caption = 'Open'
        Flat = True
        Transparent = False
        OnClick = btOpenClick
      end
      object btPrepare: TSpeedButton
        Left = 167
        Top = 1
        Width = 82
        Height = 22
        Caption = 'Prepare'
        Flat = True
        Transparent = False
        OnClick = btPrepareClick
      end
      object btUnPrepare: TSpeedButton
        Left = 250
        Top = 1
        Width = 82
        Height = 22
        Caption = 'UnPrepare'
        Flat = True
        Transparent = False
        OnClick = btUnPrepareClick
      end
      object btExecute: TSpeedButton
        Left = 333
        Top = 1
        Width = 82
        Height = 22
        Caption = 'Execute'
        Flat = True
        Transparent = False
        OnClick = btExecuteClick
      end
      object Panel2: TPanel
        Left = 416
        Top = 1
        Width = 85
        Height = 22
        BevelOuter = bvNone
        TabOrder = 0
        object cbFetchAll: TCheckBox
          Left = 11
          Top = 4
          Width = 63
          Height = 16
          Caption = 'FetchAll'
          TabOrder = 0
          OnClick = cbFetchAllClick
        end
      end
      object Panel4: TPanel
        Left = 502
        Top = 1
        Width = 142
        Height = 22
        BevelOuter = bvNone
        TabOrder = 1
        object StaticText1: TLabel
          Left = 6
          Top = 5
          Width = 54
          Height = 13
          Caption = 'FetchRows'
        end
        object edFetchRows: TEdit
          Left = 67
          Top = 1
          Width = 71
          Height = 20
          TabOrder = 0
        end
      end
    end
  end
  object meSQL: TMemo
    Left = 0
    Top = 26
    Width = 733
    Height = 91
    Align = alTop
    ScrollBars = ssVertical
    TabOrder = 1
    OnExit = meSQLExit
  end
  object Panel1: TPanel
    Left = 0
    Top = 117
    Width = 733
    Height = 26
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 491
      Height = 24
      BevelOuter = bvNone
      Color = 6369932
      TabOrder = 0
      object btRefreshRecord: TSpeedButton
        Left = 242
        Top = 1
        Width = 82
        Height = 22
        Caption = 'RefreshRecord'
        Flat = True
        Transparent = False
        OnClick = btRefreshRecordClick
      end
      object btShowState: TSpeedButton
        Left = 325
        Top = 1
        Width = 82
        Height = 22
        Caption = 'ShowState'
        Flat = True
        Transparent = False
        OnClick = btShowStateClick
      end
      object btSaveToXML: TSpeedButton
        Left = 408
        Top = 1
        Width = 82
        Height = 22
        Caption = 'SaveToXML'
        Flat = True
        Transparent = False
        OnClick = btSaveToXMLClick
      end
      object DBNavigator1: TDBNavigator
        Left = 1
        Top = 1
        Width = 240
        Height = 22
        DataSource = DataSource
        Flat = True
        TabOrder = 0
      end
    end
  end
  object DataSource: TDataSource
    DataSet = IBCQuery
    Left = 44
    Top = 34
  end
  object IBCQuery: TIBCQuery
    SQLInsert.Strings = (
      'INSERT INTO EMP'
      '  (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)'
      'VALUES'
      '  (:1, :2, :3, :4, :5, :6, :7, :8)')
    SQLDelete.Strings = (
      'DELETE FROM EMP'
      'WHERE'
      '  EMPNO = :Old_1')
    SQLUpdate.Strings = (
      'UPDATE EMP'
      'SET'
      
        '  EMPNO = :1, ENAME = :2, JOB = :3, MGR = :4, HIREDATE = :5, SAL' +
        ' = :6, COMM = :7, DEPTNO = :8'
      'WHERE'
      '  EMPNO = :Old_1')
    SQLRefresh.Strings = (
      
        'SELECT EMP.EMPNO AS IBC$0, EMP.ENAME AS IBC$1, EMP.JOB AS IBC$2,' +
        ' EMP.MGR AS IBC$3, EMP.HIREDATE AS IBC$4, EMP.SAL AS IBC$5, EMP.' +
        'COMM AS IBC$6, EMP.DEPTNO AS IBC$7 FROM EMP'
      'WHERE EMP.EMPNO = :Old_1 ')
    SQL.Strings = (
      'SELECT Emp.*'
      'FROM'
      '  Emp')
    AfterExecute = IBCQueryAfterExecute
    Left = 14
    Top = 34
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'xml'
    Filter = 'XML (*.xml)|*.xml'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 43
    Top = 65
  end
end
