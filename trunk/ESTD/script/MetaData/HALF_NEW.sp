CREATE OR ALTER PROCEDURE HALF_NEW (
    I_OBJ_LABEL TYPE OF LABEL_OBJECT,
    I_OBJ_NAME TYPE OF NAME_OBJECT,
    I_DOCOPER_ID TYPE OF ID_OPER)
RETURNS (
    O_OBJ_ID TYPE OF ID_OBJECT)
AS
declare variable V_OBJTYPE type of SIGN_OBJTYPE;
declare variable V_OBJ_CODE type of SIGN_OBJECT;
BEGIN
  execute procedure objtype_detect(:i_obj_label)
    returning_values :v_OBJTYPE, :v_obj_code;

  if (:v_OBJTYPE is null) then
    exception unknown_objecttype(:i_obj_label);

  if (substring(:v_OBJTYPE from 1 for 1) <> '8') then
    exception object_is_not_detail(:i_obj_label);

  execute procedure obj_new(:i_obj_label, :v_OBJTYPE, :v_obj_code, :i_obj_name, 796)
    returning_values :o_obj_id;

  insert into halfs(half_id, docoper_id)
    values(:o_obj_id, :i_docoper_id);

  SUSPEND;
END