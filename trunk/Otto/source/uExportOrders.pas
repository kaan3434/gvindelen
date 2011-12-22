unit uExportOrders;

interface

uses
  NativeXml, FIBDatabase, pFIBDatabase;

procedure SelectApprovedOrderItems(aTransaction: TpFIBTransaction;
  ndProducts: TXmlNode);

procedure ExportOrders(aTransaction: TpFIBTransaction; ndProduct: TXmlNode;
  aFileName: String);

implementation

uses
  Classes, GvNativeXml, GvStr, udmOtto;

procedure SelectApprovedOrderItems(aTransaction: TpFIBTransaction;
  ndProducts: TXmlNode);
var
  Products, Orders, OrderItems: string;
  ProductId, OrderId, OrderItemId: variant;
  ndOrders, ndOrder, ndOrderItems, ndOrderItem, ndClient, ndAdress,
  ndPlace, ndProduct: TXmlNode;
begin

  Products:= aTransaction.DefaultDatabase.QueryValue(
    'select list(p.product_id) from products p', 0);
  while Products <> '' do
  begin
    ndProduct:= ndProducts.NodeNew('PRODUCT');
    ProductId:= TakeFront5(Products, ',');
    dmOtto.ObjectGet(ndProduct, ProductId, aTransaction);

    Orders:= aTransaction.DefaultDatabase.QueryValue(
      'select list(o.orders) '+
      'from orders o '+
      'inner join orderitems oi on (oi.order_id = o.order_id) '+
      'inner join statuses soi on (soi.status_id = oi.status_id and soi.status_sign = ''APPROVED'') '+
      'where o.product_id = :product_id', 0, [GetXmlAttrValue(ndProduct, 'ID')], aTransaction);
    if Orders <> '' then
    begin
      ndOrders:= ndProduct.NodeNew('ORDERS');
      while Orders <> '' do
      begin
        OrderId:= TakeFront5(Orders, ',');
        ndOrder:= ndOrders.NodeNew('ORDER');
        ndClient:= ndOrder.NodeNew('CLIENT');
        ndAdress:= ndOrder.NodeNew('ADRESS');
        ndPlace:= ndAdress.NodeNew('PLACE');
        dmOtto.ObjectGet(ndOrder, OrderId, aTransaction);
        dmOtto.ObjectGet(ndClient, GetXmlAttrValue(ndOrder, 'CLIENT_ID'), aTransaction);
        dmOtto.ObjectGet(ndAdress, GetXmlAttrValue(ndOrder, 'ADRESS_ID'), aTransaction);
        dmOtto.ObjectGet(ndPlace, GetXmlAttrValue(ndAdress, 'PLACE_ID'), aTransaction);
        OrderItems:= dmOtto.dbOtto.QueryValue(
          'select list(oi.orderitem_id) '+
          'from orderitems oi '+
          'inner join statuses s on (s.status_id = oi.status_id) '+
          'where s.status_sign = ''APPROVED'' '+
          '  and oi.order_id = :order_id', 0, [OrderId], aTransaction);
        ndOrderItems:= ndOrder.NodeNew('ORDERITEMS');
        while OrderItems <> '' do
        begin
          OrderItemId:= TakeFront5(OrderItems, ',');
          ndOrderItem:= ndOrderItems.NodeNew('ORDERITEM');
          dmOtto.ObjectGet(ndOrderItem, OrderItemId, aTransaction);
        end;
      end;
    end;
  end;
end;

procedure ExportOrders(aTransaction: TpFIBTransaction; ndProduct: TXmlNode;
  aFileName: String);

function GetPlace(ndPlace: TXmlNode; MaxLen: integer): string;
begin
  if GetXmlAttrValue(ndPlace, 'PLACETYPE_CODE', '4') = 4 then
    Result:= Translit(GetXmlAttr(ndPlace, 'PLACE_NAME'))
  else
    Result:= Translit(GetXmlAttr(ndPlace, 'PLACETYPE_NAME', ' ', '.') +
                     GetXmlAttr(ndPlace, 'PLACE_NAME', ' '));
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


function FillHead(ndProduct, ndOrder: TXmlNode): string;
var
  ndClient, ndAdress, ndPlace: TXmlNode;
  Line: TStringList;
begin
  ndClient:= ndOrder.NodeByName('CLIENT');
  ndAdress:= ndOrder.NodeByName('ADRESS');
  ndPlace:= ndAdress.NodeByName('PLACE');
  Line:= TStringList.Create;
  try
    Line.Add(GetXmlAttrValue(ndProduct, 'PARTNER_NUMBER'));
    Line.Add(FilterString(GetXmlAttrValue(ndOrder, 'ORDER_CODE'), '0123456789'));
