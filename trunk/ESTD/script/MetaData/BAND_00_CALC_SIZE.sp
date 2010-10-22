CREATE OR ALTER PROCEDURE BAND_00_CALC_SIZE (
    I_DOCFORM TYPE OF SIGN_DOCFORM,
    I_DOCUMENT_ID TYPE OF ID_OBJECT,
    I_BLOCK_SIGN TYPE OF SIGN_BLOCK)
RETURNS (
    O_LINE_COUNT TYPE OF NUM_POSITION,
    O_PARENT_ID TYPE OF ID_BLOCK)
AS
declare variable V_BLOCK_SIGN type of SIGN_BLOCK;
declare variable V_BLOCK_ID type of ID_BLOCK;
declare variable V_BLANK_BAND_COUNT type of NUM_POSITION;
declare variable V_LITERA type of SIGN_LITERA;
declare variable V_IS_COMMON type of VALUE_BOOLEAN;
begin
  select b.litera
    from block_ref b
    where b.block_sign = :i_block_sign
    into :v_litera;
  if (:v_litera is null) then
    exit;

  execute procedure block_get_last(:i_document_id)
    returning_values :v_block_id, :v_block_sign;
  if (:v_block_sign is null) then
    exit;

  select br.blank_band, br.is_common
    from block_relate br
    where br.docform = :i_docform
      and br.block_prev = :v_block_sign
      and br.block_next = :i_block_sign
    into :o_line_count, :v_is_common;
  if (row_count = 0) then
    exception undefined_block_relation('prev = '||:v_block_sign||' next = '||:i_block_sign);
  if (:v_is_common = 1) then
    o_parent_id = :v_block_id;
  suspend;
end