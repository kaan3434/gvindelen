CREATE OR ALTER PROCEDURE ORGUNIT_DECODE (
    I_ORGUNIT_ID TYPE OF ID_ORGUNIT)
RETURNS (
    O_AREA_CODE TYPE OF SIGN_ORGUNIT,
    O_SHOP_CODE TYPE OF SIGN_ORGUNIT,
    O_WORKPLACE_CODE TYPE OF SIGN_ORGUNIT)
AS
declare variable V_ORGUNIT_SIGN type of SIGN_ORGUNIT;
declare variable V_ORGUNIT_CODE type of CODE_ORGUNIT;
begin
  select orgunit_sign
    from orgunits
    where orgunit_id = :i_orgunit_id
    into :v_orgunit_sign;
  -- get client code
  execute procedure splitstring(:v_orgunit_sign, '.')
    returning_values :v_orgunit_code, :v_orgunit_sign;
  -- get shop code
  if (:v_orgunit_sign is not null) then
    execute procedure splitstring(:v_orgunit_sign, '.')
      returning_values :o_shop_code, :v_orgunit_sign;
  if (:v_orgunit_sign is not null) then
    execute procedure splitstring(:v_orgunit_sign, '.')
      returning_values :o_area_code, :v_orgunit_sign;
  if (:v_orgunit_sign is not null) then
    execute procedure splitstring(:v_orgunit_sign, '.')
      returning_values :o_workplace_code, :v_orgunit_sign;
  /* Procedure Text */
  suspend;
end