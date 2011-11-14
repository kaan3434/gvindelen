/* Server version: WI-V6.3.1.26351 Firebird 2.5 
SET CLIENTLIB 'fbclient.dll';
   SQLDialect: 3. ODS: 11.2. Forced writes: On. Sweep inteval: 20000.
   Page size: 4096. Cache pages: 2048 (8192 Kb). Read-only: False. */
SET NAMES CYRL;

SET SQL DIALECT 3;

SET AUTODDL ON;

/* Create Views... */
/* Create view: V_CLIENT_ATTRS (ViwData.CreateDependDef) */
CREATE VIEW V_CLIENT_ATTRS(
OBJECT_ID,
ATTR_SIGN,
ATTR_VALUE,
ATTR_NAME)
 AS 
select oia.object_id, a.attr_sign, oia.attr_value, a.attr_name
from client_attrs oia
inner join attrs a on (a.attr_id = oia.attr_id)
;
;


/* Alter View (Drop, Create)... */
/* Drop altered view: V_ADRESS_TEXT */
SET TERM ^ ;

ALTER PROCEDURE ORDER_READ(I_OBJECT_ID TYPE OF ID_OBJECT)
 RETURNS(O_PARAM_NAME TYPE OF SIGN_OBJECT,
O_PARAM_VALUE TYPE OF VALUE_ATTR)
 AS
 BEGIN SUSPEND; END
^

SET TERM ; ^

DROP VIEW V_CLIENTADRESS;

DROP VIEW V_ORDERS;

DROP VIEW V_ADRESS_TEXT;

/* Create altered view: V_ADRESS_TEXT */
/* Create view: V_ADRESS_TEXT (ViwData.CreateDependDef) */
CREATE VIEW V_ADRESS_TEXT(
ADRESS_ID,
PLACE_ID,
CLIENT_ID,
ADRESS_TEXT,
STATUS_ID)
 AS 
select
  a.adress_id,
  a.place_id,
  a.client_id,
  iif(a.street_name is null, '', st.streettype_sign||'. '||a.street_name)
    ||' '||a.house||
    iif(a.building is null, '',', корп. '||a.building)||
    iif(a.flat is null, '', ', кв. '||a.flat),
  a.status_id
from adresses a
 inner join streettypes  st on (st.streettype_code = coalesce(a.streettype_code, 1))
;

/* Drop altered view: V_CLIENTADRESS */
/* Create altered view: V_CLIENTADRESS */
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

/* Alter Procedure... */
/* Alter (IMP_CLIENTS) */
SET TERM ^ ;

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
begin
  select p.product_name, vc.client_fio, va.adress_text, s.status_sign
    from orders o
      left join products p on (p.product_id = o.product_id)
      left join v_clients_fio vc on (vc.client_id = o.client_id)
      left join v_adress_text va on (va.adress_id = o.adress_id)
      left join statuses s on (s.status_id = o.status_id)
    where o.order_id = :i_object_id
    into :v_product_name, :v_client_fio, :v_adress_text, :v_status_sign;

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

/* Alter (SEARCH) */
ALTER PROCEDURE SEARCH(I_VALUE TYPE OF NAME_REF,
I_FROM_CLAUSE TYPE OF SQL_STATEMENT,
I_FIELDNAME_ID TYPE OF NAME_PROCEDURE,
I_FIELDNAME_NAME TYPE OF NAME_PROCEDURE,
I_WHERE_CLAUSE TYPE OF SQL_STATEMENT,
I_THRESHOLD TYPE OF VALUE_SMALLINT = 80)
 RETURNS(O_OBJECT_ID TYPE OF ID_OBJECT,
O_OBJECT_NAME TYPE OF NAME_REF,
O_VALID TYPE OF VALUE_SMALLINT)
 AS
declare variable V_SQL type of SQL_STATEMENT;
declare variable V_MASK type of MASK_NGRAMM;
declare variable V_SEARCH_ID type of ID_SEARCH;
declare variable V_STRLEN type of VALUE_SMALLINT;
begin
  if (:i_value is null) then exit;
  -- try find fitness
  v_sql = 'select '||:i_fieldname_id||', '||:i_fieldname_name||', 100'||
          ' from '||:i_from_clause||
          ' where (lower('||:i_fieldname_name||') = lower(:i_value)'||
          ' or cast('||:i_fieldname_id||' as varchar(100)) = :i_value)'||
          ' and '||coalesce(:i_where_clause, '1=1');

  for execute statement (:v_sql) (i_value := :i_value)
    into :o_object_id, :o_object_name, :o_valid do
      suspend;
  if (o_object_id is null) then
  begin
    -- fuzzy search by NGramm
    v_search_id = gen_id(seq_search_id, 1);
    v_strlen = char_length(:i_value);

    for select o_mask from search_get_ngramm(:i_value) into :v_mask
    do begin
      v_sql = 'insert into searches(search_id, object_id, object_name) '||
              'select :v_search_id, '||:i_fieldname_id||', '||:i_fieldname_name||
              ' from '||:i_from_clause||
              ' where lower('||:i_fieldname_name||') like :v_mask '||
              ' and '||coalesce(:i_where_clause, '1=1');
      execute statement (:v_sql) (v_search_id := :v_search_id, v_mask := :v_mask);
    end

    for select object_id id, max(object_name) name, count(object_id)*100/:v_strlen valid
      from searches s
      where search_id = :v_search_id
      group by object_id
      having count(object_id)*100/:v_strlen > :i_threshold
      order by valid desc
      into :o_object_id, :o_object_name, :o_valid
    do begin
      suspend;
    end

    delete from searches where search_id = :v_search_id;
  end
end
^

/* Create Views... */
/* Create view: V_ORDERS (ViwData.CreateDependDef) */
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


/* Create(Add) Crant */
GRANT ALL ON V_ADRESS_TEXT TO SYSDBA WITH GRANT OPTION;

GRANT ALL ON V_CLIENT_ATTRS TO SYSDBA WITH GRANT OPTION;

GRANT ALL ON V_CLIENTADRESS TO SYSDBA WITH GRANT OPTION;

GRANT ALL ON V_ORDERS TO SYSDBA WITH GRANT OPTION;


INSERT INTO BUILDS (BUILD) VALUES (8);
