unit uExportCancellation;
interface
uses
  Classes, SysUtils, FIBDatabase, pFIBDatabase, JvProgressComponent;

procedure ExportCancelRequest(aTransaction: TpFIBTransaction);

implementation

uses
  NativeXml, GvNativeXml, udmOtto, GvStr, GvFile, GvDtTm, DateUtils, Dialogs;

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
    Line.Add(CopyLast(GetXmlAttr(ndOrder, 'ORDER_CODE'), 5));
    Line.Add('900');
    Line.Add(GetXmlAttr(ndOrderItem, 'AUFTRAG_ID'));
    Line.Add(GetXmlAttr(ndOrderItem, 'ORDERITEM_INDEX'));
    Line.Add(GetXmlAttr(ndOrderItem, 'ARTICLE_CODE'));
    Line.Add(dmOtto.Recode('ARTICLE', 'DIMENSION_ENCODE', GetXmlAttr(ndOrderItem, 'DIMENSION')));
    Line.Add('1');
    SetXmlAttr(ndOrderItem, 'NEW.STATE_SIGN', 'CANCELREQUESTSENT');
    Result:= ReplaceAll(Line.Text, #13#10, ';')+#13#10;
    dmOtto.ActionExecute(aTransaction, ndOrderItem);
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
  Result:= '';
  ndOrder:= ndProduct.NodeFindOrCreate('ORDERS').NodeFindOrCreate('ORDER');
  try
    dmOtto.ObjectGet(ndOrder, aOrderId, aTransaction);
    OrderItemList:= aTransaction.DefaultDatabase.QueryValue(
      'select list(oi.orderitem_id) '+
      'from orderitems oi '+
      'inner join statuses s1 on (s1.status_id = oi.status_id and s1.status_sign = ''CANCELREQUEST'') '+
      'left join statuses s2 on (s2.status_id = oi.state_id) '+
      'where coalesce(s2.status_sign, '''')  <> ''CANCELREQUESTSENT'' '+
      '  and oi.order_id = :order_id',
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
    if not aTransaction.Active then
      aTransaction.StartTransaction;
    try
      dmOtto.ObjectGet(ndProduct, aProductId, aTransaction);
      OrderList:= aTransaction.DefaultDatabase.QueryValue(
        'select list(distinct o.order_id) '+
        'from orderitems oi '+
        'inner join statuses s1 on (s1.status_id = oi.status_id and s1.status_sign = ''CANCELREQUEST'') '+
        'left join statuses s2 on (s2.status_id = oi.state_id) '+
        'inner join orders o on (o.order_id = oi.order_id) '+
        'where coalesce(s2.status_sign, '''')  <> ''CANCELREQUESTSENT'' '+
        '  and o.product_id = :product_id',
        0, [aProductId], aTransaction);
      while OrderList <> '' do
      begin
        OrderId:= TakeFront5(OrderList, ',');
        Text:= Text + ExportOrder(aTransaction, ndProduct, OrderId);
      end;
      ForceDirectories(Path['CancelRequests']);
      FileName:= GetNextFileName(Format('%ss%s_%%.2u.%.3d', [
        Path['CancelRequests'], GetXmlAttrValue(ndProduct, 'PARTNER_NUMBER'),
        DayOfTheYear(Date)]));
      SaveStringAsFile(Text, FileName);
      dmOtto.CreateAlert('Запрос на ануляцию', Format('Сформирован файл %s', [ExtractFileName(FileName)]), mtInformation, 10000);
      aTransaction.Commit;
    except
      aTransaction.Rollback;
    end;
  finally
    ndProduct.Clear;
  end;
end;

procedure ExportCancelRequest(aTransaction: TpFIBTransaction);
var
  Xml: TNativeXml;
  ndProducts: TXmlNode;
  ProductId: Variant;
  ProductList: string;
begin
  xml:= TNativeXml.CreateName('PRODUCTS');
  try
    ndProducts:= Xml.Root;
    ProductList:= aTransaction.DefaultDatabase.QueryValue(
      'select list(distinct o.product_id) '+
      'from orderitems oi '+
      'inner join statuses s1 on (s1.status_id = oi.status_id and s1.status_sign = ''CANCELREQUEST'') '+
      'left join statuses s2 on (s2.status_id = oi.state_id) '+
      'inner join orders o on (o.order_id = oi.order_id)' +
      'where coalesce(s2.status_sign, '''')  <> ''CANCELREQUESTSENT''',
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
