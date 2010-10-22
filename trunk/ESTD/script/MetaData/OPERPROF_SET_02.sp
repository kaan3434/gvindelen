CREATE OR ALTER PROCEDURE OPERPROF_SET_02 (
    I_OPER_ID TYPE OF ID_OPER NOT NULL,
    I_PROF_ID TYPE OF ID_OBJECT NOT NULL,
    I_SM TYPE OF VALUE_DECIMAL = null,
    I_R TYPE OF VALUE_INTEGER = null,
    I_UT TYPE OF VALUE_INTEGER = null,
    I_KR TYPE OF VALUE_INTEGER = null,
    I_KOID TYPE OF VALUE_INTEGER = null,
    I_EN TYPE OF VALUE_INTEGER = null,
    I_OP TYPE OF VALUE_INTEGER = null,
    I_KSHT TYPE OF VALUE_DECIMAL = null,
    I_TPZ TYPE OF VALUE_DECIMAL = null,
    I_TSHT TYPE OF VALUE_DECIMAL = null)
RETURNS (
    O_OPERPROF_ID TYPE OF ID_OPEROBJ)
AS
begin
  execute procedure operprof_set(:i_oper_id, :i_prof_id)
    returning_values :o_operprof_id;

  -- разряд
  execute procedure operprof_attr_set(:o_operprof_id, 'CATEGORY', :i_r);
  -- единица нормирования "ЕН"
  execute procedure operprof_attr_set(:o_operprof_id, 'UNITS_RATE', :i_en);
  -- количесвто одновременно изготавливаемых деталей
  execute procedure operprof_attr_set(:o_operprof_id, 'KOID', :i_koid);
  -- количесвто работников
  execute procedure operprof_attr_set(:o_operprof_id, 'WORKER_COUNT', :i_kr);
  -- коэффициент штучности
  execute procedure operprof_attr_set(:o_operprof_id, 'KSHT', :i_ksht);
  -- Подготовительно-заключительно время
  execute procedure operprof_attr_set(:o_operprof_id, 'TPZ', :i_tpz);
  -- штучное время
  execute procedure operprof_attr_set(:o_operprof_id, 'TSHT', :i_tsht);
  -- объем партии
  execute procedure operprof_attr_set(:o_operprof_id, 'PARTION_SIZE', :i_op);
  -- код условий труда
  execute procedure operprof_attr_set(:o_operprof_id, 'WORK_CONDITION', :i_ut);
  -- степень механизации
  execute procedure operprof_attr_set(:o_operprof_id, 'MECH_DEGREE', :i_sm);
  suspend;
end