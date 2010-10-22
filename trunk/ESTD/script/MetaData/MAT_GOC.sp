CREATE OR ALTER PROCEDURE MAT_GOC (
    I_MAT_LABEL TYPE OF LABEL_OBJECT,
    I_MAT_NAME TYPE OF NAME_OBJECT,
    I_KEI TYPE OF CODE_KEI)
RETURNS (
    O_MAT_ID TYPE OF ID_OBJECT)
AS
begin
  select obj_id
    from objects
    where obj_label = :i_mat_label
    into :o_mat_id;
  if (row_count = 0) then
    execute procedure mat_new(:i_mat_label, :i_mat_name, :i_kei)
      returning_values :o_mat_id;
  else
    execute procedure obj_gost_upd(:o_mat_id, :i_mat_name);
  suspend;
end