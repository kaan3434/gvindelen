/* Server version: WI-V6.3.1.26351 Firebird 2.5 
   SQLDialect: 3. ODS: 11.2. Forced writes: On. Sweep inteval: 20000.
   Page size: 4096. Cache pages: 2048 (8192 Kb). Read-only: False. */
SET CLIENTLIB 'fbclient.dll';
SET NAMES CYRL;

SET SQL DIALECT 3;

SET AUTODDL ON;

ALTER TABLE ORDERS ADD SOURCE NAME_SHORT;

/* Alter View (Drop, Create)... */
/* Drop altered view: V_CLIENTADRESS */
DROP VIEW V_MONEYBACK_BELPOST;

DROP VIEW V_ORDERITEMS_RETURNING;

DROP VIEW V_CLIENTADRESS;

/* Create altered view: V_CLIENTADRESS */
/* Create view: V_CLIENTADRESS */
CREATE VIEW V_CLIENTADRESS(
CLIENT_ID,
FIO_TEXT,
LAST_NAME,
FIRST_NAME,
MID_NAME,
STATUS_ID,
MOBILE_PHONE,
EMAIL,
PHONE_NUMBER,
PLACE_ID,
PLACE_TEXT,
ADRESS_ID,
ADRESS_TEXT,
POSTINDEX)
 AS 
select c.client_id, cast(c.last_name||' '||c.first_name||' '||c.mid_name as varchar(100)),
  c.last_name, c.first_name, c.mid_name, c.status_id,
  c.mobile_phone, ca_mail.attr_value, ca_phone.attr_value,
  p.place_id, p.place_text, a.adress_id, a.adress_text, a.postindex
  from clients c
    inner join v_adress_text a on (a.client_id = c.client_id and a.status_sign<>'ARCHIVE')
    inner join v_place_text p on (p.place_id = a.place_id)
    left join v_client_attrs ca_phone on (ca_phone.object_id = c.client_id and ca_phone.attr_sign = 'PHONE_NUMBER')
    left join v_client_attrs ca_mail on (ca_mail.object_id = c.client_id and ca_mail.attr_sign = 'EMAIL')
;

/* Drop altered view: V_ORDERITEMS_RETURNING */
/* Create altered view: V_ORDERITEMS_RETURNING */
/* Create view: V_ORDERITEMS_RETURNING */
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

/*  Empty ACT_ORDER_DEBIT for ACTION_DETECT(param list change)  */
SET TERM ^ ;

ALTER PROCEDURE ACT_ORDER_DEBIT(I_PARAM_ID /* TYPE OF ID_PARAM */ BIGINT,
I_OBJECT_ID /* TYPE OF ID_OBJECT */ INTEGER,
I_OBJECT_SIGN /* TYPE OF SIGN_OBJECT */ VARCHAR(30) = 'ORDERITEM')
 AS
 BEGIN EXIT; END
^

/*  Empty ACT_ORDER_FOREACH_ORDERITEM for ACTION_DETECT(param list change)  */
ALTER PROCEDURE ACT_ORDER_FOREACH_ORDERITEM(I_PARAM_ID /* TYPE OF ID_PARAM */ BIGINT,
I_OBJECT_ID /* TYPE OF ID_OBJECT */ INTEGER,
I_OBJECT_SIGN /* TYPE OF SIGN_OBJECT */ VARCHAR(30) = 'ORDERITEM')
 AS
 BEGIN EXIT; END
^

/*  Empty ACT_ORDER_FOREACH_ORDERTAX for ACTION_DETECT(param list change)  */
ALTER PROCEDURE ACT_ORDER_FOREACH_ORDERTAX(I_PARAM_ID /* TYPE OF ID_PARAM */ BIGINT,
I_OBJECT_ID /* TYPE OF ID_OBJECT */ INTEGER,
I_OBJECT_SIGN /* TYPE OF SIGN_OBJECT */ VARCHAR(30) = 'ORDERTAX')
 AS
 BEGIN EXIT; END
