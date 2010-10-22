CREATE OR ALTER PROCEDURE BLOCK_GET_LAST (
    I_DOCUMENT_ID TYPE OF ID_BLOCK)
RETURNS (
    O_BLOCK_ID TYPE OF ID_BLOCK,
    O_BLOCK_SIGN TYPE OF SIGN_BLOCK)
AS
begin
  select first 1 l.block_id, b.block_sign
    from lines l
      inner join blocks b on (b.block_id = l.block_id)
    where l.document_id = :i_document_id
    order by l.line_id desc
    into :o_block_id, :o_block_sign;
  suspend;
end