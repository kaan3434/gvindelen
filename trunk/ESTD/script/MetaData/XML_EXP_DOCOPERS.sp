CREATE OR ALTER PROCEDURE XML_EXP_DOCOPERS (
    ND_ROOT TYPE OF ID_ELEM NOT NULL,
    ND_ITEM TYPE OF ID_ELEM NOT NULL,
    I_DOCUMENT_ID TYPE OF ID_OBJECT NOT NULL)
AS
declare variable V_IS_NEW type of VALUE_BOOLEAN;
declare variable V_OPER_NUM type of NUM_POSITION;
declare variable ND_DOCOPER type of ID_ELEM;
declare variable V_DOCOPER_ID type of ID_OPER;
declare variable V_OPER_NAME type of VALUE_ATTR;
begin
  for select op.docoper_id, op.oper_num, op.oper_name
    from docopers op
    where op.document_id = :i_document_id
    order by op.oper_num
    into :v_docoper_id, :v_oper_num, :v_oper_name do
  begin
    execute procedure xml_create_elem
      :nd_item, 'DocOperList/DocOper[]', :v_oper_num
      returning_values :nd_docoper, :v_is_new;
    execute procedure xml_create_node(:nd_docoper, 'Name', :v_oper_name);
    execute procedure xml_exp_opers(:nd_root, :nd_docoper, :v_docoper_id);
  end
end