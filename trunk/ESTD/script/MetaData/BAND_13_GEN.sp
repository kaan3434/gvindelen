CREATE OR ALTER PROCEDURE BAND_13_GEN (
    I_BLOCK_ID TYPE OF ID_BLOCK,
    I_BAND_SIGN TYPE OF SIGN_BAND)
AS
declare variable V_BAND_ID type of ID_BAND;
declare variable V_OPEROBJ_ID type of ID_OPEROBJ;
declare variable V_LINE_ID type of ID_LINE;
declare variable V_OBJ_NAME_HEAD type of NAME_OBJECT;
declare variable V_OBJ_LABEL type of LABEL_OBJECT;
declare variable V_OBJ_NAME type of NAME_OBJECT collate UTF8;
declare variable V_KEI type of CODE_KEI;
declare variable V_EN type of VALUE_INTEGER;
declare variable V_NORMRASH type of VALUE_DECIMAL;
declare variable V_OPP type of VALUE_ATTR;
declare variable V_OTHER_KEI type of CODE_KEI;
declare variable V_OPER_ID type of ID_OPER;
begin
  execute procedure param_get('OperObj_Id') returning_values :v_operobj_id;

  select o.obj_label, o.obj_name||' '||unescapestring(replace(o.obj_gost,' ', '&nbsp;')), o.kei
     from opermats oo
          inner join objects o on (o.obj_id = oo.material_id)
        where oo.opermat_id = :v_operobj_id
        into :v_obj_label, :v_obj_name, :v_kei;

  select o_band_id
    from band_new(:i_block_id, :i_band_sign)
    into :v_band_id;

  select o_attr_value, o_kei
    from opermat_attr_get(:v_operobj_id, 'UNITS_RATE')
    into :v_en, :v_other_kei;
  select o_attr_value, o_kei
    from opermat_attr_get_decimal(:v_operobj_id, 'CONSUMPTION_RATE')
    into :v_normrash, :v_other_kei;
  select o_attr_value, o_kei
    from opermat_attr_get(:v_operobj_id, 'STORAGE')
    into :v_opp, :v_other_kei;

  while (1=1) do
  begin
    select o_head, o_tile
      from splitstring_cell (:v_obj_name, ' ', '13_2')
      into :v_obj_name_head, :v_obj_name;

    select o_line_id
      from line_new (:i_block_id, :v_band_id)
      into :v_line_id;

    insert into band_13(line_id, mat_name, mat_label, opp, kei, en, normrash)
      values(:v_line_id, :v_obj_name_head, :v_obj_label, :v_opp, :v_kei, :v_en, :v_normrash);

    if (:v_obj_name is null) then
      break;
  end
end