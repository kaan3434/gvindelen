CREATE OR ALTER PROCEDURE XML_EXP_ORGUNIT (
    ND_ROOT TYPE OF ID_ELEM NOT NULL,
    I_ORGUNIT_ID TYPE OF ID_ORGUNIT NOT NULL)
RETURNS (
    O_ORGUNIT_SIGN TYPE OF SIGN_ORGUNIT)
AS
declare variable V_ORGUNIT_CODE type of SIGN_ORGUNIT;
declare variable V_ORGUNITTYPE_CODE type of CODE_ORGUNITTYPE;
declare variable V_ORGUNIT_NAME type of NAME_OBJECT;
declare variable ND_ORGUNIT type of ID_ELEM;
declare variable V_IS_NEW type of VALUE_BOOLEAN;
declare variable V_PARENT_ID type of ID_ORGUNIT;
declare variable V_PARENT_SIGN type of SIGN_ORGUNIT;
begin
  select first 1 ou.orgunit_code, ou.orgunit_type_code, ou.orgunit_name, ou.orgunit_sign, ou.parent_id
    from orgunits ou
    where ou.orgunit_id = :i_orgunit_id
    into :v_orgunit_code, :v_orgunittype_code, :v_orgunit_name, :o_orgunit_sign, :v_parent_id;
  if (:v_parent_id is not null) then
    execute procedure xml_exp_orgunit(:nd_root,  :v_parent_id) returning_values :v_parent_sign;
  execute procedure xml_create_elem
    :nd_root, 'OrgUnitList/OrgUnit["'||trim(:o_orgunit_sign)||'"]', :o_orgunit_sign
    returning_values :nd_orgunit, :v_is_new;
  if (:v_is_new = 1) then
  begin
    execute procedure xml_create_node(:nd_orgunit, 'Code', :v_orgunit_code);
    execute procedure xml_create_node(:nd_orgunit, 'Name', :v_orgunit_name);
    execute procedure xml_create_node(:nd_orgunit, 'Type', :v_orgunittype_code);
    execute procedure xml_create_node(:nd_orgunit, 'Parent', :v_parent_sign);
  end
  suspend;
end