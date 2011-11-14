/* Server version: WI-V6.3.1.26351 Firebird 2.5 
SET CLIENTLIB 'fbclient.dll';
   SQLDialect: 3. ODS: 11.2. Forced writes: On. Sweep inteval: 20000.
   Page size: 4096. Cache pages: 2048 (8192 Kb). Read-only: False. */
SET NAMES CYRL;

SET SQL DIALECT 3;

SET AUTODDL ON;

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

  select sum(coalesce(a.weight, 1))
    from orderitems oi
      left join articles a on (a.article_id = oi.article_id)
    where oi.order_id = :v_order_id
    into :v_amount;

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

SET TERM ; ^

INSERT INTO BUILDS (BUILD) VALUES (6);
