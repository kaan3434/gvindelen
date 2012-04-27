unit uExportPrePackList;
interface
uses
  Classes, SysUtils, FIBDatabase, pFIBDatabase;

procedure ExportPrePackList(aTransaction: TpFIBTransaction);

implementation

uses
  NativeXml, GvNativeXml, udmOtto, GvStr, GvFile, DateUtils, Dialogs;

function ExportOrder(aTransaction: TpFIBTransaction;
  ndProduct, ndOrders: TXmlNode; aOrderId: integer): string;
var
  ndOrder: TXmlNode;
  Line: TStringList;
  Byr2Eur, CostByr, CostEur: Variant;
begin
  Result:= '';
  ndOrder:= ndOrders.NodeFindOrCreate('ORDER');
  Line:= TStringList.Create;
  try
    dmOtto.ObjectGet(ndOrder, aOrderId, aTransaction);
    CostByr:= aTransaction.DefaultDatabase.QueryValue(
      'select cost_byr '+
      'from v_order_summary os '+
      'where os.order_id = :order_id',
      0, [aOrderId], aTransaction);
    CostEur:= aTransaction.DefaultDatabase.QueryValue(
      'select cost_eur '+
      'from v_order_summary os '+
      'where os.order_id = :order_id',
      0, [aOrderId], aTransaction);

    Line.Add(GetXmlAttr(ndProduct, 'PARTNER_NUMBER'));
    Line.Add(GetXmlAttr(ndOrder, 'PACKLIST_NO'));
    Line.Add(CopyLast(GetXmlAttr(ndOrder, 'ORDER_CODE'), 5));
    Line.Add(CostByr+'.00');
    SetXmlAttr(ndOrder, 'INVOICE_BYR_0', CostByr);
    SetXmlAttr(ndOrder, 'INVOICE_EUR_0', CostEur);
    SetXmlAttr(ndOrder, 'NEW.STATE_SIGN', 'PREPACKSENT');
    Result:= ReplaceAll(Line.Text, #13#10, ';')+#13#10;
    Result:= ReplaceAll(Result, ';'#13#10, #13#10);
    dmOtto.ActionExecute(aTransaction, ndOrder);
  finally
    Line.Free;
    ndOrder.Clear;
  end;
end;

procedure ExportPacklist(aTransaction: TpFIBTransaction;
  ndProduct: TXmlNode; aPacklistNo: integer);
var
  OrderList, FileName, Text: string;
  ndOrders: TXmlNode;
  OrderId: Variant;
  PartnerNumber: Word;
begin
  Text:= '';
  ndOrders:= ndProduct.NodeFindOrCreate('ORDERS');
  try
    OrderList:= aTransaction.DefaultDatabase.QueryValue(
      'select list(distinct o.order_id) '+
      'from orders o '+
      'inner join v_order_attrs oa on (oa.object_id = o.order_id and oa.attr_sign = ''PACKLIST_NO'') '+
      'inner join statuses s1 on (s1.status_id = o.status_id and s1.status_sign = ''PREPACKED'') '+
      'left join statuses s2 on (s2.status_id = o.state_id and s2.status_sign = ''PREPACKSENT'') '+
      'where coalesce(s2.status_sign, '''')  <> ''PREPACKSENT'' '+
      '  and oa.attr_value = :packlist_no',
      0, [aPacklistNo], aTransaction);
    dmOtto.InitProgress(WordCount(OrderList,','), 'Формирование ответа на ПреПаклист');
    while OrderList <> '' do
    begin
      OrderId:= TakeFront5(OrderList, ',');
      Text:= Text + ExportOrder(aTransaction, ndProduct, ndOrders, OrderId);
      dmOtto.StepProgress;
    end;
    ForceDirectories(Path['PrePacklists']);
    FileName:= Format('%spay_%u_%u.%.3u',
      [Path['PrePacklists'], Integer(GetXmlAttrValue(ndProduct, 'PARTNER_NUMBER')),
       aPacklistNo, DayOfTheYear(Date)]);
    SaveStringAsFile(Text, FileName);
    dmOtto.CreateAlert('Ответ на ПреПаклист', Format('Сформирован файл %s', [ExtractFileName(FileName)]), mtInformation, 10000);
  finally
    dmOtto.InitProgress;
    ndOrders.Delete;
  end
end;

procedure ExportProduct(aTransaction: TpFIBTransaction;
  ndProducts: TXmlNode; aProductId: integer);
var
  ndProduct: TXmlNode;
  PackList, FileName, Text: string;
  PacklistNo: variant;
begin
  Text:= '';
  ndProduct:= ndProducts.NodeFindOrCreate('PRODUCT');
  try
    if not aTransaction.Active then
      aTransaction.StartTransaction;
    try
      dmOtto.ObjectGet(ndProduct, aProductId, aTransaction);
      PackList:= aTransaction.DefaultDatabase.QueryValue(
        'select list(distinct oa.attr_value) '+
        'from orders o '+
        'inner join v_order_attrs oa on (oa.object_id = o.order_id and oa.attr_sign = ''PACKLIST_NO'') '+
        'inner join statuses s1 on (s1.status_id = o.status_id and s1.status_sign = ''PREPACKED'') '+
        'left join statuses s2 on (s2.status_id = o.state_id and s2.status_sign = ''PREPACKSENT'') '+
        'where coalesce(s2.status_sign, '''')  <> ''PREPACKSENT'' '+
        '  and o.product_id = :product_id',
        0, [aProductId], aTransaction);
      while PackList <> '' do
      begin
        PacklistNo:= TakeFront5(PackList, ',');
        ExportPacklist(aTransaction, ndProduct, PacklistNo);
      end;
      aTransaction.Commit;
    except
      aTransaction.Rollback;
    end;
  finally
    ndProduct.Delete;
  end;
end;

procedure ExportPrePackList(aTransaction: TpFIBTransaction);
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
      'from orders o '+
      'inner join statuses s1 on (s1.status_id = o.status_id and s1.status_sign = ''PREPACKED'') '+
      'left join statuses s2 on (s2.status_id = o.state_id and s2.status_sign = ''PREPACKSENT'') '+
      'where coalesce(s2.status_sign, '''')  <> ''PREPACKSENT''',
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
