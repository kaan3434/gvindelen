inherited UpdateSQLFrame: TUpdateSQLFrame
  Width = 443
  Height = 277
  Align = alClient
  object Splitter1: TSplitter
    Left = 0
    Top = 121
    Width = 443
    Height = 3
    Cursor = crVSplit
    Align = alTop
    Beveled = True
    Color = 6369932
    ParentColor = False
  end
  object DBGrid: TDBGrid
    Left = 0
    Top = 150
    Width = 443
    Height = 127
    Align = alClient
    DataSource = DataSource
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object meSQL: TMemo
    Left = 0
    Top = 49
    Width = 443
    Height = 72
    Align = alTop
    Anchors = []
    Constraints.MinHeight = 50
    ScrollBars = ssVertical
    TabOrder = 1
    OnExit = meSQLExit
  end
  object Panel3: TPanel
    Left = 0
    Top = 124
    Width = 443
    Height = 26
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 328
      Height = 26
      BevelOuter = bvNone
      Color = 6369932
      TabOrder = 0
      object btRefreshRecord: TSpeedButton
        Left = 242
        Top = 1
        Width = 85
        Height = 24
        Caption = 'RefreshRecord'
        Flat = True
        Transparent = False
        OnClick = btRefreshRecordClick
      end
      object DBNavigator1: TDBNavigator
        Left = 1
        Top = 1
        Width = 240
        Height = 24
        DataSource = DataSource
        Flat = True
        TabOrder = 0
      end
    end
  end
  object Panel6: TPanel
    Left = 0
    Top = 0
    Width = 443
    Height = 49
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 3
    object ToolBar: TPanel
      Left = 0
      Top = 0
      Width = 431
      Height = 49
      Align = alLeft
      BevelOuter = bvNone
      Color = 6369932
      TabOrder = 0
      object btUnPrepare: TSpeedButton
        Left = 259
        Top = 1
        Width = 85
        Height = 22
        Caption = 'UnPrepare'
        Flat = True
        Transparent = False
        OnClick = btUnPrepareClick
      end
      object btPrepare: TSpeedButton
        Left = 173
        Top = 1
        Width = 85
        Height = 22
        Caption = 'Prepare'
        Flat = True
        Transparent = False
        OnClick = btPrepareClick
      end
      object btOpen: TSpeedButton
        Left = 1
        Top = 1
        Width = 85
        Height = 22
        Caption = 'Open'
        Flat = True
        Transparent = False
        OnClick = btOpenClick
      end
      object btExecute: TSpeedButton
        Left = 345
        Top = 1
        Width = 85
        Height = 22
        Caption = 'Execute'
        Flat = True
        Transparent = False
        OnClick = btExecuteClick
      end
      object btClose: TSpeedButton
        Left = 87
        Top = 1
        Width = 85
        Height = 22
        Caption = 'Close'
        Flat = True
        Transparent = False
        OnClick = btCloseClick
      end
      object Panel4: TPanel
        Left = 2
        Top = 24
        Width = 428
        Height = 24
        BevelOuter = bvNone
        TabOrder = 0
        object cbDeleteObject: TCheckBox
          Left = 14
          Top = 5
          Width = 91
          Height = 17
          Caption = 'DeleteObject'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 0
          OnClick = cbObjectClick
        end
        object cbInsertObject: TCheckBox
          Left = 112
          Top = 5
          Width = 89
          Height = 17
          Caption = 'InsertObject'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 1
          OnClick = cbObjectClick
        end
        object cbModifyObject: TCheckBox
          Left = 210
          Top = 5
          Width = 87
          Height = 17
          Caption = 'ModifyObject'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 2
          OnClick = cbObjectClick
        end
        object cbRefreshObject: TCheckBox
          Left = 314
          Top = 5
          Width = 95
          Height = 17
          Caption = 'RefreshObject'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 3
          OnClick = cbObjectClick
        end
      end
    end
  end
  object IBCQuery: TIBCQuery
    SQL.Strings = (
      'SELECT * FROM Dept'
      '')
    Debug = True
    RefreshOptions = [roAfterInsert, roAfterUpdate]
    UpdateObject = IBCUpdateSQL
    Left = 24
    Top = 200
  end
  object DataSource: TDataSource
    DataSet = IBCQuery
    Left = 24
    Top = 232
  end
  object IBCUpdateSQL: TIBCUpdateSQL
    InsertSQL.Strings = (
      'INSERT INTO Dept'
      '  (DEPTNO, DNAME, LOC)'
      'VALUES'
      '  (:DEPTNO, :DNAME, :LOC)')
    DeleteSQL.Strings = (
      'DELETE FROM Dept'
      'WHERE'
      '  DEPTNO = :DEPTNO')
    ModifySQL.Strings = (
      'UPDATE Dept'
      'SET'
      '  DEPTNO = :DEPTNO,'
      '  DNAME = :DNAME,'
      '  LOC = :LOC'
      'WHERE'
      '  DEPTNO = :OLD_DEPTNO')
    RefreshSQL.Strings = (
      'SELECT * FROM Dept'
      'WHERE'
      '  DEPTNO = :DEPTNO')
    Left = 56
    Top = 200
  end
  object RefreshQuery: TIBCQuery
    SQL.Strings = (
      'SELECT * FROM Dept'
      'WHERE'
      '  DEPTNO = :DEPTNO')
    Left = 96
    Top = 256
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'DEPTNO'
      end>
  end
  object ModifyQuery: TIBCQuery
    SQL.Strings = (
      'UPDATE Dept'
      'SET'
      '  DEPTNO = :DEPTNO,'
      '  DNAME = :DNAME,'
      '  LOC = :LOC'
      'WHERE'
      '  DEPTNO = :OLD_DEPTNO')
    Left = 96
    Top = 224
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'DEPTNO'
      end
      item
        DataType = ftUnknown
        Name = 'DNAME'
      end
      item
        DataType = ftUnknown
        Name = 'LOC'
      end
      item
        DataType = ftUnknown
        Name = 'OLD_DEPTNO'
      end>
  end
  object DeleteQuery: TIBCQuery
    SQL.Strings = (
      'DELETE FROM Dept'
      'WHERE'
      '  DEPTNO = :DEPTNO')
    Left = 96
    Top = 160
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'DEPTNO'
      end>
  end
  object InsertQuery: TIBCQuery
    SQL.Strings = (
      'INSERT INTO Dept'
      '  (DEPTNO, DNAME, LOC)'
      'VALUES'
      '  (:DEPTNO, :DNAME, :LOC)')
    Left = 96
    Top = 192
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'DEPTNO'
      end
      item
        DataType = ftUnknown
        Name = 'DNAME'
      end
      item
        DataType = ftUnknown
        Name = 'LOC'
      end>
  end
end
