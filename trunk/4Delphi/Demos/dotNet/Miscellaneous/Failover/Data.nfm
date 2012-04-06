object DM: TDM
  OldCreateOrder = False
  Left = 186
  Top = 106
  Height = 225
  Width = 282
  object Connection: TIBCConnection
    Options.DisconnectedMode = True
    Options.LocalFailover = True
    DefaultTransaction.DefaultCloseAction = taCommit
    DefaultTransaction.IsolationLevel = iblReadOnlyReadCommitted
    Pooling = True
    Left = 32
    Top = 32
  end
  object quDetail: TIBCQuery
    Connection = Connection
    UpdateTransaction = UpdateTransaction
    SQL.Strings = (
      'select * from emp')
    MasterFields = 'DEPTNO'
    DetailFields = 'DEPTNO'
    MasterSource = dsMaster
    Debug = True
    FetchAll = True
    CachedUpdates = True
    AutoCommit = True
    Options.LocalMasterDetail = True
    Left = 104
    Top = 88
  end
  object quMaster: TIBCQuery
    Connection = Connection
    UpdateTransaction = UpdateTransaction
    SQL.Strings = (
      'select * from dept'
      '')
    Debug = True
    FetchAll = True
    CachedUpdates = True
    AutoCommit = True
    Left = 104
    Top = 32
  end
  object dsDetail: TDataSource
    DataSet = quDetail
    Left = 136
    Top = 80
  end
  object dsMaster: TDataSource
    DataSet = quMaster
    Left = 136
    Top = 24
  end
  object UpdateTransaction: TIBCTransaction
    DefaultConnection = Connection
    DefaultCloseAction = taCommit
    Left = 32
    Top = 80
  end
  object scCreate: TIBCScript
    SQL.Strings = (
      'CREATE TABLE DEPT ('
      '    DEPTNO  INTEGER NOT NULL PRIMARY KEY,'
      '    DNAME   VARCHAR(14),'
      '    LOC     VARCHAR(13)'
      ');'
      ''
      'COMMIT;'
      ''
      'CREATE TABLE EMP ('
      '    EMPNO     INTEGER NOT NULL PRIMARY KEY,'
      '    ENAME     VARCHAR(10),'
      '    JOB       VARCHAR(9),'
      '    MGR       INTEGER,'
      '    HIREDATE  TIMESTAMP,'
      '    SAL       INTEGER,'
      '    COMM      INTEGER,'
      '    DEPTNO    INTEGER REFERENCES DEPT (DEPTNO)'
      ');'
      ''
      'INSERT INTO DEPT VALUES'
      '  (10,'#39'ACCOUNTING'#39','#39'NEW YORK'#39');'
      'INSERT INTO DEPT VALUES'
      '  (20,'#39'RESEARCH'#39','#39'DALLAS'#39');'
      'INSERT INTO DEPT VALUES'
      '  (30,'#39'SALES'#39','#39'CHICAGO'#39');'
      'INSERT INTO DEPT VALUES'
      '  (40,'#39'OPERATIONS'#39','#39'BOSTON'#39');'
      'INSERT INTO EMP VALUES'
      '  (7369,'#39'SMITH'#39','#39'CLERK'#39',7902,'#39'17.12.1980'#39',800,NULL,20);'
      'INSERT INTO EMP VALUES'
      '  (7499,'#39'ALLEN'#39','#39'SALESMAN'#39',7698,'#39'20.02.1981'#39',1600,300,30);'
      'INSERT INTO EMP VALUES'
      '  (7521,'#39'WARD'#39','#39'SALESMAN'#39',7698,'#39'22.02.1981'#39',1250,500,30);'
      'INSERT INTO EMP VALUES'
      '  (7566,'#39'JONES'#39','#39'MANAGER'#39',7839,'#39'02.04.1981'#39',2975,NULL,20);'
      'INSERT INTO EMP VALUES'
      '  (7654,'#39'MARTIN'#39','#39'SALESMAN'#39',7698,'#39'28.09.1981'#39',1250,1400,30);'
      'INSERT INTO EMP VALUES'
      '  (7698,'#39'BLAKE'#39','#39'MANAGER'#39',7839,'#39'01.05.1981'#39',2850,NULL,30);'
      'INSERT INTO EMP VALUES'
      '  (7782,'#39'CLARK'#39','#39'MANAGER'#39',7839,'#39'09.06.1981'#39',2450,NULL,10);'
      'INSERT INTO EMP VALUES'
      '  (7788,'#39'SCOTT'#39','#39'ANALYST'#39',7566,'#39'13.07.87'#39',3000,NULL,20);'
      'INSERT INTO EMP VALUES'
      '  (7839,'#39'KING'#39','#39'PRESIDENT'#39',NULL,'#39'17.11.1981'#39',5000,NULL,10);'
      'INSERT INTO EMP VALUES'
      '  (7844,'#39'TURNER'#39','#39'SALESMAN'#39',7698,'#39'08.09.1981'#39',1500,0,30);'
      'INSERT INTO EMP VALUES'
      '  (7876,'#39'ADAMS'#39','#39'CLERK'#39',7788,'#39'13.07.87'#39',1100,NULL,20);'
      'INSERT INTO EMP VALUES'
      '  (7900,'#39'JAMES'#39','#39'CLERK'#39',7698,'#39'03.12.1981'#39',950,NULL,30);'
      'INSERT INTO EMP VALUES'
      '  (7902,'#39'FORD'#39','#39'ANALYST'#39',7566,'#39'03.12.1981'#39',3000,NULL,20);'
      'INSERT INTO EMP VALUES'
      '  (7934,'#39'MILLER'#39','#39'CLERK'#39',7782,'#39'23.01.1982'#39',1300,NULL,10);'
      '  '
      'COMMIT;')
    Connection = Connection
    Left = 216
    Top = 32
  end
  object scDrop: TIBCScript
    SQL.Strings = (
      'DROP TABLE EMP;'
      ''
      'COMMIT;'
      ''
      'DROP TABLE DEPT;')
    Connection = Connection
    Left = 216
    Top = 88
  end
end
