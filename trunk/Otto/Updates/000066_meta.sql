/* Server version: WI-V6.3.1.26351 Firebird 2.5 
   SQLDialect: 3. ODS: 11.2. Forced writes: On. Sweep inteval: 20000.
   Page size: 4096. Cache pages: 2048 (8192 Kb). Read-only: False. */
SET CLIENTLIB 'fbclient.dll';
SET NAMES CYRL;

SET SQL DIALECT 3;

SET AUTODDL ON;

/* Alter Procedure... */
/* Alter (BARCODE_GEN) */
SET TERM ^ ;

ALTER PROCEDURE BARCODE_GEN(I_ORDER_ID TYPE OF ID_ORDER NOT NULL,
I_PACKLIST_NO TYPE OF VALUE_INTEGER)
 RETURNS(O_BARCODE TYPE OF SIGN_OBJECT)
 AS
declare variable V_PREFIX type of VALUE_SHORT;
declare variable V_ORDER_CODE type of CODE_ORDER;
declare variable V_CN integer;
begin
  /* Procedure Text */
  select substring(pa2.attr_value from 8 for 1)||
         lpad(coalesce(pl.packlist_code, '0'), 2, '0')||
         substring(o.order_code from 2), pa1.attr_value
    from orders o
      left join packlists pl on (pl.packlist_no = coalesce(o.packlist_no, :i_packlist_no))
      inner join v_product_attrs pa1 on (pa1.object_id = o.product_id
                                     and pa1.attr_sign = 'BARCODE_SIGN')
      inner join v_product_attrs pa2 on (pa2.object_id = o.product_id
                                     and pa2.attr_sign = 'PARTNER_NUMBER')
    where o.order_id = :i_order_id
    into :o_barcode, :v_prefix;

  v_cn = 11 - mod(8*cast(substring(o_barcode from 1 for 1) as smallint) +
                  6*cast(substring(o_barcode from 2 for 1) as smallint) +
                  4*cast(substring(o_barcode from 3 for 1) as smallint) +
                  2*cast(substring(o_barcode from 4 for 1) as smallint) +
                  3*cast(substring(o_barcode from 5 for 1) as smallint) +
                  5*cast(substring(o_barcode from 6 for 1) as smallint) +
                  9*cast(substring(o_barcode from 7 for 1) as smallint) +
                  7*cast(substring(o_barcode from 8 for 1) as smallint), 11);
  if (v_cn = 10) then
    v_cn = 0;
  else if (v_cn = 11) then
    v_cn = 5;
  else
    v_cn = substring(v_cn from 1 for 1);

  o_barcode = v_prefix||o_barcode||v_cn||'LT';
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
                   where m.file_name = :i_file_name
                     and extract(year from m.message_dtm) = extract(year from current_date))) then
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

      select o_action_id from action_run(:v_object_sign, 'MESSAGE_CREATE', :v_param_id, null)
        into :v_action_id;
      select a.object_id from actions a where a.action_id = :v_action_id
        into :o_message_id;
    end
  end
  suspend;
end
^

SET TERM ; ^

