CREATE OR ALTER PROCEDURE BAND_NEW (
    I_BLOCK_ID TYPE OF ID_BLOCK NOT NULL,
    I_BAND_SIGN TYPE OF SIGN_BAND NOT NULL)
RETURNS (
    O_BAND_ID TYPE OF ID_BAND)
AS
begin
  insert into bands (block_id, band_sign)
    values(:i_block_id, :i_band_sign)
    returning band_id
    into :o_band_id;
  suspend;
end