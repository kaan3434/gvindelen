CREATE OR ALTER PROCEDURE OPERHALF_SET_11 (
    I_OPER_ID TYPE OF ID_OPER,
    I_HALF_ID TYPE OF ID_OBJECT,
    I_KEI TYPE OF CODE_KEI,
    I_EN TYPE OF VALUE_INTEGER,
    I_KI TYPE OF VALUE_INTEGER)
RETURNS (
    O_OPERHALF_ID TYPE OF ID_OPEROBJ)
AS
begin

  select master_kei from kei_okp where kei = :i_kei into :i_kei;

  execute procedure operhalf_set(:i_oper_id, :i_half_id)
    returning_values :o_operhalf_id;

  -- количество изделий на сборку "ЕВ", "КИ"
  execute procedure operhalf_attr_set(:o_operhalf_id, 'COUNT', :i_ki, :i_kei);
  -- единица нормирования "ЕН"
  execute procedure operhalf_attr_set(:o_operhalf_id, 'UNITS_RATE', :i_en, null);

  suspend;
end