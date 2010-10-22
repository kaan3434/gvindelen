CREATE OR ALTER PROCEDURE LIT_11_SET (
    I_DOCUMENT_LABEL TYPE OF LABEL_OBJECT NOT NULL,
    I_OPER_NUM TYPE OF NUM_POSITION NOT NULL,
    I_DOCSET_NAME TYPE OF NAME_OBJECT,
    I_DET_NAME TYPE OF NAME_OBJECT NOT NULL,
    I_DET_NOTE TYPE OF VALUE_ATTR,
    I_DET_LABEL TYPE OF LABEL_OBJECT NOT NULL,
    I_OPP TYPE OF VALUE_INTEGER,
    I_KEI TYPE OF CODE_KEI NOT NULL,
    I_EN TYPE OF VALUE_INTEGER NOT NULL,
    I_KI TYPE OF VALUE_INTEGER NOT NULL)
AS
declare variable V_DOCUMENT_ID type of ID_OBJECT;
declare variable V_DOCSET_ID type of ID_DOCSET;
declare variable V_DOCOPER_ID type of ID_OPER;
declare variable V_OPER_ID type of ID_OPER;
declare variable V_DET_ID type of ID_OBJECT;
declare variable V_OPERDET_ID type of ID_OPEROBJ;
begin
  execute procedure doc_get(:i_document_label)
    returning_values :v_document_id;

  execute procedure docset_goc(:v_document_id, :i_docset_name)
    returning_values :v_docset_id;

  execute procedure docoper_get(:v_document_id, :i_oper_num)
    returning_values :v_docoper_id;

  execute procedure oper_goc(:v_docoper_id, :v_docset_id)
    returning_values :v_oper_id;

  execute procedure det_goc(:i_det_label, :i_det_name)
    returning_values :v_det_id;

  execute procedure operdet_set_11(:v_oper_id, :v_det_id, :i_det_note, 
    :i_opp, :i_kei, :i_en, :i_ki)
    returning_values :v_operdet_id;
end