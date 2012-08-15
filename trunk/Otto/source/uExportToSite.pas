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
  ForceDirectories(Path['ExportToSite']);
  FileName:= Format('%s%s.xml',[Path['ExportToSite'], OrderCode]);
  ndOrder.Document.EncodingString:= 'Windows-1251';
  ndOrder.Document.XmlFormat:= xfReadable;
  ndOrder.Document.SaveToFile(FileName);
end;

procedure ExportToSite(aTransaction: TpFIBTransaction);
var
  Xml: TNativeXml;
  ndOrders: TXmlNode;
  OrderId: Variant;
  OrderList: string;
  OrderCount: Integer;
begin
  ForceDirectories(Path['ExportToSite']);
  DeleteFiles(Path['ExportToSite']+'*.*');
  xml:= TNativeXml.CreateName('ORDERS');
  try
    ndOrders:= Xml.Root;
    OrderList:= aTransaction.DefaultDatabase.QueryValue(
      'select list(order_id) from ('+
      'select order_id, max(status_dtm) status_dtm from ('+
      'select o.order_id, o.status_dtm '+
      '  from orders o '+
      'union '+
      'select oi.order_id, oi.status_dtm '+
      '  from orderitems oi '+
      'union '+
      'select om.order_id, om.status_dtm '+
      '  from ordermoneys om '+
      'union '+
      'select ot.order_id, ot.status_dtm '+
      '  from ordertaxs ot) '+
      'where order_id in (select order_id from orders where order_code is not null) '+
      'group by order_id '+
      'having max(status_dtm) > current_date-10)',
       0, aTransaction);
    OrderCount:= WordCount(OrderList, ',');
    dmOtto.InitProgress(OrderCount, 'Выгрузка данных для сайта');
    while OrderList <> '' do
    begin
      OrderId:= TakeFront5(OrderList, ',');
      ExportOrder(aTransaction, ndOrders, OrderId);
      dmOtto.StepProgress;
    end;
    dmOtto.CreateAlert('Выгрузка данных для сайта', Format('%u файлов выгружено', [OrderCount]), mtInformation, 30000);
    dmOtto.InitProgress;
  finally
    Xml.Free;
  end;
end;

end.
