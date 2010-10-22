CREATE OR ALTER TRIGGER BAND_13_BI0 FOR BAND_13
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
    new.opp = null;
    new.kei = null;
    new.en = null;
    new.normrash = null;
    new.mat_label = null;
  end
end
^