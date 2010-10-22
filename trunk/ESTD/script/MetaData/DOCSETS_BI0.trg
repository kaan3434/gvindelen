CREATE OR ALTER TRIGGER DOCSETS_BI0 FOR DOCSETS
ACTIVE BEFORE INSERT POSITION 0
AS
  declare variable v_OBJTYPE sign_objtype;
  declare variable v_allow_default_docset value_boolean;
begin
  new.docset_id = gen_id(s_docsets, 1);
end
^