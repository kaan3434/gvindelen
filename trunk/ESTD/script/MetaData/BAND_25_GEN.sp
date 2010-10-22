CREATE OR ALTER PROCEDURE BAND_25_GEN (
    I_BLOCK_ID TYPE OF ID_BLOCK,
    I_BAND_SIGN TYPE OF SIGN_BAND)
AS
declare variable V_BAND_ID type of ID_BAND;
declare variable V_LINE_ID type of ID_LINE;
declare variable V_OPER_ID type of ID_OPER;
declare variable V_OPER_NAME type of NAME_OBJECT;
declare variable V_OPER_NAME_HEAD type of NAME_OBJECT;
declare variable V_ORGUNIT_ID type of ID_ORGUNIT;
declare variable V_SHOP type of CODE_ORGUNIT;
declare variable V_AREA type of CODE_ORGUNIT;
declare variable V_WORKPLACE type of CODE_ORGUNIT;
declare variable V_OPER_NUM type of NUM_POSITION;
begin
  execute procedure param_get('Oper_Id') returning_values :v_oper_id;
  execute procedure band_new(:i_block_id, :i_band_sign) returning_values :v_band_id;

  select dop.oper_name, dop.oper_num, ou.orgunit_id
    from opers op
      inner join docopers dop on (dop.docoper_id = op.docoper_id)
      inner join operorgunits ou on (ou.oper_id = op.oper_id)
    where op.oper_id = :v_oper_id
    into :v_oper_name, :v_oper_num, :v_orgunit_id;

  execute procedure orgunit_decode(:v_orgunit_id)
    returning_values :v_shop, :v_area, :v_workplace;
  while (1=1) do
  begin
    execute procedure splitstring_cell(:v_oper_name, ' ', '25_6')
      returning_values :v_oper_name_head, :v_oper_name;

    execute procedure line_new(:i_block_id, :v_band_id)
      returning_values :v_line_id;

    insert into band_25(line_id, oper_num, shop_code, area_code, workplace_code, oper_name)
      values(:v_line_id, :v_oper_num, :v_shop, :v_area, :v_workplace, :v_oper_name_head);

    if (:v_oper_name is null) then
      exit;
  end
end