INSERT INTO OBJTYPEATTR_REF (ATTR_CODE, KEI, ATTR_NAME, ATTR_LEN) VALUES ('ALLOW_DEFAULT_DOCSET', 924, 'Признак возможночти создания набора деталей по-умолчанию', 1);
REINSERT ('DEFAULT_DOCSET_NAME', 924, 'Имя набора деталей по-умолчанию при установлееном флаге ALLOW_DEFAULT_DOCSET', 255);
REINSERT ('ALLOW_MULTIPLE_DOCSET', 924, 'Признак возможности создания нескольких наборов', 1);

COMMIT WORK;

