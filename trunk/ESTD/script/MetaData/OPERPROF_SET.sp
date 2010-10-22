CREATE OR ALTER PROCEDURE OPERPROF_SET (
    I_OPER_ID TYPE OF ID_OPER NOT NULL,
    I_PROF_ID TYPE OF ID_OBJECT NOT NULL)
RETURNS (
    O_OPERPROF_ID TYPE OF ID_OPEROBJ)
AS
begin
  update or insert into operprofs (oper_id, prof_id)
    values(:i_oper_id, :i_prof_id)
    matching (oper_id, prof_id)
    returning operprof_id
    into :o_operprof_id;

  suspend;
end