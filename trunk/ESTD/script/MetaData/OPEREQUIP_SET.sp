CREATE OR ALTER PROCEDURE OPEREQUIP_SET (
    I_OPER_ID TYPE OF ID_OPER,
    I_EQUIP_ID TYPE OF ID_OBJECT)
RETURNS (
    O_OPEREQUIP_ID TYPE OF ID_OPEROBJ)
AS
BEGIN
  update or insert into operequips (oper_id, equip_id)
    values(:i_oper_id, :i_equip_id)
    matching (oper_id, equip_id)
    returning operequip_id
    into :o_operequip_id;

  suspend;
END