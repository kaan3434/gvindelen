unit uMoneyBack;

interface
uses
  Classes, SysUtils, FIBDatabase, frxClass, pFIBDatabase;

procedure ReportMoneyBackBelpost(aTransaction: TpFIBTransaction; frxReport: TFrxReport);

procedure ReportMoneyBackBank(aTransaction: TpFIBTransaction; frxReport: TFrxReport);

procedure ReportMoneyBackAccount(aTransaction: TpFIBTransaction; frxReport: TFrxReport);

implementation

uses
  NativeXml, udmOtto, GvStr, GvNativeXml;

procedure ReportMoneyBackBelpost(aTransaction: TpFIBTransaction; frxReport: TFrxReport);
var
  MoneyBacks: string;
  MoneyBackId: Variant;
  xml: TNativeXml;
  ndMoneyBack: TXmlNode;
begin
  xml:= TNativeXml.CreateName('MoneyBack');
  try
    aTransaction.StartTransaction;
    try
      ndMoneyBack:= xml.Root;
      frxReport.LoadFromFile(Path['FastReport']+'MoneyBackBelPost.fr3');
      frxReport.PrepareReport(true);
      frxReport.ShowPreparedReport;
      MoneyBacks:= aTransaction.DefaultDatabase.QueryValue(
        'select list(mb.moneyback_id) from moneybacks mb '+
        'inner join statuses s on (s.status_id = mb.status_id) '+
        'where mb.kind = ''BELPOST'' and s.status_sign = ''NEW''',
        0, [], aTransaction);
      while MoneyBacks <> '' do
      begin
        MoneyBackId:= TakeFront5(MoneyBacks,',');
        dmOtto.ObjectGet(ndMoneyBack, MoneyBackId, aTransaction);
        SetXmlAttr(ndMoneyBack, 'NEW.STATUS_SIGN', 'APPROVED');
        dmOtto.ActionExecute(aTransaction, ndMoneyBack);
      end;
      aTransaction.Commit;
    except
      aTransaction.Rollback;
    end;
  finally
    xml.Free;
  end;
end;

procedure ReportMoneyBackBank(aTransaction: TpFIBTransaction; frxReport: TFrxReport);
var
  MoneyBacks: string;
  MoneyBackId: Variant;
  xml: TNativeXml;
  ndMoneyBack: TXmlNode;
begin
  xml:= TNativeXml.CreateName('MoneyBack');
  try
    aTransaction.StartTransaction;
    try
      ndMoneyBack:= xml.Root;
      frxReport.LoadFromFile(Path['FastReport']+'MoneyBackBank.fr3');
      frxReport.PrepareReport(true);
      frxReport.ShowPreparedReport;
      MoneyBacks:= aTransaction.DefaultDatabase.QueryValue(
        'select list(mb.moneyback_id) from moneybacks mb '+
        'inner join statuses s on (s.status_id = mb.status_id) '+
        'where mb.kind = ''BANK'' and s.status_sign = ''NEW''',
        0, [], aTransaction);
      while MoneyBacks <> '' do
      begin
        MoneyBackId:= TakeFront5(MoneyBacks,',');
        dmOtto.ObjectGet(ndMoneyBack, MoneyBackId, aTransaction);
        SetXmlAttr(ndMoneyBack, 'NEW.STATUS_SIGN', 'APPROVED');
        dmOtto.ActionExecute(aTransaction, ndMoneyBack);
      end;
      aTransaction.Commit;
    except
      aTransaction.Rollback;
    end;
  finally
    xml.Free;
  end;
end;

procedure ReportMoneyBackAccount(aTransaction: TpFIBTransaction; frxReport: TFrxReport);
var
  Orders: string;
  OrderId: Variant;
  xml: TNativeXml;
  ndOrder: TXmlNode;
begin
  xml:= TNativeXml.CreateName('Order');
  try
    ndOrder:= xml.Root;
    frxReport.LoadFromFile(Path['FastReport']+'MoneyBackAccount.fr3');
    frxReport.PrepareReport(true);
    frxReport.ShowPreparedReport;
    Orders:= aTransaction.DefaultDatabase.QueryValue(
      'select list(distinct o.order_id) '+
      'from orders o '+
      'inner join v_order_attrs oa on (oa.object_id = o.order_id and oa.attr_sign=''MONEYBACK_KIND'' and oa.attr_value=''LEAVE'') '+
      'inner join statuses s1 on (s1.status_id = o.status_id and s1.status_sign=''HAVERETURN'') '+
      'left join statuses s2 on (s2.status_id = o.state_id) '+
      'where coalesce(s2.status_sign, '''')  <> ''MONEYSENT''',
      0, [], aTransaction);
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
