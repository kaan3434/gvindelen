7.0.0
  1. Поправлен RefreshFromQuery
  2. Поправлены BCDField для оффлайн работы.  
  3. Ошибка при обработке некоторых текстов запросов (комментарии вписанные впритык к значащим символам)
  4. Ошибка AutoUpdateOptions (не учитывались изменения в опциях сделанные после первого открытия датасета)
  5. Добавлена обработка параметров типа SQL_NULL для ФБ25
  6. Неправильное сохранение, считывание при использовании методов TFIBDataSet.SaveToFile, TFIBDataSet.LoadFromFile в версии под 2009-2010
 7.  Ошибка при использовании protectedEdit. Изменялось местоположение текущей записи при автокоммите.
 8. ошибка фильтрации при использовании свойства Filter   для уникодных полей под  D2010
 9. Добавлена возможность загрузки блоб полей любого размера через метод AsWideString
10. Ошибка в pFIBScripter  при обработке некоторых процедур без использования SET TERM
11. Компонент pFIBDBSchema - вычитывает информацию о метаданных, и создает скрипт, как по отдельным объектам так и по базе в целом
12. Ошибка при работе с параметрами в двойных кавычках
13. Добавилась опция DataSet.AutoUpdateOptions.UseRowsClause
14. 2009-2010 Ошибки в методах 

    procedure BatchInputRawFile(const FileName:string);
    procedure BatchOutputRawFile(const FileName:string;Version:integer=1);

15. Ошибка в методе TFIBXSQLVAR.IsRealType
16. В локальных алиасах сохранение имени клиентской библиотеки (gds32)
17. Добавлены методы pFIBDatabase.ShutDown  и pFIBDatabase.Online (ShutDown может использовать опции от FB2 
 isc_dpb_shut_multi,isc_dpb_shut_single,isc_dpb_shut_full
)
18. В метод 
         procedure SaveToFile(const FileName: string; AddInfo:Ansistring='');
     AddInfo - возможность сохранить дополнительную информацию

    procedure LoadFromFile(const FileName: string; var AddInfo:Ansistring); overload;
    получить в переменную AddInfo ранее сохраненную доп информацию

19. Метод 
    procedure TpFIBDataSet.RefreshFromDataSet(RefreshDataSet:TDataSet;const KeyFields:string;
     IsDeletedRecords:boolean=False
    );

   Может использоваться в качестве источника для рефреша многими датасетами
20. Исправлена реализация остановки фетча используя событие BeforeFetchRecord
21. Поддерживается опции ФБ2 isc_dpb_no_db_triggers,isc_dpb_utf8_filename
22. Опции ресторе под 2.5 isc_spb_res_fix_fss_metadata,isc_spb_res_fix_fss_data
23. Опция датасета poDontCloseAfterEndTransaction
24. Скриптер  не отрабатывал многобайтные терминаторы

6.9.9
 1. Ошибка при использовании  AutoUpdateOptions.UseExecuteBlock
 2. При AutoUpdateOptions.UseExecuteBlock  блоки сейчас выполняются через Transaction.ExecSQLImmediate
 3. TFIBStringField.Value  под 2009 под уникодным коннектом
 4. не работала опция qoTrimCharFields  для свойства FIBQuery.Fields.AsWideString
 5. Ошибка при попытке использовать TWideStringField в качестве калк поля
 6. Ошибка при показе пустого значения уникодного поля
 7. Утечки памяти в многопоточных приложениях
 8. Ошибка при использовании мидаса под 2009 (с опцией poAllowCommandText)
 9. Ошибка при использовании макросов с дефолтными значениями под 2009 
10. Ошибка при импортировании значений полей по умолчанию  под 2009
11. Ошибка свойства DataSet.FieldValues  при работе с уникодными базами под 2009. 
12. Переделана работа с уникодными-блоб полями под мидас-приложениями Д2009. 
13. Методы TFIBXSQLVAR.LoadFromFile,TFIBXSQLVAR.SaveToFile  теперь не делают загрузку 
    содержимого файла в память, а пишут прямо из файла в базу (из базы в файл). 
    Применимо для работы с большими блоб файлами.
14. Совместимость со студией 2010.
15. В скриптере появилась команда SET CLIENTLIB.
16. Под 2009-2010 по умолчанию уникодные поля теперь маппируются на TFIBWideStringField.
    Связано с невозможностью корректной обработки TStringField  в мидас приложениях

 serg_vostrikov (15:53:06 10/11/2009)
