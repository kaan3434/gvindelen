CREATE OR ALTER PROCEDURE XML_WRITE_TO_BLOB (
    ND_ROOT TYPE OF ID_ELEM NOT NULL,
    I_LEVEL TYPE OF VALUE_INTEGER = 0)
RETURNS (
    O_XML_BLOB BLOB SUB_TYPE 1 SEGMENT SIZE 32000 CHARACTER SET UTF8)
AS
declare variable V_ELEM_ID type of ID_ELEM;
declare variable V_ELEMTYPE type of SIGN_ELEMTYPE;
declare variable V_ELEM_NAME type of NAME_ATTR;
declare variable V_ELEM_VALUE type of VALUE_ATTR;
declare variable V_BLOB blob sub_type 1 segment size 32000;
declare variable V_ATTR_VALUE type of VALUE_ATTR;
declare variable V_ATTR_NAME type of NAME_ATTR;
declare variable CRLF varchar(10) character set ASCII;
declare variable SPACES type of VALUE_ATTR;
declare variable I integer;
begin
  crlf = ascii_char(13)||ascii_char(10);
  i = 1;
  spaces = '';
  while (i<= i_level) do
  begin
    i = i+1;
    spaces = spaces||'  ';
  end
  select e.elem_id, e.elemtype_code, e.elem_name, nullif(escapestring(e.elem_value), '')
    from xml_elements e
    where e.elem_id = :nd_root
    into :v_elem_id, :v_elemtype, :v_elem_name, :v_elem_value;
  o_xml_blob = spaces||'<'||trim(:v_elem_name);
  -- пишем атрибуты
  for select ' '||e.elem_name||'="'||e.elem_value||'"'
    from xml_elements e
    where e.parent_id = :nd_root
      and e.elemtype_code = 'A'
    into :v_attr_value do
    o_xml_blob = o_xml_blob||:v_attr_value;
  -- находим хоть одного ребенка
  select first 1 e.elem_id
    from xml_elements e
    where e.parent_id = :nd_root
      and e.elemtype_code = 'N'
    into :v_elem_id;
  -- нет детей
  if (row_count = 0) then
    if (:v_elem_value is null) then
      o_xml_blob = o_xml_blob||'/>'||crlf;
    else
      o_xml_blob = o_xml_blob||'>'||:v_elem_value||'</'||:v_elem_name||'>'||crlf;
  else
  begin
    o_xml_blob = o_xml_blob||'>'||trim(coalesce(:v_elem_value, ''))||crlf;
    for select e.elem_id
      from xml_elements e
      where e.parent_id = :nd_root
        and e.elemtype_code = 'N'
      into :v_elem_id do
    begin
      execute procedure xml_write_to_blob
        :v_elem_id, :i_level+1
        returning_values :v_blob;
      o_xml_blob = o_xml_blob||v_blob;
    end
    o_xml_blob = o_xml_blob||spaces||'</'||:v_elem_name||'>'||crlf;
  end
  suspend;
end