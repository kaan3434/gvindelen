CREATE OR ALTER PROCEDURE XML_CREATE_ELEM (
    I_PARENT_NODE TYPE OF ID_ELEM,
    I_ELEM_NAME TYPE OF VALUE_ATTR NOT NULL,
    I_ELEM_VALUE TYPE OF VALUE_ATTR)
RETURNS (
    O_ELEM_ID TYPE OF ID_ELEM,
    O_IS_NEW TYPE OF VALUE_BOOLEAN)
AS
declare variable V_ELEMTYPE type of SIGN_ELEMTYPE;
declare variable V_ELEM_NAME type of VALUE_ATTR;
declare variable V_ELEM_VALUE type of VALUE_ATTR;
declare variable V_POS integer;
declare variable V_ELEM_INDEX integer;
begin
  v_pos = 0;
  while (trim(:i_elem_name) <> '') do
  begin
    execute procedure splitstring(trim(:i_elem_name), '/')
      returning_values :v_elem_name, :i_elem_name;
    o_is_new = 0;
    if (substring(:v_elem_name from 1 for 1) = '@') then
    begin
      v_elemtype = 'A';
      v_elem_name = substring(:v_elem_name from 2);
    end
    else
      v_elemtype = 'N';
    v_elem_value = nullif(copy_start_end(:v_elem_name, '[', ']', :v_pos), '');
    v_elem_name = copyfront_withoutkey(:v_elem_name, '[');
    if (:v_elem_value is not null) then
    begin
      v_elem_value = nullif(copy_between(:v_elem_value,  '[', ']', :v_pos), '');
      -- в конец списка NodeName[]
      if (:v_elem_value is null) then
        o_is_new = 1;
      else
      -- поиск по  значению NodeName["Value"]
      if (substring(v_elem_value from 1 for 1) = '"') then
      begin
        v_elem_value = nullif(copy_between(:v_elem_value, '"', '"', :v_pos), '');
        select elem_id
          from xml_elements
          where parent_id = :i_parent_node
            and elemtype_code = :v_elemtype
            and upper(elem_name) = upper(:v_elem_name)
            and coalesce(elem_value, ' ') = coalesce(:v_elem_value, ' ')
          into :o_elem_id;
        if (row_count = 0) then
          o_is_new = 1;
      end
      else
      -- поиск по индексу, если индекс больше кол-ва, то аналогично []
      begin
        v_elem_index = v_elem_value;
        select elem_id
          from xml_elements
          where parent_id = :i_parent_node
            and upper(elem_name) = upper(:v_elem_name)
            and elemtype_code = :v_elemtype
          rows :v_elem_index-1 to :v_elem_index
          into :o_elem_id;
        if (row_count = 0) then
        begin
          o_is_new = 1;
          v_elem_value = null;
        end
      end
    end
    else
    begin
      -- первый  попавшийся
      v_elem_value = null;
      select first 1 elem_id
        from xml_elements
        where parent_id = :i_parent_node
          and upper(elem_name) = upper(:v_elem_name)
          and elemtype_code = :v_elemtype
        into :o_elem_id;
      if (row_count = 0) then
        o_is_new = 1;
    end
    if (o_is_new = 1) then
      insert into xml_elements(parent_id, elemtype_code, elem_name, elem_value)
        values(:i_parent_node, :v_elemtype, :v_elem_name, :v_elem_value)
        returning elem_id
        into :o_elem_id;
    i_parent_node = o_elem_id;
  end
  if (:i_elem_value is not null) then
    update xml_elements
      set elem_value = :i_elem_value
      where elem_id = :o_elem_id;
  suspend;
end