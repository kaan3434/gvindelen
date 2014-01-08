unit uParsePayments;

interface

uses
  GvXml, FIBDatabase, pFIBDatabase;

procedure ProcessPayment(aMessageId: Integer; aTransaction: TpFIBTransaction);

implementation

uses
  Classes, SysUtils, GvStr, udmOtto, Variants, GvXmlUtils,
  Dialogs, Controls, GvDtTm;

var
  PayInDeltaByr : Integer;

procedure ParsePaymentLine(aMessageId, LineNo: Integer; aLine: string;
  ndOrders: TGvXmlNode; aTransaction: TpFIBTransaction);
var
  sl: TStringList;
  PayDate: TDateTime;
  PaymentId, OrderId: Variant;
  Xml: TGvXml;
  ndOrder, ndAccount, ndOrderMoneys, ndOrderMoney: TGvXmlNode;
begin
  ndOrder:= ndOrders.AddChild('ORDER');
  ndAccount:= ndOrder.AddChild('ACCOUNT');
  ndOrderMoneys:= ndOrder.AddChild('ORDERMONEYS');
  sl:= TStringList.Create;
  try
    sl.Delimiter:= ';';
    sl.DelimitedText:= '"'+ReplaceAll(aLine, ';', '";"')+'"';

    OrderId:= aTransaction.DefaultDatabase.QueryValue(
      'select order_id from orders where order_code like :order_code',
      0, [sl[3]], aTransaction);
    if OrderId <> null then
    begin
      dmOtto.ObjectGet(ndOrder, OrderId, aTransaction);
      dmOtto.ObjectGet(ndAccount, ndOrder['ACCOUNT_ID'], aTransaction);
      dmOtto.OrderMoneysGet(ndOrderMoneys, OrderId, aTransaction);

      PayDate:= DateTimeStrEval('DD.MM.YYYY', sl[0]);

      ndAccount['AMOUNT_BYR']:= StrToCurr(sl[1]);

      ndOrderMoney:= ndOrderMoneys.Find('ORDERMONEY', 'AMOUNT_BYR', sl[1]);
      if ndOrderMoney <> nil then
      begin
        dmOtto.Notify(aMessageId,
          '[LINE_NO]. Повторное зачисление суммы [AMOUNT_BYR] BYR на заявку [ORDER_CODE] c задолженностью [COST_BYR]. Сумма не зачислена.',
          'E',
          XmlAttrs2Attr(ndOrder, 'ORDER_CODE;COST_BYR',
          XmlAttrs2Attr(ndAccount, 'AMOUNT_BYR',
          Value2Attr(LineNo, 'LINE_NO'))));
        Exit;
      end;

      if not FlagPresent(ndOrder, 'STATUS_FLAG_LIST', 'PAYINABLE') then
      begin
        dmOtto.Notify(aMessageId,
          '[LINE_NO]. Попытка зачисления суммы [AMOUNT_BYR] BYR на заявку [ORDER_CODE] в статусе [STATUS_NAME]',
          'W',
          XmlAttrs2Attr(ndOrder, 'ORDER_CODE;STATUS_NAME',
          XmlAttrs2Attr(ndAccount, 'AMOUNT_BYR',
          Value2Attr(LineNo, 'LINE_NO'))));
      end;


      if Abs(ndOrder.Attr['COST_BYR'].AsMoneyDef(0)-ndAccount.Attr['AMOUNT_BYR'].AsMoneyDef(0)) > PayInDeltaByr then
      begin
        dmOtto.Notify(aMessageId,
          '[LINE_NO]. Попытка зачисления суммы [AMOUNT_BYR] BYR на заявку [ORDER_CODE] c задолженностью [COST_BYR]. Сумма не зачислена',
          'E',
          XmlAttrs2Attr(ndOrder, 'ORDER_CODE;COST_BYR',
          XmlAttrs2Attr(ndAccount, 'AMOUNT_BYR',
          Value2Attr(LineNo, 'LINE_NO'))));
        Exit;
      end;

      try
        dmOtto.ActionExecute(aTransaction, 'ACCOUNT', 'ACCOUNT_PAYMENTIN',
          XmlAttrs2Attr(ndAccount, 'ID;AMOUNT_BYR',
          XmlAttrs2Attr(ndOrder, 'ORDER_ID=ID')));
        dmOtto.ObjectGet(ndOrder, OrderId, aTransaction);

        dmOtto.Notify(aMessageId,
          '[LINE_NO]. Сумма [AMOUNT_BYR] BYR зачислена на заявку [ORDER_CODE]. Статус заявки - [STATUS_NAME]',
          'I',
          XmlAttrs2Attr(ndOrder, 'ORDER_CODE;STATUS_NAME',
          Strings2Attr(sl, 'AMOUNT_BYR=1',
          Value2Attr(LineNo, 'LINE_NO'))));
      except
        on E: Exception do
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Сумма [AMOUNT_BYR] BYR. Заявка [ORDER_CODE]. [ERROR_TEXT]',
            'E',
            XmlAttrs2Attr(ndOrder, 'ORDER_CODE',
            XmlAttrs2Attr(ndAccount, 'AMOUNT_BYR',
            Value2Attr(LineNo, 'LINE_NO',
            Value2Attr(DeleteChars(e.Message, #10#13), 'ERROR_TEXT')))));
      end;
    end
    else
      dmOtto.Notify(aMessageId,
        '[LINE_NO]. Сумма [AMOUNT_BYR] BYR. Неизвестная заявка [ORDER_CODE]',
        'E',
        Strings2Attr(sl, 'ORDER_CODE=3;AMOUNT_BYR=1',
        Value2Attr(LineNo, 'LINE_NO')));
  finally
    sl.Free;
  end;
end;

procedure ParsePayment(aMessageId: Integer; ndMessage: TGvXmlNode; aTransaction: TpFIBTransaction);
var
  LineNo: Integer;
  Lines: TStringList;
  MessageFileName: variant;
  ndOrders: TGvXmlNode;
begin
  dmOtto.ClearNotify(aMessageId);
  aTransaction.StartTransaction;
  try
    dmOtto.ObjectGet(ndMessage, aMessageId, aTransaction);
    ndOrders:= ndMessage.FindOrCreate('ORDERS');

    MessageFileName:= ndMessage['FILE_NAME'];
    dmOtto.Notify(aMessageId,
      'Начало обработки файла: [FILE_NAME]', '',
      Value2Attr(MessageFileName, 'FILE_NAME'));

    if FileExists(Path['Messages.In']+MessageFileName) then
    begin
      Lines:= TStringList.Create;
      try
        Lines.LoadFromFile(Path['Messages.In']+MessageFileName);
        dmOtto.InitProgress(Lines.Count, Format('Обработка файла %s ...', [MessageFileName]));
        For LineNo:= 0 to Lines.Count - 1 do
        begin
          ParsePaymentLine(aMessageId, LineNo+1, Lines[LineNo], ndOrders, aTransaction);
          dmOtto.StepProgress;
        end;
      finally
        dmOtto.InitProgress;
        Lines.Free;
      end;
    end
    else
      dmOtto.Notify(aMessageId,
        'Файл [FILE_NAME] не найден.', 'E',
        Value2Attr(MessageFileName, 'FILE_NAME'));

    dmOtto.Notify(aMessageId,
      'Конец обработки файла: [FILE_NAME]', '',
      Value2Attr(MessageFileName, 'FILE_NAME'));
    dmOtto.ShowProtocol(aTransaction, aMessageId);
    dmOtto.MessageCommit(aTransaction, aMessageId);
  except
    aTransaction.Rollback;
  end
end;

procedure ProcessPayment(aMessageId: Integer; aTransaction: TpFIBTransaction);
var
  aXml: TGvXml;
begin
  PayInDeltaByr:= dmOtto.SettingGet(aTransaction, 'PAYIN_DELTA_BYR');
  aXml:= TGvXml.Create('MESSAGE');
  try
    ParsePayment(aMessageId, aXml.Root, aTransaction);
  finally
    aXml.Free;
  end;
end;


end.
