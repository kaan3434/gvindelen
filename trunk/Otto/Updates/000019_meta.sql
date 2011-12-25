/* Server version: WI-V6.3.1.26351 Firebird 2.5 
   SQLDialect: 3. ODS: 11.2. Forced writes: On. Sweep inteval: 20000.
   Page size: 4096. Cache pages: 2048 (8192 Kb). Read-only: False. */
SET CLIENTLIB 'fbclient.dll';
SET NAMES CYRL;

SET SQL DIALECT 3;

SET AUTODDL ON;

RECONNECT;

ALTER TABLE INVOICE_ATTRS DROP CONSTRAINT FK_INVOICE_ATTRS_INVOICE;

ALTER TABLE ORDERITEMS DROP CONSTRAINT FK_ORDERITEMS_INVOICE;

ALTER TABLE ORDERTAXS DROP CONSTRAINT FK_ORDERTAXS_INVOICE;

ALTER TABLE PAYMENTS DROP CONSTRAINT FK_PAYMENTS_INVOICE;

ALTER TABLE INVOICES DROP CONSTRAINT PK_INVOICES;

RECONNECT;

ALTER TABLE INVOICE_ATTRS DROP CONSTRAINT PK_INVOICE_ATTRS;

RECONNECT;

ALTER TABLE DEALACTIONS DROP CONSTRAINT FK_DEALACTIONS_DEAL;

ALTER TABLE DEALS DROP CONSTRAINT PK_DEALS;

RECONNECT;

ALTER TABLE DEALACTIONS DROP CONSTRAINT PK_DEALACTIONS;

ALTER TABLE INVOICES DROP CONSTRAINT FK_INVOICES_STATUS;

ALTER TABLE INVOICES DROP CONSTRAINT FK_INVOICES_ORDER;

ALTER TABLE INVOICES DROP CONSTRAINT FK_INVOICES_ACCOUNT;

ALTER TABLE INVOICE_ATTRS DROP CONSTRAINT FK_INVOICE_ATTRS_ATTR;

ALTER TABLE DEALS DROP CONSTRAINT FK_DEALS_ORDER;

ALTER TABLE DEALACTIONS DROP CONSTRAINT FK_DEALACTIONS_ACTION;

ALTER TABLE ACCOPERS DROP CONSTRAINT FK_ACCOPERS_ORDERTAX;

ALTER TABLE ACCOPERS DROP CONSTRAINT FK_ACCOPERS_ORDERITEM;

ALTER TABLE ACCOPERS DROP CONSTRAINT FK_ACCOPERS_ACTION;

/* Alter Procedure (Before Drop)... */
SET TERM ^ ;

ALTER PROCEDURE ACT_INVOICE_STORE(I_PARAM_ID /* TYPE OF ID_PARAM */ BIGINT,
I_OBJECT_ID /* TYPE OF ID_OBJECT */ INTEGER,
I_OBJECT_SIGN /* TYPE OF SIGN_OBJECT */ VARCHAR(30) = 'INVOICE')
 AS
 BEGIN EXIT; END
^

ALTER PROCEDURE ACT_ORDERITEM_PAY(I_PARAM_ID /* TYPE OF ID_PARAM */ BIGINT,
I_OBJECT_ID /* TYPE OF ID_OBJECT */ INTEGER,
I_OBJECT_SIGN /* TYPE OF SIGN_OBJECT */ VARCHAR(30) = 'ORDERITEM')
 AS
 BEGIN EXIT; END
^

ALTER PROCEDURE INVOICE_DETECT(I_PAY_DT /* TYPE OF DT_INVOICE */ DATE NOT NULL,
I_AMOUNT_BYR /* TYPE OF MONEY_BYR */ INTEGER NOT NULL,
I_INVOICE_CODE /* TYPE OF CODE_ORDER */ VARCHAR(10))
 RETURNS(O_INVOICE_ID /* TYPE OF ID_INVOICE */ INTEGER)
 AS
 BEGIN SUSPEND; END
^

ALTER PROCEDURE INVOICE_GET_UNPAYED(I_AMOUNT_BYR /* TYPE OF MONEY_BYR */ INTEGER,
I_ORDER_CODE /* TYPE OF CODE_ORDER */ VARCHAR(10))
 RETURNS(O_INVOICE_ID /* TYPE OF ID_INVOICE */ INTEGER)
 AS
 BEGIN SUSPEND; END
^

ALTER PROCEDURE ORDER_X_UNPAID(I_DEST_PARAM_ID /* TYPE OF ID_PARAM */ BIGINT NOT NULL,
I_PARAM_NAME /* TYPE OF SIGN_ATTR */ VARCHAR(30) NOT NULL,
I_SRC_PARAM_ID /* TYPE OF ID_PARAM */ BIGINT NOT NULL)
 AS
 BEGIN EXIT; END
^


/* Drop Procedure... */
ALTER PROCEDURE ACTION_RUN(I_OBJECT_SIGN /* TYPE OF SIGN_OBJECT */ VARCHAR(30),
I_ACTION_SIGN /* TYPE OF SIGN_ACTION */ VARCHAR(30),
I_PARAM_ID /* TYPE OF ID_PARAM */ BIGINT,
I_DEAL_ID /* TYPE OF ID_DEAL */ INTEGER,
I_OBJECT_ID /* TYPE OF ID_OBJECT */ INTEGER)
 RETURNS(O_ACTION_ID /* TYPE OF ID_ACTION */ INTEGER)
 AS
 BEGIN SUSPEND; END
^

SET TERM ; ^

DROP PROCEDURE ACT_INVOICE_STORE;

DROP PROCEDURE ACT_ORDERITEM_PAY;

DROP PROCEDURE INVOICE_DETECT;

DROP PROCEDURE INVOICE_GET_UNPAYED;

DROP PROCEDURE ORDER_X_UNPAID;


