CREATE OR ALTER PROCEDURE OPERMAT_ATTR_GET (
    I_OPEROBJ_ID TYPE OF ID_OPEROBJ NOT NULL,
    I_ATTR_CODE TYPE OF SIGN_ATTR NOT NULL)
RETURNS (
    O_ATTR_VALUE TYPE OF VALUE_ATTR,
    O_KEI TYPE OF CODE_KEI)
AS
begin
  select ooa.attr_value, ooa.kei
    from opermatattrs ooa
    where ooa.opermat_id = :i_operobj_id
      and attr_code = upper(:i_attr_code)
    into :o_attr_value, :o_kei;
  suspend;
end