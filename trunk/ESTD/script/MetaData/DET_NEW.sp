CREATE OR ALTER PROCEDURE DET_NEW (
    I_OBJ_LABEL TYPE OF LABEL_OBJECT,
    I_OBJ_NAME TYPE OF NAME_OBJECT)
RETURNS (
    O_OBJ_ID TYPE OF ID_OBJECT)
AS
declare variable V_OBJTYPE type of SIGN_OBJTYPE;
declare variable V_OBJ_CODE type of SIGN_OBJECT;
declare variable V_ATTR_CODE type of SIGN_ATTR;
declare variable V_ATTR_VALUE type of VALUE_ATTR;
BEGIN
  execute procedure objtype_detect(:i_obj_label)
    returning_values :v_OBJTYPE, :v_obj_code;

  if (:v_OBJTYPE is null) then
    exception unknown_objecttype(:i_obj_label);

  if (substring(:v_OBJTYPE from 1 for 1) <> '3') then
    exception object_is_not_detail(:i_obj_label);

  execute procedure obj_new(:i_obj_label, :v_OBJTYPE, :v_obj_code, :i_obj_name, 796)
    returning_values :o_obj_id;

  insert into details(detail_id)
    values(:o_obj_id);

  -- fill detected attr values
  for select o_attr_code, o_attr_value
        from det_attr_detect(:v_OBJTYPE, :i_obj_label)
        into :v_attr_code, :v_attr_value do
  begin
    execute procedure det_attr_set(:o_obj_id, :v_attr_code, :v_attr_value);
  end

  SUSPEND;
END