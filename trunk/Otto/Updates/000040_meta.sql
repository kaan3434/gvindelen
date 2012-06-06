/* Server version: WI-V6.3.1.26351 Firebird 2.5 
   SQLDialect: 3. ODS: 11.2. Forced writes: On. Sweep inteval: 20000.
   Page size: 4096. Cache pages: 2048 (8192 Kb). Read-only: False. */
SET CLIENTLIB 'fbclient.dll';
SET NAMES CYRL;

SET SQL DIALECT 3;

SET AUTODDL ON;

ALTER TABLE PAYMENTS DROP CONSTRAINT FK_PAYMENTS_MESSAGE;

ALTER TABLE ACCOPERS DROP CONSTRAINT FK_ACCOPERS_ORDERMONEY;

CREATE DOMAIN ID_ACCREST AS INTEGER;

CREATE DOMAIN KURS_EXCH AS INTEGER;

CREATE DOMAIN SIGN_DIRECTION AS CHAR CHARACTER SET ASCII;

/* Create Table... */
CREATE TABLE ACCRESTS(ACCREST_ID ID_ACCREST NOT NULL,
ACCOUNT_ID ID_ACCOUNT NOT NULL,
BYR2EUR KURS_EXCH NOT NULL,
REST_EUR MONEY_EUR NOT NULL,
REST_BYR MONEY_BYR,
REST_DTM DTM_STATUS);


CREATE TABLE MONEYBACK_ATTRS(OBJECT_ID ID_ACTION NOT NULL,
ATTR_ID ID_ATTR NOT NULL,
ATTR_VALUE VALUE_ATTR);


CREATE TABLE MONEYBACKS(MONEYBACK_ID ID_PAYMENT NOT NULL,
ACCOUNT_ID ID_ACCOUNT,
AMOUNT_BYR MONEY_BYR NOT NULL,
STATUS_ID ID_STATUS NOT NULL,
STATUS_DTM DTM_STATUS,
ORDER_ID ID_ORDER,
KIND SIGN_OBJECT);



ALTER TABLE ACCOPERS ADD ACCREST_ID ID_ACCREST;

ALTER TABLE ORDERITEMS ADD RETURN_REESTR_ID ID_MESSAGE;

/* Create Procedure... */
SET TERM ^ ;

