CREATE OR ALTER PROCEDURE XML_CREATE_NODE (
    I_PARENT_NODE TYPE OF ID_ELEM,
    I_ELEM_NAME TYPE OF NAME_ELEM NOT NULL,
    I_ELEM_VALUE TYPE OF VALUE_ATTR)
AS
begin
  update or insert into xml_elements(
    parent_id, elemtype_code, elem_name, elem_value)
    values(:i_parent_node, 'N', :i_elem_name, :i_elem_value)
    matching(parent_id, elemtype_code, elem_name, elem_value);
end