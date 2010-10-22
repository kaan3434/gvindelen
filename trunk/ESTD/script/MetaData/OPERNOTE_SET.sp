CREATE OR ALTER PROCEDURE OPERNOTE_SET (
    I_OPER_ID TYPE OF ID_OPER,
    I_NOTE BLOB SUB_TYPE 1 SEGMENT SIZE 32000 CHARACTER SET UTF8)
AS
begin
  update or insert into opernotes (oper_id, note)
    values(:i_oper_id, :i_note)
    matching (oper_id);
end