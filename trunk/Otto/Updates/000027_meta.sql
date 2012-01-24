/* Server version: WI-V6.3.1.26351 Firebird 2.5 
SET CLIENTLIB 'fbclient.dll';
   SQLDialect: 3. ODS: 11.2. Forced writes: On. Sweep inteval: 20000.
   Page size: 4096. Cache pages: 2048 (8192 Kb). Read-only: False. */
SET NAMES CYRL;

SET SQL DIALECT 3;

SET AUTODDL ON;

RECONNECT;

ALTER TABLE PHONEPREFIXES DROP CONSTRAINT FK_PHONEPREFIXES_PHONETYPE;

ALTER TABLE PHONETYPES DROP CONSTRAINT PK_PHONETYPES;

RECONNECT;

ALTER TABLE PLACES DROP CONSTRAINT FK_PLACES_PHONEPREFIX;

ALTER TABLE PHONEPREFIXES DROP CONSTRAINT PK_PHONEPREFIXES;

ALTER TABLE ORDERHISTORY DROP CONSTRAINT FK_ORDERHISTORY_STATUS;

ALTER TABLE ORDERHISTORY DROP CONSTRAINT FK_ORDERHISTORY_STATE;

/* Empty ORDERHISTORY_UPDATE for drop ORDERHISTORY(STATE_ID) */
SET TERM ^ ;

ALTER PROCEDURE ORDERHISTORY_UPDATE(I_ORDER_ID TYPE OF ID_ORDER,
I_STATUS_ID TYPE OF ID_STATUS,
I_STATE_ID TYPE OF ID_STATE)
 AS
 BEGIN EXIT; END
^

SET TERM ; ^

ALTER TABLE ORDERHISTORY ALTER COLUMN STATE_ID TYPE ID_STATUS;

/* Drop table-fields... */
DROP VIEW V_CLIENTADRESS;

DROP VIEW V_PLACE_TEXT;

SET TERM ^ ;

ALTER PROCEDURE PLACE_READ(I_OBJECT_ID TYPE OF ID_OBJECT)
 RETURNS(O_PARAM_NAME TYPE OF SIGN_OBJECT,
O_PARAM_VALUE TYPE OF VALUE_ATTR)
 AS
 BEGIN SUSPEND; END
^

SET TERM ; ^

DROP VIEW V_PLACES;

ALTER TABLE PLACES DROP PHONEPREFIX_CODE;


RECONNECT;

/* Drop tables... */
DROP TABLE PHONEPREFIXES;

DROP TABLE PHONETYPES;


/* Drop domains... */
/* Drop: FIB$BOOLEAN (TDmnData) */
DROP DOMAIN FIB$BOOLEAN;

/* Drop: ID_CONTROL (TDmnData) */
DROP DOMAIN ID_CONTROL;

/* Drop: ID_DEAL (TDmnData) */
DROP DOMAIN ID_DEAL;

/* Drop: ID_DELIVERY (TDmnData) */
DROP DOMAIN ID_DELIVERY;

/* Drop: ID_ELEM (TDmnData) */
DROP DOMAIN ID_ELEM;

/* Drop: ID_INVOICE (TDmnData) */
DROP DOMAIN ID_INVOICE;

/* Drop: ID_SESSION (TDmnData) */
DROP DOMAIN ID_SESSION;

/* Drop: ID_STATE (TDmnData) */
DROP DOMAIN ID_STATE;

/* Drop: MSG_DTM (TDmnData) */
DROP DOMAIN MSG_DTM;

/* Drop: MSG_ID (TDmnData) */
DROP DOMAIN MSG_ID;

/* Drop: MSG_SIGN (TDmnData) */
DROP DOMAIN MSG_SIGN;

/* Drop: NODE_ID (TDmnData) */
DROP DOMAIN NODE_ID;

/* Drop: NODE_NAME (TDmnData) */
DROP DOMAIN NODE_NAME;

/* Drop: NODE_TYPE (TDmnData) */
DROP DOMAIN NODE_TYPE;

/* Drop: NODE_VALUE (TDmnData) */
DROP DOMAIN NODE_VALUE;

/* Drop: OBJ_CODE (TDmnData) */
DROP DOMAIN OBJ_CODE;

