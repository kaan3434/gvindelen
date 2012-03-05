CREATE TABLE IMP_CLIENT(NUMSTR DOUBLE PRECISION,
FILIAL DOUBLE PRECISION,
CLIENT_ID VARCHAR(7),
KOLZAK DOUBLE PRECISION,
SCATALOG DOUBLE PRECISION,
SUSD INTEGER,
SUMALL DOUBLE PRECISION,
FAMILY VARCHAR(40),
FAMILYMIN VARCHAR(20),
FAMILYENG VARCHAR(25),
STREET VARCHAR(30),
STREETENG VARCHAR(30),
HOME VARCHAR(15),
MOBIL VARCHAR(13),
INDEXCITY VARCHAR(6),
CITY_RUS VARCHAR(26),
CITY_ENG VARCHAR(26),
PARTOBL VARCHAR(41),
OBLENG VARCHAR(41),
GOS VARCHAR(6),
GOSNUM VARCHAR(6),
"_NULLFLAGS" BLOB);



RECONNECT;

/* Drop tables... */
SET TERM ^ ;

ALTER PROCEDURE IMP_CLIENTS(I_CLIENT_ID INTEGER = 0)
 AS
 BEGIN EXIT; END
^

SET TERM ; ^

/* Alter Procedure... */
/* Alter (IMP_CLIENTS) */
SET TERM ^ ;

ALTER PROCEDURE IMP_CLIENTS(I_CLIENT_ID INTEGER = 0)
 RETURNS(O_CLIENT_ID TYPE OF ID_CLIENT,
O_PLACE_ID TYPE OF ID_PLACE)
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
declare variable V_POST_INDEX type of CODE_POSTINDEX;
declare variable V_CITY_NAME type of NAME_OBJECT;
declare variable V_AREA_REGION type of NAME_OBJECT;
declare variable V_ACCOUNT_ID type of ID_ACCOUNT;
begin
  delete from clients where client_id < 0;

  for select -cast(ic.client_id as id_client), replace(ic.family, '.', ' '),
             ic.street, ic.home, replace(ic.mobil, '+375', '0'),
             ic.indexcity, ic.city_rus, ic.partobl
         from imp_client ic
         where ic.client_id > :i_client_id
         order by ic.client_id
         into :v_client_id, :v_family,
              :v_street, :v_home, :v_mobil,
              :v_post_index, :v_city_name, :v_area_region do
  begin
    o_client_id = v_client_id;
    select trim(o_head), trim(o_tile) from splitstring(:v_family, ' ') into :v_last_name, :v_family;
    select trim(o_head), trim(o_tile) from splitstring(:v_family, ' ') into :v_first_name, :v_mid_name;

    select trim(o_head), trim(o_tile) from splitstring(:v_city_name, ' ') into :v_place_type_name, :v_place_name;
    select trim(o_head), trim(o_tile) from splitstring(:v_area_region, ' ') into :v_area_name, :v_region_name;


    if (v_place_name is null) then
    begin
      v_place_name = v_place_type_name;
      v_place_type_name = 'ã';
    end
    select pt.placetype_code
      from placetypes pt
      where pt.placetype_sign = :v_place_type_name
      into :v_placetype_code;
    if (v_placetype_code is null) then
      exception ex_import 'Unknown PLACETYPE '||coalesce(:v_place_type_name, 'null');

    select pl.place_id
      from places pl
      where (pl.place_name = :v_place_name or replace(pl.place_name, '¸', 'e') = :v_place_name)
        and pl.placetype_code = :v_placetype_code
      into :v_place_id;

    if (row_count <> 1) then
    begin
      v_place_id = null;
      select pl.place_id
        from places pl
       where pl.place_name = :v_area_name
         and pl.placetype_code = 3
        into :v_area_id;
      if (row_count = 0) then
        exception ex_import 'Unknown AREANAME for PLACE='||:v_place_name||' CLIENT_ID='||:v_client_id;
      else
        insert into places(place_id, placetype_code, owner_place, place_name)
          values(gen_id(seq_place_id, 1), :v_placetype_code, :v_area_id, :v_place_name)
          returning place_id
          into :v_place_id;
    end
    else
      o_place_id = :v_place_id;

    -- create client
    if (not exists(select c.client_id
        from clients c
          inner join adresses a on (a.client_id = c.client_id)
          inner join places p on (p.place_id = a.place_id)
        where c.last_name = :v_last_name
          and c.first_name = :v_first_name
          and c.mid_name = :v_mid_name)) then
    begin
        insert into clients (client_id, last_name, first_name, mid_name, mobile_phone)
          values(:v_client_id, :v_last_name, :v_first_name, :v_mid_name, :v_mobil);
    
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
            where st.streettype_short = 'óë'
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
          street_name, house, building, flat, postindex)
          values(:v_client_id, :v_client_id, :v_place_id, :v_streettype_code,
            :v_street, :v_house, :v_building, :v_flat, :v_post_index);
    
        -- create account
        insert into accounts(rest_eur)
          values(0)
          returning account_id
          into :v_account_id;
    
        update clients c
          set c.account_id = :v_account_id
          where c.client_id = :v_client_id;
    end
    suspend;
  end
end
^

/* Create(Add) Crant */
SET TERM ; ^

GRANT ALL ON IMP_CLIENT TO SYSDBA WITH GRANT OPTION;

