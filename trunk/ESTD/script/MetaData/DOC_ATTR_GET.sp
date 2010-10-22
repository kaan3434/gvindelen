CREATE OR ALTER PROCEDURE DOC_ATTR_GET (
    I_DOC_ID TYPE OF ID_OBJECT NOT NULL,
    I_ATTR_CODE TYPE OF SIGN_ATTR NOT NULL)
RETURNS (
    O_ATTR_VALUE TYPE OF VALUE_ATTR,
    O_KEI TYPE OF CODE_KEI)
AS
begin
  select oa.attr_value, oa.kei
    from docattrs oa
    where oa.document_id = :i_doc_id
      and attr_code = upper(:i_attr_code)
    into :o_attr_value, :o_kei;
  suspend;
end