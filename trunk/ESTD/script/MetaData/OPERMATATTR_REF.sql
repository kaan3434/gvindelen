INSERT INTO OPERMATATTR_REF (ATTR_CODE, ATTR_NAME, FINDTOOL_ID, KEI, VALUE_LEN) VALUES ('CONSUMPTION_RATE', 'Норма расхода материала', NULL, 0, 10);
REINSERT ('UNITS_RATE', 'Единица нормирования', NULL, 642, 5);
REINSERT ('STORAGE', 'Место промежуточного хранения/складирования', NULL, 642, 10);

COMMIT WORK;

