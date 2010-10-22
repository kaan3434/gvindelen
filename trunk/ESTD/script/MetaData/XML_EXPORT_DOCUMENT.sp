CREATE OR ALTER PROCEDURE XML_EXPORT_DOCUMENT (
    I_DOCUMENT_LABELS TYPE OF VALUE_ATTR NOT NULL)
RETURNS (
    ND_ROOT TYPE OF ID_ELEM,
    XML_BLOB BLOB SUB_TYPE 1 SEGMENT SIZE 32000 CHARACTER SET UTF8)
AS
declare variable ND_DOCUMENT type of ID_ELEM;
declare variable V_DOCUMENT_LABEL type of LABEL_OBJECT;
declare variable V_IS_NEW type of VALUE_BOOLEAN;
declare variable V_DOCUMENT_ID type of ID_OBJECT;
begin
  delete from xml_elements where 1=1;
  execute procedure xml_create_elem
    null, 'Root', null
    returning_values :nd_root, :v_is_new;
  execute procedure xml_create_attribute(:nd_root, 'Version', 0.1);

  -- экспортируем DocSet
  for select trim(o_String) from explode(:i_document_labels, ';') into :v_document_label do
  begin
    execute procedure doc_get(:v_document_label)
      returning_values :v_document_id;
    execute procedure xml_exp_doc(:nd_root, :v_document_id)
      returning_values :v_document_label;
    execute procedure xml_create_elem
      :nd_root, 'DocumentList/Document[]', :v_document_label
      returning_values :nd_document, :v_is_new;
    if (v_is_new = 1) then
      execute procedure xml_exp_docopers(:nd_root, :nd_document, :v_document_id);
  end

  execute procedure xml_write_to_blob(:nd_root)
    returning_values :xml_blob;
  xml_blob = '<?xml version="1.0" encoding="UTF-8"?>'||ascii_char(13)||ascii_char(10)||xml_blob;
  suspend;

--  delete from xml_elements
--    where elem_id = :nd_root;
end