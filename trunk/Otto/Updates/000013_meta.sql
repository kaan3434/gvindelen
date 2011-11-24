/* Server version: WI-V6.3.1.26351 Firebird 2.5 
SET CLIENTLIB 'fbclient.dll';
   SQLDialect: 3. ODS: 11.2. Forced writes: On. Sweep inteval: 20000.
   Page size: 4096. Cache pages: 2048 (8192 Kb). Read-only: False. */
SET NAMES CYRL;

SET SQL DIALECT 3;

SET AUTODDL ON;

ALTER TABLE ORDERITEMS ADD ORDERITEM_INDEX NUMBER_PAGE;

/* Alter Procedure... */
/* Alter (MESSAGE_2_GET_FILENAME) */
SET TERM ^ ;

ALTER PROCEDURE MESSAGE_2_GET_FILENAME(I_PARTNER_NUMBER TYPE OF VALUE_INTEGER,
I_PORTION_NO TYPE OF VALUE_INTEGER)
 RETURNS(O_FILENAME TYPE OF NAME_FILE)
 AS
declare variable V_DAY_OF_YEAR type of VALUE_INTEGER;
begin
  -- select day_of_year
  v_day_of_year = extract(yearday from current_date)+1;
  o_filename = 'A'||i_partner_number||'_'||lpad(i_portion_no, 2, '0')||'.'||v_day_of_year;
  while (exists(select * from messages m where m.file_name = :o_filename)) do
  begin
    i_portion_no = i_portion_no + 1;
    o_filename = 'A'||i_partner_number||'_'||lpad(i_portion_no, 2, '0')||'.'||v_day_of_year;
  end
  suspend;
end
^

/* Alter (MESSAGE_CREATE) */
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
    if (v_template_id is not null) then
    begin
      execute procedure param_set(:v_param_id, 'TEMPLATE_ID', :v_template_id);

      select o_action_id from action_run(:v_object_sign, 'MESSAGE_CREATE', :v_param_id, null, null)
        into :v_action_id;
      select a.object_id from actions a where a.action_id = :v_action_id
        into :o_message_id;
    end
  end
  suspend;
end
^

SET TERM ; ^

