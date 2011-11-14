/* Server version: WI-V6.3.0.26074 Firebird 2.5 
   SQLDialect: 3. ODS: 11.2. Forced writes: On. Sweep inteval: 20000.
   Page size: 4096. Cache pages: 2048 (8192 Kb). Read-only: False. */
SET NAMES CYRL;

SET SQL DIALECT 3;


SET AUTODDL ON;

/* Alter Procedure... */
/* Alter (NOTIFY_CREATE) */
SET TERM ^ ;

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

INSERT INTO BUILDS (BUILD) VALUES (3);
