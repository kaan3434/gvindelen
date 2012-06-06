create or alter procedure DB_CLEANUP
as
declare variable V_CNT integer;
begin
  delete from paramheads ph
  where ph.param_id < gen_id(seq_param_id, 0) - 10000;
  select count(*) from paramheads into :v_cnt;
  select count(*) from params into :v_cnt;

  delete from actions a
  where a.action_dtm < current_date - 100
    and a.action_id < gen_id(seq_action_id, 0) - 10000;
  select count(*) from actions into :v_cnt;

  delete from messages m
  where m.message_dtm < current_date - 100;
  delete from messages m
  where m.template_id = 9
    and m.message_dtm < current_date - 7;
  select count(*) from messages into :v_cnt;

  delete from notifies n
  where n.notify_dtm < current_date - 100
    and n.notify_id < gen_id(seq_notify_id, 0) - 10000;
  select count(*) from notifies into :v_cnt;


  delete from Logs l
  where l.log_id < gen_id(seq_log_id, 0) - 10000;
  select count(*) from logs into :v_cnt;
end
