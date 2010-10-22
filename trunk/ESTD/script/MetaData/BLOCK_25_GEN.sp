CREATE OR ALTER PROCEDURE BLOCK_25_GEN (
    I_DOCFORM TYPE OF SIGN_DOCFORM NOT NULL,
    I_DOCUMENT_ID TYPE OF ID_OBJECT NOT NULL,
    I_BLOCK_SIGN TYPE OF SIGN_BLOCK NOT NULL)
AS
declare variable V_DOCSET_ID type of ID_DOCSET;
declare variable V_OPER_ID type of ID_OPER;
declare variable V_BLOCK_ID type of ID_BLOCK;
declare variable V_BLOCK_SIGN type of SIGN_BLOCK;
begin
  execute procedure param_get('DocSet_Id') returning_values :v_docset_id;
  for select op.oper_id
      from opers op
       inner join docopers dop on (dop.docoper_id = op.docoper_id)
      where op.docset_id = :v_docset_id
      order by dop.oper_num
      into :v_oper_id do
  begin
    execute procedure block_new(trim(:i_docform), :i_document_id, :i_block_sign)
      returning_values :v_block_id;

    execute procedure param_set('Oper_Id', :v_oper_id);
    execute procedure bands_gen(trim(:i_docform), :i_document_id, :i_block_sign, :v_block_id);

    execute procedure blocks_gen(trim(:i_docform), :i_document_id, :i_block_sign);
  end
end