CREATE OR ALTER PROCEDURE LIT_15_SET (
    I_DOCUMENT_LABEL TYPE OF LABEL_OBJECT,
    I_OPER_NUM TYPE OF NUM_POSITION,
    I_DOCSET_NAME TYPE OF NAME_OBJECT,
    I_NOTE BLOB SUB_TYPE 1 SEGMENT SIZE 32000 CHARACTER SET UTF8)
AS
declare variable V_DOCUMENT_ID type of ID_OBJECT;
declare variable V_DOCSET_ID type of ID_DOCSET;
declare variable V_DOCOPER_ID type of ID_OPER;
declare variable V_OPER_ID type of ID_OPER;
begin
  execute procedure doc_get(:i_document_label)
    returning_values :v_document_id;

  execute procedure docset_goc(:v_document_id, :i_docset_name)
    returning_values :v_docset_id;

  execute procedure docoper_get(:v_document_id, :i_oper_num)
    returning_values :v_docoper_id;

  execute procedure oper_goc(:v_docoper_id, :v_docset_id)
    returning_values :v_oper_id;

  execute procedure opernote_set(:v_oper_id, :i_note);
end