/* Server version: WI-V6.3.0.26074 Firebird 2.5 
   SQLDialect: 3. ODS: 11.2. Forced writes: On. Sweep inteval: 20000.
   Page size: 4096. Cache pages: 2048 (8192 Kb). Read-only: False. */
SET NAMES CYRL;

SET SQL DIALECT 3;

SET AUTODDL ON;

/* Create Domains... */
CREATE DOMAIN ID_PATTERN AS INTEGER;

/* Declare UDF */
DECLARE EXTERNAL FUNCTION ADDSECOND
TIMESTAMP, INTEGER
RETURNS TIMESTAMP
ENTRY_POINT 'addSecond' MODULE_NAME 'fbudf';


/* Create Table... */
CREATE TABLE BUILDS(BUILD VALUE_INTEGER NOT NULL,
INSTALL_DTM DTM_VALID);



/* Alter Field (Null / Not Null)... */
UPDATE RDB$RELATION_FIELDS SET RDB$NULL_FLAG = 1 WHERE RDB$FIELD_NAME='ACTION_SIGN' AND RDB$RELATION_NAME='STATUS_RULES';


/* Create Procedure... */
SET TERM ^ ;

CREATE PROCEDURE SETTING_SET(I_SETTING_SIGN TYPE OF SIGN_ATTR NOT NULL,
I_VALUE TYPE OF VALUE_ATTR)
 RETURNS(O_SETTING_ID TYPE OF ID_SETTING)
 AS
 BEGIN SUSPEND; END
^


/* Create Primary Key... */
SET TERM ; ^

ALTER TABLE BUILDS ADD CONSTRAINT PK_BUILDS PRIMARY KEY (BUILD);

/* Alter Procedure... */
/* Alter (AALL_CLEAR) */
SET TERM ^ ;

ALTER PROCEDURE AALL_CLEAR(I_CLEAR_ARTICLES SMALLINT)
 AS
declare variable V_OBJECT_ID type of ID_OBJECT;
begin
  delete from orders;
  v_object_id = gen_id(seq_order_id, -(gen_id(seq_order_id, 0)));
  v_object_id = gen_id(seq_orderitem_id, -(gen_id(seq_orderitem_id, 0)));
  v_object_id = gen_id(seq_ordertax_id, -(gen_id(seq_ordertax_id, 0)));

  delete from clients;
  v_object_id = gen_id(seq_client_id, -(gen_id(seq_client_id, 0)));
  v_object_id = gen_id(seq_adress_id, -(gen_id(seq_adress_id, 0)));

  delete from places where place_id > 1000000;
  v_object_id = gen_id(seq_place_id, -(gen_id(seq_place_id, 0))+1000000);

  delete from accounts;
  v_object_id = gen_id(seq_account_id, -(gen_id(seq_account_id, 0)));
  v_object_id = gen_id(seq_accoper_id, -(gen_id(seq_accoper_id, 0)));

  delete from messages;
  v_object_id = gen_id(seq_message_id, -(gen_id(seq_message_id, 0)));
  v_object_id = gen_id(seq_notify_id, -(gen_id(seq_notify_id, 0)));

  delete from actions;
  v_object_id = gen_id(seq_action_id, -(gen_id(seq_action_id, 0)));

  delete from deals;
  v_object_id = gen_id(seq_deal_id, -(gen_id(seq_deal_id, 0)));

  delete from paramheads;
  v_object_id = gen_id(seq_param_id, -(gen_id(seq_param_id, 0)));

  delete from logs;
  v_object_id = gen_id(seq_log_id, -(gen_id(seq_log_id, 0)));

  delete from events;
  v_object_id = gen_id(seq_event_id, -(gen_id(seq_event_id, 0)));

  delete from sessions;
  if (i_clear_articles is not null) then
  begin
    delete from magazines where magazine_id > 1;
    v_object_id = gen_id(seq_magazine_id, -(gen_id(seq_magazine_id, 0))+1);

    delete from articlecodes;
    v_object_id = gen_id(seq_article_id, -(gen_id(seq_article_id, 0)));
    v_object_id = gen_id(seq_articlecode_id, -(gen_id(seq_articlecode_id, 0)));
    v_object_id = gen_id(seq_articlesign_id, -(gen_id(seq_articlesign_id, 0)));
  end

end
^

/* Restore proc. body: SETTING_SET */
ALTER PROCEDURE SETTING_SET(I_SETTING_SIGN TYPE OF SIGN_ATTR NOT NULL,
I_VALUE TYPE OF VALUE_ATTR)
 RETURNS(O_SETTING_ID TYPE OF ID_SETTING)
 AS
declare variable V_VALID_DTM type of DTM_VALID;
begin
  v_valid_dtm = current_timestamp;
  update settings s
    set s.valid_dtm = addsecond(:v_valid_dtm, -1)
    where s.setting_sign = :i_setting_sign
      and s.valid_dtm = '9999.12.31';
  insert into settings (setting_sign, setting_value)
    values(:i_setting_sign, :i_value)
    returning setting_id
    into :o_setting_id;
  suspend;
end
^

/* Creating trigger... */
CREATE TRIGGER BUILDS_BI0 FOR BUILDS
ACTIVE BEFORE INSERT POSITION 0 
AS
begin
  new.install_dtm = current_timestamp;
end
^


/* Altering existing trigger... */
ALTER TRIGGER SETTINGS_BI0
AS
begin
  if (new.setting_id is null) then
    new.setting_id = gen_id(seq_setting_id, 1);
  if (new.valid_dtm is null) then
    new.valid_dtm = '9999.12.31';
end
^

CREATE OR ALTER TRIGGER REGISTER_SESSION
ACTIVE ON CONNECT POSITION 0
AS
begin
  delete from sessions where session_id >= current_connection;

  insert into sessions(session_id, user_name, start_dtm, finish_dtm)
    values(current_connection, current_user, current_timestamp, null);
end
^

/* Alter Procedure... */
/* Create(Add) Crant */
SET TERM ; ^

GRANT ALL ON BUILDS TO SYSDBA WITH GRANT OPTION;

INSERT INTO BUILDS (BUILD) VALUES (1);

