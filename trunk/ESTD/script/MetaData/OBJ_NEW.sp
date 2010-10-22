CREATE OR ALTER PROCEDURE OBJ_NEW (
    I_OBJ_LABEL TYPE OF LABEL_OBJECT,
    I_OBJTYPE TYPE OF SIGN_OBJTYPE,
    I_OBJ_CODE TYPE OF SIGN_OBJECT,
    I_OBJ_NAME TYPE OF NAME_OBJECT,
    I_KEI TYPE OF CODE_KEI)
RETURNS (
    O_OBJ_ID TYPE OF ID_OBJECT)
AS
begin
  select master_kei from kei_okp where kei = :i_kei into :i_kei;
  insert into objects (OBJTYPE, obj_label, obj_code, obj_name, kei)
    values (:i_OBJTYPE, :i_obj_label, :i_obj_code, :i_obj_name, :i_kei)
    returning obj_id
    into :o_obj_id;
  execute procedure obj_gost_upd(:o_obj_id, :i_obj_name);
  suspend;
end