CREATE OR ALTER PROCEDURE BAND_02_GEN (
    I_BLOCK_ID TYPE OF ID_BLOCK NOT NULL,
    I_BAND_SIGN TYPE OF SIGN_BAND NOT NULL)
AS
declare variable V_BAND_ID type of ID_BAND;
declare variable V_LINE_ID type of ID_LINE;
declare variable V_EQUIP_LABELNAME_HEAD type of NAME_OBJECT;
declare variable V_EN type of VALUE_INTEGER;
declare variable V_OTHER_KEI type of CODE_KEI;
declare variable V_OPEREQUIP_ID type of ID_OPEROBJ;
declare variable V_EQUIP_LABELNAME type of NAME_OBJECT;
declare variable V_OPERPROF_ID type of ID_OPEROBJ;
declare variable V_PROF_CODE type of CODE_PROF;
declare variable V_SM type of VALUE_INTEGER;
declare variable V_R type of VALUE_INTEGER;
declare variable V_UT type of VALUE_INTEGER;
declare variable V_KR type of VALUE_INTEGER;
declare variable V_KOID type of VALUE_INTEGER;
declare variable V_OP type of VALUE_INTEGER;
declare variable V_KSHT type of VALUE_DECIMAL;
declare variable V_TPZ type of VALUE_DECIMAL;
declare variable V_TSHT type of VALUE_DECIMAL;
begin
  execute procedure param_get('OperEquip_Id') returning_values :v_operequip_id;
  if (:v_operequip_id is not null) then
  begin
    select o.obj_label||unescapestring('&nbsp;')||o.obj_name
      from operequips oo
        inner join objects o on (o.obj_id = oo.equip_id)
      where oo.operequip_id = :v_operequip_id
      into :v_equip_labelname;
  end

  execute procedure param_get('OperProf_Id') returning_values :v_operprof_id;
  begin
    select p.prof_code
      from operprofs oo
        inner join professions p on (p.prof_id = oo.prof_id)
      where oo.operprof_id = :v_operprof_id
      into :v_prof_code;

      select o_attr_value, o_kei
        from operprof_attr_get(:v_operprof_id, 'MECH_DEGREE')
        into :v_sm, :v_other_kei;
      select o_attr_value, o_kei
        from operprof_attr_get(:v_operprof_id, 'CATEGORY')
        into :v_r, :v_other_kei;
      select o_attr_value, o_kei
        from operprof_attr_get(:v_operprof_id, 'WORK_CONDITION')
        into :v_ut, :v_other_kei;
    
      select o_attr_value, o_kei
        from operprof_attr_get(:v_operprof_id, 'WORKER_COUNT')
        into :v_kr, :v_other_kei;
      select o_attr_value, o_kei
        from operprof_attr_get(:v_operprof_id, 'KOID')
        into :v_koid, :v_other_kei;
      select o_attr_value, o_kei
        from operprof_attr_get(:v_operprof_id, 'UNITS_RATE')
        into :v_en, :v_other_kei;
      select o_attr_value, o_kei
        from operprof_attr_get(:v_operprof_id, 'PARTION_SIZE')
        into :v_op, :v_other_kei;
    
      select o_attr_value, o_kei
        from operprof_attr_get_decimal(:v_operprof_id, 'KSHT')
        into :v_ksht, :v_other_kei;
      select o_attr_value, o_kei
        from operprof_attr_get_decimal(:v_operprof_id, 'TPZ')
        into :v_tpz, :v_other_kei;
      select o_attr_value, o_kei
        from operprof_attr_get_decimal(:v_operprof_id, 'TSHT')
        into :v_tsht, :v_other_kei;
  end

  if ((:v_equip_labelname is null) and (:v_prof_code is null)) then
    exit;

  select o_band_id
    from band_new(:i_block_id, :i_band_sign)
    into :v_band_id;

  while (1=1) do
  begin
    select o_head, o_tile
      from splitstring_cell (:v_equip_labelname, ' ', '02_2')
      into :v_equip_labelname_head, :v_equip_labelname;

    select o_line_id
      from line_new (:i_block_id, :v_band_id)
      into :v_line_id;

    insert into band_02(line_id, equip_labelname, sm, prof_code, r, ut, kr, koid, en, op, ksht, tpz, tsht)
      values(:v_line_id, :v_equip_labelname_head, :v_sm, :v_prof_code, :v_r, :v_ut, :v_kr, :v_koid, :v_en, :v_op, :v_ksht, :v_tpz, :v_tsht);

    if (:v_equip_labelname is null) then
      break;
  end
end