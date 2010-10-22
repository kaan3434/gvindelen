CREATE OR ALTER TRIGGER OPERS_BI0 FOR OPERS
ACTIVE BEFORE INSERT POSITION 0
AS
begin
  new.oper_id = gen_id(s_opers, 1);
end
^