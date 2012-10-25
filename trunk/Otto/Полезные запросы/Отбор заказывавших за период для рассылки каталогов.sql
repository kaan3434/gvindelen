select c.fio_text familymin, null familyeng,
  c.adress_text street, null streeteng,
  null home, null partobl, null obleng,
  c.place_text city_rus, null city_eng,
  c.postindex gosnum, o.kolzak, oi.cost_eur sumall,
  c.mobile_phone, c.client_id
from v_clientadress c
  inner join (select o.client_id, count(o.order_id) kolzak from orders o where o.create_dtm between '2012-02-01' and '2012-07-31' group by o.client_id) o on (o.client_id = c.client_id)
  inner join (select o.client_id, sum(oi.cost_eur) cost_eur from orderitems oi inner join orders o on (o.order_id = oi.order_id) group by o.client_id) oi on (oi.client_id = c.client_id)
where c.client_id not in (select client_id from orders o1 where o1.create_dtm < '2012-02-01')
