CREATE OR ALTER PROCEDURE DOCSET_NEW (
    I_DOCUMENT_ID TYPE OF ID_OBJECT NOT NULL,
    I_DOCSET_NAME TYPE OF NAME_OBJECT)
RETURNS (
    O_DOCSET_ID TYPE OF ID_DOCSET)
AS
begin
  if (:i_docset_name is null) then
    execute procedure docset_get_defname(:i_document_id)
      returning_values :i_docset_name;
  insert into docsets(document_id, docset_name)
    values(:i_document_id, :i_docset_name)
    returning docset_id
    into :o_docset_id;
  suspend;
end