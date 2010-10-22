CREATE OR ALTER PROCEDURE XML_EXP_OPERINSTRS (
    ND_ROOT TYPE OF ID_ELEM,
    ND_OPER TYPE OF ID_ELEM,
    I_OPER_ID TYPE OF ID_OPER)
AS
declare variable V_OBJ_ID type of ID_OBJECT;
declare variable V_OBJ_LABEL type of LABEL_OBJECT;
declare variable ND_OPEROBJ type of ID_ELEM;
declare variable V_IS_NEW type of VALUE_BOOLEAN;
declare variable ND_OBJECT type of ID_ELEM;
begin
  for select instr_id
   from operinstrs
   where oper_id = :i_oper_id
   into :v_obj_id do
  begin
    execute procedure xml_exp_object(:nd_root, :v_obj_id)
      returning_values :v_obj_label, :nd_object;
    execute procedure xml_create_elem
      :nd_oper, 'InstrumentList/Instrument[]', :v_obj_label
      returning_values :nd_operobj, :v_is_new;
  end
end