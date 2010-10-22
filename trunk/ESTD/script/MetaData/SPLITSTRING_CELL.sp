CREATE OR ALTER PROCEDURE SPLITSTRING_CELL (
    I_STRING TYPE OF VALUE_ATTR,
    I_DEVIDER TYPE OF TEXT NOT NULL,
    I_CELL_SIGN TYPE OF SIGN_BLOCK NOT NULL)
RETURNS (
    O_HEAD TYPE OF VALUE_ATTR,
    O_TILE TYPE OF VALUE_ATTR)
AS
declare variable V_CELL_SIZE type of SIZE_MM;
declare variable V_FONT_SIZE type of VALUE_INTEGER;
begin
  if (:i_string is not null) then
  begin
    select c.size_cell, c.size_font
      from cells c
      where c.block_sign = :i_cell_sign
      into :v_cell_size, :v_font_size;
    if (row_count = 0) then
      exception cell_not_found(:i_cell_sign);
    if (strlenmm(:i_string, :v_font_size) <= round(:v_cell_size))  then
    begin
      o_head = i_string;
      o_tile = null;
    end
    else
      select o_head, o_tile
        from splitstringmm('', :i_string, :i_devider, :v_cell_size, :v_font_size)
        into :o_head, :o_tile;
  end
  suspend;
end