/* Drop: OBJ_NAME (TDmnData) */
DROP DOMAIN OBJ_NAME;

/* Drop: OBJ_SIGN (TDmnData) */
DROP DOMAIN OBJ_SIGN;

/* Drop: ORD_CODE (TDmnData) */
DROP DOMAIN ORD_CODE;

/* Drop: ORD_ID (TDmnData) */
DROP DOMAIN ORD_ID;

/* Drop: REST_ID (TDmnData) */
DROP DOMAIN REST_ID;

/* Drop: TEXT (TDmnData) */
DROP DOMAIN TEXT;

/* Create Views... */
/* Create view: V_PLACE_TEXT (ViwData.CreateDependDef) */
CREATE VIEW V_PLACE_TEXT(
PLACE_ID,
PLACE_TEXT,
STATUS_ID)
 AS 
select
  p.place_id,
  case pt.placetype_code
   when 2 then
     p.place_name||' '||pt.placetype_sign||'.'
   when 3 then
     p.place_name||' '||pt.placetype_sign||'.'
   else
     pt.placetype_sign||'. '||p.place_name
  end||
   iif(a.place_id is null, '', ', '||a.place_name||' '||apt.placetype_sign||'.')||
   iif(r.place_id is null, '', ', '||r.place_name||' '||rpt.placetype_sign||'.'),
  p.status_id
  from places p
    left join placetypes pt on (pt.placetype_code = coalesce(p.placetype_code, 4))
    left join places a on (a.place_id = p.owner_place and a.placetype_code = 3)
    left join placetypes apt on (apt.placetype_code = a.placetype_code)
    left join places r on (r.place_id = coalesce(a.owner_place, p.owner_place) and r.placetype_code = 2)
    left join placetypes rpt on (rpt.placetype_code = r.placetype_code)
;

/* Create view: V_CLIENTADRESS (ViwData.CreateDependDef) */
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
ADRESS_TEXT)
 AS 
select c.client_id, cast(c.last_name||' '||c.first_name||' '||c.mid_name as varchar(100)),
  c.last_name, c.first_name, c.mid_name, c.status_id,
  c.mobile_phone, ca_mail.attr_value, ca_phone.attr_value,
  p.place_id, p.place_text, a.adress_id, a.adress_text
  from clients c
    inner join v_adress_text a on (a.client_id = c.client_id)
    inner join v_place_text p on (p.place_id = a.place_id)
    left join v_client_attrs ca_phone on (ca_phone.object_id = c.client_id and ca_phone.attr_sign = 'PHONE_NUMBER')
    left join v_client_attrs ca_mail on (ca_mail.object_id = c.client_id and ca_mail.attr_sign = 'EMAIL')
;

/* Create view: V_PLACES (ViwData.CreateDependDef) */
CREATE VIEW V_PLACES(
PLACE_ID,
PLACETYPE_CODE,
PLACETYPE_SIGN,
PLACE_NAME,
AREA_ID,
AREA_NAME,
REGION_ID,
REGION_NAME)
 AS 
select
  p.place_id,
  p.placetype_code,
  pt.placetype_sign,
  p.place_name,
  a.place_id,
  a.place_name,
  r.place_id,
  r.place_name
from places p
   inner join placetypes pt on (pt.placetype_code = p.placetype_code)
   left join places a on (a.place_id = p.owner_place and a.placetype_code = 3)
   left join places r on (r.place_id = coalesce(a.owner_place, p.owner_place) and r.placetype_code = 2)
where p.placetype_code >= 4
;


/* Create Exception... */
CREATE EXCEPTION EX_UNDETECTED_ACTIONCODE 'Недопустимый переход состояний объекта';


/* Create Foreign Key... */
RECONNECT;

ALTER TABLE ORDERHISTORY ADD CONSTRAINT FK_ORDERHISTORY_STATE FOREIGN KEY (STATE_ID) REFERENCES STATUSES (STATUS_ID) ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE ORDERHISTORY ADD CONSTRAINT FK_ORDERHISTORY_STATUS FOREIGN KEY (STATUS_ID) REFERENCES STATUSES (STATUS_ID) ON UPDATE CASCADE ON DELETE CASCADE;

