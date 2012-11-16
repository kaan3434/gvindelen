/* Server version: WI-V6.3.1.26351 Firebird 2.5 
   SQLDialect: 3. ODS: 11.2. Forced writes: On. Sweep inteval: 20000.
   Page size: 4096. Cache pages: 2048 (8192 Kb). Read-only: False. */
SET CLIENTLIB 'fbclient.dll';
SET NAMES CYRL;

SET SQL DIALECT 3;

SET AUTODDL ON;

ALTER DOMAIN VALUE_WEIGHT TYPE DECIMAL(9);

ALTER TABLE ORDERITEMS ADD NAME_RUS VALUE_SHORT;

ALTER TABLE ORDERITEMS ADD KIND_RUS VALUE_SHORT;

ALTER TABLE ORDERITEMS ADD WEIGHT VALUE_WEIGHT;

ALTER TABLE ORDERS ADD COST_EUR MONEY_EUR;

ALTER TABLE ORDERS ADD COST_BYR MONEY_BYR;

/* Create Procedure... */
SET TERM ^ ;

CREATE PROCEDURE ACT_ORDER_UPDATECOST(I_PARAM_ID TYPE OF ID_PARAM,
I_OBJECT_ID TYPE OF ID_OBJECT,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ORDERITEM')
 AS
 BEGIN EXIT; END
^

CREATE PROCEDURE MONEY_EUR2BYR(I_MONEY_EUR TYPE OF MONEY_EUR NOT NULL,
I_BYR2EUR TYPE OF MONEY_BYR NOT NULL)
 RETURNS(O_MONEY_BYR TYPE OF MONEY_BYR)
 AS
 BEGIN SUSPEND; END
^

CREATE PROCEDURE ORDER_UPDATECOST(I_ORDER_ID TYPE OF ID_ORDER NOT NULL)
 AS
 BEGIN EXIT; END
^


/* Alter View (Drop, Create)... */
/* Drop altered view: V_ORDER_ATTRS */
ALTER PROCEDURE TAX_WEIGHT(I_TAXRATE_ID /* TYPE OF ID_TAX */ INTEGER,
I_PARAM_ID /* TYPE OF ID_PARAM */ BIGINT)
 RETURNS(O_COST_EUR /* TYPE OF MONEY_EUR */ DECIMAL(7,2))
 AS
 BEGIN SUSPEND; END
^

SET TERM ; ^

DROP VIEW V_ORDERITEMS_RETURNING;

DROP VIEW V_ORDER_ATTRS;

/* Create altered view: V_ORDER_ATTRS */
/* Create view: V_ORDER_ATTRS */
CREATE VIEW V_ORDER_ATTRS(
OBJECT_ID,
ATTR_SIGN,
ATTR_VALUE,
ATTR_NAME,
ATTR_ID)
 AS 
select oia.object_id, a.attr_sign, oia.attr_value, a.attr_name, a.attr_id
from order_attrs oia
inner join attrs a on (a.attr_id = oia.attr_id)
;

/* Drop altered view: V_ORDER_FULL_SPECIFICATION */
SET TERM ^ ;

ALTER PROCEDURE ACT_ACCOUNT_DEBITORDER(I_PARAM_ID /* TYPE OF ID_PARAM */ BIGINT NOT NULL,
I_OBJECT_ID /* TYPE OF ID_OBJECT */ INTEGER NOT NULL,
I_OBJECT_SIGN /* TYPE OF SIGN_OBJECT */ VARCHAR(30) = 'ACCOUNT')
 AS
 BEGIN EXIT; END
^

ALTER PROCEDURE MONEY_TO_ORDER(I_ORDER_CODE /* TYPE OF CODE_ORDER */ VARCHAR(10))
 AS
 BEGIN EXIT; END
^

SET TERM ; ^

DROP VIEW V_ORDER_SUMMARY;

DROP VIEW V_ORDER_FULL_SPECIFICATION;

/* Create altered view: V_ORDER_FULL_SPECIFICATION */
/* Create view: V_ORDER_FULL_SPECIFICATION */
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
  oi.weight, oi.price_eur, oi.amount, oi.cost_eur,
  oi.name_rus, oi.kind_rus,
  s12.status_name article_status_name,
  s11.status_name, oi.amount as count_weight,
  round(o1.byr2eur * oi.cost_eur, -1) cost_byr
from orderitems oi
  inner join orders o1 on (o1.order_id = oi.order_id)
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
select om.order_id, 3, om.ordermoney_id,
  case
    when om.amount_eur > 0 then 'Предоплата'
    when om.amount_eur < 0 then 'Задолженность'
  end payment_name, null,
  null, -om.amount_eur, 1, -om.amount_eur,
  null, null, null, s3.status_name, 0,
  -round(o3.byr2eur * om.amount_eur, -1)
from ordermoneys om
  left join  orders o3 on (o3.order_id = om.order_id)
  inner join statuses s3 on (s3.status_id = om.status_id)
;

/* Create index... */
CREATE DESC INDEX IK_ORDERS_CREATE_DTM ON ORDERS(CREATE_DTM);


/* Alter Procedure... */
/* empty dependent procedure body */
/* Clear: ACTION_RUN for: ACT_ACCOUNT_DEBITORDER */
SET TERM ^ ;

ALTER PROCEDURE ACTION_RUN(I_OBJECT_SIGN /* TYPE OF SIGN_OBJECT */ VARCHAR(30),
I_ACTION_SIGN /* TYPE OF SIGN_ACTION */ VARCHAR(30),
I_PARAM_ID /* TYPE OF ID_PARAM */ BIGINT,
I_OBJECT_ID /* TYPE OF ID_OBJECT */ INTEGER)
 RETURNS(O_ACTION_ID /* TYPE OF ID_ACTION */ INTEGER)
 AS
 BEGIN SUSPEND; END
^

/* Create view: V_ORDER_SUMMARY */
SET TERM ; ^

CREATE VIEW V_ORDER_SUMMARY(
ORDER_ID,
COST_EUR,
COST_BYR)
 AS 
select ofs.order_id, sum(ofs.cost_eur), sum(ofs.cost_byr)
from v_order_full_specification ofs
group by ofs.order_id
;

/* Alter (ACT_ACCOUNT_DEBITORDER) */
SET TERM ^ ;

ALTER PROCEDURE ACT_ACCOUNT_DEBITORDER(I_PARAM_ID TYPE OF ID_PARAM NOT NULL,
I_OBJECT_ID TYPE OF ID_OBJECT NOT NULL,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ACCOUNT')
 AS
declare variable V_AMOUNT_EUR type of MONEY_EUR;
declare variable V_ORDER_ID type of ID_ORDER;
declare variable V_NOTES type of VALUE_ATTR;
declare variable V_ACC_AMOUNT_EUR type of MONEY_EUR;
declare variable V_ACC_BYR2EUR type of MONEY_BYR;
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

  for select om.byr2eur, sum(om.amount_eur)
        from ordermoneys om
        where om.order_id = :v_order_id
        group by om.byr2eur
        having sum(om.amount_eur) > 0
        order by max(om.ordermoney_id)
        into :v_acc_byr2eur, :v_acc_amount_eur do
  begin
    if (v_amount_eur < v_acc_amount_eur) then
      v_delta_eur = v_amount_eur;
    else
      v_delta_eur = v_acc_amount_eur;
    v_delta_byr = round(v_amount_eur * :v_acc_byr2eur, -1);

    v_amount_eur = v_amount_eur - v_delta_eur;
    v_amount_byr = v_amount_byr + v_delta_byr;

    select o_value from param_get(:i_param_id, 'NOTES') into :v_notes;
    select o_pattern from param_fillpattern(:i_param_id, :v_notes) into :v_notes;

    insert into accopers (account_id, amount_eur, byr2eur, order_id, notes, amount_byr)
      values(:i_object_id, :v_delta_eur, :v_acc_byr2eur, :v_order_id, :v_notes, :v_delta_byr);
    insert into ordermoneys (account_id, amount_eur, byr2eur, order_id, amount_byr)
      values(:i_object_id, -:v_delta_eur, :v_acc_byr2eur, :v_order_id, -:v_delta_byr);
  end

  execute procedure param_set(:i_param_id, 'AMOUNT_BYR', :v_amount_byr);
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
/* Clear: BONUS_MAKE for: ACTION_RUN */
ALTER PROCEDURE BONUS_MAKE(I_FIO /* TYPE OF NAME_REF */ VARCHAR(100) NOT NULL,
I_TAXSERV_ID /* TYPE OF ID_TAX */ INTEGER NOT NULL)
 RETURNS(O_ACTION_ID /* TYPE OF ID_BONUS */ INTEGER)
 AS
 BEGIN SUSPEND; END
^

/* empty dependent procedure body */
/* Clear: BONUS_USE for: ACTION_RUN */
ALTER PROCEDURE BONUS_USE(I_ORDER_CODE /* TYPE OF CODE_ORDER */ VARCHAR(10))
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
    if (v_procedure_name = 'BONUS_USE') then
      execute procedure act_bonus_use(:i_param_id, :i_object_id);
    else
    if (v_procedure_name = 'BONUS_STORE') then
      execute procedure act_bonus_store(:i_param_id, :i_object_id);
    else
    if (v_procedure_name = 'ACCOUNT_CREDIT') then
      execute procedure act_account_credit(:i_param_id, :i_object_id);
    else
    if (v_procedure_name = 'MONEYBACK_STORE') then
      execute procedure act_moneyback_store(:i_param_id, :i_object_id);
    else
    if (v_procedure_name = 'ACCOUNT_CREDITORDER') then
      execute procedure act_account_creditorder(:i_param_id, :i_object_id);
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
    if (v_procedure_name = 'ACCOUNT_PAYMENTIN') then
      execute procedure act_account_paymentin(:i_param_id, :i_object_id);
    else
    if (v_procedure_name = 'ACCOUNT_PAYMENTOUT') then
      execute procedure act_account_paymentout(:i_param_id, :i_object_id);
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
      v_valid_criterias = 1;
      -- check criterias
      for select atc.param_name, atc.param_action, atc.param_kind, atc.param_value_1, atc.param_value_2
        from actiontree_criterias atc
        where atc.actiontreeitem_id = :v_actiontreeitem_id
        into :v_param_name, :v_param_action, :v_param_kind, :v_param_value, :v_param_value_2
      do
      begin
        select o_valid
          from param_criteria (:i_param_id, :v_param_name, :v_param_action, :v_param_kind, :v_param_value, :v_param_value_2)
          into :v_valid_criterias;
        if (:v_valid_criterias = 0) then
          leave;
      end
      if (:v_valid_criterias = 1) then
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

/* Alter (BONUS_MAKE) */
ALTER PROCEDURE BONUS_MAKE(I_FIO TYPE OF NAME_REF NOT NULL,
I_TAXSERV_ID TYPE OF ID_TAX NOT NULL)
 RETURNS(O_ACTION_ID TYPE OF ID_BONUS)
 AS
declare variable V_CLIENT_ID type of ID_CLIENT;
declare variable V_PARAM_ID type of ID_PARAM;
declare variable V_ACTION_ID type of ID_ACTION;
begin
  select client_id
    from v_clients_fio c
    where c.client_fio = :i_fio
    into :v_client_id;

  if (v_client_id is not null) then
  begin
    select o_param_id from param_create('BONUS') into :v_param_id;
    execute procedure param_set(:v_param_id, 'CLIENT_ID', :v_client_id);
    execute procedure param_set(:v_param_id, 'TAXSERV_ID', :i_taxserv_id);

    select o_action_id from action_run('BONUS', 'BONUS_CREATE', :v_param_id, 0) into :o_action_id;
    suspend;
  end
end
^

/* Alter (BONUS_USE) */
ALTER PROCEDURE BONUS_USE(I_ORDER_CODE TYPE OF CODE_ORDER)
 RETURNS(O_ACTION_ID TYPE OF ID_ACTION)
 AS
declare variable V_BONUS_ID type of ID_BONUS;
declare variable V_ORDER_ID type of ID_ORDER;
declare variable V_PARAM_ID type of ID_PARAM;
begin
  select first 1 o.order_id, b.bonus_id
    from orders o
      inner join bonuses b on (b.client_id = o.client_id and b.ordertax_id is null)
    where o.order_code = :i_order_code
    into :v_order_id, v_bonus_id;

  if (v_bonus_id is not null) then
  begin
    select o_param_id from param_create('BONUS') into :v_param_id;
    execute procedure param_set(:v_param_id, 'ID', :v_bonus_id);
    execute procedure param_set(:v_param_id, 'ORDER_ID', :v_order_id);

    select o_action_id from action_run('BONUS', 'BONUS_USE', :v_param_id, 0) into :o_action_id;
    suspend;
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
                   where m.file_name = :i_file_name
                     and extract(year from m.message_dtm) = extract(year from current_date))) then
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

