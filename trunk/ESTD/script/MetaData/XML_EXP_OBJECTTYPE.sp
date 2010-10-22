CREATE OR ALTER PROCEDURE XML_EXP_OBJECTTYPE (
    ND_ROOT TYPE OF ID_ELEM NOT NULL,
    I_OBJTYPE TYPE OF SIGN_OBJTYPE NOT NULL)
AS
declare variable ND type of ID_ELEM;
declare variable V_OBJTYPE_NAME type of NAME_OBJTYPE;
declare variable V_IS_NEW type of VALUE_BOOLEAN;
begin
  select objtype_name
    from OBJTYPE_REF
    where OBJTYPE = :i_OBJTYPE
    into :v_objtype_name;

  execute procedure xml_create_elem
    :nd_root, 'ObjectTypeList/ObjectType["'||trim(:i_OBJTYPE)||'"]/Name', :v_objtype_name
    returning_values :nd, :v_is_new;
end