^

/*  Empty ACT_ORDER_FOREACH_TAXRATE for ACTION_DETECT(param list change)  */
ALTER PROCEDURE ACT_ORDER_FOREACH_TAXRATE(I_PARAM_ID /* TYPE OF ID_PARAM */ BIGINT,
I_OBJECT_ID /* TYPE OF ID_OBJECT */ INTEGER,
I_OBJECT_SIGN /* TYPE OF SIGN_OBJECT */ VARCHAR(30) = 'ORDERTAX')
 AS
 BEGIN EXIT; END
^

/*  Empty ACTION_EXECUTE for ACTION_DETECT(param list change)  */
ALTER PROCEDURE ACTION_EXECUTE(I_OBJECT_SIGN /* TYPE OF SIGN_OBJECT */ VARCHAR(30),
I_PARAMS /* TYPE OF VALUE_BLOB */ BLOB SUB_TYPE 1 SEGMENT SIZE 100,
I_ACTION_SIGN /* TYPE OF SIGN_ACTION */ VARCHAR(30),
I_OBJECT_ID /* TYPE OF ID_OBJECT */ INTEGER)
 RETURNS(O_ACTION_ID /* TYPE OF ID_ACTION */ INTEGER)
 AS
 BEGIN SUSPEND; END
^

/* Alter empty procedure ACTION_DETECT with new param-list */
ALTER PROCEDURE ACTION_DETECT(I_OBJECT_SIGN TYPE OF SIGN_OBJECT NOT NULL,
I_OBJECT_ID TYPE OF ID_OBJECT NOT NULL,
I_NEW_STATUS_SIGN TYPE OF SIGN_OBJECT,
I_NEW_FLAG_SIGN TYPE OF SIGN_OBJECT)
 RETURNS(O_ACTION_SIGN TYPE OF SIGN_ACTION)
 AS
 BEGIN SUSPEND; END
^

/* Alter Procedure... */
ALTER PROCEDURE ACTION_DETECT(I_OBJECT_SIGN TYPE OF SIGN_OBJECT NOT NULL,
I_OBJECT_ID TYPE OF ID_OBJECT NOT NULL,
I_NEW_STATUS_SIGN TYPE OF SIGN_OBJECT,
I_NEW_FLAG_SIGN TYPE OF SIGN_OBJECT)
 RETURNS(O_ACTION_SIGN TYPE OF SIGN_ACTION)
 AS
