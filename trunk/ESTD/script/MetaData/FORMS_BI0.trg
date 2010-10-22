CREATE OR ALTER TRIGGER FORMS_BI0 FOR FORMS
ACTIVE BEFORE INSERT POSITION 0
AS
begin
  new.form_id = gen_id(s_forms, 1);
end
^