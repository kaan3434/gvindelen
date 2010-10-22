CREATE OR ALTER PROCEDURE XML_EXP_DOC (
    ND_ROOT TYPE OF ID_ELEM,
    I_DOC_ID TYPE OF ID_OBJECT)
RETURNS (
    O_DOC_LABEL TYPE OF LABEL_OBJECT)
AS
declare variable ND_OBJECT type of ID_ELEM;
declare variable V_REFDOC_ID type of ID_OBJECT;
declare variable V_REFDOC_LABEL type of LABEL_OBJECT;
begin
  execute procedure xml_exp_object(:nd_root, :i_doc_id)
    returning_values :o_doc_label, :nd_object;
  select refdoc_id
    from documents
    where document_id = :i_doc_id
    into :v_refdoc_id;
  if (:v_refdoc_id is not null) then
  begin
    execute procedure xml_exp_doc(:nd_root,  :v_refdoc_id)
      returning_values :v_refdoc_label;
    execute procedure xml_create_node(:nd_object, 'RefDoc', :v_refdoc_label);
  end
  suspend;
end