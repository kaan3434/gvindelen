INSERT INTO ORGUNITS (ORGUNIT_ID, ORGUNIT_CODE, ORGUNIT_TYPE_CODE, ORGUNIT_NAME, PARENT_ID, ORGUNIT_SIGN) VALUES (1, 'МЭТЗ', 0, 'МЭТЗ', NULL, 'МЭТЗ');
REINSERT (2, '06', 1, 'Цех 6', 1, 'МЭТЗ.06');
REINSERT (3, '04', 1, 'Цех 4', 1, 'МЭТЗ.04');
REINSERT (4, '09', 1, 'Цех 9', 1, 'МЭТЗ.09');
REINSERT (5, '10', 1, 'Цех 10', 1, 'МЭТЗ.10');
REINSERT (6, '04', 2, 'Уч. 4. Сварочный', 2, 'МЭТЗ.06.04');
REINSERT (7, 'РиК', 0, 'Рога и копыта', NULL, 'РиК');
REINSERT (8, '01', 1, 'Цех  1', 7, 'РиК.01');

COMMIT WORK;

