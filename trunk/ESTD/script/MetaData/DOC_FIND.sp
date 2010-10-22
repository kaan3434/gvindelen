CREATE OR ALTER PROCEDURE DOC_FIND (
    I_DOC_NAME TYPE OF NAME_OBJECT)
RETURNS (
    O_OBJ_ID TYPE OF ID_OBJECT)
AS
begin
  select obj_id
    from objects
    where obj_label = :i_doc_name
    into o_obj_id;
  suspend;
end