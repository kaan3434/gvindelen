CREATE OR ALTER PROCEDURE DOC_RENDER (
    I_DOCFORM TYPE OF SIGN_DOCFORM NOT NULL,
    I_DOCUMENT_ID TYPE OF ID_OBJECT NOT NULL)
AS
declare variable V_FORM_ID type of ID_FORM;
declare variable V_FORM_FREE type of NUM_POSITION;
declare variable V_FORM_LEN type of NUM_POSITION;
declare variable V_GROUP_SIZE type of NUM_POSITION;
declare variable V_GROUP_ID type of ID_LINE;
declare variable V_DOC_ROWNO type of NUM_POSITION;
begin

  delete from forms f
    where f.document_id = :i_document_id;

  update lines l
    set l.line_no = null, 
        l.form_id = null
    where l.document_id = :i_document_id;

  execute procedure form_new(:i_docform, :i_document_id)
    returning_values :v_form_id;

  for select l.group_id, count(l.line_id), min(l.doc_rowno)
        from lines l
        where l.document_id = :i_document_id
          and l.is_tilespaces = 0
        group by l.group_id
        into :v_group_id, :v_group_size, :v_doc_rowno do
  begin

    select f.form_size - f.page_len
      from forms f
      where f.form_id = :v_form_id
      into :v_form_free;

    if (v_form_free < v_group_size) then
      execute procedure form_new(:i_docform, :i_document_id)
        returning_values :v_form_id;

    select f.page_len
      from forms f
      where f.form_id = :v_form_id
      into :v_form_len;

    update lines l
      set l.line_no = :v_form_len + l.doc_rowno - :v_doc_rowno+1,
          l.form_id = :v_form_id
      where l.group_id = :v_group_id;

    update forms f
      set f.page_len = (select count(l.line_id) from lines l where l.form_id = :v_form_id)
      where f.form_id = :v_form_id;

  end
end