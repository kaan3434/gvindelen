CREATE OR ALTER PROCEDURE PARAM_INC (
    I_PARAM_NAME TYPE OF SIGN_ATTR NOT NULL,
    I_STEP TYPE OF NUM_POSITION = 1)
AS
begin
  update tmp_params tp
    set tp.param_value = cast(cast(coalesce(tp.param_value, 0) as num_position)+:i_step as value_attr)
    where tp.param_name = upper(:i_param_name);
end