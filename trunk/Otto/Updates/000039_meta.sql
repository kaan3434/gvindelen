/* Server version: WI-V6.3.1.26351 Firebird 2.5 
   SQLDialect: 3. ODS: 11.2. Forced writes: On. Sweep inteval: 20000.
   Page size: 4096. Cache pages: 2048 (8192 Kb). Read-only: False. */
SET CLIENTLIB 'fbclient.dll';
SET NAMES CYRL;

SET SQL DIALECT 3;

SET AUTODDL ON;

/* Alter View (Drop, Create)... */
/* Drop altered view: V_ADRESS_TEXT */
SET TERM ^ ;

ALTER PROCEDURE ORDER_READ(I_OBJECT_ID /* TYPE OF ID_OBJECT */ INTEGER)
 RETURNS(O_PARAM_NAME /* TYPE OF SIGN_OBJECT */ VARCHAR(30),
O_PARAM_VALUE /* TYPE OF VALUE_ATTR */ VARCHAR(4000))
 AS
 BEGIN SUSPEND; END
^

SET TERM ; ^

DROP VIEW V_CLIENTADRESS;

DROP VIEW V_ORDERS;

DROP VIEW V_ADRESS_TEXT;

/* Create altered view: V_ADRESS_TEXT */
/* Create view: V_ADRESS_TEXT */
CREATE VIEW V_ADRESS_TEXT(
ADRESS_ID,
PLACE_ID,
CLIENT_ID,
ADRESS_TEXT,
STATUS_ID,
STATUS_SIGN,
POSTINDEX)
 AS 
select
  a.adress_id,
  a.place_id,
  a.client_id,
  iif(a.street_name is null, '', st.streettype_sign||'. '||a.street_name)
    ||' '||a.house||
    iif(a.building is null, '',', корп. '||a.building)||
    iif(a.flat is null, '', ', кв. '||a.flat),
  a.status_id,
  s.status_sign,
  a.postindex
from adresses a
 inner join streettypes  st on (st.streettype_code = coalesce(a.streettype_code, 1))
 inner join statuses s on (s.status_id = a.status_id)
;

/* Drop altered view: V_CLIENTADRESS */
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
ADRESS_TEXT)
 AS 
select c.client_id, cast(c.last_name||' '||c.first_name||' '||c.mid_name as varchar(100)),
  c.last_name, c.first_name, c.mid_name, c.status_id,
  c.mobile_phone, ca_mail.attr_value, ca_phone.attr_value,
  p.place_id, p.place_text, a.adress_id, a.adress_text
  from clients c
    inner join v_adress_text a on (a.client_id = c.client_id and a.status_sign<>'ARCHIVE')
    inner join v_place_text p on (p.place_id = a.place_id)
    left join v_client_attrs ca_phone on (ca_phone.object_id = c.client_id and ca_phone.attr_sign = 'PHONE_NUMBER')
    left join v_client_attrs ca_mail on (ca_mail.object_id = c.client_id and ca_mail.attr_sign = 'EMAIL')
;

/* Alter Procedure... */
/* Alter (ORDER_READ) */
SET TERM ^ ;

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
  select p.product_name, vc.client_fio, va.adress_text,
         s.status_sign, s.flag_sign_list, s.status_name
    from orders o
      left join products p on (p.product_id = o.product_id)
      left join v_clients_fio vc on (vc.client_id = o.client_id)
      left join v_adress_text va on (va.adress_id = o.adress_id)
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

/* Creating trigger... */
CREATE TRIGGER ADRESSES_AI0 FOR ADRESSES
ACTIVE AFTER INSERT POSITION 0 
AS
  declare variable v_arc_status_id id_status;
begin
  select status_id
    from statuses s
    where s.object_sign = 'ADRESS'
      and s.status_sign = 'ARCHIVE'
    into :v_arc_status_id;
  update adresses a
    set a.status_id = :v_arc_status_id
    where a.adress_id <> new.adress_id
      and a.client_id = new.client_id
      and a.status_id <> :v_arc_status_id;
end
^


/* Create Views... */
/* Create view: V_ORDERS */
SET TERM ; ^

CREATE VIEW V_ORDERS(
ORDER_ID,
ORDER_CODE,
PRODUCT_ID,
PRODUCT_NAME,
VENDOR_ID,
VENDOR_NAME,
CLIENT_ID,
CLIENT_FIO,
ADRESS_ID,
ADRESS_TEXT,
CREATE_DTM,
STATUS_ID,
STATUS_NAME,
STATUS_SIGN,
STATUS_DTM)
 AS 
select 
    orders.order_id,
    orders.order_code,
    orders.product_id,
    products.product_name,
    products.vendor_id,
    vendors.vendor_name,
    orders.client_id,
    v_clients_fio.client_fio,
    orders.adress_id,
    v_adress_text.adress_text,
    orders.create_dtm,
    orders.status_id,
    statuses.status_name,
    statuses.status_sign,
    orders.status_dtm
from orders
   inner join products on (orders.product_id = products.product_id)
   inner join vendors on (products.vendor_id = vendors.vendor_id)
   inner join v_clients_fio on (orders.client_id = v_clients_fio.client_id)
   inner join v_adress_text on (orders.adress_id = v_adress_text.adress_id)
   inner join statuses on (orders.status_id = statuses.status_id)
;


/* Create(Add) privilege */
GRANT ALL ON V_ADRESS_TEXT TO ANNA;

GRANT ALL ON V_ADRESS_TEXT TO ELENA;

GRANT ALL ON V_ADRESS_TEXT TO KATYA;

GRANT ALL ON V_ADRESS_TEXT TO LENA;

GRANT ALL ON V_ADRESS_TEXT TO NASTYA;

GRANT ALL ON V_ADRESS_TEXT TO NASTYA17;

GRANT ALL ON V_ADRESS_TEXT TO NATVL;

GRANT ALL ON V_ADRESS_TEXT TO ND;

GRANT ALL ON V_ADRESS_TEXT TO SYSDBA WITH GRANT OPTION;

GRANT ALL ON V_ADRESS_TEXT TO USERS WITH GRANT OPTION;

GRANT ALL ON V_ADRESS_TEXT TO YULYA;

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

GRANT ALL ON V_CLIENTADRESS TO YULYA;

GRANT ALL ON V_ORDERS TO ANNA;

GRANT ALL ON V_ORDERS TO ELENA;

GRANT ALL ON V_ORDERS TO KATYA;

GRANT ALL ON V_ORDERS TO LENA;

GRANT ALL ON V_ORDERS TO NASTYA;

GRANT ALL ON V_ORDERS TO NASTYA17;

GRANT ALL ON V_ORDERS TO NATVL;

GRANT ALL ON V_ORDERS TO ND;

GRANT ALL ON V_ORDERS TO SYSDBA WITH GRANT OPTION;

GRANT ALL ON V_ORDERS TO USERS WITH GRANT OPTION;

GRANT ALL ON V_ORDERS TO YULYA;


