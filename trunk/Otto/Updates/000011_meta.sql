/* Server version: WI-V6.3.0.26074 Firebird 2.5 
   SQLDialect: 3. ODS: 11.2. Forced writes: On. Sweep inteval: 20000.
   Page size: 4096. Cache pages: 2048 (8192 Kb). Read-only: False. */
SET NAMES CYRL;

SET SQL DIALECT 3;

SET AUTODDL ON;

/* Create Foreign Key... */

ALTER TABLE ADRESSES ADD CONSTRAINT FK_ADRESSES_PLACE FOREIGN KEY (PLACE_ID) REFERENCES PLACES (PLACE_ID) ON UPDATE CASCADE;

