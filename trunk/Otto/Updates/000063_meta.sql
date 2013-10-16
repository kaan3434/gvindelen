/* Server version: WI-V6.3.1.26351 Firebird 2.5 
   SQLDialect: 3. ODS: 11.2. Forced writes: On. Sweep inteval: 20000.
   Page size: 4096. Cache pages: 2048 (8192 Kb). Read-only: False. */
SET CLIENTLIB 'fbclient.dll';
SET NAMES CYRL;

SET SQL DIALECT 3;

SET AUTODDL ON;

/* Create Table... */
CREATE TABLE PACKLISTS(PACKLIST_NO VALUE_INTEGER NOT NULL,
PACKLIST_CODE VALUE_INTEGER);



ALTER TABLE PRODUCTS ADD PAYTYPE_SIGN SIGN_OBJECT;

ALTER TABLE PRODUCTS ADD MANUAL_BAR_CODE_ABLE CODE_ACTION;

ALTER TABLE PRODUCTS ADD PARTNER_NUMBER SIGN_OBJECT;

/* Create Procedure... */
SET TERM ^ ;

CREATE PROCEDURE ACT_ORDER_DELETE(I_PARAM_ID TYPE OF ID_PARAM,
I_OBJECT_ID TYPE OF ID_OBJECT,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ORDER')
 AS
 BEGIN EXIT; END
^

CREATE PROCEDURE ADRESS_READ(I_OBJECT_ID TYPE OF ID_OBJECT)
 RETURNS(O_PARAM_NAME TYPE OF SIGN_OBJECT,
O_PARAM_VALUE TYPE OF VALUE_ATTR)
 AS
 BEGIN SUSPEND; END
^

CREATE PROCEDURE PACKLIST_UPSERT(I_PACKLIST_NO TYPE OF VALUE_INTEGER NOT NULL,
I_PACKLIST_CODE TYPE OF VALUE_INTEGER NOT NULL)
 AS
 BEGIN EXIT; END
^


/* Create Primary Key... */
SET TERM ; ^

ALTER TABLE PACKLISTS ADD CONSTRAINT PK_PACKLISTS PRIMARY KEY (PACKLIST_NO);

/*  Empty BARCODE_REGEN for BARCODE_GEN(param list change)  */
SET TERM ^ ;

ALTER PROCEDURE BARCODE_REGEN(I_PRODUCT_ID /* TYPE OF ID_PRODUCT */ INTEGER,
I_PACKLIST_NO /* TYPE OF VALUE_INTEGER */ INTEGER,
I_PACKLIST_NUM /* TYPE OF VALUE_INTEGER */ INTEGER,
I_PACKET_NO /* TYPE OF VALUE_ATTR */ VARCHAR(4000))
 AS
 BEGIN EXIT; END
^

/* Alter empty procedure BARCODE_GEN with new param-list */
ALTER PROCEDURE BARCODE_GEN(I_ORDER_ID TYPE OF ID_ORDER NOT NULL)
 RETURNS(O_BARCODE TYPE OF SIGN_OBJECT)
 AS
 BEGIN SUSPEND; END
^

/* Alter Procedure... */
/* Alter (BARCODE_GEN) */
ALTER PROCEDURE BARCODE_GEN(I_ORDER_ID TYPE OF ID_ORDER NOT NULL)
 RETURNS(O_BARCODE TYPE OF SIGN_OBJECT)
 AS
declare variable V_PREFIX type of VALUE_SHORT;
declare variable V_ORDER_CODE type of CODE_ORDER;
declare variable V_CN integer;
begin
  /* Procedure Text */
  select substring(pa2.attr_value from 8 for 1)||
         lpad(coalesce(pl.packlist_code, '0'), 2, '0')||
         substring(o.order_code from 2), pa1.attr_value
    from orders o
      left join packlists pl on (pl.packlist_no = o.packlist_no)
      inner join v_product_attrs pa1 on (pa1.object_id = o.product_id
                                     and pa1.attr_sign = 'BARCODE_SIGN')
      inner join v_product_attrs pa2 on (pa2.object_id = o.product_id
                                     and pa2.attr_sign = 'PARTNER_NUMBER')
    where o.order_id = :i_order_id
    into :o_barcode, :v_prefix;

  v_cn = 11 - mod(8*cast(substring(o_barcode from 1 for 1) as smallint) +
                  6*cast(substring(o_barcode from 2 for 1) as smallint) +
                  4*cast(substring(o_barcode from 3 for 1) as smallint) +
                  2*cast(substring(o_barcode from 4 for 1) as smallint) +
                  3*cast(substring(o_barcode from 5 for 1) as smallint) +
                  5*cast(substring(o_barcode from 6 for 1) as smallint) +
                  9*cast(substring(o_barcode from 7 for 1) as smallint) +
                  7*cast(substring(o_barcode from 8 for 1) as smallint), 11);
  if (v_cn = 10) then
    v_cn = 0;
  else if (v_cn = 11) then
    v_cn = 5;
  else
    v_cn = substring(v_cn from 1 for 1);

  o_barcode = v_prefix||o_barcode||v_cn||'LT';
  suspend;
end
^

/* Alter (BARCODE_REGEN) */
ALTER PROCEDURE BARCODE_REGEN(I_PRODUCT_ID TYPE OF ID_PRODUCT,
I_PACKLIST_NO TYPE OF VALUE_INTEGER,
I_PACKLIST_NUM TYPE OF VALUE_INTEGER,
I_PACKET_NO TYPE OF VALUE_ATTR)
 AS
declare variable V_ORDER_ID type of ID_ORDER;
declare variable V_BARCODE type of SIGN_OBJECT;
begin
for select o.order_id
        from orders o
          inner join v_order_attrs oa on (oa.object_id = o.order_id and oa.attr_sign = 'PALETTE_NO')
        where o.product_id = :i_product_id
          and o.packlist_no = :i_packlist_no
          and oa.attr_value = :i_packet_no
        into :v_order_id do
  begin
    select o_barcode from barcode_gen(:v_order_id, :i_packlist_num) into :v_barcode;
    update orderitems oi
      set oi.status_id = 185
      where oi.status_id = 186
        and oi.order_id = :v_order_id;
    update orders o
      set o.status_id = 210,
          o.bar_code = :v_barcode
      where o.order_id = :v_order_id
        and o.status_id = 211
        ;
  end
end
^

/* Restore proc. body: ACT_ORDER_DELETE */
ALTER PROCEDURE ACT_ORDER_DELETE(I_PARAM_ID TYPE OF ID_PARAM,
I_OBJECT_ID TYPE OF ID_OBJECT,
I_OBJECT_SIGN TYPE OF SIGN_OBJECT = 'ORDER')
 AS
declare variable V_PARAM_ID type of ID_PARAM;
declare variable V_ACTION_SIGN type of SIGN_ACTION;
declare variable V_OBJECT_ID type of ID_OBJECT;
declare variable V_NEW_STATUS_SIGN type of SIGN_ATTR;
declare variable V_ACTION_ID type of ID_ACTION;
declare variable V_ACTIONTREEITEM_ID type of ID_ACTIONTREEITEM;
declare variable V_NEW_FLAG_SIGN type of SIGN_OBJECT;
begin
  select o_value from param_get(:i_param_id, 'NEW.STATUS_SIGN') into :v_new_status_sign;
  select o_value from param_get(:v_param_id, 'NEW.FLAG_SIGN') into :v_new_flag_sign;
  select o_value from param_get(:i_param_id, 'ACTIONTREEITEM_ID') into :v_actiontreeitem_id;

  for select oi.orderitem_id
        from orderitems oi
        where oi.order_id = :i_object_id
        into :v_object_id do
  begin
    select o_param_id from param_create(:i_object_sign, :v_object_id) into :v_param_id;
    insert into params(param_id, param_name, param_value)
      select :v_param_id, p.param_name, p.param_value
        from params p
          inner join actiontree_params atp on (atp.param_name = p.param_name)
        where p.param_id = :i_param_id
          and atp.actiontreeitem_id = :v_actiontreeitem_id;

    select o_action_sign from action_detect(:i_object_sign, :v_object_id, :v_new_status_sign, :v_new_flag_sign, 0)
      into :v_action_sign;

    if (:v_action_sign is null) then
      select o_value from param_get(:i_param_id, 'ACTION_SIGN') into :v_action_sign;

    if (v_action_sign is not null) then
      execute procedure action_run(:i_object_sign, :v_action_sign, :v_param_id, :v_object_id)
        returning_values :v_action_id;
  end
end
^

/* Restore proc. body: ADRESS_READ */
ALTER PROCEDURE ADRESS_READ(I_OBJECT_ID TYPE OF ID_OBJECT)
 RETURNS(O_PARAM_NAME TYPE OF SIGN_OBJECT,
O_PARAM_VALUE TYPE OF VALUE_ATTR)
 AS
begin
  select st.streettype_sign
    from adresses a
      inner join streettypes st on (st.streettype_code=a.streettype_code)
    where a.adress_id = :i_object_id
    into :o_param_value;

  o_param_name = 'STREETTYPE_SIGN';
  suspend;

end
^

/* Restore proc. body: PACKLIST_UPSERT */
ALTER PROCEDURE PACKLIST_UPSERT(I_PACKLIST_NO TYPE OF VALUE_INTEGER NOT NULL,
I_PACKLIST_CODE TYPE OF VALUE_INTEGER NOT NULL)
 AS
begin
  update or insert into packlists (packlist_no, packlist_code)
    values (:i_packlist_no, :i_packlist_code)
    matching (packlist_no);
end
^

/* Alter Procedure... */
SET TERM ; ^

ALTER TABLE PRODUCTS ALTER COLUMN PRODUCT_ID POSITION 1;

ALTER TABLE PRODUCTS ALTER COLUMN PRODUCT_NAME POSITION 2;

ALTER TABLE PRODUCTS ALTER COLUMN PRODUCT_CODE POSITION 3;

ALTER TABLE PRODUCTS ALTER COLUMN VENDOR_ID POSITION 4;

ALTER TABLE PRODUCTS ALTER COLUMN STATUS_ID POSITION 5;

ALTER TABLE PRODUCTS ALTER COLUMN STATUS_DTM POSITION 6;

ALTER TABLE PRODUCTS ALTER COLUMN PAYTYPE_SIGN POSITION 7;

ALTER TABLE PRODUCTS ALTER COLUMN MANUAL_BAR_CODE_ABLE POSITION 8;

ALTER TABLE PRODUCTS ALTER COLUMN PARTNER_NUMBER POSITION 9;

/* Create(Add) privilege */
GRANT ALL ON PACKLISTS TO SYSDBA WITH GRANT OPTION;

GRANT ALL ON USERS TO YULYA;


