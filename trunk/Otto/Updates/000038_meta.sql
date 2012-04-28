/* Server version: WI-V6.3.1.26351 Firebird 2.5 
   SQLDialect: 3. ODS: 11.2. Forced writes: On. Sweep inteval: 20000.
   Page size: 4096. Cache pages: 2048 (8192 Kb). Read-only: False. */
SET CLIENTLIB 'fbclient.dll';
SET NAMES CYRL;

SET SQL DIALECT 3;

SET AUTODDL ON;

/* Alter Procedure... */
/* Alter (TAX_WEIGHT) */
SET TERM ^ ;

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

  select oa.attr_value
    from v_order_attrs oa
    where oa.object_id = :v_order_id
      and oa.attr_sign = 'WEIGHT'
      into :v_amount;

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

