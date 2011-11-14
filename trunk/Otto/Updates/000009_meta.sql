/* Server version: WI-V6.3.1.26351 Firebird 2.5 
SET CLIENTLIB 'fbclient.dll';
   SQLDialect: 3. ODS: 11.2. Forced writes: On. Sweep inteval: 20000.
   Page size: 4096. Cache pages: 2048 (8192 Kb). Read-only: False. */
SET NAMES CYRL;

SET SQL DIALECT 3;

SET AUTODDL ON;

/* Alter exist trigger... */
SET TERM ^ ;

ALTER TRIGGER ORDERITEMS_BI0
AS
begin
  new.article_code = upper(new.article_code);
  if (new.orderitem_id is null) then
    new.orderitem_id = gen_id(seq_orderitem_id, 1);
  if (new.status_id is null) then
    select o_status_id from status_get_default('ORDERITEM') into new.status_id;
  new.status_dtm = current_timestamp;

  if (exists (select f2s.flag_sign
                from flags2statuses f2s
                where f2s.status_id = new.status_id
                  and f2s.flag_sign in ('CREDIT', 'DEBIT'))) then
    new.amount = 1;
  else
    new.amount = 0;
end
^

/* Alter exist trigger... */
ALTER TRIGGER ORDERITEMS_BU0
AS
declare variable v_flaglist list_signs;
begin
  new.article_code = upper(new.article_code);
  if (old.status_id <> new.status_id) then
  begin
    new.status_dtm = current_timestamp;
    select s.flag_sign_list
      from statuses s
      where s.status_id = new.status_id
      into :v_flaglist;
    if (v_flaglist like '%,CREDIT,%') then
      new.amount = 1;
    else
    if (v_flaglist like '%,DEBIT,%') then
      new.amount = 0;
  end
end
^

SET TERM ; ^

INSERT INTO BUILDS (BUILD) VALUES (9);
