CREATE OR ALTER TRIGGER DETECT_OBJECTCODE_BIU0 FOR DETECT_OBJECTCODE
ACTIVE BEFORE INSERT OR UPDATE POSITION 0
AS
begin
  new.mask_level= charcount(new.label_mask, '_');
end
^