CREATE OR ALTER PROCEDURE XML_EXP_KEIGROUPS (
    ND_ROOT TYPE OF ID_ELEM NOT NULL,
    I_GROUPKEI_CODE TYPE OF CODE_GRPKEI NOT NULL)
AS
declare variable V_GROUPKEI_NAME type of NAME_ATTR;
declare variable V_IS_NEW type of VALUE_BOOLEAN;
begin
  select kg.groupkei_name
    from keigroup_ref kg
    where kg.groupkei_code = :i_groupkei_code
    into :v_groupkei_name;

  execute procedure xml_create_elem
    :nd_root, 'KeiGroupList/KeiGroup["'||trim(:i_groupkei_code)||'"]/Name', :v_groupkei_name
    returning_values :nd_root,  :v_is_new;
end