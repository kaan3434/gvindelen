CREATE OR ALTER PROCEDURE LIT_19_SET (
    I_DOCUMENT_LABEL TYPE OF LABEL_OBJECT,
    I_OPER_NUM TYPE OF NUM_POSITION,
    I_DOCSET_NAME TYPE OF NAME_OBJECT,
    I_INSTR_LABELNAMES TYPE OF VALUE_ATTR)
AS
declare variable V_DOCUMENT_ID type of ID_OBJECT;
declare variable V_DOCSET_ID type of ID_DOCSET;
declare variable V_DOCOPER_ID type of ID_OPER;
declare variable V_OPER_ID type of ID_OPER;
declare variable V_INSTR_ID type of ID_OBJECT;
declare variable V_INSTR_NAME type of NAME_OBJECT;
declare variable V_INSTR_LABEL type of LABEL_OBJECT;
declare variable V_INSTR_LABELNAME type of VALUE_ATTR;
declare variable V_OPERINSTR_ID type of ID_OPEROBJ;
begin

  execute procedure doc_get(:i_document_label)
    returning_values :v_document_id;

  execute procedure docset_goc(:v_document_id, :i_docset_name)
    returning_values :v_docset_id;

  execute procedure docoper_get(:v_document_id, :i_oper_num)
    returning_values :v_docoper_id;

  execute procedure oper_goc(:v_docoper_id, :v_docset_id)
    returning_values :v_oper_id;

  for select trim(o_string) from explode(:i_instr_labelnames, ';') into :v_instr_labelname do
  begin
    execute procedure splitstring(trim(:v_instr_labelname), ' ')
      returning_values :v_instr_label, :v_instr_name;
    if (:v_instr_label is null) then
      exception instrument_code_expected(:v_instr_labelname);
    if (:v_instr_name is null) then
      exception instrument_name_expected(:v_instr_labelname);

    execute procedure instr_goc(:v_instr_label, :v_instr_name)
      returning_values :v_instr_id;

    execute procedure operinstr_set(:v_oper_id, :v_instr_id)
      returning_values :v_operinstr_id;
  end
end