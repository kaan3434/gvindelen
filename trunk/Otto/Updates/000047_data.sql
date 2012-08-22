SET SQL DIALECT 3;

SET NAMES WIN1251;

SET CLIENTLIB 'fbclient.dll';


UPDATE ATTRS
SET ATTR_SIGN = 'STATIC_PHONE'
WHERE (ATTR_ID = 307);


INSERT INTO TEMPLATES (TEMPLATE_ID, FILENAME_MASK, PLUGIN_NAME)
  VALUES (12, 'order&#45;[[:DIGIT:]]{8}&#45;[[:DIGIT:]]{3}.xml', 'Заявка xml');


COMMIT WORK;

delete from payments;

delete from messages m where m.message_dtm is null;


