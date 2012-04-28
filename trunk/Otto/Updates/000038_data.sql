SET SQL DIALECT 3;

SET NAMES WIN1251;

SET CLIENTLIB 'fbclient.dll';


INSERT INTO ATTRS (ATTR_ID, OBJECT_SIGN, ATTR_SIGN, ATTR_NAME, FIELD_NAME, DIRECTION)
  VALUES (739, 'ORDER', 'LAST_NAME', 'Фамилия клиента', NULL, NULL);

INSERT INTO ATTRS (ATTR_ID, OBJECT_SIGN, ATTR_SIGN, ATTR_NAME, FIELD_NAME, DIRECTION)
  VALUES (740, 'ORDER', 'INVOICE_DT_6', 'Дата выставления оплаты', NULL, NULL);

INSERT INTO ATTRS (ATTR_ID, OBJECT_SIGN, ATTR_SIGN, ATTR_NAME, FIELD_NAME, DIRECTION)
  VALUES (741, 'ORDER', 'INVOICE_BYR_6', 'Сумма выставленной оплаты в BYR', NULL, NULL);

INSERT INTO ATTRS (ATTR_ID, OBJECT_SIGN, ATTR_SIGN, ATTR_NAME, FIELD_NAME, DIRECTION)
  VALUES (742, 'ORDER', 'INVOICE_EUR_6', 'Сумма выставленной оплаты в EUR', NULL, NULL);

INSERT INTO ATTRS (ATTR_ID, OBJECT_SIGN, ATTR_SIGN, ATTR_NAME, FIELD_NAME, DIRECTION)
  VALUES (743, 'ORDER', 'INVOICE_DT_0', 'Дата выставления оплаты', NULL, NULL);

INSERT INTO ATTRS (ATTR_ID, OBJECT_SIGN, ATTR_SIGN, ATTR_NAME, FIELD_NAME, DIRECTION)
  VALUES (744, 'ORDER', 'INVOICE_BYR_0', 'Сумма выставленной оплаты в BYR', NULL, NULL);

INSERT INTO ATTRS (ATTR_ID, OBJECT_SIGN, ATTR_SIGN, ATTR_NAME, FIELD_NAME, DIRECTION)
  VALUES (745, 'ORDER', 'INVOICE_EUR_0', 'Сумма выставленной оплаты в EUR', NULL, NULL);

INSERT INTO ATTRS (ATTR_ID, OBJECT_SIGN, ATTR_SIGN, ATTR_NAME, FIELD_NAME, DIRECTION)
  VALUES (746, 'ORDER', 'INVOICE_DT_1', 'Дата выставления оплаты', NULL, NULL);

INSERT INTO ATTRS (ATTR_ID, OBJECT_SIGN, ATTR_SIGN, ATTR_NAME, FIELD_NAME, DIRECTION)
  VALUES (747, 'ORDER', 'INVOICE_BYR_1', 'Сумма выставленной оплаты в BYR', NULL, NULL);

INSERT INTO ATTRS (ATTR_ID, OBJECT_SIGN, ATTR_SIGN, ATTR_NAME, FIELD_NAME, DIRECTION)
  VALUES (748, 'ORDER', 'INVOICE_EUR_1', 'Сумма выставленной оплаты в EUR', NULL, NULL);

INSERT INTO ATTRS (ATTR_ID, OBJECT_SIGN, ATTR_SIGN, ATTR_NAME, FIELD_NAME, DIRECTION)
  VALUES (749, 'ORDER', 'INVOICE_DT_2', 'Дата выставления оплаты', NULL, NULL);

INSERT INTO ATTRS (ATTR_ID, OBJECT_SIGN, ATTR_SIGN, ATTR_NAME, FIELD_NAME, DIRECTION)
  VALUES (750, 'ORDER', 'INVOICE_BYR_2', 'Сумма выставленной оплаты в BYR', NULL, NULL);

INSERT INTO ATTRS (ATTR_ID, OBJECT_SIGN, ATTR_SIGN, ATTR_NAME, FIELD_NAME, DIRECTION)
  VALUES (751, 'ORDER', 'INVOICE_EUR_2', 'Сумма выставленной оплаты в EUR', NULL, NULL);

INSERT INTO ATTRS (ATTR_ID, OBJECT_SIGN, ATTR_SIGN, ATTR_NAME, FIELD_NAME, DIRECTION)
  VALUES (752, 'ORDER', 'INVOICE_DT_3', 'Дата выставления оплаты', NULL, NULL);

INSERT INTO ATTRS (ATTR_ID, OBJECT_SIGN, ATTR_SIGN, ATTR_NAME, FIELD_NAME, DIRECTION)
  VALUES (753, 'ORDER', 'INVOICE_BYR_3', 'Сумма выставленной оплаты в BYR', NULL, NULL);

INSERT INTO ATTRS (ATTR_ID, OBJECT_SIGN, ATTR_SIGN, ATTR_NAME, FIELD_NAME, DIRECTION)
  VALUES (754, 'ORDER', 'INVOICE_EUR_3', 'Сумма выставленной оплаты в EUR', NULL, NULL);

INSERT INTO ATTRS (ATTR_ID, OBJECT_SIGN, ATTR_SIGN, ATTR_NAME, FIELD_NAME, DIRECTION)
  VALUES (755, 'ORDER', 'INVOICE_DT_4', 'Дата выставления оплаты', NULL, NULL);

INSERT INTO ATTRS (ATTR_ID, OBJECT_SIGN, ATTR_SIGN, ATTR_NAME, FIELD_NAME, DIRECTION)
  VALUES (756, 'ORDER', 'INVOICE_BYR_4', 'Сумма выставленной оплаты в BYR', NULL, NULL);

