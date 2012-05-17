SET SQL DIALECT 3;

SET NAMES WIN1251;

SET CLIENTLIB 'fbclient.dll';


INSERT INTO FLAGS2STATUSES (STATUS_ID, FLAG_SIGN)
  VALUES (207, 'APPENDABLE');



UPDATE TEMPLATES
SET FILENAME_MASK = 'info_[[:DIGIT:]]{8}_[[:DIGIT:]]{5}_2pay_[[:DIGIT:]]{3}.txt'
WHERE (TEMPLATE_ID = 10);


INSERT INTO STATUS_RULES (OLD_STATUS_ID, NEW_STATUS_ID, ACTION_SIGN)
  VALUES (207, 209, 'ORDER_ANULLED');


DELETE FROM WAYS
WHERE (WAY_ID = 1);
DELETE FROM WAYS
WHERE (WAY_ID = 2);
DELETE FROM WAYS
WHERE (WAY_ID = 3);
DELETE FROM WAYS
WHERE (WAY_ID = 4);
DELETE FROM WAYS
WHERE (WAY_ID = 5);
DELETE FROM WAYS
WHERE (WAY_ID = 6);
DELETE FROM WAYS
WHERE (WAY_ID = 7);
DELETE FROM WAYS
WHERE (WAY_ID = 8);
DELETE FROM WAYS
WHERE (WAY_ID = 9);
DELETE FROM WAYS
WHERE (WAY_ID = 10);

DELETE FROM PORTS
WHERE (PORT_ID = 1);
DELETE FROM PORTS
WHERE (PORT_ID = 2);
DELETE FROM PORTS
WHERE (PORT_ID = 3);
DELETE FROM PORTS
WHERE (PORT_ID = 4);

