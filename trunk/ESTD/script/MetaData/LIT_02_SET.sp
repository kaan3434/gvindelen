CREATE OR ALTER PROCEDURE LIT_02_SET (
    I_DOCUMENT_LABEL TYPE OF LABEL_OBJECT,
    I_OPER_NUM TYPE OF NUM_POSITION,
    I_EQUIP_LABELNAME TYPE OF VALUE_ATTR,
    I_SM TYPE OF VALUE_DECIMAL,
    I_PROF_CODE TYPE OF CODE_PROF,
    I_R TYPE OF VALUE_INTEGER,
    I_UT TYPE OF VALUE_INTEGER,
    I_KR TYPE OF VALUE_INTEGER,
    I_KOID TYPE OF VALUE_INTEGER,
    I_EN TYPE OF VALUE_INTEGER,
    I_OP TYPE OF VALUE_INTEGER,
    I_KSHT TYPE OF VALUE_DECIMAL,
    I_TPZ TYPE OF VALUE_DECIMAL,
    I_TSHT TYPE OF VALUE_DECIMAL)
AS
declare variable V_DOCUMENT_ID type of ID_OBJECT;
declare variable V_DOCSET_ID type of ID_DOCSET;
declare variable V_DOCOPER_ID type of ID_OPER;
declare variable V_OPER_ID type of ID_OPER;
declare variable V_EQUIP_ID type of ID_OBJECT;
declare variable V_EQUIP_NAME type of NAME_OBJECT;
declare variable V_EQUIP_LABEL type of LABEL_OBJECT;
declare variable V_PROF_ID type of ID_OBJECT;
declare variable V_OPEREQUIP_ID type of ID_OPEROBJ;
declare variable V_OPERPROF_ID type of ID_OPEROBJ;
begin
  execute procedure doc_get(:i_document_label)
    returning_values :v_document_id;

  execute procedure docset_goc(:v_document_id, null)
    returning_values :v_docset_id;

  execute procedure docoper_get(:v_document_id, :i_oper_num)
    returning_values :v_docoper_id;

  execute procedure oper_goc(:v_docoper_id, :v_docset_id)
    returning_values :v_oper_id;

  if (:i_equip_labelname is not null) then
  begin
    execute procedure splitstring(trim(:i_equip_labelname), ' ')
      returning_values :v_equip_label, :v_equip_name;
    if (:v_equip_label is null) then
      exception equipment_code_expected(:i_equip_labelname);
    if (:v_equip_name is null) then
      exception equipment_name_expected(:i_equip_labelname);

    execute procedure equip_goc(:v_equip_label, :v_equip_name)
      returning_values :v_equip_id;

    execute procedure operequip_set(:v_oper_id, :v_equip_id)
      returning_values :v_operequip_id;
  end

  if (:i_prof_code is not null) then
  begin
    execute procedure prof_goc(:i_prof_code, null)
      returning_values :v_prof_id;

    execute procedure operprof_set_02(:v_oper_id, :v_prof_id,
      :i_sm, :i_r, :i_ut, :i_kr, :i_koid, :i_en,
      :i_op, :i_ksht, :i_tpz, :i_tsht)
      returning_values :v_operprof_id;
  end
end