17. Скриптер не отрабатывал EXECUTE BLOCK в случае если терминатором являлась ';'
18. В режиме protected edit  запись не всегда блокировалась повторно (т.е. ситуация 
  Edit;Post; Commit; Edit; // На втором   Edit блокировка происходила не всегда
)
19 Ошибка свойства AsGuid  в классе TFIBGuidField.
20. Ошибка уникодных лукап полей
21. Метод DataSet.RefreshFromQuery
22. Ошибка редактора SQLEditor под D2009-2010   в случае использования ФB ниже 2.1
23. Database.AutoReconnect:boolean



6.9.6
1. Не сохранялись опция датасета poFreeHandlesAfterClose и квери qoFreeHandleAfterExecute
2. Под д2009 ошибка при работе с IB  и FB версии младше 2. Проявлялась при дефайне
{$DEFINE UNICODE_TO_STRING_FIELDS}
3. Добавлено событие FIBDatabase
   TOnIdleConnect=procedure (Sender:TFIBDatabase; IdleTicks:Cardinal; var Action:TActionOnIdle) of object;
  где TActionOnIdle=(aiCloseConnect,aiKeepLiveConnect);
  Возникает при "простое соединения" в случае если свойство TimeOut <>0. 
4. Заменен Timer. Стандартный из VCL  оказался  потоконебезопасным
5. Ошибка в методе TpFIBScripter.ExecuteFromFile. Проявлялась на некоторых скриптах
6. Ошибка в методе Locate  под Д2009. Проявлялась при  опциях поиска
Locate('FIELD', searchstr, [loCaseInsensitive, loPartialKey])
7. Обшибка при работе с блобами. Проявлялась только под FB2.5  в случае если заполненное блобполе зануляли,а после этого опять заполняли.
8. Под 2009 ошибка Malformed string при попытке записать текстовое блоб-поле под уникодным коннектом.
9  Не выполнялся метод TpFIBTransaction. SetSavePoint  под 2009
10. Новые события датасета OnReadBlobField :TOnBlobFieldProcessing
                                             OnWriteBlobField :TOnBlobFieldProcessing
где TOnBlobFieldProcessing= procedure (Field:TBlobField;BlobSize:integer;Progress:integer;var Stop:boolean)
11. Уникодные поля стали совместимыми с TClientDataSet.
12  Восстановлена совместимость GUID  полей с полями  TClientDataSet
13. D2009  ошибка при локэйте по  GUID   полям
14. pFIBClientDataSet. Методы Commit,RollBack
15. Ошибка при передаче параметров в мидас приложениях под Д2009
16. AutoUpdateOptions.UseReturningFields -Указывает использовать ли для генерации UpdateSQL,InsertSQL  секцию RETURNING, что позволяет после выполнения модифицирующего запроса частично «освежить» запись без выполнения метода Refresh.  (работает начиная с файрберд 2.0)  Имеет три возможных значения. 
 rfAll - включать в секцию RETURNING  все поля
 rfKeyFields - включать в секцию RETURNING  только ключевые поля
 rfBlobFields- включать в секцию RETURNING  блоб поля. 



6.9.5
1. обработчик pFIBDataSet.OnLockSQLText. Позволяет заменить генерацию лок-сиквела своей.
2. Борландовский TTimer  оказался не потоко-безопасным. Заменен на свой.
3. В скриптере ошибка при обработке содержимого блоб-полей
4. Ошибка при работе строковых полей не являющихся FIBStringField
5. Ошибка в методе Locate  при поиске по калк полям, если включена опция кэширования калк полей

6.8.588
   1. Ошибка в парсере, приводило к неправильной автогенерации RefreshSQL  в некоторых случаях
    www.devrace.com/bitrix/admin/ticket_edit.php?ID=10095
   2. Ошибка 'Can't read Buffer.Incorrect RecordNo.' 
      при использовании новой версии Locate
   3. Потенциальная утечка памяти при использовании сервисов
   4. В скриптере не обрабатывалась команда SET STATISTICS INDEX, добавлено
   5. Ошибка при многопоточной работе
   6. Ошибка в методах AsWideString  для полей с чарсетом NONE
   7. Ошибка при генерации запроса  количества записей 
   8. Ошибка LockRecord
   9.  Ошибки в новой (быстрой) имплементации метода Locate
   10. плавающее AV  в алертере 
   11. Методы FIBDatabase
   
    a) procedure CancelOperationFB21(ConnectForCancel:TFIBDatabase=nil);
       прерывает долгоиграющие запросы. (работает только под FB21 и выше)
    б) 

   procedure RaiseCancelOperations;
   procedure EnableCancelOperations;
   procedure DisableCancelOperations;
