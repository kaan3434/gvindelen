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

/* Alter (ORDERITEM_READ) */
ALTER PROCEDURE ORDERITEM_READ(I_OBJECT_ID TYPE OF ID_OBJECT)
 RETURNS(O_PARAM_NAME TYPE OF SIGN_OBJECT,
O_PARAM_VALUE TYPE OF VALUE_ATTR)
 AS
declare variable V_ARTICLE_ID type of ID_ARTICLE;
declare variable V_WEIGHT type of VALUE_INTEGER;
declare variable V_STATUS_SIGN type of SIGN_OBJECT;
declare variable V_STATUS_FLAG_LIST type of LIST_SIGNS;
declare variable V_STATE_SIGN type of SIGN_OBJECT;
declare variable V_STATE_FLAG_LIST type of LIST_SIGNS;
declare variable V_STATUS_NAME type of NAME_OBJECT;
declare variable V_STATE_NAME type of NAME_OBJECT;
begin
  select s.status_sign, s.flag_sign_list, s.status_name,
         ss.status_sign, ss.flag_sign_list, ss.status_name
    from orderitems oi
      inner join statuses s on (s.status_id = oi.status_id)
      left join statuses ss on (ss.status_id = oi.state_id)
    where oi.orderitem_id = :i_object_id
    into :v_status_sign, :v_status_flag_list, :v_status_name,
         :v_state_sign, :v_state_flag_list, :v_state_name;

  o_param_name = 'STATUS_SIGN';
  o_param_value = v_status_sign;
  suspend;

  o_param_name = 'STATUS_FLAG_LIST';
  o_param_value = v_status_flag_list;
  suspend;

  o_param_name = 'STATUS_NAME';
  o_param_value = v_status_name;
  suspend;


  if (v_state_sign is not null) then
  begin
    o_param_name = 'STATE_SIGN';
    o_param_value = v_state_sign;
    suspend;

    o_param_name = 'STATE_FLAG_LIST';
    o_param_value = v_state_flag_list;
    suspend;

    o_param_name = 'STATE_NAME';
    o_param_value = v_state_name;
    suspend;
  end
end
^

/* Alter (ORDERTAX_READ) */
ALTER PROCEDURE ORDERTAX_READ(I_OBJECT_ID TYPE OF ID_OBJECT)
 RETURNS(O_PARAM_NAME TYPE OF SIGN_OBJECT,
O_PARAM_VALUE TYPE OF VALUE_ATTR)
 AS
declare variable V_TAXSERV_ID type of ID_TAX;
declare variable V_TAXSERV_NAME type of NAME_REF;
declare variable V_STATUS_SIGN type of SIGN_OBJECT;
declare variable V_STATUS_NAME type of NAME_OBJECT;
begin
  select ts.taxserv_id, ts.taxserv_name, s.status_sign, s.status_name
    from ordertaxs ot
      inner join taxrates tr on (tr.taxrate_id = ot.taxrate_id)
      inner join taxservs ts on (ts.taxserv_id = tr.taxserv_id)
      inner join statuses s on (s.status_id = ot.status_id)
    where ot.ordertax_id = :i_object_id
    into :v_taxserv_id, :v_taxserv_name, :v_status_sign, :v_status_name;

  o_param_name = 'TAXSERV_ID';
  o_param_value = :v_taxserv_id;
  suspend;
  o_param_name = 'TAXSERV_NAME';
  o_param_value = :v_taxserv_name;
  suspend;
  o_param_name = 'STATUS_SIGN';
  o_param_value = v_status_sign;
  suspend;
  o_param_name = 'STATUS_NAME';
  o_param_value = v_status_name;
  suspend;

end
^

/* Altering existing trigger... */
ALTER TRIGGER ORDERITEMS_BU0
AS
declare variable v_flaglist list_signs;
begin
  new.article_code = upper(new.article_code);
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

/* Altering existing trigger... */
ALTER TRIGGER ORDERS_BU0
AS
begin
  if (old.status_id <> new.status_id) then
  begin
    new.status_dtm = current_timestamp;
    new.state_id = null;
  end
end
^

/* Create(Add) Crant */
SET TERM ; ^

GRANT USERS TO ELENA;

GRANT USERS TO NASTYA;

GRANT USERS TO NASTYA17;

GRANT USERS TO NATVL;

GRANT USERS TO ND;

GRANT USERS TO YULYA;


