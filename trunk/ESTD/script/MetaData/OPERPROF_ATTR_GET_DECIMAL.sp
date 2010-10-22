CREATE OR ALTER PROCEDURE OPERPROF_ATTR_GET_DECIMAL (
    I_OPEROBJ_ID TYPE OF ID_OPEROBJ NOT NULL,
    I_ATTR_CODE TYPE OF SIGN_ATTR NOT NULL)
RETURNS (
    O_ATTR_VALUE TYPE OF VALUE_DECIMAL,
    O_KEI TYPE OF CODE_KEI)
AS
begin
  select cast(ooa.attr_value as value_decimal), ooa.kei
    from operprofattrs ooa
    where ooa.operprof_id = :i_operobj_id
      and attr_code = upper(:i_attr_code)
    into :o_attr_value, :o_kei;
  suspend;
end