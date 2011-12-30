unit uExportPackList;

interface
uses
  Classes, NativeXml, FIBDatabase, pFIBDatabase, DB;

procedure ExportPackList(aTransaction: TpFIBTransaction);

implementation
uses
  SysUtils, GvNativeXml, udmOtto, GvStr, Dbf, GvFile, uMain, Dialogs;

function GetPlace(ndPlace: TXmlNode): string;
begin
  if GetXmlAttrValue(ndPlace, 'PLACETYPE_CODE', '4') = 4 then
    Result:= GetXmlAttr(ndPlace, 'PLACE_NAME')
  else
    Result:= GetXmlAttr(ndPlace, 'PLACETYPE_NAME', ' ', '.') +
             GetXmlAttr(ndPlace, 'PLACE_NAME', ' ');
end;

function GetStreet(ndAdress: TXmlNode): string;
begin
   if GetXmlAttrValue(ndAdress, 'STREETTYPE_CODE', '1') > 1 then
     Result:= GetXmlAttr(ndAdress, 'STREETTYPE_NAME', ' ', '. ') +
             GetXmlAttr(ndAdress, 'STREET_NAME')
   else
     Result:= GetXmlAttr(ndAdress, 'STREET_NAME');
end;

function GetHome(ndAdress: TXmlNode): string;
begin
   Result:= GetXmlAttr(ndAdress, 'HOUSE') +
           GetXmlAttr(ndAdress, 'BUILDING', '/') +
           GetXmlAttr(ndAdress, 'FLAT', '-');

end;

function GetAdress(ndAdress: TXmlNode): string;
begin
  Result:= GetStreet(ndAdress) + ', ' + GetHome(ndAdress);
end;


procedure ExportOrderItem(aTransaction: TpFIBTransaction;
  ndProduct, ndOrder, ndOrderItems, ndOrderTaxs: TXmlNode;
  tblCons, tblConsPi3: TDataSet; aOrderItemId: variant);
var
  ndOrderItem, ndClient, ndTaxSSbor, ndAdress, ndPlace: TXmlNode;
  ShortClientName: string;
  St: string;
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

    ndProduct.Document.XmlFormat:= xfReadable;
    ndProduct.Document.SaveToFile('order.xml');
    tblCons.Append;
    BatchMoveFields2(tblCons, ndProduct, 'KTPART=PARTNER_NUMBER');
    BatchMoveFields2(tblCons, ndOrder,
      'KTKUNDE=ORDER_CODE;NRSENDUNG=PACKLIST_NO;NRPALETTE=PALETTE_NO;NRKARTON=PACKET_NO;'+
      'NEWICHT=WEIGHT;DATEEXCH=CREATE_DTM;RATEEXCH=BYR2EUR;USEXCH="0";VIDPLAT="0";'+
      'CONTR_ID=ID;COSTALL=ITEMSCOST_EUR;BARKOD=BAR_CODE');
    BatchMoveFields2(tblCons, ndOrderItem,
      'NRART=ARTICLE_CODE;BZARTORG=DESCRIPTION;MENGE=AMOUNT;PRVK=PRICE_EUR;'+
      'NREGWG;ZNAK="1";INSUM="1";NRAUFPOS=ORDERITEM_INDEX');
    BatchMoveFields2(tblCons, ndTaxSSbor,
      'SBOR=COST_EUR');
    BatchMoveFields2(tblCons, ndAdress,
      'GOSNUM=POSTINDEX');
    BatchMoveFields2(tblCons, ndClient,
      'BLACKLIST="0"');

    tblCons['KTNAME']:= Translit(
      GetXmlAttr(ndClient, 'FIRST_NAME') + ' '+
      Copy(GetXmlAttr(ndClient, 'MID_NAME'), 1, 1) + ' ' +
      GetXmlAttr(ndClient, 'LAST_NAME'));
    tblCons['AUFEXT']:= FilterString(GetXmlAttr(ndOrder, 'ORDER_CODE'), '0123456789');
    tblCons['GRART']:= dmOtto.Recode('ARTICLE', 'DIMENSION_ENCODE', GetXmlAttr(ndOrderItem, 'DIMENSION'));
    tblCons['NAMEZAK']:= GetXmlAttr(ndOrderItem, 'NAME_RUS') + GetXmlAttr(ndOrderItem, 'KIND_RUS', ' ');
    tblCons['FAMILY']:= GetXmlAttr(ndClient, 'LAST_NAME') +
                        GetXmlAttr(ndClient, 'FIRST_NAME', ' ') +
                        GetXmlAttr(ndClient, 'MID_NAME', ' ');
    tblCons['STREETRUS']:= GetAdress(ndAdress);
    tblCons['CITYRUS']:= GetPlace(ndPlace);
    tblCons['REGIONRUS']:= GetXmlAttr(ndPlace, 'REGION_NAME',
                           GetXmlAttr(ndPlace, 'AREA_NAME', '', ' р-н '), ' обл.');
    tblCons['STREET']:= Translit(GetAdress(ndAdress));
    tblCons['CITY']:= Translit(GetPlace(ndPlace));
    tblCons['REGION']:= Translit(GetXmlAttr(ndPlace, 'REGION_NAME',
                           GetXmlAttr(ndPlace, 'AREA_NAME', '', ' р-н '), ' обл.'));
    tblCons['TEL']:= ReplaceAll(replaceAll(GetXmlAttr(ndClient, 'MOBILE_PHONE', '+375'), '+3750', '+375'), '+', '');
    tblCons['COSTBYR']:= aTransaction.DefaultDatabase.QueryValue(
      'select round(cast(:cost_eur as money_eur) * cast(:byr2eur as value_integer), -1) from rdb$database',
      0, [GetXmlAttrValue(ndOrderItem, 'COST_EUR'), GetXmlAttrValue(ndOrder, 'BYR2EUR')], aTransaction);
    tblCons['SBORBYR']:= aTransaction.DefaultDatabase.QueryValue(
      'select round(cast(:cost_eur as money_eur) * cast(:byr2eur as value_integer), -1) from rdb$database',
      0, [GetXmlAttrValue(ndTaxSSbor, 'COST_EUR'), GetXmlAttrValue(ndOrder, 'BYR2EUR')], aTransaction);
    tblCons.Post;
    tblConsPi3.Append;
    BatchMoveFields2(tblConsPi3, tblCons,
      'KTPART;X211=NRSENDUNG;NZAK=KTKUNDE;EXP_3="300";NAMEZAK;NRART;GRART;KOL="1";'+
      'PRICE=PRVK;PRICEBEL=COSTBYR;SERVBEL=SBORBYR;DATEPOST=DATEEXCH;NREGWG;'+
      'FAMILY;PARTOBL=REGIONRUS;TELEPHONE=TEL;NORG="1";INDEXCITY=GOSNUM;'+
      'CITYRUS;N14=NRPALETTE');
    BatchMoveFields2(tblConsPi3, ndOrderItem,
      'NRAUFPOS=ORDERITEM_INDEX');
    tblConsPi3['STREET']:= GetStreet(ndAdress);
    tblConsPi3['HOME']:= GetHome(ndAdress);
    tblConsPi3['NEWICHT']:= GetXmlAttrValue(ndOrderItem, 'WEIGHT')/1000;
    tblConsPi3.Post;
    SetXmlAttr(ndOrderItem, 'NEW.STATUS_SIGN', 'DELIVERING');
    dmOtto.ActionExecute(aTransaction, ndOrderItem);
  finally
    ndOrderItem.Clear;
  end;
