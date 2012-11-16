/* Server version: WI-V6.3.1.26351 Firebird 2.5 
   SQLDialect: 3. ODS: 11.2. Forced writes: On. Sweep inteval: 20000.
   Page size: 4096. Cache pages: 2048 (8192 Kb). Read-only: False. */
SET CLIENTLIB 'fbclient.dll';
SET NAMES CYRL;

SET SQL DIALECT 3;

SET AUTODDL ON;

/* Create Procedure... */
SET TERM ^ ;

CREATE PROCEDURE ACCOUNT_MERGE(I_FROM_ACCOUNT_ID TYPE OF ID_ACCOUNT NOT NULL,
I_TO_ACCOUNT_ID TYPE OF ID_ACCOUNT NOT NULL)
 AS
 BEGIN EXIT; END
^

CREATE PROCEDURE CLIENT_MERGE(I_FROM_CLIENT_ID TYPE OF ID_CLIENT NOT NULL,
I_TO_CLIENT_ID TYPE OF ID_CLIENT NOT NULL)
 AS
 BEGIN EXIT; END
^


/* Alter Procedure... */
/* Restore proc. body: ACCOUNT_MERGE */
ALTER PROCEDURE ACCOUNT_MERGE(I_FROM_ACCOUNT_ID TYPE OF ID_ACCOUNT NOT NULL,
I_TO_ACCOUNT_ID TYPE OF ID_ACCOUNT NOT NULL)
 AS
begin
  update accopers ao
    set ao.account_id = :i_to_account_id
    where ao.account_id = :i_from_account_id;

  update clients c
    set c.account_id = :i_to_account_id
    where c.account_id = :i_from_account_id;

  update moneybacks mb
    set mb.account_id = :i_to_account_id
    where mb.account_id = :i_from_account_id;

  update ordermoneys om
    set om.account_id = :i_to_account_id
    where om.account_id = :i_from_account_id;

  update orders o
    set o.account_id = :i_to_account_id
    where o.account_id = :i_from_account_id;

  update accrests ar
    set ar.account_id = :i_to_account_id
    where ar.account_id = :i_from_account_id
      and ar.byr2eur not in (select a.byr2eur from accrests a where a.account_id = :i_to_account_id);

  merge into accrests ar
  using (select a.account_id, a.byr2eur, coalesce(sum(a.amount_eur), 0) rest_eur
           from accopers a
           where a.account_id = :i_to_account_id
           group by  a.account_id, a.byr2eur) ao
  on (ar.account_id = ao.account_id and ar.byr2eur = ao.byr2eur)
  when matched then
    update set ar.rest_eur = ao.rest_eur
  when not matched then
    insert (account_id, byr2eur, rest_eur)
    values (ao.account_id, ao.byr2eur, ao.rest_eur);

  delete from accounts a
    where a.account_id = :i_from_account_id;

end
^

/* Restore proc. body: CLIENT_MERGE */
ALTER PROCEDURE CLIENT_MERGE(I_FROM_CLIENT_ID TYPE OF ID_CLIENT NOT NULL,
I_TO_CLIENT_ID TYPE OF ID_CLIENT NOT NULL)
 AS
declare variable V_FROM_ACCOUNT_ID type of ID_ACCOUNT;
declare variable V_TO_ACCOUNT_ID type of ID_ACCOUNT;
begin
  update orders o
    set o.client_id = :i_to_client_id
    where o.client_id = :i_from_client_id;

  update adresses a
    set a.client_id = :i_to_client_id
    where a.client_id = :i_from_client_id;

  update bonuses b
    set b.client_id = :i_to_client_id
    where b.client_id = :i_from_client_id;

  select c.account_id
    from clients c
    where c.client_id = :i_from_client_id
    into :v_from_account_id;

  select c.account_id
    from clients c
    where c.client_id = :i_to_client_id
    into :v_to_account_id;

  execute procedure account_merge(:v_from_account_id, :v_to_account_id);

  delete from clients c
    where c.client_id = :i_from_client_id;

end
^

/* Alter Procedure... */
SET TERM ; ^

