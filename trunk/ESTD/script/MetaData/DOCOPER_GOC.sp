CREATE OR ALTER PROCEDURE DOCOPER_GOC (
    I_DOCUMENT_ID TYPE OF ID_OBJECT NOT NULL,
    I_OPER_NUM TYPE OF NUM_POSITION NOT NULL,
    I_OPER_NAME TYPE OF NAME_OBJECT)
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
    insert into docopers(document_id, oper_num, oper_name)
      values(:i_document_id, :i_oper_num, :i_oper_name)
      returning docoper_id
      into :o_docoper_id;
  suspend;
end