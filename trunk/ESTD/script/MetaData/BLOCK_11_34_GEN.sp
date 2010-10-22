CREATE OR ALTER PROCEDURE BLOCK_11_34_GEN (
    I_DOCFORM TYPE OF SIGN_DOCFORM NOT NULL,
    I_DOCUMENT_ID TYPE OF ID_OBJECT NOT NULL,
    I_BLOCK_SIGN TYPE OF SIGN_BLOCK NOT NULL)
AS
declare variable V_OPER_ID type of ID_OPER;
declare variable V_OPEROBJ_ID type of ID_OPEROBJ;
declare variable V_BLOCK_ID type of ID_BLOCK;
begin
  select first 1 bl.block_id
    from blocks bl
    where bl.document_id = :i_document_id
    order by bl.block_id desc
    into :v_block_id;

  execute procedure param_get('Oper_Id') returning_values :v_oper_id;

  for select oo.operhalf_id
        from operhalfs oo
          inner join objects o on (o.obj_id = oo.half_id)
        where oo.oper_id = :v_oper_id
        order by o.obj_label
        into :v_operobj_id do
  begin
    execute procedure param_inc('Det_Index');
    execute procedure param_set('OperObj_Id', :v_operobj_id);
    execute procedure bands_gen(trim(:i_docform), :i_document_id, :i_block_sign, :v_block_id);
  end
end