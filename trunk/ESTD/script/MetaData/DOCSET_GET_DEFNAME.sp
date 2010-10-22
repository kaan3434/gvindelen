CREATE OR ALTER PROCEDURE DOCSET_GET_DEFNAME (
    I_DOC_ID TYPE OF ID_OBJECT NOT NULL)
RETURNS (
    O_DOCSET_NAME TYPE OF NAME_OBJECT)
AS
declare variable V_OBJTYPE type of SIGN_OBJTYPE;
declare variable V_ALLOW_DEFAULT_DOCSET type of VALUE_BOOLEAN;
begin
  select OBJTYPE
    from objects
    where obj_id = :i_doc_id
    into :v_OBJTYPE;
  execute procedure objtype_attr_get(:v_OBJTYPE, 'ALLOW_DEFAULT_DOCSET')
    returning_values :v_allow_default_docset;
  if (v_allow_default_docset = 1) then
    execute procedure objtype_attr_get(:v_OBJTYPE, 'DEFAULT_DOCSET_NAME')
      returning_values :o_docset_name;
  else
    exception docset_name_expected;

  suspend;
end