CREATE OR ALTER PROCEDURE OPERPROF_ATTR_SET (
    I_OPERPROF_ID TYPE OF ID_OPEROBJ,
    I_ATTR_CODE TYPE OF SIGN_ATTR,
    I_ATTR_VALUE TYPE OF VALUE_ATTR = null,
    I_KEI TYPE OF CODE_KEI = null)
AS
declare variable V_KEI type of CODE_KEI;
declare variable V_OBJ_ID type of ID_OBJECT;
begin
  if (:i_attr_value is null) then
  begin
    delete from operprofattrs
    where operprof_id = :i_operprof_id
      and attr_code = :i_attr_code;
  end
  else
  begin
    select kei
      from operprofattr_ref
      where attr_code = :i_attr_code
      into :v_kei;

    if (:i_kei is not null) then
    begin
      select master_kei from kei_okp where kei = :i_kei into :i_kei;
      execute procedure kei_convertibility(:v_kei, :i_kei, :v_obj_id);
    end

    update or insert into operprofattrs(operprof_id, attr_code, kei, attr_value)
      values(:i_operprof_id, :i_attr_code, coalesce(:i_kei, :v_kei), :i_attr_value)
      matching(operprof_id, attr_code);
  end
end