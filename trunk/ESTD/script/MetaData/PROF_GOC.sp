CREATE OR ALTER PROCEDURE PROF_GOC (
    I_PROF_CODE TYPE OF CODE_PROF NOT NULL,
    I_PROF_NAME TYPE OF NAME_OBJECT)
RETURNS (
    O_PROF_ID TYPE OF ID_OBJECT)
AS
begin
  update or insert into professions (prof_code, prof_name)
    values(:i_prof_code, :i_prof_name)
    matching(prof_code)
    returning prof_id
    into :o_prof_id;

  suspend;
end