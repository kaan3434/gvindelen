/* Server version: WI-V6.3.1.26351 Firebird 2.5 
   SQLDialect: 3. ODS: 11.2. Forced writes: On. Sweep inteval: 20000.
   Page size: 4096. Cache pages: 2048 (8192 Kb). Read-only: False. */
SET CLIENTLIB 'fbclient.dll';
SET NAMES CYRL;

SET SQL DIALECT 3;

SET AUTODDL ON;

/* Create Procedure... */
SET TERM ^ ;

CREATE PROCEDURE PLACE_READ(I_OBJECT_ID TYPE OF ID_OBJECT NOT NULL)
 RETURNS(O_PARAM_NAME TYPE OF SIGN_OBJECT,
O_PARAM_VALUE TYPE OF VALUE_ATTR)
 AS
 BEGIN SUSPEND; END
^


/* Alter Procedure... */
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

/* Restore proc. body: PLACE_READ */
ALTER PROCEDURE PLACE_READ(I_OBJECT_ID TYPE OF ID_OBJECT NOT NULL)
 RETURNS(O_PARAM_NAME TYPE OF SIGN_OBJECT,
O_PARAM_VALUE TYPE OF VALUE_ATTR)
 AS
declare variable V_REGION_NAME type of NAME_OBJECT;
declare variable V_AREA_NAME type of NAME_OBJECT;
begin
  select p.area_name, p.region_name
    from v_places p
    where p.place_id = :i_object_id
    into :v_area_name, :v_region_name;

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
end
^

/* Alter Procedure... */
SET TERM ; ^

