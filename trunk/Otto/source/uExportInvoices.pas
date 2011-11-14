unit uExportInvoices;
interface
uses
  Classes, SysUtils, FIBDatabase, pFIBDatabase, JvProgressComponent;

procedure ExportInvoices(aTransaction: TpFIBTransaction);

implementation
uses
  udmOtto, NativeXml, GvNativeXml, GvStr, GvMath, GvFile, DateUtils, Dialogs;

function ExportOrder(aTransaction: TpFIBTransaction;
  ndProduct: TXmlNode; aOrderId: integer): string;
var
  InvoiceList: string;
  ndOrder, ndInvoice: TXmlNode;
  InvoiceId: Variant;
begin
  Result:= '';
  ndOrder:= ndProduct.NodeFindOrCreate('ORDERS').NodeFindOrCreate('ORDER');
  try
    dmOtto.ObjectGet(ndOrder, aOrderId, aTransaction);
    result:= GetXmlAttr(ndProduct, 'PARTNER_NUMBER')+';'+
             FilterString(GetXmlAttr(ndorder, 'ORDER_CODE'), '0123456789')+';1'#13#10;
    InvoiceList:= aTransaction.DefaultDatabase.QueryValue(
      'select list(i.invoice_id) '+
      'from invoices i '+
      'where i.order_id = :order_id',
      0, [aOrderId], aTransaction);
    ndInvoice:= ndOrder.NodeNew('INVOICE');
    while InvoiceList <> '' do
    begin
      InvoiceId:= TakeFront5(InvoiceList, ',');
      dmOtto.ObjectGet(ndInvoice, InvoiceId, aTransaction);
      SetXmlAttr(ndInvoice, 'NEW.STATUS_SIGN', 'PAYSENT');
      dmOtto.ActionExecute(aTransaction, ndInvoice);
    end;
  finally
    ndOrder.Clear;
  end;
end;

procedure ExportProduct(aTransaction: TpFIBTransaction;
  ndProducts: TXmlNode; aProductId: integer);
var
  ndProduct: TXmlNode;
  OrderList, FileName, OrderText: string;
  OrderId: variant;
begin
  ndProduct:= ndProducts.NodeFindOrCreate('PRODUCT');
  try
    dmOtto.ObjectGet(ndProduct, aProductId, aTransaction);
    OrderList:= aTransaction.DefaultDatabase.QueryValue(
      'select list(distinct o.order_id) '+
      'from invoices i '+
      'inner join statuses s on (s.status_id = i.status_id and s.status_sign = ''PAID'') '+
      'inner join orders o on (o.order_id = i.order_id)'+
      'where o.product_id = :product_id',
      0, [aProductId], aTransaction);
    while OrderList <> '' do
    begin
      OrderId:= TakeFront5(OrderList, ',');
      OrderText:= OrderText + ExportOrder(aTransaction, ndProduct, OrderId);
    end;

    FileName:= GetNextFileName(Format('%szlg_%s_%%.2u.%.3d', [
      Path['PaidInvoices'], GetXmlAttrValue(ndProduct, 'PARTNER_NUMBER'),
      DayOfTheYear(Date)]));
    ForceDirectories(ExtractFileDir(FileName));
    SaveStringAsFile(OrderText, FileName);
    dmOtto.CreateAlert('Отправка платежей', Format('Сформирован файл %s', [ExtractFileName(FileName)]), mtInformation, 10000);
  finally
    ndProduct.Clear;
  end;
end;

procedure ExportInvoices(aTransaction: TpFIBTransaction);
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
        'from invoices i '+
        'inner join statuses s on (s.status_id = i.status_id and s.status_sign = ''PAID'') '+
        'inner join orders o on (o.order_id = i.order_id)',
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
