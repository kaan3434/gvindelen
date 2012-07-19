/* Server version: WI-V6.3.1.26351 Firebird 2.5 
   SQLDialect: 3. ODS: 11.2. Forced writes: On. Sweep inteval: 20000.
   Page size: 4096. Cache pages: 2048 (8192 Kb). Read-only: False. */
SET CLIENTLIB 'fbclient.dll';
SET NAMES CYRL;

SET SQL DIALECT 3;

SET AUTODDL ON;

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
  select p.product_name, vc.client_fio,
         ca.postindex||'. '||ca.place_text||', '||ca.adress_text adress_text,
         s.status_sign, s.flag_sign_list, s.status_name
    from orders o
      left join products p on (p.product_id = o.product_id)
      left join v_clients_fio vc on (vc.client_id = o.client_id)
      left join v_clientadress ca on (ca.adress_id = o.adress_id)
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

SET TERM ; ^

