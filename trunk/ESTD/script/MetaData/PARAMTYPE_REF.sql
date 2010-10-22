INSERT INTO PARAMTYPE_REF (PARAMTYPE, PARAMTYPE_NAME) VALUES ('V', 'Значение');
REINSERT ('P', 'Значение из параметра');
REINSERT ('Q', 'Значение поля из SQL');
REINSERT ('A', 'Значение атрибута');

COMMIT WORK;

