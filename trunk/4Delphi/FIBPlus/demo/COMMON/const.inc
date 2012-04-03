
{*******************************************************}
{                                                       }
{             Copyright (C) 2000 - 2001                 }
{         Dmitriy Kovalenko (ibsysdba@i.com.ua)         }
{                         &                             }
{           Pavel Shibanov (ib_db@i.com.ua)             }
{                   Kiev, Ukraine                       }
{                                                       }
{*******************************************************}

const
  APP_NAME       = 'FIBPlus Demo Pack';
  INI_FILE_NAME  = 'fibplus_demo.ini'; // Файл настроек

  SEARCH_DELAY     = 1500; //Временная задержка для поиска
  INTERNAL_MESSAGE = $0400 {WM_USER} + 100; //"Маркировка" внутрипрограммных мессаг


  CR                 = #13#10; //Перевод каретки
  DLL_NAME                = 'FIBPLUS_DLL';
  DLL_PATH                = 'DLL\';
  DLL_EXT                 = '.DLL';
  DLL_ERROR_LOAD          = 'Невозможно загрузить ';
  GET_PROC_ADDRESS_FAILED = 'Отсутствует загружаемая DLL ' + CR +
                            'или в DLL не найден адрес необходимой функции.';

  UNDER_CONSTRUCTION = 'Sorry,... coming soon.' + CR + 'Under construction.';

  INSERT_RECORD = 'Insert new record';
  EDIT_RECORD   = 'Edit current record';
