CREATE OR ALTER PROCEDURE BLOCK_01_GEN (
    I_DOCFORM TYPE OF SIGN_DOCFORM,
    I_DOCUMENT_ID TYPE OF ID_OBJECT,
    I_BLOCK_SIGN TYPE OF SIGN_BLOCK)
AS
declare variable V_DOCSET_ID type of ID_DOCSET;
declare variable V_OPER_ID type of ID_OPER;
declare variable V_BLOCK_ID type of ID_BLOCK;
declare variable V_BLOCK_SIGN type of SIGN_BLOCK;
declare variable V_DOCSET_NAME type of NAME_OBJECT;
begin
  select o_docset_name
    from docset_get_defname(:i_document_id)
    into :v_docset_name;
  select ds.docset_id
    from docsets ds
    where ds.document_id = :i_document_id
      and ds.docset_name = :v_docset_name
    into :v_docset_id;

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