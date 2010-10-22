CREATE OR ALTER PROCEDURE SPLITSTRINGMM (
    I_HEAD TYPE OF VALUE_ATTR,
    I_STRING TYPE OF VALUE_ATTR,
    I_DEVIDER TYPE OF TEXT,
    I_CELL_SIZE TYPE OF SIZE_MM,
    I_FONT_SIZE TYPE OF VALUE_INTEGER)
RETURNS (
    O_HEAD TYPE OF VALUE_ATTR,
    O_TILE TYPE OF VALUE_ATTR)
AS
begin
  o_head = nullif(copyfront_withkey(:i_string, :i_devider), '');
  if (o_head is null) then
  begin
    o_head = i_string;
    o_tile = null;
  end
  else
    o_tile = nullif(substring(:i_string from strlen(o_Head)+1), '');

  if (strlenmm(:i_head||:o_head, :i_font_size) > :i_cell_size) then
  begin
    o_head = i_head;
    o_tile = i_string;
  end
  else
    execute procedure splitstringmm(:i_head||:o_head, :o_tile, :i_devider, :i_cell_size, :i_font_size)
      returning_values :o_head, :o_tile;
  suspend;
end