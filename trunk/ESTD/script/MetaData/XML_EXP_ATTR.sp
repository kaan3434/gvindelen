CREATE OR ALTER PROCEDURE XML_EXP_ATTR (
    ND_ROOT TYPE OF ID_ELEM NOT NULL,
    ND_SUBJ TYPE OF ID_ELEM NOT NULL,
    I_ATTR_CODE TYPE OF NAME_ATTR NOT NULL,
    I_ATTR_KEI TYPE OF CODE_KEI NOT NULL,
    I_ATTR_VALUE TYPE OF VALUE_ATTR)
AS
declare variable ND_ATTR type of ID_ELEM;
declare variable V_IS_NEW type of VALUE_BOOLEAN;
begin
  execute procedure xml_exp_kei(:nd_root, :i_Attr_kei);
  execute procedure xml_create_elem
    :nd_subj, 'AttributeList/Attribute[]', null
    returning_values :nd_attr, :v_is_new;
  execute procedure xml_create_node(:nd_attr, 'Code', :i_attr_code);
  execute procedure xml_create_node(:nd_attr, 'Value', :i_attr_value);
  execute procedure xml_create_node(:nd_attr, 'Kei', :i_Attr_kei);
end