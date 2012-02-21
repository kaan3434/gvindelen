update orders o
set o.adress_id = (select a.adress_id from adresses a where a.client_id = o.client_id)
where o.adress_id is null and o.client_id is not null;