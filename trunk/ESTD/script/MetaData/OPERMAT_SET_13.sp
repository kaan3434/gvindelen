CREATE OR ALTER PROCEDURE OPERMAT_SET_13 (
    I_OPER_ID TYPE OF NUM_POSITION,
    I_MAT_ID TYPE OF ID_OBJECT,
    I_OPP TYPE OF VALUE_INTEGER,
    I_KEI TYPE OF CODE_KEI,
    I_EN TYPE OF VALUE_INTEGER,
    I_NORMRASH TYPE OF VALUE_DECIMAL)
RETURNS (
    O_OPERMAT_ID TYPE OF ID_OPEROBJ)
AS
begin
  select master_kei from kei_okp where kei = :i_kei into :i_kei;
  execute procedure opermat_set(:i_oper_id, :i_mat_id)
    returning_values :o_opermat_id;

  -- норма расхода материала "ЕВ", "Н.расх"
  execute procedure opermat_attr_set(:o_opermat_id, 'CONSUMPTION_RATE', :i_normrash, :i_kei);
  -- единица нормирования "ЕН"
  execute procedure opermat_attr_set(:o_opermat_id, 'UNITS_RATE', :i_en, null);
  -- склад-источник или назначение "ОПП"
  execute procedure opermat_attr_set(:o_opermat_id, 'STORAGE', :i_opp, null);

  suspend;
end