INSERT INTO ATTRS (ATTR_ID, OBJECT_SIGN, ATTR_SIGN, ATTR_NAME, FIELD_NAME, DIRECTION)
  VALUES (757, 'ORDER', 'INVOICE_EUR_4', 'Сумма выставленной оплаты в EUR', NULL, NULL);

INSERT INTO ATTRS (ATTR_ID, OBJECT_SIGN, ATTR_SIGN, ATTR_NAME, FIELD_NAME, DIRECTION)
  VALUES (758, 'ORDER', 'INVOICE_DT_5', 'Дата выставления оплаты', NULL, NULL);

INSERT INTO ATTRS (ATTR_ID, OBJECT_SIGN, ATTR_SIGN, ATTR_NAME, FIELD_NAME, DIRECTION)
  VALUES (759, 'ORDER', 'INVOICE_BYR_5', 'Сумма выставленной оплаты в BYR', NULL, NULL);

INSERT INTO ATTRS (ATTR_ID, OBJECT_SIGN, ATTR_SIGN, ATTR_NAME, FIELD_NAME, DIRECTION)
  VALUES (760, 'ORDER', 'INVOICE_EUR_5', 'Сумма выставленной оплаты в EUR', NULL, NULL);

INSERT INTO ATTRS (ATTR_ID, OBJECT_SIGN, ATTR_SIGN, ATTR_NAME, FIELD_NAME, DIRECTION)
  VALUES (941, 'ORDERITEM', 'AUFTRAG_ID', 'Код заявки у немцев', NULL, NULL);

UPDATE ATTRS
SET DIRECTION = 'R'
WHERE (ATTR_ID = 1501);

INSERT INTO ATTRS (ATTR_ID, OBJECT_SIGN, ATTR_SIGN, ATTR_NAME, FIELD_NAME, DIRECTION)
  VALUES (1502, 'PRODUCT', 'BARCODE_SIGN', 'Литера в BARCODE', NULL, 'R');

INSERT INTO ATTRS (ATTR_ID, OBJECT_SIGN, ATTR_SIGN, ATTR_NAME, FIELD_NAME, DIRECTION)
  VALUES (1503, 'PRODUCT', 'PRODUCT_CODE', 'Код продукта 1- предоплата, 2- наложенный', 'PRODUCT_CODE', 'R');



INSERT INTO PRODUCT_ATTRS (OBJECT_ID, ATTR_ID, ATTR_VALUE)
  VALUES (1, 1502, 'CZ');

INSERT INTO PRODUCT_ATTRS (OBJECT_ID, ATTR_ID, ATTR_VALUE)
  VALUES (2, 1502, 'CY');



INSERT INTO STATUS_RULES (OLD_STATUS_ID, NEW_STATUS_ID, ACTION_SIGN)
  VALUES (182, 184, 'ORDERITEM_BUNDLING');



insert into orderitem_attrs (object_id, attr_id, attr_value)
select oi.orderitem_id, 941, oa.attr_value from orderitems oi
  inner join order_attrs oa on (oa.object_id = oi.order_id)
where oa.attr_id = 733;


EXECUTE BLOCK AS
  declare variable v_order_id id_order;
  declare variable v_weight numeric(10);
  declare variable v_ordertax_id id_tax;
  declare variable v_action_id id_action;
  declare variable v_param_id id_param;
  declare variable v_taxrate_id id_tax;
  declare variable v_tax_procedure name_procedure;
  declare variable v_cost_eur money_eur;
  declare variable v_price_eur money_eur;
BEGIN
  -- Именованные параметры запроса
  for select o.order_id, substring(oa.attr_value from 1 for 4)
       from orders o
         inner join v_order_attrs oa on (oa.object_id = o.order_id and oa.attr_sign = 'WEIGHT')
         inner join statuses s on (s.status_id = o.status_id)
       where o.order_code like '1_____' and oa.attr_value like '____.%'
         and substring(oa.attr_value from 1 for 4) > '3100'
         and s.status_sign in ('DELIVERING', 'DELIVERED', 'HAVERETURN')
       into :v_order_id, :v_weight do
  begin
    v_ordertax_id = null;
    select ot.ordertax_id
      from ordertaxs ot
        inner join taxrates tr on (tr.taxrate_id = ot.taxrate_id and tr.taxserv_id = 3)
      where order_id = :v_order_id
      into :v_ordertax_id;
    if (v_ordertax_id is null) then
    begin

      select tr.taxrate_id, tr.tax_procedure
        from taxservs ts
          inner join taxrates tr on (tr.taxserv_id = ts.taxserv_id and tr.taxplan_id = 3)
        where ts.calcpoint_id = 2
        into :v_taxrate_id, :v_tax_procedure;

      select o_param_id from param_create('ORDERTAX') into :v_param_id;

      insert into params (param_id, param_name, param_value)
      select :v_param_id, tra.attr_sign, tra.attr_value
        from v_taxrate_attrs tra
        where tra.object_id = :v_taxrate_id;

      execute procedure param_set(:v_param_id,  'ORDER_ID', :v_order_id);
      execute procedure param_set(:v_param_id,  'TAXRATE_ID', :v_taxrate_id);

      select o_cost_eur from tax_weight(:v_taxrate_id, :v_param_id) into :v_cost_eur;

      v_ordertax_id = gen_id(seq_ordertax_id, 1);

      select o_action_id from action_run ('ORDERTAX', 'ORDERTAX_CREATE', :v_param_id, :v_ordertax_id) into :v_action_id;
    end
  end
END


