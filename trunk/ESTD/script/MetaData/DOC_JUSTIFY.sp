CREATE OR ALTER PROCEDURE DOC_JUSTIFY (
    I_DOCUMENT_ID TYPE OF ID_OBJECT)
AS
declare variable V_FORM_ID type of ID_FORM;
declare variable V_FORM_FREE type of NUM_POSITION;
declare variable V_FORM_LEN type of NUM_POSITION;
declare variable V_LINE_ID type of ID_LINE;
declare variable V_BLOCK_ID type of ID_BLOCK;
declare variable V_GROUP_ID type of ID_LINE;
declare variable V_BAND_ID type of ID_BAND;
begin
  for select f.form_id, f.form_size-f.page_len, f.page_len
        from forms f
        where f.document_id = :i_document_id
          and f.page_len < f.form_size
        order by f.page_no
        into :v_form_id, :v_form_free, :v_form_len do
  begin
    select first 1 l.line_id, l.block_id, l.group_id
      from lines l
      where l.form_id = :v_form_id
      order by l.doc_rowno desc
      into :v_line_id, :v_block_id, :v_group_id;

    execute procedure band_00_gen(:v_block_id, '00', :v_form_free, :v_form_id)
      returning_values :v_band_id;

    for select l.line_id
          from lines l
          where l.band_id = :v_band_id
          order by l.doc_rowno
          into :v_line_id do
    begin
      v_form_len= v_form_len + 1;
      update lines l
        set l.form_id = :v_form_id,
            l.line_no = :v_form_len,
            l.group_id = :v_group_id,
            l.is_tilespaces = 1
        where l.line_id = :v_line_id;
    end
    update forms f
      set f.page_len = (select count(l.line_id) from lines l where l.form_id = :v_form_id)
      where f.form_id = :v_form_id;
  end

end