CREATE OR ALTER PROCEDURE XML_EXP_DETECTOBJECTCODE (
    ND_ROOT TYPE OF ID_ELEM NOT NULL,
    I_OBJ_LABEL TYPE OF LABEL_OBJECT NOT NULL,
    I_OBJTYPE TYPE OF SIGN_OBJTYPE NOT NULL)
AS
declare variable ND_DETECTOBJECT type of ID_ELEM;
declare variable V_OBJTYPE type of SIGN_OBJTYPE;
declare variable V_LABEL_MASK type of MASK_VALUE;
declare variable V_CODE_MASK type of MASK_VALUE;
declare variable V_IS_NEW type of VALUE_BOOLEAN;
begin
  select first 1 doc.OBJTYPE, doc.label_mask, doc.code_mask
    from detect_objectcode doc
    where :i_obj_label like doc.label_mask
      and OBJTYPE = :i_OBJTYPE
    order by doc.mask_level desc
    into :v_OBJTYPE, :v_label_mask, :v_code_mask;
  if (row_count = 0) then
    exception undefined_detectobjectcode;

  execute procedure xml_create_elem
    :nd_root,  'DetectObjectCodeList/DetectObjectCode["'||trim(:v_label_mask)||'"]', :v_label_mask
    returning_values :nd_detectobject, :v_is_new;
  if (:v_is_new = 1) then
  begin
    execute procedure xml_create_node(:nd_detectobject, 'ObjectTypeCode', :v_OBJTYPE);
    execute procedure xml_create_node(:nd_detectobject, 'CodeMask', :v_code_mask);
  end
end