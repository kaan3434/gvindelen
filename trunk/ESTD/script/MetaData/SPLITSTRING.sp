CREATE OR ALTER PROCEDURE SPLITSTRING (
    I_STRING TYPE OF VALUE_ATTR,
    I_DEVIDER TYPE OF TEXT NOT NULL)
RETURNS (
    O_HEAD TYPE OF VALUE_ATTR,
    O_TILE TYPE OF VALUE_ATTR)
AS
begin
  o_head = nullif(copyfront_withkey(:i_string, :i_devider), '');
  if (o_head is null) then
    o_head = i_string;
  else
  begin
    o_tile = nullif(substring(:i_string from strlen(o_Head)+1), '');
    o_head = nullif(copyfront_withoutkey(:o_Head, :i_devider), '');
  end
  suspend;
end