CREATE OR ALTER PROCEDURE OPERDET_SET_11 (
    I_OPER_ID TYPE OF ID_OPER,
    I_DET_ID TYPE OF ID_OBJECT,
    I_DET_NOTE TYPE OF VALUE_ATTR,
    I_OPP TYPE OF VALUE_INTEGER,
    I_KEI TYPE OF CODE_KEI,
    I_EN TYPE OF VALUE_INTEGER,
    I_KI TYPE OF VALUE_INTEGER)
RETURNS (
    O_OPERDET_ID TYPE OF ID_OPEROBJ)
AS
begin

  select master_kei from kei_okp where kei = :i_kei into :i_kei;

  execute procedure operdet_set(:i_oper_id, :i_det_id)
    returning_values :o_operdet_id;

  -- количество изделий на сборку "ЕВ", "КИ"
  execute procedure operdet_attr_set(:o_operdet_id, 'COUNT', :i_ki, :i_kei);
  -- единица нормирования "ЕН"
  execute procedure operdet_attr_set(:o_operdet_id, 'UNITS_RATE', :i_en, null);
  -- склад-источник илиназначение "ОПП"
  execute procedure operdet_attr_set(:o_operdet_id, 'STORAGE', :i_opp, null);

  suspend;
end