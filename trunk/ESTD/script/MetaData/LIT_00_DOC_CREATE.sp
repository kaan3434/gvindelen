CREATE OR ALTER PROCEDURE LIT_00_DOC_CREATE (
    I_DOCUMENT_LABEL TYPE OF LABEL_OBJECT NOT NULL,
    I_DOCUMENT_NAME TYPE OF NAME_OBJECT NOT NULL,
    I_REFDOC_LABEL TYPE OF LABEL_OBJECT = null,
    I_DET_LABELS TYPE OF VALUE_ATTR = null)
AS
declare variable V_DOCUMENT_ID type of ID_OBJECT;
declare variable V_REFDOC_ID type of ID_OBJECT;
declare variable V_DET_LABEL type of LABEL_OBJECT;
declare variable V_DET_ID type of ID_OBJECT;
declare variable V_DOCSET_ID type of ID_DOCSET;
begin
  if (:i_refdoc_label is not null) then
    execute procedure doc_goc(:i_refdoc_label)
      returning_values :v_refdoc_id;

  execute procedure doc_uoc(:i_document_label, :i_document_name, :v_refdoc_id)
    returning_values :v_document_id;

  if (:i_det_labels is not null) then
  begin
    execute procedure docset_new(:v_document_id, null)
      returning_values :v_docset_id;
    for select o_det_label from det_labels_explode(:i_det_labels) into :v_det_label do
    begin
      execute procedure det_goc(:v_det_label, null)
        returning_values :v_det_id;
      execute procedure docset_add_det(:v_docset_id, :v_det_id);
    end
  end

end