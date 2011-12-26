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
  PaymentId, OrderId: Variant;
  Xml: TNativeXml;
  ndOrder, ndPayment: TXmlNode;
begin
  Xml:= TNativeXml.CreateName('PAYMENT');
  ndPayment:= Xml.Root;
  ndOrder:= ndPayment.NodeNew('ORDER');
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

    OrderId:= aTransaction.DefaultDatabase.QueryValue(
      'select order_id from orders where order_code like ''_''||:order_code',
      0, [FilterString(sl[3], '0123456789')], aTransaction);
    if OrderId <> null then
    begin
      dmOtto.ObjectGet(ndOrder, OrderId, aTransaction);

      try
        dmOtto.ActionExecute(aTransaction, 'ACCOUNT', 'ACCOUNT_PAYMENTIN',
          XmlAttrs2Vars(ndOrder, 'ORDER_ID=ID;ID=ACCOUNT_ID',
          XmlAttrs2Vars(ndPayment, 'AMOUNT_BYR')));

        dmOtto.ActionExecute(aTransaction, ndPayment, 'ASSIGNED');
        dmOtto.Notify(aMessageId,
          '[LINE_NO]. Сумма [AMOUNT_BYR] BYR зачислена на заявку [ORDER_CODE]',
          'I',
          XmlAttrs2Vars(ndOrder, 'ORDER_CODE',
          Strings2Vars(sl, 'AMOUNT_BYR=1',
          Value2Vars(LineNo, 'LINE_NO'))));
      except
        on E: Exception do
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Сумма [AMOUNT_BYR] BYR. Заявка [ORDER_CODE]. [ERROR_TEXT]',
            'E',
            XmlAttrs2Vars(ndOrder, 'ORDER_CODE',
            Strings2Vars(sl, 'AMOUNT_BYR=1',
            Value2Vars(LineNo, 'LINE_NO',
            Value2Vars(E.Message, 'ERROR_TEXT')))));
      end;
    end
    else
      dmOtto.Notify(aMessageId,
        '[LINE_NO]. Сумма [AMOUNT_BYR] BYR. Неизвестная заявка [ORDER_CODE]',
        'E',
        Strings2Vars(sl, 'ORDER_CODE=3;AMOUNT_BYR=1',
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
