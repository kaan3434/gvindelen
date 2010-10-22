CREATE OR ALTER TRIGGER ORGUNITS_BIU0 FOR ORGUNITS
ACTIVE BEFORE INSERT OR UPDATE POSITION 0
AS
begin
  new.orgunit_sign = new.orgunit_code;
  if (new.parent_id is not null) then
    select ou.orgunit_sign||'.'||new.orgunit_sign
      from orgunits ou
      where ou.orgunit_id = new.parent_id
      into new.orgunit_sign;
end
^