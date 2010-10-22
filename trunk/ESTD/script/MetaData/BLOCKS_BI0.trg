CREATE OR ALTER TRIGGER BLOCKS_BI0 FOR BLOCKS
ACTIVE BEFORE INSERT POSITION 0
AS
begin
  new.block_id = gen_id(s_blocks, 1);
end
^