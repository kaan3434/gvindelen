CREATE OR ALTER PROCEDURE BLOCK_02_GEN (
    I_DOCFORM TYPE OF SIGN_DOCFORM NOT NULL,
    I_DOCUMENT_ID TYPE OF ID_OBJECT NOT NULL,
    I_BLOCK_SIGN TYPE OF SIGN_BLOCK NOT NULL)
AS
declare variable V_BLOCK_ID type of ID_BLOCK;
declare variable V_OPER_ID type of ID_OPER;
declare variable V_OPEROBJ_ID type of ID_OPEROBJ;
declare variable V_FETCH_COUNT type of VALUE_INTEGER;
declare C_OPEREQUIP cursor for (
    select OO.OPEREQUIP_ID
      from OPEREQUIPS OO
    inner join OBJECTS O on (O.OBJ_ID = OO.EQUIP_ID)
      where OO.OPER_ID = :V_OPER_ID);
declare C_OPERPROF cursor for (
    select OO.OPERPROF_ID
      from OPERPROFS OO
      where OO.OPER_ID = :V_OPER_ID);
begin
  execute procedure param_get('Oper_Id') returning_values :v_oper_id;

  select first 1 operequip_id
    from (select first 1 od.operequip_id
            from operequips od
            where od.oper_id = :v_oper_id
          union
          select first 1 od.operprof_id
            from operprofs od
            where od.oper_id = :v_oper_id)
    into :v_operobj_id;
  if (row_count = 0) then exit;

  execute procedure block_new(trim(:i_docform), :i_document_id, :i_block_sign)
    returning_values :v_block_id;

  open c_operequip;
  open c_operprof;

  v_fetch_count = 1;
  while (:v_fetch_count > 0) do
  begin
    fetch c_operequip into :v_operobj_id;
    if (row_count > 0) then
      execute procedure param_set('OperEquip_Id', :v_operobj_id);
    else
      execute procedure param_del('OperEquip_Id');
    v_fetch_count = row_count;
    fetch c_operprof into :v_operobj_id;
    if (row_count > 0) then
      execute procedure param_set('OperProf_Id', :v_operobj_id);
    else
      execute procedure param_del('OperProf_Id');
    v_fetch_count = v_fetch_count + row_count;

    if (v_fetch_count > 0 ) then
      execute procedure bands_gen(trim(:i_docform), :i_document_id, :i_block_sign, :v_block_id);
  end
  close c_operprof;
  close c_operequip;
end