CREATE OR ALTER PROCEDURE EXPLODE (
    I_STRING TYPE OF VALUE_ATTR,
    I_DEVIDER TYPE OF TEXT NOT NULL)
RETURNS (
    O_STRING TYPE OF VALUE_ATTR)
AS
begin
  while (i_string <>'') do
  begin
    o_string = copyfront_withoutkey(:i_string, :i_devider);
    suspend;
    o_string = copyfront_withkey(:i_string, :i_devider);
    i_string = substring(:i_string from strlen(o_string)+1);
  end
end