/* Alter (MONEY_TO_ORDER) */
ALTER PROCEDURE MONEY_TO_ORDER(I_ORDER_CODE TYPE OF CODE_ORDER)
 AS
declare variable V_PARAM_ID type of ID_PARAM;
declare variable V_ACCOUNT_ID type of ID_ACCOUNT;
declare variable V_ORDER_ID type of ID_ORDER;
declare variable V_ACTION_ID type of ID_ACTION;
declare variable V_COST_EUR type of MONEY_EUR;
declare variable V_AMOUNT_EUR type of MONEY_EUR;
declare variable V_REST_EUR type of MONEY_EUR;
begin
  select o.account_id, o.order_id, os.cost_eur
    from orders o
      inner join v_order_summary os on (os.order_id = o.order_id)
    where o.order_code = :i_order_code
    into :v_account_id, :v_order_id, :v_cost_eur;

  select sum(ar.rest_eur)
    from accrests ar
    where ar.account_id = :v_account_id
    into :v_rest_eur;

  if (v_rest_eur > v_cost_eur) then
    v_amount_eur= replace(v_cost_eur, ',', '.');
  else
    v_amount_eur= replace(v_rest_eur, ',', '.');

  select o_param_id from param_create('ACCOUNT', :v_account_id) into :v_param_id;
  execute procedure param_set(:v_param_id, 'ORDER_ID', :v_order_id);

  execute procedure param_set(:v_param_id, 'AMOUNT_EUR', replace(:v_amount_eur, ',','.'));

  select o_action_id
    from action_run('ACCOUNT', 'ACCOUNT_CREDITORDER', :v_param_id, :v_account_id)
    into :v_action_id;

  suspend;
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

