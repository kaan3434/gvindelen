CREATE OR ALTER PROCEDURE BAND_00_GEN (
    I_BLOCK_ID TYPE OF ID_BLOCK NOT NULL,
    I_BAND_SIGN TYPE OF SIGN_BAND NOT NULL,
    I_BLANK_LINE_COUNT TYPE OF NUM_POSITION NOT NULL,
    I_FORM_ID TYPE OF ID_FORM = null)
RETURNS (
    O_BAND_ID INTEGER)
AS
declare variable V_LINE_ID type of ID_LINE;
declare variable I type of NUM_POSITION;
begin
  execute procedure band_new(:i_block_id, :i_band_sign) returning_values :o_band_id;
  i = 0;
  while (i < :i_blank_line_count) do
  begin
    execute procedure line_new(:i_block_id, :o_band_id, :i_form_id)
      returning_values :v_line_id;
    i = i + 1;
  end
end