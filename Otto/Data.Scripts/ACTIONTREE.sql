INSERT INTO ACTIONTREE (ACTIONTREEITEM_ID, ACTION_SIGN, ORDER_NO, CHILD_ACTION) VALUES (2, 'ORDER_DRAFT', 2, 'ORDER_FOREACH_TAXRATE');
INSERT INTO ACTIONTREE (ACTIONTREEITEM_ID, ACTION_SIGN, ORDER_NO, CHILD_ACTION) VALUES (31, 'ORDER_ACCEPTREQUEST', 1, 'ORDER_FOREACH_ORDERITEM');
INSERT INTO ACTIONTREE (ACTIONTREEITEM_ID, ACTION_SIGN, ORDER_NO, CHILD_ACTION) VALUES (4, 'ORDER_APPROVE', 2, 'ORDER_FOREACH_ORDERTAX');
INSERT INTO ACTIONTREE (ACTIONTREEITEM_ID, ACTION_SIGN, ORDER_NO, CHILD_ACTION) VALUES (5, 'ORDER_APPROVE', 3, 'CLIENT_APPROVE');
INSERT INTO ACTIONTREE (ACTIONTREEITEM_ID, ACTION_SIGN, ORDER_NO, CHILD_ACTION) VALUES (3, 'ORDER_APPROVE', 1, 'ORDER_FOREACH_ORDERITEM');
INSERT INTO ACTIONTREE (ACTIONTREEITEM_ID, ACTION_SIGN, ORDER_NO, CHILD_ACTION) VALUES (22, 'ORDER_DISAPPROVE', 2, 'ORDER_FOREACH_ORDERTAX');
INSERT INTO ACTIONTREE (ACTIONTREEITEM_ID, ACTION_SIGN, ORDER_NO, CHILD_ACTION) VALUES (21, 'ORDER_DISAPPROVE', 1, 'ORDER_FOREACH_ORDERITEM');
INSERT INTO ACTIONTREE (ACTIONTREEITEM_ID, ACTION_SIGN, ORDER_NO, CHILD_ACTION) VALUES (8, 'ORDER_APPROVE', 4, 'EVENT_CREATE');
INSERT INTO ACTIONTREE (ACTIONTREEITEM_ID, ACTION_SIGN, ORDER_NO, CHILD_ACTION) VALUES (9, 'CLIENT_STORE', 1, 'ACCOUNT_CREATE');
INSERT INTO ACTIONTREE (ACTIONTREEITEM_ID, ACTION_SIGN, ORDER_NO, CHILD_ACTION) VALUES (30, 'ACCOUNT_PAYMENTIN', 1, 'ACCOUNT_CREDITORDER');
INSERT INTO ACTIONTREE (ACTIONTREEITEM_ID, ACTION_SIGN, ORDER_NO, CHILD_ACTION) VALUES (41, 'ORDERITEM_ANULLED', 1, 'ORDER_ANULLED');
INSERT INTO ACTIONTREE (ACTIONTREEITEM_ID, ACTION_SIGN, ORDER_NO, CHILD_ACTION) VALUES (42, 'ORDER_ANULLED', 1, 'ORDER_FOREACH_ORDERTAX');
INSERT INTO ACTIONTREE (ACTIONTREEITEM_ID, ACTION_SIGN, ORDER_NO, CHILD_ACTION) VALUES (43, 'ORDER_ANULLED', 2, 'ACCOUNT_DEBITORDER');
INSERT INTO ACTIONTREE (ACTIONTREEITEM_ID, ACTION_SIGN, ORDER_NO, CHILD_ACTION) VALUES (51, 'ORDERITEM_CANCEL', 1, 'ORDER_CANCELLED');
INSERT INTO ACTIONTREE (ACTIONTREEITEM_ID, ACTION_SIGN, ORDER_NO, CHILD_ACTION) VALUES (52, 'ORDER_CANCELLED', 1, 'ORDER_FOREACH_ORDERTAX');
INSERT INTO ACTIONTREE (ACTIONTREEITEM_ID, ACTION_SIGN, ORDER_NO, CHILD_ACTION) VALUES (53, 'ORDER_CANCELLED', 2, 'ACCOUNT_DEBITORDER');
INSERT INTO ACTIONTREE (ACTIONTREEITEM_ID, ACTION_SIGN, ORDER_NO, CHILD_ACTION) VALUES (61, 'ORDER_HAVERETURN', 1, 'ORDER_FOREACH_TAXRATE');
INSERT INTO ACTIONTREE (ACTIONTREEITEM_ID, ACTION_SIGN, ORDER_NO, CHILD_ACTION) VALUES (62, 'ORDER_HAVERETURN', 2, 'ACCOUNT_DEBITORDER');

COMMIT WORK;

