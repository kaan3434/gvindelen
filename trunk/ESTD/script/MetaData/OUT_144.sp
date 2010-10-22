CREATE OR ALTER PROCEDURE OUT_144 (
    I_DOCFORM TYPE OF SIGN_OBJTYPE NOT NULL,
    I_DOCUMENT_ID TYPE OF ID_OBJECT NOT NULL)
AS
declare variable V_BLOCK_SIGN type of SIGN_BLOCK;
begin
  delete from blocks
    where document_id = :i_document_id;

  select bt.block_sign
    from block_tree bt
    where bt.docform = :i_docform
      and bt.block_sign = bt.parent_block
    into :v_block_sign;

  execute procedure blocks_gen(:i_docform, :i_document_id, :v_block_sign);
end