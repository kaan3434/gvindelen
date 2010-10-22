CREATE OR ALTER PROCEDURE BAND_15_GEN (
    I_BLOCK_ID TYPE OF ID_BLOCK,
    I_BAND_SIGN TYPE OF SIGN_BAND)
AS
declare variable V_BAND_ID type of ID_BAND;
declare variable V_OPER_ID type of ID_OPEROBJ;
declare variable V_LINE_ID type of ID_LINE;
declare variable V_PARAGRAPH type of VALUE_ATTR;
declare variable V_PARAGRAPH_HEAD type of TEXT;
declare variable V_CRLF varchar(10);
declare variable V_PARA varchar(10);
declare variable V_NOTE type of NOTE;
declare variable V_STRING type of VALUE_ATTR;
declare variable V_TILE type of VALUE_ATTR;
begin
  execute procedure param_get('Oper_Id') returning_values :v_oper_id;

  v_crlf = ascii_char(13)||ascii_char(10);
  v_para = unescapestring('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');

  select replace(:v_para||oo.note, :v_crlf, :v_crlf||:v_para)
    from opernotes oo
    where oo.oper_id = :v_oper_id
    into :v_note;

  while (1=1) do
  begin
    v_string = substring(:v_note from 1 for 4000);
    select o_head, o_tile
      from splitstring(:v_string, :v_crlf)
      into :v_paragraph, :v_tile;
    v_note = nullif(substring(v_note from strlen(:v_paragraph)+3), '');

    select o_band_id
      from band_new(:i_block_id, :i_band_sign)
      into :v_band_id;
    while (2=2) do
    begin
      select o_head, o_tile
        from splitstring_cell (:v_paragraph, ' ', '15_2')
        into :v_paragraph_head, :v_paragraph;

      select o_line_id
        from line_new (:i_block_id, :v_band_id)
        into :v_line_id;

      insert into band_15(line_id, note)
        values(:v_line_id, :v_paragraph_head);

      if (:v_paragraph is null) then
        break;
    end
    if (:v_note is null) then
      break;
  end
end