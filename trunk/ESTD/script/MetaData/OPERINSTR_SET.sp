CREATE OR ALTER PROCEDURE OPERINSTR_SET (
    I_OPER_ID TYPE OF ID_OPER NOT NULL,
    I_INSTR_ID TYPE OF ID_OBJECT NOT NULL)
RETURNS (
    O_OPERINSTR_ID INTEGER)
AS
BEGIN
  update or insert into operinstrs (oper_id, instr_id)
    values(:i_oper_id, :i_instr_id)
    matching (oper_id, instr_id)
    returning operinstr_id
    into :o_operinstr_id;
  suspend;
END