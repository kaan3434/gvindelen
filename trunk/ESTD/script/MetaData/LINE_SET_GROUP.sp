CREATE OR ALTER PROCEDURE LINE_SET_GROUP (
    I_DOCUMENT_ID TYPE OF ID_OBJECT)
AS
declare variable V_LINE_ID type of ID_LINE;
declare variable V_BAND_ID type of ID_BAND;
declare variable V_BAND_SIZE type of NUM_POSITION;
declare variable V_BAND_ROWNO type of NUM_POSITION;
declare variable V_BAND_SIGN type of SIGN_BAND;
declare variable V_BLOCK_ID type of ID_BLOCK;
declare variable V_DOC_ROWNO type of NUM_POSITION;
declare variable V_BLOCK_ROWNO type of NUM_POSITION;
declare variable V_PARENT_BLOCK_ID type of ID_BLOCK;
declare variable V_GROUP_ID type of ID_LINE;
declare variable V_BLOCK_SIZE type of NUM_POSITION;
declare variable V_PREV_GROUP_ID type of ID_LINE;
declare variable V_IS_TILESPACES type of VALUE_BOOLEAN;
begin
  update lines l
    set l.group_id = null,
        l.is_tilespaces = null
    where l.document_id = :i_document_id;

  for select l.line_id, l.band_id, l.band_rowno, b.band_sign, l.block_id, l.block_rowno, l.doc_rowno
        from lines l
          inner join bands b on (b.band_id = l.band_id)
        where l.document_id = :i_document_id
        order by l.doc_rowno
        into :v_line_id, :v_band_id, :v_band_rowno, :v_band_sign, :v_block_id, :v_block_rowno, :v_doc_rowno do
  begin
      select count(l.line_id)
        from lines l
        where l.band_id = :v_band_id
        into :v_band_size;
    
      select count(l.line_id)
        from lines l
          inner join bands b on (b.band_id = l.band_id)
        where l.block_id = :v_block_id
          and b.band_sign <> '00'
        into :v_block_size;
    
      select parent_id
        from blocks b
        where b.block_id = :v_block_id
        into :v_parent_block_id;
    
      if ((:v_block_rowno = 1) and (:v_parent_block_id is not null)) then
      begin
        select l.group_id
          from lines l
          where l.line_id = (select max(l2.line_id)
                               from lines l2
                               where l2.doc_rowno < :v_doc_rowno)
          into :v_group_id;
      end
      else
      if ((:v_band_rowno = 1) and (:v_band_sign='00')) then
      begin
        select l.group_id
          from lines l
          where l.line_id = (select max(l2.line_id)
                               from lines l2
                               where l2.doc_rowno < :v_doc_rowno)
          into :v_group_id;
      end
      else
      if ((:v_block_rowno = 2) or
          ((:v_block_rowno = :v_block_size) and (:v_block_rowno > 1)) or
          (:v_band_rowno = 2) or
          ((:v_band_rowno = :v_band_size) and (:v_band_rowno > 1)) or
          (:v_band_sign = '00'))  then
        select l.group_id
          from lines l
          where l.band_id = :v_band_id
            and l.band_rowno = :v_band_rowno - 1
          into :v_group_id;
      else
        v_group_id = v_line_id;
    
      update lines l
        set l.group_id = :v_group_id
        where l.line_id = :v_line_id;
  end
  
  v_prev_group_id = -1;
  
  for select l.line_id, l.group_id, b.band_sign
        from lines l
          inner join bands b on (b.band_id = l.band_id)
        where l.document_id = :i_document_id
        order by l.doc_rowno desc
        into :v_line_id, :v_group_id, :v_band_sign do
  begin
    v_is_tilespaces = 0;
    if (v_prev_group_id <> :v_group_id) then
      if (v_band_sign = '00') then
        v_is_tilespaces = 1;
      else
        v_prev_group_id = :v_group_id;
    update lines l
      set l.is_tilespaces = :v_is_tilespaces
      where l.line_id = :v_line_id;
  end
end