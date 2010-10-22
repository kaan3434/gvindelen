CREATE OR ALTER PROCEDURE OPERDOC_SET (
    I_OPER_ID TYPE OF ID_OPER NOT NULL,
    I_DOC_ID TYPE OF ID_OBJECT NOT NULL)
RETURNS (
    O_OPERDOC_ID TYPE OF ID_OPEROBJ)
AS
BEGIN
  update or insert into operdocs (oper_id, document_id)
    values(:i_oper_id, :i_doc_id)
    matching (oper_id, document_id)
    returning operdoc_id
    into :o_operdoc_id;
  suspend;
END