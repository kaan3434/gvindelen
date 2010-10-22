CREATE OR ALTER PROCEDURE OPERMAT_ATTR_SET (
    I_OPERMAT_ID TYPE OF ID_OPEROBJ,
    I_ATTR_CODE TYPE OF SIGN_ATTR,
    I_ATTR_VALUE TYPE OF VALUE_ATTR,
    I_KEI TYPE OF CODE_KEI)
AS
declare variable V_KEI type of CODE_KEI;
declare variable V_OBJ_ID type of ID_OBJECT;
begin
  if (:i_attr_value is null) then
  begin
    delete from opermatattrs
    where opermat_id = :i_opermat_id
      and attr_code = :i_attr_code;
  end
  else
  begin
    select kei
      from opermatattr_ref
      where attr_code = :i_attr_code
      into :v_kei;

    if (:v_kei = 0) then
      select o.kei, o.obj_id
        from opermats om
          inner join objects o on (om.material_id = o.obj_id)
        where opermat_id = :i_opermat_id
        into :v_kei, :v_obj_id;

    if (:i_kei is not null) then
    begin
      select master_kei from kei_okp where kei = :i_kei into :i_kei;
      execute procedure kei_convertibility(:v_kei, :i_kei, :v_obj_id);
    end

    update or insert into opermatattrs(opermat_id, attr_code, kei, attr_value)
      values(:i_opermat_id, :i_attr_code, coalesce(:i_kei, :v_kei), :i_attr_value)
      matching(opermat_id, attr_code);
  end
end