Методы для прерывания долгоиграющих запросов под FB2.5
   12. Добавлен чекбокс UseSelectForLock   на странице Preference Dataset в тулзах
   13. Ошибки при работе  с блоб полями под старыми версиями интербейс и файрберда

6.8.500
   1. Тормоза при работе со строками через FIBQuery
   2. Ошибка при работе с транзакцией на несколько датабэйсов. (иногда проявлялось при освобождении 
      датабэйсов ) 
   3.  Ошибка при доступе к нескольким бд из программы. 
   4. Ошибка при работе с   TFIBLargeIntField.Value
   5. Ошибка в TpFIBScripter при работе с командами 
    COMMENT ON COLUMN ... IS

   6. 2PC  транзакции  с разными параметрами транзакций
   7. Опция датасета CacheModelOptions.BlobCacheLimit
   8.  Ошибка в TpFIBScripter при попытке создать БД в папке имеющую пробелы в имени.
   9. Ошибка в работе с CsMonitor. 
  10. Ошибка в методе датасета VisibleRecordCount (проявлялась с датасетами имеющими удаленные записи)

6.8.423
 1. Поддержка CsMonitor. (Спасибо Юре Плотникову) Включается дефайном в 
    FIBPlus.inc    
 2. Добавился метод procedure TFIBDatabase.ClearQueryCacheList;
 3. Исправлена ошибка в методе CloneRecord. Проявлялась при наличии в датасете 
    удаленных записей
 4. исправлено Неправильное позиционирование текущей записи после рефреша 
    удаленной при включенной опции poRefreshDeleted
 5. Поправлены параметры внутренних транзакций с учетом требований ФБ21
 6. У полей TFIBDataTimeField, TFIBTimeField  появилось свойство 
    ShowMsec:boolean. При включении в дбконтролах будут показываться  значения
    с миллисекундами
 7. Существенно убыстрен метод Locate. (новую реализаци можно выключить выключив дефайн
    {$DEFINE FAST_LOCATE} в файле FIBPlus.inc    
)
 8. Метод LookUp  будет для поиска нужных значений 
    использовать сортировку в датасете если она присутствует
 9. Под ФБ2.1 булин, и гуид поля могут создаваться и для Select from procedure  если там выходные
     параметры имеют тип - соответствующий домен.
10. Алертер  - поправлена авторегистрация интереса к событиям. Не срабатывала когда алертер и 
     датабэйс лежат на разных формах
11. Поправлен метод 
      procedure TFIBLargeIntField.SetVarValue(const Value: Variant);
      неправильно работал если на входе было нулл значение

6.8.411
 1. Добавлен компонент TpFIBScripter
 2. В режиме CachedUpdates для удаленных записей при CancelUpdates восстанавливались значения полей
     которые были непосредственно в момент удаления. Т.е. если запись сначала редактировалась а потом
    удалялась то при отмене изменений мы получали не изначальные значения записи а измененные.
 3. Добавились методы 

    TFIBDataSet
    procedure DisableMasterSource;
    procedure EnableMasterSource;
    function  MasterSourceDisabled:boolean;

   Служат для временного отключения режима мастер-деталь.  Например

   DetailDataSet.DisableMasterSource;
   try
     MasterDataSet.Edit;
     MasterDataSet.FieldByName('ID').asInteger:=NewValue;
     MasterDataSet.Post;
     ChangeDetailDataSetLinkField(NewValue);
   finally
    DetailDataSet.EnableMasterSource;
   end
  при этом деталь датасет не переоткрывается. 
 4. Свойство DetailDataSet.AutoUpdateOptions.UseExecuteBlock:boolean
    Работает только при CachedUpdates=True.  Если включено UseExecuteBlock, то при ApplyUpdates,ApplyUpdToBase
    будут генериться запросы типа EXECUTE BLOCK. Т.е. изменения будут посылаться в базу не для каждой
    записи отдельно, а пачками по 255 записей. 
 5. Поправлена  работа с UTF8  полями под ИБ2007

