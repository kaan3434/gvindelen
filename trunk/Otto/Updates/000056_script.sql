update orderitems oi
set oi.name_rus = (select attr_value from v_orderitem_attrs where object_id = oi.orderitem_id and attr_sign = 'NAME_RUS');

update orderitems oi
set oi.kind_rus = (select attr_value from v_orderitem_attrs where object_id = oi.orderitem_id and attr_sign = 'KIND_RUS');

update orderitems oi
set oi.weight = (select attr_value from v_orderitem_attrs where object_id = oi.orderitem_id and attr_sign = 'WEIGHT');

delete from orderitem_attrs oia
where oia.attr_id in (select a.attr_id from attrs a where a.object_sign = 'ORDERITEM' and a.attr_sign in ('NAME_RUS', 'KIND_RUS', 'WEIGHT'));

execute ibeblock
as
declare variable v_order_id id_order;
begin
  for select o.order_id from orders o into :v_order_id do
  begin
    execute procedure order_updatecost (:v_order_id);
  end
  update orders o
    set o.cost_byr = (select o_money_byr from money_eur2byr(o.cost_eur, o.byr2eur));

end;

commit;

