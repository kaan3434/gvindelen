CREATE OR ALTER PROCEDURE XML_EXP_OBJECT (
    ND_ROOT TYPE OF ID_ELEM NOT NULL,
    I_OBJ_ID TYPE OF ID_OBJECT NOT NULL)
RETURNS (
    O_OBJ_LABEL TYPE OF LABEL_OBJECT,
    ND_OBJECT TYPE OF ID_ELEM)
AS
declare variable V_OBJ_NAME type of NAME_OBJECT;
declare variable V_OBJ_CODE type of SIGN_OBJECT;
declare variable V_OBJTYPE type of SIGN_OBJTYPE;
declare variable V_KEI type of CODE_KEI;
declare variable V_IS_NEW type of VALUE_BOOLEAN;
begin
  select o.obj_label, o.obj_name, o.obj_code, o.OBJTYPE, o.kei
    from objects o
    where obj_id = :i_obj_id
    into :o_obj_label, :v_obj_name, :v_obj_code, :v_OBJTYPE, :v_kei;

  execute procedure xml_create_elem
    :nd_root, 'ObjectList/Object["'||trim(:o_obj_label)||'"]', :o_obj_label
    returning_values :nd_object, :v_is_new;
  if (:v_is_new = 1) then
  begin
    -- сохраняем  объект
    execute procedure xml_exp_objecttype(:nd_root, :v_OBJTYPE);
    execute procedure xml_create_node(:nd_object, 'ObjectType', :v_OBJTYPE);
    execute procedure xml_exp_kei(:nd_root, :v_kei);
    execute procedure xml_create_node(:nd_object, 'Kei', :v_kei);
    execute procedure xml_create_node(:nd_object, 'Name', :v_obj_name);
    execute procedure xml_create_node(:nd_object, 'Code', :v_obj_code);
    execute procedure xml_exp_detectobjectcode(:nd_root, :o_obj_label, :v_OBJTYPE);
    execute procedure xml_exp_detectdetailattr(:nd_root, :v_OBJTYPE);
  end
  suspend;
end