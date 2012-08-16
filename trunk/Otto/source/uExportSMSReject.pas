unit uExportSMSReject;

interface
uses
  Classes, NativeXml, FIBDatabase, pFIBDatabase;

procedure ExportSMSRejected(aTransaction: TpFIBTransaction);

implementation
uses
  GvNativeXml, udmOtto, GvStr, SysUtils, GvFile, Dialogs;

function ExportOrderItem(aTransaction: TpFIBTransaction;
  ndOrderItems: TXmlNode; OrderItemId: Integer): string;
var
  ndOrderItem: TXmlNode;
begin
  ndOrderItem:= ndOrderItems.NodeNew('ORDERITEM');
  dmOtto.ObjectGet(ndOrderItem, OrderItemId, aTransaction);
  Result:= GetXmlAttr(ndOrderItem, 'ARTICLE_CODE', ' артикул ') +
           GetXmlAttr(ndOrderItem, 'NAME_RUS', ' ') +
           GetXmlAttr(ndOrderItem, 'KIND_RUS', ' ') +
           GetXmlAttr(ndOrderItem, 'PRICE_EUR', ' (', ' EUR);');
  SetXmlAttr(ndOrderItem, 'NEW.STATE_SIGN', 'SMSREJECTSENT');
  dmOtto.ActionExecute(aTransaction, ndOrderItem);
end;

function ExportOrder(aTransaction: TpFIBTransaction;
  ndOrders: TXmlNode; OrderId: Integer): string;
var
  ndOrder, ndOrderItems, ndClient: TXmlNode;
  OrderItemList, Mobile: String;
  OrderItemId: Variant;
begin
  Result:= '';
  ndOrder:= ndOrders.NodeNew('ORDER');
  ndClient:= ndOrder.NodeNew('CLIENT');
  ndOrderItems:= ndOrder.NodeNew('ORDERITEMS');

  dmOtto.ObjectGet(ndOrder, OrderId, aTransaction);
  dmOtto.ObjectGet(ndClient, GetXmlAttrValue(ndOrder, 'CLIENT_ID'), aTransaction);
  Mobile:= replaceAll(GetXmlAttr(ndClient, 'MOBILE_PHONE', '+375'), '+3750', '+375');
  Result:= FilterString(Mobile, '0123456789') + GetXmlAttr(ndOrder, 'ORDER_CODE', ' Отказ по заявке ', ':');

  OrderItemList:= aTransaction.DefaultDatabase.QueryValue(
    'select list(distinct oi.orderitem_id) '+
    'from orderitems oi '+
    'inner join statuses s1 on (s1.status_id = oi.status_id and s1.status_sign = ''REJECTED'') '+
    'left join statuses s2 on (s2.status_id = oi.state_id) '+
    'where coalesce(s2.status_sign, '''')  <> ''SMSREJECTSENT'' '+
    '  and oi.order_id = :order_id',
    0, [OrderId], aTransaction);
  if OrderItemList <> '' then
  begin
    OrderItemId:= TakeFront5(OrderItemList, ',');
    Result:= Result + ExportOrderItem(aTransaction, ndOrderItems, OrderItemId);
  end;
  Result:= Translit(Result)+#13#10;
end;

procedure ExportSMSRejected(aTransaction: TpFIBTransaction);
var
  ndOrders: TXmlNode;
  OrderList, FileName: string;
  OrderId: variant;
  SmsText: string;
  Xml: TNativeXml;
begin
  SmsText:= '';
  aTransaction.StartTransaction;
  try
    xml:= TNativeXml.CreateName('ORDERS');
    try
      ndOrders:= Xml.Root;
      OrderList:= aTransaction.DefaultDatabase.QueryValue(
        'select list(distinct oi.order_id) '+
        'from orderitems oi '+
        'inner join statuses s1 on (s1.status_id = oi.status_id and s1.status_sign = ''REJECTED'') '+
        'left join statuses s2 on (s2.status_id = oi.state_id) '+
        'where coalesce(s2.status_sign, '''')  <> ''SMSREJECTSENT''',
        0, aTransaction);
      while OrderList <> '' do
      begin
        OrderId := TakeFront5(OrderList, ',');
        SmsText:= SmsText + ExportOrder(aTransaction, ndOrders, OrderId);
      end;
      if ndOrders.NodeCount > 0 then
      begin
        ForceDirectories(Path['SMSReject']);
        FileName:= GetNextFileName(Format('%sSMSReject_%s_%%u.txt',
                   [Path['SMSReject'], FormatDateTime('YYYYMMDD', Date)]), 1);
        SaveStringAsFile(SmsText, FileName);
        dmOtto.CreateAlert('Отправка SMS', Format('Сформирован файл %s', [ExtractFileName(FileName)]), mtInformation, 10000);
      end;
      dmOtto.ExportCommitRequest(ndOrders, aTransaction);
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