/*  Empty ACT_ORDER_STORE for ORDERHISTORY_UPDATE(param list change)  */
SET TERM ^ ;

ALTER PROCEDURE ACT_ORDER_STORE(I_PARAM_ID TYPE OF ID_PARAM,
I_OBJECT_ID TYPE OF ID_OBJECT,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ORDER')
 AS
 BEGIN EXIT; END
^

/*  Empty IMP_CLIENTS for SPLITSTRING(param list change)  */
ALTER PROCEDURE IMP_CLIENTS(I_CLIENT_ID INTEGER = 0)
 AS
 BEGIN EXIT; END
^

/*  Empty PARAM_UNPARSE for SPLITSTRING(param list change)  */
ALTER PROCEDURE PARAM_UNPARSE(I_PARAM_ID TYPE OF ID_PARAM,
I_PARAMS TYPE OF VALUE_BLOB)
 AS
 BEGIN EXIT; END
^

/*  Empty SPLITBLOB for SPLITSTRING(param list change)  */
ALTER PROCEDURE SPLITBLOB(I_BLOB TYPE OF VALUE_BLOB,
I_DEVIDER TYPE OF DEVIDER)
 RETURNS(O_LINE TYPE OF VALUE_ATTR)
 AS
 BEGIN SUSPEND; END
^

/* Alter empty procedure ORDERHISTORY_UPDATE with new param-list */
ALTER PROCEDURE ORDERHISTORY_UPDATE(I_ORDER_ID TYPE OF ID_ORDER,
I_STATUS_ID TYPE OF ID_STATUS,
I_STATE_ID TYPE OF ID_STATUS)
 AS
 BEGIN EXIT; END
^

/* Alter empty procedure SPLITSTRING with new param-list */
ALTER PROCEDURE SPLITSTRING(I_STRING TYPE OF VALUE_ATTR,
I_DEVIDER TYPE OF DEVIDER)
 RETURNS(O_HEAD TYPE OF VALUE_ATTR,
O_TILE TYPE OF VALUE_ATTR)
 AS
 BEGIN SUSPEND; END
^

/* Alter Procedure... */
/* empty dependent procedure body */
/* Clear: ACTION_RUN for: ACT_ORDER_STORE */
ALTER PROCEDURE ACTION_RUN(I_OBJECT_SIGN TYPE OF SIGN_OBJECT,
I_ACTION_SIGN TYPE OF SIGN_ACTION,
I_PARAM_ID TYPE OF ID_PARAM,
I_OBJECT_ID TYPE OF ID_OBJECT)
 RETURNS(O_ACTION_ID TYPE OF ID_ACTION)
 AS
 BEGIN SUSPEND; END
^

ALTER PROCEDURE ORDERHISTORY_UPDATE(I_ORDER_ID TYPE OF ID_ORDER,
I_STATUS_ID TYPE OF ID_STATUS,
I_STATE_ID TYPE OF ID_STATUS)
 AS
declare variable V_STATUS_ID type of ID_STATUS;
declare variable V_STATE_ID type of ID_STATUS;
begin
  select coalesce(oh.status_id, 0), coalesce(oh.state_id, 0)
    from orderhistory oh
    where oh.order_id = :i_order_id
    order by oh.action_dtm desc
    into :v_status_id, :v_state_id;
  if ((:i_status_id <> :v_status_id) or (coalesce(:i_state_id, 0) <> :v_state_id)) then
  begin
    insert into orderhistory(order_id, status_id, state_id)
      values (:i_order_id, :i_status_id, :i_state_id);
  end
end
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

/* empty dependent procedure body */
/* Clear: ACT_ORDER_DEBIT for: ACTION_DETECT */
ALTER PROCEDURE ACT_ORDER_DEBIT(I_PARAM_ID TYPE OF ID_PARAM,
I_OBJECT_ID TYPE OF ID_OBJECT,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ORDERITEM')
 AS
 BEGIN EXIT; END
^

/* empty dependent procedure body */
/* Clear: ACT_ORDER_FOREACH_ORDERITEM for: ACTION_DETECT */
ALTER PROCEDURE ACT_ORDER_FOREACH_ORDERITEM(I_PARAM_ID TYPE OF ID_PARAM,
I_OBJECT_ID TYPE OF ID_OBJECT,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ORDERITEM')
 AS
 BEGIN EXIT; END
^

/* empty dependent procedure body */
/* Clear: ACT_ORDER_FOREACH_ORDERTAX for: ACTION_DETECT */
ALTER PROCEDURE ACT_ORDER_FOREACH_ORDERTAX(I_PARAM_ID TYPE OF ID_PARAM,
I_OBJECT_ID TYPE OF ID_OBJECT,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ORDERTAX')
 AS
 BEGIN EXIT; END
^

/* empty dependent procedure body */
/* Clear: ACT_ORDER_FOREACH_TAXRATE for: ACTION_DETECT */
ALTER PROCEDURE ACT_ORDER_FOREACH_TAXRATE(I_PARAM_ID TYPE OF ID_PARAM,
I_OBJECT_ID TYPE OF ID_OBJECT,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ORDERTAX')
 AS
 BEGIN EXIT; END
^

/* empty dependent procedure body */
/* Clear: ACTION_EXECUTE for: ACTION_DETECT */
ALTER PROCEDURE ACTION_EXECUTE(I_OBJECT_SIGN TYPE OF SIGN_OBJECT,
I_PARAMS TYPE OF VALUE_BLOB,
I_ACTION_SIGN TYPE OF SIGN_ACTION,
I_OBJECT_ID TYPE OF ID_OBJECT)
 RETURNS(O_ACTION_ID TYPE OF ID_ACTION)
 AS
 BEGIN SUSPEND; END
^

/* Alter (ACTION_DETECT) */
ALTER PROCEDURE ACTION_DETECT(I_OBJECT_SIGN TYPE OF SIGN_OBJECT,
I_OBJECT_ID TYPE OF ID_OBJECT,
I_NEW_STATUS_SIGN TYPE OF SIGN_OBJECT)
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

  select s.status_id
    from statuses s
    where s.status_sign = :i_new_status_sign
      and s.object_sign = :i_object_sign
    into :v_new_status_id;

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

/* empty dependent procedure body */
/* Clear: ACTION_RERUN for: ACTION_EXECUTE */
ALTER PROCEDURE ACTION_RERUN(I_LOG_ID TYPE OF ID_LOG)
 AS
 BEGIN EXIT; END
^

/* empty dependent procedure body */
/* Clear: ACTION_RERUN_ACTION for: ACTION_EXECUTE */
ALTER PROCEDURE ACTION_RERUN_ACTION(I_LOG_ID TYPE OF ID_LOG)
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
  else
  begin
    select s.status_sign
      from statuses s
      where s.status_id = :v_now_status_id
      into :v_now_status_sign;
  end
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

/* empty dependent procedure body */
/* Clear: MESSAGE_CREATE for: ACTION_RUN */
ALTER PROCEDURE MESSAGE_CREATE(I_FILE_NAME TYPE OF NAME_FILE,
I_FILE_SIZE TYPE OF SIZE_FILE,
I_FILE_DTM TYPE OF DTM_FILE)
 RETURNS(O_MESSAGE_ID TYPE OF ID_MESSAGE)
 AS
 BEGIN SUSPEND; END
^

/* empty dependent procedure body */
/* Clear: ORDER_ANUL for: ACTION_RUN */
ALTER PROCEDURE ORDER_ANUL(I_ORDER_ID TYPE OF ID_ORDER)
 RETURNS(O_NEW_STATUS_SIGN TYPE OF SIGN_OBJECT)
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

ALTER PROCEDURE SPLITSTRING(I_STRING TYPE OF VALUE_ATTR,
I_DEVIDER TYPE OF DEVIDER)
 RETURNS(O_HEAD TYPE OF VALUE_ATTR,
O_TILE TYPE OF VALUE_ATTR)
 AS
begin
  o_head = nullif(copyfront_withkey(:i_string, :i_devider), '');
  if (o_head is null) then
    o_head = i_string;
  else
  begin
    o_tile = nullif(substring(:i_string from strlen(o_Head)+1), '');
    o_head = nullif(copyfront_withoutkey(:o_Head, :i_devider), '');
  end
  suspend;
end
^

/* Alter (IMP_CLIENTS) */
ALTER PROCEDURE IMP_CLIENTS(I_CLIENT_ID INTEGER = 0)
 AS
declare variable V_FIRST_NAME type of NAME_REF;
declare variable V_LAST_NAME type of NAME_REF;
declare variable V_MID_NAME type of NAME_REF;
declare variable V_CLIENT_ID type of ID_CLIENT;
declare variable V_FAMILY type of NAME_REF;
declare variable V_STREET type of NAME_REF;
declare variable V_HOME type of NAME_REF;
declare variable V_CITYGET_ID type of VALUE_INTEGER;
declare variable V_TELEPHONE type of NAME_REF;
declare variable V_MOBIL type of NAME_REF;
declare variable V_EMAIL type of NAME_REF;
declare variable V_PLACE_NAME type of NAME_REF;
declare variable V_PHONE_CODE type of NAME_REF;
declare variable V_PLACE_TYPE_NAME type of NAME_REF;
declare variable V_REGION_NAME type of NAME_REF;
declare variable V_AREA_NAME type of NAME_REF;
declare variable V_PLACETYPE_CODE type of CODE_PLACETYPE;
declare variable V_AREA_ID type of ID_PLACE;
declare variable V_PLACE_ID type of ID_PLACE;
declare variable V_STREETTYPE_NAME type of NAME_REF;
declare variable V_STREETTYPE_CODE type of CODE_PLACETYPE;
declare variable V_HOUSE type of NAME_REF;
declare variable V_BUILDING type of NAME_REF;
declare variable V_FLAT type of NAME_REF;
begin
  delete from clients where client_id < 0;

  for select -cast(ic.client_id as id_client), replace(ic.family, '.', ' '), ic.street, ic.home, ic.cityget_id,
              ic.telephone, ic.email, replace(ic.kodmob, '375', '0')||ic.mobil
         from imp_client ic
         where ic.client_id > :i_client_id
         into :v_client_id, :v_family, :v_street, :v_home, :v_cityget_id,
              :v_telephone, :v_email, :v_mobil do
  begin
    select o_head, o_tile from splitstring(:v_family, ' ') into :v_last_name, :v_family;
    select trim(o_head), trim(o_tile) from splitstring(trim(:v_family), ' ') into :v_first_name, :v_mid_name;

    select trim(cg.city_rus), trim(replace(cg.kodtel, '8-', '')), coalesce(ct.nametype, 'г'), r.namereg, o.nameobl
      from imp_cityget cg
        left join imp_citytype ct on (ct.type_id = cg.type_id)
        left join imp_oblast o on (o.oblast_id = cg.oblast_id)
        left join imp_region r on (r.region_id = cg.region_id)
      where cg.city_id = :v_cityget_id
      into :v_place_name, :v_phone_code, :v_place_type_name, :v_area_name, :v_region_name;

    select pt.placetype_code
      from placetypes pt
      where pt.placetype_sign = :v_place_type_name
      into :v_placetype_code;
    if (v_placetype_code is null) then
      exception ex_import 'Unknown PLACETYPE '||coalesce(:v_place_type_name, 'null');


    select pl.place_id
      from places pl
      where pl.place_name = :v_place_name
        and pl.placetype_code = :v_placetype_code
      into :v_place_id;

    if (row_count = 0) then
    begin
      select pl.place_id
        from places pl
       where pl.place_name = :v_area_name
         and pl.placetype_code = 3
        into :v_area_id;
      if (row_count = 0) then
        exception ex_import 'Unknown AREANAME='||coalesce(:v_area_name, 'null')||' CLIENT_ID='||:v_client_id;
    end

    select pl.place_id
      from places pl
      where pl.place_name = :v_place_name
        and pl.placetype_code = :v_placetype_code
      into :v_place_id;

    -- create place
    if (v_place_id is null) then
      insert into places (placetype_code, place_name, owner_place)
        values(:v_placetype_code, :v_place_name, :v_area_id)
        returning place_id
        into :v_place_id;

    -- create client
    insert into clients (client_id, last_name, first_name, mid_name, mobile_phone)
      values(:v_client_id, :v_last_name, :v_first_name, :v_mid_name, :v_mobil);

    if (:v_telephone is not null) then
    begin
      select trim(o_head) from splitstring(:v_telephone, ' ') into :v_telephone;
      v_telephone = replace(:v_telephone, '(', '');
      v_telephone = replace(:v_telephone, ')', '');
      if (strlen(:v_telephone) < 8) then
        v_telephone = :v_phone_code||:v_telephone;
      if (v_telephone is null) then
        exception ex_import 'Phone AREACODE is NULL CityGet='||:v_cityget_id;
      execute procedure attr_put('CLIENT', :v_client_id, 'PHONE_NUMBER', :v_telephone);
    end
    if (:v_email is not null) then
      execute procedure attr_put('CLIENT', :v_client_id, 'EMAIL', :v_email);

    select o_head from splitstring(:v_street, ' ') into :v_streettype_name;
    if (:v_streettype_name <> :v_street) then
    begin
      select st.streettype_code
        from streettypes st
        where st.streettype_short = :v_streettype_name
        into :v_streettype_code;
      if (row_count = 0) then
        exception ex_import 'unknown streettypes '||coalesce(:v_streettype_name, 'null');
      v_street= substring(v_street from char_length(v_streettype_name)+1);
    end
    else
      select st.streettype_code
        from streettypes st
        where st.streettype_short = 'ул'
        into :v_streettype_code;

    if (v_home like '%-%-%') then
    begin
      select trim(o_head), trim(o_tile) from splitstring(:v_home, '-') into :v_house, :v_home;
      select trim(o_head), trim(o_tile) from splitstring(:v_home, '-') into :v_building, :v_flat;
    end
    else if (v_home like '%/%-%') then
    begin
      select trim(o_head), trim(o_tile) from splitstring(:v_home, '/') into :v_house, :v_home;
      select trim(o_head), trim(o_tile) from splitstring(:v_home, '-') into :v_building, :v_flat;
    end
    else
    begin
      select trim(o_head), trim(o_tile) from splitstring(:v_home, '-') into :v_house, :v_flat;
      v_building = null;
    end

    -- create adress
    insert into adresses (adress_id, client_id, place_id, streettype_code,
      street_name, house, building, flat)
      values(:v_client_id, :v_client_id, :v_place_id, :v_streettype_code,
        :v_street, :v_house, :v_building, :v_flat);

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

/* empty dependent procedure body */
/* Clear: NOTIFY_CREATE for: PARAM_UNPARSE */
ALTER PROCEDURE NOTIFY_CREATE(I_MESSAGE_ID TYPE OF ID_MESSAGE,
I_NOTIFY_TEXT TYPE OF VALUE_ATTR,
I_PARAMS TYPE OF VALUE_BLOB,
I_STATE TYPE OF VALUE_CHAR)
 RETURNS(O_NOTIFY_ID TYPE OF ID_NOTIFY)
 AS
 BEGIN SUSPEND; END
^

/* Alter (PARAM_UNPARSE) */
ALTER PROCEDURE PARAM_UNPARSE(I_PARAM_ID TYPE OF ID_PARAM,
I_PARAMS TYPE OF VALUE_BLOB)
 AS
declare variable V_LINE type of VALUE_ATTR;
declare variable V_PARAM_SIGN type of SIGN_OBJECT;
declare variable V_PARAM_VALUE type of VALUE_ATTR;
begin
  for select o_line from splitblob(:i_params, ascii_char(13)||ascii_char(10))
    where o_line <> ''
    into :v_line
  do begin
    select trim(o_head), trim(o_tile) from splitstring(:v_line, '=')
      into :v_param_sign, :v_param_value;
    if (v_param_value like '"%"') then
      v_param_value = substring(v_param_value from 2 for strlen(v_param_value)-2);

    update or insert into params(param_id, param_name, param_value)
      values(:i_param_id, :v_param_sign, unescapestring(:v_param_value))
      matching (param_id, param_name);
  end
end
^

/* Alter (PLACE_READ) */
ALTER PROCEDURE PLACE_READ(I_OBJECT_ID TYPE OF ID_OBJECT)
 RETURNS(O_PARAM_NAME TYPE OF SIGN_OBJECT,
O_PARAM_VALUE TYPE OF VALUE_ATTR)
 AS
declare variable V_REGION_NAME type of NAME_OBJECT;
declare variable V_AREA_NAME type of NAME_OBJECT;
declare variable V_PLACETYPE_SIGN type of NAME_SHORT;
begin
  select p.area_name, p.region_name, p.placetype_sign
    from v_places p
    where p.place_id = :i_object_id
    into :v_area_name, :v_region_name, :v_placetype_sign;

  if (:v_area_name is not null) then
  begin
    o_param_name = 'AREA_NAME';
    o_param_value = :v_area_name;
    suspend;
  end

  if (:v_region_name is not null) then
  begin
    o_param_name = 'REGION_NAME';
    o_param_value = :v_region_name;
    suspend;
  end

  o_param_name = 'PLACETYPE_SIGN';
  o_param_value = :v_placetype_sign;
  suspend;

end
^

/* Alter (SPLITBLOB) */
ALTER PROCEDURE SPLITBLOB(I_BLOB TYPE OF VALUE_BLOB,
I_DEVIDER TYPE OF DEVIDER)
 RETURNS(O_LINE TYPE OF VALUE_ATTR)
 AS
declare variable V_POS type of VALUE_INTEGER;
declare variable V_STR type of VALUE_ATTR;
begin
  v_pos = 1;
  v_str = substring(:i_blob from v_pos for 4000);
  while (char_length(v_str) > 0) do
  begin
    select o_head from splitstring(:v_str, :i_devider) into :o_line;
    v_pos = v_pos + char_length(:o_line) + 2;
    suspend;
    v_str = substring(:i_blob from v_pos for 4000);
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

/* Restore proc. body: NOTIFY_CREATE */
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

SET TERM ; ^

ALTER TABLE PLACES ALTER COLUMN PLACE_ID POSITION 1;

ALTER TABLE PLACES ALTER COLUMN PLACETYPE_CODE POSITION 2;

ALTER TABLE PLACES ALTER COLUMN OWNER_PLACE POSITION 3;

ALTER TABLE PLACES ALTER COLUMN PLACE_NAME POSITION 4;

ALTER TABLE PLACES ALTER COLUMN STATUS_ID POSITION 5;

/* Create(Add) Crant */
GRANT ALL ON V_CLIENTADRESS TO ELENA;

GRANT ALL ON V_CLIENTADRESS TO NASTYA;

GRANT ALL ON V_CLIENTADRESS TO NASTYA17;

GRANT ALL ON V_CLIENTADRESS TO NATVL;

GRANT ALL ON V_CLIENTADRESS TO ND;

GRANT ALL ON V_CLIENTADRESS TO SYSDBA WITH GRANT OPTION;

GRANT ALL ON V_CLIENTADRESS TO USERS WITH GRANT OPTION;

GRANT ALL ON V_CLIENTADRESS TO YULYA;

GRANT ALL ON V_PLACE_TEXT TO ELENA;

GRANT ALL ON V_PLACE_TEXT TO NASTYA;

GRANT ALL ON V_PLACE_TEXT TO NASTYA17;

GRANT ALL ON V_PLACE_TEXT TO NATVL;

GRANT ALL ON V_PLACE_TEXT TO ND;

GRANT ALL ON V_PLACE_TEXT TO SYSDBA WITH GRANT OPTION;

GRANT ALL ON V_PLACE_TEXT TO USERS WITH GRANT OPTION;

GRANT ALL ON V_PLACE_TEXT TO YULYA;

GRANT ALL ON V_PLACES TO ELENA;

GRANT ALL ON V_PLACES TO NASTYA;

GRANT ALL ON V_PLACES TO NASTYA17;

GRANT ALL ON V_PLACES TO NATVL;

GRANT ALL ON V_PLACES TO ND;

GRANT ALL ON V_PLACES TO SYSDBA WITH GRANT OPTION;

GRANT ALL ON V_PLACES TO USERS WITH GRANT OPTION;

GRANT ALL ON V_PLACES TO YULYA;

GRANT USERS TO ELENA;

GRANT USERS TO NASTYA;

GRANT USERS TO NASTYA17;

GRANT USERS TO NATVL;

GRANT USERS TO ND;

GRANT USERS TO YULYA;


