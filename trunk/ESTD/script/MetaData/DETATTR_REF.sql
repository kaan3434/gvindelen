INSERT INTO DETATTR_REF (ATTR_CODE, KEI, ATTR_NAME, ATTR_LEN) VALUES ('MAJOR_VERSION', 924, 'Основное исполнение', 3);
REINSERT ('MINOR_VERSION', 924, 'Дополнительное исполнение', 2);
REINSERT ('MAIN_PART', 924, 'Основной код', 25);
REINSERT ('MAJOR_VERSION_RANGE_START', 924, 'Начало диапазона основного исполнения', 25);
REINSERT ('MAJOR_VERSION_RANGE_END', 924, 'Конец диапазона основного исполнения', 25);

COMMIT WORK;

