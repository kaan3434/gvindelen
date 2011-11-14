SET SQL DIALECT 3;

SET NAMES WIN1251;

INSERT INTO ATTRS (ATTR_ID, OBJECT_SIGN, ATTR_SIGN, ATTR_NAME, FIELD_NAME, DIRECTION)
  VALUES (307, 'CLIENT', 'PHONE_NUMBER', '����� ��������', NULL, NULL);

UPDATE STREETTYPES
SET STREETTYPE_SHORT = '��-�',
    STREETTYPE_SIGN = '��-�'
WHERE (STREETTYPE_CODE = 4);

UPDATE STREETTYPES
SET STREETTYPE_SHORT = '��-�',
    STREETTYPE_SIGN = '��-�'
WHERE (STREETTYPE_CODE = 6);

UPDATE STREETTYPES
SET STREETTYPE_SHORT = '��',
    STREETTYPE_SIGN = '��'
WHERE (STREETTYPE_CODE = 7);

INSERT INTO STREETTYPES (STREETTYPE_CODE, STREETTYPE_NAME, STREETTYPE_SHORT, IS_DEFAULT, STREETTYPE_SIGN)
  VALUES (9, '�����', '�', NULL, '�');

INSERT INTO STREETTYPES (STREETTYPE_CODE, STREETTYPE_NAME, STREETTYPE_SHORT, IS_DEFAULT, STREETTYPE_SIGN)
  VALUES (10, '��������', '���', NULL, '���');

