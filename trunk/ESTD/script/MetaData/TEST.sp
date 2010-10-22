CREATE OR ALTER PROCEDURE TEST
AS
declare variable V_DOCUMENT_ID type of ID_OBJECT;
declare variable V_VALUE type of VALUE_ATTR;
begin
  v_document_id = 18;
  execute statement 'select o_attr_value from operprof_attr_get(1, ''KOID'')'
    into :v_value;
end