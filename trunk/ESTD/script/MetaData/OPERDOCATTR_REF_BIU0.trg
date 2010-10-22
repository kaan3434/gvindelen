CREATE OR ALTER TRIGGER OPERDOCATTR_REF_BIU0 FOR OPERDOCATTR_REF
ACTIVE BEFORE INSERT OR UPDATE POSITION 0
AS
begin
  select master_kei from kei_okp where kei = new.kei into new.kei;
end
^