/* Alter (TAX_WEIGHT) */
ALTER PROCEDURE TAX_WEIGHT(I_TAXRATE_ID TYPE OF ID_TAX,
I_PARAM_ID TYPE OF ID_PARAM)
 RETURNS(O_COST_EUR TYPE OF MONEY_EUR)
 AS
declare variable V_AMOUNT type of VALUE_INTEGER;
declare variable V_ORDER_ID type of ID_ORDER;
declare variable V_PRICE_AMOUNT type of VALUE_INTEGER;
declare variable V_PRICE_EUR type of MONEY_EUR;
declare variable V_TAX_AMOUNT type of VALUE_INTEGER;
declare variable V_FREE_AMOUNT type of VALUE_INTEGER;
begin
  select o_value from param_get(:i_param_id, 'ORDER_ID') into :v_order_id;

  select ta.attr_value
    from v_taxrate_attrs ta
    where ta.object_id = :i_taxrate_id
      and ta.attr_sign = 'PRICE'
    into :v_price_eur;

  select ta.attr_value
    from v_taxrate_attrs ta
    where ta.object_id = :i_taxrate_id
      and ta.attr_sign = 'PRICE_AMOUNT'
    into :v_price_amount;

  select ta.attr_value
    from v_taxrate_attrs ta
    where ta.object_id = :i_taxrate_id
      and ta.attr_sign = 'FREE_AMOUNT'
    into :v_free_amount;

  select oa.attr_value
    from v_order_attrs oa
    where oa.object_id = :v_order_id
      and oa.attr_sign = 'WEIGHT'
      into :v_amount;

  if (v_amount - v_free_amount > 0) then
  begin
    v_tax_amount = (v_amount-v_free_amount)/ v_price_amount;
    if (v_tax_amount * v_price_amount < v_amount) then
     v_tax_amount = v_tax_amount + 1;
  end
  else
    v_tax_amount = 0;

  execute procedure param_set(:i_param_id, 'PRICE_EUR', :v_price_eur);
  execute procedure param_set(:i_param_id, 'AMOUNT', :v_tax_amount);
  o_cost_eur = :v_price_eur*:v_tax_amount;
  suspend;
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
declare variable V_NEW_FLAG_SIGN type of SIGN_OBJECT;
begin
  select o_value from param_get(:i_param_id, 'NEW.STATUS_SIGN') into :v_new_status_sign;
  select o_value from param_get(:v_param_id, 'NEW.FLAG_SIGN') into :v_new_flag_sign;
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

    select o_action_sign from action_detect(:i_object_sign, :v_object_id, :v_new_status_sign, :v_new_flag_sign, 0)
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
declare variable V_NEW_FLAG_SIGN type of SIGN_OBJECT;
begin
  select o_value from param_get(:i_param_id, 'NEW.STATUS_SIGN') into :v_new_status_sign;
  select o_value from param_get(:i_param_id, 'NEW.FLAG_SIGN') into :v_new_flag_sign;
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

    select o_action_sign from action_detect(:i_object_sign, :v_object_id, :v_new_status_sign, :v_new_flag_sign, 0)
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
declare variable V_NEW_FLAG_SIGN type of SIGN_OBJECT;
begin
  select o_value from param_get(:i_param_id, 'NEW.STATUS_SIGN') into :v_new_status_sign;
  select o_value from param_get(:i_param_id, 'NEW.FLAG_SIGN') into :v_new_flag_sign;
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

    select o_action_sign from action_detect(:i_object_sign, :v_object_id, :v_new_status_sign, :v_new_flag_sign, 0)
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
declare variable V_NEW_FLAG_SIGN type of SIGN_OBJECT;
begin
  select o_value from param_get(:i_param_id, 'NEW.STATUS_SIGN') into :v_new_status_sign;
  select o_value from param_get(:i_param_id, 'ACTIONTREEITEM_ID') into :v_actiontreeitem_id;
  select o_value from param_get(:i_param_id, 'NEW.FLAG_SIGN') into :v_new_flag_sign;

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
    select o_action_sign from action_detect(:i_object_sign, :v_object_id, :v_new_status_sign, :v_new_flag_sign, 0)
      into :v_action_sign;

    if (v_action_sign is not null) then
    begin
      execute procedure param_set(:v_param_id, 'TAXRATE_ID', :v_taxrate_id);
      execute procedure action_run(:i_object_sign, :v_action_sign, :v_param_id, :v_object_id)
        returning_values :v_action_id;
    end
  end