end;

procedure ExportOrder(aTransaction: TpFIBTransaction;
  ndProduct, ndOrders: TXmlNode; tblCons, tblConsPi3: TDataSet; aOrderId: integer);
var
  ndOrder, ndOrderItems, ndOrderItem, ndOrderTaxs: TXmlNode;
  OrderItemList: string;
  OrderItemId: Variant;
  i: integer;
begin
  ndOrder:= ndProduct.NodeFindOrCreate('ORDERS').NodeFindOrCreate('ORDER');
  try
    dmOtto.ObjectGet(ndOrder, aOrderId, aTransaction);
    ndOrderItems:= ndOrder.NodeFindOrCreate('ORDERITEMS');
    dmOtto.OrderItemsGet(ndOrderItems, aOrderId, aTransaction);
    ndOrderTaxs:= ndOrder.NodeFindOrCreate('ORDERTAXS');
    dmOtto.OrderTaxsGet(ndOrderTaxs, aOrderId, aTransaction);
    SetXmlAttr(ndOrder, 'NEW.STATUS_SIGN', 'DELIVERING');
    dmOtto.ActionExecute(aTransaction, ndOrder);

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
        tblCons, tblConsPi3, OrderItemId);
    end;
  finally
    ndOrder.Clear;
  end;
end;

procedure ExportPack(aTransaction: TpFIBTransaction;
  ndProduct: TXmlNode; aPackNo: integer);
const
  HeaderText = 'Формирование паклиста';
var
  ConsName, ConsPi3Name: string;
  OrderList: string;
  OrderId: variant;
  dbfCons, dbfConsPi3: TDbf;
  ndOrders: TXmlNode;
begin
  ndOrders:= ndProduct.NodeNew('ORDERS');
  try
    SetXmlAttr(ndOrders, 'PACKLIST_NO', aPackNo);
    dbfCons:= TDbf.Create(nil);
    dbfConsPi3:= TDbf.Create(nil);
    ConsName:= Format('t-cons_%s_%uv.dbf',
      [GetXmlAttr(ndProduct, 'PARTNER_NUMBER'), aPackNo]);
    copyFile(Path['Stru']+'tcons.dbf', Path['DbfPackLists'] + ConsName);
    ConsPi3Name:= Format('t-cons_%s_%uvpi3',
      [GetXmlAttr(ndProduct, 'PARTNER_NUMBER'), aPackNo]);
    copyFile(Path['Stru']+'tconspi3.dbf', Path['DbfPackLists'] + ConsPi3Name+'.dbf');
    MainForm.PrintPackList(aTransaction, aPackNo, ConsPi3Name+'.xls');
    dbfCons.FilePath:= Path['DbfPackLists'];
    dbfCons.TableName:= ConsName;
    dbfConsPi3.FilePath:= Path['DbfPackLists'];
    dbfConsPi3.TableName:= ConsPi3Name+'.dbf';
    try
      dbfCons.Open;
      dbfConsPi3.Open;
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
          ExportOrder(aTransaction, ndProduct, ndOrders, dbfCons, dbfConsPi3, OrderId);
        end;
      finally
        dbfCons.Close;
        dbfConsPi3.Close;
      end;
    finally
      dbfConsPi3.Free;
      dbfCons.Free;
    end;
    dmOtto.CreateAlert(HeaderText, Format('Сформирован паклист %u', [aPackNo]), mtInformation);
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
