CREATE OR ALTER PROCEDURE BAND_34_GEN (
    I_BLOCK_ID TYPE OF ID_BLOCK NOT NULL,
    I_BAND_SIGN TYPE OF SIGN_BAND NOT NULL)
AS
declare variable V_BAND_ID type of ID_BAND;
declare variable V_OPEROBJ_ID type of ID_OPEROBJ;
declare variable V_LINE_ID type of ID_LINE;
declare variable V_OBJ_NAME_HEAD type of NAME_OBJECT;
declare variable V_OBJ_LABEL type of LABEL_OBJECT;
declare variable V_OBJ_NAME type of NAME_OBJECT collate UTF8;
declare variable V_KEI type of CODE_KEI;
declare variable V_EN type of VALUE_INTEGER;
declare variable V_KI type of VALUE_INTEGER;
declare variable V_OPP type of VALUE_ATTR;
declare variable V_OTHER_KEI type of CODE_KEI;
declare variable V_INDEX type of NUM_POSITION;
declare variable V_OPER_NUM type of NUM_POSITION;
begin
  execute procedure param_get('OperObj_Id') returning_values :v_operobj_id;
  execute procedure param_get('Det_Index') returning_values :v_index;

  select o.obj_label, o.obj_name, o.kei, dop.oper_num
    from operhalfs oo
      inner join objects o on (o.obj_id = oo.half_id)
      inner join halfs h on (h.half_id = oo.half_id)
      inner join docopers dop on (dop.docoper_id = h.docoper_id)
    where oo.operhalf_id = :v_operobj_id
    into :v_obj_label, :v_obj_name, :v_kei, :v_oper_num;

  execute procedure band_new(:i_block_id, :i_band_sign) returning_values :v_band_id;
  v_obj_name = cast(:v_index as varchar(3))||unescapestring('.&nbsp;')||v_obj_name;

  execute procedure operhalf_attr_get(:v_operobj_id, 'UNITS_RATE')
    returning_values :v_en, :v_other_kei;
  execute procedure operhalf_attr_get(:v_operobj_id, 'COUNT')
    returning_values :v_ki, :v_other_kei;
  v_opp = unescapestring('оп.')||v_oper_num;

  while (1=1) do
  begin
    execute procedure splitstring_cell(:v_obj_name, ' ', '34_2')
      returning_values :v_obj_name_head, :v_obj_name;

    execute procedure line_new(:i_block_id, :v_band_id)
      returning_values :v_line_id;
    insert into band_34(line_id, half_name, half_label, opp, kei, en, ki)
      values(:v_line_id, :v_obj_name_head, :v_obj_label, :v_opp, :v_kei, :v_en, :v_ki);

    if (:v_obj_name is null) then
      break;
  end
end