CREATE OR ALTER PROCEDURE DOCSET_ADD_DET (
    I_DOCSET_ID TYPE OF ID_DOCSET,
    I_DET_ID TYPE OF ID_OBJECT)
AS
begin
  update or insert into detinset(docset_id, detail_id)
    values(:i_docset_id, :i_det_id)
    matching(docset_id, detail_id);
end