unit uExportOrder;
interface
uses
  Classes, SysUtils, FIBDatabase, pFIBDatabase, Controls;

procedure ExportApprovedOrder(aTransaction: TpFIBTransaction);

implementation
uses
  udmOtto, GvXml, GvXmlUtils, GvStr, GvMath, GvFile, DateUtils, Dialogs, 
  uExportSuissen;

function GetPlace(ndPlace: TGvXmlNode): string;
begin
  Result:= FillPattern(
    '{PLACETYPE_CODE <> "4" THEN [PLACETYPE_SIGN]. }[PLACE_NAME]',
    XmlAttrs2Attr(ndPlace, 'PLACETYPE_CODE;PLACETYPE_SIGN;PLACE_NAME'));
end;

function GetAdress(ndAdress: TGvXmlNode; MaxLen: integer): string;
var
  Part1, Part2: string;
begin
   Part1:= FillPattern('{STREETTYPE_CODE <> "1" THEN  [STREETTYPE_NAME]. }[STREET_NAME]',
     XmlAttrs2Attr(ndAdress, 'STREETTYPE_CODE;STREETTYPE_NAME;STREET_NAME'));

   Part2:= FillPattern('{HOUSE THEN , [HOUSE]{BUILDING THEN /[BUILDING]}}{FLAT THEN -[FLAT]}',
     XmlAttrs2Attr(ndAdress, 'HOUSE;BUILDIND;FLAT'));

   Result:= Part1 + Part2;
   if Length(Result) <= MaxLen then Exit;
   Result:= Copy(Part1, 1, MaxLen-Length(Part2)-1)+'.'+Part2;
end;

function ExportClient(aTransaction: TpFIBTransaction;
  ndProduct, ndOrders: TGvXmlNode; aOrderId: integer): string;
var
  ndOrder, ndClient, ndAdress, ndPlace: TGvXmlNode;
  Line: TStringList;
begin
  Result:= '';
  ndOrder:= ndOrders.AddChild('ORDER');
  ndClient:= ndOrder.FindOrCreate('CLIENT');
  ndAdress:= ndOrder.FindOrCreate('ADRESS');
  ndPlace:= ndAdress.FindOrCreate('PLACE');
  dmOtto.ObjectGet(ndOrder, aOrderId, aTransaction);
  dmOtto.ObjectGet(ndClient, ndOrder['CLIENT_ID'], aTransaction);
  dmOtto.ObjectGet(ndAdress, ndOrder['ADRESS_ID'], aTransaction);
  dmOtto.ObjectGet(ndPlace, ndAdress['PLACE_ID'], aTransaction);
  if ndOrder.Attr['STATUS_SIGN'].ValueIn(['APPROVED']) then
  begin
    Result:= FillPattern(
      '[PARTNER_NUMBER];[ORDER_CODE|SUBSTR=2,5];100;[GENDER];'+
      '[LASTNAME|TRANSLIT];[FIRST_NAME|TRANSLIT]{MID_NAME THEN  [MID_NAME|TRANSLIT|SUBSTR=1,1]};;'+
      '[ADRESS_TEXT|TRANSLIT|SUBSTR=1,32];{AREA_NAME THEN [AREA_NAME|TRANSLIT] r-n};'+
      '[POSTINDEX];[PLACE_TEXT|TRANSLIT|SUBSTR=1,24];N',
      XmlAttrs2Attr(ndProduct, 'PARTNER_NUMBER',
      XmlAttrs2Attr(ndOrder, 'ORDER_CODE',
      XmlAttrs2Attr(ndAdress, 'POSTINDEX',
      XmlAttrs2Attr(ndClient, 'FIRST_NAME;LAST_NAME;MID_NAME',
      Value2Attr(GetAdress(ndAdress, 32), 'ADRESS_TEXT',
      Value2Attr(GetPlace(ndPlace), 'PLACE_TEXT',
      Value2Attr(IfThen(LastChar(ndClient['FIRST_NAME']) in ['а', 'я'], '3', '1'), 'GENDER'
    ))))))));
    ndOrder['NEW.STATUS_SIGN']:= 'ACCEPTREQUEST';
    dmOtto.ActionExecute(aTransaction, ndOrder);
  end;
end;

function ExportOrderItem(aTransaction: TpFIBTransaction;
  ndProduct, ndOrder, ndOrderItems: TGvXmlNode; aOrderItemId: integer): string;
var
  ndOrderItem: TGvXmlNode;
  Line: TStringList;
