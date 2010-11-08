object dmSwim: TdmSwim
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 434
  Top = 239
  Height = 312
  Width = 590
  object DataSet: TpFIBDataSet
    Transaction = UpdateTran
    Database = Database
    Left = 88
    Top = 64
  end
  object StoredProc: TpFIBStoredProc
    Transaction = UpdateTran
    Database = Database
    Left = 88
    Top = 16
    qoAutoCommit = True
    qoStartTransaction = True
  end
  object UpdateTran: TpFIBTransaction
    DefaultDatabase = Database
    TimeoutAction = TARollback
    Left = 32
    Top = 64
  end
  object Database: TpFIBDatabase
    DBName = 'D:\swim2\Data\swim.fdb'
    DBParams.Strings = (
      'password='
      'sql_role_name=admin'
      'user_name=sysdba'
      'lc_ctype=CYRL')
    DefaultTransaction = ReadTran
    DefaultUpdateTransaction = UpdateTran
    SQLDialect = 3
    Timeout = 0
    DesignDBOptions = []
    AliasName = 'swim'
    WaitForRestoreConnect = 0
    Left = 32
    Top = 16
  end
  object ReadTran: TpFIBTransaction
    DefaultDatabase = Database
    TimeoutAction = TARollback
    Left = 32
    Top = 112
  end
  object tblASports: TpFIBDataSet
    UpdateSQL.Strings = (
      'UPDATE ASPORTS'
      'SET '
      ' ASPORT_NM = :ASPORT_NM,'
      ' DEFAULT_FLG = :DEFAULT_FLG,'
      ' COUNTRY_FLG = :COUNTRY_FLG,'
      ' ASUBSPORT1_ID = :ASUBSPORT1_ID,'
      ' ASUBSPORT2_ID = :ASUBSPORT2_ID,'
      ' WAYS_CNT = :WAYS_CNT,'
      ' EVENT_OFS = :EVENT_OFS'
      'WHERE'
      ' ASPORT_ID = :OLD_ASPORT_ID'
      ' ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      ' ASPORTS'
      'WHERE'
      '  ASPORT_ID = :OLD_ASPORT_ID'
      ' ')
    InsertSQL.Strings = (
      'INSERT INTO ASPORTS('
      ' ASPORT_ID,'
      ' ASPORT_NM,'
      ' DEFAULT_FLG,'
      ' COUNTRY_FLG,'
      ' ASUBSPORT1_ID,'
      ' ASUBSPORT2_ID,'
      ' WAYS_CNT,'
      ' EVENT_OFS'
      ')'
      'VALUES('
      ' :ASPORT_ID,'
      ' :ASPORT_NM,'
      ' :DEFAULT_FLG,'
      ' :COUNTRY_FLG,'
      ' :ASUBSPORT1_ID,'
      ' :ASUBSPORT2_ID,'
      ' :WAYS_CNT,'
      ' :EVENT_OFS'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '  ASPORT_ID,'
      '  ASPORT_NM,'
      '  DEFAULT_FLG,'
      '  COUNTRY_FLG,'
      '  ASUBSPORT1_ID,'
      '  ASUBSPORT2_ID,'
      '  WAYS_CNT,'
      '  EVENT_OFS'
      'FROM'
      '  ASPORTS '
      'WHERE '
      '  ASPORTS.ASPORT_ID = :OLD_ASPORT_ID'
      ' ')
    SelectSQL.Strings = (
      'SELECT'
      ' ASPORT_ID,'
      ' ASPORT_NM,'
      ' DEFAULT_FLG,'
      ' COUNTRY_FLG,'
      ' ASUBSPORT1_ID,'
      ' ASUBSPORT2_ID,'
      ' WAYS_CNT,'
      ' EVENT_OFS'
      'FROM'
      ' ASPORTS '
      'ORDER BY ASPORT_NM'
      ''
      '')
    AutoUpdateOptions.UpdateTableName = 'ASPORTS'
    AutoUpdateOptions.KeyFields = 'ASPORT_ID'
    AutoUpdateOptions.GeneratorName = 'GEN_ASPORT_ID'
    AutoUpdateOptions.WhenGetGenID = wgBeforePost
    AutoCalcFields = False
    Transaction = ReadTran
    Database = Database
    UpdateTransaction = UpdateTran
    AutoCommit = True
    DataSet_ID = 1
    Description = 'ASPORTS'
    Left = 152
    Top = 16
    poApplyRepositary = True
  end
  object tblBSports: TpFIBDataSet
    UniDirectional = True
    UpdateSQL.Strings = (
      'UPDATE BSPORTS'
      'SET '
      '    ASPORT_ID = :ASPORT_ID'
      'WHERE'
      '    BSPORT_ID = :BSPORT_ID'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      '    BSPORTS'
      'WHERE'
      '        BSPORT_ID = :OLD_BSPORT_ID'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO BSPORTS('
      '    BSPORT_ID,'
      '    BSPORT_NM,'
      '    ASPORT_ID,'
      '    BOOKER_ID,'
      '    IGNORE_FLG'
      ')'
      'VALUES('
      '    :BSPORT_ID,'
      '    :BSPORT_NM,'
      '    :ASPORT_ID,'
      '    :BOOKER_ID,'
      '    :IGNORE_FLG'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      ' b.BSPORT_ID,'
      ' b.BSPORT_NM,'
      ' b.ASPORT_ID,'
      ' b.BOOKER_ID,'
      ' k.BOOKER_NM,'
      ' b.IGNORE_FLG'
      'FROM'
      ' BSPORTS b'
      '  LEFT JOIN BOOKERS k ON'
      '       (b.BOOKER_ID = k.BOOKER_ID)'
      ''
      ' WHERE '
      '        B.BSPORT_ID = :OLD_BSPORT_ID'
      '    ')
    SelectSQL.Strings = (
      'SELECT'
      ' b.BSPORT_ID,'
      ' b.BSPORT_NM,'
      ' b.ASPORT_ID,'
      ' b.BOOKER_ID,'
      ' k.BOOKER_NM,'
      ' b.IGNORE_FLG'
      'FROM'
      ' BSPORTS b'
      '  LEFT JOIN BOOKERS k ON'
      '       (b.BOOKER_ID = k.BOOKER_ID)'
      'ORDER BY b.BSPORT_ID ')
    AutoCalcFields = False
    AllowedUpdateKinds = [ukModify]
    Transaction = ReadTran
    Database = Database
    UpdateTransaction = UpdateTran
    AutoCommit = True
    DataSet_ID = 2
    Description = 'BSPORTS'
    Left = 152
    Top = 64
    poApplyRepositary = True
  end
  object tblBookers: TpFIBDataSet
    UpdateSQL.Strings = (
      'UPDATE BOOKERS'
      'SET '
      ' BOOKER_NM = :BOOKER_NM,'
      ' VALUTE_SGN = :VALUTE_SGN,'
      ' ONEBET_FLG = :ONEBET_FLG,'
      ' HOURS_OFS = :HOURS_OFS,'
      ' MINBET_MNY = :MINBET_MNY,'
      ' MAXBET_MNY = :MAXBET_MNY'
      'WHERE'
      ' BOOKER_ID = :OLD_BOOKER_ID'
      ' ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      ' BOOKERS'
      'WHERE'
      '  BOOKER_ID = :OLD_BOOKER_ID'
      ' ')
    InsertSQL.Strings = (
      'INSERT INTO BOOKERS('
      ' BOOKER_NM,'
      ' VALUTE_SGN,'
      ' ONEBET_FLG,'
      ' HOURS_OFS,'
      ' MINBET_MNY,'
      ' MAXBET_MNY'
      ')'
      'VALUES('
      ' :BOOKER_NM,'
      ' :VALUTE_SGN,'
      ' :ONEBET_FLG,'
      ' :HOURS_OFS,'
      ' :MINBET_MNY,'
      ' :MAXBET_MNY'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      ' BOOKER_ID,'
      ' BOOKER_NM,'
      ' VALUTE_SGN,'
      ' ONEBET_FLG,'
      ' HOURS_OFS,'
      ' MINBET_MNY,'
      ' MAXBET_MNY'
      'FROM'
      ' BOOKERS '
      ''
      ' WHERE '
      '  BOOKERS.BOOKER_ID = :OLD_BOOKER_ID'
      ' ')
    SelectSQL.Strings = (
      'SELECT'
      ' BOOKER_ID,'
      ' BOOKER_NM,'
      ' VALUTE_SGN,'
      ' ONEBET_FLG,'
      ' HOURS_OFS,'
      ' MINBET_MNY,'
      ' MAXBET_MNY'
      'FROM'
      ' BOOKERS '
      'ORDER BY BOOKER_ID')
    AutoCalcFields = False
    AllowedUpdateKinds = [ukModify]
    Transaction = ReadTran
    Database = Database
    UpdateTransaction = UpdateTran
    AutoCommit = True
    DataSet_ID = 3
    Description = 'BOOKERS'
    Left = 152
    Top = 112
    poApplyRepositary = True
  end
  object tblCountrys: TpFIBDataSet
    UpdateSQL.Strings = (
      'UPDATE COUNTRYS'
      'SET '
      '    ACOUNTRY_NM = :ACOUNTRY_NM,'
      '    MCOUNTRY_SGN = :MCOUNTRY_SGN'
      'WHERE'
      '    ACOUNTRY_SGN = :OLD_ACOUNTRY_SGN'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      '    COUNTRYS'
      'WHERE'
      '        ACOUNTRY_SGN = :OLD_ACOUNTRY_SGN'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO COUNTRYS('
      '    ACOUNTRY_SGN,'
      '    ACOUNTRY_NM,'
      '    MCOUNTRY_SGN'
      ')'
      'VALUES('
      '    :ACOUNTRY_SGN,'
      '    :ACOUNTRY_NM,'
      '    :MCOUNTRY_SGN'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    ACOUNTRY_SGN,'
      '    ACOUNTRY_NM,'
      '    MCOUNTRY_SGN'
      'FROM'
      '    COUNTRYS '
      ''
      ' WHERE '
      '        COUNTRYS.ACOUNTRY_SGN = :OLD_ACOUNTRY_SGN'
      '    ')
    SelectSQL.Strings = (
      'SELECT'
      '    ACOUNTRY_SGN,'
      '    ACOUNTRY_NM,'
      '    MCOUNTRY_SGN'
      'FROM'
      '    COUNTRYS '
      'ORDER BY ACOUNTRY_NM')
    AutoCalcFields = False
    Transaction = ReadTran
    Database = Database
    UpdateTransaction = UpdateTran
    AutoCommit = True
    DataSet_ID = 4
    Description = 'COUNTRYS'
    Left = 152
    Top = 160
    poApplyRepositary = True
  end
  object tblBTournirs: TpFIBDataSet
    UpdateSQL.Strings = (
      'UPDATE BTOURNIRS'
      'SET '
      '    ATOURNIR_ID = :ATOURNIR_ID,'
      '    ASPORT_ID = :ASPORT_ID,'
      '    COUNTRY_SGN = :COUNTRY_SGN,'
      '    USED_DT = :USED_DT,'
      '    IGNORE_FLG = :IGNORE_FLG'
      'WHERE'
      '    BTOURNIR_ID = :OLD_BTOURNIR_ID'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      '    BTOURNIRS'
      'WHERE'
      '        BTOURNIR_ID = :OLD_BTOURNIR_ID'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO BTOURNIRS('
      '    BTOURNIR_ID,'
      '    ATOURNIR_ID,'
      '    BOOKER_ID,'
      '    BSPORT_ID,'
      '    BTOURNIR_NM,'
      '    ASPORT_ID,'
      '    COUNTRY_SGN,'
      '    USED_DT,'
      '    IGNORE_FLG'
      ')'
      'VALUES('
      '    :BTOURNIR_ID,'
      '    :ATOURNIR_ID,'
      '    :BOOKER_ID,'
      '    :BSPORT_ID,'
      '    :BTOURNIR_NM,'
      '    :ASPORT_ID,'
      '    :COUNTRY_SGN,'
      '    :USED_DT,'
      '    :IGNORE_FLG'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    t.BTOURNIR_ID,'
      '    t.ATOURNIR_ID,'
      '    s.ATOURNIR_NM,'
      '    t.BOOKER_ID,'
      '    b.BOOKER_NM,'
      '    t.BSPORT_ID,'
      '    t.BTOURNIR_NM,'
      '    t.ASPORT_ID,'
      '    a.ASPORT_NM,'
      '    t.COUNTRY_SGN,'
      '    t.USED_DT,'
      '    t.IGNORE_FLG,'
      
        '    iif((t.COUNTRY_SGN IS NULL) OR (t.ATOURNIR_ID IS NULL), 0, 1' +
        ') COMPLETE_FLG'
      'FROM'
      '    BTOURNIRS t'
      '      LEFT JOIN BOOKERS b'
      '        ON (b.BOOKER_ID = t.BOOKER_ID)'
      '      LEFT JOIN ASPORTS a'
      '        ON (a.ASPORT_ID = t.ASPORT_ID)'
      '      LEFT JOIN ATOURNIRS s'
      '        ON (s.ATOURNIR_ID = t.ATOURNIR_ID)'
      ''
      ' WHERE '
      '        T.BTOURNIR_ID = :OLD_BTOURNIR_ID'
      '    ')
    SelectSQL.Strings = (
      'SELECT'
      '    t.BTOURNIR_ID,'
      '    t.ATOURNIR_ID,'
      '    s.ATOURNIR_NM,'
      '    t.BOOKER_ID,'
      '    b.BOOKER_NM,'
      '    t.BSPORT_ID,'
      '    t.BTOURNIR_NM,'
      '    t.ASPORT_ID,'
      '    a.ASPORT_NM,'
      '    t.COUNTRY_SGN,'
      '    t.USED_DT,'
      '    t.IGNORE_FLG,'
      
        '    iif((t.COUNTRY_SGN IS NULL) OR (t.ATOURNIR_ID IS NULL), 0, 1' +
        ') COMPLETE_FLG'
      'FROM'
      '    BTOURNIRS t'
      '      LEFT JOIN BOOKERS b'
      '        ON (b.BOOKER_ID = t.BOOKER_ID)'
      '      LEFT JOIN ASPORTS a'
      '        ON (a.ASPORT_ID = t.ASPORT_ID)'
      '      LEFT JOIN ATOURNIRS s'
      '        ON (s.ATOURNIR_ID = t.ATOURNIR_ID)'
      'ORDER BY '
      '  COMPLETE_FLG,'
      '  a.ASPORT_NM,'
      '  t.BTOURNIR_NM'
      '  ')
    AutoCalcFields = False
    Transaction = ReadTran
    Database = Database
    UpdateTransaction = UpdateTran
    AutoCommit = True
    DataSet_ID = 6
    Description = 'BTOURNIRS'
    Left = 224
    Top = 16
    poApplyRepositary = True
  end
  object tblParts: TpFIBDataSet
    UpdateSQL.Strings = (
      'UPDATE PARTS'
      'SET '
      '    PART_TXT = :PART_TXT'
      'WHERE'
      '    BTOURNIR_ID = :OLD_BTOURNIR_ID'
      '    and PART_LVL = :OLD_PART_LVL'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      '    PARTS'
      'WHERE'
      '        BTOURNIR_ID = :OLD_BTOURNIR_ID'
      '    and PART_LVL = :OLD_PART_LVL'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO PARTS('
      '    BTOURNIR_ID,'
      '    PART_LVL,'
      '    PART_TXT'
      ')'
      'VALUES('
      '    :BTOURNIR_ID,'
      '    :PART_LVL,'
      '    :PART_TXT'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    BTOURNIR_ID,'
      '    PART_LVL,'
      '    PART_TXT'
      'FROM'
      '    PARTS'
      ''
      ' WHERE '
      '        PARTS.BTOURNIR_ID = :OLD_BTOURNIR_ID'
      '    and PARTS.PART_LVL = :OLD_PART_LVL'
      '    ')
    SelectSQL.Strings = (
      'SELECT'
      '    BTOURNIR_ID,'
      '    PART_LVL,'
      '    PART_TXT'
      'FROM'
      '    PARTS'
      'ORDER BY BTOURNIR_ID,'
      '         PART_LVL ')
    Transaction = ReadTran
    Database = Database
    UpdateTransaction = UpdateTran
    DataSet_ID = 10
    Description = 'PARTS'
    Left = 224
    Top = 208
    poApplyRepositary = True
  end
  object tblAGamers: TpFIBDataSet
    UpdateSQL.Strings = (
      'UPDATE AGAMERS'
      'SET '
      '    AGAMER_NM = :AGAMER_NM,'
      '    COUNTRY_SGN = :COUNTRY_SGN'
      'WHERE'
      '    AGAMER_ID = :OLD_AGAMER_ID'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      '    AGAMERS'
      'WHERE'
      '        AGAMER_ID = :OLD_AGAMER_ID'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO AGAMERS('
      '    AGAMER_ID,'
      '    AGAMER_NM,'
      '    COUNTRY_SGN'
      ')'
      'VALUES('
      '    :AGAMER_ID,'
      '    :AGAMER_NM,'
      '    :COUNTRY_SGN'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    g.AGAMER_ID,'
      '    g.AGAMER_NM,'
      '    g.ASPORT_ID,'
      '    g.COUNTRY_SGN'
      'FROM'
      '    AGAMERS g'
      ''
      ' WHERE '
      '        G.AGAMER_ID = :OLD_AGAMER_ID'
      '    ')
    SelectSQL.Strings = (
      'SELECT'
      '    g.AGAMER_ID,'
      '    g.AGAMER_NM,'
      '    g.ASPORT_ID,'
      '    g.COUNTRY_SGN'
      'FROM'
      '    AGAMERS g'
      'ORDER BY AGAMER_NM')
    CacheModelOptions.CacheModelKind = cmkLimitedBufferSize
    CacheModelOptions.BufferChunks = 100
    AutoUpdateOptions.UpdateTableName = 'AGAMERS'
    AutoUpdateOptions.KeyFields = 'AGAMER_ID'
    AutoUpdateOptions.GeneratorName = 'GEN_AGAMER_ID'
    AutoUpdateOptions.WhenGetGenID = wgBeforePost
    AutoCalcFields = False
    Transaction = ReadTran
    Database = Database
    UpdateTransaction = UpdateTran
    AutoCommit = True
    DataSet_ID = 7
    Description = 'AGAMERS'
    Left = 224
    Top = 64
    poApplyRepositary = True
  end
  object tblBGamers: TpFIBDataSet
    UpdateSQL.Strings = (
      'UPDATE BGAMERS'
      'SET '
      '    AGAMER_ID = :AGAMER_ID'
      'WHERE'
      '    BGAMER_ID = :OLD_BGAMER_ID'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      '    BGAMERS'
      'WHERE'
      '    BGAMER_ID = :OLD_BGAMER_ID'
      '        ')
    InsertSQL.Strings = (
      'INSERT INTO BGAMERS('
      '    BGAMER_ID,'
      '    BGAMER_NM,'
      '    AGAMER_ID,'
      '    BTOURNIR_ID,'
      '    USED_DT'
      ')'
      'VALUES('
      '    :BGAMER_ID,'
      '    :BGAMER_NM,'
      '    :AGAMER_ID,'
      '    :BTOURNIR_ID,'
      '    :USED_DT'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    BGAMER_ID,'
      '    BGAMER_NM,'
      '    AGAMER_ID,'
      '    AGAMER_NM,'
      '    ASPORT_ID,'
      '    ASPORT_NM,'
      '    COUNTRY_SGN,'
      '    BTOURNIR_ID,'
      '    BTOURNIR_NM,'
      '    ATOURNIR_ID,'
      '    USED_DT,'
      '    COMPLETE_FLG,'
      '    COUNTRY_FLG,'
      '    ASUBSPORT1_ID,'
      '    ASUBSPORT2_ID'
      'FROM'
      '    VE_BGAMERS'
      'WHERE'
      '    BGAMER_ID = :OLD_BGAMER_ID ')
    SelectSQL.Strings = (
      'SELECT'
      '    BGAMER_ID,'
      '    BGAMER_NM,'
      '    AGAMER_ID,'
      '    AGAMER_NM,'
      '    ASPORT_ID,'
      '    ASPORT_NM,'
      '    COUNTRY_SGN,'
      '    BTOURNIR_ID,'
      '    BTOURNIR_NM,'
      '    ATOURNIR_ID,'
      '    ATOURNIR_NM,'
      '    USED_DT,'
      '    COMPLETE_FLG,'
      '    COUNTRY_FLG,'
      '    ASUBSPORT1_ID,'
      '    ASUBSPORT2_ID'
      'FROM'
      '    VE_BGAMERS '
      'ORDER BY COMPLETE_FLG'
      '       , ASPORT_NM'
      '       , BTOURNIR_NM'
      '       , AGAMER_NM'
      '       , BGAMER_NM')
    CacheModelOptions.CacheModelKind = cmkLimitedBufferSize
    CacheModelOptions.BufferChunks = 100
    Transaction = ReadTran
    Database = Database
    UpdateTransaction = UpdateTran
    AutoCommit = True
    DataSet_ID = 8
    Description = 'BGAMERS'
    Left = 224
    Top = 112
    poApplyRepositary = True
  end
  object tblEvents: TpFIBDataSet
    UpdateSQL.Strings = (
      'UPDATE EVENTS'
      'SET '
      '    AGAMER1_ID = :AGAMER1_ID,'
      '    AGAMER2_ID = :AGAMER2_ID,'
      '    COMPLETE_FLG = :COMPLETE_FLG,'
      '    IGNORE_FLG = :IGNORE_FLG'
      'WHERE'
      '    EVENT_ID = :OLD_EVENT_ID'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      '    EVENTS'
      'WHERE'
      '        EVENT_ID = :OLD_EVENT_ID'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO EVENTS('
      '    EVENT_ID,'
      '    ASPORT_ID,'
      '    BTOURNIR_ID,'
      '    EVENT_DTM,'
      '    AGAMER1_ID,'
      '    BGAMER1_ID,'
      '    AGAMER2_ID,'
      '    BGAMER2_ID,'
      '    COMPLETE_FLG,'
      '    IGNORE_FLG'
      ')'
      'VALUES('
      '    :EVENT_ID,'
      '    :ASPORT_ID,'
      '    :BTOURNIR_ID,'
      '    :EVENT_DTM,'
      '    :AGAMER1_ID,'
      '    :BGAMER1_ID,'
      '    :AGAMER2_ID,'
      '    :BGAMER2_ID,'
      '    :COMPLETE_FLG,'
      '    :IGNORE_FLG'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    e.EVENT_ID,'
      '    e.ASPORT_ID,'
      '    a.ASPORT_NM,'
      '    e.BTOURNIR_ID,'
      '    e.EVENT_DTM,'
      '    e.AGAMER1_ID,'
      '    e.BGAMER1_ID,'
      '    coalesce(ag1.AGAMER_NM, bg1.BGAMER_NM) GAMER1_NM,'
      '    e.AGAMER2_ID,'
      '    e.BGAMER2_ID,'
      '    coalesce(ag2.AGAMER_NM, bg2.BGAMER_NM) GAMER2_NM,'
      '    e.COMPLETE_FLG,'
      '    e.IGNORE_FLG'
      'FROM'
      '    EVENTS e '
      '    LEFT JOIN ASPORTS a'
      '      ON (e.ASPORT_ID = a.ASPORT_ID)'
      '    LEFT JOIN AGAMERS ag1'
      '      ON (e.AGAMER1_ID = ag1.AGAMER_ID)'
      '    LEFT JOIN AGAMERS ag2'
      '      ON (e.AGAMER2_ID = ag2.AGAMER_ID)'
      '    LEFT JOIN BGAMERS bg1'
      '      ON (e.BGAMER1_ID = bg1.BGAMER_ID)'
      '    LEFT JOIN BGAMERS bg2'
      '      ON (e.BGAMER2_ID = bg2.BGAMER_ID)'
      ''
      ' WHERE '
      '        E.EVENT_ID = :OLD_EVENT_ID'
      '    ')
    SelectSQL.Strings = (
      'SELECT'
      '    e.EVENT_ID,'
      '    e.ASPORT_ID,'
      '    a.ASPORT_NM,'
      '    e.BTOURNIR_ID,'
      '    e.EVENT_DTM,'
      '    e.AGAMER1_ID,'
      '    e.BGAMER1_ID,'
      '    coalesce(ag1.AGAMER_NM, bg1.BGAMER_NM) GAMER1_NM,'
      '    e.AGAMER2_ID,'
      '    e.BGAMER2_ID,'
      '    coalesce(ag2.AGAMER_NM, bg2.BGAMER_NM) GAMER2_NM,'
      '    e.COMPLETE_FLG,'
      '    e.IGNORE_FLG'
      'FROM'
      '    EVENTS e '
      '    LEFT JOIN ASPORTS a'
      '      ON (e.ASPORT_ID = a.ASPORT_ID)'
      '    LEFT JOIN AGAMERS ag1'
      '      ON (e.AGAMER1_ID = ag1.AGAMER_ID)'
      '    LEFT JOIN AGAMERS ag2'
      '      ON (e.AGAMER2_ID = ag2.AGAMER_ID)'
      '    LEFT JOIN BGAMERS bg1'
      '      ON (e.BGAMER1_ID = bg1.BGAMER_ID)'
      '    LEFT JOIN BGAMERS bg2'
      '      ON (e.BGAMER2_ID = bg2.BGAMER_ID)'
      'ORDER BY EVENT_DTM')
    Transaction = ReadTran
    Database = Database
    UpdateTransaction = UpdateTran
    DataSet_ID = 9
    Description = 'EVENTS'
    Left = 224
    Top = 160
    poApplyRepositary = True
  end
  object tblATournirs: TpFIBDataSet
    UpdateSQL.Strings = (
      'UPDATE ATOURNIRS'
      'SET '
      '    ASPORT_ID = :ASPORT_ID,'
      '    ATOURNIR_NM = :ATOURNIR_NM,'
      '    COUNTRY_SGN = :COUNTRY_SGN,'
      '    START_DT = :START_DT,'
      '    END_DT = :END_DT'
      'WHERE'
      '    ATOURNIR_ID = :OLD_ATOURNIR_ID'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      '    ATOURNIRS'
      'WHERE'
      '        ATOURNIR_ID = :OLD_ATOURNIR_ID'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO ATOURNIRS('
      '    ATOURNIR_ID,'
      '    ASPORT_ID,'
      '    ATOURNIR_NM,'
      '    COUNTRY_SGN,'
      '    START_DT,'
      '    END_DT'
      ')'
      'VALUES('
      '    :ATOURNIR_ID,'
      '    :ASPORT_ID,'
      '    :ATOURNIR_NM,'
      '    :COUNTRY_SGN,'
      '    :START_DT,'
      '    :END_DT'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    t.ATOURNIR_ID,'
      '    t.ASPORT_ID,'
      '    s.ASPORT_NM,'
      '    t.ATOURNIR_NM,'
      '    t.COUNTRY_SGN,'
      '    t.START_DT,'
      '    t.END_DT'
      'FROM'
      '    ATOURNIRS t'
      '      LEFT JOIN ASPORTS s'
      '        ON (s.ASPORT_ID = t.ASPORT_ID)'
      ''
      ' WHERE '
      '        T.ATOURNIR_ID = :OLD_ATOURNIR_ID'
      '    ')
    SelectSQL.Strings = (
      'SELECT'
      '    t.ATOURNIR_ID,'
      '    t.ASPORT_ID,'
      '    s.ASPORT_NM,'
      '    t.ATOURNIR_NM,'
      '    t.COUNTRY_SGN,'
      '    t.START_DT,'
      '    t.END_DT'
      'FROM'
      '    ATOURNIRS t'
      '      LEFT JOIN ASPORTS s'
      '        ON (s.ASPORT_ID = t.ASPORT_ID)'
      'ORDER BY s.ASPORT_NM'
      '       , t.ATOURNIR_NM')
    CacheModelOptions.CacheModelKind = cmkLimitedBufferSize
    CacheModelOptions.BufferChunks = 100
    AutoUpdateOptions.UpdateTableName = 'ATOURNIRS'
    AutoUpdateOptions.KeyFields = 'ATOURNIR_ID'
    AutoUpdateOptions.GeneratorName = 'GEN_ATOURNIR_ID'
    AutoUpdateOptions.WhenGetGenID = wgBeforePost
    Transaction = ReadTran
    Database = Database
    UpdateTransaction = UpdateTran
    AutoCommit = True
    DataSet_ID = 5
    Description = 'ATOURNIRS'
    Left = 152
    Top = 208
    poApplyRepositary = True
  end
  object tblHistory: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    ASPORT_ID,'
      '    ATOURNIR_ID,'
      '    ATOURNIR_NM,'
      '    AGAMER_ID,'
      '    AGAMER_NM'
      'FROM'
      '    V_HISTORY '
      'ORDER BY '
      '    AGAMER_NM')
    Transaction = ReadTran
    Database = Database
    UpdateTransaction = UpdateTran
    DataSet_ID = 11
    Description = 'HISTORY'
    Left = 288
    Top = 16
    poApplyRepositary = True
  end
  object spPutEvent: TpFIBStoredProc
    Transaction = UpdateTran
    Database = Database
    SQL.Strings = (
      
        'EXECUTE PROCEDURE PUT_EVENTBETS (?I_BTOURNIR_ID, ?I_EVENT_DTM, ?' +
        'I_BGAMER1_NM, ?I_BGAMER2_NM, ?I_S_0, ?I_V_0, ?I_K_0, ?I_S_1, ?I_' +
        'V_1, ?I_K_1, ?I_S_2, ?I_V_2, ?I_K_2, ?I_S_3, ?I_V_3, ?I_K_3, ?I_' +
        'S_4, ?I_V_4, ?I_K_4, ?I_S_5, ?I_V_5, ?I_K_5, ?I_S_6, ?I_V_6, ?I_' +
        'K_6, ?I_S_7, ?I_V_7, ?I_K_7, ?I_S_8, ?I_V_8, ?I_K_8, ?I_S_9, ?I_' +
        'V_9, ?I_K_9)')
    StoredProcName = 'PUT_EVENTBETS'
    Left = 88
    Top = 112
    qoAutoCommit = True
    qoStartTransaction = True
  end
  object spGetSport: TpFIBStoredProc
    Transaction = UpdateTran
    Database = Database
    SQL.Strings = (
      
        'EXECUTE PROCEDURE GET_ASPORT_BY_BSPORT_NM (?I_BSPORT_NM, ?I_BTOU' +
        'RNIR_NM, ?I_BOOKER_ID)')
    StoredProcName = 'GET_ASPORT_BY_BSPORT_NM'
    Left = 88
    Top = 160
    qoAutoCommit = True
    qoStartTransaction = True
  end
end
