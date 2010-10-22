CREATE OR ALTER PROCEDURE XML_EXP_OPERS (
    ND_ROOT TYPE OF ID_ELEM NOT NULL,
    ND_ITEM TYPE OF ID_ELEM NOT NULL,
    I_DOCOPER_ID TYPE OF ID_OPER NOT NULL)
AS
declare variable V_DOCSET_NAME type of NAME_OBJECT;
declare variable ND_OPER type of ID_ELEM;
declare variable V_IS_NEW type of VALUE_BOOLEAN;
declare variable V_OPER_ID type of ID_OPER;
declare variable V_DOCSET_ID type of ID_DOCSET;
begin
  for select op.oper_id, op.docset_id
    from opers op
    where op.docoper_id = :i_docoper_id
    into :v_oper_id, :v_docset_id do
  begin
    execute procedure xml_exp_docset(:nd_root, :v_docset_id)
      returning_values :v_docset_name;
    execute procedure xml_create_elem
      :nd_item, 'OperList/Oper[]', :v_docset_name
      returning_values :nd_oper, :v_is_new;
    execute procedure xml_exp_operorgunits(:nd_root, :nd_oper, :v_oper_id);
    execute procedure xml_exp_operprofs(:nd_root, :nd_oper, :v_oper_id);
    execute procedure xml_exp_operdocs(:nd_root, :nd_oper, :v_oper_id);
    execute procedure xml_exp_operdets(:nd_root, :nd_oper, :v_oper_id);
    execute procedure xml_exp_opermats(:nd_root, :nd_oper, :v_oper_id);
    execute procedure xml_exp_operequips(:nd_root, :nd_oper, :v_oper_id);
    execute procedure xml_exp_operinstrs(:nd_root, :nd_oper, :v_oper_id);
    execute procedure xml_exp_operhalfs(:nd_root, :nd_oper, :v_oper_id);
    execute procedure xml_exp_opernotes(:nd_oper, :v_oper_id);
  end
end