declare variable V_TABLE_NAME type of NAME_PROCEDURE;
declare variable V_IDFIELD_NAME type of NAME_PROCEDURE;
declare variable V_SQL type of SQL_STATEMENT;
declare variable V_NEW_STATUS_ID type of ID_STATUS;
declare variable V_NOW_STATUS_ID type of ID_STATUS;
declare variable V_NOW_STATUS_SIGN type of SIGN_OBJECT;
declare variable V_ERROR_MESSAGE type of RDB$MESSAGE;
declare variable V_ERROR type of VALUE_ATTR;
begin
  i_object_sign = trim(i_object_sign);
  -- get current status_id
  select o.table_name, o.idfield_name
    from objects o
    where o.object_sign = :i_object_sign
    into :v_table_name, :v_idfield_name;

  v_sql = 'select status_id from '||v_table_name||' where '||v_idfield_name||' = :object_id';

  execute statement (:v_sql) (object_id := :i_object_id)
    into :v_now_status_id;

  select s.status_sign
    from statuses s
    where s.status_id = :v_now_status_id
      and s.object_sign = :i_object_sign
    into :v_now_status_sign;

  if (:i_new_status_sign is not null) then
  begin
    -- search action by status_sign
    select s.status_id
      from statuses s
      where s.status_sign = :i_new_status_sign
        and s.object_sign = :i_object_sign
      into :v_new_status_id;
  end
  else
  begin
    -- search action by flag_sign
    select sr.new_status_id
      from status_rules sr
        inner join flags2statuses f2s on (f2s.status_id = sr.new_status_id)
      where sr.old_status_id = :v_now_status_id
        and f2s.flag_sign = :i_new_flag_sign
      into :v_new_status_id;
  when sqlcode -811 do
    begin
      select RDB$MESSAGE
        from RDB$EXCEPTIONS
        where RDB$EXCEPTION_NAME = 'EX_UNDETECTED_ACTIONCODE'
        into :v_error_message;
      v_error = v_error_message||' (объект="'||:i_object_sign||'" id="'||:i_object_id||'" переход из="'||:v_now_status_sign||'" по флагу="'||:i_new_flag_sign||'")';
      exception ex_undetected_actioncode :v_error;
    end
  end

  if (v_now_status_id = v_new_status_id) then
    o_action_sign = :i_object_sign||'_STORE';
  else
  if (v_now_status_id is null) then
  begin
    -- get default action_sign
    select coalesce(s.action_sign, :i_object_sign||'_STORE')
      from statuses s
      where s.object_sign = :i_object_sign
        and s.is_default = 1
      into :o_action_sign;
  end
  else
  if (v_new_status_id is not null) then
  begin
    -- get action_sign
    select sr.action_sign
      from status_rules sr
      where sr.old_status_id = :v_now_status_id
        and sr.new_status_id = :v_new_status_id
      into :o_action_sign;

    if (:o_action_sign is null) then
    begin
      select RDB$MESSAGE
        from RDB$EXCEPTIONS
        where RDB$EXCEPTION_NAME = 'EX_UNDETECTED_ACTIONCODE'
        into :v_error_message;
      v_error = v_error_message||' (объект="'||:i_object_sign||'" id="'||:i_object_id||'" переход из="'||:v_now_status_sign||'" в="'||:i_new_status_sign||'")';
      exception ex_undetected_actioncode :v_error;
    end
  end

  suspend;
end
^

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

/* empty dependent procedure body */
/* Clear: ACTION_RUN for: ACT_ORDER_FOREACH_ORDERITEM */
ALTER PROCEDURE ACTION_RUN(I_OBJECT_SIGN /* TYPE OF SIGN_OBJECT */ VARCHAR(30),
I_ACTION_SIGN /* TYPE OF SIGN_ACTION */ VARCHAR(30),
I_PARAM_ID /* TYPE OF ID_PARAM */ BIGINT,
I_OBJECT_ID /* TYPE OF ID_OBJECT */ INTEGER)
 RETURNS(O_ACTION_ID /* TYPE OF ID_ACTION */ INTEGER)
 AS
 BEGIN SUSPEND; END
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

/* Alter (ORDER_READ) */
ALTER PROCEDURE ORDER_READ(I_OBJECT_ID TYPE OF ID_OBJECT)
 RETURNS(O_PARAM_NAME TYPE OF SIGN_OBJECT,
O_PARAM_VALUE TYPE OF VALUE_ATTR)
 AS
