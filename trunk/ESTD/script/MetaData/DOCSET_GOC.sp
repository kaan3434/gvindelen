CREATE OR ALTER PROCEDURE DOCSET_GOC (
    I_DOC_ID TYPE OF ID_OBJECT NOT NULL,
    I_DOCSET_NAME TYPE OF NAME_OBJECT)
RETURNS (
    O_DOCSET_ID TYPE OF ID_DOCSET)
AS
begin
  if (:i_docset_name is null) then
    execute procedure docset_get_defname(:i_doc_id)
      returning_values :i_docset_name;
  select docset_id
    from docsets
    where document_id = :i_doc_id
      and docset_name = :i_docset_name
    into :o_docset_id;
  if (row_count = 0) then
    execute procedure docset_new(:i_doc_id, :i_docset_name)
      returning_values :o_docset_id;
  suspend;
end