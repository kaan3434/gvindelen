CREATE OR ALTER PROCEDURE OPERHALF_ATTR_GET (
    I_OPERHALF_ID TYPE OF ID_OPEROBJ NOT NULL,
    I_ATTR_CODE TYPE OF SIGN_ATTR NOT NULL)
RETURNS (
    O_ATTR_VALUE TYPE OF VALUE_ATTR,
    O_KEI TYPE OF CODE_KEI)
AS
begin
  select oda.attr_value, oda.kei
    from operhalfattrs oda
    where oda.operhalf_id = :i_operhalf_id
      and attr_code = upper(:i_attr_code)
    into :o_attr_value, :o_kei;
  suspend;
end