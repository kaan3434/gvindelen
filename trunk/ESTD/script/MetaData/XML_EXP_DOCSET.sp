CREATE OR ALTER PROCEDURE XML_EXP_DOCSET (
    ND_ROOT TYPE OF ID_ELEM NOT NULL,
    I_DOCSET_ID TYPE OF ID_DOCSET NOT NULL)
RETURNS (
    O_DOCSET_NAME TYPE OF NAME_OBJECT)
AS
declare variable V_IS_ALL type of VALUE_BOOLEAN;
declare variable ND_DOCSET type of ID_ELEM;
declare variable V_IS_NEW type of VALUE_BOOLEAN;
declare variable V_OBJ_LABEL type of LABEL_OBJECT;
declare variable V_OBJ_ID type of ID_OBJECT;
declare variable ND_DETAILS type of ID_ELEM;
declare variable ND_OBJECT type of ID_ELEM;
begin
  select ds.docset_name, ds.is_all
    from docsets ds
    where ds.docset_id = :i_docset_id
    into :o_docset_name, :v_is_all;
  execute procedure xml_create_elem
    :nd_root, 'DocSetList/DocSet["'||trim(:o_docset_name)||'"]', :o_docset_name
    returning_values :nd_docset, :v_is_new;
  if (:v_is_new = 1) then
  begin
    execute procedure xml_create_elem
      :nd_docset, 'DetailList', null
      returning_values :nd_details, :v_is_new;
    for select dis.detail_id
      from detinset dis
      where dis.docset_id = :i_docset_id
      into :v_obj_id do
    begin
      execute procedure xml_exp_object(:nd_root, :v_obj_id) 
        returning_values :v_obj_label, :nd_object;
      execute procedure xml_create_node(:nd_details, 'Detail', :v_obj_label);
    end
  end
  suspend;
end