CREATE PROCEDURE ACT_ACCOUNT_PAYMENTOUT(I_PARAM_ID TYPE OF ID_PARAM NOT NULL,
I_OBJECT_ID TYPE OF ID_OBJECT NOT NULL,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ACCOUNT')
 AS
 BEGIN EXIT; END
^

CREATE PROCEDURE ACT_MONEYBACK_STORE(I_PARAM_ID TYPE OF ID_PARAM NOT NULL,
I_OBJECT_ID TYPE OF ID_OBJECT,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'MONEYBACK')
 AS
 BEGIN EXIT; END
^

CREATE PROCEDURE MONEYBACK_READ(I_OBJECT_ID TYPE OF ID_OBJECT)
 RETURNS(O_PARAM_NAME TYPE OF SIGN_OBJECT,
O_PARAM_VALUE TYPE OF VALUE_ATTR)
 AS
 BEGIN SUSPEND; END
^

CREATE PROCEDURE MONEYBACK_X_PURPOSE(I_DEST_PARAM_ID TYPE OF ID_PARAM,
I_PARAM_NAME TYPE OF SIGN_ATTR,
I_SRC_PARAM_ID TYPE OF ID_PARAM)
 AS
 BEGIN EXIT; END
^

CREATE PROCEDURE PARAM_MERGE(I_DEST_PARAM_ID TYPE OF ID_PARAM NOT NULL,
I_SRC_PARAM_ID TYPE OF ID_PARAM NOT NULL,
I_PREFIX TYPE OF SIGN_OBJECT)
 AS
 BEGIN EXIT; END
^

CREATE PROCEDURE TAX_ENTERED_SUM(I_TAXRATE_ID TYPE OF ID_TAX,
I_PARAM_ID TYPE OF ID_PARAM)
 RETURNS(O_COST_EUR TYPE OF MONEY_EUR)
 AS
 BEGIN SUSPEND; END
^


/* Create Views... */
/* Create view: V_ACCRESTS */
SET TERM ; ^

CREATE VIEW V_ACCRESTS(
ACCOUNT_ID,
REST_BYR,
REST_EUR,
REST_DTM)
 AS 
select account_id, sum(rest_byr) rest_byr, sum(rest_eur) rest_eur, max(rest_dtm) rest_dtm from accrests group by account_id
;

/* Create view: V_CLIENT_BANKINFO */
CREATE VIEW V_CLIENT_BANKINFO(
CLIENT_ID,
BANK_ACCOUNT_NUM,
BANK_NAME,
BANK_CLIENT_ACCOUNT,
BANK_MFO,
BANK_UNP)
 AS 
select c.client_id
  , cast(ca1.attr_value as varchar(13)) bank_account_num
  , cast(ca2.attr_value as varchar(100)) bank_name
  , cast(ca3.attr_value as varchar(100)) bank_client_account
  , cast(ca4.attr_value as varchar(15)) bank_mfo
  , cast(ca5.attr_value as varchar(15)) bank_unp
from clients c
left join v_client_attrs ca1 on (ca1.object_id = c.client_id and ca1.attr_sign = 'BANK_ACCOUNT_NUM')
left join v_client_attrs ca2 on (ca2.object_id = c.client_id and ca2.attr_sign = 'BANK_NAME')
left join v_client_attrs ca3 on (ca3.object_id = c.client_id and ca3.attr_sign = 'BANK_CLIENT_ACCOUNT')
left join v_client_attrs ca4 on (ca4.object_id = c.client_id and ca4.attr_sign = 'BANK_MFO')
left join v_client_attrs ca5 on (ca5.object_id = c.client_id and ca5.attr_sign = 'BANK_UNP')
;

/* Create view: V_MONEYBACK_ATTRS */
CREATE VIEW V_MONEYBACK_ATTRS(
OBJECT_ID,
ATTR_SIGN,
ATTR_VALUE,
ATTR_NAME)
 AS 
select mba.object_id, a.attr_sign, mba.attr_value, a.attr_name
from moneyback_attrs mba
inner join attrs a on (a.attr_id = mba.attr_id)
;

/* Create view: V_MONEYBACK_BANK */
CREATE VIEW V_MONEYBACK_BANK(
MONEYBACK_ID,
CLIENT_ID,
CLIENT_FIO,
AMOUNT_BYR,
PURPOSE)
 AS 
select mb.moneyback_id
  , c.client_id
  , cf.client_fio
  , mb.amount_byr
  , mba.attr_value purpose
from moneybacks mb
left join v_moneyback_attrs mba on (mba.object_id = mb.moneyback_id and mba.attr_sign = 'PURPOSE')
inner join clients c on (c.account_id = mb.account_id)
inner join v_clients_fio cf on (cf.client_id = c.client_id)
inner join statuses s on (s.status_id = mb.status_id)
where mb.kind = 'BANK'
  and s.status_sign = 'NEW'
;

/* Create view: V_MONEYBACK_BELPOST */
CREATE VIEW V_MONEYBACK_BELPOST(
FIO_TEXT,
PLACE_TEXT,
ADRESS_TEXT,
POSTINDEX,
PAYED_BYR,
POST_FEE_BYR,
NDS_BYR,
AMOUNT_BYR,
NDS_FEE,
BELPOST_FEE,
PURPOSE)
 AS 
select ca.FIO_Text, ca.Place_Text, ca.Adress_Text, a.PostIndex
  , round(mb.amount_byr/(1+belpost.fee),-1) payed_byr
  , round(mb.amount_byr*belpost.fee/(1+belpost.fee)) post_fee_byr
  , round(round(mb.amount_byr*belpost.fee/(1+belpost.fee))*nds.fee) nds_byr
  , mb.amount_byr
  , nds.fee
  , belpost.fee
  , mba.attr_value purpose
from moneybacks mb,
(select cast(o_value as numeric(10,4))/100 fee from setting_get('BELPOST_FEE')) belpost,
(select cast(o_value as numeric(10,2))/100 fee from setting_get('NDS_FEE')) nds
left join v_moneyback_attrs mba on (mba.object_id = mb.moneyback_id and mba.attr_sign = 'PURPOSE')
inner join clients c on (c.account_id = mb.account_id)
inner join v_clientadress ca on (ca.client_id = c.client_id)
inner join statuses s on (s.status_id = mb.status_id)
inner join adresses a on (a.adress_id = ca.adress_id)                                                                                                                              
where mb.kind = 'BELPOST'
  and s.status_sign = 'NEW'
;

/* Create view: V_PRODUCT_ATTRS */
CREATE VIEW V_PRODUCT_ATTRS(
OBJECT_ID,
ATTR_SIGN,
ATTR_VALUE,
ATTR_NAME)
 AS 
select pa.object_id, a.attr_sign, pa.attr_value, a.attr_name
from product_attrs pa
inner join attrs a on (a.attr_id = pa.attr_id)
;

/* Create view: V_ORDERITEMS_RETURNING */
CREATE VIEW V_ORDERITEMS_RETURNING(
ORDERITEM_ID,
ORDER_ID,
ORDER_CODE,
PARTNER_NUMBER,
CLIENT_ID,
FIO_TEXT,
ADRESS_TEXT,
PLACE_TEXT,
AUFTRAG_ID,
ORDERITEM_INDEX,
ARTICLE_CODE,
DIMENSION,
AMOUNT,
NAME_RUS,
PRICE_EUR,
WEIGHT,
NRRETCODE,
NREGWG,
PACKLIST_NO,
BEPOST_BAR_CODE,
BAR_CODE)
 AS 
select oi.orderitem_id
  , o.order_id
  , o.order_code
  , cast(pa.attr_value as numeric(10)) partner_number
  , ca.client_id
  , ca.fio_text
  , ca.adress_text
  , ca.place_text
  , cast(oia1.attr_value as varchar(10)) auftrag_id
  , oi.orderitem_index
  , oi.article_code
  , oi.dimension
  , 1 amount
  , cast(trim(coalesce(oia2.attr_value,'')||' '||coalesce(oia3.attr_value, '')) as varchar(100)) name_rus
  , price_eur
  , cast(oia4.attr_value as numeric(10, 3))/1000 weight
  , cast(oia5.attr_value as varchar(50)) nrretcode
  , cast(oia6.attr_value as varchar(50)) nregwg
  , cast(oa1.attr_value as varchar(10)) packlist_no
  , cast(oa2.attr_value as varchar(20)) bepost_bar_code
  , o.bar_code
from OrderItems oi
inner join statuses sr on (sr.status_id = oi.status_id and sr.status_sign = 'RETURNING')
inner join orders o on (o.order_id = oi.order_id)
inner join v_product_attrs pa on (pa.object_id = o.product_id and pa.attr_sign = 'PARTNER_NUMBER')
inner join v_clientadress ca on (ca.client_id = o.client_id)
left join v_orderitem_attrs oia1 on (oia1.object_id = oi.orderitem_id and oia1.attr_sign = 'AUFTRAG_ID')
left join v_orderitem_attrs oia2 on (oia2.object_id = oi.orderitem_id and oia2.attr_sign = 'NAME_RUS')
left join v_orderitem_attrs oia3 on (oia3.object_id = oi.orderitem_id and oia3.attr_sign = 'KIND_RUS')
left join v_orderitem_attrs oia4 on (oia4.object_id = oi.orderitem_id and oia4.attr_sign = 'WEIGHT')
left join v_orderitem_attrs oia5 on (oia5.object_id = oi.orderitem_id and oia5.attr_sign = 'NRRETCODE')
left join v_orderitem_attrs oia6 on (oia6.object_id = oi.orderitem_id and oia6.attr_sign = 'NREGWG')
left join v_order_attrs oa1 on (oa1.object_id = o.order_id and oa1.attr_sign = 'PACKLIST_NO')
left join v_order_attrs oa2 on (oa2.object_id = o.order_id and oa2.attr_sign = 'BELPOST_BAR_CODE')
where oi.return_reestr_id is null
;


/* Create generator... */
CREATE GENERATOR SEQ_ACCREST_ID;

CREATE GENERATOR SEQ_MONEYBACK_ID;


/* Create Primary Key... */
ALTER TABLE ACCRESTS ADD CONSTRAINT PK_ACCRESTS PRIMARY KEY (ACCREST_ID);

ALTER TABLE MONEYBACK_ATTRS ADD CONSTRAINT PK_MONEYBACK_ATTRS_1 PRIMARY KEY (OBJECT_ID, ATTR_ID);

ALTER TABLE MONEYBACKS ADD CONSTRAINT PK_MONEYBACKS PRIMARY KEY (MONEYBACK_ID);

/* Create Foreign Key... */
RECONNECT;

ALTER TABLE ACCRESTS ADD CONSTRAINT FK_ACCRESTS_ACCOUNT FOREIGN KEY (ACCOUNT_ID) REFERENCES ACCOUNTS (ACCOUNT_ID) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE MONEYBACK_ATTRS ADD CONSTRAINT FK_MONEYBACK_ATTRS_ATTR FOREIGN KEY (ATTR_ID) REFERENCES ATTRS (ATTR_ID) ON UPDATE CASCADE;

ALTER TABLE MONEYBACK_ATTRS ADD CONSTRAINT FK_MONEYBACK_ATTRS_BONEYBACK FOREIGN KEY (OBJECT_ID) REFERENCES MONEYBACKS (MONEYBACK_ID) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE MONEYBACKS ADD CONSTRAINT FK_MONEYBACKS_ACCOUNT FOREIGN KEY (ACCOUNT_ID) REFERENCES ACCOUNTS (ACCOUNT_ID) ON UPDATE CASCADE;

ALTER TABLE MONEYBACKS ADD CONSTRAINT FK_MONEYBACKS_ORDER FOREIGN KEY (ORDER_ID) REFERENCES ORDERS (ORDER_ID) ON UPDATE CASCADE;

ALTER TABLE MONEYBACKS ADD CONSTRAINT FK_MONEYBACKS_STATUS FOREIGN KEY (STATUS_ID) REFERENCES STATUSES (STATUS_ID) ON UPDATE CASCADE;

ALTER TABLE ORDERITEMS ADD CONSTRAINT FK_ORDERITEMS_RETURN FOREIGN KEY (RETURN_REESTR_ID) REFERENCES MESSAGES (MESSAGE_ID) ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE PAYMENTS ADD CONSTRAINT FK_PAYMENTS_MESSAGE FOREIGN KEY (MESSAGE_ID) REFERENCES MESSAGES (MESSAGE_ID) ON UPDATE CASCADE ON DELETE SET NULL;

/*  Empty ACTION_RUN for ACT_PAYMENT_STORE(param list change)  */
SET TERM ^ ;

ALTER PROCEDURE ACTION_RUN(I_OBJECT_SIGN /* TYPE OF SIGN_OBJECT */ VARCHAR(30),
I_ACTION_SIGN /* TYPE OF SIGN_ACTION */ VARCHAR(30),
I_PARAM_ID /* TYPE OF ID_PARAM */ BIGINT,
I_OBJECT_ID /* TYPE OF ID_OBJECT */ INTEGER)
 RETURNS(O_ACTION_ID /* TYPE OF ID_ACTION */ INTEGER)
 AS
 BEGIN SUSPEND; END
^

/* Alter empty procedure ACT_ACCOUNT_CREDIT with new param-list */
ALTER PROCEDURE ACT_ACCOUNT_CREDIT(I_PARAM_ID TYPE OF ID_PARAM NOT NULL,
I_OBJECT_ID TYPE OF ID_OBJECT NOT NULL,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ACCOUNT')
 AS
 BEGIN EXIT; END
^

/* Alter empty procedure ACT_PAYMENT_STORE with new param-list */
ALTER PROCEDURE ACT_PAYMENT_STORE(I_PARAM_ID TYPE OF ID_PARAM NOT NULL,
I_OBJECT_ID TYPE OF ID_OBJECT NOT NULL,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'PAYMENT')
 AS
 BEGIN EXIT; END
^

/* Alter Procedure... */
/* Alter (ACT_ACCOUNT_CREDIT) */
ALTER PROCEDURE ACT_ACCOUNT_CREDIT(I_PARAM_ID TYPE OF ID_PARAM NOT NULL,
I_OBJECT_ID TYPE OF ID_OBJECT NOT NULL,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ACCOUNT')
 AS
declare variable V_AMOUNT_EUR type of MONEY_EUR;
declare variable V_BYR2EUR type of MONEY_BYR;
declare variable V_ORDER_ID type of ID_ORDER;
declare variable V_NOTES type of VALUE_ATTR;
declare variable V_AMOUNT_BYR type of MONEY_BYR;
begin
  update paramheads set object_id = :i_object_id where param_id = :i_param_id;

  execute procedure param_set(:i_param_id, 'ID', :i_object_id);

  select o_value from param_get(:i_param_id, 'AMOUNT_BYR') into :v_amount_byr;
  select o_value from param_get(:i_param_id, 'AMOUNT_EUR') into :v_amount_eur;
  select o_value from param_get(:i_param_id, 'BYR2EUR') into :v_byr2eur;
  select o_value from param_get(:i_param_id, 'NOTES') into :v_notes;

  select o_pattern from param_fillpattern(:i_param_id, :v_notes) into :v_notes;

  insert into accopers (account_id, amount_eur, amount_byr, byr2eur, notes)
    values(:i_object_id, -:v_amount_eur, -:v_amount_byr, :v_byr2eur, :v_notes);
end
^

/* Alter (ACT_ACCOUNT_DEBITORDER) */
ALTER PROCEDURE ACT_ACCOUNT_DEBITORDER(I_PARAM_ID TYPE OF ID_PARAM NOT NULL,
I_OBJECT_ID TYPE OF ID_OBJECT NOT NULL,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ACCOUNT')
 AS
declare variable V_AMOUNT_EUR type of MONEY_EUR;
declare variable V_ORDER_ID type of ID_ORDER;
declare variable V_NOTES type of VALUE_ATTR;
declare variable V_ACC_AMOUNT_EUR type of MONEY_EUR;
declare variable V_ACC_BYR2EUR type of MONEY_BYR;
declare variable V_ACC_AMOUNT_BYR type of MONEY_BYR;
declare variable V_DELTA_EUR type of MONEY_EUR;
declare variable V_AMOUNT_BYR type of MONEY_BYR;
declare variable V_DELTA_BYR type of MONEY_BYR;
begin
  update paramheads set object_id = :i_object_id where param_id = :i_param_id;

  execute procedure param_set(:i_param_id, 'ID', :i_object_id);

  select o_value from param_get(:i_param_id, 'ORDER_ID') into :v_order_id;

  select -os.cost_eur
    from v_order_summary os
    where os.order_id = :v_order_id
    into :v_amount_eur;
  v_amount_byr = 0;

  -- esli pereplata po zayavke
  if (v_amount_eur > 0) then
  begin
    for select om.byr2eur, sum(om.amount_eur), sum(om.amount_byr)
          from ordermoneys om
          where om.order_id = :v_order_id
          group by om.byr2eur
          having sum(om.amount_eur) > 0
          order by om.byr2eur
          into :v_acc_byr2eur, :v_acc_amount_eur, :v_acc_amount_byr do
    begin
      if (v_amount_eur < v_acc_amount_eur) then
      begin
        v_delta_eur = v_amount_eur;
        v_delta_byr = round(v_amount_eur * :v_acc_byr2eur, -1);
      end
      else
      begin
        v_delta_eur = v_acc_amount_eur;
        v_delta_byr = v_acc_amount_byr;
      end
      v_amount_eur = v_amount_eur - v_delta_eur;
      v_amount_byr = v_amount_byr + v_delta_byr;
      select o_value from param_get(:i_param_id, 'NOTES') into :v_notes;
      select o_pattern from param_fillpattern(:i_param_id, :v_notes) into :v_notes;

      insert into accopers (account_id, amount_eur, byr2eur, order_id, notes)
        values(:i_object_id, :v_delta_eur, :v_acc_byr2eur, :v_order_id, :v_notes);
      insert into ordermoneys (account_id, amount_eur, byr2eur, order_id)
        values(:i_object_id, -:v_delta_eur, :v_acc_byr2eur, :v_order_id);
    end
  end
  else
  -- esli po zayavke dolg
  if (v_amount_eur < 0) then
  begin
    for select om.byr2eur, sum(om.amount_eur), sum(om.amount_byr)
          from ordermoneys om
          where om.order_id = :v_order_id
          group by om.byr2eur
          having sum(om.amount_eur) > 0
          order by om.byr2eur desc
          into :v_acc_byr2eur, :v_acc_amount_eur, :v_acc_amount_byr do
    begin
      if (v_amount_eur < v_acc_amount_eur) then
      begin
        v_delta_eur = v_amount_eur;
        v_delta_byr = round(v_amount_eur * :v_acc_byr2eur, -1);
      end
      else
      begin
        v_delta_eur = v_acc_amount_eur;
        v_delta_byr = v_acc_amount_byr;
      end
      v_amount_eur = v_amount_eur - v_delta_eur;
      v_amount_byr = v_amount_byr + v_delta_byr;

      select o_value from param_get(:i_param_id, 'NOTES') into :v_notes;
      select o_pattern from param_fillpattern(:i_param_id, :v_notes) into :v_notes;

      insert into accopers (account_id, amount_eur, byr2eur, order_id, notes)
        values(:i_object_id, :v_delta_eur, :v_acc_byr2eur, :v_order_id, :v_notes);
      insert into ordermoneys (account_id, amount_eur, byr2eur, order_id)
        values(:i_object_id, -:v_delta_eur, :v_acc_byr2eur, :v_order_id);
    end
  end
  execute procedure param_set(:i_param_id, 'AMOUNT_BYR', :v_amount_byr);
end
^

/* Alter (ACT_ACCOUNT_PAYMENTIN) */
ALTER PROCEDURE ACT_ACCOUNT_PAYMENTIN(I_PARAM_ID TYPE OF ID_PARAM NOT NULL,
I_OBJECT_ID TYPE OF ID_OBJECT NOT NULL,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ACCOUNT')
 AS
declare variable V_AMOUNT_EUR type of MONEY_EUR;
declare variable V_BYR2EUR type of MONEY_BYR;
declare variable V_ORDER_ID type of ID_ORDER;
declare variable V_NOTES type of VALUE_ATTR;
declare variable V_AMOUNT_BYR type of MONEY_BYR;
declare variable V_ORDER_CODE type of CODE_ORDER;
begin
  update paramheads set object_id = :i_object_id where param_id = :i_param_id;

  execute procedure param_set(:i_param_id, 'ID', :i_object_id);

  select o_value from param_get(:i_param_id, 'AMOUNT_BYR') into :v_amount_byr;
  select o_value from param_get(:i_param_id, 'ORDER_ID') into :v_order_id;
  select o_value from param_get(:i_param_id, 'NOTES') into :v_notes;

  select o.byr2eur, o.order_code
    from orders o
    where o.order_id = :v_order_id
    into :v_byr2eur, :v_order_code;

  v_amount_eur = round(cast(v_amount_byr as numeric(18,3)) / v_byr2eur, 2);

  execute procedure param_set(:i_param_id, 'ORDER_CODE', :v_order_code);
  execute procedure param_set(:i_param_id, 'BYR2EUR', :v_byr2eur);
  execute procedure param_set(:i_param_id, 'AMOUNT_EUR', :v_amount_eur);

  select o_pattern from param_fillpattern(:i_param_id, :v_notes) into :v_notes;

  insert into accopers (account_id, amount_eur, byr2eur, order_id, notes, amount_byr)
    values(:i_object_id, :v_amount_eur, :v_byr2eur, :v_order_id, :v_notes, :v_amount_byr);
end
^

/* Alter (ACT_PAYMENT_STORE) */
ALTER PROCEDURE ACT_PAYMENT_STORE(I_PARAM_ID TYPE OF ID_PARAM NOT NULL,
I_OBJECT_ID TYPE OF ID_OBJECT NOT NULL,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'PAYMENT')
 AS
declare variable V_NOW_STATUS_ID type of ID_STATUS;
declare variable V_NEW_STATUS_ID type of ID_STATUS;
declare variable V_UPDATEABLE type of VALUE_BOOLEAN;
declare variable V_AMOUNT_BYR type of MONEY_BYR;
declare variable V_MESSAGE_ID type of ID_MESSAGE;
declare variable V_CREATE_DT type of DT_INVOICE;
begin
  if (coalesce(i_object_id, 0) = 0) then i_object_id = gen_id(seq_payment_id, 1);

  update paramheads set object_id = :i_object_id where param_id = :i_param_id;

  execute procedure param_set(:i_param_id, 'ID', :i_object_id);

  select status_id from payments where payment_id = :i_object_id into :v_now_status_id;

  if (:v_now_status_id is null) then
  begin
    select o_value from param_get(:i_param_id, 'STATUS_ID') into :v_new_status_id;
    if (:v_new_status_id is null) then
       select s.status_id
         from param_get(:i_param_id, 'NEW.STATUS_SIGN') p
           inner join statuses s on (s.object_sign = :i_object_sign and s.status_sign = p.o_value)
       into :v_new_status_id;
    select o_value from param_get(:i_param_id, 'MESSAGE_ID') into :v_message_id;
    select o_value from param_get(:i_param_id, 'AMOUNT_BYR') into :v_amount_byr;
    select o_value from param_get(:i_param_id, 'CREATE_DT') into :v_create_dt;

    insert into payments(payment_id, message_id, create_dt, amount_byr, status_id)
      values(:i_object_id, :v_message_id, :v_create_dt, :v_amount_byr, :v_new_status_id)
      returning status_id
      into :v_new_status_id;
    v_updateable = 1;
  end
  else
  begin
    select o_updateable, o_new_status_id
      from object_updateable(:i_param_id, :v_now_status_id, :i_object_sign)
      into :v_updateable, :v_new_status_id;
  end
  if (v_updateable = 1) then
  begin
    execute procedure param_set(:i_param_id, 'STATUS_ID', :v_new_status_id);
    execute procedure object_put(:i_param_id);
  end
end
^

/* empty dependent procedure body */
/* Clear: ACTION_REEXECUTE for: ACTION_EXECUTE */
ALTER PROCEDURE ACTION_REEXECUTE(I_LOG_ID /* TYPE OF ID_LOG */ BIGINT)
 AS
 BEGIN EXIT; END
^

/* empty dependent procedure body */
/* Clear: ACTION_RERUN for: ACTION_EXECUTE */
ALTER PROCEDURE ACTION_RERUN(I_LOG_ID /* TYPE OF ID_LOG */ BIGINT)
 AS
 BEGIN EXIT; END
^

/* empty dependent procedure body */
/* Clear: ACTION_RERUN_ACTION for: ACTION_EXECUTE */
ALTER PROCEDURE ACTION_RERUN_ACTION(I_LOG_ID /* TYPE OF ID_LOG */ BIGINT)
 AS
 BEGIN EXIT; END
^

/* Alter (ACTION_EXECUTE) */
ALTER PROCEDURE ACTION_EXECUTE(I_OBJECT_SIGN TYPE OF SIGN_OBJECT,
I_PARAMS TYPE OF VALUE_BLOB,
I_ACTION_SIGN TYPE OF SIGN_ACTION,
I_OBJECT_ID TYPE OF ID_OBJECT)
 RETURNS(O_ACTION_ID TYPE OF ID_ACTION)
 AS
declare variable V_NEW_STATUS_SIGN type of SIGN_ATTR;
declare variable V_PARAM_ID type of ID_PARAM;
declare variable V_ACTION_ID type of ID_ACTION;
declare variable V_LOG_ID type of ID_LOG;
declare variable V_NOW_STATUS_ID type of ID_STATUS;
declare variable V_NOW_STATUS_SIGN type of SIGN_OBJECT;
begin
  select o_param_id
    from param_create(:i_object_sign)
    into :v_param_id;

  execute procedure param_unparse(:v_param_id, :i_params);

--  select o_log_id
--    from log_create(:i_object_sign, :v_param_id, null, null, coalesce(:i_object_id, 0))
--    into :v_log_id;

  i_object_id = nullif(i_object_id, 0);
  if (:i_object_id is not null) then
    execute procedure param_set(:v_param_id, 'ID', :i_object_id);
  else
    select o_value from param_get(:v_param_id, 'ID') into :i_object_id;

  select o_value from param_get(:v_param_id, 'NEW.STATUS_SIGN') into :v_new_status_sign;

  if (i_action_sign is null) then
    select o_action_sign
      from action_detect(:i_object_sign, :i_object_id, :v_new_status_sign)
      into :i_action_sign;

  if (i_action_sign is null) then
    i_action_sign= :i_object_sign||'_STORE';

  select o_action_id
    from action_run(:i_object_sign, :i_action_sign, :v_param_id, :i_object_id)
    into :o_action_id;

  delete from paramheads ph
    where ph.param_id = :v_param_id;

  suspend;
end
^

/* Alter (ACTION_REEXECUTE) */
ALTER PROCEDURE ACTION_REEXECUTE(I_LOG_ID TYPE OF ID_LOG)
 AS
declare variable V_PARAMS type of VALUE_BLOB;
declare variable V_OBJECT_SIGN type of SIGN_OBJECT;
declare variable V_ACTION_SIGN type of SIGN_ACTION;
declare variable V_ACTION_ID type of ID_ACTION;
begin
  select l.action_sign, l.params_in
    from logs l
    where l.log_id = :i_log_id 
    into :v_object_sign, :v_params;

  select o_action_id from action_execute(:v_object_sign, :v_params, null, null)
    into :v_action_id;

end
^

/* Alter (ACTION_RERUN) */
ALTER PROCEDURE ACTION_RERUN(I_LOG_ID TYPE OF ID_LOG)
 AS
declare variable V_PARAMS type of VALUE_BLOB;
declare variable V_OBJECT_SIGN type of SIGN_OBJECT;
declare variable V_ACTION_SIGN type of SIGN_ACTION;
declare variable V_ACTION_ID type of ID_ACTION;
begin
  select l.action_sign, l.params_in, ac.object_sign
    from logs l
      inner join actioncodes ac on (ac.action_sign = l.action_sign)
    where l.log_id = :i_log_id 
    into :v_action_sign, :v_params, :v_object_sign;

  if (v_object_sign is null) then
    select l.action_sign, l.params_in
      from logs l
      where l.log_id = :i_log_id
      into :v_object_sign, :v_params;

  select o_action_id from action_execute(:v_object_sign, :v_params, null, null)
    into :v_action_id;

end
^

/* Alter (ACTION_RERUN_ACTION) */
ALTER PROCEDURE ACTION_RERUN_ACTION(I_LOG_ID TYPE OF ID_LOG)
 AS
declare variable V_PARAMS type of VALUE_BLOB;
declare variable V_OBJECT_SIGN type of SIGN_OBJECT;
declare variable V_ACTION_SIGN type of SIGN_ACTION;
declare variable V_ACTION_ID type of ID_ACTION;
begin
  select l.action_sign, l.params_in, ac.object_sign
    from logs l
      inner join actioncodes ac on (ac.action_sign = l.action_sign)
    where l.log_id = :i_log_id 
    into :v_action_sign, :v_params, :v_object_sign;

  if (v_object_sign is null) then
    select l.action_sign, l.params_in
      from logs l
      where l.log_id = :i_log_id
      into :v_object_sign, :v_params;

  select o_action_id from action_execute(:v_object_sign, :v_params, :v_action_sign, null)
    into :v_action_id;

end
^

/* empty dependent procedure body */
/* Clear: ACT_ORDER_DEBIT for: ACTION_RUN */
ALTER PROCEDURE ACT_ORDER_DEBIT(I_PARAM_ID /* TYPE OF ID_PARAM */ BIGINT,
I_OBJECT_ID /* TYPE OF ID_OBJECT */ INTEGER,
I_OBJECT_SIGN /* TYPE OF SIGN_OBJECT */ VARCHAR(30) = 'ORDERITEM')
 AS
 BEGIN EXIT; END
^

/* empty dependent procedure body */
/* Clear: ACT_ORDER_FOREACH_ORDERITEM for: ACTION_RUN */
ALTER PROCEDURE ACT_ORDER_FOREACH_ORDERITEM(I_PARAM_ID /* TYPE OF ID_PARAM */ BIGINT,
I_OBJECT_ID /* TYPE OF ID_OBJECT */ INTEGER,
I_OBJECT_SIGN /* TYPE OF SIGN_OBJECT */ VARCHAR(30) = 'ORDERITEM')
 AS
 BEGIN EXIT; END
^

/* empty dependent procedure body */
/* Clear: ACT_ORDER_FOREACH_ORDERTAX for: ACTION_RUN */
ALTER PROCEDURE ACT_ORDER_FOREACH_ORDERTAX(I_PARAM_ID /* TYPE OF ID_PARAM */ BIGINT,
I_OBJECT_ID /* TYPE OF ID_OBJECT */ INTEGER,
I_OBJECT_SIGN /* TYPE OF SIGN_OBJECT */ VARCHAR(30) = 'ORDERTAX')
 AS
 BEGIN EXIT; END
^

/* empty dependent procedure body */
/* Clear: ACT_ORDER_FOREACH_TAXRATE for: ACTION_RUN */
ALTER PROCEDURE ACT_ORDER_FOREACH_TAXRATE(I_PARAM_ID /* TYPE OF ID_PARAM */ BIGINT,
I_OBJECT_ID /* TYPE OF ID_OBJECT */ INTEGER,
I_OBJECT_SIGN /* TYPE OF SIGN_OBJECT */ VARCHAR(30) = 'ORDERTAX')
 AS
 BEGIN EXIT; END
^

/* empty dependent procedure body */
/* Clear: ACTION_EXECUTE for: ACTION_RUN */
ALTER PROCEDURE ACTION_EXECUTE(I_OBJECT_SIGN /* TYPE OF SIGN_OBJECT */ VARCHAR(30),
I_PARAMS /* TYPE OF VALUE_BLOB */ BLOB SUB_TYPE 1 SEGMENT SIZE 100,
I_ACTION_SIGN /* TYPE OF SIGN_ACTION */ VARCHAR(30),
I_OBJECT_ID /* TYPE OF ID_OBJECT */ INTEGER)
 RETURNS(O_ACTION_ID /* TYPE OF ID_ACTION */ INTEGER)
 AS
 BEGIN SUSPEND; END
^

/* empty dependent procedure body */
/* Clear: MESSAGE_CREATE for: ACTION_RUN */
ALTER PROCEDURE MESSAGE_CREATE(I_FILE_NAME /* TYPE OF NAME_FILE */ VARCHAR(100),
I_FILE_SIZE /* TYPE OF SIZE_FILE */ INTEGER,
I_FILE_DTM /* TYPE OF DTM_FILE */ TIMESTAMP)
 RETURNS(O_MESSAGE_ID /* TYPE OF ID_MESSAGE */ INTEGER)
 AS
 BEGIN SUSPEND; END
^

/* empty dependent procedure body */
/* Clear: ORDER_ANUL for: ACTION_RUN */
ALTER PROCEDURE ORDER_ANUL(I_ORDER_ID /* TYPE OF ID_ORDER */ INTEGER)
 RETURNS(O_NEW_STATUS_SIGN /* TYPE OF SIGN_OBJECT */ VARCHAR(30))
 AS
 BEGIN SUSPEND; END
^

/* Alter (ACTION_RUN) */
ALTER PROCEDURE ACTION_RUN(I_OBJECT_SIGN TYPE OF SIGN_OBJECT,
I_ACTION_SIGN TYPE OF SIGN_ACTION,
I_PARAM_ID TYPE OF ID_PARAM,
I_OBJECT_ID TYPE OF ID_OBJECT)
 RETURNS(O_ACTION_ID TYPE OF ID_ACTION)
 AS
declare variable V_PARAM_ID type of ID_PARAM;
declare variable V_PARAM_NAME type of SIGN_OBJECT;
declare variable V_PARAM_KIND type of KIND_PARAM;
declare variable V_PARAM_VALUE type of VALUE_ATTR;
declare variable V_PARAM_VALUE_2 type of VALUE_ATTR;
declare variable V_ACTIONTREEITEM_ID type of ID_ACTIONTREEITEM;
declare variable V_CHILD_OBJECT_SIGN type of SIGN_OBJECT;
declare variable V_CHILD_ACTION_SIGN type of SIGN_ACTION;
declare variable V_SQL type of SQL_STATEMENT;
declare variable V_PROCEDURE_NAME type of SIGN_OBJECT;
declare variable V_PARAM_ACTION type of SIGN_ACTION;
declare variable V_VALID_CRITERIAS type of BOOLEAN = 1;
declare variable V_LOG_ID type of ID_LOG;
declare variable V_CHILD_ACTION_ID type of ID_ACTION;
begin
  i_object_sign = trim(i_object_sign);
  i_action_sign = trim(i_action_sign);
  o_action_id = gen_id(seq_action_id, 1);
  select o_log_id
    from log_create(:i_action_sign, :i_param_id, :o_action_id, :o_action_id, coalesce(:i_object_id, 0))
    into :v_log_id;

  i_object_id = nullif(i_object_id, 0);
  if (i_object_id is null) then
    select o_value from param_get(:i_param_id, 'ID') into :i_object_id;
  else
    execute procedure param_set(:i_param_id, 'ID', :i_object_id);

  insert into actions (action_id, action_sign, action_dtm, object_id)
    values(:o_action_id, :i_action_sign, current_timestamp, :i_object_id);

  update paramheads
    set action_id = :o_action_id,
        object_id = :i_object_id
    where param_id = :i_param_id;

  -- get action object_code
  select coalesce(a.procedure_name, a.action_sign)
    from actioncodes a
    where a.action_sign = :i_action_sign
    into :v_procedure_name;

  -- read action input params
  for select acp.param_name, trim(acp.param_kind), acp.param_value
    from actioncode_params acp
      inner join paramkinds pk on (pk.param_kind = acp.param_kind)
    where acp.action_sign = :i_action_sign
      and pk.is_output = 0
    order by pk.order_no
    into :v_param_name, :v_param_kind, :v_param_value
  do execute procedure param_calc_in(:i_object_sign, :i_param_id, :v_param_name, :v_param_kind, :v_param_value, :i_param_id);

  if (i_object_id is not null) then
    execute procedure object_get(:i_object_sign, :i_object_id, :i_param_id);

  v_valid_criterias = 1;
  -- check criterias
  for select acc.param_name, acc.param_action, acc.param_kind, acc.param_value_1, acc.param_value_2
    from actioncode_criterias acc
    where acc.actioncode_sign = :i_action_sign
    into :v_param_name, :v_param_action, :v_param_kind, :v_param_value, :v_param_value_2
  do
  begin
    select o_valid
      from param_criteria (:i_param_id, :v_param_name, :v_param_action, :v_param_kind, :v_param_value, :v_param_value_2)
      into :v_valid_criterias;
    if (:v_valid_criterias = 0) then
      leave;
  end

  if (v_valid_criterias = 1) then
  begin
    if (v_procedure_name = 'ACCOUNT_CREDIT') then
      execute procedure act_account_credit(:i_param_id, :i_object_id);
    else
    if (v_procedure_name = 'MONEYBACK_STORE') then
      execute procedure act_moneyback_store(:i_param_id, :i_object_id);
    else
    if (v_procedure_name = 'ACCOUNT_DEBITORDER') then
      execute procedure act_account_debitorder(:i_param_id, :i_object_id);
    else
    if (v_procedure_name = 'PAYMENT_STORE') then
      execute procedure act_payment_store(:i_param_id, :i_object_id);
    else
    if (v_procedure_name = 'ACCOUNT_STORE') then
      execute procedure act_account_store(:i_param_id, :i_object_id);
    else
    if (v_procedure_name = 'ORDER_FOREACH_ORDERITEM') then
      execute procedure act_order_foreach_orderitem(:i_param_id, :i_object_id);
    else
    if (v_procedure_name = 'ORDER_FOREACH_ORDERTAX') then
      execute procedure act_order_foreach_ordertax(:i_param_id, :i_object_id);
    else
    if (v_procedure_name = 'ORDER_FOREACH_TAXRATE') then
      execute procedure act_order_foreach_taxrate(:i_param_id, :i_object_id);
    else
    if (v_procedure_name = 'ORDERITEM_STORE') then
      execute procedure act_orderitem_store(:i_param_id, :i_object_id);
    else
    if (v_procedure_name = 'CLIENT_STORE') then
      execute procedure act_client_store(:i_param_id, :i_object_id);
    else
    if (v_procedure_name = 'ORDERTAX_STORE') then
      execute procedure act_ordertax_store(:i_param_id, :i_object_id);
    else
    if (v_procedure_name = 'ORDER_STORE') then
      execute procedure act_order_store(:i_param_id, :i_object_id);
    else
    if (v_procedure_name = 'MESSAGE_STORE') then
      execute procedure act_message_store(:i_param_id, :i_object_id);
    else
    if (v_procedure_name = 'MAGAZINE_STORE') then
      execute procedure act_magazine_store(:i_param_id, :i_object_id);
    else
    begin
    -- run main action
      v_sql = 'execute procedure act_'||:v_procedure_name||'(:param_id, :object_id)';
      execute statement (:v_sql) (param_id := :i_param_id, object_id := :i_object_id);
    end
  
    if (:i_object_id is null) then
    begin
      select o_value from param_get(:i_param_id, 'ID') into :i_object_id;
      update actions
        set object_id = :i_object_id
        where action_id = :o_action_id;
    end
  
    -- run child actions
    for select a.actiontreeitem_id, a.child_action, c.object_sign
      from actiontree a
        inner join actioncodes c on (c.action_sign = a.child_action)
      where a.action_sign = :i_action_sign
      order by a.order_no
      into :v_actiontreeitem_id, :v_child_action_sign, :v_child_object_sign do
    begin
      select o_param_id from param_create(:v_child_object_sign) into :v_param_id;
      execute procedure param_set(:v_param_id, 'ACTIONTREEITEM_ID', :v_actiontreeitem_id);
      -- calc child action input param
      for select atp.param_name, atp.param_kind, atp.param_value
        from actiontree_params atp
          inner join paramkinds pk on (pk.param_kind = atp.param_kind)
        where atp.actiontreeitem_id = :v_actiontreeitem_id
          and pk.is_output = 0
        order by pk.order_no
        into :v_param_name, :v_param_kind, :v_param_value
      do execute procedure param_calc_in(:v_child_object_sign, :v_param_id, :v_param_name, :v_param_kind, :v_param_value, :i_param_id);
  
      v_valid_criterias = 1;
      -- check criterias
      for select atc.param_name, atc.param_action, atc.param_kind, atc.param_value_1, atc.param_value_2
        from actiontree_criterias atc
        where atc.actiontreeitem_id = :v_actiontreeitem_id
        into :v_param_name, :v_param_action, :v_param_kind, :v_param_value, :v_param_value_2
      do
      begin
        select o_valid
          from param_criteria (:v_param_id, :v_param_name, :v_param_action, :v_param_kind, :v_param_value, :v_param_value_2)
          into :v_valid_criterias;
        if (:v_valid_criterias = 0) then
          leave;
      end
      if (:v_valid_criterias = 1) then
      begin
        -- execute child action
        if (v_child_action_sign like '%FOREACH%') then
          execute procedure action_run(:v_child_object_sign, :v_child_action_sign, :v_param_id, :i_object_id)
            returning_values :v_child_action_id;
        else
          execute procedure action_run(:v_child_object_sign, :v_child_action_sign, :v_param_id, null)
            returning_values :v_child_action_id;
        -- extract output params
        for select atp.param_name, atp.param_kind, atp.param_value
          from actiontree_params atp
            inner join paramkinds pk on (pk.param_kind = atp.param_kind)
          where atp.actiontreeitem_id = :v_actiontreeitem_id
            and pk.is_output = 1
          order by pk.order_no
          into :v_param_name, :v_param_kind, :v_param_value
        do execute procedure param_calc_out(:v_child_object_sign, :v_param_id, :v_param_name, :v_param_kind, :v_param_value, :i_param_id);
      end
    end
  
    execute procedure param_set(:i_param_id, 'ACTION_ID', :o_action_id);
  
    for select acp.param_name, acp.param_kind, acp.param_value
      from actioncode_params acp
        inner join paramkinds pk on (pk.param_kind = acp.param_kind)
      where acp.action_sign = :i_action_sign
        and pk.is_output = 1
      order by pk.order_no
      into :v_param_name, :v_param_kind, :v_param_value
    do execute procedure param_calc_out(:i_object_sign, :i_param_id, :v_param_name, :v_param_kind, :v_param_value, :i_param_id);
    execute procedure log_update(:v_log_id, :i_param_id, 0, coalesce(:i_object_id, 0));
  end
  else
    execute procedure log_update_skiped(:v_log_id, :i_param_id, 0, coalesce(:i_object_id, 0));

  suspend;
-- Exception Handler
  when any do
    begin
      execute procedure log_update(:v_log_id, :i_param_id, sqlcode, coalesce(:i_object_id, 0));
      exception;
    end
end
^

/* Alter (MESSAGE_CREATE) */
ALTER PROCEDURE MESSAGE_CREATE(I_FILE_NAME TYPE OF NAME_FILE,
I_FILE_SIZE TYPE OF SIZE_FILE,
I_FILE_DTM TYPE OF DTM_FILE)
 RETURNS(O_MESSAGE_ID TYPE OF ID_MESSAGE)
 AS
declare variable V_ACTION_ID type of ID_ACTION;
declare variable V_PARAM_ID type of ID_PARAM;
declare variable V_TEMPLATE_ID type of ID_TEMPLATE;
declare variable V_FILE_NAME type of NAME_FILE;
declare variable V_OBJECT_SIGN type of SIGN_OBJECT = 'MESSAGE';
begin
  if (not exists(select m.message_id
                   from messages m
                   where m.file_name = :i_file_name)) then
  begin
    select o_param_id from param_create(:v_object_sign) into :v_param_id;
    execute procedure param_set(:v_param_id, 'FILE_NAME', :i_file_name);
    execute procedure param_set(:v_param_id, 'FILE_SIZE', :i_file_size);
    execute procedure param_set(:v_param_id, 'FILE_DTM', :i_file_dtm);

    v_file_name = EscapeStringEx(:i_file_name, '-');

    select t.template_id
      from templates t
      where :v_file_name similar to t.filename_mask
      into :v_template_id;

    execute procedure param_set(:v_param_id, 'TEMPLATE_ID', :v_template_id);

    select o_action_id from action_run(:v_object_sign, 'MESSAGE_CREATE', :v_param_id, null)
      into :v_action_id;
    select a.object_id from actions a where a.action_id = :v_action_id
      into :o_message_id;
  end
  suspend;
end
^

/* Alter (OBJECT_READ) */
ALTER PROCEDURE OBJECT_READ(I_OBJECT_SIGN TYPE OF SIGN_OBJECT NOT NULL,
I_OBJECT_ID TYPE OF ID_OBJECT NOT NULL)
 RETURNS(O_PARAM_NAME TYPE OF SIGN_OBJECT,
O_PARAM_VALUE TYPE OF VALUE_ATTR)
 AS
declare variable V_PIVOT type of SQL_STATEMENT;
declare variable V_SQL type of SQL_STATEMENT;
declare variable V_PROCEDURE_NAME type of NAME_PROCEDURE;
begin
  if (i_object_id is null) then
    exit;
  select o_sql from pivot_record(:i_object_sign) into v_pivot;
  v_sql =
    'select pv.attr_sign, pv.attr_value '||
    ' from ('||:v_pivot||') pv ';
  for execute statement (:v_sql) (id := :i_object_id)
    into :o_param_name, :o_param_value do
    suspend;

  select o.procedure_read
    from objects o
    where o.object_sign = :i_object_sign
    into :v_procedure_name;
  if (v_procedure_name is not null) then
  begin
    v_sql = 'select o_param_name, o_param_value '||
    ' from '||:v_procedure_name||' (:id)';
    for execute statement (:v_sql) (id := :i_object_id)
      into :o_param_name, :o_param_value do
      suspend;
  end

end
^

/* Alter (ORDER_ANUL) */
ALTER PROCEDURE ORDER_ANUL(I_ORDER_ID TYPE OF ID_ORDER)
 RETURNS(O_NEW_STATUS_SIGN TYPE OF SIGN_OBJECT)
 AS
declare variable V_ORDERITEMS_CNT type of VALUE_INTEGER;
declare variable V_ORDER_STATUS_ID type of ID_STATUS;
declare variable V_ORDER_STATUS_SIGN type of SIGN_OBJECT;
declare variable V_PARAM_ID type of ID_PARAM;
declare variable V_ACTION_ID type of ID_ACTION;
begin
  select count(*) from orderitems oi
    inner join flags2statuses f2s on (f2s.status_id = oi.status_id and f2s.flag_sign = 'CREDIT')
    where oi.order_id = :i_order_id
    into :v_orderitems_cnt;

  select s.status_id, s.status_sign
    from orders o
      inner join statuses s on (s.status_id = o.status_id)
    where o.order_id = :i_order_id
    into :v_order_status_id, :v_order_status_sign;

  if (:v_orderitems_cnt = 0 and :v_order_status_sign not in ('CANCELLED', 'ANULLED', 'REJECTED')) then
  begin
    select o_param_id from param_create('ORDER', :i_order_id) into :v_param_id;
    select o_action_id from action_run('ORDER', 'ORDER_CANCELLED', :v_param_id, :i_order_id) into :v_action_id;
  end

  select s.status_sign
    from orders o
      inner join statuses s on (s.status_id = o.status_id)
    where o.order_id = :i_order_id
    into :o_new_status_sign;
  suspend;
end
^

/* Restore proc. body: ACT_ACCOUNT_PAYMENTOUT */
ALTER PROCEDURE ACT_ACCOUNT_PAYMENTOUT(I_PARAM_ID TYPE OF ID_PARAM NOT NULL,
I_OBJECT_ID TYPE OF ID_OBJECT NOT NULL,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ACCOUNT')
 AS
declare variable V_NOTES type of VALUE_ATTR;
declare variable V_AMOUNT_BYR type of MONEY_BYR;
declare variable V_REST_BYR type of MONEY_BYR;
declare variable V_DELTA_BYR type of MONEY_BYR;
declare variable V_BYR2EUR type of KURS_EXCH;
begin
  update paramheads set object_id = :i_object_id where param_id = :i_param_id;

  execute procedure param_set(:i_param_id, 'ID', :i_object_id);

  select o_value from param_get(:i_param_id, 'AMOUNT_BYR') into :v_amount_byr;
  select o_value from param_get(:i_param_id, 'NOTES') into :v_notes;

  select o_pattern from param_fillpattern(:i_param_id, :v_notes) into :v_notes;

  for select ar.byr2eur, ar.rest_byr
         from accrests ar
         where ar.account_id = :i_object_id
           and ar.rest_byr > 0
         order by ar.byr2eur
         into :v_byr2eur, :v_rest_byr do
  begin
    if (v_amount_byr < v_rest_byr) then
      v_delta_byr = v_amount_byr;
    else
      v_delta_byr = v_rest_byr;
    v_amount_byr = v_amount_byr - v_delta_byr;

    insert into accopers (account_id, byr2eur, notes, amount_byr)
      values(:i_object_id, :v_byr2eur, :v_notes, -:v_delta_byr);
    if (v_amount_byr = 0) then break;
  end

end
^

/* Restore proc. body: ACT_MONEYBACK_STORE */
ALTER PROCEDURE ACT_MONEYBACK_STORE(I_PARAM_ID TYPE OF ID_PARAM NOT NULL,
I_OBJECT_ID TYPE OF ID_OBJECT,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'MONEYBACK')
 AS
declare variable V_NOW_STATUS_ID type of ID_STATUS;
declare variable V_NEW_STATUS_ID type of ID_STATUS;
declare variable V_UPDATEABLE type of VALUE_BOOLEAN;
declare variable V_AMOUNT_BYR type of MONEY_BYR;
declare variable V_ACCOUNT_ID type of ID_ACCOUNT;
begin
  if (coalesce(i_object_id, 0) = 0) then i_object_id = gen_id(seq_moneyback_id, 1);

  update paramheads set object_id = :i_object_id where param_id = :i_param_id;

  execute procedure param_set(:i_param_id, 'ID', :i_object_id);

  select status_id from moneybacks where moneyback_id = :i_object_id into :v_now_status_id;

  if (:v_now_status_id is null) then
  begin
    select o_value from param_get(:i_param_id, 'STATUS_ID') into :v_new_status_id;
    if (:v_new_status_id is null) then
       select s.status_id
         from param_get(:i_param_id, 'NEW.STATUS_SIGN') p
           inner join statuses s on (s.object_sign = :i_object_sign and s.status_sign = p.o_value)
       into :v_new_status_id;
    select o_value from param_get(:i_param_id, 'ACCOUNT_ID') into :v_account_id;
    select o_value from param_get(:i_param_id, 'AMOUNT_BYR') into :v_amount_byr;

    insert into moneybacks(moneyback_id, account_id, amount_byr, status_id)
      values(:i_object_id, :v_account_id, :v_amount_byr, :v_new_status_id)
      returning status_id
      into :v_new_status_id;
    v_updateable = 1;
  end
  else
  begin
    select o_updateable, o_new_status_id
      from object_updateable(:i_param_id, :v_now_status_id, :i_object_sign)
      into :v_updateable, :v_new_status_id;
  end
  if (v_updateable = 1) then
  begin
    execute procedure param_set(:i_param_id, 'STATUS_ID', :v_new_status_id);
    execute procedure object_put(:i_param_id);
  end
end
^

/* Restore proc. body: ACT_ORDER_DEBIT */
ALTER PROCEDURE ACT_ORDER_DEBIT(I_PARAM_ID TYPE OF ID_PARAM,
I_OBJECT_ID TYPE OF ID_OBJECT,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ORDERITEM')
 AS
declare variable V_PARAM_ID type of ID_PARAM;
declare variable V_ACTION_SIGN type of SIGN_ACTION;
declare variable V_OBJECT_ID type of ID_OBJECT;
declare variable V_NEW_STATUS_SIGN type of SIGN_ATTR;
declare variable V_ACTION_ID type of ID_ACTION;
declare variable V_ACTIONTREEITEM_ID type of ID_ACTIONTREEITEM;
begin
  select o_value from param_get(:i_param_id, 'NEW.STATUS_SIGN') into :v_new_status_sign;
  select o_value from param_get(:i_param_id, 'ACTIONTREEITEM_ID') into :v_actiontreeitem_id;

  for select oi.orderitem_id
        from orderitems oi
        where oi.order_id = :i_object_id
        into :v_object_id do
  begin
    select o_param_id from param_create(:i_object_sign, :v_object_id) into :v_param_id;
    insert into params(param_id, param_name, param_value)
      select :v_param_id, p.param_name, p.param_value
        from params p
          inner join actiontree_params atp on (atp.param_name = p.param_name)
        where p.param_id = :i_param_id
          and atp.actiontreeitem_id = :v_actiontreeitem_id;

    select o_action_sign from action_detect(:i_object_sign, :v_object_id, :v_new_status_sign)
      into :v_action_sign;

    if (:v_action_sign is null) then
      select o_value from param_get(:i_param_id, 'ACTION_SIGN') into :v_action_sign;

    if (v_action_sign is not null) then
      execute procedure action_run(:i_object_sign, :v_action_sign, :v_param_id, :v_object_id)
        returning_values :v_action_id;
  end
end
^

/* Restore proc. body: ACT_ORDER_FOREACH_ORDERITEM */
ALTER PROCEDURE ACT_ORDER_FOREACH_ORDERITEM(I_PARAM_ID TYPE OF ID_PARAM,
I_OBJECT_ID TYPE OF ID_OBJECT,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ORDERITEM')
 AS
declare variable V_PARAM_ID type of ID_PARAM;
declare variable V_ACTION_SIGN type of SIGN_ACTION;
declare variable V_OBJECT_ID type of ID_OBJECT;
declare variable V_NEW_STATUS_SIGN type of SIGN_ATTR;
declare variable V_ACTION_ID type of ID_ACTION;
declare variable V_ACTIONTREEITEM_ID type of ID_ACTIONTREEITEM;
begin
  select o_value from param_get(:i_param_id, 'NEW.STATUS_SIGN') into :v_new_status_sign;
  select o_value from param_get(:i_param_id, 'ACTIONTREEITEM_ID') into :v_actiontreeitem_id;

  for select oi.orderitem_id
        from orderitems oi
        where oi.order_id = :i_object_id
        into :v_object_id do
  begin
    select o_param_id from param_create(:i_object_sign, :v_object_id) into :v_param_id;
    insert into params(param_id, param_name, param_value)
      select :v_param_id, p.param_name, p.param_value
        from params p
          inner join actiontree_params atp on (atp.param_name = p.param_name)
        where p.param_id = :i_param_id
          and atp.actiontreeitem_id = :v_actiontreeitem_id;

    select o_action_sign from action_detect(:i_object_sign, :v_object_id, :v_new_status_sign)
      into :v_action_sign;

    if (:v_action_sign is null) then
      select o_value from param_get(:i_param_id, 'ACTION_SIGN') into :v_action_sign;

    if (v_action_sign is not null) then
      execute procedure action_run(:i_object_sign, :v_action_sign, :v_param_id, :v_object_id)
        returning_values :v_action_id;
  end
end
^

/* Restore proc. body: ACT_ORDER_FOREACH_ORDERTAX */
ALTER PROCEDURE ACT_ORDER_FOREACH_ORDERTAX(I_PARAM_ID TYPE OF ID_PARAM,
I_OBJECT_ID TYPE OF ID_OBJECT,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ORDERTAX')
 AS
declare variable V_PARAM_ID type of ID_PARAM;
declare variable V_ACTION_SIGN type of SIGN_ACTION;
declare variable V_OBJECT_ID type of ID_OBJECT;
declare variable V_NEW_STATUS_SIGN type of SIGN_ATTR;
declare variable V_ACTION_ID type of ID_ACTION;
declare variable V_ACTIONTREEITEM_ID type of ID_ACTIONTREEITEM;
begin
  select o_value from param_get(:i_param_id, 'NEW.STATUS_SIGN') into :v_new_status_sign;
  select o_value from param_get(:i_param_id, 'ACTIONTREEITEM_ID') into :v_actiontreeitem_id;

  for select ordertax_id
        from ordertaxs
        where order_id = :i_object_id
        into :v_object_id do
  begin
    select o_param_id from param_create(:i_object_sign, :v_object_id) into :v_param_id;
    insert into params(param_id, param_name, param_value)
      select :v_param_id, p.param_name, p.param_value
        from params p
          inner join actiontree_params atp on (atp.param_name = p.param_name)
        where p.param_id = :i_param_id
          and atp.actiontreeitem_id = :v_actiontreeitem_id;

    select o_action_sign from action_detect(:i_object_sign, :v_object_id, :v_new_status_sign)
      into :v_action_sign;

    if (:v_action_sign is null) then
      select o_value from param_get(:i_param_id, 'ACTION_SIGN') into :v_action_sign;

    if (v_action_sign is not null) then
      execute procedure action_run(:i_object_sign, :v_action_sign, :v_param_id, :v_object_id)
        returning_values :v_action_id;
  end
end
^

/* Restore proc. body: ACT_ORDER_FOREACH_TAXRATE */
ALTER PROCEDURE ACT_ORDER_FOREACH_TAXRATE(I_PARAM_ID TYPE OF ID_PARAM,
I_OBJECT_ID TYPE OF ID_OBJECT,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ORDERTAX')
 AS
declare variable V_PARAM_ID type of ID_PARAM;
declare variable V_ACTION_SIGN type of SIGN_ACTION;
declare variable V_NEW_STATUS_SIGN type of SIGN_ATTR;
declare variable V_ACTION_ID type of ID_ACTION;
declare variable V_TAXRATE_ID type of ID_TAX;
declare variable V_TAX_PROCEDURE type of NAME_PROCEDURE;
declare variable V_COST_EUR type of MONEY_EUR;
declare variable V_OBJECT_ID type of ID_OBJECT;
declare variable V_ACTIONTREEITEM_ID type of ID_ACTIONTREEITEM;
begin
  select o_value from param_get(:i_param_id, 'NEW.STATUS_SIGN') into :v_new_status_sign;
  select o_value from param_get(:i_param_id, 'ACTIONTREEITEM_ID') into :v_actiontreeitem_id;

  for select tr.taxrate_id, tr.tax_procedure
    from orders o
      inner join calcpoints cp on (cp.object_status_id = o.status_id)
      inner join taxservs ts on (ts.calcpoint_id = cp.calcpoint_id)
      inner join taxrates tr on (tr.taxserv_id = ts.taxserv_id and tr.taxplan_id = o.taxplan_id)
      left join ordertaxs ot on (ot.order_id = o.order_id and ot.taxrate_id = tr.taxrate_id)
    where o.order_id = :i_object_id
      and ot.ordertax_id is null
    into :v_taxrate_id, :v_tax_procedure do
  begin
    v_object_id = gen_id(seq_ordertax_id, 1);

    select o_param_id from param_create(:i_object_sign, :v_object_id) into :v_param_id;
    insert into params(param_id, param_name, param_value)
      select :v_param_id, p.param_name, p.param_value
        from params p
          inner join actiontree_params atp on (atp.param_name = p.param_name)
        where p.param_id = :i_param_id
          and atp.actiontreeitem_id = :v_actiontreeitem_id;

    execute statement ('select o_cost_eur from '||v_tax_procedure||'(:taxrate_id, :param_id)')
      (taxrate_id := :v_taxrate_id, param_id := :v_param_id)
      into :v_cost_eur;
    if (v_cost_eur > 0) then
    begin
      select o_action_sign from action_detect(:i_object_sign, :v_object_id, :v_new_status_sign)
        into :v_action_sign;

      if (v_action_sign is not null) then
      begin
        execute procedure param_set(:v_param_id, 'TAXRATE_ID', :v_taxrate_id);
        execute procedure action_run(:i_object_sign, :v_action_sign, :v_param_id, :v_object_id)
          returning_values :v_action_id;
      end
    end
  end
end
^

/* Restore proc. body: ACTION_EXECUTE */
ALTER PROCEDURE ACTION_EXECUTE(I_OBJECT_SIGN TYPE OF SIGN_OBJECT,
I_PARAMS TYPE OF VALUE_BLOB,
I_ACTION_SIGN TYPE OF SIGN_ACTION,
I_OBJECT_ID TYPE OF ID_OBJECT)
 RETURNS(O_ACTION_ID TYPE OF ID_ACTION)
 AS
declare variable V_NEW_STATUS_SIGN type of SIGN_ATTR;
declare variable V_PARAM_ID type of ID_PARAM;
declare variable V_ACTION_ID type of ID_ACTION;
declare variable V_LOG_ID type of ID_LOG;
declare variable V_NOW_STATUS_ID type of ID_STATUS;
declare variable V_NOW_STATUS_SIGN type of SIGN_OBJECT;
begin
  select o_param_id
    from param_create(:i_object_sign)
    into :v_param_id;

  execute procedure param_unparse(:v_param_id, :i_params);

--  select o_log_id
--    from log_create(:i_object_sign, :v_param_id, null, null, coalesce(:i_object_id, 0))
--    into :v_log_id;

  i_object_id = nullif(i_object_id, 0);
  if (:i_object_id is not null) then
    execute procedure param_set(:v_param_id, 'ID', :i_object_id);
  else
    select o_value from param_get(:v_param_id, 'ID') into :i_object_id;

  select o_value from param_get(:v_param_id, 'NEW.STATUS_SIGN') into :v_new_status_sign;

  if (i_action_sign is null) then
    select o_action_sign
      from action_detect(:i_object_sign, :i_object_id, :v_new_status_sign)
      into :i_action_sign;

  if (i_action_sign is null) then
    i_action_sign= :i_object_sign||'_STORE';

  select o_action_id
    from action_run(:i_object_sign, :i_action_sign, :v_param_id, :i_object_id)
    into :o_action_id;

  delete from paramheads ph
    where ph.param_id = :v_param_id;

  suspend;
end
^

/* Restore proc. body: MONEYBACK_READ */
ALTER PROCEDURE MONEYBACK_READ(I_OBJECT_ID TYPE OF ID_OBJECT)
 RETURNS(O_PARAM_NAME TYPE OF SIGN_OBJECT,
O_PARAM_VALUE TYPE OF VALUE_ATTR)
 AS
declare variable V_STATUS_SIGN type of SIGN_OBJECT;
declare variable V_STATUS_NAME type of NAME_OBJECT;
begin
  select s.status_sign, s.status_name
    from moneybacks mb
      inner join statuses s on (s.status_id = mb.status_id)
    where mb.moneyback_id = :i_object_id
    into :v_status_sign, :v_status_name;

  o_param_name = 'STATUS_SIGN';
  o_param_value = v_status_sign;
  suspend;
  o_param_name = 'STATUS_NAME';
  o_param_value = v_status_name;
  suspend;

end
^

/* Restore proc. body: MONEYBACK_X_PURPOSE */
ALTER PROCEDURE MONEYBACK_X_PURPOSE(I_DEST_PARAM_ID TYPE OF ID_PARAM,
I_PARAM_NAME TYPE OF SIGN_ATTR,
I_SRC_PARAM_ID TYPE OF ID_PARAM)
 AS
declare variable V_KIND type of VALUE_ATTR;
declare variable V_PURPOSE type of VALUE_ATTR;
declare variable V_ORDER_ID type of ID_ORDER;
declare variable V_CLIENT_ID type of ID_CLIENT;
declare variable V_ACCOUNT_ID type of ID_ACCOUNT;
declare variable V_ORDER_CODE type of CODE_ORDER;
declare variable V_CLIENT_PARAM_ID type of ID_PARAM;
begin
  select o_value from param_get(:i_src_param_id, 'KIND') into :v_kind;
  select o_value from param_get(:i_src_param_id, 'ORDER_ID') into :v_order_id;
  select o_value from param_get(:i_src_param_id, 'ACCOUNT_ID') into :v_account_id;
  if (v_order_id is not null) then
  begin
    select o.order_code, o.client_id
      from orders o
      where o.order_id = :v_order_id
      into :v_order_code, :v_client_id;
    execute procedure param_set(:i_dest_param_id, 'ORDER_CODE', :v_order_code);
  end

  if (v_client_id is null) then
    select c.client_id
      from clients c
      where c.account_id = :v_account_id
      into :v_client_id;

  if (v_kind = 'BELPOST') then
  begin
    v_purpose = '[ORDER_CODE]';
  end
  else if (v_kind = 'BANK') then
  begin
    if (v_order_code is null) then
      v_purpose = '¬озврат денежных средств со счета дл€ зачислени€ на картсчет [CLIENT_BANK_CLIENT_ACCOUNT] '||
        '[CLIENT_LAST_NAME] [CLIENT_FIRST_NAME] [CLIENT_MID_NAME] паспорт [CLIENT_PASSPORT_NUM] выдан '||
        '[CLIENT_PASSPORT_ISSUER] [CLIENT_PASSPORT_ISSUED] [CLIENT_PERSONAL_NUM]';
    else
      v_purpose = '¬озврат денежных средств за полученный и возвращенный товар по '||
        'каталогу OTTO за€вка [ORDER_CODE] дл€ зачислени€ на картсчет [CLIENT_BANK_CLIENT_ACCOUNT] '||
        '[CLIENT_LAST_NAME] [CLIENT_FIRST_NAME] [CLIENT_MID_NAME] паспорт [CLIENT_PASSPORT_NUM] выдан '||
        '[CLIENT_PASSPORT_ISSUER] [CLIENT_PASSPORT_ISSUED] [CLIENT_PERSONAL_NUM]';

    select o_param_id from param_create('CLIENT', :v_client_id) into :v_client_param_id;
    execute procedure object_get('CLIENT', :v_client_id, :v_client_param_id);
    execute procedure param_merge(:i_dest_param_id, :v_client_param_id, 'CLIENT_');
    delete from paramheads ph where ph.param_id = :v_client_param_id;
  end

  select o_pattern from param_fillpattern(:i_dest_param_id, :v_purpose) into :v_purpose;

  execute procedure param_set(:i_dest_param_id, :i_param_name, :v_purpose);
end
^

/* Restore proc. body: PARAM_MERGE */
ALTER PROCEDURE PARAM_MERGE(I_DEST_PARAM_ID TYPE OF ID_PARAM NOT NULL,
I_SRC_PARAM_ID TYPE OF ID_PARAM NOT NULL,
I_PREFIX TYPE OF SIGN_OBJECT)
 AS
begin
  insert into params
  select :i_dest_param_id, :i_prefix||p.param_name, p.param_value
    from params p
    where p.param_id = :i_src_param_id;
end
^

/* Restore proc. body: TAX_ENTERED_SUM */
ALTER PROCEDURE TAX_ENTERED_SUM(I_TAXRATE_ID TYPE OF ID_TAX,
I_PARAM_ID TYPE OF ID_PARAM)
 RETURNS(O_COST_EUR TYPE OF MONEY_EUR)
 AS
declare variable V_PRICE_EUR type of MONEY_EUR;
declare variable V_PARAM_NAME type of SIGN_OBJECT;
begin
  select ta.attr_value
    from taxrate_attrs ta
      inner join attrs a on (a.attr_id = ta.attr_id)
    where ta.object_id = :i_taxrate_id
      and a.attr_sign = 'PARAM_NAME'
    into :v_param_name;
  select o_value from param_get(:i_param_id, :v_param_name) into :v_price_eur;
  execute procedure param_set(:i_param_id, 'PRICE_EUR', :v_price_eur);
  execute procedure param_set(:i_param_id, 'AMOUNT', 1);
  o_cost_eur = v_price_eur;
  suspend;
end
^

/* Creating trigger... */
CREATE TRIGGER ACCRESTS_BI0 FOR ACCRESTS
ACTIVE BEFORE INSERT POSITION 0 
AS
begin
  new.rest_dtm = current_timestamp;

  if (new.accrest_id is null) then
    new.accrest_id = gen_id(seq_accrest_id, 1);

  if (new.byr2eur is null) then
    select o_value from setting_get('BYR2EUR', new.rest_dtm) into new.byr2eur;

  if (new.rest_byr is null and new.rest_eur is not null) then
    new.rest_byr = round(new.rest_eur * new.byr2eur, -1);

  if (new.rest_eur is null and new.rest_byr is not null) then
    new.rest_eur = new.rest_byr / new.byr2eur;
end
^

CREATE TRIGGER ACCRESTS_BU0 FOR ACCRESTS
ACTIVE BEFORE UPDATE POSITION 0 
AS
begin
  new.rest_dtm = current_timestamp;
  if (new.rest_byr is null and new.rest_eur is not null) then
    new.rest_byr = old.rest_byr + round(new.rest_eur * old.byr2eur, -1);
  if (new.rest_eur is null and new.rest_byr is not null) then
    new.rest_eur = old.rest_eur + round(new.rest_byr, 2) / old.byr2eur;
end
^

CREATE TRIGGER MONEYBACKS_BI0 FOR MONEYBACKS
ACTIVE BEFORE INSERT OR UPDATE POSITION 0 
AS
begin
  if (new.moneyback_id is null) then
    new.moneyback_id = gen_id(seq_moneyback_id, 1);
  if (new.status_id is null) then
    select o_status_id from status_get_default('MONEYBACK') into new.status_id;
  new.status_dtm = current_timestamp;
end
^


/* Create Views... */

/* Altering existing trigger... */
ALTER TRIGGER ACCOPERS_BI
as
declare variable v_accrest_id id_accrest;
declare variable v_byr2eur kurs_exch;
declare variable v_rest_byr money_byr;
declare variable v_delta_byr money_byr;
declare variable v_delta_eur money_eur;
declare variable v_amount_byr money_byr;
declare variable v_amount_eur money_eur;
begin
  if (new.accoper_id is null) then
    new.accoper_id = gen_id(seq_accoper_id,1);
  new.accoper_dtm = current_timestamp;

  if (new.byr2eur is null) then
    select cast(o_value as integer)
      from setting_get('BYR2EUR', new.accoper_dtm)
      into new.byr2eur;

  if (new.amount_byr is null) then
    new.amount_byr = round(new.amount_eur * new.byr2eur, -1);
  if (new.amount_eur is null) then
    new.amount_eur = round(new.amount_byr, 2) / new.byr2eur;

  v_amount_byr = new.amount_byr;
--  v_amount_eur = new.amount_eur;
  if (v_amount_byr < 0) then
  begin
    for select ar.accrest_id, ar.rest_byr, ar.byr2eur
          from accrests ar
          where ar.account_id = new.account_id
            and ar.rest_byr > 0
          order by ar.byr2eur desc
          into :v_accrest_id, :v_rest_byr, :v_byr2eur do
    begin
      if (abs(v_amount_byr) < v_rest_byr) then
        v_delta_byr = abs(v_amount_byr);
      else
        v_delta_byr = v_rest_byr;
      v_amount_byr = v_amount_byr + v_delta_byr;
--      v_delta_eur = round(v_delta_byr, 2) * :v_byr2eur;
--      v_amount_eur = v_amount_eur + v_delta_eur;
      update accrests ar
        set ar.rest_byr = ar.rest_byr - :v_delta_byr,
            ar.rest_eur = null
--            ar.rest_eur = ar.rest_eur - :v_delta_eur
        where ar.accrest_id = :v_accrest_id;
    end
  end

  v_byr2eur = coalesce(:v_byr2eur, new.byr2eur);
  select ar.accrest_id
    from accrests ar
    where ar.account_id = new.account_id
      and ar.byr2eur = :v_byr2eur
    into :v_accrest_id;

  if (:v_accrest_id is null) then
    insert into accrests (account_id, byr2eur, rest_eur, rest_byr)
      values(new.account_id, :v_byr2eur, :v_amount_eur, :v_amount_byr)
      returning accrest_id
      into :v_accrest_id;
  else
    update accrests ar
      set ar.rest_byr = ar.rest_byr + :v_amount_byr,
          ar.rest_eur = null
--          ar.rest_eur = ar.rest_eur + :v_amount_eur
      where ar.accrest_id = :v_accrest_id;
end
^

/* Alter Procedure... */
/* Alter (ACT_ORDER_DEBIT) */
ALTER PROCEDURE ACT_ORDER_DEBIT(I_PARAM_ID TYPE OF ID_PARAM,
I_OBJECT_ID TYPE OF ID_OBJECT,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ORDERITEM')
 AS
declare variable V_PARAM_ID type of ID_PARAM;
declare variable V_ACTION_SIGN type of SIGN_ACTION;
declare variable V_OBJECT_ID type of ID_OBJECT;
declare variable V_NEW_STATUS_SIGN type of SIGN_ATTR;
declare variable V_ACTION_ID type of ID_ACTION;
declare variable V_ACTIONTREEITEM_ID type of ID_ACTIONTREEITEM;
begin
  select o_value from param_get(:i_param_id, 'NEW.STATUS_SIGN') into :v_new_status_sign;
  select o_value from param_get(:i_param_id, 'ACTIONTREEITEM_ID') into :v_actiontreeitem_id;

  for select oi.orderitem_id
        from orderitems oi
        where oi.order_id = :i_object_id
        into :v_object_id do
  begin
    select o_param_id from param_create(:i_object_sign, :v_object_id) into :v_param_id;
    insert into params(param_id, param_name, param_value)
      select :v_param_id, p.param_name, p.param_value
        from params p
          inner join actiontree_params atp on (atp.param_name = p.param_name)
        where p.param_id = :i_param_id
          and atp.actiontreeitem_id = :v_actiontreeitem_id;

    select o_action_sign from action_detect(:i_object_sign, :v_object_id, :v_new_status_sign)
      into :v_action_sign;

    if (:v_action_sign is null) then
      select o_value from param_get(:i_param_id, 'ACTION_SIGN') into :v_action_sign;

    if (v_action_sign is not null) then
      execute procedure action_run(:i_object_sign, :v_action_sign, :v_param_id, :v_object_id)
        returning_values :v_action_id;
  end
end
^

/* Alter (ACT_ORDER_FOREACH_ORDERITEM) */
ALTER PROCEDURE ACT_ORDER_FOREACH_ORDERITEM(I_PARAM_ID TYPE OF ID_PARAM,
I_OBJECT_ID TYPE OF ID_OBJECT,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ORDERITEM')
 AS
declare variable V_PARAM_ID type of ID_PARAM;
declare variable V_ACTION_SIGN type of SIGN_ACTION;
declare variable V_OBJECT_ID type of ID_OBJECT;
declare variable V_NEW_STATUS_SIGN type of SIGN_ATTR;
declare variable V_ACTION_ID type of ID_ACTION;
declare variable V_ACTIONTREEITEM_ID type of ID_ACTIONTREEITEM;
begin
  select o_value from param_get(:i_param_id, 'NEW.STATUS_SIGN') into :v_new_status_sign;
  select o_value from param_get(:i_param_id, 'ACTIONTREEITEM_ID') into :v_actiontreeitem_id;

  for select oi.orderitem_id
        from orderitems oi
        where oi.order_id = :i_object_id
        into :v_object_id do
  begin
    select o_param_id from param_create(:i_object_sign, :v_object_id) into :v_param_id;
    insert into params(param_id, param_name, param_value)
      select :v_param_id, p.param_name, p.param_value
        from params p
          inner join actiontree_params atp on (atp.param_name = p.param_name)
        where p.param_id = :i_param_id
          and atp.actiontreeitem_id = :v_actiontreeitem_id;

    select o_action_sign from action_detect(:i_object_sign, :v_object_id, :v_new_status_sign)
      into :v_action_sign;

    if (:v_action_sign is null) then
      select o_value from param_get(:i_param_id, 'ACTION_SIGN') into :v_action_sign;

    if (v_action_sign is not null) then
      execute procedure action_run(:i_object_sign, :v_action_sign, :v_param_id, :v_object_id)
        returning_values :v_action_id;
  end
end
^

/* Alter (ACT_ORDER_FOREACH_ORDERTAX) */
ALTER PROCEDURE ACT_ORDER_FOREACH_ORDERTAX(I_PARAM_ID TYPE OF ID_PARAM,
I_OBJECT_ID TYPE OF ID_OBJECT,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ORDERTAX')
 AS
declare variable V_PARAM_ID type of ID_PARAM;
declare variable V_ACTION_SIGN type of SIGN_ACTION;
declare variable V_OBJECT_ID type of ID_OBJECT;
declare variable V_NEW_STATUS_SIGN type of SIGN_ATTR;
declare variable V_ACTION_ID type of ID_ACTION;
declare variable V_ACTIONTREEITEM_ID type of ID_ACTIONTREEITEM;
begin
  select o_value from param_get(:i_param_id, 'NEW.STATUS_SIGN') into :v_new_status_sign;
  select o_value from param_get(:i_param_id, 'ACTIONTREEITEM_ID') into :v_actiontreeitem_id;

  for select ordertax_id
        from ordertaxs
        where order_id = :i_object_id
        into :v_object_id do
  begin
    select o_param_id from param_create(:i_object_sign, :v_object_id) into :v_param_id;
    insert into params(param_id, param_name, param_value)
      select :v_param_id, p.param_name, p.param_value
        from params p
          inner join actiontree_params atp on (atp.param_name = p.param_name)
        where p.param_id = :i_param_id
          and atp.actiontreeitem_id = :v_actiontreeitem_id;

    select o_action_sign from action_detect(:i_object_sign, :v_object_id, :v_new_status_sign)
      into :v_action_sign;

    if (:v_action_sign is null) then
      select o_value from param_get(:i_param_id, 'ACTION_SIGN') into :v_action_sign;

    if (v_action_sign is not null) then
      execute procedure action_run(:i_object_sign, :v_action_sign, :v_param_id, :v_object_id)
        returning_values :v_action_id;
  end
end
^

/* Alter (ACT_ORDER_FOREACH_TAXRATE) */
ALTER PROCEDURE ACT_ORDER_FOREACH_TAXRATE(I_PARAM_ID TYPE OF ID_PARAM,
I_OBJECT_ID TYPE OF ID_OBJECT,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ORDERTAX')
 AS
declare variable V_PARAM_ID type of ID_PARAM;
declare variable V_ACTION_SIGN type of SIGN_ACTION;
declare variable V_NEW_STATUS_SIGN type of SIGN_ATTR;
declare variable V_ACTION_ID type of ID_ACTION;
declare variable V_TAXRATE_ID type of ID_TAX;
declare variable V_TAX_PROCEDURE type of NAME_PROCEDURE;
declare variable V_COST_EUR type of MONEY_EUR;
declare variable V_OBJECT_ID type of ID_OBJECT;
declare variable V_ACTIONTREEITEM_ID type of ID_ACTIONTREEITEM;
begin
  select o_value from param_get(:i_param_id, 'NEW.STATUS_SIGN') into :v_new_status_sign;
  select o_value from param_get(:i_param_id, 'ACTIONTREEITEM_ID') into :v_actiontreeitem_id;

  for select tr.taxrate_id, tr.tax_procedure
    from orders o
      inner join calcpoints cp on (cp.object_status_id = o.status_id)
      inner join taxservs ts on (ts.calcpoint_id = cp.calcpoint_id)
      inner join taxrates tr on (tr.taxserv_id = ts.taxserv_id and tr.taxplan_id = o.taxplan_id)
      left join ordertaxs ot on (ot.order_id = o.order_id and ot.taxrate_id = tr.taxrate_id)
    where o.order_id = :i_object_id
      and ot.ordertax_id is null
    into :v_taxrate_id, :v_tax_procedure do
  begin
    v_object_id = gen_id(seq_ordertax_id, 1);

    select o_param_id from param_create(:i_object_sign, :v_object_id) into :v_param_id;
    insert into params(param_id, param_name, param_value)
      select :v_param_id, p.param_name, p.param_value
        from params p
          inner join actiontree_params atp on (atp.param_name = p.param_name)
        where p.param_id = :i_param_id
          and atp.actiontreeitem_id = :v_actiontreeitem_id;

    execute statement ('select o_cost_eur from '||v_tax_procedure||'(:taxrate_id, :param_id)')
      (taxrate_id := :v_taxrate_id, param_id := :v_param_id)
      into :v_cost_eur;
    if (v_cost_eur > 0) then
    begin
      select o_action_sign from action_detect(:i_object_sign, :v_object_id, :v_new_status_sign)
        into :v_action_sign;

      if (v_action_sign is not null) then
      begin
        execute procedure param_set(:v_param_id, 'TAXRATE_ID', :v_taxrate_id);
        execute procedure action_run(:i_object_sign, :v_action_sign, :v_param_id, :v_object_id)
          returning_values :v_action_id;
      end
    end
  end
end
^

/* Alter (ACTION_EXECUTE) */
ALTER PROCEDURE ACTION_EXECUTE(I_OBJECT_SIGN TYPE OF SIGN_OBJECT,
I_PARAMS TYPE OF VALUE_BLOB,
I_ACTION_SIGN TYPE OF SIGN_ACTION,
I_OBJECT_ID TYPE OF ID_OBJECT)
 RETURNS(O_ACTION_ID TYPE OF ID_ACTION)
 AS
declare variable V_NEW_STATUS_SIGN type of SIGN_ATTR;
declare variable V_PARAM_ID type of ID_PARAM;
declare variable V_ACTION_ID type of ID_ACTION;
declare variable V_LOG_ID type of ID_LOG;
declare variable V_NOW_STATUS_ID type of ID_STATUS;
declare variable V_NOW_STATUS_SIGN type of SIGN_OBJECT;
begin
  select o_param_id
    from param_create(:i_object_sign)
    into :v_param_id;

  execute procedure param_unparse(:v_param_id, :i_params);

--  select o_log_id
--    from log_create(:i_object_sign, :v_param_id, null, null, coalesce(:i_object_id, 0))
--    into :v_log_id;

  i_object_id = nullif(i_object_id, 0);
  if (:i_object_id is not null) then
    execute procedure param_set(:v_param_id, 'ID', :i_object_id);
  else
    select o_value from param_get(:v_param_id, 'ID') into :i_object_id;

  select o_value from param_get(:v_param_id, 'NEW.STATUS_SIGN') into :v_new_status_sign;

  if (i_action_sign is null) then
    select o_action_sign
      from action_detect(:i_object_sign, :i_object_id, :v_new_status_sign)
      into :i_action_sign;

  if (i_action_sign is null) then
    i_action_sign= :i_object_sign||'_STORE';

  select o_action_id
    from action_run(:i_object_sign, :i_action_sign, :v_param_id, :i_object_id)
    into :o_action_id;

  delete from paramheads ph
    where ph.param_id = :v_param_id;

  suspend;
end
^

SET TERM ; ^

ALTER TABLE ACCOPERS ALTER COLUMN ACCOPER_ID POSITION 1;

ALTER TABLE ACCOPERS ALTER COLUMN ACCOUNT_ID POSITION 2;

ALTER TABLE ACCOPERS ALTER COLUMN AMOUNT_EUR POSITION 3;

ALTER TABLE ACCOPERS ALTER COLUMN AMOUNT_BYR POSITION 4;

ALTER TABLE ACCOPERS ALTER COLUMN ACCREST_ID POSITION 5;

ALTER TABLE ACCOPERS ALTER COLUMN ACCOPER_DTM POSITION 6;

ALTER TABLE ACCOPERS ALTER COLUMN ORDER_ID POSITION 7;

ALTER TABLE ACCOPERS ALTER COLUMN ORDERMONEY_ID POSITION 8;

ALTER TABLE ACCOPERS ALTER COLUMN NOTES POSITION 9;

ALTER TABLE ACCOPERS ALTER COLUMN BYR2EUR POSITION 10;

ALTER TABLE ORDERITEMS ALTER COLUMN ORDERITEM_ID POSITION 1;

ALTER TABLE ORDERITEMS ALTER COLUMN ORDER_ID POSITION 2;

ALTER TABLE ORDERITEMS ALTER COLUMN ARTICLE_ID POSITION 3;

ALTER TABLE ORDERITEMS ALTER COLUMN MAGAZINE_ID POSITION 4;

ALTER TABLE ORDERITEMS ALTER COLUMN ARTICLE_CODE POSITION 5;

ALTER TABLE ORDERITEMS ALTER COLUMN DIMENSION POSITION 6;

ALTER TABLE ORDERITEMS ALTER COLUMN PRICE_EUR POSITION 7;

ALTER TABLE ORDERITEMS ALTER COLUMN AMOUNT POSITION 8;

ALTER TABLE ORDERITEMS ALTER COLUMN COST_EUR POSITION 9;

ALTER TABLE ORDERITEMS ALTER COLUMN STATUS_ID POSITION 10;

ALTER TABLE ORDERITEMS ALTER COLUMN STATUS_DTM POSITION 11;

ALTER TABLE ORDERITEMS ALTER COLUMN STATE_ID POSITION 12;

ALTER TABLE ORDERITEMS ALTER COLUMN ORDERITEM_INDEX POSITION 13;

ALTER TABLE ORDERITEMS ALTER COLUMN RETURN_REESTR_ID POSITION 14;

/* DROP: -- GRANT RDB$ADMIN TO ELENA */
REVOKE RDB$ADMIN FROM ELENA;

/* DROP: -- GRANT RDB$ADMIN TO ND */
REVOKE RDB$ADMIN FROM ND;

/* DROP: -- GRANT USERS TO ANNA */
REVOKE USERS FROM ANNA;

/* DROP: -- GRANT USERS TO KATYA */
REVOKE USERS FROM KATYA;

/* DROP: -- GRANT USERS TO LENA */
REVOKE USERS FROM LENA;

/* Create(Add) privilege */
GRANT ALL ON ACCOPERS TO VALERY;

GRANT ALL ON ACCOUNTS TO VALERY;

GRANT ALL ON ACCRESTS TO SYSDBA WITH GRANT OPTION;

GRANT ALL ON ACTION_ATTRS TO VALERY;

GRANT ALL ON ACTIONCODE_CRITERIAS TO VALERY;

GRANT ALL ON ACTIONCODE_PARAMS TO VALERY;

GRANT ALL ON ACTIONCODES TO VALERY;

GRANT ALL ON ACTIONS TO VALERY;

GRANT ALL ON ACTIONTREE TO VALERY;

GRANT ALL ON ACTIONTREE_CRITERIAS TO VALERY;

GRANT ALL ON ACTIONTREE_PARAMS TO VALERY;

GRANT ALL ON ADRESSES TO VALERY;

GRANT ALL ON ARTICLE_ATTRS TO VALERY;

GRANT ALL ON ARTICLECODE_ATTRS TO VALERY;

GRANT ALL ON ARTICLECODES TO VALERY;

GRANT ALL ON ARTICLEMASKS TO VALERY;

GRANT ALL ON ARTICLES TO VALERY;

GRANT ALL ON ARTICLESIGNS TO VALERY;

GRANT ALL ON ATTRS TO VALERY;

GRANT ALL ON BUILDS TO VALERY;

GRANT ALL ON CALCPOINTS TO VALERY;

GRANT ALL ON CATALOG2PLUGIN TO VALERY;

GRANT ALL ON CATALOGS TO VALERY;

GRANT ALL ON CLIENT_ATTRS TO VALERY;

GRANT ALL ON CLIENTS TO VALERY;

GRANT ALL ON COUNTERS TO VALERY;

GRANT ALL ON DETECTOR TO VALERY;

GRANT ALL ON EVENTCODES TO VALERY;

GRANT ALL ON EVENTS TO VALERY;

GRANT ALL ON FLAGS TO VALERY;

GRANT ALL ON FLAGS2STATUSES TO VALERY;

GRANT ALL ON IMP_CLIENT3 TO VALERY;

GRANT ALL ON LOGS TO VALERY;

GRANT ALL ON MAGAZINES TO VALERY;

GRANT ALL ON MESSAGE_ATTRS TO VALERY;

GRANT ALL ON MESSAGES TO VALERY;

GRANT ALL ON MONEYBACK_ATTRS TO SYSDBA WITH GRANT OPTION;

GRANT ALL ON MONEYBACKS TO SYSDBA WITH GRANT OPTION;

GRANT ALL ON NOTIFIES TO VALERY;

GRANT ALL ON OBJECTS TO VALERY;

GRANT ALL ON ORDER_ATTRS TO VALERY;

GRANT ALL ON ORDERHISTORY TO VALERY;

GRANT ALL ON ORDERITEM_ATTRS TO VALERY;

GRANT ALL ON ORDERITEMS TO VALERY;

GRANT ALL ON ORDERMONEYS TO VALERY;

GRANT ALL ON ORDERS TO VALERY;

GRANT ALL ON ORDERTAXS TO VALERY;

GRANT ALL ON PARAMACTIONS TO VALERY;

GRANT ALL ON PARAMHEADS TO VALERY;

GRANT ALL ON PARAMKINDS TO VALERY;

GRANT ALL ON PARAMS TO VALERY;

GRANT ALL ON PAYMENTS TO VALERY;

GRANT ALL ON PLACES TO VALERY;

GRANT ALL ON PLACETYPES TO VALERY;

GRANT ALL ON PLUGIN_PARAMS TO VALERY;

GRANT ALL ON PLUGINS TO VALERY;

GRANT ALL ON PORT2TEMPLATE TO VALERY;

GRANT ALL ON PORTS TO VALERY;

GRANT ALL ON PRODUCT_ATTRS TO VALERY;

GRANT ALL ON PRODUCTS TO VALERY;

GRANT ALL ON RECODES TO VALERY;

GRANT ALL ON SEARCHES TO VALERY;

GRANT ALL ON SESSIONS TO VALERY;

GRANT ALL ON SETTINGS TO VALERY;

GRANT ALL ON SETTINGSIGNS TO VALERY;

GRANT ALL ON STATUS_RULES TO VALERY;

GRANT ALL ON STATUSES TO VALERY;

GRANT ALL ON STREETTYPES TO VALERY;

GRANT ALL ON TAXPLANS TO VALERY;

GRANT ALL ON TAXRATE_ATTRS TO VALERY;

GRANT ALL ON TAXRATES TO VALERY;

GRANT ALL ON TAXSERVS TO VALERY;

GRANT ALL ON TEMPLATES TO VALERY;

GRANT ALL ON TMP_OTTO_ARTICLE TO VALERY;

GRANT ALL ON TMP_SEARCHES TO VALERY;

GRANT ALL ON USERS TO VALERY;

GRANT ALL ON V_ACCRESTS TO SYSDBA WITH GRANT OPTION;

GRANT ALL ON V_ACTION_ATTRS TO VALERY;

GRANT ALL ON V_ADRESS_TEXT TO VALERY;

GRANT ALL ON V_ARTICLES TO VALERY;

GRANT ALL ON V_ATTRINPARAM TO VALERY;

GRANT ALL ON V_CLIENT_ATTRS TO VALERY;

GRANT ALL ON V_CLIENT_BANKINFO TO SYSDBA WITH GRANT OPTION;

GRANT ALL ON V_CLIENTADRESS TO VALERY;

GRANT ALL ON V_CLIENTS_FIO TO VALERY;

GRANT ALL ON V_MONEYBACK_ATTRS TO SYSDBA WITH GRANT OPTION;

GRANT ALL ON V_MONEYBACK_BANK TO SYSDBA WITH GRANT OPTION;

GRANT ALL ON V_MONEYBACK_BELPOST TO SYSDBA WITH GRANT OPTION;

GRANT ALL ON V_ORDER_ATTRS TO VALERY;

GRANT ALL ON V_ORDER_FULL_SPECIFICATION TO VALERY;

GRANT ALL ON V_ORDER_INVOICEABLE TO VALERY;

GRANT ALL ON V_ORDER_PAID TO VALERY;

GRANT ALL ON V_ORDER_SUMMARY TO VALERY;

GRANT ALL ON V_ORDERITEM_ATTRS TO VALERY;

GRANT ALL ON V_ORDERITEMS_RETURNING TO SYSDBA WITH GRANT OPTION;

GRANT ALL ON V_ORDERS TO VALERY;

GRANT ALL ON V_PLACE_TEXT TO VALERY;

GRANT ALL ON V_PLACES TO VALERY;

GRANT ALL ON V_PRODUCT_ATTRS TO SYSDBA WITH GRANT OPTION;

GRANT ALL ON V_SETTINGS TO VALERY;

GRANT ALL ON V_STATUS_AVAILABLE TO VALERY;

GRANT ALL ON V_STATUSES TO VALERY;

GRANT ALL ON V_TAXRATE_ATTRS TO VALERY;

GRANT ALL ON VALUTES TO VALERY;

GRANT ALL ON VENDORS TO VALERY;

GRANT ALL ON WAYS TO VALERY;

GRANT EXECUTE ON PROCEDURE AALL_CLEAR TO VALERY;

GRANT EXECUTE ON PROCEDURE ACCOUNT_X_SEARCH TO VALERY;

GRANT EXECUTE ON PROCEDURE ACT_ACCOUNT_CREDIT TO VALERY;

GRANT EXECUTE ON PROCEDURE ACT_ACCOUNT_CREDITORDER TO VALERY;

GRANT EXECUTE ON PROCEDURE ACT_ACCOUNT_DEBIT TO VALERY;

GRANT EXECUTE ON PROCEDURE ACT_ACCOUNT_DEBITORDER TO VALERY;

GRANT EXECUTE ON PROCEDURE ACT_ACCOUNT_PAYMENTIN TO VALERY;

GRANT EXECUTE ON PROCEDURE ACT_ACCOUNT_STORE TO VALERY;

GRANT EXECUTE ON PROCEDURE ACT_ADRESS_STORE TO VALERY;

GRANT EXECUTE ON PROCEDURE ACT_CLIENT_STORE TO VALERY;

GRANT EXECUTE ON PROCEDURE ACT_EVENT_STORE TO VALERY;

GRANT EXECUTE ON PROCEDURE ACT_MAGAZINE_STORE TO VALERY;

GRANT EXECUTE ON PROCEDURE ACT_MESSAGE_STORE TO VALERY;

GRANT EXECUTE ON PROCEDURE ACT_ORDER_DEBIT TO VALERY;

GRANT EXECUTE ON PROCEDURE ACT_ORDER_FOREACH_ORDERITEM TO VALERY;

GRANT EXECUTE ON PROCEDURE ACT_ORDER_FOREACH_ORDERTAX TO VALERY;

GRANT EXECUTE ON PROCEDURE ACT_ORDER_FOREACH_TAXRATE TO VALERY;

GRANT EXECUTE ON PROCEDURE ACT_ORDER_STORE TO VALERY;

GRANT EXECUTE ON PROCEDURE ACT_ORDERITEM_STORE TO VALERY;

GRANT EXECUTE ON PROCEDURE ACT_ORDERMONEY_CREDIT TO VALERY;

GRANT EXECUTE ON PROCEDURE ACT_ORDERMONEY_DEBIT TO VALERY;

GRANT EXECUTE ON PROCEDURE ACT_ORDERMONEY_STORE TO VALERY;

GRANT EXECUTE ON PROCEDURE ACT_ORDERTAX_STORE TO VALERY;

GRANT EXECUTE ON PROCEDURE ACT_PAYMENT_STORE TO VALERY;

GRANT EXECUTE ON PROCEDURE ACT_PLACE_STORE TO VALERY;

GRANT EXECUTE ON PROCEDURE ACTION_DETECT TO VALERY;

GRANT EXECUTE ON PROCEDURE ACTION_EXECUTE TO VALERY;

GRANT EXECUTE ON PROCEDURE ACTION_REEXECUTE TO VALERY;

GRANT EXECUTE ON PROCEDURE ACTION_RERUN TO VALERY;

GRANT EXECUTE ON PROCEDURE ACTION_RERUN_ACTION TO VALERY;

GRANT EXECUTE ON PROCEDURE ACTION_RUN TO VALERY;

GRANT EXECUTE ON PROCEDURE ARTICLE_GOC TO VALERY;

GRANT EXECUTE ON PROCEDURE ARTICLECODE_GOC TO VALERY;

GRANT EXECUTE ON PROCEDURE ARTICLES_PUMP TO VALERY;

GRANT EXECUTE ON PROCEDURE ARTICLESIGN_DETECT TO VALERY;

GRANT EXECUTE ON PROCEDURE ATTR_PUT TO VALERY;

GRANT EXECUTE ON PROCEDURE COUNTER_NEXTVAL TO VALERY;

GRANT EXECUTE ON PROCEDURE DB_CLEANUP TO VALERY;

GRANT EXECUTE ON PROCEDURE LOG_CREATE TO VALERY;

GRANT EXECUTE ON PROCEDURE LOG_UPDATE TO VALERY;

GRANT EXECUTE ON PROCEDURE LOG_UPDATE_SKIPED TO VALERY;

GRANT EXECUTE ON PROCEDURE MAGAZINE_DETECT TO VALERY;

GRANT EXECUTE ON PROCEDURE MESSAGE_BUSY TO VALERY;

GRANT EXECUTE ON PROCEDURE MESSAGE_BUSY_2 TO VALERY;

GRANT EXECUTE ON PROCEDURE MESSAGE_CREATE TO VALERY;

GRANT EXECUTE ON PROCEDURE MESSAGE_RELEASE TO VALERY;

GRANT EXECUTE ON PROCEDURE NOTIFY_CREATE TO VALERY;

GRANT EXECUTE ON PROCEDURE OBJECT_GET TO VALERY;

GRANT EXECUTE ON PROCEDURE OBJECT_PUT TO VALERY;

GRANT EXECUTE ON PROCEDURE OBJECT_READ TO VALERY;

GRANT EXECUTE ON PROCEDURE OBJECT_UPDATEABLE TO VALERY;

GRANT EXECUTE ON PROCEDURE ORDER_ANUL TO VALERY;

GRANT EXECUTE ON PROCEDURE ORDER_READ TO VALERY;

GRANT EXECUTE ON PROCEDURE ORDER_X_ACTIVEITEMSCOUNT TO VALERY;

GRANT EXECUTE ON PROCEDURE ORDER_X_UNINVOICED TO VALERY;

GRANT EXECUTE ON PROCEDURE ORDERHISTORY_UPDATE TO VALERY;

GRANT EXECUTE ON PROCEDURE ORDERITEM_READ TO VALERY;

GRANT EXECUTE ON PROCEDURE ORDERITEM_X_GETSTATEID TO VALERY;

GRANT EXECUTE ON PROCEDURE ORDERTAX_READ TO VALERY;

GRANT EXECUTE ON PROCEDURE PARAM_CALC_IN TO VALERY;

GRANT EXECUTE ON PROCEDURE PARAM_CALC_OUT TO VALERY;

GRANT EXECUTE ON PROCEDURE PARAM_CLONE TO VALERY;

GRANT EXECUTE ON PROCEDURE PARAM_CREATE TO VALERY;

GRANT EXECUTE ON PROCEDURE PARAM_CRITERIA TO VALERY;

GRANT EXECUTE ON PROCEDURE PARAM_DEL TO VALERY;

GRANT EXECUTE ON PROCEDURE PARAM_FILLPATTERN TO VALERY;

GRANT EXECUTE ON PROCEDURE PARAM_GET TO VALERY;

GRANT EXECUTE ON PROCEDURE PARAM_PARSE TO VALERY;

GRANT EXECUTE ON PROCEDURE PARAM_PARSE_4ACTION TO VALERY;

GRANT EXECUTE ON PROCEDURE PARAM_SET TO VALERY;

GRANT EXECUTE ON PROCEDURE PARAM_UNPARSE TO VALERY;

GRANT EXECUTE ON PROCEDURE PIVOT_RECORD TO VALERY;

GRANT EXECUTE ON PROCEDURE PLACE_DETECT TO VALERY;

GRANT EXECUTE ON PROCEDURE PLACE_READ TO VALERY;

GRANT EXECUTE ON PROCEDURE PLUGIN_VALUE TO VALERY;

GRANT EXECUTE ON PROCEDURE SEARCH TO VALERY;

GRANT EXECUTE ON PROCEDURE SEARCH_GET_NGRAMM TO VALERY;

GRANT EXECUTE ON PROCEDURE SETTING_GET TO VALERY;

GRANT EXECUTE ON PROCEDURE SETTING_SET TO VALERY;

GRANT EXECUTE ON PROCEDURE SPLITBLOB TO VALERY;

GRANT EXECUTE ON PROCEDURE SPLITSTRING TO VALERY;

GRANT EXECUTE ON PROCEDURE STATUS_CHECK_CONVERSION TO VALERY;

GRANT EXECUTE ON PROCEDURE STATUS_CONVERSION_BY_FLAG TO VALERY;

GRANT EXECUTE ON PROCEDURE STATUS_GET_CONVERSION TO VALERY;

GRANT EXECUTE ON PROCEDURE STATUS_GET_DEFAULT TO VALERY;

GRANT EXECUTE ON PROCEDURE STATUS_STORE_DATE TO VALERY;

GRANT EXECUTE ON PROCEDURE TAX_FIXED_SUM TO VALERY;

GRANT EXECUTE ON PROCEDURE TAX_USE_REST TO VALERY;

GRANT EXECUTE ON PROCEDURE TAX_WEIGHT TO VALERY;

GRANT EXECUTE ON PROCEDURE TAXRATE_CALC TO VALERY;

GRANT RDB$ADMIN TO NASTYA;

GRANT USERS TO VALERY;