declare variable V_PRODUCT_NAME type of VALUE_ATTR;
declare variable V_CLIENT_FIO type of VALUE_ATTR;
declare variable V_ADRESS_TEXT type of VALUE_ATTR;
declare variable V_STATUS_SIGN type of SIGN_ATTR;
declare variable V_ACCOUNT_ID type of ID_ACCOUNT;
declare variable V_STATUS_FLAG_LIST type of LIST_SIGNS;
declare variable V_STATUS_NAME type of NAME_OBJECT;
begin
  select p.product_name, vc.client_fio,
         ca.postindex||'. '||ca.place_text||', '||ca.adress_text adress_text,
         s.status_sign, s.flag_sign_list, s.status_name
    from orders o
      left join products p on (p.product_id = o.product_id)
      left join v_clients_fio vc on (vc.client_id = o.client_id)
      left join v_clientadress ca on (ca.client_id = o.client_id)
      left join statuses s on (s.status_id = o.status_id)
    where o.order_id = :i_object_id
    into :v_product_name, :v_client_fio, :v_adress_text,
         :v_status_sign, :v_status_flag_list, :v_status_name;

  o_param_name = 'STATUS_SIGN';
  o_param_value = v_status_sign;
  suspend;
  o_param_name = 'STATUS_FLAG_LIST';
  o_param_value = v_status_flag_list;
  suspend;
  o_param_name = 'STATUS_NAME';
  o_param_value = v_status_name;
  suspend;


  if (:v_product_name is not null) then
  begin
    o_param_name = 'PRODUCT_NAME';
    o_param_value = :v_product_name;
    suspend;
  end

  if (v_client_fio is not null) then
  begin
    o_param_name = 'CLIENT_FIO';
    o_param_value = :v_client_fio;
    suspend;
  end

  if (:v_adress_text is not null) then
  begin
    o_param_name = 'ADRESS_TEXT';
    o_param_value = :v_adress_text;
    suspend;
  end

  select a.account_id
    from orders o
      inner join clients cl on (cl.client_id = o.client_id)
      inner join accounts a on (a.account_id = cl.account_id)
    where o.order_id = :i_object_id
    into :v_account_id;
  if (:v_account_id is not null) then
  begin
    o_param_name = 'ACCOUNT_ID';
    o_param_value = :v_account_id;
    suspend;
  end

end
^

/* Create Views... */
/* Create view: V_MONEYBACK_BELPOST */
SET TERM ; ^

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


/* Altering existing trigger... */
SET TERM ^ ;

ALTER TRIGGER ACCRESTS_BI0
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
    new.rest_eur = cast(new.rest_byr as numeric(12,2)) / new.byr2eur;
end
^

/* Altering existing trigger... */
ALTER TRIGGER ACCRESTS_BU0
AS
begin
  new.rest_dtm = current_timestamp;
  if (new.rest_byr = old.rest_byr and new.rest_eur <> old.rest_eur) then
    new.rest_byr = old.rest_byr + round(new.rest_eur * old.byr2eur, -1);
  else
  if (new.rest_eur = old.rest_eur and new.rest_byr <> old.rest_byr) then
    new.rest_eur = old.rest_eur + new.rest_byr / old.byr2eur;
end
^

/* Altering existing trigger... */
ALTER TRIGGER ORDERITEMS_BU0
AS
declare variable v_flaglist list_signs;
begin
  new.article_code = upper(new.article_code);
  new.dimension = upper(new.dimension);
  if (new.status_id <> old.status_id) then
  begin
    new.status_dtm = current_timestamp;
    new.state_id = null;
  end
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

SET TERM ; ^

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

/* Create(Add) privilege */
GRANT ALL ON V_CLIENTADRESS TO ANNA;

GRANT ALL ON V_CLIENTADRESS TO ELENA;

GRANT ALL ON V_CLIENTADRESS TO KATYA;

GRANT ALL ON V_CLIENTADRESS TO LENA;

GRANT ALL ON V_CLIENTADRESS TO NASTYA;

GRANT ALL ON V_CLIENTADRESS TO NASTYA17;

GRANT ALL ON V_CLIENTADRESS TO NATVL;

GRANT ALL ON V_CLIENTADRESS TO ND;

GRANT ALL ON V_CLIENTADRESS TO SYSDBA WITH GRANT OPTION;

GRANT ALL ON V_CLIENTADRESS TO USERS WITH GRANT OPTION;

GRANT ALL ON V_CLIENTADRESS TO VALERY;

GRANT ALL ON V_CLIENTADRESS TO YULYA;

GRANT ALL ON V_MONEYBACK_BELPOST TO SYSDBA WITH GRANT OPTION;

GRANT ALL ON V_ORDERITEMS_RETURNING TO SYSDBA WITH GRANT OPTION;

GRANT RDB$ADMIN TO ELENA;

GRANT RDB$ADMIN TO ND;


