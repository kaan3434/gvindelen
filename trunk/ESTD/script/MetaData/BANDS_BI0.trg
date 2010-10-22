CREATE OR ALTER TRIGGER BANDS_BI0 FOR BANDS
ACTIVE BEFORE INSERT POSITION 0
AS
begin
  new.band_id = gen_id(s_bands, 1);
end
^