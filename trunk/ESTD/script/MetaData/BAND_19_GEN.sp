CREATE OR ALTER PROCEDURE BAND_19_GEN (
    I_BLOCK_ID TYPE OF ID_BLOCK NOT NULL,
    I_BAND_SIGN TYPE OF SIGN_BAND NOT NULL)
AS
declare variable V_BAND_ID type of ID_BAND;
declare variable V_OPER_ID type of ID_OPEROBJ;
declare variable V_LINE_ID type of ID_LINE;
declare variable V_INSTR_LABELNAMES type of VALUE_ATTR;
declare variable V_INSTR_LABELNAMES_HEAD type of TEXT;
begin
  execute procedure param_get('Oper_Id') returning_values :v_oper_id;

  select list(obj_label||unescapestring('&nbsp;')||obj_name, '; ')
    from (select o.obj_label, o.obj_name||' '||unescapestring(replace(o.obj_gost,' ', '&nbsp;')) obj_name
            from operinstrs oo
              inner join objects o on (o.obj_id = oo.instr_id)
            where oo.oper_id = :v_oper_id
            order by o.objtype, o.obj_label)
    into :v_instr_labelnames;

  select o_band_id
    from band_new(:i_block_id, :i_band_sign)
    into :v_band_id;

  while (1=1) do
  begin
    select o_head, o_tile
      from splitstring_cell (:v_instr_labelnames, ' ', '19_2')
      into :v_instr_labelnames_head, :v_instr_labelnames;

    select o_line_id
      from line_new (:i_block_id, :v_band_id)
      into :v_line_id;

    insert into band_19(line_id, instr_labelnames)
      values(:v_line_id, :v_instr_labelnames_head);

    if (:v_instr_labelnames is null) then
      break;
  end
end