CREATE OR ALTER PROCEDURE DOC_UOC (
    I_DOC_LABEL TYPE OF LABEL_OBJECT NOT NULL,
    I_DOC_NAME TYPE OF NAME_OBJECT NOT NULL,
    I_REFDOC_ID TYPE OF ID_OBJECT = null)
RETURNS (
    O_DOC_ID TYPE OF ID_OBJECT)
AS
declare variable V_OBJ_NAME type of NAME_OBJECT;
begin
  select obj_id, obj_name
    from objects
    where obj_label = :i_doc_label
    into :o_doc_id, :v_obj_name;
  if (row_count = 0) then
    execute procedure doc_new(:i_doc_label, :i_doc_name, :i_refdoc_id)
      returning_values :o_doc_id;
  else
  begin
    if (:v_obj_name is null) then
      update objects
        set obj_name = :i_doc_name
        where obj_id = :o_doc_id;
    if (:i_refdoc_id is not null) then
      update documents
        set refdoc_id = :i_refdoc_id
        where document_id = :o_doc_id;
  end
  suspend;
end