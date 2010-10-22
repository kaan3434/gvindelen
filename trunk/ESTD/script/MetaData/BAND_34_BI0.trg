CREATE OR ALTER TRIGGER BAND_34_BI0 FOR BAND_34
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
    new.half_label = null;
    new.opp = null;
    new.kei = null;
    new.en = null;
    new.ki = null;
  end
end
^