CREATE OR ALTER PROCEDURE OPER_GOC (
    I_DOCOPER_ID TYPE OF ID_OPER NOT NULL,
    I_DOCSET_ID TYPE OF ID_DOCSET NOT NULL)
RETURNS (
    O_OPER_ID TYPE OF ID_OPER)
AS
begin
  select oper_id
    from opers
    where docset_id = :i_docset_id
      and docoper_id = :i_docoper_id
    into :o_oper_id;
  if (row_count = 0) then
    insert into opers(docoper_id, docset_id)
      values(:i_docoper_id, :i_docset_id)
      returning oper_id
      into :o_oper_id;
  suspend;
end