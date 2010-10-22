CREATE OR ALTER PROCEDURE OBJTYPE_ATTR_GET (
    I_OBJTYPE TYPE OF SIGN_OBJTYPE,
    I_ATTR_CODE TYPE OF SIGN_ATTR)
RETURNS (
    O_ATTR_VALUE TYPE OF VALUE_ATTR)
AS
begin
  while (:i_OBJTYPE <> '') do
  begin
    select first 1 attr_value
      from objtypeattrs
      where OBJTYPE = :i_OBJTYPE
        and attr_code = upper(:i_attr_code)
      into o_attr_value;
    if (row_count = 1) then
    begin
      suspend;
      exit;
    end
    i_OBJTYPE = substring(:i_OBJTYPE from 1 for strlen(:i_OBJTYPE)-1);
  end
  suspend;
end