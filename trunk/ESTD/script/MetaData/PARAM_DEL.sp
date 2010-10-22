CREATE OR ALTER PROCEDURE PARAM_DEL (
    I_PARAM_NAME TYPE OF SIGN_ATTR)
AS
begin
  delete from tmp_params tp
    where tp.param_name = upper(:i_param_name);
end