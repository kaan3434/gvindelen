CREATE OR ALTER PROCEDURE PARAM_SET (
    I_PARAM_NAME TYPE OF SIGN_ATTR NOT NULL,
    I_PARAM_VALUE TYPE OF VALUE_ATTR)
AS
begin
  update or insert into tmp_params (param_name, param_value)
    values(upper(:i_param_name), cast(:i_param_value as value_attr))
    matching (param_name);
end