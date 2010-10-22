CREATE OR ALTER PROCEDURE INSTR_GOC (
    I_INSTR_LABEL TYPE OF LABEL_OBJECT NOT NULL,
    I_INSTR_NAME TYPE OF NAME_OBJECT NOT NULL)
RETURNS (
    O_INSTR_ID TYPE OF ID_OBJECT)
AS
begin
  select obj_id
    from objects
    where obj_label = :i_instr_label
    into :o_instr_id;
  if (row_count = 0) then
    execute procedure instr_new(:i_instr_label, :i_instr_name)
      returning_values :o_instr_id;
  else
    execute procedure obj_gost_upd(:o_instr_id, :i_instr_name);
  suspend;
end