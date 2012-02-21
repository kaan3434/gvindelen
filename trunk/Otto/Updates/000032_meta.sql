/* Server version: WI-V6.3.1.26351 Firebird 2.5 
   SQLDialect: 3. ODS: 11.2. Forced writes: On. Sweep inteval: 20000.
   Page size: 4096. Cache pages: 2048 (8192 Kb). Read-only: False. */
SET CLIENTLIB 'fbclient.dll';
SET NAMES CYRL;

SET SQL DIALECT 3;

SET AUTODDL ON;

/* Altering existing trigger... */
SET TERM ^ ;

ALTER TRIGGER ORDERS_BU0
AS
begin
  if (old.status_id <> new.status_id) then
    new.status_dtm = current_timestamp;
  if ((new.adress_id is null) and (new.client_id is not null)) then
  begin
    select a.adress_id
      from adresses a
      where a.client_id = new.client_id
      into new.adress_id;
  end
end
^

/* Create(Add) Crant */
SET TERM ; ^

GRANT USERS TO ELENA;

GRANT USERS TO NASTYA;

GRANT USERS TO NASTYA17;

GRANT USERS TO NATVL;

GRANT USERS TO ND;

GRANT USERS TO YULYA;


