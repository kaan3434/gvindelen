CREATE OR ALTER PROCEDURE DET_GOC (
    I_DET_LABEL TYPE OF LABEL_OBJECT NOT NULL,
    I_DET_NAME TYPE OF NAME_OBJECT)
RETURNS (
    O_DET_ID TYPE OF ID_OBJECT)
AS
begin
  select obj_id
    from objects
    where obj_label = :i_det_label
    into :o_det_id;
  if (row_count = 0) then
    execute procedure det_new(:i_det_label, :i_det_name)
      returning_values :o_det_id;
  suspend;
end