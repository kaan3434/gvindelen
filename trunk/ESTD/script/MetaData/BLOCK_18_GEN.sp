CREATE OR ALTER PROCEDURE BLOCK_18_GEN (
    I_DOCFORM TYPE OF SIGN_DOCFORM,
    I_DOCUMENT_ID TYPE OF ID_OBJECT,
    I_BLOCK_SIGN TYPE OF SIGN_BLOCK)
AS
declare variable V_DOCSET_ID type of ID_DOCSET;
declare variable V_BLOCK_ID type of ID_BLOCK;
begin
  for select ds.docset_id
      from docsets ds
      where ds.document_id = :i_document_id
      into :v_docset_id do
  begin
    execute procedure block_new(trim(:i_docform), :i_document_id, :i_block_sign)
      returning_values :v_block_id;

    execute procedure param_set('DocSet_Id', :v_docset_id);
    execute procedure bands_gen(trim(:i_docform), :i_document_id, :i_block_sign, :v_block_id);

    execute procedure blocks_gen(trim(:i_docform), :i_document_id, :i_block_sign);
  end
end