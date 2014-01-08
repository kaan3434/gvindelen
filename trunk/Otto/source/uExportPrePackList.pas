unit uExportPrePackList;
interface
uses
  Classes, SysUtils, FIBDatabase, pFIBDatabase;

procedure ExportPrePackList(aTransaction: TpFIBTransaction);

implementation

uses
  GvXml, GvXmlUtils, udmOtto, GvStr, GvFile, DateUtils, Dialogs;

function ExportOrder(aTransaction: TpFIBTransaction;
  ndProduct, ndOrders: TGvXmlNode; aOrderId: integer): string;
var
  ndOrder: TGvXmlNode;
  Line: TStringList;
begin
  Result:= '';
  ndOrder:= ndOrders.FindOrCreate('ORDER');
  dmOtto.ObjectGet(ndOrder, aOrderId, aTransaction);
  Result:= FillPattern(
    '[PARTNER_NUMBER];[PACKLIST_NO];[ORDER_CODE|SUBSTR=2,5];[COST_BYR].00'#13#10,
    XmlAttrs2Attr(ndProduct, 'PARTNER_NUMBER',
    XmlAttrs2Attr(ndOrder, 'PACKLIST_NO;ORDER_CODE;COST_BYR')));
  ndOrder['INVOICE_BYR_0']:= ndOrder.Attr['COST_BYR'].AsMoney;
  ndOrder['INVOICE_EUR_0']:=  ndOrder.Attr['COST_EUR'].AsMoney;
  ndOrder['NEW.STATE_SIGN']:= 'PREPACKSENT';
  dmOtto.ActionExecute(aTransaction, ndOrder);
end;

procedure ExportPacklist(aTransaction: TpFIBTransaction;
  ndProduct, ndOrders: TGvXmlNode; aPacklistNo: integer);
var
  OrderList, FileName, Text: string;
  OrderId: Variant;
  PartnerNumber: Word;
begin
  Text:= '';
  try
    OrderList:= aTransaction.DefaultDatabase.QueryValue(
      'select list(distinct order_id) from ('+
      'select o.order_id '+
      'from orders o '+
      '  inner join statuses s1 on (s1.status_id = o.status_id and s1.status_sign = ''PREPACKED'') '+
      '  left join statuses s2 on (s2.status_id = o.state_id and s2.status_sign = ''PREPACKSENT'') '+
      'where coalesce(s2.status_sign, '''')  <> ''PREPACKSENT'' '+
      '  and o.packlist_no = :packlist_no '+
      'order by o.order_code)',
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
      [Path['PrePacklists'], Integer(ndProduct['PARTNER_NUMBER']),
       aPacklistNo, DayOfTheYear(Date)]);
    SaveStringAsFile(Text, FileName);
    dmOtto.CreateAlert('Ответ на ПреПаклист', Format('Сформирован файл %s', [ExtractFileName(FileName)]), mtInformation, 10000);
  finally
    dmOtto.InitProgress;
  end
end;

procedure ExportProduct(aTransaction: TpFIBTransaction;
  ndProducts: TGvXmlNode; aProductId: integer);
var
  ndProduct, ndOrders: TGvXmlNode;
  PackList, FileName, Text: string;
  PacklistNo: variant;
begin
  Text:= '';
  ndProduct:= ndProducts.FindOrCreate('PRODUCT');
  ndOrders:= ndProduct.AddChild('ORDERS');
  dmOtto.ObjectGet(ndProduct, aProductId, aTransaction);

  PackList:= aTransaction.DefaultDatabase.QueryValue(
        'select list(distinct o.packlist_no) '+
        'from orders o '+
        'inner join statuses s1 on (s1.status_id = o.status_id and s1.status_sign = ''PREPACKED'') '+
        'left join statuses s2 on (s2.status_id = o.state_id and s2.status_sign = ''PREPACKSENT'') '+
        'where coalesce(s2.status_sign, '''')  <> ''PREPACKSENT'' '+
        '  and o.product_id = :product_id',
        0, [aProductId], aTransaction);
  while PackList <> '' do
  begin
    PacklistNo:= TakeFront5(PackList, ',');
    ExportPacklist(aTransaction, ndProduct, ndOrders, PacklistNo);
  end;
end;

procedure ExportPrePackList(aTransaction: TpFIBTransaction);
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
        'from orders o '+
        ' inner join statuses s1 on (s1.status_id = o.status_id and s1.status_sign = ''PREPACKED'') '+
        ' left join statuses s2 on (s2.status_id = o.state_id and s2.status_sign = ''PREPACKSENT'') '+
        'where coalesce(s2.status_sign, '''')  <> ''PREPACKSENT''',
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
