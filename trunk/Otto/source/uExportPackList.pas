unit uExportPackList;

interface
uses
  Classes, NativeXml, FIBDatabase, pFIBDatabase, DB;

procedure ExportPackList(aTransaction: TpFIBTransaction);

implementation
uses
  SysUtils, GvNativeXml, udmOtto, GvStr, Dbf, GvFile;

function GetPlace(ndPlace: TXmlNode): string;
begin
  if GetXmlAttrValue(ndPlace, 'PLACETYPE_CODE', '4') = 4 then
    Result:= GetXmlAttr(ndPlace, 'PLACE_NAME')
  else
    Result:= GetXmlAttr(ndPlace, 'PLACETYPE_NAME', ' ', '.') +
             GetXmlAttr(ndPlace, 'PLACE_NAME', ' ');
end;

function GetAdress(ndAdress: TXmlNode): string;
var
  Part1, Part2: string;
begin
   if GetXmlAttrValue(ndAdress, 'STREETTYPE_CODE', '1') > 1 then
     Part1:= GetXmlAttr(ndAdress, 'STREETTYPE_NAME', ' ', '. ') +
             GetXmlAttr(ndAdress, 'STREET_NAME')
   else
     Part1:= GetXmlAttr(ndAdress, 'STREET_NAME');

   Part2:= GetXmlAttr(ndAdress, 'HOUSE', ', ') +
           GetXmlAttr(ndAdress, 'BUILDING', '/') +
           GetXmlAttr(ndAdress, 'FLAT', '-');
   Result:= Part1 + Part2;
end;


procedure ExportOrderItem(aTransaction: TpFIBTransaction;
  ndProduct, ndOrder, ndOrderItems, ndOrderTaxs: TXmlNode;
  tblCons: TDataSet; aOrderItemId: variant);
var
  ndOrderItem, ndClient, ndTaxSSbor, ndAdress, ndPlace: TXmlNode;
  ShortClientName: string;
begin
  ndOrderItem:= ndOrderItems.NodeByAttributeValue('ORDERITEM', 'ID', aOrderItemId);
  try
    ndTaxSSbor:= ndOrderTaxs.NodeByAttributeValue('ORDERTAX', 'TAXSERV_ID', '1');

    ndClient:= ndOrder.NodeFindOrCreate('CLIENT');
    dmOtto.ObjectGet(ndClient, GetXmlAttrValue(ndOrder, 'CLIENT_ID'), aTransaction);
    ndAdress:= ndOrder.NodeFindOrCreate('ADRESS');
    dmOtto.ObjectGet(ndAdress, GetXmlAttrValue(ndOrder, 'ADRESS_ID'), aTransaction);
    ndPlace:= ndAdress.NodeFindOrCreate('PLACE');
    dmOtto.ObjectGet(ndPlace, GetXmlAttrValue(ndAdress, 'PLACE_ID'), aTransaction);

    tblCons.Append;
    BatchMoveFields2(tblCons, ndProduct, 'KTPART=PARTNER_NUMBER');
    BatchMoveFields2(tblCons, ndOrder,
      'KTKUNDE=ORDER_CODE;NRSENDUNG=PACKLIST_NO;NRKARTON=PALETTE_NO;'+
      'NEWICHT=WEIGHT');
    BatchMoveFields2(tblCons, ndOrderItem,
      'NRART=ARTICLE_CODE;BZARTORG=DESCRIPTION;MENGE=AMOUNT;PRVK=PRICE_EUR;'+
      'NREGWG');
    BatchMoveFields2(tblCons, ndTaxSSbor,
      'SBOR=COST_EUR');
    BatchMoveFields2(tblCons, ndAdress,
      'GOSNUM=POSTINDEX');

    tblCons['KTNAME']:= Translit(
      GetXmlAttr(ndClient, 'FIRST_NAME') + ' '+
      Copy(GetXmlAttr(ndClient, 'MID_NAME'), 1, 1) + ' ' +
      GetXmlAttr(ndClient, 'LAST_NAME'));
    tblCons['AUFEXT']:= FilterString(GetXmlAttr(ndOrder, 'ORDER_CODE'), '0123456789');
    tblCons['GRART']:= dmOtto.Recode('ARTICLE', 'DIMENSION_ENCODE', GetXmlAttr(ndOrderItem, 'DIMENSION'));
    tblCons['NAMEZAK']:= GetXmlAttr(ndOrderItem, 'NAME_RUS', ' ') + GetXmlAttr(ndOrderItem, 'KIND_RUS');
    tblCons['FAMILY']:= GetXmlAttr(ndClient, 'LAST_NAME') +
                        GetXmlAttr(ndClient, 'FIRST_NAME', ' ') +
                        GetXmlAttr(ndClient, 'MID_NAME', ' ');
    tblCons['STREETRUS']:= GetAdress(ndAdress);
    tblCons['CITYRUS']:= GetPlace(ndPlace);
    tblCons['REGIONRUS']:= GetXmlAttr(ndPlace, 'REGION_NAME',
                           GetXmlAttr(ndPlace, 'AREA_NAME', '', ' р-н '), ' обл.');
    tblCons['STREET']:= Translit(tblCons['STREETRUS']);
//    tblCons['CITY']:= Translit(tblCons['CITYRUS']);
//    tblCons['REGION']:= Translit(tblCons['REGIONRUS']);
    tblCons['TEL']:= replaceAll(GetXmlAttr(ndClient, 'MOBILE_PHONE', '+375'), '+3750', '+375');

    tblCons.Post;
  finally
    ndOrderItem.Clear;
  end;
