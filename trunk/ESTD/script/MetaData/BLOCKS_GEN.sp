CREATE OR ALTER PROCEDURE BLOCKS_GEN (
    I_DOCFORM TYPE OF SIGN_DOCFORM NOT NULL,
    I_DOCUMENT_ID TYPE OF ID_OBJECT NOT NULL,
    I_PARENT_BLOCK TYPE OF SIGN_BLOCK NOT NULL)
AS
declare variable V_BLOCK_SIGN type of SIGN_BLOCK;
begin
  for select bt.block_sign
        from block_tree bt
        where bt.docform = :i_docform
          and bt.parent_block = trim(:i_parent_block)
          and bt.block_sign <> bt.parent_block
        order by bt.block_order
        into :v_block_sign do
  begin
    if (:v_block_sign = '01') then
    begin
      execute procedure block_01_gen(trim(:i_docform), :i_document_id, :v_block_sign);
    end
    else
    if (:v_block_sign = '02') then
    begin
      execute procedure block_02_gen(trim(:i_docform), :i_document_id, :v_block_sign);
    end
    else
    if (:v_block_sign = '15') then
    begin
      execute procedure block_15_gen(trim(:i_docform), :i_document_id, :v_block_sign);
    end
    else
    if (:v_block_sign = '19') then
    begin
      execute procedure block_19_gen(trim(:i_docform), :i_document_id, :v_block_sign);
    end
    else
    if (:v_block_sign = '18') then
    begin
      execute procedure block_18_gen(trim(:i_docform), :i_document_id, :v_block_sign);
    end
    else
    if (:v_block_sign = '25') then
    begin
      execute procedure block_25_gen(trim(:i_docform), :i_document_id, :v_block_sign);
    end
    else
    if (:v_block_sign = '11') then
    begin
      execute procedure block_11_gen(trim(:i_docform), :i_document_id, :v_block_sign);
    end
    else
    if (:v_block_sign = '11_11') then
    begin
      execute procedure block_11_11_gen(trim(:i_docform), :i_document_id, :v_block_sign);
    end
    else
    if (:v_block_sign = '11_34') then
    begin
      execute procedure block_11_34_gen(trim(:i_docform), :i_document_id, :v_block_sign);
    end
    else
    if (:v_block_sign = '13') then
    begin
      execute procedure block_13_gen(trim(:i_docform), :i_document_id, :v_block_sign);
    end
    else
      exception unknown_block(:v_block_sign);

--      execute statement 'execute procedure block_'||:v_block_code||'_gen '||
--        :i_docform||', '||:i_document_id||','||:v_block_code||','||:v_block_id;
  end
end