begin
  ndOrderItem:= ndOrderItems.AddChild('ORDERITEM');
  dmOtto.ObjectGet(ndOrderItem, aOrderItemId, aTransaction);
  Result:= FillPattern(
    '[PARTNER_NUMBER];[ORDER_CODE|SUBSTR=2,5];200;[ORDER_CODE|SUBSTR=2,5];'+
    '[ARTICLE_CODE];[DIMENSION];1;[PRICE_EUR];;;;0',
    XmlAttrs2Attr(ndProduct, 'PARTNER_NUMBER',
    XmlAttrs2Attr(ndOrder, 'ORDER_CODE',
    XmlAttrs2Attr(ndOrderItem, 'ARTICLE_CODE;PRICE_EUR',
    Value2Attr(dmOtto.Recode('ORDERITEM', 'DIMENSION_ENCODE', ndOrderItem['DIMENSION']),'DIMENSION')
  ))));

//    Line.Add(GetXmlAttr(ndProduct, 'PARTNER_NUMBER'));
//    Line.Add(CopyLast(GetXmlAttr(ndOrder, 'ORDER_CODE'), 5));
//    Line.Add('200');
//    Line.Add(CopyLast(GetXmlAttr(ndOrder, 'ORDER_CODE'), 5));
//    Line.Add(GetXmlAttr(ndOrderItem, 'ARTICLE_CODE'));
//    Line.Add(dmOtto.Recode('ORDERITEM', 'DIMENSION_ENCODE', GetXmlAttr(ndOrderItem, 'DIMENSION')));
//    Line.Add('1');
//    Line.Add(GetXmlAttr(ndOrderItem, 'COST_EUR'));
//    Line.Add('');
//    Line.Add('');
//    Line.Add('');
//    Line.Add('0');
//    Result:= ReplaceAll(Line.Text, #13#10, ';')+#13#10;
  ndOrderItem['NEW.STATUS_SIGN']:= 'ACCEPTREQUEST';
  dmOtto.ActionExecute(aTransaction, ndOrderItem);
//    IncXmlAttr(ndProduct, 'ORDERITEM_COUNT');
end;

function ExportOrder(aTransaction: TpFIBTransaction;
  ndProduct, ndOrders: TGvXmlNode; aOrderId: Integer): string;
var
  OrderItemList: string;
  ndOrder, ndOrderItems: TGvXmlNode;
  OrderItemId: Variant;
begin
  Result:= '';
  ndOrder:= ndOrders.Find('ORDER', 'ID', [aOrderId]);
  if ndOrder = nil then
  begin
    ndOrder:= ndOrders.AddChild('ORDER');
    dmOtto.ObjectGet(ndOrder, aOrderId, aTransaction);
  end;
  ndOrderItems:= ndOrder.AddChild('ORDERITEMS');

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

procedure ExportProductOtto(aTransaction: TpFIBTransaction;
  ndProduct: TGvXmlNode; aProductId: integer);
var
  ndOrders: TGvXmlNode;
  OrderList, FileName, ClientText, OrderItemText: string;
  OrderId: variant;
begin
  ndOrders:= ndProduct.AddChild('ORDERS');
  try
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
      Path['OrderRequests'], ndProduct['PARTNER_NUMBER'],
      Integer(dmOtto.DealerId), DayOfTheYear(Date)]));
    SaveStringAsFile(ClientText+OrderItemText, FileName);
    dmOtto.CreateAlert('Отправка заявок', Format('Сформирован файл %s', [ExtractFileName(FileName)]), mtInformation, 10000);
  finally
    ndOrders.Free;
  end;
end;

procedure ExportApprovedOrder(aTransaction: TpFIBTransaction);
var
  Xml: TGvXml;
  ndProducts, ndProduct: TGvXmlNode;
  ProductId: Variant;
  ArjName, ProductList: string;
begin
  aTransaction.StartTransaction;
  try
    xml:= TGvXml.Create('PRODUCTS');
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
        ndProduct:= ndProducts.FindOrCreate('PRODUCT');
        try
          dmOtto.ObjectGet(ndProduct, ProductId, aTransaction);
          if ndProduct['VENDOR_NAME'] = 'OTTO' then
            ExportProductOtto(aTransaction, ndProduct, ProductId)
          else
          begin
//            ArjName:=
//            ExportProductSuissen(aTransaction, ndProduct, ProductId, 'ACCEPT_REQUEST', ArjName);
          end;
        finally
          ndProduct.Free;
        end;
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
