CREATE OR ALTER TRIGGER BAND_25_BI0 FOR BAND_25
ACTIVE BEFORE INSERT POSITION 0
AS
declare variable v_band_rowno num_position;
begin
  select l.band_rowno
    from lines l
    where l.line_id = new.line_id
    into :v_band_rowno;
  if (:v_band_rowno > 1) then
  begin
    new.shop_code = null;
    new.area_code = null;
    new.workplace_code = null;
    new.oper_num = null;
  end
end
^