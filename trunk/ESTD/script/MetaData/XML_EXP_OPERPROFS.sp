CREATE OR ALTER PROCEDURE XML_EXP_OPERPROFS (
    ND_ROOT TYPE OF ID_ELEM,
    ND_OPER TYPE OF ID_ELEM,
    I_OPER_ID TYPE OF ID_OPER)
AS
declare variable V_OPEROBJ_ID type of ID_OPEROBJ;
declare variable V_OBJ_ID type of ID_OBJECT;
declare variable ND_OPEROBJ type of ID_ELEM;
declare variable V_IS_NEW type of VALUE_BOOLEAN;
declare variable V_ATTR_CODE type of NAME_ATTR;
declare variable V_ATTR_KEI type of CODE_KEI;
declare variable V_ATTR_VALUE type of VALUE_ATTR;
declare variable V_PROF_CODE type of CODE_PROF;
begin
  for select operprof_id, prof_id
   from operprofs
   where oper_id = :i_oper_id
   into :v_operobj_id, :v_obj_id do
  begin
    execute procedure xml_exp_profession(:nd_root, :v_obj_id) returning_values :v_prof_code;
    execute procedure xml_create_elem
      :nd_oper, 'ProfessionList/Profession[]', :v_prof_code
      returning_values :nd_operobj, :v_is_new;
    for select oda.attr_code, oda.kei, oda.attr_value
      from operprofattrs oda
      where oda.operprof_id = :v_operobj_id
      into :v_attr_code, :v_attr_kei, :v_attr_value do
      execute procedure xml_exp_attr(:nd_root, :nd_operobj, :v_attr_code, :v_attr_kei, :v_attr_value);
  end
end