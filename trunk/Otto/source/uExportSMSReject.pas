unit uExportSMSReject;

interface
uses
  Classes, NativeXml, FIBDatabase, pFIBDatabase;

procedure ExportSMSRejected(aTransaction: TpFIBTransaction);

implementation
uses
  GvNativeXml, udmOtto, GvStr, SysUtils, GvFile;

procedure MakeSMSRejectNotify(OrderId: Integer; oMessageLines: TStringList;
  aTransaction: TpFIBTransaction);
var
  ndOrder, ndOrderItems, ndOrderItem, ndClient: TXmlNode;
  Xml: TNativeXml;
  i: Integer;
  Line, Mobile: String;
begin
  Xml:= TNativeXml.CreateName('ORDER');
  try
    ndOrder:= Xml.Root;
    ndOrderItems:= ndOrder.NodeNew('ORDERITEMS');
    ndClient:= ndOrder.NodeNew('CLIENT');
    dmOtto.ObjectGet(ndOrder, OrderId, aTransaction);
    dmOtto.OrderItemsGet(ndOrderItems, OrderId, aTransaction);
    dmOtto.ObjectGet(ndClient, GetXmlAttrValue(ndOrder, 'CLIENT_ID'), aTransaction);

    if AttrExists(ndClient, 'MOBILE_PHONE') then
    begin
      Mobile:= replaceAll(GetXmlAttr(ndClient, 'MOBILE_PHONE', '+375'), '+3750', '+375');
      Line:= FilterString(Mobile, '0123456789') + GetXmlAttr(ndOrder, 'ORDER_CODE', ' Отказ по заявке ', ':');
      for i:= 0 to ndOrderItems.NodeCount - 1 do
      begin
        ndOrderItem:= ndOrderItems[i];
        if XmlAttrIn(ndOrderItem, 'STATUS_SIGN', 'REJECTED') then
        begin
          Line:= Line + GetXmlAttr(ndOrderItem, 'ARTICLE_CODE', ' артикул ')
                      + GetXmlAttr(ndOrderItem, 'NAME_RUS', ' ')
                      + GetXmlAttr(ndOrderItem, 'KIND_RUS', ' ')
                      + GetXmlAttr(ndOrderItem, 'PRICE_EUR', ' (', ' EUR);');
          ndOrderItem.ValueAsBool:= True;
          dmOtto.ActionExecute(aTransaction, 'ORDERITEM_SMSREJECTSEND', ndOrderItem);
        end;
      end;
      oMessageLines.Add(Translit(Line));
    end;
  finally
    Xml.Free;
  end;
end;

procedure ExportSMSRejected(aTransaction: TpFIBTransaction);
var
  OrderList, FileName: string;
  OrderId: variant;
  Lines: TStringList;
begin
  aTransaction.StartTransaction;
  try
    OrderList := aTransaction.DefaultDatabase.QueryValue(
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
          OrderId := TakeFront5(orderList, ',');
          MakeSmsRejectNotify(OrderId, Lines, aTransaction);
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
  except
    aTransaction.Rollback;
  end;
end;

end.
