CREATE OR ALTER PROCEDURE LIT_25_SET_0001 (
    I_DOCUMENT_LABEL TYPE OF LABEL_OBJECT,
    I_OPER_NUM TYPE OF NUM_POSITION,
    I_DOCSET_NAME TYPE OF NAME_OBJECT,
    I_SHOP_SIGN TYPE OF CODE_ORGUNIT,
    I_AREA_SIGN TYPE OF CODE_ORGUNIT,
    I_WORKPLACE_SIGN TYPE OF CODE_ORGUNIT,
    I_TSHT TYPE OF VALUE_DECIMAL)
AS
declare variable V_DOCSET_ID type of ID_DOCSET;
declare variable V_DOCUMENT_ID type of ID_OBJECT;
declare variable V_ORGUNIT_ID type of ID_ORGUNIT;
declare variable V_DOCOPER_ID type of ID_OPER;
declare variable V_OPER_ID type of ID_OPER;
declare variable V_OPERORGUNIT_ID type of ID_OPEROBJ;
declare variable V_REFDOC_ID type of ID_OBJECT;
declare variable V_OPER_NAME type of VALUE_ATTR;
declare variable V_OPERPROF_ID type of ID_OPEROBJ;
declare variable V_PROF_ID type of ID_OBJECT;
begin
  execute procedure doc_get_ref(:i_document_label)
    returning_values :v_document_id, :v_refdoc_id;

  execute procedure docset_get(:v_document_id, :i_docset_name)
    returning_values :v_docset_id;

  execute procedure docoper_find_opername(:v_refdoc_id, :i_oper_num)
    returning_values :v_oper_name;

  execute procedure docoper_goc(:v_document_id, :i_oper_num, :v_oper_name)
    returning_values :v_docoper_id;

  execute procedure oper_goc(:v_docoper_id, :v_docset_id)
    returning_values :v_oper_id;

  execute procedure orgunit_get(:i_shop_sign, :i_area_sign, :i_workplace_sign)
    returning_values :v_orgunit_id;
  execute procedure operorgunit_set(:v_oper_id, :v_orgunit_id)
    returning_values :v_operorgunit_id;

  -- get profcode from
  execute procedure prof_goc(0, null)
    returning_values :v_prof_id;

  execute procedure operprof_set_02(:v_oper_id, :v_prof_id,
    null, null, null, null, null, null,  null, null, null, :i_tsht)
    returning_values :v_operprof_id;
end