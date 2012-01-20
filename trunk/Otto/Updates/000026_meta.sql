/* Server version: WI-V6.3.1.26351 Firebird 2.5 
   SQLDialect: 3. ODS: 11.2. Forced writes: On. Sweep inteval: 20000.
   Page size: 4096. Cache pages: 2048 (8192 Kb). Read-only: False. */
SET CLIENTLIB 'fbclient.dll';
SET NAMES CYRL;

SET SQL DIALECT 3;


SET AUTODDL ON;

ALTER TABLE NOTIFIES DROP CONSTRAINT FK_NOTIFIES_PARAM;

ALTER TABLE MESSAGES DROP CONSTRAINT FK_MESSAGES_SESSION;

/* Alter Procedure (Before Drop)... */
SET TERM ^ ;

ALTER PROCEDURE NOTIFY_QUERY(I_MESSAGE_ID /* TYPE OF ID_MESSAGE */ INTEGER)
 RETURNS(O_NOTIFY_TEXT /* TYPE OF VALUE_ATTR */ VARCHAR(4000),
O_NOTIFY_CLASS /* TYPE OF VALUE_CHAR */ CHAR)
 AS
 BEGIN SUSPEND; END
^


/* Drop Procedure... */
SET TERM ; ^

DROP PROCEDURE NOTIFY_QUERY;


/* Drop table-fields... */
/* Empty NOTIFY_CREATE for drop NOTIFIES(PARAM_ID) */
SET TERM ^ ;

ALTER PROCEDURE NOTIFY_CREATE(I_MESSAGE_ID /* TYPE OF ID_MESSAGE */ INTEGER,
I_NOTIFY_TEXT /* TYPE OF VALUE_ATTR */ VARCHAR(4000),
I_PARAMS /* TYPE OF VALUE_BLOB */ BLOB SUB_TYPE 1 SEGMENT SIZE 100,
I_STATE /* TYPE OF VALUE_CHAR */ CHAR)
 RETURNS(O_NOTIFY_ID /* TYPE OF ID_NOTIFY */ INTEGER)
 AS
 BEGIN SUSPEND; END
^

SET TERM ; ^

ALTER TABLE NOTIFIES DROP PARAM_ID;


/* Create Procedure... */
SET TERM ^ ;

CREATE PROCEDURE ORDER_ANUL(I_ORDER_ID TYPE OF ID_ORDER NOT NULL)
 RETURNS(O_NEW_STATUS_SIGN TYPE OF SIGN_OBJECT)
 AS
 BEGIN SUSPEND; END
^


/* Alter Procedure... */
/* empty dependent procedure body */
/* Clear: ACTION_RUN for: ACT_ORDER_STORE */
ALTER PROCEDURE ACTION_RUN(I_OBJECT_SIGN /* TYPE OF SIGN_OBJECT */ VARCHAR(30),
I_ACTION_SIGN /* TYPE OF SIGN_ACTION */ VARCHAR(30),
I_PARAM_ID /* TYPE OF ID_PARAM */ BIGINT,
I_OBJECT_ID /* TYPE OF ID_OBJECT */ INTEGER)
 RETURNS(O_ACTION_ID /* TYPE OF ID_ACTION */ INTEGER)
 AS
 BEGIN SUSPEND; END
^

