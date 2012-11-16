SET SQL DIALECT 3;

SET NAMES WIN1251;

SET CLIENTLIB 'fbclient.dll';


INSERT INTO ACTIONCODES (ACTION_SIGN, ACTION_NAME, OBJECT_SIGN, PROCEDURE_NAME)
  VALUES ('ACCOUNT_REST2ORDER', 'Перенос остатка на заявку', 'ACCOUNT', 'ACCOUNT_CREDITORDER');


update accrests ar
  set ar.rest_eur = 0, ar.rest_byr = 0;

merge into accrests ar
  using (select ao.account_id,  ao.byr2eur, sum(ao.amount_eur) rest_eur
           from accopers ao
--           where account_id = :v_account_id
           group by ao.account_id,  ao.byr2eur) p
      on p.account_id = ar.account_id and p.byr2eur = ar.byr2eur
    when matched then
      update set ar.rest_eur = p.rest_eur
    when not matched then
      insert (account_id, byr2eur, rest_eur)
      values (p.account_id, p.byr2eur, p.rest_eur);

 update accounts a
   set a.rest_eur = (select coalesce(sum(ar.rest_eur), 0) from accrests ar where ar.account_id = a.account_id);
