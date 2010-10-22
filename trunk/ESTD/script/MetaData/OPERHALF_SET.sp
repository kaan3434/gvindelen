CREATE OR ALTER PROCEDURE OPERHALF_SET (
    I_OPER_ID TYPE OF ID_OPER,
    I_HALF_ID TYPE OF ID_OBJECT)
RETURNS (
    O_OPERHALF_ID TYPE OF ID_OPEROBJ)
AS
begin
  update or insert into operhalfs (oper_id, half_id)
    values(:i_oper_id, :i_half_id)
    matching (oper_id, half_id)
    returning operhalf_id
    into :o_operhalf_id;

  suspend;
end