end
^

/* Restore proc. body: ACT_ORDER_UPDATECOST */
ALTER PROCEDURE ACT_ORDER_UPDATECOST(I_PARAM_ID TYPE OF ID_PARAM,
I_OBJECT_ID TYPE OF ID_OBJECT,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ORDERITEM')
 AS
declare variable V_PARAM_ID type of ID_PARAM;
declare variable V_ACTION_SIGN type of SIGN_ACTION;
declare variable V_OBJECT_ID type of ID_OBJECT;
declare variable V_NEW_STATUS_SIGN type of SIGN_ATTR;
declare variable V_ACTION_ID type of ID_ACTION;
declare variable V_ACTIONTREEITEM_ID type of ID_ACTIONTREEITEM;
declare variable V_NEW_FLAG_SIGN type of SIGN_OBJECT;
begin
  select o_value from param_get(:i_param_id, 'NEW.STATUS_SIGN') into :v_new_status_sign;
  select o_value from param_get(:v_param_id, 'NEW.FLAG_SIGN') into :v_new_flag_sign;
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

    select o_action_sign from action_detect(:i_object_sign, :v_object_id, :v_new_status_sign, :v_new_flag_sign, 0)
      into :v_action_sign;

    if (:v_action_sign is null) then
      select o_value from param_get(:i_param_id, 'ACTION_SIGN') into :v_action_sign;

    if (v_action_sign is not null) then
      execute procedure action_run(:i_object_sign, :v_action_sign, :v_param_id, :v_object_id)
        returning_values :v_action_id;
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
declare variable V_NEW_FLAG_SIGN type of SIGN_OBJECT;
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
  select o_value from param_get(:v_param_id, 'NEW.FLAG_SIGN') into :v_new_flag_sign;

  if (i_action_sign is null) then
    select o_action_sign
      from action_detect(:i_object_sign, :i_object_id, :v_new_status_sign, :v_new_flag_sign, 1)
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

/* Restore proc. body: MONEY_EUR2BYR */
ALTER PROCEDURE MONEY_EUR2BYR(I_MONEY_EUR TYPE OF MONEY_EUR NOT NULL,
I_BYR2EUR TYPE OF MONEY_BYR NOT NULL)
 RETURNS(O_MONEY_BYR TYPE OF MONEY_BYR)
 AS
begin
  o_money_byr = round(:i_money_eur*:i_byr2eur, -1);
  suspend;
end
^

/* Restore proc. body: ORDER_UPDATECOST */
ALTER PROCEDURE ORDER_UPDATECOST(I_ORDER_ID TYPE OF ID_ORDER NOT NULL)
 AS
declare variable V_ORDERITEMS_COST type of MONEY_EUR;
declare variable V_ORDERTAXS_COST type of MONEY_EUR;
declare variable V_ORDERMONEYS_COST type of MONEY_EUR;
begin
  select coalesce(sum(oi.cost_eur), 0)
    from orderitems oi
    where oi.order_id = :i_order_id
    into :v_orderitems_cost;

  select coalesce(sum(ot.cost_eur), 0)
    from ordertaxs ot
    where ot.order_id = :i_order_id
    into :v_ordertaxs_cost;

  select coalesce(sum(om.amount_eur), 0)
    from ordermoneys om
    where om.order_id = :i_order_id
    into :v_ordermoneys_cost;

  update orders o
    set o.cost_eur = :v_orderitems_cost+:v_ordertaxs_cost-:v_ordermoneys_cost
    where o.order_id = :i_order_id;
end
^

/* Creating trigger... */
CREATE TRIGGER ORDERITEMS_AIUD0 FOR ORDERITEMS
ACTIVE AFTER INSERT OR UPDATE OR DELETE POSITION 0 
AS
begin
  if ((inserting) or (deleting) or (new.cost_eur <> old.cost_eur)) then
      execute procedure order_updatecost(new.order_id);
end
^

CREATE TRIGGER ORDERMONEYS_AIUD0 FOR ORDERMONEYS
ACTIVE AFTER INSERT OR UPDATE OR DELETE POSITION 0 
AS
begin
  if ((inserting) or (deleting) or (new.amount_eur <> old.amount_eur)) then
      execute procedure order_updatecost(new.order_id);
end
^

CREATE TRIGGER ORDERTAXS_AIUD0 FOR ORDERTAXS
ACTIVE AFTER INSERT OR UPDATE OR DELETE POSITION 0 
AS
begin
  if ((inserting) or (deleting) or (new.cost_eur <> old.cost_eur)) then
      execute procedure order_updatecost(new.order_id);
end
^


/* Create Views... */
/* Create view: V_ORDERITEMS_RETURNING */
SET TERM ; ^

CREATE VIEW V_ORDERITEMS_RETURNING(
PRODUCT_ID,
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
select o.product_id
  , oi.orderitem_id
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


/* Altering existing trigger... */
SET TERM ^ ;

ALTER TRIGGER ORDERS_BU0
AS
begin
  if (old.status_id <> new.status_id) then
  begin
    new.status_dtm = current_timestamp;
    new.state_id = null;
  end

  if (old.cost_eur <> new.cost_eur) then
    select o_money_byr from money_eur2byr(new.cost_eur, new.byr2eur) into new.cost_byr;
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
declare variable V_NEW_FLAG_SIGN type of SIGN_OBJECT;
begin
  select o_value from param_get(:i_param_id, 'NEW.STATUS_SIGN') into :v_new_status_sign;
  select o_value from param_get(:v_param_id, 'NEW.FLAG_SIGN') into :v_new_flag_sign;
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

    select o_action_sign from action_detect(:i_object_sign, :v_object_id, :v_new_status_sign, :v_new_flag_sign, 0)
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
declare variable V_NEW_FLAG_SIGN type of SIGN_OBJECT;
begin
  select o_value from param_get(:i_param_id, 'NEW.STATUS_SIGN') into :v_new_status_sign;
  select o_value from param_get(:i_param_id, 'NEW.FLAG_SIGN') into :v_new_flag_sign;
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

    select o_action_sign from action_detect(:i_object_sign, :v_object_id, :v_new_status_sign, :v_new_flag_sign, 0)
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
declare variable V_NEW_FLAG_SIGN type of SIGN_OBJECT;
begin
  select o_value from param_get(:i_param_id, 'NEW.STATUS_SIGN') into :v_new_status_sign;
  select o_value from param_get(:i_param_id, 'NEW.FLAG_SIGN') into :v_new_flag_sign;
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

    select o_action_sign from action_detect(:i_object_sign, :v_object_id, :v_new_status_sign, :v_new_flag_sign, 0)
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
declare variable V_NEW_FLAG_SIGN type of SIGN_OBJECT;
begin
  select o_value from param_get(:i_param_id, 'NEW.STATUS_SIGN') into :v_new_status_sign;
  select o_value from param_get(:i_param_id, 'ACTIONTREEITEM_ID') into :v_actiontreeitem_id;
  select o_value from param_get(:i_param_id, 'NEW.FLAG_SIGN') into :v_new_flag_sign;

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
    select o_action_sign from action_detect(:i_object_sign, :v_object_id, :v_new_status_sign, :v_new_flag_sign, 0)
      into :v_action_sign;

    if (v_action_sign is not null) then
    begin
      execute procedure param_set(:v_param_id, 'TAXRATE_ID', :v_taxrate_id);
      execute procedure action_run(:i_object_sign, :v_action_sign, :v_param_id, :v_object_id)
        returning_values :v_action_id;
    end
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
declare variable V_NEW_FLAG_SIGN type of SIGN_OBJECT;
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
  select o_value from param_get(:v_param_id, 'NEW.FLAG_SIGN') into :v_new_flag_sign;

  if (i_action_sign is null) then
    select o_action_sign
      from action_detect(:i_object_sign, :i_object_id, :v_new_status_sign, :v_new_flag_sign, 1)
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

SET TERM ; ^

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

ALTER TABLE ORDERITEMS ALTER COLUMN AUFTRAG_ID POSITION 15;

ALTER TABLE ORDERITEMS ALTER COLUMN NAME_RUS POSITION 16;

ALTER TABLE ORDERITEMS ALTER COLUMN KIND_RUS POSITION 17;

ALTER TABLE ORDERITEMS ALTER COLUMN WEIGHT POSITION 18;

ALTER TABLE ORDERS ALTER COLUMN ORDER_ID POSITION 1;

ALTER TABLE ORDERS ALTER COLUMN ORDER_CODE POSITION 2;

ALTER TABLE ORDERS ALTER COLUMN PRODUCT_ID POSITION 3;

ALTER TABLE ORDERS ALTER COLUMN TAXPLAN_ID POSITION 4;

ALTER TABLE ORDERS ALTER COLUMN CLIENT_ID POSITION 5;

ALTER TABLE ORDERS ALTER COLUMN ACCOUNT_ID POSITION 6;

ALTER TABLE ORDERS ALTER COLUMN ADRESS_ID POSITION 7;

ALTER TABLE ORDERS ALTER COLUMN BYR2EUR POSITION 8;

ALTER TABLE ORDERS ALTER COLUMN CREATE_DTM POSITION 9;

ALTER TABLE ORDERS ALTER COLUMN STATE_ID POSITION 10;

ALTER TABLE ORDERS ALTER COLUMN STATUS_ID POSITION 11;

ALTER TABLE ORDERS ALTER COLUMN STATUS_DTM POSITION 12;

ALTER TABLE ORDERS ALTER COLUMN BAR_CODE POSITION 13;

ALTER TABLE ORDERS ALTER COLUMN USER_SIGN POSITION 14;

ALTER TABLE ORDERS ALTER COLUMN SOURCE POSITION 15;

ALTER TABLE ORDERS ALTER COLUMN COST_EUR POSITION 16;

ALTER TABLE ORDERS ALTER COLUMN COST_BYR POSITION 17;

/* Create(Add) privilege */
GRANT ALL ON V_ORDER_ATTRS TO ANNA;

GRANT ALL ON V_ORDER_ATTRS TO ELENA;

GRANT ALL ON V_ORDER_ATTRS TO KATYA;

GRANT ALL ON V_ORDER_ATTRS TO LENA;

GRANT ALL ON V_ORDER_ATTRS TO NASTYA;

GRANT ALL ON V_ORDER_ATTRS TO NASTYA17;

GRANT ALL ON V_ORDER_ATTRS TO NATVL;

GRANT ALL ON V_ORDER_ATTRS TO ND;

GRANT ALL ON V_ORDER_ATTRS TO PUBLIC;

GRANT ALL ON V_ORDER_ATTRS TO SVETLANA;

GRANT ALL ON V_ORDER_ATTRS TO SYSDBA WITH GRANT OPTION;

GRANT ALL ON V_ORDER_ATTRS TO USERS WITH GRANT OPTION;

GRANT ALL ON V_ORDER_ATTRS TO VALERY;

GRANT ALL ON V_ORDER_ATTRS TO YULYA;

GRANT ALL ON V_ORDER_FULL_SPECIFICATION TO ANNA;

GRANT ALL ON V_ORDER_FULL_SPECIFICATION TO ELENA;

GRANT ALL ON V_ORDER_FULL_SPECIFICATION TO KATYA;

GRANT ALL ON V_ORDER_FULL_SPECIFICATION TO LENA;

GRANT ALL ON V_ORDER_FULL_SPECIFICATION TO NASTYA;

GRANT ALL ON V_ORDER_FULL_SPECIFICATION TO NASTYA17;

GRANT ALL ON V_ORDER_FULL_SPECIFICATION TO NATVL;

GRANT ALL ON V_ORDER_FULL_SPECIFICATION TO ND;

GRANT ALL ON V_ORDER_FULL_SPECIFICATION TO PUBLIC;

GRANT ALL ON V_ORDER_FULL_SPECIFICATION TO SVETLANA;

GRANT ALL ON V_ORDER_FULL_SPECIFICATION TO SYSDBA WITH GRANT OPTION;

GRANT ALL ON V_ORDER_FULL_SPECIFICATION TO USERS WITH GRANT OPTION;

GRANT ALL ON V_ORDER_FULL_SPECIFICATION TO VALERY;

GRANT ALL ON V_ORDER_FULL_SPECIFICATION TO YULYA;

GRANT ALL ON V_ORDER_SUMMARY TO ANNA;

GRANT ALL ON V_ORDER_SUMMARY TO ELENA;

GRANT ALL ON V_ORDER_SUMMARY TO KATYA;

GRANT ALL ON V_ORDER_SUMMARY TO LENA;

GRANT ALL ON V_ORDER_SUMMARY TO NASTYA;

GRANT ALL ON V_ORDER_SUMMARY TO NASTYA17;

GRANT ALL ON V_ORDER_SUMMARY TO NATVL;

GRANT ALL ON V_ORDER_SUMMARY TO ND;

GRANT ALL ON V_ORDER_SUMMARY TO PUBLIC;

GRANT ALL ON V_ORDER_SUMMARY TO SVETLANA;

GRANT ALL ON V_ORDER_SUMMARY TO SYSDBA WITH GRANT OPTION;

GRANT ALL ON V_ORDER_SUMMARY TO USERS WITH GRANT OPTION;

GRANT ALL ON V_ORDER_SUMMARY TO VALERY;

GRANT ALL ON V_ORDER_SUMMARY TO YULYA;

GRANT ALL ON V_ORDERITEMS_RETURNING TO ANNA;

GRANT ALL ON V_ORDERITEMS_RETURNING TO ELENA;

GRANT ALL ON V_ORDERITEMS_RETURNING TO KATYA;

GRANT ALL ON V_ORDERITEMS_RETURNING TO LENA;

GRANT ALL ON V_ORDERITEMS_RETURNING TO NASTYA;

GRANT ALL ON V_ORDERITEMS_RETURNING TO NASTYA17;

GRANT ALL ON V_ORDERITEMS_RETURNING TO NATVL;

GRANT ALL ON V_ORDERITEMS_RETURNING TO ND;

GRANT ALL ON V_ORDERITEMS_RETURNING TO PUBLIC;

GRANT ALL ON V_ORDERITEMS_RETURNING TO SVETLANA;

GRANT ALL ON V_ORDERITEMS_RETURNING TO SYSDBA WITH GRANT OPTION;

GRANT ALL ON V_ORDERITEMS_RETURNING TO VALERY;

GRANT ALL ON V_ORDERITEMS_RETURNING TO YULYA;


