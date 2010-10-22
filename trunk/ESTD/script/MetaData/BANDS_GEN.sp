CREATE OR ALTER PROCEDURE BANDS_GEN (
    I_DOCFORM TYPE OF SIGN_DOCFORM NOT NULL,
    I_DOCUMENT_ID TYPE OF ID_OBJECT NOT NULL,
    I_BLOCK_SIGN TYPE OF SIGN_BLOCK NOT NULL,
    I_BLOCK_ID TYPE OF ID_BLOCK NOT NULL)
AS
declare variable V_BAND_SIGN type of SIGN_BAND;
declare variable V_BAND_ID type of ID_BAND;
declare variable V_BAND_SIZE type of NUM_POSITION;
declare variable V_LINE_ID type of ID_LINE;
begin
  select bb.band_sign
    from blockbands bb
    where bb.docform = :i_docform
      and bb.block_sign = :i_block_sign
    into :v_band_sign;
  if (:v_band_sign = '01') then
    execute procedure band_01_gen(:i_block_id, :v_band_sign) returning_values :v_band_id;
  else
  if (:v_band_sign = '02') then
    execute procedure band_02_gen(:i_block_id, :v_band_sign);
  else
  if (:v_band_sign = '15') then
    execute procedure band_15_gen(:i_block_id, :v_band_sign);
  else
  if (:v_band_sign = '19') then
    execute procedure band_19_gen(:i_block_id, :v_band_sign);
  else
  if (:v_band_sign = '18') then
    execute procedure band_18_gen(:i_block_id, :v_band_sign)
      returning_values :v_band_id;
  else
  if (:v_band_sign = '25') then
    execute procedure band_25_gen(:i_block_id, :v_band_sign);
  else
  if (:v_band_sign = '11') then
    execute procedure band_11_gen(:i_block_id, :v_band_sign);
  else
  if (:v_band_sign = '13') then
    execute procedure band_13_gen(:i_block_id, :v_band_sign);
  else
  if (:v_band_sign = '34') then
    execute procedure band_34_gen(:i_block_id, :v_band_sign);
  else
    exception unknown_band(:v_band_sign);

--      execute statement 'execute procedure band_'||:v_band_sign||'_gen('||v_band_id||')';
end