delete from order_attrs oa
where oa.attr_id = 725
 and exists (select *
               from order_attrs oaa
               where oaa.object_id = oa.object_id
                 and oaa.attr_id = 744);
delete from order_attrs oa
where oa.attr_id = 724
 and exists (select *
               from order_attrs oaa
               where oaa.object_id = oa.object_id
                 and oaa.attr_id = 745);
update order_attrs oa
set oa.attr_id = 744
where oa.attr_id = 725;

update order_attrs oa
set oa.attr_id = 745
where oa.attr_id = 724;

delete from attrs a
where a.attr_id in (724, 725);

EXECUTE BLOCK as
declare variable v_order_id integer;
declare variable v_money_byr money_byr;
declare variable v_money_eur money_eur;
declare variable v_byr2eur money_byr;
BEGIN
  for select o.order_id, cast(replace(unescapestring(oa.attr_value), ',', '.') as money_eur), o.byr2eur
        from orders o
          inner join order_attrs oa on (oa.object_id = o.order_id and oa.attr_id = 745)
        into :v_order_id, :v_money_eur, :v_byr2eur do
  begin

    select o_money_byr from money_eur2byr(:v_money_eur, :v_byr2eur) into :v_money_byr;
    update order_attrs oa
      set oa.attr_value = :v_money_byr
      where oa.object_id = :v_order_id
        and oa.attr_id = 744;
  end
end

--ddddddddddd
delete from order_attrs oa
where oa.attr_id = 727
 and exists (select *
               from order_attrs oaa
               where oaa.object_id = oa.object_id
                 and oaa.attr_id = 747);
delete from order_attrs oa
where oa.attr_id = 726
 and exists (select *
               from order_attrs oaa
               where oaa.object_id = oa.object_id
                 and oaa.attr_id = 748);
update order_attrs oa
set oa.attr_id = 747
where oa.attr_id = 727;

update order_attrs oa
set oa.attr_id = 748
where oa.attr_id = 726;

delete from attrs a
where a.attr_id in (726, 727);

EXECUTE BLOCK as
declare variable v_order_id integer;
declare variable v_money_byr money_byr;
declare variable v_money_eur money_eur;
declare variable v_byr2eur money_byr;
BEGIN
  for select o.order_id, cast(replace(unescapestring(oa.attr_value), ',', '.') as money_eur), o.byr2eur
        from orders o
          inner join order_attrs oa on (oa.object_id = o.order_id and oa.attr_id = 748)
        into :v_order_id, :v_money_eur, :v_byr2eur do
  begin

    select o_money_byr from money_eur2byr(:v_money_eur, :v_byr2eur) into :v_money_byr;
    update order_attrs oa
      set oa.attr_value = :v_money_byr
      where oa.object_id = :v_order_id
        and oa.attr_id = 747;
  end
end

--ddddddddddd
delete from order_attrs oa
where oa.attr_id = 729
 and exists (select *
               from order_attrs oaa
               where oaa.object_id = oa.object_id
                 and oaa.attr_id = 750);
delete from order_attrs oa
where oa.attr_id = 728
 and exists (select *
               from order_attrs oaa
               where oaa.object_id = oa.object_id
                 and oaa.attr_id = 751);
update order_attrs oa
set oa.attr_id = 750
where oa.attr_id = 729;

update order_attrs oa
set oa.attr_id = 751
where oa.attr_id = 728;

delete from attrs a
where a.attr_id in (728, 729);

EXECUTE BLOCK as
declare variable v_order_id integer;
declare variable v_money_byr money_byr;
declare variable v_money_eur money_eur;
declare variable v_byr2eur money_byr;
BEGIN
  for select o.order_id, cast(replace(unescapestring(oa.attr_value), ',', '.') as money_eur), o.byr2eur
        from orders o
          inner join order_attrs oa on (oa.object_id = o.order_id and oa.attr_id = 751)
        into :v_order_id, :v_money_eur, :v_byr2eur do
  begin

    select o_money_byr from money_eur2byr(:v_money_eur, :v_byr2eur) into :v_money_byr;
    update order_attrs oa
      set oa.attr_value = :v_money_byr
      where oa.object_id = :v_order_id
        and oa.attr_id = 750;
  end
end

