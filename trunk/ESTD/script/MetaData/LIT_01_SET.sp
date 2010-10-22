CREATE OR ALTER PROCEDURE LIT_01_SET (
    I_DOCUMENT_LABEL TYPE OF LABEL_OBJECT,
    I_OPER_NUM TYPE OF NUM_POSITION,
    I_OPER_NAME TYPE OF VALUE_ATTR,
    I_SHOP_SIGN TYPE OF CODE_ORGUNIT,
    I_AREA_SIGN TYPE OF CODE_ORGUNIT,
    I_WORKPLACE_SIGN TYPE OF CODE_ORGUNIT,
    I_DOC_LABELS TYPE OF VALUE_ATTR)
AS
declare variable V_DOCSET_ID type of ID_DOCSET;
declare variable V_DOCUMENT_ID type of ID_OBJECT;
declare variable V_ORGUNIT_ID type of ID_ORGUNIT;
declare variable V_DOC_LABEL type of LABEL_OBJECT;
declare variable V_DOC_ID type of ID_OBJECT;
declare variable V_DOCOPER_ID type of ID_OPER;
declare variable V_OPER_ID type of ID_OPER;
declare variable V_OPERORGUNIT_ID type of ID_OPEROBJ;
declare variable V_OPERDOC_ID type of ID_OPEROBJ;
begin
  execute procedure doc_get(:i_document_label)
    returning_values :v_document_id;

  execute procedure docset_goc(:v_document_id, null)
    returning_values :v_docset_id;

  execute procedure docoper_goc(:v_document_id, :i_oper_num, :i_oper_name)
    returning_values :v_docoper_id;

  execute procedure oper_goc(:v_docoper_id, :v_docset_id)
    returning_values :v_oper_id;

  execute procedure orgunit_get(:i_shop_sign, :i_area_sign, :i_workplace_sign)
    returning_values :v_orgunit_id;
  execute procedure operorgunit_set(:v_oper_id, :v_orgunit_id)
    returning_values :v_operorgunit_id;

  for select trim(o_string) from explode(:i_doc_labels, ';') into :v_doc_label do
  begin
    execute procedure doc_goc(:v_doc_label)
      returning_values :v_doc_id;
    execute procedure operdoc_set(:v_oper_id, :v_doc_id)
      returning_values :v_operdoc_id;
  end
end