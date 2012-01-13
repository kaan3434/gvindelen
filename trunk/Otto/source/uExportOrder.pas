unit uExportOrder;
interface
uses
  Classes, SysUtils, FIBDatabase, pFIBDatabase, JvProgressComponent;

procedure ExportApprovedOrder(aTransaction: TpFIBTransaction);

implementation
uses
  udmOtto, NativeXml, GvNativeXml, GvStr, GvMath, GvFile, DateUtils, Dialogs;

var
  ProgressIndicator: TJvProgressComponent;

function GetPlace(ndPlace: TXmlNode; MaxLen: integer): string;
begin
  if GetXmlAttrValue(ndPlace, 'PLACETYPE_CODE', '4') = 4 then
    Result:= Translit(GetXmlAttr(ndPlace, 'PLACE_NAME'))
  else
    Result:= Translit(GetXmlAttr(ndPlace, 'PLACETYPE_SIGN') +
                     GetXmlAttr(ndPlace, 'PLACE_NAME', '. '));
end;

function GetAdress(ndAdress: TXmlNode; MaxLen: integer): string;
var
  Part1, Part2: string;
begin
   if GetXmlAttrValue(ndAdress, 'STREETTYPE_CODE', '1') > 1 then
     Part1:= Translit(GetXmlAttr(ndAdress, 'STREETTYPE_NAME', ' ', '. ') +
                      GetXmlAttr(ndAdress, 'STREET_NAME'))
   else
     Part1:= Translit(GetXmlAttr(ndAdress, 'STREET_NAME'));

   Part2:= Translit(GetXmlAttr(ndAdress, 'HOUSE', ', ') +
                    GetXmlAttr(ndAdress, 'BUILDING', '/') +
                    GetXmlAttr(ndAdress, 'FLAT', '-'));
   Result:= Part1 + Part2;
   if Length(Result) <= MaxLen then Exit;
   Result:= Copy(Part1, 1, MaxLen-Length(Part2)-1)+'.'+Part2;
end;

function ExportClient(aTransaction: TpFIBTransaction;
  ndProduct: TXmlNode; aOrderId: integer): string;
var
  OrderItemList: string;
  ndOrder, ndClient, ndAdress, ndPlace: TXmlNode;
  OrderItemId: Variant;
  Line: TStringList;
