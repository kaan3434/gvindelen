CREATE OR ALTER PROCEDURE DET_PART_EXTRACT (
    I_OBJTYPE TYPE OF SIGN_OBJTYPE,
    I_OBJ_LABEL TYPE OF LABEL_OBJECT)
RETURNS (
    O_MAIN_PART TYPE OF LABEL_OBJECT,
    O_MAJOR_VERSION TYPE OF LABEL_OBJECT,
    O_MINOR_VERSION TYPE OF LABEL_OBJECT,
    O_MAJOR_VERSION_RANGE_START TYPE OF VALUE_INTEGER,
    O_MAJOR_VERSION_RANGE_END TYPE OF VALUE_INTEGER)
AS
declare variable V_ATTR_CODE type of SIGN_ATTR;
declare variable V_ATTR_VALUE type of VALUE_ATTR;
begin
  for select o_attr_code, o_attr_value
        from det_attr_detect(:i_OBJTYPE, :i_obj_label)
        into :v_attr_code, :v_attr_value do
  begin
    if (:v_attr_code = 'MAIN_PART') then
      o_main_part = v_attr_value;
    else
    if (:v_attr_code = 'MAJOR_VERSION') then
      o_major_version = v_attr_value;
    else
    if (:v_attr_code = 'MINOR_VERSION') then
      o_minor_version = v_attr_value;
    else
    if (:v_attr_code = 'MAJOR_VERSION_RANGE_START') then
      o_major_version_range_start = v_attr_value;
    else
    if (:v_attr_code = 'MAJOR_VERSION_RANGE_END') then
      o_major_version_range_end = v_attr_value;
  end
  /* Procedure Text */
  if (o_major_version_range_start is null) then
    o_major_version_range_start = o_major_version;
  if (o_major_version_range_end is null) then
    o_major_version_range_end = o_major_version;
  suspend;
end