71.302
  1.Утечка памяти при использовании CachedUpdates и многократном редактировании одной и той же записи
 2. Неправильная работа при присвоении Date параметра через Value.
 3. Замена нулл параметров на строку IS NULL теперь происходит непосредственно     перед выполнением запроса. Т.е. если пользователь заранее вызвал Prepare то препарируется именно пользовательский запрос без всяких замен, несмотря на то что некоторые параметры имеют NULL значения
 4. Поправлена работа с DDL запросами под FB21 с базами ODS11. (конвертация комментариев в уникоду)

51.301
1. Ошибка в TFIBGuidField. Неправильно отображало некоторые значения. Например значение
 {00000000-0000-0000-0000-000000000000}
2. Ошибка при вызове метода IsEmpty при установленном свойстве 
 DataSet.CacheModelOptions.CacheModelKind= cmkLimitedBufferSize.
3. Ошибка в процедуре Sort (unit fibDataset) c DisableScrollEvents. Проявлялось если  в датасете записей не более одной.
4. Ошибка в методе  function TpFIBDataSet.PSGetParams: TParams;(спасибо Danny Van den Wouwer )

5. Поправлен pFIBClientDataSet. Не работал с уникодными полями под БДС2006

6. Изменен метод procedure TFIBXSQLVAR.SetAsVariant(Value: Variant);
     Теперь он может  работать и с OleVariant  (спасибо Danny Van den Wouwer )
7. Ошибка  в методе TFIBQuery.DoAfterExecute 
     приводило к неправильной последовательности вывода действий на SQLMonitor
(спасибо Danny Van den Wouwer )

 8. Ошибка при смене клиентской библиотеки в рантайме.
 9. Поддержка чарсетов SUPPORT_KOI8_CHARSET
     дефайн в FIBPlus.inc {$DEFINE SUPPORT_KOI8_CHARSET}
 10. Поддержка ИБ2007
     а) специальный дефайн в FIBPlus.inc {$DEFINE SUPPORT_IB2007} 
     б) метод FIBdatabase.IsIB2007Connect:boolean;
     в) свойство InstanceName  в ConnectParams
 11. Ошибка в методе       TFIBXSQLVAR.GetAsDateTime. Проявлялась при датах меньших начальной ИБ.
 12. Ошибка в методе WhereClause неправильно обрабатывались комментарии в стиле ФБ (--)
 13. Ошибка при обработке запросов c "with" клаузой для FB2.1
 14. Не работали TGUIDFields  в TFIBClientDataSet

+++++++++++++++++++++++++++


274. 1. Ошибка при выполнении DDL  запросов в уникодном коннекте. 
        (портились комментарии сделанные на не английском языке)   
  
272
 1. Добавилась опция poUseSelectForLock в TpFIBDataSet.Options. 
    Действует при включенном poProtectedEdit. В случае включения этой опции, 
    блокирование записи будет производиться не "холостым апдейтом" а конструкцией
    
    Select * from TABLE1 WHERE ... for update with lock
    (работает ТОЛЬКО для ФБ)
 2. Метод FIBQuery.ExecuteImmediate. Немедленно выполняет запрос без предварительной 
    препарации. (См. документацию по ИБ АПИ функции isc_dsql_execute_immediate)
 3. Выполнение DDL запросов сейчас производится через  ExecuteImmediate

270  
 1. В некоторых случаях неверно происходило  добавление в сортированный НД
 2. В процедуре CopyFieldsProperties добавлено копирование свойств 
  AutoGenerateValue, ConstraintErrorMessage, CustomConstraint, Tag и Index 
 3. Ошибка в TpFIBCustomService.GenerateSPB. Проявлялась при пустом значениии Params
 4. При смене свойства  Filter  не происходит зануления результатов предыдущего фильтра.
 5. Ошибка в методе Locate  при попытке поиска числовых значений в стринговых полях.
 6. SQLMonitor стал показывать текст сиквела уже после применения макросов и кондишенов 
 7. Событие OnFillClientBlob теперь вызывается  не только при первом считывании записи, 
    но и после ее модификации 
 8. Свойство pFIBDataSet.ReceiveEvents и событие pFIBDataSet.OnUserEvent объявляется устаревшим и убирается из основного кода.
    Тем кто все же использует его, нужно компилироваться с дефайном 
