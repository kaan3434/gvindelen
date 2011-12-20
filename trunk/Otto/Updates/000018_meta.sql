/* Server version: WI-V6.3.1.26351 Firebird 2.5 
SET CLIENTLIB 'fbclient.dll';
   SQLDialect: 3. ODS: 11.2. Forced writes: On. Sweep inteval: 20000.
   Page size: 4096. Cache pages: 2048 (8192 Kb). Read-only: False. */
SET NAMES CYRL;

SET SQL DIALECT 3;

SET AUTODDL ON;

/* Create Table... */
CREATE TABLE ORDERMONEYS(ORDERMONEY_ID ID_ORDERITEM NOT NULL,
ORDER_ID ID_ORDER NOT NULL,
ACCOUNT_ID ID_ACCOUNT NOT NULL,
AMOUNT_EUR MONEY_EUR,
STATUS_ID ID_STATUS NOT NULL,
STATUS_DTM DTM_STATUS);



/* Create Procedure... */
SET TERM ^ ;

CREATE PROCEDURE ACT_ORDERMONEY_STORE(I_PARAM_ID TYPE OF ID_PARAM,
I_OBJECT_ID TYPE OF ID_OBJECT,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ORDERMONEY')
 AS
 BEGIN EXIT; END
^


/* Create generator... */
SET TERM ; ^

CREATE GENERATOR SEQ_ORDERMONEY_ID;


/* Create Primary Key... */
ALTER TABLE ORDERMONEYS ADD CONSTRAINT PK_ORDERMONEYS PRIMARY KEY (ORDERMONEY_ID);

/* Create Foreign Key... */
RECONNECT;

ALTER TABLE ORDERMONEYS ADD CONSTRAINT FK_ORDERMONEYS_ACCOUNT FOREIGN KEY (ACCOUNT_ID) REFERENCES ACCOUNTS (ACCOUNT_ID) ON UPDATE CASCADE;

ALTER TABLE ORDERMONEYS ADD CONSTRAINT FK_ORDERMONEYS_ORDER FOREIGN KEY (ORDER_ID) REFERENCES ORDERS (ORDER_ID) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ORDERMONEYS ADD CONSTRAINT FK_ORDERMONEYS_STATUS FOREIGN KEY (STATUS_ID) REFERENCES STATUSES (STATUS_ID) ON UPDATE CASCADE;

/* Alter Procedure... */
/* Restore proc. body: ACT_ORDERMONEY_STORE */
SET TERM ^ ;

ALTER PROCEDURE ACT_ORDERMONEY_STORE(I_PARAM_ID TYPE OF ID_PARAM,
I_OBJECT_ID TYPE OF ID_OBJECT,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ORDERMONEY')
 AS
declare variable V_NOW_STATUS_ID type of ID_STATUS;
declare variable V_ORDER_ID type of ID_ORDER;
declare variable V_UPDATEABLE type of VALUE_BOOLEAN;
declare variable V_NEW_STATUS_ID type of ID_STATUS;
declare variable V_ACCOUNT_ID type of ID_ACCOUNT;
begin
  if (coalesce(i_object_id, 0) = 0) then i_object_id = gen_id(seq_ordermoney_id, 1);
    
  update paramheads set object_id = :i_object_id where param_id = :i_param_id;
    
  execute procedure param_set(:i_param_id, 'ID', :i_object_id);
    
  select status_id from ordermoneys where ordermoney_id = :i_object_id into :v_now_status_id;

  if (:v_now_status_id is null) then
  begin
    select o_value from param_get(:i_param_id, 'ACCOUNT_ID') into :v_account_id;
    select o_value from param_get(:i_param_id, 'ORDER_ID') into :v_order_id;

    insert into ordermoneys(ordermoney_id, order_id, account_id, status_id)
      values(:i_object_id, :v_order_id, :v_account_id, :v_new_status_id)
      returning status_id
      into :v_new_status_id;
    v_updateable = 1;
  end
  else
  begin
    select o_updateable, o_new_status_id
      from object_updateable(:i_param_id, :v_now_status_id, :i_object_sign)
      into :v_updateable, :v_new_status_id;
  end

  if ((v_updateable = 1) or exists(select o_value from param_get(:i_param_id, 'UPDATEABLE'))) then
  begin
    execute procedure param_set(:i_param_id, 'STATUS_ID', :v_new_status_id);
    execute procedure object_put(:i_param_id);
  end
end
^

/* Create trigger... */
CREATE TRIGGER ORDERMONEYS_BI0 FOR ORDERMONEYS
ACTIVE BEFORE INSERT POSITION 0 
AS
begin
  if (new.ordermoney_id is null) then
    new.ordermoney_id = gen_id(seq_ordermoney_id, 1);
  if (new.status_id is null) then
    select o_status_id from status_get_default('ORDERMONEY') into new.status_id;
  new.status_dtm = current_timestamp;

end
^


/* Alter Procedure... */
/* Create(Add) Crant */
SET TERM ; ^

GRANT ALL ON ORDERMONEYS TO SYSDBA WITH GRANT OPTION;


