unit uReportReturnedOrderItems;

interface
uses
  NativeXml, FIBDatabase, pFIBDatabase, frxClass;

procedure ReportReturnedOrderItems(aTransaction: TpFIBTransaction; frxReport: TFrxReport);

implementation

uses
  udmOtto, GvStr, GvFile, SysUtils, GvNativeXml, DateUtils;

procedure ExportProduct(aTransaction: TpFIBTransaction; ndProducts: TXmlNode; aProductId: Integer);
var
  ndProduct: TXmlNode;
  OrderItemList, FileName, Text: string;
  OrderItemId: variant;
begin
  ndProduct:= ndProducts.NodeFindOrCreate('PRODUCT');
  try
    if not aTransaction.Active then
      aTransaction.StartTransaction;
    try
      dmOtto.ObjectGet(ndProduct, aProductId, aTransaction);
      OrderItemList:= aTransaction.DefaultDatabase.QueryValue(
        'select list(distinct o.orderitem_id) '+
        'from orderitems oi '+
        'inner join statuses s1 on (s1.status_id = oi.status_id and s1.status_sign = ''RETURNING'') '+
        'left join statuses s2 on (s2.status_id = oi.state_id) '+
        'inner join orders o on (o.order_id = oi.order_id) '+
        'where coalesce(s2.status_sign, '''')  <> ''RETURNSENTVILNIUS'' '+
        '  and o.product_id = :product_id',
        0, [aProductId], aTransaction);
      while OrderItemList <> '' do
      begin
        OrderItemId:= TakeFront5(OrderItemList, ',');
//        ExportOrderItem(aTransaction, ndProduct, OrderItemId);
      end;
      ForceDirectories(Path['ReturnRequests']);
      FileName:= GetNextFileName(Format('%sr%s_%%.2u.%.3d', [
        Path['ReturnRequests'], GetXmlAttrValue(ndProduct, 'PARTNER_NUMBER'),
        DayOfTheYear(Date)]));
      SaveStringAsFile(Text, FileName);
//      dmOtto.CreateAlert('Запрос на ануляцию', Format('Сформирован файл %s', [ExtractFileName(FileName)]), mtInformation, 10000);
      aTransaction.Commit;
    except
      aTransaction.Rollback;
    end;
  finally
    ndProduct.Clear;
  end;
end;


procedure ReportReturnedOrderItems(aTransaction: TpFIBTransaction; frxReport: TFrxReport);
var
  Orders: string;
  OrderId: Variant;
  xml: TNativeXml;
  ndOrder: TXmlNode;
begin
  xml:= TNativeXml.CreateName('Order');
  try
    ndOrder:= xml.Root;
    frxReport.LoadFromFile(Path['FastReport']+'OrderItemReturns.fr3');
    frxReport.PrepareReport(true);
    frxReport.ShowPreparedReport;
  finally
  end;
end;

procedure ExportReturns(aTransaction: TpFIBTransaction; frxReport: TFrxReport);
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
      'from v_orderitems_returning oi',
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
