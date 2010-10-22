CREATE OR ALTER PROCEDURE OPERMAT_SET (
    I_OPER_ID TYPE OF ID_OPER NOT NULL,
    I_MAT_ID TYPE OF ID_OBJECT NOT NULL)
RETURNS (
    O_OPERMAT_ID TYPE OF ID_OPEROBJ)
AS
BEGIN
  update or insert into opermats (oper_id, material_id)
    values(:i_oper_id, :i_mat_id)
    matching (oper_id, material_id)
    returning opermat_id
    into :o_opermat_id;
  suspend;
END