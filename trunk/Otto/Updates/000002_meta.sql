/* Server version: WI-V6.3.0.26074 Firebird 2.5 
   SQLDialect: 3. ODS: 11.2. Forced writes: On. Sweep inteval: 20000.
   Page size: 4096. Cache pages: 2048 (8192 Kb). Read-only: False. */
SET NAMES CYRL;

SET SQL DIALECT 3;

SET AUTODDL ON;

/* Create Procedure... */
SET TERM ^ ;

CREATE PROCEDURE ORDERITEM_X_GETSTATEID(I_DEST_PARAM_ID TYPE OF ID_PARAM,
I_PARAM_NAME TYPE OF SIGN_ATTR,
I_SRC_PARAM_ID TYPE OF ID_PARAM)
 AS
 BEGIN EXIT; END
^


/* Alter Procedure... */
/* Alter (STATUS_STORE_DATE) */
ALTER PROCEDURE STATUS_STORE_DATE(I_OBJECT_ID TYPE OF ID_OBJECT,
I_STATUS_ID TYPE OF ID_STATUS)
 AS
declare variable V_OBJECT_SIGN type of SIGN_OBJECT;
declare variable V_STATUS_SIGN type of SIGN_ATTR;
declare variable V_STORE_DATE type of BOOLEAN;
begin
  select s.object_sign, s.status_sign, s.store_date
    from statuses s
    where s.status_id = :i_status_id
    into :v_object_sign, :v_status_sign, :v_store_date;
  if (v_store_date = 1) then
  begin
    execute procedure attr_put(:v_object_sign, :i_object_id, 'DTM.'||:v_status_sign, current_timestamp);
  end
end
^

/* Restore proc. body: ORDERITEM_X_GETSTATEID */
ALTER PROCEDURE ORDERITEM_X_GETSTATEID(I_DEST_PARAM_ID TYPE OF ID_PARAM,
I_PARAM_NAME TYPE OF SIGN_ATTR,
I_SRC_PARAM_ID TYPE OF ID_PARAM)
 AS
declare variable V_UNPAID_INVOICE_COUNT type of VALUE_INTEGER;
declare variable V_STATE_ID type of ID_STATUS;
declare variable V_STATE_SIGN type of SIGN_OBJECT;
declare variable V_STORE_DATE type of VALUE_BOOLEAN;
begin
  select o_value from param_get(:i_src_param_id, 'NEW.STATE_SIGN') into :v_state_sign;

  select s.status_id, s.store_date
    from statuses s
    where s.status_sign = :v_state_sign
      and s.object_sign = 'ORDERITEM'
    into :v_state_id, :v_store_date;

  execute procedure param_set(:i_dest_param_id, :i_param_name, :v_state_id);
  if (:v_store_date = 1) then
  begin
    execute procedure param_set(:i_dest_param_id, 'DTM.'||:v_state_sign, current_timestamp);
  end
end
^

/* Alter Procedure... */
SET TERM ; ^

INSERT INTO BUILDS (BUILD) VALUES (2);
