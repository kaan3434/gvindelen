CREATE OR ALTER TRIGGER DOCOPERS_BI0 FOR DOCOPERS
ACTIVE BEFORE INSERT POSITION 0
AS
begin
  new.docoper_id = gen_id(s_docopers, 1);
end
^