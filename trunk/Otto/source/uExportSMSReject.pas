unit uExportSMSReject;

interface
uses
  Classes, NativeXml, FIBDatabase, pFIBDatabase;

procedure ExportSMSRejected(aTransaction: TpFIBTransaction);

implementation
uses
  GvNativeXml, udmOtto, GvStr, SysUtils, GvFile, Dialogs;

function ExportOrderItem(aTransaction: TpFIBTransaction;
  ndOrder: TXmlNode; OrderItemId: Integer): string;
var
  ndOrderItem: TXmlNode;
begin
  ndOrderItem:= ndOrder.NodeFindOrCreate('ORDERITEMS').NodeNew('ORDERITEM');
  try
    dmOtto.ObjectGet(ndOrderItem, OrderItemId, aTransaction);
    Result:= GetXmlAttr(ndOrderItem, 'ARTICLE_CODE', ' артикул ') +
             GetXmlAttr(ndOrderItem, 'NAME_RUS', ' ') +
             GetXmlAttr(ndOrderItem, 'KIND_RUS', ' ') +
             GetXmlAttr(ndOrderItem, 'PRICE_EUR', ' (', ' EUR);');
    SetXmlAttr(ndOrderItem, 'NEW.STATE_SIGN', 'SMSREJECTSENT');
    dmOtto.ActionExecute(aTransaction, ndOrderItem);
  finally
    ndOrderItem.Delete;
  end;
end;

function ExportOrder(aTransaction: TpFIBTransaction;
  ndOrders: TXmlNode; OrderId: Integer): string;
var
  ndOrder, ndOrderItems, ndOrderItem, ndClient: TXmlNode;
  Xml: TNativeXml;
  i: Integer;
  OrderItemList, Line, Mobile: String;
  OrderItemId: Variant;
begin
  ndOrder:= ndOrders.NodeFindOrCreate('ORDER');
  ndClient:= ndOrder.NodeNew('CLIENT');
  try
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
      Result:= Result + ExportOrderItem(aTransaction, ndOrder, OrderItemId);
    end;
    Result:= Translit(Result);
  finally
    ndOrder.Delete;
  end;
end;

procedure ExportSMSRejected(aTransaction: TpFIBTransaction);
var
  ndOrders: TXmlNode;
  OrderList, FileName: string;
  OrderId: variant;
  Lines: TStringList;
  Xml: TNativeXml;
begin
  xml:= TNativeXml.CreateName('ORDERS');
  try
    ndOrders:= Xml.Root;
    if not aTransaction.Active then
      aTransaction.StartTransaction;
    try
      OrderList:= aTransaction.DefaultDatabase.QueryValue(
        'select list(distinct oi.order_id) '+
        'from orderitems oi '+
        'inner join statuses s1 on (s1.status_id = oi.status_id and s1.status_sign = ''REJECTED'') '+
        'left join statuses s2 on (s2.status_id = oi.state_id) '+
        'where coalesce(s2.status_sign, '''')  <> ''SMSREJECTSENT''',
        0, aTransaction);
      if OrderList <> '' then
      begin
        Lines := TStringList.Create;
        try
          while OrderList <> '' do
          begin
            OrderId := TakeFront5(OrderList, ',');
            Lines.Add(ExportOrder(aTransaction, ndOrders, OrderId));
          end;
          FileName := GetNextFileName(Format('%sSMSReject_%s_%%u.txt',
            [Path['SMSReject'], FormatDateTime('YYYYMMDD', Date)]), 1);
          ForceDirectories(ExtractFileDir(FileName));
          Lines.SaveToFile(FileName);
        finally
          Lines.Free;
        end;
      end;
      aTransaction.Commit;
      dmOtto.CreateAlert('Отправка SMS', Format('Сформирован файл %s', [ExtractFileName(FileName)]), mtInformation, 10000);
    except
      aTransaction.Rollback;
    end;
  finally
    Xml.Free;
  end;
end;

end.
