/* Server version: WI-V6.3.1.26351 Firebird 2.5 
   SQLDialect: 3. ODS: 11.2. Forced writes: On. Sweep inteval: 20000.
   Page size: 4096. Cache pages: 2048 (8192 Kb). Read-only: False. */
SET CLIENTLIB 'fbclient.dll';
SET NAMES CYRL;

SET SQL DIALECT 3;

SET AUTODDL ON;

/* Create Domains... */
CREATE DOMAIN ID_BONUS AS INTEGER;

/* Create Table... */
CREATE TABLE BONUSES(BONUS_ID ID_BONUS NOT NULL,
CLIENT_ID ID_CLIENT NOT NULL,
TAXSERV_ID ID_TAXSERV NOT NULL,
CREATE_DTM DTM_CREATE,
ORDERTAX_ID ID_TAX,
STATUS_ID ID_STATUS,
STATUS_DTM DTM_STATUS);



/* Alter Field (Null / Not Null)... */
UPDATE RDB$RELATION_FIELDS SET RDB$NULL_FLAG = NULL WHERE RDB$FIELD_NAME='CALCPOINT_ID' AND RDB$RELATION_NAME='TAXSERVS';


/* Create Procedure... */
SET TERM ^ ;

CREATE PROCEDURE ACT_BONUS_STORE(I_PARAM_ID TYPE OF ID_PARAM NOT NULL,
I_OBJECT_ID TYPE OF ID_OBJECT,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'BONUS')
 AS
 BEGIN EXIT; END
^

CREATE PROCEDURE ACT_BONUS_USE(I_PARAM_ID TYPE OF ID_PARAM NOT NULL,
I_OBJECT_ID TYPE OF ID_OBJECT NOT NULL,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'BONUS')
 AS
 BEGIN EXIT; END
^

CREATE PROCEDURE BONUS_MAKE(I_FIO TYPE OF NAME_REF NOT NULL,
I_TAXSERV_ID TYPE OF ID_TAX NOT NULL)
 RETURNS(O_ACTION_ID TYPE OF ID_BONUS)
 AS
 BEGIN SUSPEND; END
^


/* Create generator... */
SET TERM ; ^

CREATE GENERATOR SEQ_BONUS_ID;


/* Create Primary Key... */
ALTER TABLE BONUSES ADD CONSTRAINT PK_BONUSES PRIMARY KEY (BONUS_ID);

/* Create Foreign Key... */
RECONNECT;

ALTER TABLE BONUSES ADD CONSTRAINT FK_BONUSES_CLIENT_ID FOREIGN KEY (CLIENT_ID) REFERENCES CLIENTS (CLIENT_ID) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE BONUSES ADD CONSTRAINT FK_BONUSES_ORDERTAX_ID FOREIGN KEY (ORDERTAX_ID) REFERENCES ORDERTAXS (ORDERTAX_ID) ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE BONUSES ADD CONSTRAINT FK_BONUSES_STATUS_ID FOREIGN KEY (STATUS_ID) REFERENCES STATUSES (STATUS_ID) ON UPDATE CASCADE;

ALTER TABLE BONUSES ADD CONSTRAINT FK_BONUSES_TAXSERV_ID FOREIGN KEY (TAXSERV_ID) REFERENCES TAXSERVS (TAXSERV_ID) ON UPDATE CASCADE ON DELETE CASCADE;

