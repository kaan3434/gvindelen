unit uExportReturns;
interface
uses
  Classes, SysUtils, FIBDatabase, pFIBDatabase;

procedure ExportReturns(aTransaction: TpFIBTransaction);

implementation

uses
  NativeXml, GvNativeXml, udmOtto, GvStr, GvFile, GvDtTm, DateUtils, Dialogs;

//var
//  ProgressIndicator: TJvProgressComponent;

function ExportOrderItem(aTransaction: TpFIBTransaction;
  ndProduct, ndOrder, ndOrderItems: TXmlNode; aOrderItemId: integer): string;
var
  ndOrderItem: TXmlNode;
  Line: TStringList;
begin
  ndOrderItem:= ndOrderItems.NodeNew('ORDERITEM');
  Line:= TStringList.Create;
  try
    dmOtto.ObjectGet(ndOrderItem, aOrderItemId, aTransaction);
    Line.Add(GetXmlAttr(ndProduct, 'PARTNER_NUMBER'));
    Line.Add(CopyLast(GetXmlAttr(ndOrder, 'ORDER_CODE'), 5));
    Line.Add('300');
    Line.Add(GetXmlAttr(ndOrderItem, 'AUFTRAG_ID'));
    Line.Add(GetXmlAttr(ndOrderItem, 'ORDERITEM_INDEX'));
    Line.Add(GetXmlAttr(ndOrderItem, 'ARTICLE_CODE'));
    Line.Add(dmOtto.Recode('ORDERITEM', 'DIMENSION_ENCODE', GetXmlAttr(ndOrderItem, 'DIMENSION')));
    Line.Add('1');
    Line.Add(GetXmlAttr(ndOrderItem, 'NRRETCODE'));
    Line.Add(GetXmlAttr(ndOrderItem, 'NREGWG'));
    Line.Add(GetXmlAttr(ndOrder, 'PACKLIST_NO'));
    Line.Add(ReplaceAll(GetXmlAttrAsMoney(ndOrderItem, 'PRICE_EUR'),'.', ','));
    Result:= ReplaceAll(Line.Text, #13#10, ';')+#13#10;
    SetXmlAttr(ndOrderItem, 'NEW.STATE_SIGN', 'RETURNSENT');
    dmOtto.ActionExecute(aTransaction, ndOrderItem);
  finally
    Line.Free;
  end;
end;

function ExportOrder(aTransaction: TpFIBTransaction;
  ndProduct, ndOrders: TXmlNode; aOrderId: integer): string;
var
  OrderItemList: string;
  ndOrder, ndOrderItems: TXmlNode;
  OrderItemId: Variant;
begin
  Result:= '';
  ndOrder:= ndOrders.NodeNew('ORDER');
  ndOrderItems:= ndOrder.NodeNew('ORDERITEMS');

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
  ndProducts: TXmlNode; aProductId: integer);
var
  ndProduct, ndOrders: TXmlNode;
  OrderList, FileName, Text: string;
  OrderId: variant;
begin
  Text:= '';
  ndProduct:= ndProducts.NodeFindOrCreate('PRODUCT');
  ndOrders:= ndProduct.NodeNew('ORDERS');

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
    Path['ReturnRequests'], GetXmlAttrValue(ndProduct, 'PARTNER_NUMBER'),
    DayOfTheYear(Date)]));
  SaveStringAsFile(Text, FileName);
  dmOtto.CreateAlert('Запрос на возврат', Format('Сформирован файл %s', [ExtractFileName(FileName)]), mtInformation, 10000);
end;

procedure ExportReturns(aTransaction: TpFIBTransaction);
var
  Xml: TNativeXml;
  ndProducts: TXmlNode;
  ProductId: Variant;
  ProductList: string;
begin
  aTransaction.StartTransaction;
  try
    xml:= TNativeXml.CreateName('PRODUCTS');
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
