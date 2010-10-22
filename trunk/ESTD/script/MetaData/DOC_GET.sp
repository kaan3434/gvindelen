CREATE OR ALTER PROCEDURE DOC_GET (
    I_DOC_LABEL TYPE OF LABEL_OBJECT)
RETURNS (
    O_OBJ_ID TYPE OF ID_OBJECT)
AS
begin
  select obj_id
    from objects
    where obj_label = :i_doc_label
    into o_obj_id;
  if (row_count = 0) then
    exception document_not_found(:i_doc_label);
  suspend;
end