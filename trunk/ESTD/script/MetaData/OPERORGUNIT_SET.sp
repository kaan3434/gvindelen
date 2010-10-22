CREATE OR ALTER PROCEDURE OPERORGUNIT_SET (
    I_OPER_ID TYPE OF ID_OPER,
    I_ORGUNIT_ID TYPE OF ID_ORGUNIT)
RETURNS (
    O_OPERORGUNIT_ID TYPE OF ID_OPEROBJ)
AS
begin
  update or insert into operorgunits (oper_id, orgunit_id)
    values(:i_oper_id, :i_orgunit_id)
    matching (oper_id)
    returning operorgunit_id
    into :o_operorgunit_id;
  suspend;
end