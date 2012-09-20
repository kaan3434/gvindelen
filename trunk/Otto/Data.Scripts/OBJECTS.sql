INSERT INTO OBJECTS (OBJECT_SIGN, OBJECT_NAME, TABLE_NAME, IDFIELD_NAME, ATTR_TABLE_NAME, PROCEDURE_READ) VALUES ('ORDER', '������', 'ORDERS', 'ORDER_ID', 'ORDER_ATTRS', 'ORDER_READ');
INSERT INTO OBJECTS (OBJECT_SIGN, OBJECT_NAME, TABLE_NAME, IDFIELD_NAME, ATTR_TABLE_NAME, PROCEDURE_READ) VALUES ('ARTICLE', '�������', 'ARTICLES', 'ARTICLE_ID', 'ARTICLE_ATTRS', NULL);
INSERT INTO OBJECTS (OBJECT_SIGN, OBJECT_NAME, TABLE_NAME, IDFIELD_NAME, ATTR_TABLE_NAME, PROCEDURE_READ) VALUES ('ORDERITEM', '������� ������', 'ORDERITEMS', 'ORDERITEM_ID', 'ORDERITEM_ATTRS', 'ORDERITEM_READ');
INSERT INTO OBJECTS (OBJECT_SIGN, OBJECT_NAME, TABLE_NAME, IDFIELD_NAME, ATTR_TABLE_NAME, PROCEDURE_READ) VALUES ('CLIENT', '������', 'CLIENTS', 'CLIENT_ID', 'CLIENT_ATTRS', NULL);
INSERT INTO OBJECTS (OBJECT_SIGN, OBJECT_NAME, TABLE_NAME, IDFIELD_NAME, ATTR_TABLE_NAME, PROCEDURE_READ) VALUES ('ADRESS', '�����', 'ADRESSES', 'ADRESS_ID', NULL, NULL);
INSERT INTO OBJECTS (OBJECT_SIGN, OBJECT_NAME, TABLE_NAME, IDFIELD_NAME, ATTR_TABLE_NAME, PROCEDURE_READ) VALUES ('PLACE', '������', 'PLACES', 'PLACE_ID', NULL, 'PLACE_READ');
INSERT INTO OBJECTS (OBJECT_SIGN, OBJECT_NAME, TABLE_NAME, IDFIELD_NAME, ATTR_TABLE_NAME, PROCEDURE_READ) VALUES ('CATALOG', '�������', 'CATALOGS', 'CATALOG_ID', NULL, NULL);
INSERT INTO OBJECTS (OBJECT_SIGN, OBJECT_NAME, TABLE_NAME, IDFIELD_NAME, ATTR_TABLE_NAME, PROCEDURE_READ) VALUES ('MAGAZINE', '������', 'MAGAZINES', 'MAGAZINE_ID', NULL, NULL);
INSERT INTO OBJECTS (OBJECT_SIGN, OBJECT_NAME, TABLE_NAME, IDFIELD_NAME, ATTR_TABLE_NAME, PROCEDURE_READ) VALUES ('EVENT', '�������', 'EVENTS', 'EVENT_ID', NULL, NULL);
INSERT INTO OBJECTS (OBJECT_SIGN, OBJECT_NAME, TABLE_NAME, IDFIELD_NAME, ATTR_TABLE_NAME, PROCEDURE_READ) VALUES ('ARTICLECODE', '������� ��������', 'ARTICLECODES', 'ARTICLECODE_ID', 'ARTICLECODE_ATTRS', NULL);
INSERT INTO OBJECTS (OBJECT_SIGN, OBJECT_NAME, TABLE_NAME, IDFIELD_NAME, ATTR_TABLE_NAME, PROCEDURE_READ) VALUES ('ACTION', '��������', 'ACTIONS', 'ACTION_ID', NULL, NULL);
INSERT INTO OBJECTS (OBJECT_SIGN, OBJECT_NAME, TABLE_NAME, IDFIELD_NAME, ATTR_TABLE_NAME, PROCEDURE_READ) VALUES ('ACCOUNT', '����', 'ACCOUNTS', 'ACCOUNT_ID', NULL, NULL);
INSERT INTO OBJECTS (OBJECT_SIGN, OBJECT_NAME, TABLE_NAME, IDFIELD_NAME, ATTR_TABLE_NAME, PROCEDURE_READ) VALUES ('MESSAGE', '���������', 'MESSAGES', 'MESSAGE_ID', 'MESSAGE_ATTRS', 'MESSAGE_READ');
INSERT INTO OBJECTS (OBJECT_SIGN, OBJECT_NAME, TABLE_NAME, IDFIELD_NAME, ATTR_TABLE_NAME, PROCEDURE_READ) VALUES ('NOTIFY', '���������', 'NOTIFIES', 'NOTIFY_ID', NULL, NULL);
INSERT INTO OBJECTS (OBJECT_SIGN, OBJECT_NAME, TABLE_NAME, IDFIELD_NAME, ATTR_TABLE_NAME, PROCEDURE_READ) VALUES ('ARTICLESIGN', '������ ���������', 'ARTICLESIGNS', 'ARTICLESIGN_ID', NULL, NULL);
INSERT INTO OBJECTS (OBJECT_SIGN, OBJECT_NAME, TABLE_NAME, IDFIELD_NAME, ATTR_TABLE_NAME, PROCEDURE_READ) VALUES ('TAXPLAN', '�������� ����', 'TAXPLANS', 'TAXPLAN_ID', NULL, NULL);
INSERT INTO OBJECTS (OBJECT_SIGN, OBJECT_NAME, TABLE_NAME, IDFIELD_NAME, ATTR_TABLE_NAME, PROCEDURE_READ) VALUES ('TAXSERV', '������', 'TAXSERVS', 'TAXSERV_ID', NULL, NULL);
INSERT INTO OBJECTS (OBJECT_SIGN, OBJECT_NAME, TABLE_NAME, IDFIELD_NAME, ATTR_TABLE_NAME, PROCEDURE_READ) VALUES ('TAXRATE', '�����', 'TAXRATES', 'TAXRATE_ID', 'TAXRATE_ATTRS', NULL);
INSERT INTO OBJECTS (OBJECT_SIGN, OBJECT_NAME, TABLE_NAME, IDFIELD_NAME, ATTR_TABLE_NAME, PROCEDURE_READ) VALUES ('VENDOR', '���������', 'VENDORS', 'VENDOR_ID', NULL, NULL);
INSERT INTO OBJECTS (OBJECT_SIGN, OBJECT_NAME, TABLE_NAME, IDFIELD_NAME, ATTR_TABLE_NAME, PROCEDURE_READ) VALUES ('PRODUCT', '�������', 'PRODUCTS', 'PRODUCT_ID', 'PRODUCT_ATTRS', NULL);
INSERT INTO OBJECTS (OBJECT_SIGN, OBJECT_NAME, TABLE_NAME, IDFIELD_NAME, ATTR_TABLE_NAME, PROCEDURE_READ) VALUES ('ORDERTAX', '�������� �� ������', 'ORDERTAXS', 'ORDERTAX_ID', NULL, 'ORDERTAX_READ');
INSERT INTO OBJECTS (OBJECT_SIGN, OBJECT_NAME, TABLE_NAME, IDFIELD_NAME, ATTR_TABLE_NAME, PROCEDURE_READ) VALUES ('SETTING', '���������', 'SETTINGS', 'SETTING_ID', NULL, NULL);
INSERT INTO OBJECTS (OBJECT_SIGN, OBJECT_NAME, TABLE_NAME, IDFIELD_NAME, ATTR_TABLE_NAME, PROCEDURE_READ) VALUES ('INVOICE', '���������', 'INVOICES', 'INVOICE_ID', 'INVOICE_ATTRS', NULL);
INSERT INTO OBJECTS (OBJECT_SIGN, OBJECT_NAME, TABLE_NAME, IDFIELD_NAME, ATTR_TABLE_NAME, PROCEDURE_READ) VALUES ('PAYMENT', '�������', 'PAYMENTS', 'PAYMENT_ID', NULL, NULL);
INSERT INTO OBJECTS (OBJECT_SIGN, OBJECT_NAME, TABLE_NAME, IDFIELD_NAME, ATTR_TABLE_NAME, PROCEDURE_READ) VALUES ('ORDERMONEY', '�������', 'ORDERMONEYS', 'ORDERMONEY_ID', NULL, NULL);
INSERT INTO OBJECTS (OBJECT_SIGN, OBJECT_NAME, TABLE_NAME, IDFIELD_NAME, ATTR_TABLE_NAME, PROCEDURE_READ) VALUES ('WAY', '����������� ������������ ������', 'WAYS', 'WAY_ID', NULL, NULL);
INSERT INTO OBJECTS (OBJECT_SIGN, OBJECT_NAME, TABLE_NAME, IDFIELD_NAME, ATTR_TABLE_NAME, PROCEDURE_READ) VALUES ('MONEYBACK', '�������� �����', 'MONEYBACKS', 'MONEYBACK_ID', 'MONEYBACK_ATTRS', 'MONEYBACK_READ');
INSERT INTO OBJECTS (OBJECT_SIGN, OBJECT_NAME, TABLE_NAME, IDFIELD_NAME, ATTR_TABLE_NAME, PROCEDURE_READ) VALUES ('BONUS', '������', 'BONUSES', 'BONUS_ID', NULL, NULL);

COMMIT WORK;

