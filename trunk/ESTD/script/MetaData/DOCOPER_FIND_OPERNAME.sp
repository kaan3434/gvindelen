CREATE OR ALTER PROCEDURE DOCOPER_FIND_OPERNAME (
    I_DOC_ID TYPE OF ID_OBJECT NOT NULL,
    I_OPER_NUM TYPE OF NUM_POSITION NOT NULL)
RETURNS (
    O_OPER_NAME TYPE OF NAME_OBJECT)
AS
begin
  select d.oper_name
    from docopers d
    where d.document_id = :i_doc_id
      and d.oper_num = :i_oper_num
    into :o_oper_name;
  suspend;
end