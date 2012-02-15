unit uExportToSite;
interface
uses
  Classes, SysUtils, FIBDatabase, pFIBDatabase;

procedure ExportToSite(aTransaction: TpFIBTransaction);

implementation

uses
  NativeXml, GvNativeXml, udmOtto, GvStr, GvFile, Dialogs;

procedure ExportOrder(aTransaction: TpFIBTransaction;
  ndOrders: TXmlNode; aOrderId: integer);
var
  ndOrder, ndClient, ndOrderItems, ndOrderTaxs, ndOrderMoneys: TXmlNode;
  OrderCode, FileName: string;
begin
  ndOrder:= ndOrders.NodeNew('ORDER');
  try
    ndClient:= ndOrder.NodeNew('CLIENT');
    ndOrderItems:= ndOrder.NodeNew('ORDERITEMS');
    ndOrderTaxs:= ndOrder.NodeNew('ORDERTAXS');
    ndOrderMoneys:= ndOrder.NodeNew('ORDERMONEYS');
    dmOtto.ObjectGet(ndOrder, aOrderId, aTransaction);
    dmOtto.OrderItemsGet(ndOrderItems, aOrderId, aTransaction);
    dmOtto.OrderTaxsGet(ndOrderTaxs, aOrderId, aTransaction);
    dmOtto.OrderMoneysGet(ndOrderMoneys, aOrderId, aTransaction);
    dmOtto.ObjectGet(ndClient, GetXmlAttrValue(ndOrder, 'CLIENT_ID'), aTransaction);
    OrderCode:= GetXmlAttrValue(ndOrder, 'ORDER_CODE');
    FileName:= Format('%s%s.xml',[
      Path['ExportToSite'],
      FillFront(FilterString(OrderCode, '0123456789'), 5, '0')]);
    ndOrder.Document.EncodingString:= 'Windows-1251';
    ndOrder.Document.XmlFormat:= xfReadable;
    ndOrder.Document.SaveToFile(FileName);
  finally
    ndOrder.Delete;
  end;
end;

procedure ExportToSite(aTransaction: TpFIBTransaction);
var
  Xml: TNativeXml;
  ndOrders: TXmlNode;
  OrderId: Variant;
  OrderList: string;
begin
  ForceDirectories(Path['ExportToSite']);
  DeleteFiles(Path['ExportToSite']+'*.*');
  xml:= TNativeXml.CreateName('ORDERS');
  try
    ndOrders:= Xml.Root;
    OrderList:= aTransaction.DefaultDatabase.QueryValue(
      'select list(o.order_id) '+
      'from orders o '+
      'where o.create_dtm >= current_date - 100 '+
      ' and o.order_code is not null',
       0, aTransaction);
    while OrderList <> '' do
    begin
      OrderId:= TakeFront5(OrderList, ',');
      ExportOrder(aTransaction, ndOrders, OrderId);
    end;
  finally
    Xml.Free;
  end;
end;

end.
