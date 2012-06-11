unit uReportReturnedOrderItems;

interface
uses
  NativeXml, FIBDatabase, pFIBDatabase, frxClass;

procedure ReportReturnedOrderItems(aTransaction: TpFIBTransaction; frxReport: TFrxReport);

implementation

uses
  udmOtto;

procedure ReportReturnedOrderItems(aTransaction: TpFIBTransaction; frxReport: TFrxReport);
var
  Orders: string;
  OrderId: Variant;
  xml: TNativeXml;
  ndOrder: TXmlNode;
begin
  xml:= TNativeXml.CreateName('Order');
  try
    ndOrder:= xml.Root;
    frxReport.LoadFromFile(Path['FastReport']+'OrderItemReturns.fr3');
    frxReport.PrepareReport(true);
    frxReport.ShowPreparedReport;
//    Orders:= aTransaction.DefaultDatabase.QueryValueStr(
//      'select list(distinct orderitem_id) '+
  //    'from OrderItems oi '+
//      'inner join statuses sr on (sr.status_id = oi.status_id and sr.status_sign = ''RETURNING'') '+
//      'where oi.return_reestr_id is null',
//      0, [], aTransaction);
{    while Orders <> '' do
    begin
      OrderId:= TakeFront5(Orders,',');
      dmOtto.ObjectGet(ndOrder, OrderId, aTransaction);
      SetXmlAttr(ndOrder, 'NEW.STATE_SIGN', 'MONEYSENT');
      dmOtto.ActionExecute(aTransaction, ndOrder);
    end;}
  finally
    xml.Free;
  end;
end;

end.
