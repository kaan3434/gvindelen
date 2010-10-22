CREATE OR ALTER PROCEDURE OPERDET_SET (
    I_OPER_ID TYPE OF ID_OPER NOT NULL,
    I_DET_ID TYPE OF ID_OBJECT NOT NULL)
RETURNS (
    O_OPERDET_ID TYPE OF ID_OPEROBJ)
AS
BEGIN
  update or insert into operdets (oper_id, detail_id)
    values(:i_oper_id, :i_det_id)
    matching (oper_id, detail_id)
    returning operdet_id
    into :o_operdet_id;
  suspend;
END