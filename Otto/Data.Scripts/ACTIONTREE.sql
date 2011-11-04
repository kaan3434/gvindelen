INSERT INTO ACTIONTREE (ACTIONTREEITEM_ID, ACTION_SIGN, ORDER_NO, CHILD_ACTION) VALUES (2, 'ORDER_CREATE', 2, 'ORDER_FOREACH_TAXRATE');
INSERT INTO ACTIONTREE (ACTIONTREEITEM_ID, ACTION_SIGN, ORDER_NO, CHILD_ACTION) VALUES (1, 'CLIENT_CREATE', 1, 'ACCOUNT_STORE');
INSERT INTO ACTIONTREE (ACTIONTREEITEM_ID, ACTION_SIGN, ORDER_NO, CHILD_ACTION) VALUES (6, 'ORDERITEM_APPROVE', 1, 'ACCOUNT_CREDIT');
INSERT INTO ACTIONTREE (ACTIONTREEITEM_ID, ACTION_SIGN, ORDER_NO, CHILD_ACTION) VALUES (7, 'ORDERTAX_APPROVE', 1, 'ACCOUNT_CREDIT');
INSERT INTO ACTIONTREE (ACTIONTREEITEM_ID, ACTION_SIGN, ORDER_NO, CHILD_ACTION) VALUES (31, 'ORDER_ACCEPTREQUEST', 1, 'ORDER_FOREACH_ORDERITEM');
INSERT INTO ACTIONTREE (ACTIONTREEITEM_ID, ACTION_SIGN, ORDER_NO, CHILD_ACTION) VALUES (4, 'ORDER_APPROVE', 2, 'ORDER_FOREACH_ORDERTAX');
INSERT INTO ACTIONTREE (ACTIONTREEITEM_ID, ACTION_SIGN, ORDER_NO, CHILD_ACTION) VALUES (5, 'ORDER_APPROVE', 3, 'CLIENT_APPROVE');
INSERT INTO ACTIONTREE (ACTIONTREEITEM_ID, ACTION_SIGN, ORDER_NO, CHILD_ACTION) VALUES (3, 'ORDER_APPROVE', 1, 'ORDER_FOREACH_ORDERITEM');
INSERT INTO ACTIONTREE (ACTIONTREEITEM_ID, ACTION_SIGN, ORDER_NO, CHILD_ACTION) VALUES (22, 'ORDER_DISAPPROVE', 2, 'ORDER_FOREACH_ORDERTAX');
INSERT INTO ACTIONTREE (ACTIONTREEITEM_ID, ACTION_SIGN, ORDER_NO, CHILD_ACTION) VALUES (21, 'ORDER_DISAPPROVE', 1, 'ORDER_FOREACH_ORDERITEM');
INSERT INTO ACTIONTREE (ACTIONTREEITEM_ID, ACTION_SIGN, ORDER_NO, CHILD_ACTION) VALUES (23, 'ORDERITEM_DRAFT', 1, 'ACCOUNT_DEBIT');
INSERT INTO ACTIONTREE (ACTIONTREEITEM_ID, ACTION_SIGN, ORDER_NO, CHILD_ACTION) VALUES (24, 'ORDERTAX_DRAFT', 1, 'ACCOUNT_DEBIT');
INSERT INTO ACTIONTREE (ACTIONTREEITEM_ID, ACTION_SIGN, ORDER_NO, CHILD_ACTION) VALUES (41, 'ORDER_INVOICE', 1, 'INVOICE_CREATE');
INSERT INTO ACTIONTREE (ACTIONTREEITEM_ID, ACTION_SIGN, ORDER_NO, CHILD_ACTION) VALUES (42, 'ORDER_INVOICE', 2, 'ORDER_FOREACH_ORDERITEM');
INSERT INTO ACTIONTREE (ACTIONTREEITEM_ID, ACTION_SIGN, ORDER_NO, CHILD_ACTION) VALUES (43, 'ORDER_INVOICE', 3, 'ORDER_FOREACH_ORDERTAX');
INSERT INTO ACTIONTREE (ACTIONTREEITEM_ID, ACTION_SIGN, ORDER_NO, CHILD_ACTION) VALUES (51, 'PAYMENT_ASSIGN', 1, 'INVOICE_PAID');
INSERT INTO ACTIONTREE (ACTIONTREEITEM_ID, ACTION_SIGN, ORDER_NO, CHILD_ACTION) VALUES (53, 'INVOICE_PAID', 2, 'ORDER_PAID');
INSERT INTO ACTIONTREE (ACTIONTREEITEM_ID, ACTION_SIGN, ORDER_NO, CHILD_ACTION) VALUES (52, 'INVOICE_PAID', 1, 'ACCOUNT_DEBIT');
INSERT INTO ACTIONTREE (ACTIONTREEITEM_ID, ACTION_SIGN, ORDER_NO, CHILD_ACTION) VALUES (8, 'ORDER_APPROVE', 4, 'EVENT_CREATE');

COMMIT WORK;