end;

procedure ExportOrder(aTransaction: TpFIBTransaction;
  ndProduct, ndOrders: TXmlNode; tblCons: TDataSet; aOrderId: integer);
var
  ndOrder, ndOrderItems, ndOrderItem, ndOrderTaxs: TXmlNode;
  OrderItemList: string;
  OrderItemId: Variant;
begin
  ndOrder:= ndProduct.NodeFindOrCreate('ORDERS').NodeFindOrCreate('ORDER');
  try
    dmOtto.ObjectGet(ndOrder, aOrderId, aTransaction);
    ndOrderItems:= ndOrder.NodeFindOrCreate('ORDERITEMS');
    dmOtto.OrderItemsGet(ndOrderItems, aOrderId, aTransaction);
    ndOrderTaxs:= ndOrder.NodeFindOrCreate('ORDERTAXS');
    dmOtto.OrderTaxsGet(ndOrderTaxs, aOrderId, aTransaction);
    OrderItemList:= aTransaction.DefaultDatabase.QueryValue(
      'select list(oi.orderitem_id) '+
      'from orderitems oi '+
      'inner join statuses s on (s.status_id = oi.status_id and s.status_sign = ''PACKED'') '+
      'where oi.order_id = :order_id',
      0, [aOrderId], aTransaction);
    while OrderItemList <> '' do
    begin
      OrderItemId:= TakeFront5(OrderItemList, ',');
      ExportOrderItem(aTransaction, ndProduct, ndOrder, ndOrderItems, ndOrderTaxs,
        tblCons, OrderItemId);
    end;
  finally
    ndOrder.Clear;
  end;
end;

procedure ExportPack(aTransaction: TpFIBTransaction;
  ndProduct: TXmlNode; aPackNo: integer);
var
  TConsName, TConspi3Name: string;
  OrderList: string;
  OrderId: variant;
  dbfCons: TDbf;
  ndOrders: TXmlNode;
begin
  ndOrders:= ndProduct.NodeNew('ORDERS');
  try
    SetXmlAttr(ndOrders, 'PACKLIST_NO', aPackNo);
    dbfCons:= TDbf.Create(nil);
    TConsName:= Format('t-cons_%s_%uv.dbf',
      [GetXmlAttr(ndProduct, 'PARTNER_NUMBER'), aPackNo]);
    copyFile(Path['Stru']+'tcons.dbf', Path['DbfPackLists'] + TConsName);
    dbfCons.FilePath:= Path['DbfPackLists'];
    dbfCons.TableName:= TConsName;
    try
      dbfCons.Open;
      try
        OrderList:= aTransaction.DefaultDatabase.QueryValue(
          'select list(distinct o.order_id) '+
          'from orders o '+
          'inner join statuses s on (s.status_id = o.status_id and s.status_sign = ''PACKED'') '+
          'inner join v_order_attrs oa on (oa.object_id = o.order_id and oa.attr_sign = ''PACKLIST_NO'') '+
          'where oa.attr_value = :pack_no',
          0, [aPackNo], aTransaction);
        while OrderList <> '' do
        begin
          OrderId:= TakeFront5(OrderList, ',');
          ExportOrder(aTransaction, ndProduct, ndOrders, dbfCons, OrderId);
        end;
      finally
        dbfCons.Close;
      end;
    finally
      dbfCons.Free;
    end;
  finally
    ndOrders.Clear;
  end;
end;

procedure ExportProduct(aTransaction: TpFIBTransaction;
  ndProducts: TXmlNode; aProductId: integer);
var
  ndProduct: TXmlNode;
  PackList, FileName, OrderText: string;
  PackNo: variant;
begin
  ndProduct:= ndProducts.NodeFindOrCreate('PRODUCT');
  try
    dmOtto.ObjectGet(ndProduct, aProductId, aTransaction);
    PackList:= aTransaction.DefaultDatabase.QueryValue(
      'select list(distinct oa.attr_value) '+
      'from orders o '+
      'inner join statuses s on (s.status_id = o.status_id and s.status_sign = ''PACKED'') '+
      'inner join v_order_attrs oa on (oa.object_id = o.order_id and oa.attr_sign = ''PACKLIST_NO'') '+
      'where o.product_id = :product_id',
      0, [aProductId], aTransaction);
    while PackList <> '' do
    begin
      PackNo:= TakeFront5(PackList, ',');
      ExportPack(aTransaction, ndProduct, PackNo);
    end;
  finally
    ndProduct.Clear;
  end;
end;

procedure ExportPackList(aTransaction: TpFIBTransaction);
var
  Xml: TNativeXml;
  ndProducts: TXmlNode;
  ProductId: Variant;
  ProductList: string;
  Files: TStringList;
begin
  if aTransaction.Active then aTransaction.Rollback;
  aTransaction.StartTransaction;
  try
    xml:= TNativeXml.CreateName('PRODUCTS');
    try
      ndProducts:= Xml.Root;
      ProductList:= aTransaction.DefaultDatabase.QueryValue(
        'select list(distinct o.product_id) '+
        'from orders o '+
        'inner join statuses s on (s.status_id = o.status_id and s.status_sign = ''PACKED'') ',
        0, aTransaction);
      while ProductList <> '' do
      begin
        ProductId:= TakeFront5(ProductList, ',');
        ExportProduct(aTransaction, ndProducts, ProductId);
      end;
    finally
      Xml.Free;
    end;
    aTransaction.Commit;
  except
    aTransaction.Rollback;
  end;
end;

end.
