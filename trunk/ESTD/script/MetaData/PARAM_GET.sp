CREATE OR ALTER PROCEDURE PARAM_GET (
    I_PARAM_NAME TYPE OF SIGN_ATTR)
RETURNS (
    O_PARAM_VALUE TYPE OF VALUE_ATTR)
AS
begin
  select param_value
    from tmp_params
    where param_name = upper(:i_param_name)
    into :o_param_value;
  suspend;
end