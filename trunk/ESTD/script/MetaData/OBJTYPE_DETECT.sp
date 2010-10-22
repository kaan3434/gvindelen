CREATE OR ALTER PROCEDURE OBJTYPE_DETECT (
    I_OBJECT_LABEL TYPE OF LABEL_OBJECT)
RETURNS (
    O_OBJTYPE TYPE OF SIGN_OBJTYPE,
    O_OBJ_CODE TYPE OF SIGN_OBJECT)
AS
declare variable V_CODE_MASK varchar(100);
begin
  i_object_label = trim(:i_object_label);
  select first 1 OBJTYPE, code_mask
    from detect_objectcode
    where :i_object_label like label_mask
    order by mask_level desc
    into :o_OBJTYPE, :v_code_mask;

  if (row_count <> 0) then
    o_obj_code = nullif(recode(:i_object_label, :v_code_mask), '');

  suspend;
end