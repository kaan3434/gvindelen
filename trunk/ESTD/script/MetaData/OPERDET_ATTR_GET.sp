CREATE OR ALTER PROCEDURE OPERDET_ATTR_GET (
    I_OPERDET_ID TYPE OF ID_OPEROBJ,
    I_ATTR_CODE TYPE OF SIGN_ATTR)
RETURNS (
    O_ATTR_VALUE TYPE OF VALUE_ATTR,
    O_KEI TYPE OF CODE_KEI)
AS
begin
  select oda.attr_value, oda.kei
    from operdetattrs oda
    where oda.operdet_id = :i_operdet_id
      and attr_code = upper(:i_attr_code)
    into :o_attr_value, :o_kei;
  suspend;
end