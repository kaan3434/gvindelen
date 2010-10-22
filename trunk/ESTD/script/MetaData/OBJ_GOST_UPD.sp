CREATE OR ALTER PROCEDURE OBJ_GOST_UPD (
    I_OBJ_ID TYPE OF ID_OBJECT,
    I_OBJ_NAME TYPE OF NAME_OBJECT)
AS
declare variable V_GOST type of NAME_OBJECT;
declare variable V_POS integer;
begin
  select obj_gost
    from objects
    where obj_id = :i_obj_id
    into :v_gost;
  if (v_gost is null) then
  begin
    if (upper(:i_obj_name) LIKE '% ГОСТ%') then
      v_pos = strpos(' ГОСТ', :i_obj_name);
    else
    if (upper(:i_obj_name) LIKE '% СТБ%') then
      v_pos = strpos(' СТБ', :i_obj_name);
    else
    if (upper(:i_obj_name) LIKE '% PСТ%') then
      v_pos = strpos(' РСТ', :i_obj_name);
    else
    if (upper(:i_obj_name) LIKE '% СТП%') then
      v_pos = strpos(' СТП', :i_obj_name);
    if (v_pos is not null) then
    begin
      v_gost = trim(substring(:i_obj_name from v_pos));
      i_obj_name = substring(:i_obj_name from 1 for v_pos-1);
      update objects
        set obj_gost = :v_gost
          , obj_name = :i_obj_name
        where obj_id = :i_obj_id;
    end
  end
end