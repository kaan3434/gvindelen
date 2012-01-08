/* Server version: WI-V6.3.1.26351 Firebird 2.5 
   SQLDialect: 3. ODS: 11.2. Forced writes: On. Sweep inteval: 20000.
   Page size: 4096. Cache pages: 2048 (8192 Kb). Read-only: False. */
SET CLIENTLIB 'fbclient.dll';
SET NAMES CYRL;

SET SQL DIALECT 3;

SET AUTODDL ON;

/* Create Procedure... */
SET TERM ^ ;

CREATE PROCEDURE ORDER_X_ACTIVEITEMSCOUNT(I_DEST_PARAM_ID TYPE OF ID_PARAM NOT NULL,
I_PARAM_NAME TYPE OF SIGN_ATTR NOT NULL,
I_SRC_PARAM_ID TYPE OF ID_PARAM)
 AS
 BEGIN EXIT; END
^


/*  Empty ACT_ACCOUNT_CREDIT for PARAM_FILLPATTERN(param list change)  */
ALTER PROCEDURE ACT_ACCOUNT_CREDIT(I_PARAM_ID /* TYPE OF ID_PARAM */ BIGINT,
I_OBJECT_ID /* TYPE OF ID_OBJECT */ INTEGER,
I_OBJECT_SIGN /* TYPE OF SIGN_OBJECT */ VARCHAR(30) = 'ACCOUNT')
 AS
 BEGIN EXIT; END
^

/*  Empty ACT_ACCOUNT_CREDITORDER for PARAM_FILLPATTERN(param list change)  */
ALTER PROCEDURE ACT_ACCOUNT_CREDITORDER(I_PARAM_ID /* TYPE OF ID_PARAM */ BIGINT,
I_OBJECT_ID /* TYPE OF ID_OBJECT */ INTEGER,
I_OBJECT_SIGN /* TYPE OF SIGN_OBJECT */ VARCHAR(30) = 'ACCOUNT')
 AS
 BEGIN EXIT; END
^

/*  Empty ACT_ACCOUNT_DEBIT for PARAM_FILLPATTERN(param list change)  */
ALTER PROCEDURE ACT_ACCOUNT_DEBIT(I_PARAM_ID /* TYPE OF ID_PARAM */ BIGINT,
I_OBJECT_ID /* TYPE OF ID_OBJECT */ INTEGER,
I_OBJECT_SIGN /* TYPE OF SIGN_OBJECT */ VARCHAR(30) = 'ACCOUNT')
 AS
 BEGIN EXIT; END
^

/*  Empty ACT_ACCOUNT_DEBITORDER for PARAM_FILLPATTERN(param list change)  */
ALTER PROCEDURE ACT_ACCOUNT_DEBITORDER(I_PARAM_ID /* TYPE OF ID_PARAM */ BIGINT,
I_OBJECT_ID /* TYPE OF ID_OBJECT */ INTEGER,
I_OBJECT_SIGN /* TYPE OF SIGN_OBJECT */ VARCHAR(30) = 'ACCOUNT')
 AS
 BEGIN EXIT; END
^

/*  Empty ACT_ACCOUNT_PAYMENTIN for PARAM_FILLPATTERN(param list change)  */
ALTER PROCEDURE ACT_ACCOUNT_PAYMENTIN(I_PARAM_ID /* TYPE OF ID_PARAM */ BIGINT NOT NULL,
I_OBJECT_ID /* TYPE OF ID_OBJECT */ INTEGER NOT NULL,
I_OBJECT_SIGN /* TYPE OF SIGN_OBJECT */ VARCHAR(30) = 'ACCOUNT')
 AS
 BEGIN EXIT; END
^

/* Alter empty procedure PARAM_FILLPATTERN with new param-list */
ALTER PROCEDURE PARAM_FILLPATTERN(I_PARAM_ID TYPE OF ID_PARAM NOT NULL,
I_PATTERN TYPE OF VALUE_ATTR)
 RETURNS(O_PATTERN TYPE OF VALUE_ATTR)
 AS
 BEGIN SUSPEND; END
