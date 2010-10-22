CREATE OR ALTER PROCEDURE LIT_34_SET (
    I_DOCUMENT_LABEL TYPE OF LABEL_OBJECT NOT NULL,
    I_OPER_NUM TYPE OF NUM_POSITION NOT NULL,
    I_DOCSET_NAME TYPE OF NAME_OBJECT,
    I_HALF_OPER_NUM TYPE OF NUM_POSITION NOT NULL,
    I_KEI TYPE OF CODE_KEI,
    I_EN TYPE OF VALUE_INTEGER,
    I_KI TYPE OF VALUE_INTEGER)
AS
declare variable V_DOCUMENT_ID type of ID_OBJECT;
declare variable V_DOCSET_ID type of ID_DOCSET;
declare variable V_DOCOPER_ID type of ID_OPER;
declare variable V_OPER_ID type of ID_OPER;
declare variable V_HALF_ID type of ID_OBJECT;
declare variable V_OPERHALF_ID type of ID_OPEROBJ;
begin
  execute procedure doc_get(:i_document_label)
    returning_values :v_document_id;

  execute procedure docset_goc(:v_document_id, :i_docset_name)
    returning_values :v_docset_id;

  execute procedure docoper_get(:v_document_id, :i_oper_num)
    returning_values :v_docoper_id;

  execute procedure oper_goc(:v_docoper_id, :v_docset_id)
    returning_values :v_oper_id;

  execute procedure half_goc(:v_document_id, :i_half_oper_num)
    returning_values :v_half_id;

  execute procedure operhalf_set_11(:v_oper_id, :v_half_id,
    :i_kei, :i_en, :i_ki)
    returning_values :v_operhalf_id;

end