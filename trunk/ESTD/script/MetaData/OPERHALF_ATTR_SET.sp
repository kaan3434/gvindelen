CREATE OR ALTER PROCEDURE OPERHALF_ATTR_SET (
    I_OPERHALF_ID TYPE OF ID_OPEROBJ,
    I_ATTR_CODE TYPE OF SIGN_ATTR,
    I_ATTR_VALUE TYPE OF VALUE_ATTR,
    I_KEI TYPE OF CODE_KEI)
AS
declare variable V_KEI type of CODE_KEI;
begin
  if (:i_attr_value is null) then
  begin
    delete from operhalfattrs
    where operhalf_id = :i_operhalf_id
      and attr_code = :i_attr_code;
  end
  else
  begin
    select kei
      from operhalfattr_ref
      where attr_code = :i_attr_code
      into :v_kei;

    update or insert into operhalfattrs(operhalf_id, attr_code, kei, attr_value)
      values(:i_operhalf_id, :i_attr_code, coalesce(:i_kei, :v_kei), :i_attr_value)
      matching(operhalf_id, attr_code);
  end
end