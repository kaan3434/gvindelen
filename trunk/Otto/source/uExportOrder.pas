unit uExportOrder;
interface
uses
  Classes, SysUtils, FIBDatabase, pFIBDatabase, Controls;

procedure ExportApprovedOrder(aTransaction: TpFIBTransaction);

implementation
uses
  udmOtto, NativeXml, GvNativeXml, GvStr, GvMath, GvFile, DateUtils, Dialogs;

function GetPlace(ndPlace: TXmlNode; MaxLen: integer): string;
begin
  if GetXmlAttrValue(ndPlace, 'PLACETYPE_CODE', '4') = 4 then
    Result:= Translit(GetXmlAttr(ndPlace, 'PLACE_NAME'))
  else
    Result:= Translit(GetXmlAttr(ndPlace, 'PLACETYPE_SIGN') +
                     GetXmlAttr(ndPlace, 'PLACE_NAME', '. '));
  result:= Copy(Result, 1, MaxLen);
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
  ndProduct, ndOrders: TXmlNode; aOrderId: integer): string;
var
  ndOrder, ndClient, ndAdress, ndPlace: TXmlNode;
  Line: TStringList;
begin
  Result:= '';
  ndOrder:= ndOrders.NodeNew('ORDER');
  ndClient:= ndOrder.NodeFindOrCreate('CLIENT');
  ndAdress:= ndOrder.NodeFindOrCreate('ADRESS');
  ndPlace:= ndAdress.NodeFindOrCreate('PLACE');
  Line:= TStringList.Create;
  try
    dmOtto.ObjectGet(ndOrder, aOrderId, aTransaction);
    dmOtto.ObjectGet(ndClient, GetXmlAttrValue(ndOrder, 'CLIENT_ID'), aTransaction);
    dmOtto.ObjectGet(ndAdress, GetXmlAttrValue(ndOrder, 'ADRESS_ID'), aTransaction);
    dmOtto.ObjectGet(ndPlace, GetXmlAttrValue(ndAdress, 'PLACE_ID'), aTransaction);
    if XmlAttrIn(ndOrder, 'STATUS_SIGN', 'APPROVED') then
    begin
      Line.Add(GetXmlAttr(ndProduct, 'PARTNER_NUMBER'));
      Line.Add(CopyLast(GetXmlAttr(ndOrder, 'ORDER_CODE'), 5));
      Line.Add('100');
      Line.Add(IfThen(LastChar(GetXmlAttr(ndClient, 'FIRST_NAME')) in ['а', 'я'], '3', '1'));
      Line.Add(Translit(GetXmlAttr(ndClient, 'LAST_NAME')));
      Line.Add(Translit(GetXmlAttr(ndClient, 'FIRST_NAME') + ' '+ Copy(GetXmlAttr(ndClient, 'MID_NAME'), 1, 1)));
      Line.Add('');
      Line.Add(GetAdress(ndAdress, 32));
      Line.Add(Translit(GetXmlAttr(ndPlace, 'AREA_NAME', '', ' r-n')));
      Line.Add(GetXmlAttr(ndAdress, 'POSTINDEX'));
      Line.Add(GetPlace(ndPlace, 24));
      Line.Add('N');
      Result:= ReplaceAll(Line.Text, #13#10, ';')+#13#10;
      SetXmlAttr(ndOrder, 'NEW.STATUS_SIGN', 'ACCEPTREQUEST');
      dmOtto.ActionExecute(aTransaction, ndOrder);
      IncXmlAttr(ndProduct, 'ORDER_COUNT');
    end;
  finally
    Line.Free;
  end;
end;

function ExportOrderItem(aTransaction: TpFIBTransaction;
  ndProduct, ndOrder, ndOrderItems: TXmlNode; aOrderItemId: integer): string;
var
  ndOrderItem: TXmlNode;
  Line: TStringList;
begin
  ndOrderItem:= ndOrderItems.NodeNew('ORDERITEM');
  Line:= TStringList.Create;
  try
    dmOtto.ObjectGet(ndOrderItem, aOrderItemId, aTransaction);
    ndOrderItem.ValueAsBool:= True;
    Line.Add(GetXmlAttr(ndProduct, 'PARTNER_NUMBER'));
    Line.Add(CopyLast(GetXmlAttr(ndOrder, 'ORDER_CODE'), 5));
    Line.Add('200');
    Line.Add(CopyLast(GetXmlAttr(ndOrder, 'ORDER_CODE'), 5));
    Line.Add(GetXmlAttr(ndOrderItem, 'ARTICLE_CODE'));
    Line.Add(dmOtto.Recode('ORDERITEM', 'DIMENSION_ENCODE', GetXmlAttr(ndOrderItem, 'DIMENSION')));
    Line.Add('1');
    Line.Add(GetXmlAttr(ndOrderItem, 'COST_EUR'));
    Line.Add('');
    Line.Add('');
    Line.Add('');
    Line.Add('0');
    Result:= ReplaceAll(Line.Text, #13#10, ';')+#13#10;
    SetXmlAttr(ndOrderItem, 'NEW.STATUS_SIGN', 'ACCEPTREQUEST');
    dmOtto.ActionExecute(aTransaction, ndOrderItem);
    IncXmlAttr(ndProduct, 'ORDERITEM_COUNT');
  finally
    Line.Free;
  end;
end;

function ExportOrder(aTransaction: TpFIBTransaction;
  ndProduct, ndOrders: TXmlNode; aOrderId: Integer): string;
var
  OrderItemList: string;
  ndOrder, ndOrderItems: TXmlNode;
  OrderItemId: Variant;
begin
  Result:= '';
  ndOrder:= ndOrders.NodeByAttributeValue('ORDER', 'ID', IntToStr(aOrderId), false);
  if ndOrder = nil then
  begin
    ndOrder:= ndOrders.NodeNew('ORDER');
    dmOtto.ObjectGet(ndOrder, aOrderId, aTransaction);
  end;
  ndOrderItems:= ndOrder.NodeNew('ORDERITEMS');

  dmOtto.ObjectGet(ndOrder, aOrderId, aTransaction);
  OrderItemList:= aTransaction.DefaultDatabase.QueryValue(
    'select list(orderitem_id) from ('+
    'select oi.orderitem_id '+
    'from orderitems oi '+
    '  inner join statuses s on (s.status_id = oi.status_id and s.status_sign = ''APPROVED'') '+
    'where oi.order_id = :order_id '+
    'order by oi.orderitem_id)',
    0, [aOrderId], aTransaction);
  while OrderItemList <> '' do
  begin
    OrderItemId:= TakeFront5(OrderItemList, ',');
    result:= Result + ExportOrderItem(aTransaction, ndProduct, ndOrder, ndOrderItems, OrderItemId);
  end;
end;

procedure ExportProduct(aTransaction: TpFIBTransaction;
  ndProducts: TXmlNode; aProductId: integer);
var
  ndProduct, ndOrders: TXmlNode;
  OrderList, FileName, ClientText, OrderItemText: string;
  OrderId: variant;
begin
  ndProduct:= ndProducts.NodeFindOrCreate('PRODUCT');
  ndOrders:= ndProduct.NodeNew('ORDERS');
  dmOtto.ObjectGet(ndProduct, aProductId, aTransaction);
  OrderList:= aTransaction.DefaultDatabase.QueryValue(
    'select list(distinct order_id) from ( '+
    'select o.order_id, o.order_code '+
    'from orderitems oi '+
    'inner join statuses s on (s.status_id = oi.status_id and s.status_sign = ''APPROVED'') '+
    'inner join orders o on (o.order_id = oi.order_id) '+
    'where o.product_id = :product_id '+
    'order by o.order_code)',
    0, [aProductId], aTransaction);
  while OrderList <> '' do
  begin
    OrderId:= TakeFront5(OrderList, ',');
    ClientText:= ClientText + ExportClient(aTransaction, ndProduct, ndOrders, OrderId);
    OrderItemText:= OrderItemText + ExportOrder(aTransaction, ndProduct, ndOrders, OrderId);
  end;

  ForceDirectories(Path['OrderRequests']);
  FileName:= GetNextFileName(Format('%sa%s_%.1u%%.1u.%.3d', [
    Path['OrderRequests'], GetXmlAttrValue(ndProduct, 'PARTNER_NUMBER'),
    Integer(dmOtto.DealerId), DayOfTheYear(Date)]));
  SaveStringAsFile(ClientText+OrderItemText, FileName);
  dmOtto.CreateAlert('Отправка заявок', Format('Сформирован файл %s', [ExtractFileName(FileName)]), mtInformation, 10000);
end;

procedure ExportApprovedOrder(aTransaction: TpFIBTransaction);
var
  Xml: TNativeXml;
  ndProducts: TXmlNode;
  ProductId: Variant;
  ProductList: string;
begin
  aTransaction.StartTransaction;
  try
    xml:= TNativeXml.CreateName('PRODUCTS');
    try
      ndProducts:= Xml.Root;
      ProductList:= aTransaction.DefaultDatabase.QueryValue(
        'select list(distinct o.product_id) '+
        'from orderitems oi '+
        'inner join statuses s on (s.status_id = oi.status_id and s.status_sign = ''APPROVED'') '+
        'inner join orders o on (o.order_id = oi.order_id)',
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