/* Alter Procedure... */
/* empty dependent procedure body */
/* Clear: ACT_ORDER_DEBIT for: ACTION_RUN */
SET TERM ^ ;

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
/* Clear: ACTION_RUN for: ACTION_RUN */
ALTER PROCEDURE ACTION_RUN(I_OBJECT_SIGN /* TYPE OF SIGN_OBJECT */ VARCHAR(30),
I_ACTION_SIGN /* TYPE OF SIGN_ACTION */ VARCHAR(30),
I_PARAM_ID /* TYPE OF ID_PARAM */ BIGINT,
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
/* Clear: MONEY_TO_ORDER for: ACTION_RUN */
ALTER PROCEDURE MONEY_TO_ORDER(I_ORDER_CODE /* TYPE OF CODE_ORDER */ VARCHAR(10))
 AS
 BEGIN EXIT; END
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

/* Alter (PARAM_CRITERIA) */
ALTER PROCEDURE PARAM_CRITERIA(I_PARAM_ID TYPE OF ID_PARAM,
I_PARAM_NAME TYPE OF SIGN_OBJECT,
I_PARAM_ACTION TYPE OF SIGN_ACTION,
I_PARAM_DATATYPE TYPE OF KIND_PARAM,
I_PARAM_VALUE_1 TYPE OF VALUE_ATTR,
I_PARAM_VALUE_2 TYPE OF VALUE_ATTR)
 RETURNS(O_VALID TYPE OF BOOLEAN)
 AS
declare variable V_VALUE type of VALUE_ATTR;
begin
  if (not exists (select param_value
                    from params
                    where param_name = :i_param_name
                      and param_id = :i_param_id)) then
  begin
    o_valid = 0;
    if (:i_param_action = 'NOT EXISTS') then
      o_valid = 1;
  end
  else
  begin
    select param_value
      from params
      where param_name = :i_param_name
        and param_id = :i_param_id
      into :v_value;
    if (:i_param_datatype = 'N') then
    begin
      if ((:i_param_action = '=') and (cast(:v_value as numeric) = cast(:i_param_value_1 as numeric))) then
        o_valid = 1;
      else
      if ((:i_param_action = '<>') and (cast(:v_value as numeric) <> cast(:i_param_value_1 as numeric))) then
        o_valid = 1;
      else
      if ((:i_param_action = '>') and (cast(:v_value as numeric) > cast(:i_param_value_1 as numeric))) then
        o_valid = 1;
      else
      if ((:i_param_action = '<') and (cast(:v_value as numeric) < cast(:i_param_value_1 as numeric))) then
        o_valid = 1;
      else
      if ((:i_param_action = '>=') and (cast(:v_value as numeric) >= cast(:i_param_value_1 as numeric))) then
        o_valid = 1;
      else
      if ((:i_param_action = '<=') and (cast(:v_value as numeric) <= cast(:i_param_value_1 as numeric))) then
        o_valid = 1;
      else
      if ((:i_param_action = 'IS') and (:v_value is null)) then
        o_valid = 1;
      else
      if ((:i_param_action = 'IS NOT') and (:v_value is not null)) then
        o_valid = 1;
      else
      if ((:i_param_action = 'BETWEEN_[]') and (cast(:v_value as numeric) between cast(:i_param_value_1 as numeric) and cast(:i_param_value_2 as numeric))) then
        o_valid = 1;
    end
    else
    if (:i_param_datatype = 'S') then
    begin
      if ((:i_param_action = '=') and (cast(:v_value as value_attr) = cast(:i_param_value_1 as value_attr))) then
        o_valid = 1;
      else
      if ((:i_param_action = '<>') and (cast(:v_value as value_attr) <> cast(:i_param_value_1 as value_attr))) then
        o_valid = 1;
      else
      if ((:i_param_action = 'IS') and (:v_value is null)) then
        o_valid = 1;
      else
      if ((:i_param_action = 'IS NOT') and (:v_value is not null)) then
        o_valid = 1;
      else
      if ((:i_param_action = 'IN') and (','||cast(:i_param_value_1 as value_attr)||',' like '%,'||cast(:v_value as value_attr)||',%')) then
        o_valid = 1;
      else
      if ((:i_param_action = 'NOT IN') and (','||cast(:i_param_value_1 as value_attr)||',' not like '%,'||cast(:v_value as value_attr)||',%')) then
        o_valid = 1;
    end
  end
  suspend;
end
^

/* Restore proc. body: ACT_BONUS_STORE */
ALTER PROCEDURE ACT_BONUS_STORE(I_PARAM_ID TYPE OF ID_PARAM NOT NULL,
I_OBJECT_ID TYPE OF ID_OBJECT,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'BONUS')
 AS
declare variable V_NOW_STATUS_ID type of ID_STATUS;
declare variable V_UPDATEABLE type of VALUE_BOOLEAN;
declare variable V_NEW_STATUS_ID type of ID_STATUS;
declare variable V_TAXSERV_ID type of ID_TAX;
declare variable V_CLIENT_ID type of ID_CLIENT;
begin
  if (coalesce(i_object_id, 0) = 0) then i_object_id = gen_id(seq_bonus_id, 1);
    
  update paramheads set object_id = :i_object_id where param_id = :i_param_id;
    
  execute procedure param_set(:i_param_id, 'ID', :i_object_id);
    
  select status_id from bonuses b where b.bonus_id = :i_object_id into :v_now_status_id;

  if (:v_now_status_id is null) then
  begin
    select o_value from param_get(:i_param_id, 'TAXSERV_ID') into :v_taxserv_id;
    select o_value from param_get(:i_param_id, 'CLIENT_ID') into :v_client_id;

    insert into bonuses(bonus_id, client_id, taxserv_id, status_id)
      values(:i_object_id, :v_client_id, :v_taxserv_id, :v_new_status_id)
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
  else
    exception ex_status_conversion_unavail 'From '||:v_now_status_id||' to '||:v_new_status_id;

end
^

/* Restore proc. body: ACT_BONUS_USE */
ALTER PROCEDURE ACT_BONUS_USE(I_PARAM_ID TYPE OF ID_PARAM NOT NULL,
I_OBJECT_ID TYPE OF ID_OBJECT NOT NULL,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'BONUS')
 AS
declare variable V_NOW_STATUS_ID type of ID_STATUS;
declare variable V_ORDER_ID type of ID_ORDER;
declare variable V_UPDATEABLE type of VALUE_BOOLEAN;
declare variable V_NEW_STATUS_ID type of ID_STATUS;
declare variable V_TAXRATE_ID type of ID_TAX;
declare variable V_TAX_PROCEDURE type of NAME_PROCEDURE;
declare variable V_PRICE_EUR type of MONEY_EUR;
declare variable V_ORDERTAX_ID type of ID_TAX;
begin

  update paramheads set object_id = :i_object_id where param_id = :i_param_id;
    
  execute procedure param_set(:i_param_id, 'ID', :i_object_id);

  select o_value from param_get(:i_param_id, 'ORDER_ID') into :v_order_id;

  select status_id from bonuses b where b.bonus_id = :i_object_id into :v_now_status_id;
    
  select r.taxrate_id, r.tax_procedure
    from orders o
      inner join bonuses b on (b.client_id = o.client_id)
      inner join product2taxplan p2t on (p2t.product_id = o.product_id)
      inner join taxrates r on (r.taxplan_id = p2t.taxplan_id and r.taxserv_id = b.taxserv_id)
    into :v_taxrate_id, :v_tax_procedure;

  execute statement ('select o_cost_eur from '||v_tax_procedure||'(:taxrate_id, :param_id)')
    (taxrate_id := :v_taxrate_id, param_id := :i_param_id)
    into :v_price_eur;

  insert into ordertaxs(order_id, taxrate_id, status_id, price_eur)
    values(:v_order_id, :v_taxrate_id, :v_new_status_id, -:v_price_eur)
    returning ordertax_id
    into :v_ordertax_id;

  select o_updateable, o_new_status_id
    from object_updateable(:i_param_id, :v_now_status_id, :i_object_sign)
    into :v_updateable, :v_new_status_id;

  update bonuses b
    set b.ordertax_id = :v_ordertax_id, b.status_id = :v_new_status_id
    where b.bonus_id = :i_object_id;
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

    select o_action_sign from action_detect(:i_object_sign, :v_object_id, :v_new_status_sign, :v_new_flag_sign)
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

    select o_action_sign from action_detect(:i_object_sign, :v_object_id, :v_new_status_sign, :v_new_flag_sign)
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

    select o_action_sign from action_detect(:i_object_sign, :v_object_id, :v_new_status_sign, :v_new_flag_sign)
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
    select o_action_sign from action_detect(:i_object_sign, :v_object_id, :v_new_status_sign, :v_new_flag_sign)
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
      from action_detect(:i_object_sign, :i_object_id, :v_new_status_sign, :v_new_flag_sign)
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

/* Restore proc. body: BONUS_MAKE */
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

/* Creating trigger... */
CREATE TRIGGER BONUSES_BI0 FOR BONUSES
ACTIVE BEFORE INSERT POSITION 0 
AS
begin
  if (new.bonus_id is null) then
    new.bonus_id = gen_id(seq_bonus_id, 1);
  if (new.status_id is null) then
    select o_status_id from status_get_default('BONUS') into new.status_id;
  if (new.create_dtm is null) then
    new.create_dtm = current_timestamp;
  new.status_dtm = current_timestamp;
end
^

CREATE TRIGGER BONUSES_BU0 FOR BONUSES
ACTIVE BEFORE UPDATE POSITION 0 
AS
begin
  if (old.status_id <> new.status_id) then
    new.status_dtm = current_timestamp;
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

    select o_action_sign from action_detect(:i_object_sign, :v_object_id, :v_new_status_sign, :v_new_flag_sign)
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

    select o_action_sign from action_detect(:i_object_sign, :v_object_id, :v_new_status_sign, :v_new_flag_sign)
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

    select o_action_sign from action_detect(:i_object_sign, :v_object_id, :v_new_status_sign, :v_new_flag_sign)
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
    select o_action_sign from action_detect(:i_object_sign, :v_object_id, :v_new_status_sign, :v_new_flag_sign)
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
      from action_detect(:i_object_sign, :i_object_id, :v_new_status_sign, :v_new_flag_sign)
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

/* DROP: -- GRANT ALL ON ACCOPERS TO SVETLANA */
SET TERM ; ^

REVOKE ALL ON ACCOPERS FROM SVETLANA;

/* DROP: -- GRANT ALL ON ACCOUNTS TO SVETLANA */
REVOKE ALL ON ACCOUNTS FROM SVETLANA;

/* DROP: -- GRANT ALL ON ACCRESTS TO SVETLANA */
REVOKE ALL ON ACCRESTS FROM SVETLANA;

/* DROP: -- GRANT ALL ON ACTION_ATTRS TO SVETLANA */
REVOKE ALL ON ACTION_ATTRS FROM SVETLANA;

/* DROP: -- GRANT ALL ON ACTIONCODE_CRITERIAS TO SVETLANA */
REVOKE ALL ON ACTIONCODE_CRITERIAS FROM SVETLANA;

/* DROP: -- GRANT ALL ON ACTIONCODE_PARAMS TO SVETLANA */
REVOKE ALL ON ACTIONCODE_PARAMS FROM SVETLANA;

/* DROP: -- GRANT ALL ON ACTIONCODES TO SVETLANA */
REVOKE ALL ON ACTIONCODES FROM SVETLANA;

/* DROP: -- GRANT ALL ON ACTIONS TO SVETLANA */
REVOKE ALL ON ACTIONS FROM SVETLANA;

/* DROP: -- GRANT ALL ON ACTIONTREE TO SVETLANA */
REVOKE ALL ON ACTIONTREE FROM SVETLANA;

/* DROP: -- GRANT ALL ON ACTIONTREE_CRITERIAS TO SVETLANA */
REVOKE ALL ON ACTIONTREE_CRITERIAS FROM SVETLANA;

/* DROP: -- GRANT ALL ON ACTIONTREE_PARAMS TO SVETLANA */
REVOKE ALL ON ACTIONTREE_PARAMS FROM SVETLANA;

/* DROP: -- GRANT ALL ON ADRESSES TO SVETLANA */
REVOKE ALL ON ADRESSES FROM SVETLANA;

/* DROP: -- GRANT ALL ON ARTICLE_ATTRS TO SVETLANA */
REVOKE ALL ON ARTICLE_ATTRS FROM SVETLANA;

/* DROP: -- GRANT ALL ON ARTICLECODE_ATTRS TO SVETLANA */
REVOKE ALL ON ARTICLECODE_ATTRS FROM SVETLANA;

/* DROP: -- GRANT ALL ON ARTICLECODES TO SVETLANA */
REVOKE ALL ON ARTICLECODES FROM SVETLANA;

/* DROP: -- GRANT ALL ON ARTICLEMASKS TO SVETLANA */
REVOKE ALL ON ARTICLEMASKS FROM SVETLANA;

/* DROP: -- GRANT ALL ON ARTICLES TO SVETLANA */
REVOKE ALL ON ARTICLES FROM SVETLANA;

/* DROP: -- GRANT ALL ON ARTICLESIGNS TO SVETLANA */
REVOKE ALL ON ARTICLESIGNS FROM SVETLANA;

/* DROP: -- GRANT ALL ON ATTRS TO SVETLANA */
REVOKE ALL ON ATTRS FROM SVETLANA;

/* DROP: -- GRANT ALL ON BUILDS TO SVETLANA */
REVOKE ALL ON BUILDS FROM SVETLANA;

/* DROP: -- GRANT ALL ON CALCPOINTS TO SVETLANA */
REVOKE ALL ON CALCPOINTS FROM SVETLANA;

/* DROP: -- GRANT ALL ON CATALOG2PLUGIN TO SVETLANA */
REVOKE ALL ON CATALOG2PLUGIN FROM SVETLANA;

/* DROP: -- GRANT ALL ON CATALOGS TO SVETLANA */
REVOKE ALL ON CATALOGS FROM SVETLANA;

/* DROP: -- GRANT ALL ON CLIENT_ATTRS TO SVETLANA */
REVOKE ALL ON CLIENT_ATTRS FROM SVETLANA;

/* DROP: -- GRANT ALL ON CLIENTS TO SVETLANA */
REVOKE ALL ON CLIENTS FROM SVETLANA;

/* DROP: -- GRANT ALL ON COUNTERS TO SVETLANA */
REVOKE ALL ON COUNTERS FROM SVETLANA;

/* DROP: -- GRANT ALL ON DETECTOR TO SVETLANA */
REVOKE ALL ON DETECTOR FROM SVETLANA;

/* DROP: -- GRANT ALL ON EVENTCODES TO SVETLANA */
REVOKE ALL ON EVENTCODES FROM SVETLANA;

/* DROP: -- GRANT ALL ON EVENTS TO SVETLANA */
REVOKE ALL ON EVENTS FROM SVETLANA;

/* DROP: -- GRANT ALL ON FLAGS TO SVETLANA */
REVOKE ALL ON FLAGS FROM SVETLANA;

/* DROP: -- GRANT ALL ON FLAGS2STATUSES TO SVETLANA */
REVOKE ALL ON FLAGS2STATUSES FROM SVETLANA;

/* DROP: -- GRANT ALL ON IMP_CLIENT3 TO SVETLANA */
REVOKE ALL ON IMP_CLIENT3 FROM SVETLANA;

/* DROP: -- GRANT ALL ON LOGS TO SVETLANA */
REVOKE ALL ON LOGS FROM SVETLANA;

/* DROP: -- GRANT ALL ON MAGAZINES TO SVETLANA */
REVOKE ALL ON MAGAZINES FROM SVETLANA;

/* DROP: -- GRANT ALL ON MESSAGE_ATTRS TO SVETLANA */
REVOKE ALL ON MESSAGE_ATTRS FROM SVETLANA;

/* DROP: -- GRANT ALL ON MESSAGES TO SVETLANA */
REVOKE ALL ON MESSAGES FROM SVETLANA;

/* DROP: -- GRANT ALL ON MONEYBACK_ATTRS TO SVETLANA */
REVOKE ALL ON MONEYBACK_ATTRS FROM SVETLANA;

/* DROP: -- GRANT ALL ON MONEYBACKS TO SVETLANA */
REVOKE ALL ON MONEYBACKS FROM SVETLANA;

/* DROP: -- GRANT ALL ON NOTIFIES TO SVETLANA */
REVOKE ALL ON NOTIFIES FROM SVETLANA;

/* DROP: -- GRANT ALL ON OBJECTS TO SVETLANA */
REVOKE ALL ON OBJECTS FROM SVETLANA;

/* DROP: -- GRANT ALL ON ORDER_ATTRS TO SVETLANA */
REVOKE ALL ON ORDER_ATTRS FROM SVETLANA;

/* DROP: -- GRANT ALL ON ORDERHISTORY TO SVETLANA */
REVOKE ALL ON ORDERHISTORY FROM SVETLANA;

/* DROP: -- GRANT ALL ON ORDERITEM_ATTRS TO SVETLANA */
REVOKE ALL ON ORDERITEM_ATTRS FROM SVETLANA;

/* DROP: -- GRANT ALL ON ORDERITEMS TO SVETLANA */
REVOKE ALL ON ORDERITEMS FROM SVETLANA;

/* DROP: -- GRANT ALL ON ORDERMONEYS TO SVETLANA */
REVOKE ALL ON ORDERMONEYS FROM SVETLANA;

/* DROP: -- GRANT ALL ON ORDERS TO SVETLANA */
REVOKE ALL ON ORDERS FROM SVETLANA;

/* DROP: -- GRANT ALL ON ORDERTAXS TO SVETLANA */
REVOKE ALL ON ORDERTAXS FROM SVETLANA;

/* DROP: -- GRANT ALL ON PARAMACTIONS TO SVETLANA */
REVOKE ALL ON PARAMACTIONS FROM SVETLANA;

/* DROP: -- GRANT ALL ON PARAMHEADS TO SVETLANA */
REVOKE ALL ON PARAMHEADS FROM SVETLANA;

/* DROP: -- GRANT ALL ON PARAMKINDS TO SVETLANA */
REVOKE ALL ON PARAMKINDS FROM SVETLANA;

/* DROP: -- GRANT ALL ON PARAMS TO SVETLANA */
REVOKE ALL ON PARAMS FROM SVETLANA;

/* DROP: -- GRANT ALL ON PAYMENTS TO SVETLANA */
REVOKE ALL ON PAYMENTS FROM SVETLANA;

/* DROP: -- GRANT ALL ON PLACES TO SVETLANA */
REVOKE ALL ON PLACES FROM SVETLANA;

/* DROP: -- GRANT ALL ON PLACETYPES TO SVETLANA */
REVOKE ALL ON PLACETYPES FROM SVETLANA;

/* DROP: -- GRANT ALL ON PLUGIN_PARAMS TO SVETLANA */
REVOKE ALL ON PLUGIN_PARAMS FROM SVETLANA;

/* DROP: -- GRANT ALL ON PLUGINS TO SVETLANA */
REVOKE ALL ON PLUGINS FROM SVETLANA;

/* DROP: -- GRANT ALL ON PORT2TEMPLATE TO SVETLANA */
REVOKE ALL ON PORT2TEMPLATE FROM SVETLANA;

/* DROP: -- GRANT ALL ON PORTS TO SVETLANA */
REVOKE ALL ON PORTS FROM SVETLANA;

/* DROP: -- GRANT ALL ON PRODUCT_ATTRS TO SVETLANA */
REVOKE ALL ON PRODUCT_ATTRS FROM SVETLANA;

/* DROP: -- GRANT ALL ON PRODUCT2TAXPLAN TO SVETLANA */
REVOKE ALL ON PRODUCT2TAXPLAN FROM SVETLANA;

/* DROP: -- GRANT ALL ON PRODUCTS TO SVETLANA */
REVOKE ALL ON PRODUCTS FROM SVETLANA;

/* DROP: -- GRANT ALL ON RECODES TO SVETLANA */
REVOKE ALL ON RECODES FROM SVETLANA;

/* DROP: -- GRANT ALL ON SEARCHES TO SVETLANA */
REVOKE ALL ON SEARCHES FROM SVETLANA;

/* DROP: -- GRANT ALL ON SESSIONS TO SVETLANA */
REVOKE ALL ON SESSIONS FROM SVETLANA;

/* DROP: -- GRANT ALL ON SETTINGS TO SVETLANA */
REVOKE ALL ON SETTINGS FROM SVETLANA;

/* DROP: -- GRANT ALL ON SETTINGSIGNS TO SVETLANA */
REVOKE ALL ON SETTINGSIGNS FROM SVETLANA;

/* DROP: -- GRANT ALL ON STATUS_RULES TO SVETLANA */
REVOKE ALL ON STATUS_RULES FROM SVETLANA;

/* DROP: -- GRANT ALL ON STATUSES TO SVETLANA */
REVOKE ALL ON STATUSES FROM SVETLANA;

/* DROP: -- GRANT ALL ON STREETTYPES TO SVETLANA */
REVOKE ALL ON STREETTYPES FROM SVETLANA;

/* DROP: -- GRANT ALL ON TAXPLANS TO SVETLANA */
REVOKE ALL ON TAXPLANS FROM SVETLANA;

/* DROP: -- GRANT ALL ON TAXRATE_ATTRS TO SVETLANA */
REVOKE ALL ON TAXRATE_ATTRS FROM SVETLANA;

/* DROP: -- GRANT ALL ON TAXRATES TO SVETLANA */
REVOKE ALL ON TAXRATES FROM SVETLANA;

/* DROP: -- GRANT ALL ON TAXSERVS TO SVETLANA */
REVOKE ALL ON TAXSERVS FROM SVETLANA;

/* DROP: -- GRANT ALL ON TEMPLATES TO SVETLANA */
REVOKE ALL ON TEMPLATES FROM SVETLANA;

/* DROP: -- GRANT ALL ON TMP_OTTO_ARTICLE TO SVETLANA */
REVOKE ALL ON TMP_OTTO_ARTICLE FROM SVETLANA;

/* DROP: -- GRANT ALL ON TMP_SEARCHES TO SVETLANA */
REVOKE ALL ON TMP_SEARCHES FROM SVETLANA;

/* DROP: -- GRANT ALL ON USERS TO SVETLANA */
REVOKE ALL ON USERS FROM SVETLANA;

/* DROP: -- GRANT ALL ON V_ACCRESTS TO SVETLANA */
REVOKE ALL ON V_ACCRESTS FROM SVETLANA;

/* DROP: -- GRANT ALL ON V_ACTION_ATTRS TO SVETLANA */
REVOKE ALL ON V_ACTION_ATTRS FROM SVETLANA;

/* DROP: -- GRANT ALL ON V_ADRESS_TEXT TO SVETLANA */
REVOKE ALL ON V_ADRESS_TEXT FROM SVETLANA;

/* DROP: -- GRANT ALL ON V_ARTICLES TO SVETLANA */
REVOKE ALL ON V_ARTICLES FROM SVETLANA;

/* DROP: -- GRANT ALL ON V_ATTRINPARAM TO SVETLANA */
REVOKE ALL ON V_ATTRINPARAM FROM SVETLANA;

/* DROP: -- GRANT ALL ON V_CLIENT_ATTRS TO SVETLANA */
REVOKE ALL ON V_CLIENT_ATTRS FROM SVETLANA;

/* DROP: -- GRANT ALL ON V_CLIENT_BANKINFO TO SVETLANA */
REVOKE ALL ON V_CLIENT_BANKINFO FROM SVETLANA;

/* DROP: -- GRANT ALL ON V_CLIENTADRESS TO SVETLANA */
REVOKE ALL ON V_CLIENTADRESS FROM SVETLANA;

/* DROP: -- GRANT ALL ON V_CLIENTS_FIO TO SVETLANA */
REVOKE ALL ON V_CLIENTS_FIO FROM SVETLANA;

/* DROP: -- GRANT ALL ON V_MONEYBACK_ATTRS TO SVETLANA */
REVOKE ALL ON V_MONEYBACK_ATTRS FROM SVETLANA;

/* DROP: -- GRANT ALL ON V_MONEYBACK_BANK TO SVETLANA */
REVOKE ALL ON V_MONEYBACK_BANK FROM SVETLANA;

/* DROP: -- GRANT ALL ON V_MONEYBACK_BELPOST TO SVETLANA */
REVOKE ALL ON V_MONEYBACK_BELPOST FROM SVETLANA;

/* DROP: -- GRANT ALL ON V_ORDER_ATTRS TO SVETLANA */
REVOKE ALL ON V_ORDER_ATTRS FROM SVETLANA;

/* DROP: -- GRANT ALL ON V_ORDER_FULL_SPECIFICATION TO SVETLANA */
REVOKE ALL ON V_ORDER_FULL_SPECIFICATION FROM SVETLANA;

/* DROP: -- GRANT ALL ON V_ORDER_INVOICEABLE TO SVETLANA */
REVOKE ALL ON V_ORDER_INVOICEABLE FROM SVETLANA;

/* DROP: -- GRANT ALL ON V_ORDER_PAID TO SVETLANA */
REVOKE ALL ON V_ORDER_PAID FROM SVETLANA;

/* DROP: -- GRANT ALL ON V_ORDER_SUMMARY TO SVETLANA */
REVOKE ALL ON V_ORDER_SUMMARY FROM SVETLANA;

/* DROP: -- GRANT ALL ON V_ORDERITEM_ATTRS TO SVETLANA */
REVOKE ALL ON V_ORDERITEM_ATTRS FROM SVETLANA;

/* DROP: -- GRANT ALL ON V_ORDERITEMS_RETURNING TO SVETLANA */
REVOKE ALL ON V_ORDERITEMS_RETURNING FROM SVETLANA;

/* DROP: -- GRANT ALL ON V_ORDERS TO SVETLANA */
REVOKE ALL ON V_ORDERS FROM SVETLANA;

/* DROP: -- GRANT ALL ON V_PLACE_TEXT TO SVETLANA */
REVOKE ALL ON V_PLACE_TEXT FROM SVETLANA;

/* DROP: -- GRANT ALL ON V_PLACES TO SVETLANA */
REVOKE ALL ON V_PLACES FROM SVETLANA;

/* DROP: -- GRANT ALL ON V_PRODUCT_ATTRS TO SVETLANA */
REVOKE ALL ON V_PRODUCT_ATTRS FROM SVETLANA;

/* DROP: -- GRANT ALL ON V_SETTINGS TO SVETLANA */
REVOKE ALL ON V_SETTINGS FROM SVETLANA;

/* DROP: -- GRANT ALL ON V_STATUS_AVAILABLE TO SVETLANA */
REVOKE ALL ON V_STATUS_AVAILABLE FROM SVETLANA;

/* DROP: -- GRANT ALL ON V_STATUSES TO SVETLANA */
REVOKE ALL ON V_STATUSES FROM SVETLANA;

/* DROP: -- GRANT ALL ON V_TAXRATE_ATTRS TO SVETLANA */
REVOKE ALL ON V_TAXRATE_ATTRS FROM SVETLANA;

/* DROP: -- GRANT ALL ON VALUTES TO SVETLANA */
REVOKE ALL ON VALUTES FROM SVETLANA;

/* DROP: -- GRANT ALL ON VENDORS TO SVETLANA */
REVOKE ALL ON VENDORS FROM SVETLANA;

/* DROP: -- GRANT ALL ON WAYS TO SVETLANA */
REVOKE ALL ON WAYS FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE AALL_CLEAR TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE AALL_CLEAR FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACCOUNT_X_SEARCH TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ACCOUNT_X_SEARCH FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_ACCOUNT_CREDIT TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ACT_ACCOUNT_CREDIT FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_ACCOUNT_CREDITORDER TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ACT_ACCOUNT_CREDITORDER FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_ACCOUNT_DEBIT TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ACT_ACCOUNT_DEBIT FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_ACCOUNT_DEBITORDER TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ACT_ACCOUNT_DEBITORDER FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_ACCOUNT_PAYMENTIN TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ACT_ACCOUNT_PAYMENTIN FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_ACCOUNT_PAYMENTOUT TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ACT_ACCOUNT_PAYMENTOUT FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_ACCOUNT_STORE TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ACT_ACCOUNT_STORE FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_ADRESS_STORE TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ACT_ADRESS_STORE FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_CLIENT_STORE TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ACT_CLIENT_STORE FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_EVENT_STORE TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ACT_EVENT_STORE FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_MAGAZINE_STORE TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ACT_MAGAZINE_STORE FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_MESSAGE_STORE TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ACT_MESSAGE_STORE FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_MONEYBACK_STORE TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ACT_MONEYBACK_STORE FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_ORDER_DEBIT TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ACT_ORDER_DEBIT FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_ORDER_FOREACH_ORDERITEM TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ACT_ORDER_FOREACH_ORDERITEM FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_ORDER_FOREACH_ORDERTAX TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ACT_ORDER_FOREACH_ORDERTAX FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_ORDER_FOREACH_TAXRATE TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ACT_ORDER_FOREACH_TAXRATE FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_ORDER_STORE TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ACT_ORDER_STORE FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_ORDERITEM_STORE TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ACT_ORDERITEM_STORE FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_ORDERMONEY_CREDIT TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ACT_ORDERMONEY_CREDIT FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_ORDERMONEY_DEBIT TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ACT_ORDERMONEY_DEBIT FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_ORDERMONEY_STORE TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ACT_ORDERMONEY_STORE FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_ORDERTAX_STORE TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ACT_ORDERTAX_STORE FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_PAYMENT_STORE TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ACT_PAYMENT_STORE FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_PLACE_STORE TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ACT_PLACE_STORE FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACTION_DETECT TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ACTION_DETECT FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACTION_EXECUTE TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ACTION_EXECUTE FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACTION_REEXECUTE TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ACTION_REEXECUTE FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACTION_RERUN TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ACTION_RERUN FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACTION_RERUN_ACTION TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ACTION_RERUN_ACTION FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACTION_RUN TO PROCEDURE MONEY_TO_ORDER */
REVOKE EXECUTE ON PROCEDURE ACTION_RUN FROM PROCEDURE MONEY_TO_ORDER;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACTION_RUN TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ACTION_RUN FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ARTICLE_GOC TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ARTICLE_GOC FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ARTICLECODE_GOC TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ARTICLECODE_GOC FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ARTICLES_PUMP TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ARTICLES_PUMP FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ARTICLESIGN_DETECT TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ARTICLESIGN_DETECT FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ATTR_PUT TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ATTR_PUT FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE CLIENTS_KILL TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE CLIENTS_KILL FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE COUNTER_NEXTVAL TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE COUNTER_NEXTVAL FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE DB_CLEANUP TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE DB_CLEANUP FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE LOG_CREATE TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE LOG_CREATE FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE LOG_UPDATE TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE LOG_UPDATE FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE LOG_UPDATE_SKIPED TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE LOG_UPDATE_SKIPED FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE MAGAZINE_DETECT TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE MAGAZINE_DETECT FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE MESSAGE_BUSY TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE MESSAGE_BUSY FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE MESSAGE_BUSY_2 TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE MESSAGE_BUSY_2 FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE MESSAGE_CREATE TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE MESSAGE_CREATE FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE MESSAGE_READ TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE MESSAGE_READ FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE MESSAGE_RELEASE TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE MESSAGE_RELEASE FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE MONEYBACK_READ TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE MONEYBACK_READ FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE MONEYBACK_X_PURPOSE TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE MONEYBACK_X_PURPOSE FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE NOTIFY_CREATE TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE NOTIFY_CREATE FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE OBJECT_GET TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE OBJECT_GET FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE OBJECT_PUT TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE OBJECT_PUT FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE OBJECT_READ TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE OBJECT_READ FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE OBJECT_UPDATEABLE TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE OBJECT_UPDATEABLE FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ORDER_ANUL TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ORDER_ANUL FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ORDER_READ TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ORDER_READ FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ORDER_X_ACTIVEITEMSCOUNT TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ORDER_X_ACTIVEITEMSCOUNT FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ORDER_X_UNINVOICED TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ORDER_X_UNINVOICED FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ORDERHISTORY_UPDATE TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ORDERHISTORY_UPDATE FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ORDERITEM_READ TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ORDERITEM_READ FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ORDERITEM_X_GETSTATEID TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ORDERITEM_X_GETSTATEID FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ORDERTAX_READ TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE ORDERTAX_READ FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE PARAM_CALC_IN TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE PARAM_CALC_IN FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE PARAM_CALC_OUT TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE PARAM_CALC_OUT FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE PARAM_CLONE TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE PARAM_CLONE FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE PARAM_CREATE TO PROCEDURE MONEY_TO_ORDER */
REVOKE EXECUTE ON PROCEDURE PARAM_CREATE FROM PROCEDURE MONEY_TO_ORDER;

/* DROP: -- GRANT EXECUTE ON PROCEDURE PARAM_CREATE TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE PARAM_CREATE FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE PARAM_CRITERIA TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE PARAM_CRITERIA FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE PARAM_DEL TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE PARAM_DEL FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE PARAM_FILLPATTERN TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE PARAM_FILLPATTERN FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE PARAM_GET TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE PARAM_GET FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE PARAM_MERGE TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE PARAM_MERGE FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE PARAM_PARSE TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE PARAM_PARSE FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE PARAM_PARSE_4ACTION TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE PARAM_PARSE_4ACTION FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE PARAM_SET TO PROCEDURE MONEY_TO_ORDER */
REVOKE EXECUTE ON PROCEDURE PARAM_SET FROM PROCEDURE MONEY_TO_ORDER;

/* DROP: -- GRANT EXECUTE ON PROCEDURE PARAM_SET TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE PARAM_SET FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE PARAM_UNPARSE TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE PARAM_UNPARSE FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE PIVOT_RECORD TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE PIVOT_RECORD FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE PLACE_DETECT TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE PLACE_DETECT FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE PLACE_READ TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE PLACE_READ FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE PLUGIN_VALUE TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE PLUGIN_VALUE FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE SEARCH TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE SEARCH FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE SEARCH_GET_NGRAMM TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE SEARCH_GET_NGRAMM FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE SETTING_GET TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE SETTING_GET FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE SETTING_SET TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE SETTING_SET FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE SPLITBLOB TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE SPLITBLOB FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE SPLITSTRING TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE SPLITSTRING FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE STATUS_CHECK_CONVERSION TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE STATUS_CHECK_CONVERSION FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE STATUS_CONVERSION_BY_FLAG TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE STATUS_CONVERSION_BY_FLAG FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE STATUS_GET_CONVERSION TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE STATUS_GET_CONVERSION FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE STATUS_GET_DEFAULT TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE STATUS_GET_DEFAULT FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE STATUS_STORE_DATE TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE STATUS_STORE_DATE FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE TAX_ENTERED_SUM TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE TAX_ENTERED_SUM FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE TAX_FIXED_SUM TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE TAX_FIXED_SUM FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE TAX_USE_REST TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE TAX_USE_REST FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE TAX_WEIGHT TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE TAX_WEIGHT FROM SVETLANA;

/* DROP: -- GRANT EXECUTE ON PROCEDURE TAXRATE_CALC TO SVETLANA */
REVOKE EXECUTE ON PROCEDURE TAXRATE_CALC FROM SVETLANA;

/* DROP: -- GRANT SELECT ON ACCRESTS TO PROCEDURE MONEY_TO_ORDER */
REVOKE SELECT ON ACCRESTS FROM PROCEDURE MONEY_TO_ORDER;

/* DROP: -- GRANT SELECT ON ORDERS TO PROCEDURE MONEY_TO_ORDER */
REVOKE SELECT ON ORDERS FROM PROCEDURE MONEY_TO_ORDER;

/* DROP: -- GRANT SELECT ON V_ORDER_SUMMARY TO PROCEDURE MONEY_TO_ORDER */
REVOKE SELECT ON V_ORDER_SUMMARY FROM PROCEDURE MONEY_TO_ORDER;

/* Create(Add) privilege */
GRANT ALL ON BONUSES TO SYSDBA WITH GRANT OPTION;

GRANT ALL ON USERS TO YULYA;


