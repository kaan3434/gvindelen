CREATE OR ALTER PROCEDURE KEI_CONVERTIBILITY (
    I_KEI1 TYPE OF CODE_KEI,
    I_KEI2 TYPE OF CODE_KEI,
    I_OBJ_ID TYPE OF ID_OBJECT)
AS
declare variable V_KOEF integer;
begin
  if (i_kei1 = i_kei2) then exit;
  select koef
    from kei_converts
    where okei1 = :i_kei1
      and okei2 = :i_kei2
    into :v_koef;

  if (:v_koef is not null) then exit;

  if (:i_obj_id is null) then exit;
  exception unconvertible_kei;
end