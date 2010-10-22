CREATE OR ALTER TRIGGER BAND_02_BI0 FOR BAND_02
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
    new.kr = null;
    new.prof_code = null;
  end
end
^