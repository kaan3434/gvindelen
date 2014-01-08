unit uExportToSite;
interface
uses
  Classes, SysUtils, FIBDatabase, pFIBDatabase;

procedure ExportToSite(aTransaction: TpFIBTransaction);

implementation

uses
  GvXml, GvXmlUtils, udmOtto, GvStr, GvFile, Dialogs;

procedure ExportOrder(aTransaction: TpFIBTransaction;
  aOrderId: integer);
var
  xml: TGvXml;
  ndOrder, ndClient, ndOrderItems, ndOrderTaxs, ndOrderMoneys: TGvXmlNode;
  OrderCode, FileName: string;
begin
  xml:= TGvXml.Create('ORDERS');
  try
    ndOrder:= xml.Root.AddChild('ORDER');
    ndClient:= ndOrder.AddChild('CLIENT');
    ndOrderItems:= ndOrder.AddChild('ORDERITEMS');
    ndOrderTaxs:= ndOrder.AddChild('ORDERTAXS');
    ndOrderMoneys:= ndOrder.AddChild('ORDERMONEYS');
    dmOtto.ObjectGet(ndOrder, aOrderId, aTransaction);
    dmOtto.OrderItemsGet(ndOrderItems, aOrderId, aTransaction);
    dmOtto.OrderTaxsGet(ndOrderTaxs, aOrderId, aTransaction);
    dmOtto.OrderMoneysGet(ndOrderMoneys, aOrderId, aTransaction);
    dmOtto.ObjectGet(ndClient, ndOrder['CLIENT_ID'], aTransaction);
    OrderCode:= ndOrder['ORDER_CODE'];
    FileName:= Format('%s%s.xml',[Path['ExportToSite'], OrderCode]);
    xml.Header.Attr['Encoding'].AsString:= 'Windows-1251';
    xml.SaveToFile(FileName);
  finally
    xml.Free;
  end;
end;

procedure ExportToSite(aTransaction: TpFIBTransaction);
var
  Xml: TGvXml;
  ndOrders: TGvXmlNode;
  OrderId: Variant;
  OrderList: string;
  OrderCount: Integer;
begin
  aTransaction.StartTransaction;
  try
    ForceDirectories(Path['ExportToSite']);
    DeleteFiles(Path['ExportToSite']+'*.*');
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
      ExportOrder(aTransaction, OrderId);
      dmOtto.StepProgress;
    end;
    dmOtto.CreateAlert('Выгрузка данных для сайта', Format('%u файлов выгружено', [OrderCount]), mtInformation, 30000);
    dmOtto.InitProgress;
  except
    on E: Exception do
    begin
      aTransaction.Rollback;
      ShowMessage('Ошибка при формировании файлов: '+e.Message);
    end;
  end;
end;

end.
