CREATE OR ALTER PROCEDURE BLOCK_11_GEN (
    I_DOCFORM TYPE OF SIGN_DOCFORM NOT NULL,
    I_DOCUMENT_ID TYPE OF ID_OBJECT NOT NULL,
    I_BLOCK_SIGN TYPE OF SIGN_BLOCK NOT NULL)
AS
declare variable V_BLOCK_ID type of ID_BLOCK;
declare variable V_OPER_ID type of ID_OPER;
declare variable V_OPEROBJ_ID type of ID_OPEROBJ;
begin
  execute procedure param_get('Oper_Id') returning_values :v_oper_id;

  select first 1 operdet_id
    from (select first 1 od.operdet_id
            from operdets od
            where od.oper_id = :v_oper_id
          union
          select first 1 od.operhalf_id
            from operhalfs od
            where od.oper_id = :v_oper_id)
    into :v_operobj_id;
  if (row_count = 0) then exit;

  execute procedure block_new(trim(:i_docform), :i_document_id, :i_block_sign)
    returning_values :v_block_id;

  execute procedure param_set('Det_Index', 0);

  execute procedure blocks_gen(trim(:i_docform), :i_document_id, :i_block_sign);
end