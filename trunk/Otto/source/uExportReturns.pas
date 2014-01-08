unit uExportReturns;
interface
uses
  Classes, SysUtils, FIBDatabase, pFIBDatabase;

procedure ExportReturns(aTransaction: TpFIBTransaction);

implementation

uses
  GvXml, GvXmlUtils, udmOtto, GvStr, GvFile, GvDtTm, DateUtils, Dialogs;

//var
//  ProgressIndicator: TJvProgressComponent;

function ExportOrderItem(aTransaction: TpFIBTransaction;
  ndProduct, ndOrder, ndOrderItems: TGvXmlNode; aOrderItemId: integer): string;
var
  ndOrderItem: TGvXmlNode;
  Line: TStringList;
begin
  ndOrderItem:= ndOrderItems.AddChild('ORDERITEM');
  Result:= FillPattern(
    '[PARTNER_NUMBER];[ORDER_CODE|SUBSTR=2,5];300;[AUFTRAG_ID];[ORDERITEM_INDEX];'+
    '[ARTICLE_CODE];[DIMENSION];1;[NRRETCODE];[NREGWG];[PACKLIST_NO];[PRICE_EUR]'#13#10,
    XmlAttrs2Attr(ndProduct, 'PARTNER_NUMBER',
    XmlAttrs2Attr(ndOrder, 'ORDER_CODE;PACKLIST_NO',
    XmlAttrs2Attr(ndOrderItem, 'AUFTRAG_ID;ORDERITEM_INDEX;ARTICLE_CODE;NRRETCODE;NREGWG;PRICE_EUR',
    Value2Attr(dmOtto.Recode('ORDERITEM', 'DIMENSION_ENCODE', ndOrderItem['DIMENSION']), 'DIMENSION'
  )))));
  ndOrderItem['NEW.STATE_SIGN']:= 'RETURNSENT';
  dmOtto.ActionExecute(aTransaction, ndOrderItem);
end;

function ExportOrder(aTransaction: TpFIBTransaction;
  ndProduct, ndOrders: TGvXmlNode; aOrderId: integer): string;
var
  OrderItemList: string;
  ndOrder, ndOrderItems: TGvXmlNode;
  OrderItemId: Variant;
begin
  Result:= '';
  ndOrder:= ndOrders.AddChild('ORDER');
  ndOrderItems:= ndOrder.AddChild('ORDERITEMS');

  dmOtto.ObjectGet(ndOrder, aOrderId, aTransaction);
  OrderItemList:= aTransaction.DefaultDatabase.QueryValue(
    'select list(orderitem_id) from ('+
    'select oi.orderitem_id '+
    'from orderitems oi '+
    '  inner join statuses s1 on (s1.status_id = oi.status_id and s1.status_sign in (''RETURNING'',''DISCARDED'')) '+
    '  left join statuses s2 on (s2.status_id = oi.state_id) '+
    'where coalesce(s2.status_sign, '''')  <> ''RETURNSENT'' '+
    '  and oi.order_id = :order_id '+
    'order by oi.auftrag_id,oi.orderitem_index)',
    0, [aOrderId], aTransaction);
  while OrderItemList <> '' do
  begin
    OrderItemId:= TakeFront5(OrderItemList, ',');
    result:= Result + ExportOrderItem(aTransaction, ndProduct, ndOrder, ndOrderItems, OrderItemId);
  end;
end;

procedure ExportProduct(aTransaction: TpFIBTransaction;
  ndProducts: TGvXmlNode; aProductId: integer);
var
  ndProduct, ndOrders: TGvXmlNode;
  OrderList, FileName, Text: string;
  OrderId: variant;
begin
  Text:= '';
  ndProduct:= ndProducts.FindOrCreate('PRODUCT');
  ndOrders:= ndProduct.AddChild('ORDERS');

  dmOtto.ObjectGet(ndProduct, aProductId, aTransaction);
  OrderList:= aTransaction.DefaultDatabase.QueryValue(
    'select list(distinct order_id) from ('+
    'select o.order_id '+
    'from orderitems oi '+
    '  inner join statuses s1 on (s1.status_id = oi.status_id and s1.status_sign in (''RETURNING'',''DISCARDED'')) '+
    '  left join statuses s2 on (s2.status_id = oi.state_id) '+
    '  inner join orders o on (o.order_id = oi.order_id) '+
    'where coalesce(s2.status_sign, '''')  <> ''RETURNSENT'' '+
    '  and o.product_id = :product_id '+
    'order by o.order_code)',
    0, [aProductId], aTransaction);
  while OrderList <> '' do
  begin
    OrderId:= TakeFront5(OrderList, ',');
    Text:= Text + ExportOrder(aTransaction, ndProduct, ndOrders, OrderId);
  end;
  ForceDirectories(Path['ReturnRequests']);
  FileName:= GetNextFileName(Format('%ss%s_%%.2u.%.3d', [
    Path['ReturnRequests'], ndProduct['PARTNER_NUMBER'],
    DayOfTheYear(Date)]));
  SaveStringAsFile(Text, FileName);
  dmOtto.CreateAlert('Запрос на возврат', Format('Сформирован файл %s', [ExtractFileName(FileName)]), mtInformation, 10000);
end;

procedure ExportReturns(aTransaction: TpFIBTransaction);
var
  Xml: TGvXml;
  ndProducts: TGvXmlNode;
  ProductId: Variant;
  ProductList: string;
begin
  aTransaction.StartTransaction;
  try
    xml:= TGvXml.Create('PRODUCTS');
    try
      ndProducts:= Xml.Root;
      ProductList:= aTransaction.DefaultDatabase.QueryValue(
        'select list(distinct o.product_id) '+
        'from orderitems oi '+
        '  inner join statuses s1 on (s1.status_id = oi.status_id and s1.status_sign in (''RETURNING'',''DISCARDED'')) '+
        '  left join statuses s2 on (s2.status_id = oi.state_id) '+
        '  inner join orders o on (o.order_id = oi.order_id) ' +
        'where coalesce(s2.status_sign, '''')  <> ''RETURNSENT''',
         0, aTransaction);
      while ProductList <> '' do
      begin
        ProductId:= TakeFront5(ProductList, ',');
        ExportProduct(aTransaction, ndProducts, ProductId);
      end;
      dmOtto.ExportCommitRequest(ndProducts, aTransaction);
    finally
      Xml.Free;
    end;
  except
    on E: Exception do
    begin
      aTransaction.Rollback;
      ShowMessage('Ошибка при формировании файлов: '+e.Message);
    end;
  end;

end;

end.
