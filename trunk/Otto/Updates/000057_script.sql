update orders o
set o.packlist_no = (select attr_value from v_order_attrs where object_id = o.order_id and attr_sign = 'PACKLIST_NO');

update orders o
set o.weight = (select attr_value from v_order_attrs where object_id = o.order_id and attr_sign = 'WEIGHT');


