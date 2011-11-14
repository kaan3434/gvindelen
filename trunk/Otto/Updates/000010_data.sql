SET SQL DIALECT 3;

SET NAMES WIN1251;

update orders o
set o.status_id = 203
where o.status_id = 205
  and o.client_id in (2,3,4,7,13);

update orderitems oi
set oi.status_id = 174
where oi.order_id in (select o.order_id from orders o
  where o.client_id in (2,3,4,7,13))
  and oi.status_id in (180, 184);

delete from orderitems oi
where oi.orderitem_id = 33;

delete from accopers ao
where ao.accoper_id = 26;

update accopers ao
set ao.rest_eur = ao.rest_eur + 119.99,
  ao.balance_eur = ao.balance_eur + 119.99
where ao.accoper_id > 26
  and ao.account_id = 5
