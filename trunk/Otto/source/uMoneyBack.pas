unit uMoneyBack;

interface
uses
  Classes, SysUtils, FIBDatabase, frxClass, pFIBDatabase;

procedure ReportMoneyBackBelpost(aTransaction: TpFIBTransaction);

procedure ReportMoneyBackBank(aTransaction: TpFIBTransaction);

procedure ReportMoneyBackAccount(aTransaction: TpFIBTransaction; frxReport: TFrxReport);

implementation

uses
  NativeXml, udmOtto, GvStr, GvNativeXml, GvFile, DateUtils;

procedure ReportMoneyBackBelpost(aTransaction: TpFIBTransaction);
var
  MoneyBacks: string;
  MoneyBackId: Variant;
  xml: TNativeXml;
  ndMoneyBack: TXmlNode;
  FileName: String;
begin
  ForceDirectories(Path['Returns']);
  FileName:= GetNextFileName(Format('%sBelPost_%%.2u.%.3d', [
    Path['Returns'], DayOfTheYear(Date)]));
  xml:= TNativeXml.CreateName('MoneyBack');
  try
    aTransaction.StartTransaction;
    try
      ndMoneyBack:= xml.Root;
      MoneyBacks:= aTransaction.DefaultDatabase.QueryValue(
        'select list(mb.moneyback_id) '+
        'from moneybacks mb '+
        ' inner join statuses s on (s.status_id = mb.status_id) '+
        'where mb.kind = ''BELPOST'' and s.status_sign = ''NEW'' ',
        0, [], aTransaction);
      if MoneyBacks <> '' then
      begin
        with dmOtto do
        begin
          frxExportXLS.DefaultPath:= Path['Returns'];
          frxExportXLS.FileName:= FileName+'.xls';
          frxExportXLS.Background:= True;
          frxExportXLS.OverwritePrompt:= False;
          frxExportXLS.ShowDialog:= False;
          frxExportXLS.ShowProgress:= True;

          frxPDFExport.DefaultPath:= Path['Returns'];
          frxPDFExport.FileName:= FileName+'.xls';

          frxReport.LoadFromFile(Path['FastReport'] + 'MoneyBackBelPost.fr3');
          frxReport.PrepareReport(true);
          frxReport.Export(frxExportXLS);
          frxReport.Export(frxPDFExport);
        end;

        while MoneyBacks <> '' do
        begin
          MoneyBackId:= TakeFront5(MoneyBacks,',');
          dmOtto.ObjectGet(ndMoneyBack, MoneyBackId, aTransaction);
          SetXmlAttr(ndMoneyBack, 'NEW.STATUS_SIGN', 'APPROVED');
          dmOtto.ActionExecute(aTransaction, ndMoneyBack);
        end;
      end;
      dmOtto.ExportCommitRequest(ndMoneyBack, aTransaction);
    except
      aTransaction.Rollback;
    end;
  finally
    xml.Free;
  end;
end;

procedure ReportMoneyBackBank(aTransaction: TpFIBTransaction);
var
  MoneyBacks, FileName: string;
  MoneyBackId: Variant;
  xml: TNativeXml;
  ndMoneyBack: TXmlNode;
begin
  ForceDirectories(Path['Returns']);
  FileName:= GetNextFileName(Format('%sBank_%%.2u.%.3d', [
    Path['Returns'], DayOfTheYear(Date)]));
  xml:= TNativeXml.CreateName('MoneyBack');
  try
    aTransaction.StartTransaction;
    try
      ndMoneyBack:= xml.Root;
      MoneyBacks:= aTransaction.DefaultDatabase.QueryValue(
        'select list(mb.moneyback_id) from moneybacks mb '+
        'inner join statuses s on (s.status_id = mb.status_id) '+
        'where mb.kind = ''BANK'' and s.status_sign = ''NEW''',
        0, [], aTransaction);
      if MoneyBacks <> '' then
      begin
        with dmOtto do
        begin
          frxExportXLS.DefaultPath:= Path['Returns'];
          frxExportXLS.FileName:= FileName+'.xls';
          frxExportXLS.Background:= True;
          frxExportXLS.OverwritePrompt:= False;
          frxExportXLS.ShowDialog:= False;
          frxExportXLS.ShowProgress:= True;

          frxPDFExport.DefaultPath:= Path['Returns'];
          frxPDFExport.FileName:= FileName+'.xls';

          frxReport.LoadFromFile(Path['FastReport'] + 'MoneyBackBank.fr3');
          frxReport.PrepareReport(true);
          frxReport.Export(frxExportXLS);
          frxReport.Export(frxPDFExport);
        end;
        while MoneyBacks <> '' do
        begin
          MoneyBackId:= TakeFront5(MoneyBacks,',');
          dmOtto.ObjectGet(ndMoneyBack, MoneyBackId, aTransaction);
          SetXmlAttr(ndMoneyBack, 'NEW.STATUS_SIGN', 'APPROVED');
          dmOtto.ActionExecute(aTransaction, ndMoneyBack);
        end;
      end;
      dmOtto.ExportCommitRequest(ndMoneyBack, aTransaction);
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
    while Orders <> '' do
    begin
      OrderId:= TakeFront5(Orders,',');
      dmOtto.ObjectGet(ndOrder, OrderId, aTransaction);
      SetXmlAttr(ndOrder, 'NEW.STATE_SIGN', 'MONEYSENT');
      dmOtto.ActionExecute(aTransaction, ndOrder);
    end;
  finally
    xml.Free;
  end;
end;

end.
