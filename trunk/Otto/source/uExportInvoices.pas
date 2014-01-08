unit uExportInvoices;
interface
uses
  Classes, SysUtils, FIBDatabase, pFIBDatabase, JvProgressComponent;

procedure ExportInvoices(aTransaction: TpFIBTransaction);

implementation
uses
  udmOtto, GvXml, GvXmlUtils, GvStr, GvFile, DateUtils, Dialogs;

function ExportOrder(aTransaction: TpFIBTransaction;
  ndProduct, ndOrders: TGvXmlNode; aOrderId: integer): string;
var
  InvoiceList: string;
  ndOrder, ndInvoice: TGvXmlNode;
  InvoiceId: Variant;
begin
  Result:= '';
  ndOrder:= ndOrders.AddChild('ORDER');
  dmOtto.ObjectGet(ndOrder, aOrderId, aTransaction);
  result:=  FillPattern(
    '[PARTNER_NUMBER];[ORDER_CODE|SUBSTR=2,5];1'#13#10,
    XmlAttrs2Attr(ndProduct, 'PARTNER_NUMBER',
    XmlAttrs2Attr(ndOrder, 'ORDER_CODE'
  )));
  if not ndOrder.Attr['STATUS_SIGN'].ValueIn(['PAID']) then
    ndOrder['NEW.STATUS_SIGN']:= 'PAID';
  ndOrder['NEW.STATE_SIGN']:= 'PAYSENT';
  dmOtto.ActionExecute(aTransaction, ndOrder);
end;

procedure ExportProduct(aTransaction: TpFIBTransaction;
  ndProducts: TGvXmlNode; aProductId: integer);
var
  ndProduct, ndOrders: TGvXmlNode;
  OrderList, FileName, OrderText: string;
  OrderId: variant;
begin
  OrderText:= '';
  ndProduct:= ndProducts.FindOrCreate('PRODUCT');
  ndOrders:= ndProduct.AddChild('ORDERS');
  dmOtto.ObjectGet(ndProduct, aProductId, aTransaction);
  OrderList:= aTransaction.DefaultDatabase.QueryValue(
    'select list(distinct order_id) from ('+
    'select o.order_id '+
    'from orders o '+
    '  inner join statuses s1 on (s1.status_id = o.status_id and s1.status_sign in (''ACCEPTED'',''PAID'')) '+
    '  left join statuses s2 on (s2.status_id = o.state_id and s2.status_sign = ''PAYSENT'') '+
    '  inner join v_order_paid op on (op.order_id = o.order_id) '+
    'where o.product_id = :product_id '+
    '  and coalesce(s2.status_sign, '''') <> ''PAYSENT'' '+
    'order by o.order_code)',
    0, [aProductId], aTransaction);
  while OrderList <> '' do
  begin
    OrderId:= TakeFront5(OrderList, ',');
    OrderText:= OrderText + ExportOrder(aTransaction, ndProduct, ndOrders, OrderId);
  end;

  ForceDirectories(Path['PaidInvoices']);
  FileName:= GetNextFileName(Format('%szlg_%s_%%.2u.%.3d', [
    Path['PaidInvoices'], ndProduct['PARTNER_NUMBER'],
    DayOfTheYear(Date)]));
  SaveStringAsFile(OrderText, FileName);
  dmOtto.CreateAlert('Отправка платежей', Format('Сформирован файл %s', [ExtractFileName(FileName)]), mtInformation, 10000);
end;

procedure ExportInvoices(aTransaction: TpFIBTransaction);
var
  Xml: TGvXml;
  ndProducts: TGvXmlNode;
  ProductId: Variant;
  ProductList: string;
  Files: TStringList;
begin
  aTransaction.StartTransaction;
  try
    xml:= TGvXml.Create('PRODUCTS');
    try
      ndProducts:= Xml.Root;
      ProductList:= aTransaction.DefaultDatabase.QueryValue(
        'select list(distinct o.product_id) '+
        'from orders o '+
        '  inner join statuses s on (s.status_id = o.status_id and s.status_sign in (''ACCEPTED'',''PAID'')) '+
        '  inner join v_order_paid op on (op.order_id = o.order_id)',
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
      ShowMessage('Ошибка при формировании файлов: '+E.Message);
    end;
  end;
end;


end.
