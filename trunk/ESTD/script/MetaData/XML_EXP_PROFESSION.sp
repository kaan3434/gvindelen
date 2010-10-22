CREATE OR ALTER PROCEDURE XML_EXP_PROFESSION (
    ND_ROOT TYPE OF ID_ELEM NOT NULL,
    I_PROF_ID TYPE OF ID_OBJECT NOT NULL)
RETURNS (
    O_PROF_CODE TYPE OF CODE_PROF)
AS
declare variable V_PROF_NAME type of NAME_OKP;
declare variable ND_PROF type of ID_ELEM;
declare variable V_IS_NEW type of VALUE_BOOLEAN;
declare variable V_OKR_CODE type of CODE_PROFOKR;
begin
  for select p.prof_code, p.prof_name, p.prof_okr_code
    from professions p
    where p.prof_id = :i_prof_id
    into :o_prof_code, :v_prof_name, :v_okr_code do
  begin
    execute procedure xml_create_elem
      :nd_root, 'ProfessionList/Profession["'||:o_prof_code||'"]', :o_prof_code
      returning_values :nd_prof, :v_is_new;
    if (v_is_new = 1) then
    begin
      execute procedure xml_create_node(:nd_prof, 'Name', :v_prof_name);
      execute procedure xml_create_node(:nd_prof, 'OKR', :v_okr_code);
    end
  end
  suspend;
end