unit uParsePayments;

interface

uses
  NativeXml, FIBDatabase, pFIBDatabase;

procedure ProcessPayment(aMessageId: Integer; aTransaction: TpFIBTransaction);

implementation

uses
  Classes, SysUtils, GvStr, udmOtto, pFIBStoredProc, Variants, GvNativeXml,
  Dialogs, Controls, StrUtils, GvDtTm;

procedure ParsePaymentLine(aMessageId, LineNo: Integer; aLine: string; aTransaction: TpFIBTransaction);
var
  sl: TStringList;
  PayDate: TDateTime;
  InvoiceId, PaymentId: Variant;
  Xml: TNativeXml;
  ndOrder, ndInvoices, ndInvoice, ndPayment: TXmlNode;
begin
  Xml:= TNativeXml.CreateName('PAYMENT');
  ndPayment:= Xml.Root;
  ndOrder:= ndPayment.NodeNew('ORDER');
  ndInvoices:= ndPayment.NodeNew('INVOICES');
  sl:= TStringList.Create;
  try
    sl.Delimiter:= ';';
    sl.DelimitedText:= '"'+ReplaceAll(aLine, ';', '";"')+'"';

    PayDate:= DateTimeStrEval('DD.MM.YYYY', sl[0]);

    PaymentId:= dmOtto.GetNewObjectId('PAYMENT');
    SetXmlAttr(ndPayment, 'ID', PaymentId);
    SetXmlAttr(ndPayment, 'MESSAGE_ID', aMessageId);
    SetXmlAttr(ndPayment, 'CREATE_DT', PayDate);
    SetXmlAttrAsMoney(ndPayment, 'AMOUNT_BYR', sl[1]);
    SetXmlAttr(ndPayment, 'NOTES', sl[2]);
    SetXmlAttr(ndPayment, 'ORDER_CODE', sl[3]);
    dmOtto.ActionExecute(aTransaction, ndPayment);

    InvoiceId:= aTransaction.DefaultDatabase.QueryValue(
      'select o_invoice_id from invoice_detect(:pay_dt, :amount_byr, :invoice_code)',
      0, [PayDate, sl[1], sl[3]], aTransaction);
    if InvoiceId <> null then
    begin
      ndInvoice:= ndInvoices.NodeNew('INVOICE');
      dmOtto.ObjectGet(ndInvoice, InvoiceId, aTransaction);
      SetXmlAttr(ndPayment, 'INVOICE_ID', InvoiceId);
      try
        dmOtto.ActionExecute(aTransaction, ndPayment, 'ASSIGNED');
        dmOtto.Notify(aMessageId,
          '[LINE_NO]. Извещение [INVOICE_CODE]. Сумма [AMOUNT_BYR]. Заявка [ORDER_CODE]. Ok',
          'I',
          Strings2Vars(sl, 'INVOICE_CODE=3;AMOUNT_BYR=1',
          Value2Vars(LineNo, 'LINE_NO')));
      except
      end;
    end
    else
      dmOtto.Notify(aMessageId,
        '[LINE_NO]. Заявка [INVOICE_CODE]. Сумма [AMOUNT_BYR].',
        'E',
        Strings2Vars(sl, 'INVOICE_CODE=3;AMOUNT_BYR=1',
        Value2Vars(LineNo, 'LINE_NO')));

  finally
    sl.Free;
    Xml.Free;
  end;
end;

procedure ParsePayment(aMessageId: Integer; ndOrders: TXmlNode; aTransaction: TpFIBTransaction);
var
  LineNo: Integer;
  Lines: TStringList;
  MessageFileName: variant;
  ndOrder, ndOrderItems: TXmlNode;
begin
  dmOtto.ClearNotify(aMessageId);
  MessageFileName:= dmOtto.dbOtto.QueryValue(
    'select m.file_name from messages m where m.message_id = :message_id', 0,
    [aMessageId]);
  dmOtto.Notify(aMessageId,
    'Начало обработки файла: [FILE_NAME]', 'I',
    Value2Vars(MessageFileName, 'FILE_NAME'));
  // загружаем файл
  if not aTransaction.Active then
    aTransaction.StartTransaction;
  try
    Lines:= TStringList.Create;
    try
      Lines.LoadFromFile(Path['Messages.In']+MessageFileName);
      For LineNo:= 0 to Lines.Count - 1 do
        ParsePaymentLine(aMessageId, LineNo, Lines[LineNo], aTransaction);
    finally
      Lines.Free;
    end;
    dmOtto.Notify(aMessageId,
      'Конец обработки файла: [FILE_NAME]', 'I',
      Value2Vars(MessageFileName, 'FILE_NAME'));
  except
    aTransaction.Rollback;
    raise;
  end
end;

procedure ProcessPayment(aMessageId: Integer; aTransaction: TpFIBTransaction);
var
  aXml: TNativeXml;
begin
  aXml:= TNativeXml.CreateName('MESSAGE');
  SetXmlAttr(aXml.Root, 'MESSAGE_ID', aMessageId);
  try
    if not aTransaction.Active then
      aTransaction.StartTransaction;
    ParsePayment(aMessageId, aXml.Root, aTransaction);
    dmOtto.MessageSuccess(aTransaction, aMessageId);
    aTransaction.Commit;
  finally
    aXml.Free;
  end;
end;


end.