/* Dropping trigger... */
DROP TRIGGER DEALS_BI0;

DROP TRIGGER INVOICES_AI0;

DROP TRIGGER INVOICES_AU0;

DROP TRIGGER INVOICES_BI0;


/* Drop View... */
DROP VIEW V_ACCOPER_SUMMARY;

SET TERM ^ ;

ALTER PROCEDURE ORDERITEM_READ(I_OBJECT_ID /* TYPE OF ID_OBJECT */ INTEGER)
 RETURNS(O_PARAM_NAME /* TYPE OF SIGN_OBJECT */ VARCHAR(30),
O_PARAM_VALUE /* TYPE OF VALUE_ATTR */ VARCHAR(4000))
 AS
 BEGIN SUSPEND; END
^

ALTER PROCEDURE ORDERTAX_READ(I_OBJECT_ID /* TYPE OF ID_OBJECT */ INTEGER)
 RETURNS(O_PARAM_NAME /* TYPE OF SIGN_OBJECT */ VARCHAR(30),
O_PARAM_VALUE /* TYPE OF VALUE_ATTR */ VARCHAR(4000))
 AS
 BEGIN SUSPEND; END
^

SET TERM ; ^

DROP VIEW V_INVOICE_ATTRS;


ALTER TABLE ACCOPERS ADD ACCOPER_DTM DTM_CREATE;

ALTER TABLE ACCOPERS ADD BYR2EUR MONEY_BYR;

ALTER TABLE ACCOPERS ADD ORDERMONEY_ID ID_TAX;

ALTER TABLE ORDERMONEYS ADD CREATED_DTM DTM_ACTION;

ALTER TABLE ORDERMONEYS ADD BYR2EUR MONEY_BYR;

ALTER TABLE ORDERS ADD ACCOUNT_ID ID_ACCOUNT;

ALTER TABLE ORDERS ADD USER_SIGN MON_USER;

SET TERM ^ ;

ALTER TRIGGER ORDERHISTORY_BI0
 AS Declare variable I integer;
BEGIN I = 0; END
^

SET TERM ; ^

ALTER TABLE ORDERHISTORY ALTER COLUMN USER_SIGN TYPE MON_USER;

RECONNECT;

ALTER TABLE USERS DROP CONSTRAINT PK_USERS;

ALTER TABLE USERS ALTER COLUMN USER_SIGN TYPE MON_USER;

/* Drop table-fields... */
/* Empty ACT_ACCOUNT_STORE for drop ACCOPERS(ACTION_ID) */
SET TERM ^ ;

ALTER PROCEDURE ACT_ACCOUNT_STORE(I_PARAM_ID /* TYPE OF ID_PARAM */ BIGINT NOT NULL,
I_OBJECT_ID /* TYPE OF ID_OBJECT */ INTEGER,
I_OBJECT_SIGN /* TYPE OF SIGN_OBJECT */ VARCHAR(30) = 'ACCOUNT')
 AS
 BEGIN EXIT; END
^

SET TERM ; ^

ALTER TABLE ACCOPERS DROP ACTION_ID;

ALTER TABLE ACCOPERS DROP REST_EUR;

ALTER TABLE ACCOPERS DROP BALANCE_EUR;

/* Empty AALL_CLEAR for drop ACCOPERS(ORDERITEM_ID) */
SET TERM ^ ;

ALTER PROCEDURE AALL_CLEAR(I_CLEAR_ARTICLES SMALLINT)
 AS
 BEGIN EXIT; END
^

SET TERM ; ^

ALTER TABLE ACCOPERS DROP ORDERITEM_ID;

ALTER TABLE ACCOPERS DROP ORDERTAX_ID;

/* Empty ORDER_X_UNINVOICED for drop ORDERITEMS(INVOICE_ID) */
SET TERM ^ ;

ALTER PROCEDURE ORDER_X_UNINVOICED(I_DEST_PARAM_ID /* TYPE OF ID_PARAM */ BIGINT,
I_PARAM_NAME /* TYPE OF SIGN_ATTR */ VARCHAR(30),
I_SRC_PARAM_ID /* TYPE OF ID_PARAM */ BIGINT)
 AS
 BEGIN EXIT; END
^

SET TERM ; ^

DROP VIEW V_ORDER_SUMMARY;

DROP VIEW V_ORDER_FULL_SPECIFICATION;

DROP VIEW V_ORDER_INVOICEABLE;

ALTER TABLE ORDERITEMS DROP INVOICE_ID;

ALTER TABLE ORDERITEMS DROP PAID_EUR;

ALTER TABLE ORDERTAXS DROP INVOICE_ID;

ALTER TABLE ORDERTAXS DROP PAID_EUR;

ALTER TABLE PAYMENTS DROP INVOICE_ID;


RECONNECT;

/* Drop tables... */
DROP TABLE DEALACTIONS;

SET TERM ^ ;

ALTER PROCEDURE ACTION_EXECUTE(I_OBJECT_SIGN /* TYPE OF SIGN_OBJECT */ VARCHAR(30),
I_PARAMS /* TYPE OF VALUE_BLOB */ BLOB SUB_TYPE 1 SEGMENT SIZE 100,
I_ACTION_SIGN /* TYPE OF SIGN_ACTION */ VARCHAR(30),
I_DEAL_ID /* TYPE OF ID_DEAL */ INTEGER,
I_OBJECT_ID /* TYPE OF ID_OBJECT */ INTEGER)
 RETURNS(O_ACTION_ID /* TYPE OF ID_ACTION */ INTEGER)
 AS
 BEGIN SUSPEND; END
^

SET TERM ; ^

DROP TABLE DEALS;

DROP TABLE INVOICE_ATTRS;

DROP TABLE INVOICES;


/* Create Procedure... */
SET TERM ^ ;

