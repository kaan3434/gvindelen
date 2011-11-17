unit uExportPackList;

interface
uses
  Classes, NativeXml, FIBDatabase, pFIBDatabase;

procedure ExpotyPackList(aTransaction: TpFIBTransaction);

implementation
uses
  GvNativeXml, udmOtto, GvStr;

procedure ExportProduct(aTransaction: TpFIBTransaction;
  ndProducts: TXmlNode; aProductId: integer);
var
  ndProduct: TXmlNode;
  OrderList, FileName, OrderText: string;
  OrderId: variant;
  TConsName, TConspi3Name: string;
begin
  TConsName:= Format('%st-cons_%s_
  copyFile(Path['Stru']+'tcons.dbf', Path['PackedOrders']+'t-cons_'
  ndProduct:= ndProducts.NodeFindOrCreate('PRODUCT');
  try
    dmOtto.ObjectGet(ndProduct, aProductId, aTransaction);
    OrderList:= aTransaction.DefaultDatabase.QueryValue(
      'select list(distinct o.order_id) '+
      'from orders o '+
      'inner join statuses s on (s.status_id = i.status_id and s.status_sign = ''PACKED'') '+
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
        'inner join statuses s on (s.status_id = i.status_id and s.status_sign = ''PACKED'') ',
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
