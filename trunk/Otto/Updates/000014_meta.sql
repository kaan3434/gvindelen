/* Server version: WI-V6.3.0.26074 Firebird 2.5 
   SQLDialect: 3. ODS: 11.2. Forced writes: On. Sweep inteval: 20000.
   Page size: 4096. Cache pages: 2048 (8192 Kb). Read-only: False. */
SET CLIENTLIB 'fbclient.dll';
SET NAMES CYRL;

SET SQL DIALECT 3;

SET AUTODDL ON;

/* Create Domains... */
CREATE DOMAIN CODE_BAR AS VARCHAR(13) CHARACTER SET ASCII;

/* Alter Procedure (Before Drop)... */
SET TERM ^ ;

ALTER PROCEDURE MESSAGE_2_GET_FILENAME(I_PARTNER_NUMBER /* TYPE OF VALUE_INTEGER */ INTEGER,
I_PORTION_NO /* TYPE OF VALUE_INTEGER */ INTEGER)
 RETURNS(O_FILENAME /* TYPE OF NAME_FILE */ VARCHAR(100))
 AS
 BEGIN SUSPEND; END
^


/* Drop Procedure... */
SET TERM ; ^

DROP PROCEDURE MESSAGE_2_GET_FILENAME;


ALTER TABLE ORDERS ADD BAR_CODE CODE_BAR COLLATE ASCII;

/* Alter Procedure... */
/* Alter (MESSAGE_CREATE) */
SET TERM ^ ;

ALTER PROCEDURE MESSAGE_CREATE(I_FILE_NAME TYPE OF NAME_FILE,
I_FILE_SIZE TYPE OF SIZE_FILE,
I_FILE_DTM TYPE OF DTM_FILE)
 RETURNS(O_MESSAGE_ID TYPE OF ID_MESSAGE)
 AS
declare variable V_ACTION_ID type of ID_ACTION;
declare variable V_PARAM_ID type of ID_PARAM;
declare variable V_TEMPLATE_ID type of ID_TEMPLATE;
declare variable V_FILE_NAME type of NAME_FILE;
declare variable V_OBJECT_SIGN type of SIGN_OBJECT = 'MESSAGE';
begin
  if (not exists(select m.message_id
                   from messages m
                   where m.file_name = :i_file_name)) then
  begin
    select o_param_id from param_create(:v_object_sign) into :v_param_id;
    execute procedure param_set(:v_param_id, 'FILE_NAME', :i_file_name);
    execute procedure param_set(:v_param_id, 'FILE_SIZE', :i_file_size);
    execute procedure param_set(:v_param_id, 'FILE_DTM', :i_file_dtm);

    v_file_name = EscapeStringEx(:i_file_name, '-');

    select t.template_id
      from templates t
      where :v_file_name similar to t.filename_mask
      into :v_template_id;

    execute procedure param_set(:v_param_id, 'TEMPLATE_ID', :v_template_id);

    select o_action_id from action_run(:v_object_sign, 'MESSAGE_CREATE', :v_param_id, null, null)
      into :v_action_id;
    select a.object_id from actions a where a.action_id = :v_action_id
      into :o_message_id;
  end
  suspend;
end
^

/* Alter (NOTIFY_CREATE) */
ALTER PROCEDURE NOTIFY_CREATE(I_MESSAGE_ID TYPE OF ID_MESSAGE NOT NULL,
I_NOTIFY_TEXT TYPE OF VALUE_ATTR NOT NULL,
I_PARAMS TYPE OF VALUE_BLOB,
I_STATE TYPE OF VALUE_CHAR)
 RETURNS(O_NOTIFY_ID TYPE OF ID_NOTIFY)
 AS
declare variable V_PARAM_ID type of ID_PARAM;
begin
  if (nullif(i_params, '') is not null) then
  begin
    select o_param_id from param_create('NOTIFY', :i_message_id) into :v_param_id;
    execute procedure param_unparse(:v_param_id, :i_params);
  end

  insert into notifies(message_id, param_id, notify_text, notify_class)
    values(:i_message_id, :v_param_id, :i_notify_text, upper(:i_state))
    returning notify_id
    into :o_notify_id;
  suspend;
end
^

SET TERM ; ^

