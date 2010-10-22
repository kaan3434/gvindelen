CREATE OR ALTER PROCEDURE DET_LABELS_EXPLODE (
    I_DET_LABELS TYPE OF VALUE_ATTR)
RETURNS (
    O_DET_LABEL TYPE OF LABEL_OBJECT)
AS
declare variable V_DET_LABEL type of LABEL_OBJECT;
declare variable V_MAIN_PART type of LABEL_OBJECT;
declare variable V_MAJOR_VERSION type of LABEL_OBJECT;
declare variable V_MINOR_VERSION type of LABEL_OBJECT;
declare variable V_OBJTYPE type of SIGN_OBJTYPE;
declare variable V_OBJ_CODE type of CODE_OBJECT;
declare variable V_MJV_RANGE_START type of VALUE_INTEGER;
declare variable V_MJV_RANGE_END type of VALUE_INTEGER;
declare variable V_MJV_LEN type of VALUE_INTEGER;
declare variable V_PREV_OBJTYPE type of SIGN_OBJTYPE;
declare variable V_START_DET_LABEL type of LABEL_OBJECT;
declare variable V_START_MAIN_PART type of LABEL_OBJECT;
declare variable V_START_MAJOR_VERSION type of LABEL_OBJECT;
declare variable V_START_MINOR_VERSION type of LABEL_OBJECT;
begin
  for select trim(o_string) from explode(:i_det_labels, ';') into :v_det_label do
  begin
    -- try detect object type
    execute procedure objtype_detect(:v_det_label)
      returning_values :v_OBJTYPE, :v_obj_code;

    if (v_OBJTYPE is null) then
    begin
      execute procedure det_part_extract(:v_prev_OBJTYPE, :v_start_det_label||';'||:v_det_label)
        returning_values :v_main_part, :v_major_version, :v_minor_version,
                         :v_mjv_range_start, :v_mjv_range_end;
      v_OBJTYPE = v_prev_OBJTYPE;
    end
    else
    begin
      execute procedure det_part_extract(:v_OBJTYPE, :v_det_label)
        returning_values :v_start_main_part, :v_start_major_version, :v_start_minor_version,
                         :v_mjv_range_start, :v_mjv_range_end;
      v_prev_OBJTYPE = v_OBJTYPE;
      if (cast(v_start_minor_version as integer) <> 0) then
        v_start_det_label = v_start_main_part||'.'||v_start_major_version||'.'||v_start_minor_version;
      else
      if (cast(v_start_major_version as integer) <> 0) then
        v_start_det_label = v_start_main_part||'.'||v_start_major_version;
      else
        v_start_det_label = v_start_main_part;
    end

    if (v_OBJTYPE is null) then
      exception unknown_objecttype(:v_det_label);

    v_mjv_len = strlen(:v_start_major_version);
    -- если есть диапазон, но генерируем детали в диапазоне
    while (:v_mjv_range_start <= :v_mjv_range_end) do
    begin
      if (cast(v_start_minor_version as integer) <> 0) then
        o_det_label = v_start_main_part||'.'||lpad(v_mjv_range_start, :v_mjv_len, '0')||'.'||v_start_minor_version;
      else
      if (v_mjv_range_start <> 0) then
        o_det_label = v_start_main_part||'.'||lpad(v_mjv_range_start, :v_mjv_len, '0');
      else
        o_det_label = v_start_main_part;
      suspend;
      v_mjv_range_start = v_mjv_range_start + 1;
    end
  end
end