CREATE OR ALTER PROCEDURE BLOCK_NEW (
    I_OBJTYPE TYPE OF SIGN_OBJTYPE,
    I_DOCUMENT_ID TYPE OF ID_OBJECT NOT NULL,
    I_BLOCK_SIGN TYPE OF SIGN_BLOCK NOT NULL)
RETURNS (
    O_BLOCK_ID TYPE OF ID_BLOCK)
AS
declare variable V_BLOCK_SIGN type of SIGN_BLOCK;
declare variable V_BAND_00_SIZE type of NUM_POSITION;
declare variable V_BAND_ID type of ID_BAND;
declare variable V_PARENT_ID type of ID_BLOCK;
begin
  execute procedure block_get_last(:i_document_id)
    returning_values :o_block_id, :v_block_sign;
  if ((:v_block_sign <> trim(:i_block_sign)) or (:v_block_sign is null)) then
  begin
    execute procedure band_00_calc_size(trim(:i_OBJTYPE), :i_document_id, :i_block_sign)
      returning_values :v_band_00_size, :v_parent_id;
    if (:v_band_00_size > 0) then
      execute procedure band_00_gen(:o_block_id, '00', :v_band_00_size)
        returning_values :v_band_id;
    insert into blocks (document_id, block_sign, parent_id)
      values(:i_document_id, trim(:i_block_sign), :v_parent_id)
      returning block_id
      into :o_block_id;
  end
  suspend;
end