USE_DEPRECATE_METHODS2 в файле FIBplus.inc
 9. Поправлена работа SQLMonitor при мониторинге эксепшнов. (Иногда приводило к зависанию)
10. SQL редактор датасета подправлен, для правильной работы с запросами в которых одна и 
    та же таблица входит по нескольку раз.    (гарантия только под ФБ2)
 
269. Не был предусмотрен тип ftSmallInt  для кэшированных вычисляемых полей 
     в TFIBCustomDataSet.RecordFieldValue

268. Неправильная обработка полей с чарсетом UTF8  и коллэйтом отличным от 
умолчательного.

267.
 1. При обнаружении что база находится в shutdown коннект автоматически закрывается,
    далее производится обработка потери коннекта (при использовании pFibErrorHandler)
 2. Ошибка в  генераторе запросов. Не показывался тип поля, для полей DOUBLE PRECISION
266.
 1. Небольшая утечка памяти при работе с блоб-параметрами в некоторых случаях
 2. Ошибка при поиске (Locate) unicode-строки в поле varchar(unicode_fss) при 
    включенной опции poTrimCharFields 

265
 1. Поправлена функция 
    function  InvertOrderClause(const OrderText:string):string;
    (не обрабатывала ордер бай с употреблением NULLS FIRST, как следствие это приводило 
    к некорректной работе режима ограниченного кэша для таких запросов)
254
 1. Поправлены методы TpFIBDataSet.PSInTransaction, PSStartTransaction,PSEndTransaction


253
 1. Более корректная обработка запросов "COMMIT" "ROLLBACK".
 2. Поправлен  редактор репозитория ошибок. Неправильно работал при выборе 
    "Unique Indices"
 3. Исправлена ошибка в методе FIBDataSet.RecordFieldValue(Field:TField;aBookmark:TBookmark):Variant; 
251

1.Если текущий текст клаузы PLAN в запросе TpFIBDataSet.SelectSQL использует неявный JOIN (т.е. 
  начинается не со слова JOIN, а со скобки), то присваивание свойству TpFIBDataSet.PlanClause нового значения имеет 
  результатом запрос с неверной клаузой PLAN (в нём присутствует ненужная скобка после слова PLAN).
  Исправлено
2. TpFibErrorHandler исправил обработку сообщений о пользовательских эксепшнах под ФБ2.
   (с учетом введенного в этой версии PSQL Stack Trace) 
3. Мелкая ошибка  в методе FIBQuery.PrepareArraySqlVar 
4. Подправлена обработка потери коннекта для случая когда производится попытка его 
   восстановления

250.
  1. TFIBCustomDataSet.RecordFieldValue отстутствовала обработка BOOLEAN полей 
     от ИБ7
  2. Добавлена обработка полей чарсета UTF8 для ФБ1.5 и ФБ2
  3. Для датабэйса добавилось свойство
      property UseBlrToTextFilter :boolean 
     Включает выключает обработку блоб полей с подтипами Blr (2), Acl(3)
     (Задолбали меня. Подтип 2 оказывается слишком многие используют не по назначению)

248.
   CloneCurRecord: error with boolean field in record (IB7)
247
 1.Ошибка в LocateNext. Если последняя запись датасета удовлетворяет условию поиска,
   и поиск начинается с нее, то LocateNext возвращал True
 2.Неправильная работа методов  LocateXXX в сочетании с фильтрацией по 
   вычисляемым полям. Проявлялась в случае если Locate происходил по невычисляемым 
   полям а фильтрация по вычисляемым

 3. Метода  FIBDatabase.QueryValueAsStr стала возвращать пустую строку в случае 
    когда  запрос, передаваемый в функцию ничего не возвращает или возвращаемое поле Null,

 4. Если установить в датасете CachedUpdates=True и поставить в OnUpdateError "UpdateAction:=uaAbort;", 
    то после отработки OnUpdateError возникал EAccessViolation.

245
 1.В датасете появился обработчик
 TOnApplyFieldRepository=procedure(DataSet:TDataSet;Field:TField;FieldInfo:TpFIBFieldInfo) of object;
 2.В DSContainer появился обработчик аналогичный п1
 3.В DSContainer появилась проперть IsGlobal:boolean. При взведении ее в True 
   действие контейнера начинает распространяться на ВСЕ датасеты  приложения.