//    Line.Add(GetXmlAttrValue(ndOrder, 'CLIENT_ID'));
    Line.Add('100');
    Line.Add('1');
    Line.Add(Translit(GetXmlAttr(ndClient, 'LAST_NAME')));
    Line.Add(Translit(GetXmlAttr(ndClient, 'FIRST_NAME'))+' '+
             Translit(Copy(GetXmlAttr(ndClient, 'MID_NAME'), 1, 1)+'.'));
    Line.Add('');
    Line.Add(GetAdress(ndAdress, 32));
    Line.Add(GetXmlAttr(ndPlace, 'AREA_NAME', '', ' ð-í'));
    Line.Add(GetXmlAttr(ndAdress, 'POSTINDEX'));
    Line.Add(GetPlace(ndPlace, 24));
    if GetXmlAttr(ndClient, 'STATUS_SIGN') = 'APPROVED' then
      Line.Add('N')
    else
      Line.Add('U');
    Result:= ReplaceAll(Line.Text, #13#10, ';');
  finally
    Line.Free;
  end;
end;

function FillItem(ndProduct, ndOrder, ndOrderItem: TXmlNode): string;
var
  Line: TStringList;
  Dimension: string;
begin
  Line:= TStringList.Create;
  try
    Line.Add(GetXmlAttrValue(ndProduct, 'PARTNER_NUMBER'));
    Line.Add(GetXmlAttrValue(ndOrder, 'CLIENT_ID'));
    Line.Add('200');
    Line.Add(FilterString(GetXmlAttrValue(ndOrder, 'ORDER_CODE'), '0123456789'));
//    Line.Add(GetXmlAttrValue(ndOrder, 'ORDER_CODE'));
    Line.Add(GetXmlAttrValue(ndOrderItem, 'ARTICLE_CODE'));
    Dimension:= GetXmlAttrValue(ndOrderItem, 'DIMENSION');
    if FilterString(Dimension, '0123456789') <> Dimension then
      Dimension:= dmOtto.Recode('ARTICLE', 'DIMENSION_ENCODE', Dimension);
    Line.Add(Dimension);
    Line.Add(GetXmlAttrValue(ndOrderItem, 'AMOUNT'));
    Line.Add(GetXmlAttrValue(ndOrderItem, 'COST_EUR'));
    Line.Add(GetXmlAttr(ndOrderItem, 'PAGE_NO'));
    Line.Add(GetXmlAttr(ndOrderItem, 'POSITION_SIGN'));
    Line.Add('');
    Line.Add('0');
    Result:= ReplaceAll(Line.Text, #13#10, ';');
  finally
    Line.Free;
  end
end;

var
  ndOrders, ndOrder, ndOrderItems, ndOrderItem: TXmlNode;
  st: string;
  slHead, slItems, Line: TStringList;
  i, j, oi, DealId: Integer;
  FileName: string;
begin
  slHead:= TStringList.Create;
  try
    slItems:= TStringList.Create;
    try
      ndOrders:= ndProduct.NodeByName('ORDERS');
      For i:= 0 to ndOrders.NodeCount - 1 do
      begin
        ndOrder:= ndOrders[i];
        slHead.Add(FillHead(ndProduct, ndOrder));
        ndOrderItems:= ndOrder.NodeByName('ORDERITEMS');
        for j:= 0 to ndOrderItems.NodeCount - 1 do
        begin
          ndOrderItem:= ndOrderItems[j];
          slItems.Add(FillItem(ndProduct, ndOrder, ndOrderItem));
        end;
      end;
      slHead.AddStrings(slItems);
    finally
      slItems.Free;
    end;
    slHead.Text:= ReplaceAll(slHead.Text, ';'#13#10, #13#10);
    slHead.SaveToFile(Path['Messages.Out']+aFileName);
    for i:= 0 to ndOrders.NodeCount - 1 do
    begin
      ndOrder:= ndOrders[i];
      if GetXmlAttrValue(ndOrder, 'STATUS_SIGN') = 'APPROVED' then
        dmOtto.ActionExecute(aTransaction, ndOrder, 'ACCEPTREQUEST')
      else
      begin
        ndOrderItems:= ndOrder.NodeByName('ORDERITEMS');
        for oi:= 0 to ndOrderItems.NodeCount-1 do
        begin
          ndOrderItem:= ndOrderItems[oi];
          dmOtto.ActionExecute(aTransaction, ndOrderItem, 'ACCEPTREQUEST');
        end;
      end;
    end;
  finally
    slHead.Free;
  end;
end;

end.