begin
  ndOrder:= ndProduct.NodeFindOrCreate('ORDERS').NodeFindOrCreate('ORDER');
  ndClient:= ndOrder.NodeFindOrCreate('CLIENT');
  ndAdress:= ndOrder.NodeFindOrCreate('ADRESS');
  ndPlace:= ndAdress.NodeFindOrCreate('PLACE');
  Line:= TStringList.Create;
  try
    dmOtto.ObjectGet(ndOrder, aOrderId, aTransaction);
    dmOtto.ObjectGet(ndClient, GetXmlAttrValue(ndOrder, 'CLIENT_ID'), aTransaction);
    dmOtto.ObjectGet(ndAdress, GetXmlAttrValue(ndOrder, 'ADRESS_ID'), aTransaction);
    dmOtto.ObjectGet(ndPlace, GetXmlAttrValue(ndAdress, 'PLACE_ID'), aTransaction);
    ndOrder.ValueAsBool:= True;
    ndOrder.Document.XmlFormat:= xfReadable;
    ndOrder.Document.SaveToFile('Order.xml');

    Line.Add(GetXmlAttr(ndProduct, 'PARTNER_NUMBER'));
    Line.Add(FilterString(GetXmlAttr(ndOrder, 'ORDER_CODE'), '0123456789'));
    Line.Add('100');
    Line.Add(IfThen(LastChar(GetXmlAttr(ndClient, 'FIRST_NAME')) in ['а', 'я'], '3', '1'));
    Line.Add(Translit(GetXmlAttr(ndClient, 'LAST_NAME')));
    Line.Add(Translit(GetXmlAttr(ndClient, 'FIRST_NAME') + ' '+ Copy(GetXmlAttr(ndClient, 'MID_NAME'), 1, 1)));
    Line.Add('');
    Line.Add(GetAdress(ndAdress, 32));
    Line.Add(Translit(GetXmlAttr(ndPlace, 'AREA_NAME', '', ' r-n')));
    Line.Add(GetXmlAttr(ndAdress, 'POSTINDEX'));
    Line.Add(GetPlace(ndPlace, 24));
    Line.Add(IfThen(XmlAttrIn(ndClient, 'STATUS_SIGN', 'APPROVED'), 'N', 'U'));
    Result:= ReplaceAll(Line.Text, #13#10, ';')+#13#10;
    if XmlAttrIn(ndOrder, 'STATUS_SIGN', 'APPROVED') then
      dmOtto.ActionExecute(aTransaction, ndOrder, 'ACCEPTREQUEST');
  finally
    Line.Free;
    ndOrder.Clear;
  end;
end;

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
    ndOrderItem.ValueAsBool:= True;
    Line.Add(GetXmlAttr(ndProduct, 'PARTNER_NUMBER'));
    Line.Add(FilterString(GetXmlAttr(ndOrder, 'ORDER_CODE'), '0123456789'));
    Line.Add('200');
    Line.Add(FilterString(GetXmlAttr(ndOrder, 'ORDER_CODE'), '0123456789'));
    Line.Add(GetXmlAttr(ndOrderItem, 'ARTICLE_CODE'));
    Line.Add(dmOtto.Recode('ARTICLE', 'DIMENSION_ENCODE', GetXmlAttr(ndOrderItem, 'DIMENSION')));
    Line.Add('1');
    Line.Add(GetXmlAttr(ndOrderItem, 'COST_EUR'));
    Line.Add('');
    Line.Add('');
    Line.Add('');
    Line.Add('0');
    Result:= ReplaceAll(Line.Text, #13#10, ';')+#13#10;
    if not XmlAttrIn(ndOrder, 'STATUS_SIGN', 'APPROVED') then
      dmOtto.ActionExecute(aTransaction, ndOrderItem, 'ACCEPTREQUEST');
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
      'inner join statuses s1 on (s1.status_id = oi.status_id and s1.status_sign = ''APPROVED'') '+
      'left join statuses s2 on (s2.status_id = oi.state_id and s2.status_sign <> ''ACCEPTREQUESTSENT'') '+
      'where oi.order_id = :order_id',
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
  OrderList, FileName, ClientText, OrderItemText: string;
  OrderId: variant;
begin
  ndProduct:= ndProducts.NodeFindOrCreate('PRODUCT');
  try
    dmOtto.ObjectGet(ndProduct, aProductId, aTransaction);
    OrderList:= aTransaction.DefaultDatabase.QueryValue(
      'select list(distinct o.order_id) '+
      'from orderitems oi '+
      'inner join statuses s1 on (s1.status_id = oi.status_id and s1.status_sign = ''APPROVED'') '+
      'left join statuses s2 on (s2.status_id = oi.state_id and s2.status_sign <> ''ACCEPTREQUESTSENT'') '+
      'inner join orders o on (o.order_id = oi.order_id) '+
      'where o.product_id = :product_id',
      0, [aProductId], aTransaction);
    while OrderList <> '' do
    begin
      OrderId:= TakeFront5(OrderList, ',');
      OrderItemText:= OrderItemText + ExportOrder(aTransaction, ndProduct, OrderId);
      ClientText:= ClientText + ExportClient(aTransaction, ndProduct, OrderId);
    end;

    FileName:= GetNextFileName(Format('%sa%s_%%.2u.%.3d', [
      Path['OrderRequests'], GetXmlAttrValue(ndProduct, 'PARTNER_NUMBER'),
      DayOfTheYear(Date)]));
    ForceDirectories(ExtractFileDir(FileName));
    SaveStringAsFile(ClientText+OrderItemText, FileName);
    dmOtto.CreateAlert('Отправка заявок', Format('Сформирован файл %s', [ExtractFileName(FileName)]), mtInformation, 10000);
    // CreateOutgoingMessage(FileName);
  finally
    ndProduct.Clear;
  end;
end;

procedure ExportApprovedOrder(aTransaction: TpFIBTransaction);
var
  Xml: TNativeXml;
  ndProducts: TXmlNode;
  ProductId: Variant;
  ProductList: string;
begin
  if aTransaction.Active then aTransaction.Rollback;
  aTransaction.StartTransaction;
  try
    xml:= TNativeXml.CreateName('PRODUCTS');
    try
      ndProducts:= Xml.Root;
      ProductList:= aTransaction.DefaultDatabase.QueryValue(
        'select list(distinct o.product_id) '+
        'from orderitems oi '+
        'inner join statuses s1 on (s1.status_id = oi.status_id and s1.status_sign = ''APPROVED'') '+
        'left join statuses s2 on (s2.status_id = oi.state_id and s2.status_sign <> ''ACCEPTREQUESTSENT'') '+
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
    aTransaction.Commit;
  except
    aTransaction.Rollback;
  end;
end;

end.
