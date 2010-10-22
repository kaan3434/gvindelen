CREATE OR ALTER PROCEDURE DET_ATTR_DETECT (
    I_OBJTYPE TYPE OF SIGN_OBJTYPE,
    I_OBJ_LABEL TYPE OF LABEL_OBJECT)
RETURNS (
    O_ATTR_CODE TYPE OF SIGN_ATTR,
    O_ATTR_VALUE TYPE OF VALUE_ATTR)
AS
declare variable V_MASK_VALUE type of MASK_VALUE;
declare C_ATTRS cursor for (
    select DETECT_DETAILATTR.ATTR_CODE, DETECT_DETAILATTR.VALUE_MASK
      from DETECT_DETAILATTR
      where :I_OBJTYPE like DETECT_DETAILATTR.OBJTYPE || '%' and
            :I_OBJ_LABEL like DETECT_DETAILATTR.LABEL_MASK
      order by OBJTYPE);
begin
  i_obj_label = trim(:i_obj_label);
  open c_attrs;
  while (1=1) do
  begin
    fetch c_attrs into :o_attr_code, :v_mask_value;

    if (row_count = 0) then leave;

    o_attr_value = recode(:i_obj_label, :v_mask_value);
    suspend;
  end
  close c_attrs;
end