Совокупность п1-3 позволяет разработчику легко использовать свои собственные настройки в
репозитарии полей. Как пример. Если хочется настраивать свойство EditMask, то добавляем
в таблицу репозитория поле  EDIT_MASK, в приложении ставим контейнер, делаем его глобальным
в обработчике  OnApplyFieldRepository пишем:

procedure TForm1.DataSetsContainer1ApplyFieldRepository(DataSet: TDataSet;
  Field: TField; FieldInfo: TpFIBFieldInfo);
begin
 Field.EditMask:=FieldInfo.OtherInfo.Values['EDIT_MASK'];
end;

243
 1. Ошибка в SQLEditor при попытке работы с СП.
 2. Ошибка при генерации RefreshSQL если алиас таблицы начинается с буквосочетания "AS"
 
242
 1. Ошибка при выполнении некоторых execute block
 2. Ошибка при обработке потери коннекта в случае если существует несколько коннектов к разным базам

241
 1. Для полей LargeInt  свойство Filter неработоспособно
 2. Плавающее АВ при обращении к DoTrim когда в качестве аргумента используется пустая строка
 


240
1.LocateNext работает неправильно, если не все записи выбраны в кэш 
2.ExtLocate при успешном поиске по сортированному датасету, при наличии нескольких одинаковых 
  по искомым полям записей, иногда показывал не первую найденную запись, а последнюю

234
 BCD поля не могли использоваться в качестве лукапных
232
 1. AV под дизайном BDS2006  в CBuilder проектах
 2. Небольшая поправка в SQLNavigator из FIBPlusTools.
При открытии окна SQL Navigator над свежесозданным проектом приложения (File->New->Application; FibPlus->SQL Navigator:) 
происходило исчезновение из проекта модуля, созданного по умолчанию (Unit1.pas).
 3. Мелкие ошибки при поиске в тексте SQL в SQLEditor

231
1. Добавлен обработчик TFIBDataSet.
    property AfterUpdateRecord: TFIBAfterUpdateRecordEvent read FAfterUpdateRecord
     write FAfterUpdateRecord
где  


  TFIBAfterUpdateRecordEvent = procedure(DataSet: TDataSet; UpdateKind: TUpdateKind;
    var Resume:boolean) of object;

Вызывается из ApplyUpdates,ApplyUpdToBase для каждой записи модификации которой 
отправляются на сервер. Вызывается непосредственно ПОСЛЕ того как успешно вызвался 
запрос на изменения.
2. Ошибка при Locate: если в датасете запись была удалена, а после этого был вызван 
   Locate условиям которого она удовлетворяет
3. Ошибка при обработке Field.DisplayFormat  вида 
"#,##0.00;-#,##0.00; ;"
4. Неправильная работа  SQL editor при установленном флажке "Use Selected Fiedls Only"
5. Неправильная работа  SQL editor при генерации рефреша, при присутствии в начале 
   SelectSQL закомментированного текста

230
 1.Неправильная работа опции dcForceMasterRefresh
 2.Ошибка в poKeepSorting при попытке изменения ПЕРВОЙ записи датасета 
 3.Подвисание при использовании poKeepSorting  
 4.Ошибка при применении poProtectedEdit .Позиция текущей записи сбивалась
 5. Пакеты под BDS2006  переделаны. В предыдущей версии они не работали при 
   попытке использования в CBuilder приложениях
 6. В тулзах закладка Preferences  пополнены опциями poUseLargeIntField в 
    PrepareOptions и настройкой DateTimeDisplay в DefaultFormats



225-226
 Тулзы под D2006

224
 Пакеты под D2006
214
1. Обошли ошибку компилятора E5912. Проявлялась при попытке скомпилировать 
   строки FIBBCDField.Value:=1;

2. Ошибка при работе с памятью в TFIBStringField. Проявлялась когда поля были
   созданы под дизайном, а в рантайме менялся текст SQL таким образом, что длина
   поля изменялась в большую сторону.  
 
                                                      
213
Добавилась опция датасета poRefreshAfterDelete. Если включена, то после 
DataSet.Delete производится попытка рефреша только что удаленной записи. 
Если попытка успешная (т.е. запись физически не была удалена), то запись не 
будет  помечаться в кэше как удаленная и останется видимой.