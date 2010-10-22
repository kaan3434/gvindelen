INSERT INTO OPERPROFATTR_REF (ATTR_CODE, ATTR_NAME, FINDTOOL_ID, KEI, VALUE_LEN) VALUES ('MECH_DEGREE', 'Степень механизации', NULL, 924, 5);
REINSERT ('CATEGORY', 'Разряд работы, необходимый для выполнения операции', NULL, 924, 2);
REINSERT ('WORK_CONDITION', 'Код условий труда по ОКПДТР', NULL, 924, 3);
REINSERT ('WORKER_COUNT', 'Количество исполнителей', NULL, 924, 2);
REINSERT ('KOID', 'Количество одновременно изготавливаемых деталей', NULL, 924, 4);
REINSERT ('UNITS_RATE', 'Единица нормирования', NULL, 924, 5);
REINSERT ('PARTION_SIZE', 'Объем производственной партии', NULL, 924, 5);
REINSERT ('KSHT', 'Коэффициент штучного времени при многостаночном обслуживании', NULL, 924, 10);
REINSERT ('TPZ', 'Норма подготовительно-заключительного времени на операцию', NULL, 355, 10);
REINSERT ('TSHT', 'Норма штучного времени на операцию', NULL, 355, 10);
REINSERT ('INHERITED_PROF_ID', 'Наследованный Идентификатор профессии', NULL, 924, 1);

COMMIT WORK;