/* Alter (ACT_ORDER_STORE) */
ALTER PROCEDURE ACT_ORDER_STORE(I_PARAM_ID TYPE OF ID_PARAM,
I_OBJECT_ID TYPE OF ID_OBJECT,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ORDER')
 AS
declare variable V_NOW_STATUS_ID type of ID_STATUS;
declare variable V_NEW_STATUS_ID type of ID_STATUS;
declare variable V_UPDATEABLE type of VALUE_BOOLEAN;
declare variable V_CALCPOINT_ID type of ID_CALCPOINT;
declare variable V_NEW_STATE_SIGN type of SIGN_OBJECT;
declare variable V_NEW_STATE_ID type of ID_STATUS;
begin
  if (coalesce(i_object_id, 0) = 0) then i_object_id = gen_id(seq_order_id, 1);

  update paramheads set object_id = :i_object_id where param_id = :i_param_id;

  execute procedure param_set(:i_param_id, 'ID', :i_object_id);

  select oi.status_id from orders oi where oi.order_id = :i_object_id into :v_now_status_id;

  if (:v_now_status_id is null) then
  begin
    insert into orders(order_id, status_id)
      values(:i_object_id, :v_new_status_id)
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

  select o_value from param_get(:i_param_id,  'NEW.STATE_SIGN') into :v_new_state_sign;
  if (:v_new_state_sign is not null) then
  begin
    select s.status_id 
      from statuses s
      where s.object_sign = :i_object_sign
        and s.status_sign = :v_new_state_sign
      into :v_new_state_id;
    execute procedure param_set(:i_param_id, 'STATE_ID', :v_new_state_id);
  end

  if (v_updateable = 1) then
  begin
    select cp.calcpoint_id
      from calcpoints cp
      where cp.object_status_id = :v_new_status_id
      into :v_calcpoint_id;
    execute procedure param_set(:i_param_id, 'CALCPOINT_ID', :v_calcpoint_id);

    execute procedure param_set(:i_param_id, 'STATUS_ID', :v_new_status_id);
    execute procedure object_put(:i_param_id);

    execute procedure orderhistory_update(:i_object_id, :v_new_status_id, null);
  end
  else
    exception ex_status_conversion_unavail 'From '||:v_now_status_id||' to '||:v_new_status_id;
end
^

/* Alter (ACT_ORDERTAX_STORE) */
ALTER PROCEDURE ACT_ORDERTAX_STORE(I_PARAM_ID TYPE OF ID_PARAM,
I_OBJECT_ID TYPE OF ID_OBJECT,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ORDERTAX')
 AS
declare variable V_NOW_STATUS_ID type of ID_STATUS;
declare variable V_ORDER_ID type of ID_ORDER;
declare variable V_UPDATEABLE type of VALUE_BOOLEAN;
declare variable V_NEW_STATUS_ID type of ID_STATUS;
declare variable V_TAXRATE_ID type of ID_TAX;
declare variable V_TAXPLAN_ID type of ID_TAX;
declare variable V_TAX_PROCEDURE type of NAME_PROCEDURE;
declare variable V_PRICE_EUR type of MONEY_EUR;
declare variable V_AMOUNT type of VALUE_INTEGER;
declare variable V_CALCPOINT_ID type of ID_CALCPOINT;
begin
  if (coalesce(i_object_id, 0) = 0) then i_object_id = gen_id(seq_ordertax_id, 1);
    
  update paramheads set object_id = :i_object_id where param_id = :i_param_id;
    
  execute procedure param_set(:i_param_id, 'ID', :i_object_id);
    
  select status_id from ordertaxs where ordertax_id = :i_object_id into :v_now_status_id;

  if (:v_now_status_id is null) then
  begin
    select o_value from param_get(:i_param_id, 'TAXRATE_ID') into :v_taxrate_id;
    select o_value from param_get(:i_param_id, 'ORDER_ID') into :v_order_id;

    insert into ordertaxs(ordertax_id, order_id, taxrate_id, status_id)
      values(:i_object_id, :v_order_id, :v_taxrate_id, :v_new_status_id)
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

/* Alter (NOTIFY_CREATE) */
ALTER PROCEDURE NOTIFY_CREATE(I_MESSAGE_ID TYPE OF ID_MESSAGE,
I_NOTIFY_TEXT TYPE OF VALUE_ATTR,
I_PARAMS TYPE OF VALUE_BLOB,
I_STATE TYPE OF VALUE_CHAR)
 RETURNS(O_NOTIFY_ID TYPE OF ID_NOTIFY)
 AS
declare variable V_PARAM_ID type of ID_PARAM;
begin
  if (nullif(i_params, '') is not null) then
  begin
    select o_param_id from param_create('NOTIFY', :i_message_id) into :v_param_id;
    execute procedure param_unparse(:v_param_id, :i_params);
    select o_pattern from param_fillpattern(:v_param_id, :i_notify_text) into :i_notify_text;
  end


  insert into notifies(message_id, notify_text, notify_class)
    values(:i_message_id, :i_notify_text, upper(:i_state))
    returning notify_id
    into :o_notify_id;
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

/* Restore proc. body: ORDER_ANUL */
ALTER PROCEDURE ORDER_ANUL(I_ORDER_ID TYPE OF ID_ORDER NOT NULL)
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

/* Altering existing trigger... */
SET TERM ; ^

DROP TRIGGER REGISTER_SESSION;

SET TERM ^ ;

CREATE TRIGGER REGISTER_SESSION
INACTIVE ON CONNECT
 POSITION 0 
AS
begin
  delete from sessions where session_id >= current_connection;

  insert into sessions(session_id, user_name, start_dtm, finish_dtm)
    values(current_connection, current_user, current_timestamp, null);
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

SET TERM ; ^

ALTER TABLE NOTIFIES ALTER COLUMN NOTIFY_ID POSITION 1;

ALTER TABLE NOTIFIES ALTER COLUMN MESSAGE_ID POSITION 2;

ALTER TABLE NOTIFIES ALTER COLUMN NOTIFY_DTM POSITION 3;

ALTER TABLE NOTIFIES ALTER COLUMN NOTIFY_TEXT POSITION 4;

ALTER TABLE NOTIFIES ALTER COLUMN NOTIFY_CLASS POSITION 5;

/* DROP: -- GRANT ALL ON ACCOPERS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON ACCOPERS FROM VALERY;

/* DROP: -- GRANT ALL ON ACCOUNTS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON ACCOUNTS FROM VALERY;

/* DROP: -- GRANT ALL ON ACTION_ATTRS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON ACTION_ATTRS FROM VALERY;

/* DROP: -- GRANT ALL ON ACTIONCODE_CRITERIAS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON ACTIONCODE_CRITERIAS FROM VALERY;

/* DROP: -- GRANT ALL ON ACTIONCODE_PARAMS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON ACTIONCODE_PARAMS FROM VALERY;

/* DROP: -- GRANT ALL ON ACTIONCODES TO VALERY WITH GRANT OPTION */
REVOKE ALL ON ACTIONCODES FROM VALERY;

/* DROP: -- GRANT ALL ON ACTIONS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON ACTIONS FROM VALERY;

/* DROP: -- GRANT ALL ON ACTIONTREE TO VALERY WITH GRANT OPTION */
REVOKE ALL ON ACTIONTREE FROM VALERY;

/* DROP: -- GRANT ALL ON ACTIONTREE_CRITERIAS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON ACTIONTREE_CRITERIAS FROM VALERY;

/* DROP: -- GRANT ALL ON ACTIONTREE_PARAMS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON ACTIONTREE_PARAMS FROM VALERY;

/* DROP: -- GRANT ALL ON ADRESSES TO VALERY WITH GRANT OPTION */
REVOKE ALL ON ADRESSES FROM VALERY;

/* DROP: -- GRANT ALL ON ARTICLE_ATTRS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON ARTICLE_ATTRS FROM VALERY;

/* DROP: -- GRANT ALL ON ARTICLECODE_ATTRS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON ARTICLECODE_ATTRS FROM VALERY;

/* DROP: -- GRANT ALL ON ARTICLECODES TO VALERY WITH GRANT OPTION */
REVOKE ALL ON ARTICLECODES FROM VALERY;

/* DROP: -- GRANT ALL ON ARTICLEMASKS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON ARTICLEMASKS FROM VALERY;

/* DROP: -- GRANT ALL ON ARTICLES TO VALERY WITH GRANT OPTION */
REVOKE ALL ON ARTICLES FROM VALERY;

/* DROP: -- GRANT ALL ON ARTICLESIGNS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON ARTICLESIGNS FROM VALERY;

/* DROP: -- GRANT ALL ON ATTRS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON ATTRS FROM VALERY;

/* DROP: -- GRANT ALL ON BUILDS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON BUILDS FROM VALERY;

/* DROP: -- GRANT ALL ON CALCPOINTS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON CALCPOINTS FROM VALERY;

/* DROP: -- GRANT ALL ON CATALOG2PLUGIN TO VALERY WITH GRANT OPTION */
REVOKE ALL ON CATALOG2PLUGIN FROM VALERY;

/* DROP: -- GRANT ALL ON CATALOGS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON CATALOGS FROM VALERY;

/* DROP: -- GRANT ALL ON CLIENT_ATTRS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON CLIENT_ATTRS FROM VALERY;

/* DROP: -- GRANT ALL ON CLIENTS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON CLIENTS FROM VALERY;

/* DROP: -- GRANT ALL ON COUNTERS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON COUNTERS FROM VALERY;

/* DROP: -- GRANT ALL ON DETECTOR TO VALERY WITH GRANT OPTION */
REVOKE ALL ON DETECTOR FROM VALERY;

/* DROP: -- GRANT ALL ON EVENTCODES TO VALERY WITH GRANT OPTION */
REVOKE ALL ON EVENTCODES FROM VALERY;

/* DROP: -- GRANT ALL ON EVENTS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON EVENTS FROM VALERY;

/* DROP: -- GRANT ALL ON FLAGS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON FLAGS FROM VALERY;

/* DROP: -- GRANT ALL ON FLAGS2STATUSES TO VALERY WITH GRANT OPTION */
REVOKE ALL ON FLAGS2STATUSES FROM VALERY;

/* DROP: -- GRANT ALL ON IMP_CITYGET TO VALERY WITH GRANT OPTION */
REVOKE ALL ON IMP_CITYGET FROM VALERY;

/* DROP: -- GRANT ALL ON IMP_CITYTYPE TO VALERY WITH GRANT OPTION */
REVOKE ALL ON IMP_CITYTYPE FROM VALERY;

/* DROP: -- GRANT ALL ON IMP_CLIENT TO VALERY WITH GRANT OPTION */
REVOKE ALL ON IMP_CLIENT FROM VALERY;

/* DROP: -- GRANT ALL ON IMP_OBLAST TO VALERY WITH GRANT OPTION */
REVOKE ALL ON IMP_OBLAST FROM VALERY;

/* DROP: -- GRANT ALL ON IMP_REGION TO VALERY WITH GRANT OPTION */
REVOKE ALL ON IMP_REGION FROM VALERY;

/* DROP: -- GRANT ALL ON LOGS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON LOGS FROM VALERY;

/* DROP: -- GRANT ALL ON MAGAZINES TO VALERY WITH GRANT OPTION */
REVOKE ALL ON MAGAZINES FROM VALERY;

/* DROP: -- GRANT ALL ON MESSAGE_ATTRS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON MESSAGE_ATTRS FROM VALERY;

/* DROP: -- GRANT ALL ON MESSAGES TO VALERY WITH GRANT OPTION */
REVOKE ALL ON MESSAGES FROM VALERY;

/* DROP: -- GRANT ALL ON NOTIFIES TO VALERY WITH GRANT OPTION */
REVOKE ALL ON NOTIFIES FROM VALERY;

/* DROP: -- GRANT ALL ON OBJECTS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON OBJECTS FROM VALERY;

/* DROP: -- GRANT ALL ON ORDER_ATTRS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON ORDER_ATTRS FROM VALERY;

/* DROP: -- GRANT ALL ON ORDERHISTORY TO VALERY WITH GRANT OPTION */
REVOKE ALL ON ORDERHISTORY FROM VALERY;

/* DROP: -- GRANT ALL ON ORDERITEM_ATTRS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON ORDERITEM_ATTRS FROM VALERY;

/* DROP: -- GRANT ALL ON ORDERITEMS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON ORDERITEMS FROM VALERY;

/* DROP: -- GRANT ALL ON ORDERMONEYS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON ORDERMONEYS FROM VALERY;

/* DROP: -- GRANT ALL ON ORDERS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON ORDERS FROM VALERY;

/* DROP: -- GRANT ALL ON ORDERTAXS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON ORDERTAXS FROM VALERY;

/* DROP: -- GRANT ALL ON PARAMACTIONS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON PARAMACTIONS FROM VALERY;

/* DROP: -- GRANT ALL ON PARAMHEADS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON PARAMHEADS FROM VALERY;

/* DROP: -- GRANT ALL ON PARAMKINDS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON PARAMKINDS FROM VALERY;

/* DROP: -- GRANT ALL ON PARAMS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON PARAMS FROM VALERY;

/* DROP: -- GRANT ALL ON PAYMENTS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON PAYMENTS FROM VALERY;

/* DROP: -- GRANT ALL ON PHONEPREFIXES TO VALERY WITH GRANT OPTION */
REVOKE ALL ON PHONEPREFIXES FROM VALERY;

/* DROP: -- GRANT ALL ON PHONETYPES TO VALERY WITH GRANT OPTION */
REVOKE ALL ON PHONETYPES FROM VALERY;

/* DROP: -- GRANT ALL ON PLACES TO VALERY WITH GRANT OPTION */
REVOKE ALL ON PLACES FROM VALERY;

/* DROP: -- GRANT ALL ON PLACETYPES TO VALERY WITH GRANT OPTION */
REVOKE ALL ON PLACETYPES FROM VALERY;

/* DROP: -- GRANT ALL ON PLUGIN_PARAMS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON PLUGIN_PARAMS FROM VALERY;

/* DROP: -- GRANT ALL ON PLUGINS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON PLUGINS FROM VALERY;

/* DROP: -- GRANT ALL ON PORT2TEMPLATE TO VALERY WITH GRANT OPTION */
REVOKE ALL ON PORT2TEMPLATE FROM VALERY;

/* DROP: -- GRANT ALL ON PORTS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON PORTS FROM VALERY;

/* DROP: -- GRANT ALL ON PRODUCT_ATTRS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON PRODUCT_ATTRS FROM VALERY;

/* DROP: -- GRANT ALL ON PRODUCTS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON PRODUCTS FROM VALERY;

/* DROP: -- GRANT ALL ON RECODES TO VALERY WITH GRANT OPTION */
REVOKE ALL ON RECODES FROM VALERY;

/* DROP: -- GRANT ALL ON SEARCHES TO VALERY WITH GRANT OPTION */
REVOKE ALL ON SEARCHES FROM VALERY;

/* DROP: -- GRANT ALL ON SESSIONS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON SESSIONS FROM VALERY;

/* DROP: -- GRANT ALL ON SETTINGS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON SETTINGS FROM VALERY;

/* DROP: -- GRANT ALL ON SETTINGSIGNS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON SETTINGSIGNS FROM VALERY;

/* DROP: -- GRANT ALL ON STATUS_RULES TO VALERY WITH GRANT OPTION */
REVOKE ALL ON STATUS_RULES FROM VALERY;

/* DROP: -- GRANT ALL ON STATUSES TO VALERY WITH GRANT OPTION */
REVOKE ALL ON STATUSES FROM VALERY;

/* DROP: -- GRANT ALL ON STREETTYPES TO VALERY WITH GRANT OPTION */
REVOKE ALL ON STREETTYPES FROM VALERY;

/* DROP: -- GRANT ALL ON TAXPLANS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON TAXPLANS FROM VALERY;

/* DROP: -- GRANT ALL ON TAXRATE_ATTRS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON TAXRATE_ATTRS FROM VALERY;

/* DROP: -- GRANT ALL ON TAXRATES TO VALERY WITH GRANT OPTION */
REVOKE ALL ON TAXRATES FROM VALERY;

/* DROP: -- GRANT ALL ON TAXSERVS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON TAXSERVS FROM VALERY;

/* DROP: -- GRANT ALL ON TEMPLATES TO VALERY WITH GRANT OPTION */
REVOKE ALL ON TEMPLATES FROM VALERY;

/* DROP: -- GRANT ALL ON TMP_OTTO_ARTICLE TO VALERY WITH GRANT OPTION */
REVOKE ALL ON TMP_OTTO_ARTICLE FROM VALERY;

/* DROP: -- GRANT ALL ON TMP_SEARCHES TO VALERY WITH GRANT OPTION */
REVOKE ALL ON TMP_SEARCHES FROM VALERY;

/* DROP: -- GRANT ALL ON USERS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON USERS FROM VALERY;

/* DROP: -- GRANT ALL ON V_ACTION_ATTRS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON V_ACTION_ATTRS FROM VALERY;

/* DROP: -- GRANT ALL ON V_ADRESS_TEXT TO VALERY WITH GRANT OPTION */
REVOKE ALL ON V_ADRESS_TEXT FROM VALERY;

/* DROP: -- GRANT ALL ON V_ARTICLES TO VALERY WITH GRANT OPTION */
REVOKE ALL ON V_ARTICLES FROM VALERY;

/* DROP: -- GRANT ALL ON V_ATTRINPARAM TO VALERY WITH GRANT OPTION */
REVOKE ALL ON V_ATTRINPARAM FROM VALERY;

/* DROP: -- GRANT ALL ON V_CLIENT_ATTRS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON V_CLIENT_ATTRS FROM VALERY;

/* DROP: -- GRANT ALL ON V_CLIENTADRESS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON V_CLIENTADRESS FROM VALERY;

/* DROP: -- GRANT ALL ON V_CLIENTS_FIO TO VALERY WITH GRANT OPTION */
REVOKE ALL ON V_CLIENTS_FIO FROM VALERY;

/* DROP: -- GRANT ALL ON V_ORDER_ATTRS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON V_ORDER_ATTRS FROM VALERY;

/* DROP: -- GRANT ALL ON V_ORDER_FULL_SPECIFICATION TO VALERY WITH GRANT OPTION */
REVOKE ALL ON V_ORDER_FULL_SPECIFICATION FROM VALERY;

/* DROP: -- GRANT ALL ON V_ORDER_INVOICEABLE TO VALERY WITH GRANT OPTION */
REVOKE ALL ON V_ORDER_INVOICEABLE FROM VALERY;

/* DROP: -- GRANT ALL ON V_ORDER_PAID TO VALERY WITH GRANT OPTION */
REVOKE ALL ON V_ORDER_PAID FROM VALERY;

/* DROP: -- GRANT ALL ON V_ORDER_SUMMARY TO VALERY WITH GRANT OPTION */
REVOKE ALL ON V_ORDER_SUMMARY FROM VALERY;

/* DROP: -- GRANT ALL ON V_ORDERITEM_ATTRS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON V_ORDERITEM_ATTRS FROM VALERY;

/* DROP: -- GRANT ALL ON V_ORDERS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON V_ORDERS FROM VALERY;

/* DROP: -- GRANT ALL ON V_PLACE_TEXT TO VALERY WITH GRANT OPTION */
REVOKE ALL ON V_PLACE_TEXT FROM VALERY;

/* DROP: -- GRANT ALL ON V_PLACES TO VALERY WITH GRANT OPTION */
REVOKE ALL ON V_PLACES FROM VALERY;

/* DROP: -- GRANT ALL ON V_SETTINGS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON V_SETTINGS FROM VALERY;

/* DROP: -- GRANT ALL ON V_STATUS_AVAILABLE TO VALERY WITH GRANT OPTION */
REVOKE ALL ON V_STATUS_AVAILABLE FROM VALERY;

/* DROP: -- GRANT ALL ON V_STATUSES TO VALERY WITH GRANT OPTION */
REVOKE ALL ON V_STATUSES FROM VALERY;

/* DROP: -- GRANT ALL ON V_TAXRATE_ATTRS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON V_TAXRATE_ATTRS FROM VALERY;

/* DROP: -- GRANT ALL ON VALUTES TO VALERY WITH GRANT OPTION */
REVOKE ALL ON VALUTES FROM VALERY;

/* DROP: -- GRANT ALL ON VENDORS TO VALERY WITH GRANT OPTION */
REVOKE ALL ON VENDORS FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE AALL_CLEAR TO VALERY */
REVOKE EXECUTE ON PROCEDURE AALL_CLEAR FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACCOUNT_X_SEARCH TO VALERY */
REVOKE EXECUTE ON PROCEDURE ACCOUNT_X_SEARCH FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_ACCOUNT_CREDIT TO VALERY */
REVOKE EXECUTE ON PROCEDURE ACT_ACCOUNT_CREDIT FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_ACCOUNT_CREDITORDER TO VALERY */
REVOKE EXECUTE ON PROCEDURE ACT_ACCOUNT_CREDITORDER FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_ACCOUNT_DEBIT TO VALERY */
REVOKE EXECUTE ON PROCEDURE ACT_ACCOUNT_DEBIT FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_ACCOUNT_DEBITORDER TO VALERY */
REVOKE EXECUTE ON PROCEDURE ACT_ACCOUNT_DEBITORDER FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_ACCOUNT_PAYMENTIN TO VALERY */
REVOKE EXECUTE ON PROCEDURE ACT_ACCOUNT_PAYMENTIN FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_ACCOUNT_STORE TO VALERY */
REVOKE EXECUTE ON PROCEDURE ACT_ACCOUNT_STORE FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_ADRESS_STORE TO VALERY */
REVOKE EXECUTE ON PROCEDURE ACT_ADRESS_STORE FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_CLIENT_STORE TO VALERY */
REVOKE EXECUTE ON PROCEDURE ACT_CLIENT_STORE FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_EVENT_STORE TO VALERY */
REVOKE EXECUTE ON PROCEDURE ACT_EVENT_STORE FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_MAGAZINE_STORE TO VALERY */
REVOKE EXECUTE ON PROCEDURE ACT_MAGAZINE_STORE FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_MESSAGE_STORE TO VALERY */
REVOKE EXECUTE ON PROCEDURE ACT_MESSAGE_STORE FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_ORDER_DEBIT TO VALERY */
REVOKE EXECUTE ON PROCEDURE ACT_ORDER_DEBIT FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_ORDER_FOREACH_ORDERITEM TO VALERY */
REVOKE EXECUTE ON PROCEDURE ACT_ORDER_FOREACH_ORDERITEM FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_ORDER_FOREACH_ORDERTAX TO VALERY */
REVOKE EXECUTE ON PROCEDURE ACT_ORDER_FOREACH_ORDERTAX FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_ORDER_FOREACH_TAXRATE TO VALERY */
REVOKE EXECUTE ON PROCEDURE ACT_ORDER_FOREACH_TAXRATE FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_ORDER_STORE TO VALERY */
REVOKE EXECUTE ON PROCEDURE ACT_ORDER_STORE FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_ORDERITEM_STORE TO VALERY */
REVOKE EXECUTE ON PROCEDURE ACT_ORDERITEM_STORE FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_ORDERMONEY_CREDIT TO VALERY */
REVOKE EXECUTE ON PROCEDURE ACT_ORDERMONEY_CREDIT FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_ORDERMONEY_DEBIT TO VALERY */
REVOKE EXECUTE ON PROCEDURE ACT_ORDERMONEY_DEBIT FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_ORDERMONEY_STORE TO VALERY */
REVOKE EXECUTE ON PROCEDURE ACT_ORDERMONEY_STORE FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_ORDERTAX_STORE TO VALERY */
REVOKE EXECUTE ON PROCEDURE ACT_ORDERTAX_STORE FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_PAYMENT_STORE TO VALERY */
REVOKE EXECUTE ON PROCEDURE ACT_PAYMENT_STORE FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACT_PLACE_STORE TO VALERY */
REVOKE EXECUTE ON PROCEDURE ACT_PLACE_STORE FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACTION_DETECT TO VALERY */
REVOKE EXECUTE ON PROCEDURE ACTION_DETECT FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACTION_EXECUTE TO VALERY */
REVOKE EXECUTE ON PROCEDURE ACTION_EXECUTE FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACTION_RERUN TO VALERY */
REVOKE EXECUTE ON PROCEDURE ACTION_RERUN FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACTION_RERUN_ACTION TO VALERY */
REVOKE EXECUTE ON PROCEDURE ACTION_RERUN_ACTION FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ACTION_RUN TO VALERY */
REVOKE EXECUTE ON PROCEDURE ACTION_RUN FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ARTICLE_GOC TO VALERY */
REVOKE EXECUTE ON PROCEDURE ARTICLE_GOC FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ARTICLECODE_GOC TO VALERY */
REVOKE EXECUTE ON PROCEDURE ARTICLECODE_GOC FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ARTICLES_PUMP TO VALERY */
REVOKE EXECUTE ON PROCEDURE ARTICLES_PUMP FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ARTICLESIGN_DETECT TO VALERY */
REVOKE EXECUTE ON PROCEDURE ARTICLESIGN_DETECT FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ATTR_PUT TO VALERY */
REVOKE EXECUTE ON PROCEDURE ATTR_PUT FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE COUNTER_NEXTVAL TO VALERY */
REVOKE EXECUTE ON PROCEDURE COUNTER_NEXTVAL FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE IMP_CLIENTS TO VALERY */
REVOKE EXECUTE ON PROCEDURE IMP_CLIENTS FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE LOG_CREATE TO VALERY */
REVOKE EXECUTE ON PROCEDURE LOG_CREATE FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE LOG_UPDATE TO VALERY */
REVOKE EXECUTE ON PROCEDURE LOG_UPDATE FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE LOG_UPDATE_SKIPED TO VALERY */
REVOKE EXECUTE ON PROCEDURE LOG_UPDATE_SKIPED FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE MAGAZINE_DETECT TO VALERY */
REVOKE EXECUTE ON PROCEDURE MAGAZINE_DETECT FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE MESSAGE_BUSY TO VALERY */
REVOKE EXECUTE ON PROCEDURE MESSAGE_BUSY FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE MESSAGE_BUSY_2 TO VALERY */
REVOKE EXECUTE ON PROCEDURE MESSAGE_BUSY_2 FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE MESSAGE_CREATE TO VALERY */
REVOKE EXECUTE ON PROCEDURE MESSAGE_CREATE FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE MESSAGE_RELEASE TO VALERY */
REVOKE EXECUTE ON PROCEDURE MESSAGE_RELEASE FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE NOTIFY_CREATE TO VALERY */
REVOKE EXECUTE ON PROCEDURE NOTIFY_CREATE FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE OBJECT_GET TO VALERY */
REVOKE EXECUTE ON PROCEDURE OBJECT_GET FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE OBJECT_PUT TO VALERY */
REVOKE EXECUTE ON PROCEDURE OBJECT_PUT FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE OBJECT_READ TO VALERY */
REVOKE EXECUTE ON PROCEDURE OBJECT_READ FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE OBJECT_UPDATEABLE TO VALERY */
REVOKE EXECUTE ON PROCEDURE OBJECT_UPDATEABLE FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ORDER_READ TO VALERY */
REVOKE EXECUTE ON PROCEDURE ORDER_READ FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ORDER_X_ACTIVEITEMSCOUNT TO VALERY */
REVOKE EXECUTE ON PROCEDURE ORDER_X_ACTIVEITEMSCOUNT FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ORDER_X_UNINVOICED TO VALERY */
REVOKE EXECUTE ON PROCEDURE ORDER_X_UNINVOICED FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ORDERHISTORY_UPDATE TO VALERY */
REVOKE EXECUTE ON PROCEDURE ORDERHISTORY_UPDATE FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ORDERITEM_READ TO VALERY */
REVOKE EXECUTE ON PROCEDURE ORDERITEM_READ FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ORDERITEM_X_GETSTATEID TO VALERY */
REVOKE EXECUTE ON PROCEDURE ORDERITEM_X_GETSTATEID FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE ORDERTAX_READ TO VALERY */
REVOKE EXECUTE ON PROCEDURE ORDERTAX_READ FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE PARAM_CALC_IN TO VALERY */
REVOKE EXECUTE ON PROCEDURE PARAM_CALC_IN FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE PARAM_CALC_OUT TO VALERY */
REVOKE EXECUTE ON PROCEDURE PARAM_CALC_OUT FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE PARAM_CLONE TO VALERY */
REVOKE EXECUTE ON PROCEDURE PARAM_CLONE FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE PARAM_CREATE TO VALERY */
REVOKE EXECUTE ON PROCEDURE PARAM_CREATE FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE PARAM_CRITERIA TO VALERY */
REVOKE EXECUTE ON PROCEDURE PARAM_CRITERIA FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE PARAM_DEL TO VALERY */
REVOKE EXECUTE ON PROCEDURE PARAM_DEL FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE PARAM_FILLPATTERN TO VALERY */
REVOKE EXECUTE ON PROCEDURE PARAM_FILLPATTERN FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE PARAM_GET TO VALERY */
REVOKE EXECUTE ON PROCEDURE PARAM_GET FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE PARAM_PARSE TO VALERY */
REVOKE EXECUTE ON PROCEDURE PARAM_PARSE FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE PARAM_PARSE_4ACTION TO VALERY */
REVOKE EXECUTE ON PROCEDURE PARAM_PARSE_4ACTION FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE PARAM_SET TO VALERY */
REVOKE EXECUTE ON PROCEDURE PARAM_SET FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE PARAM_UNPARSE TO VALERY */
REVOKE EXECUTE ON PROCEDURE PARAM_UNPARSE FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE PIVOT_RECORD TO VALERY */
REVOKE EXECUTE ON PROCEDURE PIVOT_RECORD FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE PLACE_DETECT TO VALERY */
REVOKE EXECUTE ON PROCEDURE PLACE_DETECT FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE PLACE_READ TO VALERY */
REVOKE EXECUTE ON PROCEDURE PLACE_READ FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE PLUGIN_VALUE TO VALERY */
REVOKE EXECUTE ON PROCEDURE PLUGIN_VALUE FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE SEARCH TO VALERY */
REVOKE EXECUTE ON PROCEDURE SEARCH FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE SEARCH_GET_NGRAMM TO VALERY */
REVOKE EXECUTE ON PROCEDURE SEARCH_GET_NGRAMM FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE SETTING_GET TO VALERY */
REVOKE EXECUTE ON PROCEDURE SETTING_GET FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE SETTING_SET TO VALERY */
REVOKE EXECUTE ON PROCEDURE SETTING_SET FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE SPLITBLOB TO VALERY */
REVOKE EXECUTE ON PROCEDURE SPLITBLOB FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE SPLITSTRING TO VALERY */
REVOKE EXECUTE ON PROCEDURE SPLITSTRING FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE STATUS_CHECK_CONVERSION TO VALERY */
REVOKE EXECUTE ON PROCEDURE STATUS_CHECK_CONVERSION FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE STATUS_CONVERSION_BY_FLAG TO VALERY */
REVOKE EXECUTE ON PROCEDURE STATUS_CONVERSION_BY_FLAG FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE STATUS_GET_CONVERSION TO VALERY */
REVOKE EXECUTE ON PROCEDURE STATUS_GET_CONVERSION FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE STATUS_GET_DEFAULT TO VALERY */
REVOKE EXECUTE ON PROCEDURE STATUS_GET_DEFAULT FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE STATUS_STORE_DATE TO VALERY */
REVOKE EXECUTE ON PROCEDURE STATUS_STORE_DATE FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE TAX_FIXED_SUM TO VALERY */
REVOKE EXECUTE ON PROCEDURE TAX_FIXED_SUM FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE TAX_USE_REST TO VALERY */
REVOKE EXECUTE ON PROCEDURE TAX_USE_REST FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE TAX_WEIGHT TO VALERY */
REVOKE EXECUTE ON PROCEDURE TAX_WEIGHT FROM VALERY;

/* DROP: -- GRANT EXECUTE ON PROCEDURE TAXRATE_CALC TO VALERY */
REVOKE EXECUTE ON PROCEDURE TAXRATE_CALC FROM VALERY;

/* Create(Add) Crant */
GRANT USERS TO ELENA;

GRANT USERS TO NASTYA;

GRANT USERS TO NASTYA17;

GRANT USERS TO NATVL;

GRANT USERS TO ND;

GRANT USERS TO YULYA;