^

/* Alter Procedure... */
ALTER PROCEDURE PARAM_FILLPATTERN(I_PARAM_ID TYPE OF ID_PARAM NOT NULL,
I_PATTERN TYPE OF VALUE_ATTR)
 RETURNS(O_PATTERN TYPE OF VALUE_ATTR)
 AS
declare variable V_PARAM_NAME type of SIGN_ATTR;
declare variable V_PARAM_VALUE type of VALUE_ATTR;
begin
  o_pattern = i_pattern;
  for select p.param_name, coalesce(p.param_value, '')
        from params p
        where p.param_id = :i_param_id
        into :v_param_name, :v_param_value do
      o_pattern = replace(o_pattern, '['||:v_param_name||']', :v_param_value);
  suspend;
end
^

/* Alter (ACT_ACCOUNT_CREDIT) */
ALTER PROCEDURE ACT_ACCOUNT_CREDIT(I_PARAM_ID TYPE OF ID_PARAM,
I_OBJECT_ID TYPE OF ID_OBJECT,
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

/* Alter (ACT_ACCOUNT_CREDITORDER) */
ALTER PROCEDURE ACT_ACCOUNT_CREDITORDER(I_PARAM_ID TYPE OF ID_PARAM,
I_OBJECT_ID TYPE OF ID_OBJECT,
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

/* Alter (ACT_ACCOUNT_DEBIT) */
ALTER PROCEDURE ACT_ACCOUNT_DEBIT(I_PARAM_ID TYPE OF ID_PARAM,
I_OBJECT_ID TYPE OF ID_OBJECT,
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

  select o_value from param_get(:i_param_id, 'AMOUNT_EUR') into :v_amount_eur;
  select o_value from param_get(:i_param_id, 'BYR2EUR') into :v_byr2eur;
  select o_value from param_get(:i_param_id, 'ORDER_ID') into :v_order_id;
  select o_value from param_get(:i_param_id, 'NOTES') into :v_notes;

  select o_pattern from param_fillpattern(:i_param_id, :v_notes) into :v_notes;

  insert into accopers (account_id, amount_eur, byr2eur, order_id, notes)
    values(:i_object_id, :v_amount_eur, :v_byr2eur, :v_order_id, :v_notes);
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

  insert into accopers (account_id, amount_eur, byr2eur, order_id, notes)
    values(:i_object_id, :v_amount_eur, :v_byr2eur, :v_order_id, :v_notes);
end
^

/* empty dependent procedure body */
/* Clear: ACTION_RUN for: PARAM_CALC_IN */
ALTER PROCEDURE ACTION_RUN(I_OBJECT_SIGN /* TYPE OF SIGN_OBJECT */ VARCHAR(30),
I_ACTION_SIGN /* TYPE OF SIGN_ACTION */ VARCHAR(30),
I_PARAM_ID /* TYPE OF ID_PARAM */ BIGINT,
I_OBJECT_ID /* TYPE OF ID_OBJECT */ INTEGER)
 RETURNS(O_ACTION_ID /* TYPE OF ID_ACTION */ INTEGER)
 AS
 BEGIN SUSPEND; END
^

/* Alter (PARAM_CALC_IN) */
ALTER PROCEDURE PARAM_CALC_IN(I_OBJECT_SIGN TYPE OF SIGN_OBJECT,
I_DEST_PARAM_ID TYPE OF ID_PARAM,
I_PARAM_NAME TYPE OF SIGN_OBJECT,
I_PARAM_KIND TYPE OF KIND_PARAM,
I_PARAM_VALUE TYPE OF VALUE_ATTR,
I_SRC_PARAM_ID TYPE OF ID_PARAM)
 AS
declare variable V_PARAM_VALUE type of VALUE_ATTR;
declare variable V_SQL type of SQL_STATEMENT;
declare variable V_TABLE_NAME type of NAME_PROCEDURE;
begin
  if (exists (select param_value from params
                where param_id = :i_dest_param_id
                  and param_name = :i_param_name)) then exit;

  if (:i_param_kind = 'I') then
    exception ex_mandatory_param_expected 'Mandatory parameter '||:i_param_name||' expected';
  else
  if (:i_param_kind = 'V') then
    execute procedure param_set(:i_dest_param_id, :i_param_name, :i_param_value);
  else
  if (:i_param_kind = 'A') then
  begin
    select param_value from params
      where param_name = :i_param_value
        and param_id = :i_src_param_id
      into :v_param_value;
    if (row_count = 1) then
      execute procedure param_set(:i_dest_param_id, :i_param_name, :v_param_value);
  end
  else
  if (:i_param_kind = 'X') then
  begin
    v_sql = 'execute procedure '||:i_object_sign||'_X_'||:i_param_value||' (:dest_param_id, :pattern, :src_param_id)';
    execute statement (:v_sql) (dest_param_id := :i_dest_param_id, pattern := :i_param_name, src_param_id := :i_src_param_id);
  end
  else
  if (:i_param_kind = 'B') then
  begin
    if (i_object_sign = 'ACCOUNT') then
      execute procedure account_x_search(:i_dest_param_id, :i_param_value, :i_src_param_id);
    else
    begin
      v_sql = 'execute procedure '||:i_object_sign||'_X_SEARCH (:dest_param_id, :pattern, :src_param_id)';
      execute statement (:v_sql) (dest_param_id := :i_dest_param_id, pattern := :i_param_value, src_param_id := :i_src_param_id);
    end
  end
  else
  if (:i_param_kind = 'F') then
  begin
    select o_pattern from param_fillpattern(:i_src_param_id, :i_param_value) into :v_sql;
    execute statement (:v_sql) into :v_param_value;
    execute procedure param_set (:i_dest_param_id, :i_param_name, :v_param_value);
  end
end
^

/* Restore proc. body: ACTION_RUN */
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

/* Restore proc. body: ORDER_X_ACTIVEITEMSCOUNT */
ALTER PROCEDURE ORDER_X_ACTIVEITEMSCOUNT(I_DEST_PARAM_ID TYPE OF ID_PARAM NOT NULL,
I_PARAM_NAME TYPE OF SIGN_ATTR NOT NULL,
I_SRC_PARAM_ID TYPE OF ID_PARAM)
 AS
declare variable V_OBJECT_ID type of ID_OBJECT;
declare variable V_AMOUNT type of VALUE_INTEGER;
begin
  select o_value from param_get(:i_src_param_id, 'ID') into :v_object_id;

  select sum(oi.amount)
    from orderitems oi
    where oi.order_id = :v_object_id
    into :v_amount;

  execute procedure param_set(:i_dest_param_id, :i_param_name, :v_amount);
end
^

/* Altering existing trigger... */
ALTER TRIGGER ORDERITEMS_BU0
AS
declare variable v_flaglist list_signs;
begin
  new.article_code = upper(new.article_code);
  if (new.status_id <> old.status_id) then
    new.status_dtm = current_timestamp;
  if (exists (select *
                from flags2statuses f2s
                where f2s.status_id = new.status_id
                  and f2s.flag_sign = 'CREDIT')) then
    new.amount = 1;
  else
    new.amount = 0;
  new.cost_eur = new.amount * new.price_eur;
end
^

/* Altering existing trigger... */
ALTER TRIGGER ORDERTAXS_BU0
AS
begin
  if (old.status_id <> new.status_id) then
    new.status_dtm = current_timestamp;
  if (not exists (select *
                from flags2statuses f2s
                where f2s.status_id = new.status_id
                  and f2s.flag_sign = 'CREDIT')) then
    new.amount = 0;
  new.cost_eur= new.price_eur * new.amount;
end
^

/* Alter Procedure... */
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

SET TERM ; ^

