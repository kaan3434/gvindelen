unit uExportSuissen;

interface

uses
  Classes, NativeXml, FIBDatabase, pFIBDatabase;

procedure ExportSuissen(aTransaction: TpFIBTransaction; ndProduct: TXmlNode;
  aProductId: integer; aStatusSign, aArjName:String);

implementation

uses
  SysUtils, Dialogs, dbf, udmOtto, GvNativeXml, GvStr, GvFile;

procedure ExportOrder(aTransaction: TpFIBTransaction; ndProduct, ndOrders: TXmlNode;
  aOrderId: integer; aStatusSign:String; dbfClient, dbfOrder, dbfItems: TDbf);
var
  ndOrder, ndClient, ndAdress, ndPlace, ndOrderItems, ndOrderItem: TXmlNode;
  OrderItemList: string;
  OrderItemId, Intern: Variant;
begin
  ndOrder:= ndOrders.NodeNew('ORDER');
  dmOtto.ObjectGet(ndOrder, aOrderId, aTransaction);
  ndClient:= ndOrder.NodeNew('CLIENT');
  dmOtto.ObjectGet(ndClient, GetXmlAttrValue(ndOrder, 'CLIENT_ID'), aTransaction);
  if GetXmlAttr(ndClient, 'SUISSEN_CODE') = '' then
  begin
    SetXmlAttr(ndClient, 'SUISSEN_CODE', dmOtto.GetNextCounterValue('CLIENT', 'SUISSEN_CODE', 0, aTransaction));
    dmOtto.ActionExecute(aTransaction, ndClient);
  end;
  ndAdress:= ndClient.NodeNew('ADRESS');
  dmOtto.AdressRead(ndAdress, GetXmlAttrValue(ndOrder, 'ADRESS_ID'), aTransaction);
  ndPlace:= ndAdress.FindNode('PLACE');
  dbfClient.Append;
  BatchMoveFields2(dbfClient, ndClient,
    'CL_NUM=SUISSEN_CODE;MCL_NUM=SUISSEN_CODE;XCL_NUM=SUISSEN_CODE;CL_GROUP="1";'+
    'CL_TYPE="VB";F_NAME_NAT=FIRST_NAME;L_NAME_NAT=LAST_NAME;X_NAME_NAT=MID_NAME;'+
    'PHONE=MOBILE_PHONE');
  BatchMoveFields2(dbfClient, ndAdress,
    'ADRESS_NAT=STREET_TEXT;ZIP=POSTINDEX');
  BatchMoveFields2(dbfClient, ndPlace,
    'CITY_NAT=PLACE_TEXT');

  dbfClient['F_NAME_LAT']:= Translit(dbfClient['F_NAME_NAT']);
  dbfClient['L_NAME_LAT']:= Translit(dbfClient['L_NAME_LAT']);
  dbfClient['CITY_LAT']:= Translit(dbfClient['CITY_LAT']);
  dbfClient['ADRESS_LAT']:= Translit(dbfClient['ADRESS_NAT']);
  dbfClient.Post;

  dbfOrder.Append;
  BatchMoveFields2(dbfOrder, ndClient,
    'CLIENT_NUM=SUISSEN_CODE;');
  BatchMoveFields2(dbfOrder, ndOrder,
    'ORDER_NUM=ID;ORDER_DATE=CREATE_DTM');
  dbfOrder.Post;

  ndOrderItems:= ndOrder.NodeNew('ORDERITEMS');

  OrderItemList:= aTransaction.DefaultDatabase.QueryValueAsStr(
    'select list(distinct orderitem_id) from ( '+
    'select oi.orderitem_id '+
    'from orderitems oi '+
    'inner join statuses s on (s.status_id = oi.status_id and s.status_sign = :status_sign) '+
    'inner join orders o on (o.order_id = oi.order_id) '+
    'where oi.order_id = :order_id '+
    'order by oi.index_item)',
    0, [aOrderId, aStatusSign]);
  while OrderItemList <> '' do
  begin
    OrderItemId:= TakeFront5(OrderItemList, ',');
    ndOrderItem:= ndOrderItems.NodeNew('ORDERITEM');
    dmOtto.ObjectGet(ndOrderItem, OrderItemId, aTransaction);
    if GetXmlAttr(ndOrderItem, 'AUFTRAG_ID') = '' then
    begin
      Intern:= aTransaction.DefaultDatabase.QueryValue(
        'select o_intern from orderitem_set_intern(:OrderItem_id)',
        0, [OrderItemId], aTransaction);
      SetXmlAttr(ndOrderItem, 'AUFTRAG_ID', Intern);
    end;
    dbfItems.Append;
    BatchMoveFields2(dbfItems, ndClient,
      'CLIENT_NUM=SUISSEN_CODE');
    BatchMoveFields2(dbfItems, ndOrder,
      'ORDER_NUM=ID;ORDER_DATE=CREATE_DTM');
    BatchMoveFields2(dbfItems, ndOrderItem,
      'INTERN=AUFTRAG_ID;ITEM_NUM=ARTICLE_CODE;ITEM_SIZE=DIMENSION;'+
      'ITEM_NAME=DESCRIPTION;AMOUNT="1";PRICE=PRICE_EUR;TOTAL_SUM=COST_EUR'+
      'ITEM_TYPE="NR"');
    dbfItems.Post;
  end;
end;

procedure ExportSuissen(aTransaction: TpFIBTransaction; ndProduct: TXmlNode;
  aProductId: integer; aStatusSign, aArjName:String);
var
  dbfClients, dbfOrders, dbfItems: TDbf;
  ndOrders: TXmlNode;
  OrderId: variant;
  OrderList, FilePath: string;
begin
  ndOrders:= ndProduct.NodeNew('ORDERS');
  OrderList:= aTransaction.DefaultDatabase.QueryValueAsStr(
    'select list(distinct order_id) from ( '+
    'select o.order_id, o.order_code '+
    'from orderitems oi '+
    'inner join statuses s on (s.status_id = oi.status_id and s.status_sign = :status_sign) '+
    'inner join orders o on (o.order_id = oi.order_id) '+
    'where o.product_id = :product_id '+
    'order by o.order_code)',
    0, [aProductId, aStatusSign]);
  if OrderList<> '' then
  begin
    FilePath:= Path['OrderRequests']+aArjName+'\';
    ForceDirectories(FilePath);
    CopyFile(Path['Stru']+'Clients.dbf', FilePath);
    dbfClients:= TDbf.Create(nil);
    dbfClients.FilePath:= FilePath;
    dbfClients.TableName:= 'Clients.dbf';

    CopyFile(Path['Stru']+'Orders.dbf', FilePath);
    dbfOrders:= TDbf.Create(nil);
    dbfOrders.FilePath:= FilePath;
    dbfOrders.TableName:= 'Orders.dbf';

    CopyFile(Path['Stru']+'Items.dbf', FilePath);
    dbfItems:= TDbf.Create(nil);
    dbfItems.FilePath:= FilePath;
    dbfItems.TableName:= 'Items.dbf';
    try
      dbfClients.Open;
      dbfOrders.Open;
      dbfItems.Open;
      while OrderList <> '' do
      begin
        OrderId:= TakeFront5(OrderList, ',');
        ExportOrder(aTransaction, ndProduct, ndOrders, OrderId, aStatusSign, dbfClients, dbfOrders, dbfItems);
      end;
    finally
      dbfClients.Close;
      dbfOrders.Close;
      dbfItems.Close;
    end
  end;
  dmOtto.CreateAlert('Отправка заявок', Format('Сформирован файл %s', [ExtractFileName(aArjName)]), mtInformation, 10000);
end;

end.
