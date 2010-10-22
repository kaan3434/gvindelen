CREATE OR ALTER PROCEDURE DOC_NEW (
    I_OBJ_LABEL TYPE OF LABEL_OBJECT,
    I_OBJ_NAME TYPE OF NAME_OBJECT,
    I_REFOBJ_ID TYPE OF ID_OBJECT = null)
RETURNS (
    O_OBJ_ID TYPE OF ID_OBJECT)
AS
declare variable V_OBJTYPE type of SIGN_OBJTYPE;
declare variable V_OBJ_CODE type of SIGN_OBJECT;
declare variable V_DOCSET_ID type of ID_DOCSET;
BEGIN
  execute procedure objtype_detect(:i_obj_label)
    returning_values :v_OBJTYPE, :v_obj_code;

  if (:v_OBJTYPE is null) then
    exception unknown_objecttype(:i_obj_label);

  if (substring(v_OBJTYPE from 1 for 1) not in ('1', '9', '2')) then
    exception object_is_not_document;

  execute procedure obj_new(:i_obj_label, :v_OBJTYPE, :v_obj_code, :i_obj_name, 796)
    returning_values :o_obj_id;

  insert into documents(document_id, refdoc_id)
    values(:o_obj_id, :i_refobj_id);

  SUSPEND;
END