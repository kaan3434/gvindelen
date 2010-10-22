CREATE OR ALTER PROCEDURE DOC_GOC (
    I_DOC_LABEL TYPE OF LABEL_OBJECT)
RETURNS (
    O_DOC_ID TYPE OF ID_OBJECT)
AS
begin
  select obj_id
    from objects
    where obj_label = :i_doc_label
    into :o_doc_id;
  if (row_count = 0) then
    execute procedure doc_new(:i_doc_label, null)
      returning_values :o_doc_id;
  suspend;
end