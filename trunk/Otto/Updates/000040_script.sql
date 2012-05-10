update accopers ao
set ao.byr2eur = (select byr2eur from orders o where o.order_id = ao.order_id)
where ao.byr2eur is null
  and ao.order_id is not null;

update accopers ao
set ao.accoper_dtm = (select min(a.action_dtm) from actions a where a.action_sign like 'ACCOUNT%' and a.object_id = ao.account_id)
where ao.byr2eur is null;

update accopers ao
set ao.byr2eur = (select cast(o_value as integer) from setting_get('BYR2EUR', ao.accoper_dtm))
where ao.byr2eur is null;

update accopers ao
set ao.byr2eur = (select cast(o_value as integer) from setting_get('BYR2EUR', cast('2012-01-01' as date)))
where ao.byr2eur is null;

insert into accrests (account_id, byr2eur, rest_eur)
select ac.account_id, min(o.byr2eur), ac.rest_eur
from accounts ac
 inner join orders o on (o.account_id = ac.account_id)
where ac.rest_eur <> 0
group by ac.account_id, ac.rest_eur;
