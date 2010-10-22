CREATE OR ALTER PROCEDURE EQUIP_GOC (
    I_EQUIP_LABEL TYPE OF LABEL_OBJECT,
    I_EQUIP_NAME TYPE OF NAME_OBJECT)
RETURNS (
    O_EQUIP_ID TYPE OF ID_OBJECT)
AS
begin
  select obj_id
    from objects
    where obj_label = :i_equip_label
    into :o_equip_id;
  if (row_count = 0) then
    execute procedure equip_new(:i_equip_label, :i_equip_name)
      returning_values :o_equip_id;
  else
    execute procedure obj_gost_upd(:o_equip_id, :i_equip_name);
  suspend;
end