CREATE OR ALTER PROCEDURE LIT_13_SET (
    I_DOCUMENT_LABEL TYPE OF LABEL_OBJECT,
    I_OPER_NUM TYPE OF NUM_POSITION,
    I_DOCSET_NAME TYPE OF NAME_OBJECT,
    I_MAT_NAME TYPE OF NAME_OBJECT,
    I_MAT_LABEL TYPE OF LABEL_OBJECT,
    I_OPP TYPE OF VALUE_INTEGER,
    I_KEI TYPE OF CODE_KEI,
    I_EN TYPE OF VALUE_INTEGER,
    I_NORMRASH TYPE OF VALUE_DECIMAL)
AS
declare variable V_DOCUMENT_ID type of ID_OBJECT;
declare variable V_DOCSET_ID type of ID_DOCSET;
declare variable V_DOCOPER_ID type of ID_OPER;
declare variable V_OPER_ID type of ID_OPER;
declare variable V_MAT_ID type of ID_OBJECT;
declare variable V_OPERMAT_ID type of ID_OPEROBJ;
begin
  execute procedure doc_get(:i_document_label)
    returning_values :v_document_id;

  execute procedure docset_goc(:v_document_id, :i_docset_name)
    returning_values :v_docset_id;

  execute procedure docoper_get(:v_document_id, :i_oper_num)
    returning_values :v_docoper_id;

  execute procedure oper_goc(:v_docoper_id, :v_docset_id)
    returning_values :v_oper_id;

  execute procedure mat_goc(:i_mat_label, :i_mat_name, :i_kei)
    returning_values :v_mat_id;

  execute procedure opermat_set_13(:v_oper_id, :v_mat_id,
    :i_opp, :i_kei, :i_en, :i_normrash)
    returning_values :v_opermat_id;
end