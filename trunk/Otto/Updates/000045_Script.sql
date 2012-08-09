update orderitems oi
set oi.auftrag_id = (select oia.attr_value from v_orderitem_attrs oia where oia.object_id = oi.orderitem_id and oia.attr_sign='AUFTRAG_ID')
where oi.auftrag_id is null;

delete from orderitem_attrs oia
where oia.attr_id = (select a.attr_id from attrs a where a.object_sign = 'ORDERITEM' and a.attr_sign='AUFTRAG_ID');