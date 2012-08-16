/* Server version: WI-V6.3.1.26351 Firebird 2.5 
   SQLDialect: 3. ODS: 11.2. Forced writes: On. Sweep inteval: 20000.
   Page size: 4096. Cache pages: 2048 (8192 Kb). Read-only: False. */
SET CLIENTLIB 'fbclient.dll';
SET NAMES CYRL;

SET SQL DIALECT 3;

SET AUTODDL ON;

/* Altering existing trigger... */
SET TERM ^ ;

ALTER TRIGGER ACCOPERS_BI
as
declare variable v_accrest_id id_accrest;
declare variable v_byr2eur kurs_exch;
declare variable v_rest_byr money_byr;
declare variable v_delta_byr money_byr;
declare variable v_delta_eur money_eur;
declare variable v_amount_byr money_byr;
declare variable v_amount_eur money_eur;
begin
  if (new.accoper_id is null) then
    new.accoper_id = gen_id(seq_accoper_id,1);
  new.accoper_dtm = current_timestamp;

  if (new.byr2eur is null) then
    select cast(o_value as integer)
      from setting_get('BYR2EUR', new.accoper_dtm)
      into new.byr2eur;

  if (new.amount_byr is null) then
    new.amount_byr = round(new.amount_eur * new.byr2eur, -1);
  if (new.amount_eur is null) then
    new.amount_eur = (0.00 + new.amount_byr) / new.byr2eur;

  v_amount_byr = new.amount_byr;
  v_amount_eur = new.amount_eur;
  if (v_amount_byr < 0) then
  begin
    for select ar.accrest_id, ar.rest_byr, ar.byr2eur
          from accrests ar
          where ar.account_id = new.account_id
            and ar.rest_byr <> 0
          order by ar.accrest_id desc
          into :v_accrest_id, :v_rest_byr, :v_byr2eur do
    begin
      if (abs(v_amount_byr) < abs(v_rest_byr)) then
        v_delta_byr = v_amount_byr;
      else
        v_delta_byr = v_rest_byr;
      v_amount_byr = v_amount_byr + v_delta_byr;
      v_delta_eur = (0.00 + v_delta_byr) / v_byr2eur;
      v_amount_eur = v_amount_eur + v_delta_eur;
      update accrests ar
        set ar.rest_byr = ar.rest_byr - :v_delta_byr,
            ar.rest_eur = ar.rest_eur - :v_delta_eur
        where ar.accrest_id = :v_accrest_id
        returning accrest_id
        into new.accrest_id;

    end
  end

  v_byr2eur = coalesce(:v_byr2eur, new.byr2eur);
  select ar.accrest_id
    from accrests ar
    where ar.account_id = new.account_id
      and ar.byr2eur = :v_byr2eur
    into :v_accrest_id;

  if (:v_accrest_id is null) then
    insert into accrests (account_id, byr2eur, rest_eur, rest_byr)
      values(new.account_id, :v_byr2eur, new.amount_eur, new.amount_byr)
      returning accrest_id
      into new.accrest_id;
  else
  if (:v_amount_byr <> 0) then
    update accrests ar
      set ar.rest_byr = ar.rest_byr + new.amount_byr,
          ar.rest_eur = ar.rest_eur + new.amount_eur
      where ar.accrest_id = :v_accrest_id
      returning accrest_id
      into new.accrest_id;
end
^

SET TERM ; ^

