unit uExportInvoices;
interface
uses
  Classes, SysUtils, FIBDatabase, pFIBDatabase, JvProgressComponent;

procedure ExportInvoices(aTransaction: TpFIBTransaction);

implementation
uses
  udmOtto, NativeXml, GvNativeXml, GvStr, GvFile, DateUtils, Dialogs;

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
             CopyLast(GetXmlAttr(ndorder, 'ORDER_CODE'), 5)+';1'#13#10;
    if GetXmlAttr(ndOrder, 'STATUS_SIGN') <> 'PAID' then
      SetXmlAttr(ndOrder, 'NEW.STATUS_SIGN', 'PAID');
    SetXmlAttr(ndOrder, 'NEW.STATE_SIGN', 'PAYSENT');
    dmOtto.ActionExecute(aTransaction, ndOrder);
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
  OrderText:= '';
  ndProduct:= ndProducts.NodeFindOrCreate('PRODUCT');
  try
    if not aTransaction.Active then
      aTransaction.StartTransaction;
    try
      dmOtto.ObjectGet(ndProduct, aProductId, aTransaction);
      OrderList:= aTransaction.DefaultDatabase.QueryValue(
        'select list(distinct o.order_id) '+
        'from orders o '+
        '  inner join statuses s on (s.status_id = o.status_id and s.status_sign in (''ACCEPTED'',''PAID'')) '+
        '  inner join v_order_paid op on (op.order_id = o.order_id) '+
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
      aTransaction.Commit;
      dmOtto.CreateAlert('Отправка платежей', Format('Сформирован файл %s', [ExtractFileName(FileName)]), mtInformation, 10000);
    except
      aTransaction.Rollback;
    end;
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
  xml:= TNativeXml.CreateName('PRODUCTS');
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
  finally
    Xml.Free;
  end;
end;


end.
