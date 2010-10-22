CREATE OR ALTER PROCEDURE ORGUNIT_GET (
    I_SHOP_SIGN TYPE OF SIGN_ORGUNIT NOT NULL,
    I_AREA_SIGN TYPE OF SIGN_ORGUNIT,
    I_WORKPLACE_SIGN TYPE OF SIGN_ORGUNIT)
RETURNS (
    O_ORGUNIT_ID TYPE OF ID_ORGUNIT)
AS
begin
  if (i_shop_sign is not null) then
  begin
    select orgunit_id
      from orgunits
      where orgunit_type_code = '1'
        and orgunit_code = :i_shop_sign
      into :o_orgunit_id;

    if (row_count = 0) then
      exception shop_orgunit_not_found(:i_shop_sign);
    else if (i_area_sign is not null) then
    begin
      select orgunit_id
        from orgunits
        where orgunit_type_code = '2'
          and parent_id = :o_orgunit_id
          and orgunit_code = :i_area_sign
        into :o_orgunit_id;
      if (row_count = 0) then
        exception area_orgunit_not_fount(:i_area_sign);
      else if (:i_workplace_sign is not null) then
      begin
        select orgunit_id
          from orgunits
          where orgunit_type_code = '3'
            and parent_id = :o_orgunit_id
            and orgunit_code = :i_area_sign
          into :o_orgunit_id;
        if (row_count = 0) then
          exception workplace_orgunit_not_found(:i_workplace_sign);
      end
    end
  end
  suspend;
end