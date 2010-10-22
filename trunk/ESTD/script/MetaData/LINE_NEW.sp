CREATE OR ALTER PROCEDURE LINE_NEW (
    I_BLOCK_ID TYPE OF ID_BLOCK NOT NULL,
    I_BAND_ID TYPE OF ID_BAND NOT NULL,
    I_FORM_ID TYPE OF ID_FORM = null)
RETURNS (
    O_LINE_ID TYPE OF ID_LINE)
AS
declare variable V_DOCUMENT_ID type of ID_OBJECT;
declare variable V_DOC_ROWNO type of NUM_POSITION;
declare variable V_BLOCK_ID type of ID_BLOCK;
declare variable V_BLOCK_ROWNO type of NUM_POSITION;
declare variable V_BAND_ID type of ID_BAND;
declare variable V_BAND_ROWNO type of NUM_POSITION;
begin
  select bl.document_id
    from blocks bl
    where bl.block_id = :i_block_id
    into :v_document_id;

  if (:i_form_id is null) then
    select first 1 l.doc_rowno, l.block_id, l.block_rowno, l.band_id, l.band_rowno
      from lines l
      where l.document_id = :v_document_id
      order by line_id desc
      into :v_doc_rowno, :v_block_id,  :v_block_rowno, :v_band_id,  :v_band_rowno;
  else
    select first 1 l.doc_rowno, l.block_id, l.block_rowno, l.band_id, l.band_rowno
      from lines l
      where l.form_id = :i_form_id
      order by line_id desc
      into :v_doc_rowno, :v_block_id,  :v_block_rowno, :v_band_id,  :v_band_rowno;

  if (v_doc_rowno is null) then
  begin
    v_doc_rowno = 0;
    v_block_rowno = 0;
    v_band_rowno = 0;
  end
  else
  if (v_block_id <> i_block_id) then
  begin
    v_block_rowno = 0;
    v_band_rowno = 0;
  end
  else
  if (v_band_id <> i_band_id) then
    v_band_rowno = 0;

--  if (:i_form_id is not null) then
    update lines l
      set l.doc_rowno = l.doc_rowno + 1
      where l.document_id = :v_document_id
        and l.doc_rowno > :v_doc_rowno;

  o_line_id = gen_id(s_lines, 1);
  insert into lines (line_id, document_id, doc_rowno,
    block_id, block_rowno, band_id, band_rowno)
    values(:o_line_id, :v_document_id, :v_doc_rowno+1,
    :i_block_id, :v_block_rowno+1, :i_band_id, :v_band_rowno+1);
  suspend;
end