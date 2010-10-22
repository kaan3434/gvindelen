CREATE OR ALTER PROCEDURE DOC_GET_REF (
    I_DOC_LABEL TYPE OF LABEL_OBJECT)
RETURNS (
    O_DOC_ID TYPE OF ID_OBJECT,
    O_REFDOC_ID TYPE OF ID_OBJECT)
AS
declare variable V_DOC_LABEL integer;
begin
  select d.document_id, d.refdoc_id
    from documents d
      inner join objects o on (o.obj_id = d.document_id)
    where o.obj_label = :i_doc_label
    into :o_doc_id, :o_refdoc_id;

  if (row_count = 0) then
    exception document_not_found(:i_doc_label);

  if (o_refdoc_id is null) then
    exception undefined_refdocument(:i_doc_label);

  suspend;
end