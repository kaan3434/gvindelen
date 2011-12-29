/* Server version: WI-V6.3.1.26351 Firebird 2.5 
SET CLIENTLIB 'fbclient.dll';
   SQLDialect: 3. ODS: 11.2. Forced writes: On. Sweep inteval: 20000.
   Page size: 4096. Cache pages: 2048 (8192 Kb). Read-only: False. */
SET NAMES CYRL;

SET SQL DIALECT 3;


SET AUTODDL ON;

/* Alter Procedure... */
/* Alter (ACT_ACCOUNT_PAYMENTIN) */
SET TERM ^ ;

ALTER PROCEDURE ACT_ACCOUNT_PAYMENTIN(I_PARAM_ID TYPE OF ID_PARAM,
I_OBJECT_ID TYPE OF ID_OBJECT,
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

  v_amount_eur = cast(v_amount_byr as numeric(18,2)) / v_byr2eur;

  execute procedure param_set(:i_param_id, 'ORDER_CODE', :v_order_code);
  execute procedure param_set(:i_param_id, 'BYR2EUR', :v_byr2eur);
  execute procedure param_set(:i_param_id, 'AMOUNT_EUR', :v_amount_eur);

  select o_pattern from param_fillpattern(:i_param_id, :v_notes) into :v_notes;

  insert into accopers (account_id, amount_eur, byr2eur, order_id, notes)
    values(:i_object_id, :v_amount_eur, :v_byr2eur, :v_order_id, :v_notes);
end
^

SET TERM ; ^