CREATE PROCEDURE ACT_ACCOUNT_CREDIT(I_PARAM_ID TYPE OF ID_PARAM NOT NULL,
I_OBJECT_ID TYPE OF ID_OBJECT NOT NULL,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ACCOUNT')
 AS
 BEGIN EXIT; END
^

CREATE PROCEDURE ACT_ACCOUNT_CREDITORDER(I_PARAM_ID TYPE OF ID_PARAM NOT NULL,
I_OBJECT_ID TYPE OF ID_OBJECT NOT NULL,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ACCOUNT')
 AS
 BEGIN EXIT; END
^

CREATE PROCEDURE ACT_ACCOUNT_DEBIT(I_PARAM_ID TYPE OF ID_PARAM NOT NULL,
I_OBJECT_ID TYPE OF ID_OBJECT NOT NULL,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ACCOUNT')
 AS
 BEGIN EXIT; END
^

CREATE PROCEDURE ACT_ACCOUNT_DEBITORDER(I_PARAM_ID TYPE OF ID_PARAM,
I_OBJECT_ID TYPE OF ID_OBJECT,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ACCOUNT')
 AS
 BEGIN EXIT; END
^

CREATE PROCEDURE ACT_ORDER_DEBIT(I_PARAM_ID TYPE OF ID_PARAM,
I_OBJECT_ID TYPE OF ID_OBJECT,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ORDERITEM')
 AS
 BEGIN EXIT; END
^

CREATE PROCEDURE ACT_ORDERMONEY_CREDIT(I_PARAM_ID TYPE OF ID_PARAM,
I_OBJECT_ID TYPE OF ID_OBJECT,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ORDERMONEY')
 AS
 BEGIN EXIT; END
^

CREATE PROCEDURE ACT_ORDERMONEY_DEBIT(I_PARAM_ID TYPE OF ID_PARAM,
I_OBJECT_ID TYPE OF ID_OBJECT,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ORDERMONEY')
 AS
 BEGIN EXIT; END
^

CREATE PROCEDURE PARAM_FILLPATTERN(I_PARAM_ID TYPE OF ID_PARAM NOT NULL,
I_PATTERN TYPE OF VALUE_ATTR)
 RETURNS(O_PATTERN TYPE OF VALUE_ATTR)
 AS
 BEGIN SUSPEND; END
^


/* Create Views... */
/* Create view: V_ORDER_FULL_SPECIFICATION */
SET TERM ; ^

CREATE VIEW V_ORDER_FULL_SPECIFICATION(
ORDER_ID,
ORD,
SUBJECT_ID,
SUBJECT_NAME,
DIMENSION,
WEIGHT,
PRICE_EUR,
AMOUNT,
COST_EUR,
NAME_RUS,
KIND_RUS,
STATE_NAME,
STATUS_NAME,
COUNT_WEIGHT,
COST_BYR)
 AS 
select oi.order_id, 1, oi.orderitem_id, oi.article_code, oi.dimension,
  cast(oia3.attr_value as integer) weight,
  oi.price_eur, oi.amount, oi.cost_eur,
  cast(oia1.attr_value as varchar(100)) name_rus,
  cast(oia2.attr_value as varchar(100)) kind_rus,
  s12.status_name article_status_name,
  s11.status_name, oi.amount as count_weight,
  round(o1.byr2eur * oi.cost_eur, -1) cost_byr
from orderitems oi
  left join v_orderitem_attrs oia1 on (oia1.object_id = oi.orderitem_id and oia1.attr_sign = 'NAME_RUS')
  left join v_orderitem_attrs oia2 on (oia2.object_id = oi.orderitem_id and oia2.attr_sign = 'KIND_RUS')
  left join v_orderitem_attrs oia3 on (oia3.object_id = oi.orderitem_id and oia3.attr_sign = 'WEIGHT')
  inner join orders o1 on (o1.order_id = oi.order_id)
  left join articles a on (a.article_id = oi.article_id)
  inner join statuses s11 on (s11.status_id = oi.status_id)
  left join statuses s12 on (s12.status_id = oi.state_id)
union
select ot.order_id, 2, ot.ordertax_id, ts.taxserv_name, null,
  null, ot.price_eur, ot.amount, ot.cost_eur,
  null, null, null, s2.status_name, 0,
  round(o2.byr2eur * ot.cost_eur, -1)
from ordertaxs ot
  inner join taxrates tr on (tr.taxrate_id = ot.taxrate_id)
  inner join taxservs ts on (ts.taxserv_id = tr.taxserv_id)
  left join  orders o2 on (o2.order_id = ot.order_id)
  inner join statuses s2 on (s2.status_id = ot.status_id)
union
select om.order_id, 3, om.ordermoney_id, 'Предоплата', null,
  null, om.amount_eur, 1, om.amount_eur,
  null, null, null, s3.status_name, 0,
  round(o3.byr2eur * om.amount_eur, -1)
from ordermoneys om
  left join  orders o3 on (o3.order_id = om.order_id)
  inner join statuses s3 on (s3.status_id = om.status_id)
;

/* Create view: V_ORDER_INVOICEABLE */
CREATE VIEW V_ORDER_INVOICEABLE(
ORDER_ID)
 AS 
select distinct o.order_id
from (
select oi.order_id
  from OrderItems oi
    inner join statuses si on (si.status_id = oi.status_id)
  where si.status_sign in ('ACCEPTED', 'BUNDLING', 'PACKED')
union
select ot.order_id
  from ordertaxs ot
    inner join statuses st on (st.status_id = ot.status_id)
  where st.status_sign in ('APPROVED')
) oit
inner join orders o on (o.order_id = oit.order_id)
inner join statuses s on (s.status_id = o.status_id)
where s.status_sign in ('ACCEPTED', 'PACKED')
;

/* Create view: V_ORDER_SUMMARY */
CREATE VIEW V_ORDER_SUMMARY(
ORDER_ID,
COST_EUR,
COST_BYR)
 AS 
select ofs.order_id, sum(ofs.cost_eur), sum(ofs.cost_byr)
from v_order_full_specification ofs
group by ofs.order_id
;


/* Create Primary Key... */
ALTER TABLE USERS ADD CONSTRAINT PK_USERS PRIMARY KEY (USER_SIGN);

/* Create Foreign Key... */
RECONNECT;

ALTER TABLE ACCOPERS ADD CONSTRAINT FK_ACCOPERS_ORDERMONEY FOREIGN KEY (ORDERMONEY_ID) REFERENCES ORDERMONEYS (ORDERMONEY_ID) ON UPDATE CASCADE;

ALTER TABLE ORDERS ADD CONSTRAINT FK_ORDERS_ACCOUNT FOREIGN KEY (ACCOUNT_ID) REFERENCES ACCOUNTS (ACCOUNT_ID) ON UPDATE CASCADE;

/*  Empty ACTION_RERUN for ACTION_EXECUTE(param list change)  */
SET TERM ^ ;

ALTER PROCEDURE ACTION_RERUN(I_LOG_ID /* TYPE OF ID_LOG */ BIGINT)
 AS
 BEGIN EXIT; END
^

/*  Empty ACTION_RERUN_ACTION for ACTION_EXECUTE(param list change)  */
ALTER PROCEDURE ACTION_RERUN_ACTION(I_LOG_ID /* TYPE OF ID_LOG */ BIGINT)
 AS
 BEGIN EXIT; END
^

/*  Empty ACT_ORDER_FOREACH_ORDERITEM for ACTION_RUN(param list change)  */
ALTER PROCEDURE ACT_ORDER_FOREACH_ORDERITEM(I_PARAM_ID /* TYPE OF ID_PARAM */ BIGINT,
I_OBJECT_ID /* TYPE OF ID_OBJECT */ INTEGER,
I_OBJECT_SIGN /* TYPE OF SIGN_OBJECT */ VARCHAR(30) = 'ORDERITEM')
 AS
 BEGIN EXIT; END
^

/*  Empty ACT_ORDER_FOREACH_ORDERTAX for ACTION_RUN(param list change)  */
ALTER PROCEDURE ACT_ORDER_FOREACH_ORDERTAX(I_PARAM_ID /* TYPE OF ID_PARAM */ BIGINT,
I_OBJECT_ID /* TYPE OF ID_OBJECT */ INTEGER,
I_OBJECT_SIGN /* TYPE OF SIGN_OBJECT */ VARCHAR(30) = 'ORDERTAX')
 AS
 BEGIN EXIT; END
^

/*  Empty ACT_ORDER_FOREACH_TAXRATE for ACTION_RUN(param list change)  */
ALTER PROCEDURE ACT_ORDER_FOREACH_TAXRATE(I_PARAM_ID /* TYPE OF ID_PARAM */ BIGINT,
I_OBJECT_ID /* TYPE OF ID_OBJECT */ INTEGER,
I_OBJECT_SIGN /* TYPE OF SIGN_OBJECT */ VARCHAR(30) = 'ORDERTAX')
 AS
 BEGIN EXIT; END
^

/*  Empty MESSAGE_CREATE for ACTION_RUN(param list change)  */
ALTER PROCEDURE MESSAGE_CREATE(I_FILE_NAME /* TYPE OF NAME_FILE */ VARCHAR(100),
I_FILE_SIZE /* TYPE OF SIZE_FILE */ INTEGER,
I_FILE_DTM /* TYPE OF DTM_FILE */ TIMESTAMP)
 RETURNS(O_MESSAGE_ID /* TYPE OF ID_MESSAGE */ INTEGER)
 AS
 BEGIN SUSPEND; END
^

/* Alter empty procedure ACTION_EXECUTE with new param-list */
ALTER PROCEDURE ACTION_EXECUTE(I_OBJECT_SIGN TYPE OF SIGN_OBJECT,
I_PARAMS TYPE OF VALUE_BLOB,
I_ACTION_SIGN TYPE OF SIGN_ACTION,
I_OBJECT_ID TYPE OF ID_OBJECT)
 RETURNS(O_ACTION_ID TYPE OF ID_ACTION)
 AS
 BEGIN SUSPEND; END
^

/* Alter empty procedure ACTION_RUN with new param-list */
ALTER PROCEDURE ACTION_RUN(I_OBJECT_SIGN TYPE OF SIGN_OBJECT,
I_ACTION_SIGN TYPE OF SIGN_ACTION,
I_PARAM_ID TYPE OF ID_PARAM,
I_OBJECT_ID TYPE OF ID_OBJECT)
 RETURNS(O_ACTION_ID TYPE OF ID_ACTION)
 AS
 BEGIN SUSPEND; END
^

/* Alter Procedure... */
/* Alter (AALL_CLEAR) */
ALTER PROCEDURE AALL_CLEAR(I_CLEAR_ARTICLES SMALLINT)
 AS
declare variable V_OBJECT_ID type of ID_OBJECT;
begin

  update accopers ao
    set ao.order_id = null;

  delete from payments;
  v_object_id = gen_id(seq_payment_id, -(gen_id(seq_payment_id, 0)));

  delete from orders;
  v_object_id = gen_id(seq_order_id, -(gen_id(seq_order_id, 0)));
  v_object_id = gen_id(seq_orderitem_id, -(gen_id(seq_orderitem_id, 0)));
  v_object_id = gen_id(seq_ordertax_id, -(gen_id(seq_ordertax_id, 0)));

  delete from clients;
  v_object_id = gen_id(seq_client_id, -(gen_id(seq_client_id, 0)));
  v_object_id = gen_id(seq_adress_id, -(gen_id(seq_adress_id, 0)));

  delete from accounts;
  v_object_id = gen_id(seq_account_id, -(gen_id(seq_account_id, 0)));
  v_object_id = gen_id(seq_accoper_id, -(gen_id(seq_accoper_id, 0)));


  delete from places where place_id > 1000000;
  v_object_id = gen_id(seq_place_id, -(gen_id(seq_place_id, 0))+1000000);


  delete from messages;
  v_object_id = gen_id(seq_message_id, -(gen_id(seq_message_id, 0)));
  v_object_id = gen_id(seq_notify_id, -(gen_id(seq_notify_id, 0)));

  delete from actions;
  v_object_id = gen_id(seq_action_id, -(gen_id(seq_action_id, 0)));

  delete from paramheads;
  v_object_id = gen_id(seq_param_id, -(gen_id(seq_param_id, 0)));

  delete from logs;
  v_object_id = gen_id(seq_log_id, -(gen_id(seq_log_id, 0)));

  delete from events;
  v_object_id = gen_id(seq_event_id, -(gen_id(seq_event_id, 0)));

  delete from sessions;
  if (i_clear_articles is not null) then
  begin
    delete from magazines where magazine_id > 1;
    v_object_id = gen_id(seq_magazine_id, -(gen_id(seq_magazine_id, 0))+1);

    delete from articlecodes;
    v_object_id = gen_id(seq_article_id, -(gen_id(seq_article_id, 0)));
    v_object_id = gen_id(seq_articlecode_id, -(gen_id(seq_articlecode_id, 0)));
    v_object_id = gen_id(seq_articlesign_id, -(gen_id(seq_articlesign_id, 0)));
  end

end
^

/* Alter (ACT_ACCOUNT_STORE) */
ALTER PROCEDURE ACT_ACCOUNT_STORE(I_PARAM_ID TYPE OF ID_PARAM NOT NULL,
I_OBJECT_ID TYPE OF ID_OBJECT,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ACCOUNT')
 AS
declare variable V_NOW_STATUS_ID type of ID_STATUS;
declare variable V_NEW_STATUS_ID type of ID_STATUS;
declare variable V_REST_EUR type of MONEY_EUR;
declare variable V_UPDATEABLE type of VALUE_BOOLEAN;
begin
  if (coalesce(i_object_id, 0) = 0) then i_object_id = gen_id(seq_account_id, 1);

  update paramheads set object_id = :i_object_id where param_id = :i_param_id;

  execute procedure param_set(:i_param_id, 'ID', :i_object_id);

  select status_id from accounts where account_id = :i_object_id into :v_now_status_id;

  if (:v_now_status_id is null) then
  begin
    v_rest_eur = 0;
    insert into accounts(account_id, rest_eur, status_id)
      values(:i_object_id, :v_rest_eur, :v_new_status_id)
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
begin
  select o_param_id
    from param_create(:i_object_sign)
    into :v_param_id;

  execute procedure param_unparse(:v_param_id, :i_params);

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

  if (i_action_sign is not null) then
    select o_action_id
      from action_run(:i_object_sign, :i_action_sign, :v_param_id, :i_object_id)
      into :o_action_id;

  suspend;
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

/* Alter (ORDER_X_UNINVOICED) */
ALTER PROCEDURE ORDER_X_UNINVOICED(I_DEST_PARAM_ID TYPE OF ID_PARAM,
I_PARAM_NAME TYPE OF SIGN_ATTR,
I_SRC_PARAM_ID TYPE OF ID_PARAM)
 AS
declare variable V_OBJECT_ID type of ID_OBJECT;
declare variable V_ORDERITEMS_COST_EUR type of MONEY_EUR;
declare variable V_ORDERTAXS_COST_EUR type of MONEY_EUR;
declare variable V_ORDERMONEYS_COST_EUR type of MONEY_EUR;
begin
  select o_value from param_get(:i_src_param_id, 'ID') into :v_object_id;

  select sum(oi.cost_eur)
    from orderitems oi
    where oi.order_id = :v_object_id
    into :v_orderitems_cost_eur;

  select sum(ot.cost_eur)
    from ordertaxs ot
    where ot.order_id = :v_object_id
    into :v_ordertaxs_cost_eur;

  select sum(om.amount_eur)
    from ordermoneys om
    where om.order_id = :v_object_id
    into :v_ordermoneys_cost_eur;

  execute procedure param_set(:i_dest_param_id, :i_param_name,
    :v_orderitems_cost_eur+:v_ordertaxs_cost_eur-:v_ordermoneys_cost_eur);
end
^

/* Alter (ORDERITEM_READ) */
ALTER PROCEDURE ORDERITEM_READ(I_OBJECT_ID TYPE OF ID_OBJECT)
 RETURNS(O_PARAM_NAME TYPE OF SIGN_OBJECT,
O_PARAM_VALUE TYPE OF VALUE_ATTR)
 AS
declare variable V_ARTICLE_ID type of ID_ARTICLE;
declare variable V_WEIGHT type of VALUE_INTEGER;
declare variable V_STATUS_SIGN type of SIGN_OBJECT;
declare variable V_STATUS_FLAG_LIST type of LIST_SIGNS;
declare variable V_STATE_SIGN type of SIGN_OBJECT;
declare variable V_STATE_FLAG_LIST type of LIST_SIGNS;
begin
  select oi.article_id, s.status_sign, s.flag_sign_list, ss.status_sign, ss.flag_sign_list
    from orderitems oi
      inner join statuses s on (s.status_id = oi.status_id)
      left join statuses ss on (ss.status_id = oi.state_id)
    where oi.orderitem_id = :i_object_id
    into :v_article_id, :v_status_sign, :v_status_flag_list, :v_state_sign, :v_state_flag_list;

  o_param_name = 'STATUS_SIGN';
  o_param_value = v_status_sign;
  suspend;

  o_param_name = 'STATUS_FLAG_LIST';
  o_param_value = v_status_flag_list;
  suspend;

  if (v_state_sign is not null) then
  begin
    o_param_name = 'STATE_SIGN';
    o_param_value = v_state_sign;
    suspend;

    o_param_name = 'STATE_FLAG_LIST';
    o_param_value = v_state_flag_list;
    suspend;
  end

  if (v_article_id is not null) then
    select ac.magazine_id, a.weight
      from articles a
        inner join articlecodes ac on (ac.articlecode_id=a.articlecode_id)
      where a.article_id = :v_article_id
      into :o_param_value, :v_weight;
  else
    o_param_value = 1;
  o_param_name = 'MAGAZINE_ID';
  suspend;

  if (v_weight is not null) then
  begin
    o_param_value = :v_weight;
    o_param_name = 'WEIGHT';
    suspend;
  end

end
^

/* Alter (ORDERTAX_READ) */
ALTER PROCEDURE ORDERTAX_READ(I_OBJECT_ID TYPE OF ID_OBJECT)
 RETURNS(O_PARAM_NAME TYPE OF SIGN_OBJECT,
O_PARAM_VALUE TYPE OF VALUE_ATTR)
 AS
declare variable V_TAXSERV_ID type of ID_TAX;
declare variable V_TAXSERV_NAME type of NAME_REF;
begin
  select ts.taxserv_id, ts.taxserv_name
    from ordertaxs ot
      inner join taxrates tr on (tr.taxrate_id = ot.taxrate_id)
      inner join taxservs ts on (ts.taxserv_id = tr.taxserv_id)
    where ot.ordertax_id = :i_object_id
    into :v_taxserv_id, :v_taxserv_name;

  o_param_name = 'TAXSERV_ID';
  o_param_value = :v_taxserv_id;
  suspend;
  o_param_name = 'TAXSERV_NAME';
  o_param_value = :v_taxserv_name;
  suspend;
end
^

/* Restore proc. body: ACT_ACCOUNT_CREDIT */
ALTER PROCEDURE ACT_ACCOUNT_CREDIT(I_PARAM_ID TYPE OF ID_PARAM NOT NULL,
I_OBJECT_ID TYPE OF ID_OBJECT NOT NULL,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ACCOUNT')
 AS
declare variable V_AMOUNT_EUR type of MONEY_EUR;
declare variable V_BYR2EUR type of MONEY_BYR;
declare variable V_ORDER_ID type of ID_ORDER;
declare variable V_NOTES type of VALUE_ATTR;
begin
  update paramheads set object_id = :i_object_id where param_id = :i_param_id;

  execute procedure param_set(:i_param_id, 'ID', :i_object_id);

  select o_value from param_get(:i_param_id, 'AMOUNT_EUR') into :v_amount_eur;
  select o_value from param_get(:i_param_id, 'BYR2EUR') into :v_byr2eur;
  select o_value from param_get(:i_param_id, 'ORDER_ID') into :v_order_id;
  select o_value from param_get(:i_param_id, 'NOTES') into :v_notes;

  select o_pattern from param_fillpattern(:i_param_id, :v_notes) into :v_notes;

  insert into accopers (account_id, amount_eur, byr2eur, order_id, notes)
    values(:i_object_id, -:v_amount_eur, :v_byr2eur, :v_order_id, :v_notes);
end
^

/* Restore proc. body: ACT_ACCOUNT_CREDITORDER */
ALTER PROCEDURE ACT_ACCOUNT_CREDITORDER(I_PARAM_ID TYPE OF ID_PARAM NOT NULL,
I_OBJECT_ID TYPE OF ID_OBJECT NOT NULL,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ACCOUNT')
 AS
declare variable V_AMOUNT_EUR type of MONEY_EUR;
declare variable V_BYR2EUR type of MONEY_BYR;
declare variable V_ORDER_ID type of ID_ORDER;
declare variable V_NOTES type of VALUE_ATTR;
declare variable V_ACC_AMOUNT_EUR type of MONEY_EUR;
declare variable V_ACC_BYR2EUR type of MONEY_BYR;
begin
  update paramheads set object_id = :i_object_id where param_id = :i_param_id;

  execute procedure param_set(:i_param_id, 'ID', :i_object_id);

  select o_value from param_get(:i_param_id, 'AMOUNT_EUR') into :v_amount_eur;
  select o_value from param_get(:i_param_id, 'ORDER_ID') into :v_order_id;

  for select ao.byr2eur, sum(ao.amount_eur)
        from accopers ao
        where ao.account_id = :i_object_id
        group by ao.byr2eur
        having sum(ao.amount_eur) > 0
        into :v_acc_byr2eur, :v_acc_amount_eur do
  begin
    if (v_amount_eur < :v_acc_amount_eur) then
      v_acc_amount_eur = v_amount_eur;
    v_amount_eur = v_amount_eur - v_acc_amount_eur;

    select o_value from param_get(:i_param_id, 'NOTES') into :v_notes;
    select o_pattern from param_fillpattern(:i_param_id, :v_notes) into :v_notes;

    insert into accopers (account_id, amount_eur, byr2eur, order_id, notes)
      values(:i_object_id, -:v_acc_amount_eur, :v_acc_byr2eur, :v_order_id, :v_notes);
    insert into ordermoneys (account_id, amount_eur, byr2eur, order_id)
      values(:i_object_id, :v_acc_amount_eur, :v_acc_byr2eur, :v_order_id);
    if (v_amount_eur = 0) then break;
  end
end
^

/* Restore proc. body: ACT_ACCOUNT_DEBIT */
ALTER PROCEDURE ACT_ACCOUNT_DEBIT(I_PARAM_ID TYPE OF ID_PARAM NOT NULL,
I_OBJECT_ID TYPE OF ID_OBJECT NOT NULL,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ACCOUNT')
 AS
declare variable V_AMOUNT_EUR type of MONEY_EUR;
declare variable V_BYR2EUR type of MONEY_BYR;
declare variable V_ORDER_ID type of ID_ORDER;
declare variable V_NOTES type of VALUE_ATTR;
begin

  update paramheads set object_id = :i_object_id where param_id = :i_param_id;

  execute procedure param_set(:i_param_id, 'ID', :i_object_id);

  select o_value from param_get(:i_param_id, 'AMOUNT_EUR') into :v_amount_eur;
  select o_value from param_get(:i_param_id, 'BYR2EUR') into :v_byr2eur;
  select o_value from param_get(:i_param_id, 'ORDER_ID') into :v_order_id;
  select o_value from param_get(:i_param_id, 'NOTES') into :v_notes;

  select o_pattern from param_fillpattern(:i_param_id, :v_notes) into :v_notes;

  insert into accopers (account_id, amount_eur, byr2eur, order_id, notes)
    values(:i_object_id, :v_amount_eur, :v_byr2eur, :v_order_id, :v_notes);
end
^

/* Restore proc. body: ACT_ACCOUNT_DEBITORDER */
ALTER PROCEDURE ACT_ACCOUNT_DEBITORDER(I_PARAM_ID TYPE OF ID_PARAM,
I_OBJECT_ID TYPE OF ID_OBJECT,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ACCOUNT')
 AS
declare variable V_AMOUNT_EUR type of MONEY_EUR;
declare variable V_ORDER_ID type of ID_ORDER;
declare variable V_NOTES type of VALUE_ATTR;
declare variable V_ACC_AMOUNT_EUR type of MONEY_EUR;
declare variable V_ACC_BYR2EUR type of MONEY_BYR;
declare variable V_ORDERITEMS_COST_EUR type of MONEY_EUR;
declare variable V_ORDERTAXS_COST_EUR type of MONEY_EUR;
declare variable V_ORDERMONEYS_COST_EUR type of MONEY_EUR;
begin
  update paramheads set object_id = :i_object_id where param_id = :i_param_id;

  execute procedure param_set(:i_param_id, 'ID', :i_object_id);

  select o_value from param_get(:i_param_id, 'ORDER_ID') into :v_order_id;

  select sum(oi.cost_eur)
    from orderitems oi
    where oi.order_id = :v_order_id
    into :v_orderitems_cost_eur;
  select sum(ot.cost_eur)
    from ordertaxs ot
    where ot.order_id = :v_order_id
    into :v_ordertaxs_cost_eur;
  select sum(om.amount_eur)
    from ordermoneys om
    where om.order_id = :v_order_id
    into :v_ordermoneys_cost_eur;
  v_amount_eur = v_ordermoneys_cost_eur - v_orderitems_cost_eur - v_ordertaxs_cost_eur;

  -- esli pereplata po zayavke
  if (v_amount_eur > 0) then
  begin
    for select om.byr2eur, sum(om.amount_eur)
          from ordermoneys om
          where om.order_id = :v_order_id
          group by om.byr2eur
          having sum(om.amount_eur) > 0
          order by om.byr2eur
          into :v_acc_byr2eur, :v_acc_amount_eur do
    begin
      if (v_amount_eur < v_acc_amount_eur) then
        v_acc_amount_eur = v_amount_eur;
      select o_value from param_get(:i_param_id, 'NOTES') into :v_notes;
      select o_pattern from param_fillpattern(:i_param_id, :v_notes) into :v_notes;

      insert into accopers (account_id, amount_eur, byr2eur, order_id, notes)
        values(:i_object_id, :v_acc_amount_eur, :v_acc_byr2eur, :v_order_id, :v_notes);
      insert into ordermoneys (account_id, amount_eur, byr2eur, order_id)
        values(:i_object_id, -:v_acc_amount_eur, :v_acc_byr2eur, :v_order_id);
    end
  end
  else
  -- esli po zayavke dolg
  if (v_amount_eur < 0) then
  begin
    for select om.byr2eur, sum(om.amount_eur)
          from ordermoneys om
          where om.order_id = :v_order_id
          group by om.byr2eur
          having sum(om.amount_eur) > 0
          order by om.byr2eur desc
          into :v_acc_byr2eur, :v_acc_amount_eur do
    begin
      if (v_amount_eur < v_acc_amount_eur) then
        v_acc_amount_eur = v_amount_eur;

      select o_value from param_get(:i_param_id, 'NOTES') into :v_notes;
      select o_pattern from param_fillpattern(:i_param_id, :v_notes) into :v_notes;

      insert into accopers (account_id, amount_eur, byr2eur, order_id, notes)
        values(:i_object_id, :v_acc_amount_eur, :v_acc_byr2eur, :v_order_id, :v_notes);
      insert into ordermoneys (account_id, amount_eur, byr2eur, order_id)
        values(:i_object_id, -:v_acc_amount_eur, :v_acc_byr2eur, :v_order_id);
    end
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

/* Restore proc. body: ACT_ORDERMONEY_CREDIT */
ALTER PROCEDURE ACT_ORDERMONEY_CREDIT(I_PARAM_ID TYPE OF ID_PARAM,
I_OBJECT_ID TYPE OF ID_OBJECT,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ORDERMONEY')
 AS
declare variable V_NOW_STATUS_ID type of ID_STATUS;
declare variable V_ORDER_ID type of ID_ORDER;
declare variable V_UPDATEABLE type of VALUE_BOOLEAN;
declare variable V_NEW_STATUS_ID type of ID_STATUS;
declare variable V_ACCOUNT_ID type of ID_ACCOUNT;
begin
  if (coalesce(i_object_id, 0) = 0) then i_object_id = gen_id(seq_ordermoney_id, 1);
    
  update paramheads set object_id = :i_object_id where param_id = :i_param_id;
    
  execute procedure param_set(:i_param_id, 'ID', :i_object_id);
    
  select status_id from ordermoneys where ordermoney_id = :i_object_id into :v_now_status_id;

  if (:v_now_status_id is null) then
  begin
    select o_value from param_get(:i_param_id, 'ACCOUNT_ID') into :v_account_id;
    select o_value from param_get(:i_param_id, 'ORDER_ID') into :v_order_id;

    insert into ordermoneys(ordermoney_id, order_id, account_id, status_id)
      values(:i_object_id, :v_order_id, :v_account_id, :v_new_status_id)
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

  if ((v_updateable = 1) or exists(select o_value from param_get(:i_param_id, 'UPDATEABLE'))) then
  begin
    execute procedure param_set(:i_param_id, 'STATUS_ID', :v_new_status_id);
    execute procedure object_put(:i_param_id);
  end
end
^

/* Restore proc. body: ACT_ORDERMONEY_DEBIT */
ALTER PROCEDURE ACT_ORDERMONEY_DEBIT(I_PARAM_ID TYPE OF ID_PARAM,
I_OBJECT_ID TYPE OF ID_OBJECT,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ORDERMONEY')
 AS
declare variable V_NOW_STATUS_ID type of ID_STATUS;
declare variable V_ORDER_ID type of ID_ORDER;
declare variable V_UPDATEABLE type of VALUE_BOOLEAN;
declare variable V_NEW_STATUS_ID type of ID_STATUS;
declare variable V_ACCOUNT_ID type of ID_ACCOUNT;
begin
  if (coalesce(i_object_id, 0) = 0) then i_object_id = gen_id(seq_ordermoney_id, 1);
    
  update paramheads set object_id = :i_object_id where param_id = :i_param_id;
    
  execute procedure param_set(:i_param_id, 'ID', :i_object_id);
    
  select status_id from ordermoneys where ordermoney_id = :i_object_id into :v_now_status_id;

  if (:v_now_status_id is null) then
  begin
    select o_value from param_get(:i_param_id, 'ACCOUNT_ID') into :v_account_id;
    select o_value from param_get(:i_param_id, 'ORDER_ID') into :v_order_id;

    insert into ordermoneys(ordermoney_id, order_id, account_id, status_id)
      values(:i_object_id, :v_order_id, :v_account_id, :v_new_status_id)
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

  if ((v_updateable = 1) or exists(select o_value from param_get(:i_param_id, 'UPDATEABLE'))) then
  begin
    execute procedure param_set(:i_param_id, 'STATUS_ID', :v_new_status_id);
    execute procedure object_put(:i_param_id);
  end
end
^

/* Restore proc. body: PARAM_FILLPATTERN */
ALTER PROCEDURE PARAM_FILLPATTERN(I_PARAM_ID TYPE OF ID_PARAM NOT NULL,
I_PATTERN TYPE OF VALUE_ATTR)
 RETURNS(O_PATTERN TYPE OF VALUE_ATTR)
 AS
declare variable V_PARAM_NAME type of SIGN_ATTR;
declare variable V_PARAM_VALUE type of VALUE_ATTR;
begin
  o_pattern = i_pattern;
  for select p.param_name, p.param_value
        from params p
        where p.param_id = :i_param_id
        into :v_param_name, :v_param_value do
      o_pattern = replace(o_pattern, '['||:v_param_name||']', :v_param_value);
  suspend;
end
^

/* Creating trigger... */
CREATE TRIGGER ACCOPERS_AI0 FOR ACCOPERS
ACTIVE AFTER INSERT POSITION 0 
AS
begin
  update accounts a
    set a.rest_eur = a.rest_eur + new.amount_eur, a.rest_date = current_timestamp
    where a.account_id = new.account_id;
end
^


/* Altering existing trigger... */
ALTER TRIGGER ACCOPERS_BI
as
begin
  if (new.accoper_id is null) then
    new.accoper_id = gen_id(seq_accoper_id,1);
  new.accoper_dtm = current_timestamp;
end
^

/* Altering existing trigger... */
ALTER TRIGGER ORDERHISTORY_BI0
AS
begin
  new.action_dtm = current_timestamp;
  new.user_sign = user;
end
^

/* Altering existing trigger... */
ALTER TRIGGER ORDERMONEYS_BI0
AS
begin
  if (new.ordermoney_id is null) then
    new.ordermoney_id = gen_id(seq_ordermoney_id, 1);
  if (new.status_id is null) then
    select o_status_id from status_get_default('ORDERMONEY') into new.status_id;
  new.status_dtm = current_timestamp;
  new.created_dtm = current_timestamp;
end
^

/* Altering existing trigger... */
ALTER TRIGGER ORDERS_BI0
AS
begin
  if (new.order_id is null) then
    new.order_id = gen_id(seq_order_id, 1);
  if (new.status_id is null) then
    select o_status_id from status_get_default('ORDER') into new.status_id;
  if (new.create_dtm is null) then
    new.create_dtm = current_timestamp;
  new.status_dtm = current_timestamp;
  new.user_sign = current_user;
end
^

/* Alter Procedure... */
/* DROP: -- GRANT ALL ON V_ACCOPER_SUMMARY TO SYSDBA WITH GRANT OPTION */
SET TERM ; ^

REVOKE ALL ON V_ACCOPER_SUMMARY FROM SYSDBA;

/* DROP: -- GRANT ALL ON V_INVOICE_ATTRS TO SYSDBA WITH GRANT OPTION */
REVOKE ALL ON V_INVOICE_ATTRS FROM SYSDBA;

/* Create(Add) Crant */
GRANT ALL ON V_ORDER_FULL_SPECIFICATION TO SYSDBA WITH GRANT OPTION;

GRANT ALL ON V_ORDER_INVOICEABLE TO SYSDBA WITH GRANT OPTION;

GRANT ALL ON V_ORDER_SUMMARY TO SYSDBA WITH GRANT OPTION;


