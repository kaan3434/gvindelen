CREATE OR ALTER PROCEDURE XML_EXP_OPERORGUNITS (
    ND_ROOT TYPE OF ID_ELEM,
    ND_OPER TYPE OF ID_ELEM,
    I_OPER_ID TYPE OF ID_OPER)
AS
declare variable V_IS_NEW type of VALUE_BOOLEAN;
declare variable V_ORGUNIT_ID type of ID_ORGUNIT;
declare variable V_ORGUNIT_SIGN type of SIGN_ORGUNIT;
declare variable ND_OPEROBJ type of ID_ELEM;
begin
  for select orgunit_id
   from operorgunits
   where oper_id = :i_oper_id
   into :v_orgunit_id do
  begin
    execute procedure xml_exp_orgunit(:nd_root, :v_orgunit_id) returning_values :v_orgunit_sign;
    execute procedure xml_create_elem
      :nd_oper, 'OrgUnitList/OrgUnit[]', :v_orgunit_sign
      returning_values :nd_operobj, :v_is_new;
  end
end