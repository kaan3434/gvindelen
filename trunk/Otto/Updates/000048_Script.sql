delete from orders o where o.client_id is null;

delete from accrests aar
where aar.account_id in (
select ao.account_id
from (select ao.account_id, ao.byr2eur, sum(ao.amount_eur) amount_eur, sum(ao.amount_byr) amount_byr
from accopers ao
group by ao.account_id, ao.byr2eur
having sum(ao.amount_eur) = 0) ao
inner join accrests ar on (ar.account_id = ao.account_id and ar.byr2eur = ao.byr2eur)
where ao.amount_byr = 0 and ar.rest_byr <> 0
);

delete from accrests aar
where aar.account_id in (
select ao.account_id
from (select ao.account_id, ao.byr2eur, sum(ao.amount_eur) amount_eur, sum(ao.amount_byr) amount_byr
from accopers ao
group by ao.account_id, ao.byr2eur
having sum(ao.amount_eur) = 0) ao
inner join accrests ar on (ar.account_id = ao.account_id and ar.byr2eur = ao.byr2eur)
where ao.amount_eur = 0 and ar.rest_byr <> 0
);

delete from accrests ar
where ar.account_id in
(select ao.account_id
from accopers ao
group by ao.account_id, ao.byr2eur
having sum(ao.amount_eur) = 0);

delete from accrests
where accrests.account_id in (
select ar.account_id
from accrests ar
group by ar.account_id
having sum(ar.rest_eur) = 0
);

