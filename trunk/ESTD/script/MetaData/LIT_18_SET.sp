CREATE OR ALTER PROCEDURE LIT_18_SET (
    I_DOCUMENT_LABEL TYPE OF LABEL_OBJECT NOT NULL,
    I_OBJ_NAME TYPE OF NAME_OBJECT NOT NULL,
    I_OBJ_LABELS TYPE OF VALUE_ATTR NOT NULL)
AS
declare variable V_DOCUMENT_ID type of ID_OBJECT;
declare variable V_DOCSET_ID type of ID_DOCSET;
declare variable V_DET_LABEL type of LABEL_OBJECT;
declare variable V_DET_ID type of ID_OBJECT;
begin
  execute procedure doc_get(:i_document_label)
    returning_values :v_document_id;

  execute procedure docset_goc(:v_document_id, :i_obj_labels)
    returning_values :v_docset_id;

  -- add details in docset
  for select o_det_label from det_labels_explode(:i_obj_labels) into :v_det_label do
  begin
    execute procedure det_goc(:v_det_label, :i_obj_name)
      returning_values :v_det_id;
    execute procedure docset_add_det(:v_docset_id, :v_det_id);
  end
end