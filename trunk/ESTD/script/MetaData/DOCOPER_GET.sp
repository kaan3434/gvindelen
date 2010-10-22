CREATE OR ALTER PROCEDURE DOCOPER_GET (
    I_DOCUMENT_ID TYPE OF ID_OBJECT,
    I_OPER_NUM TYPE OF NUM_POSITION)
RETURNS (
    O_DOCOPER_ID TYPE OF ID_OPER)
AS
begin
  select d.docoper_id
    from docopers d
    where d.document_id = :i_document_id
      and d.oper_num = :i_oper_num
    into :o_docoper_id;
  if (row_count = 0) then
    exception docoper_not_found;
  suspend;
end