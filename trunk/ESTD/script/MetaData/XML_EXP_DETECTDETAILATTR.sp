CREATE OR ALTER PROCEDURE XML_EXP_DETECTDETAILATTR (
    ND_ROOT TYPE OF ID_ELEM NOT NULL,
    I_OBJTYPE TYPE OF SIGN_OBJTYPE NOT NULL)
AS
declare variable ND_DETECTDETATTR type of ID_ELEM;
declare variable V_LABEL_MASK type of MASK_VALUE;
declare variable V_VALUE_MASK type of MASK_VALUE;
declare variable V_ATTR_CODE type of SIGN_ATTR;
declare variable V_IS_NEW type of VALUE_BOOLEAN;
begin
  for select label_mask, attr_code, value_mask
    from detect_detailattr
    where OBJTYPE = :i_OBJTYPE
    into :v_label_mask, :v_attr_code, :v_value_mask do
  begin
    execute procedure xml_create_elem
      :nd_root, 'DetectDetailAttrList/DetectDetailAttr["'||trim(:v_label_mask)||'"]', :v_label_mask
      returning_values :nd_detectdetattr, :v_is_new;
    if (v_is_new = 1) then
    begin
      execute procedure xml_create_node(:nd_detectdetattr, 'ObjectType', :i_OBJTYPE);
      execute procedure xml_create_node(:nd_detectdetattr, 'AttrCode', :v_attr_code);
      execute procedure xml_create_node(:nd_detectdetattr, 'ValueMask', :v_value_mask);
    end
  end
end