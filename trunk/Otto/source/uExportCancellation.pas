unit uExportCancellation;
interface
uses
  Classes, SysUtils, FIBDatabase, pFIBDatabase, JvProgressComponent;

procedure ExportCancelRequest(aTransaction: TpFIBTransaction; aProgressIndicator: TJvProgressComponent);

implementation

uses
  NativeXml, GvNativeXml, udmOtto, GvStr, GvFile, GvDtTm, DateUtils;

var
  ProgressIndicator: TJvProgressComponent;

function ExportOrderItem(aTransaction: TpFIBTransaction;
  ndProduct, ndOrder: TXmlNode; aOrderItemId: integer): string;
var
  ndOrderItem: TXmlNode;
  Line: TStringList;
begin
  ndOrderItem:= ndOrder.NodeFindOrCreate('ORDERITEMS').NodeFindOrCreate('ORDERITEM');
  Line:= TStringList.Create;
  try
    dmOtto.ObjectGet(ndOrderItem, aOrderItemId, aTransaction);
    Line.Add(GetXmlAttr(ndProduct, 'PARTNER_NUMBER'));
    Line.Add(GetXmlAttr(ndOrder, 'CLIENT_ID'));
    Line.Add('900');
    Line.Add(FilterString(GetXmlAttr(ndOrder, 'ORDER_CODE'), '0123456789'));
    Line.Add('');
    Line.Add(GetXmlAttr(ndOrderItem, 'ARTICLE_CODE'));
    Line.Add(GetXmlAttr(ndOrderItem, 'DIMENSION'));
    Line.Add('1');
    dmOtto.ActionExecute(aTransaction, 'ORDERITEM_CANCELREQUESTSENT', ndOrderItem);
    Result:= ReplaceAll(Line.Text, #13#10, ';')+#13#10;
  finally
    Line.Free;
    ndOrderItem.Clear;
  end;
end;

function ExportOrder(aTransaction: TpFIBTransaction;
  ndProduct: TXmlNode; aOrderId: integer): string;
var
  OrderItemList: string;
  ndOrder: TXmlNode;
  OrderItemId: Variant;
begin
  ndOrder:= ndProduct.NodeFindOrCreate('ORDERS').NodeFindOrCreate('ORDER');
  try
    dmOtto.ObjectGet(ndOrder, aOrderId, aTransaction);
    OrderItemList:= aTransaction.DefaultDatabase.QueryValue(
      'select list(oi.orderitems) '+
      'from orderitems oi '+
      'inner join statuses s1 on (s1.status_id = oi.status_id and s1.status_sign = ''CANCELREQUEST'') '+
      'left join statuses s2 on (s2.status_id = oi.state_id and s2.status_sign <> ''CANCELREQUESTSENT'') '+
      'where o.order_id = :order_id',
      0, [aOrderId], aTransaction);
    while OrderItemList <> '' do
    begin
      OrderItemId:= TakeFront5(OrderItemList, ',');
      result:= Result + ExportOrderItem(aTransaction, ndProduct, ndOrder, OrderItemId);
    end;
  finally
    ndOrder.Clear;
  end;
end;

procedure ExportProduct(aTransaction: TpFIBTransaction;
  ndProducts: TXmlNode; aProductId: integer);
var
  ndProduct: TXmlNode;
  OrderList, FileName, Text: string;
  OrderId: variant;
begin
  Text:= '';
  ndProduct:= ndProducts.NodeFindOrCreate('PRODUCT');
  try
    dmOtto.ObjectGet(ndProduct, aProductId, aTransaction);
    OrderList:= aTransaction.DefaultDatabase.QueryValue(
      'select list(distinct o.order_id) '+
      'from orderitems oi '+
      'inner join statuses s1 on (s1.status_id = oi.status_id and s1.status_sign = ''CANCELREQUEST'') '+
      'left join statuses s2 on (s2.status_id = oi.state_id and s2.status_sign <> ''CANCELREQUESTSENT'') '+
      'inner join orders o on (o.order_id = oi.order_id) '+
      'where o.product_id = :product_id',
      0, [aProductId], aTransaction);
    while OrderList <> '' do
    begin
      OrderId:= TakeFront5(OrderList, ',');
      Text:= Text + ExportOrder(aTransaction, ndProduct, OrderId);
    end;
    FileName:= GetNextFileName(Format('%ss%s_%%.2u.%.3d', [
      Path['CancelRequests'], GetXmlAttrValue(ndProduct, 'PARTNER_NUMBER'),
      DayOfTheYear(Date)]));
    SaveStringAsFile(Text, FileName);
    // CreateOutgoingMessage(FileName);
  finally
    ndProduct.Clear;
  end;
end;

procedure ExportCancelRequest(aTransaction: TpFIBTransaction; aProgressIndicator: TJvProgressComponent);
var
  Xml: TNativeXml;
  ndProducts: TXmlNode;
  ProductId: Variant;
  ProductList: string;
begin
  ProgressIndicator:= aProgressIndicator;
  ProgressIndicator.ProgressMax:= aTransaction.DefaultDatabase.QueryValue(
    'select count(oi.orderitem_id) '+
    'from orderitems oi '+
    'inner join statuses s1 on (s1.status_id = oi.status_id and s1.status_sign = ''CANCELREQUEST'') '+
    'left join statuses s2 on (s2.status_id = oi.state_id and s2.status_sign <> ''CANCELREQUESTSENT'') '+
    'inner join orders o on (o.order_id = oi.order_id)',
    0, aTransaction);

  xml:= TNativeXml.CreateName('PRODUCTS');
  try
    ndProducts:= Xml.Root;
    ProductList:= aTransaction.DefaultDatabase.QueryValue(
      'select list(distinct o.product_id) '+
      'from orderitems oi '+
      'inner join statuses s1 on (s1.status_id = oi.status_id and s1.status_sign = ''CANCELREQUEST'') '+
      'left join statuses s2 on (s2.status_id = oi.state_id and s2.status_sign <> ''CANCELREQUESTSENT'') '+
      'inner join orders o on (o.order_id = oi.order_id)',
      0, aTransaction);
    while ProductList <> '' do
    begin
      ProductId:= TakeFront5(ProductList, ',');
      ExportProduct(aTransaction, ndProducts, ProductId);
    end;
  finally
    Xml.Free;
  end;
end;

end.
