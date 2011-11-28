INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('CLIENT_CREATE', 'FIRST_NAME', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('CLIENT_CREATE', 'LAST_NAME', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('INVOICE_CREATE', 'ACCOUNT_ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('MESSAGE_CREATE', 'FILE_NAME', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('MESSAGE_CREATE', 'FILE_DTM', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('MESSAGE_CREATE', 'FILE_SIZE', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('PAYMENT_ASSIGN', 'NEW.STATUS_SIGN', 'V', 'ASSIGNED');
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('MESSAGE_STATUS', 'ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('MESSAGE_BUSY', 'ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('MESSAGE_ERROR', 'ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('PAYMENT_ASSIGN', 'INVOICE_ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('PAYMENT_ASSIGN', 'ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('MESSAGE_SUCCESS', 'ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDERITEM_CREATE', 'ORDER_ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDER_CREATE', 'ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('CLIENT_CREATE', 'MOBILE_PHONE', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDER_FOREACH_TAXRATE', 'ORDER_ID', 'A', 'ID');
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('MAGAZINE_LOADED', 'NEW.STATUS_SIGN', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDER_ACCEPT', 'ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDERITEM_APPROVE', 'NEW.STATUS_SIGN', 'V', 'APPROVED');
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDERTAX_APPROVE', 'NEW.STATUS_SIGN', 'V', 'APPROVED');
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDER_APPROVE', 'NEW.STATUS_SIGN', 'V', 'APPROVED');
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDER_APPROVE', 'ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDERTAX_CREATE', 'ORDER_ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('CLIENT_APPROVE', 'NEW.STATUS_SIGN', 'V', 'APPROVED');
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ACCOUNT_CREDIT', 'SIGN', 'V', '-1');
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ACCOUNT_DEBIT', 'SIGN', 'V', '1');
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ACCOUNT_STORE', 'SIGN', 'V', '0');
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ACCOUNT_STORE', 'AMOUNT_EUR', 'V', '0');
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ACCOUNT_STORE', 'ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ACCOUNT_CREDIT', 'AMOUNT_EUR', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ACCOUNT_DEBIT', 'AMOUNT_EUR', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ACCOUNT_CREDIT', 'ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ACCOUNT_DEBIT', 'ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ACCOUNT_CREDIT', 'REST_EUR', 'W', 'REST_EUR');
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ACCOUNT_CREDIT', 'AMOUNT_EUR', 'W', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ACCOUNT_CREDIT', 'BALANCE_EUR', 'W', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ACCOUNT_DEBIT', 'REST_EUR', 'W', 'REST_EUR');
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ACCOUNT_DEBIT', 'AMOUNT_EUR', 'W', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ACCOUNT_DEBIT', 'BALANCE_EUR', 'W', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('MAGAZINE_LOADED', 'ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDER_ACCEPTREQUEST', 'ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDER_ACCEPTREQUEST', 'NEW.STATUS_SIGN', 'V', 'ACCEPTREQUEST');
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDERITEM_ACCEPTREQUEST', 'NEW.STATUS_SIGN', 'V', 'ACCEPTREQUEST');
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDERITEM_DRAFT', 'ORDER_ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDERITEM_DRAFT', 'NEW.STATUS_SIGN', 'V', 'DRAFT');
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDERTAX_DRAFT', 'NEW.STATUS_SIGN', 'V', 'DRAFT');
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDERTAX_DRAFT', 'ORDER_ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('EVENT_CREATE', 'OBJECT_ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('EVENT_CREATE', 'EVENT_SIGN', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDER_FOREACH_TAXRATE', 'ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDER_ACCEPT', 'NEW.STATUS_SIGN', 'V', 'ACCEPTED');
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDERTAX_CREATE', 'TAXRATE_ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDERTAX_CREATE', 'PRICE_EUR', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDERTAX_CREATE', 'AMOUNT', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDERITEM_ACCEPT', 'NEW.STATUS_SIGN', 'V', 'ACCEPTED');
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDERITEM_ACCEPT', 'ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDERITEM_ACCEPTREQUEST', 'ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDERITEM_BUNDLING', 'NEW.STATUS_SIGN', 'V', 'BUNDLING');
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDERITEM_BUNDLING', 'ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDERITEM_PACKED', 'ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDERITEM_PACKED', 'NEW.STATUS_SIGN', 'V', 'PACKED');
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('INVOICE_CANCEL', 'ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('INVOICE_CANCEL', 'NEW.STATUS_SIGN', 'V', 'CANCELLED');
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('INVOICE_CREATE', 'ORDER_ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('INVOICE_PAID', 'ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('INVOICE_PAID', 'NEW.STATUS_SIGN', 'V', 'PAID');
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('INVOICE_PRINT', 'ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('INVOICE_PRINT', 'NEW.STATUS_SIGN', 'V', 'PRINTED');
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDERITEM_INVOICE', 'ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDERITEM_INVOICE', 'INVOICE_ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDERTAX_INVOICE', 'ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDERTAX_INVOICE', 'INVOICE_ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDER_INVOICE', 'AMOUNT_EUR', 'X', 'UNINVOICED');
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDER_INVOICE', 'ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('INVOICE_PRINT', 'FILENAME', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('MESSAGE_BUSY', 'NEW.STATUS_SIGN', 'V', 'BUSY');
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('MESSAGE_ERROR', 'NEW.STATUS_SIGN', 'V', 'ERROR');
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('MESSAGE_STATUS', 'NEW.STATUS_SIGN', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('MESSAGE_SUCCESS', 'NEW.STATUS_SIGN', 'V', 'SUCCESS');
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDERITEM_SMSREJECTSEND', 'ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDERITEM_SMSREJECTSEND', 'NEW.STATE_SIGN', 'V', 'SMSREJECTSENDED');
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDERITEM_SMSREJECTSEND', 'STATE_ID', 'X', 'GETSTATEID');
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDERITEM_CANCELREQUEST', 'ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDERITEM_CANCELREQUEST', 'NEW.STATUS_SIGN', 'V', 'CANCELREQUEST');
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDERITEM_REJECT', 'ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDERITEM_REJECT', 'NEW.STATUS_SIGN', 'V', 'REJECTED');
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDER_PAID', 'ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDER_PAID', 'NEW.STATUS_SIGN', 'V', 'PAID');
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDER_PACKED', 'ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDER_PACKED', 'NEW.STATUS_SIGN', 'V', 'PACKED');
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDER_DELIVERING', 'NEW.STATUS_SIGN', 'V', 'DELIVERING');
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDER_DELIVERING', 'ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDERITEM_CANCEL', 'ID', 'I', NULL);
INSERT INTO ACTIONCODE_PARAMS (ACTION_SIGN, PARAM_NAME, PARAM_KIND, PARAM_VALUE) VALUES ('ORDERITEM_CANCEL', 'NEW.STATUS_SIGN', 'V', 'CANCELLED');

COMMIT WORK;
