unit uParsePaymentsBP;

interface

uses
  GvXml, FIBDatabase, pFIBDatabase;

procedure ProcessPaymentBaltPost(aMessageId: Integer; aTransaction: TpFIBTransaction);

implementation

uses
  Classes, SysUtils, GvStr, udmOtto, Variants, GvXmlUtils,
  Dialogs, Controls, GvDtTm;

procedure ParsePaymentLine(aMessageId, LineNo: Integer; aLine: string;
  ndOrders: TGvXmlNode; aTransaction: TpFIBTransaction);
var
  sl: TStringList;
  PayDate: TDateTime;
  PaymentId, OrderId, OrderMoneyId: Variant;
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
      'select order_id from orders where bar_code like :bar_code',
      0, [sl[7]], aTransaction);
    if OrderId <> null then
    begin
      dmOtto.ObjectGet(ndOrder, OrderId, aTransaction);
      dmOtto.ObjectGet(ndAccount, ndOrder['ACCOUNT_ID'], aTransaction);
      dmOtto.OrderMoneysGet(ndOrderMoneys, OrderId, aTransaction);

      sl[5]:= FilterString(sl[5], '0123456789');
      sl[6]:= FilterString(sl[6], '0123456789,.');
      ndAccount['AMOUNT_BYR']:= StrToCurr(sl[5]);
      ndAccount['AMOUNT_EUR']:= StrToCurr(sl[6]);

      // получаем OrderMoney_Id зачисления без движения по счету
      try
        OrderMoneyId:= aTransaction.DefaultDatabase.QueryValue(
          'select om.ordermoney_id from ordermoneys om '+
          '  left join accopers ao on (ao.ordermoney_id = om.ordermoney_id) '+
          'where om.order_id = :order_id '+
          '  and om.amount_eur > 0 '+
          '  and ao.accoper_id is null',
          0, [OrderId], aTransaction);
        if OrderMoneyId <> null then
        begin
          ndOrderMoney:= ndOrderMoneys.Find('ORDERMONEY', 'ID', OrderMoneyId);
          aTransaction.ExecSQLImmediate(Format(
            'delete from ordermoneys om where om.ordermoney_id = %u', [Integer(OrderMoneyId)]));
          aTransaction.ExecSQLImmediate(Format(
            'update orders o '+
            'set o.cost_byr = (select o_money_byr from money_eur2byr(o.cost_eur, o.byr2eur)) '+
            'where o.order_id = %s', [OrderId]));
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Заявка [ORDER_CODE] [BAR_CODE]. Удалено фиктивное зачисление на [AMOUNT_BYR] BYR [AMOUNT_EUR] EUR',
            'I',
            XmlAttrs2Attr(ndOrder, 'ORDER_CODE;BAR_CODE',
            XmlAttrs2Attr(ndOrderMoney, 'AMOUNT_EUR;AMOUNT_BYR',
            Value2Attr(LineNo, 'LINE_NO'))));
          dmOtto.ObjectGet(ndOrder, OrderId, aTransaction);
          ndOrderMoneys.Clear;
          dmOtto.OrderMoneysGet(ndOrderMoneys, OrderId, aTransaction);
        end;
      except
        dmOtto.Notify(aMessageId,
          '[LINE_NO]. Заявка [ORDER_CODE] [BAR_CODE]. Не могу идентифицировать фиктивное зачисление. Сумма не зачислена',
          'E',
          XmlAttrs2Attr(ndOrder, 'ORDER_CODE;BAR_CODE',
          Value2Attr(LineNo, 'LINE_NO')));
        Exit;
      end;

      ndOrderMoney:= ndOrderMoneys.Find('ORDERMONEY', 'AMOUNT_BYR', sl[5]);
      if ndOrderMoney <> nil then
      begin
        dmOtto.Notify(aMessageId,
          '[LINE_NO]. Повторное зачисление суммы [AMOUNT_BYR] BYR [AMOUNT_EUR] EUR на заявку [ORDER_CODE] [BAR_CODE] c задолженностью [COST_BYR] BYR [COST_EUR] EUR. Сумма не зачислена',
          'E',
          XmlAttrs2Attr(ndOrder, 'ORDER_CODE;COST_BYR;COST_EUR;BAR_CODE',
          XmlAttrs2Attr(ndAccount, 'AMOUNT_BYR;AMOUNT_EUR',
          Value2Attr(LineNo, 'LINE_NO'))));
        Exit;
      end;

      try
        dmOtto.ActionExecute(aTransaction, 'ACCOUNT', 'ACCOUNT_PAYMENTIN',
          XmlAttrs2Attr(ndAccount, 'ID;AMOUNT_BYR',
          XmlAttrs2Attr(ndOrder, 'ORDER_ID=ID')));
        dmOtto.ObjectGet(ndOrder, OrderId, aTransaction);

        if ndOrder.Attr['STATUS_SIGN'].ValueIn(['DELIVERING']) then
        begin
          dmOtto.ActionExecute(aTransaction, 'ORDER', 'ORDER_DELIVERED', nil, OrderId);
          dmOtto.ObjectGet(ndOrder, OrderId, aTransaction);
        end;

        dmOtto.Notify(aMessageId,
          '[LINE_NO]. Сумма [AMOUNT_BYR] BYR [AMOUNT_EUR] EUR зачислена на заявку [ORDER_CODE] [BAR_CODE]. Статус заявки - [STATUS_NAME]',
          'I',
          XmlAttrs2Attr(ndOrder, 'ORDER_CODE;STATUS_NAME;BAR_CODE',
          Strings2Attr(sl, 'AMOUNT_BYR=5;AMOUNT_EUR=6',
          Value2Attr(LineNo, 'LINE_NO'))));
      except
        on E: Exception do
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Сумма [AMOUNT_BYR] BYR [AMOUNT_EUR] EUR. Заявка [ORDER_CODE] [BAR_CODE]. [ERROR_TEXT]',
            'E',
            XmlAttrs2Attr(ndOrder, 'ORDER_CODE;BAR_CODE',
            XmlAttrs2Attr(ndAccount, 'AMOUNT_BYR;AMOUNT_EUR',
            Value2Attr(LineNo, 'LINE_NO',
            Value2Attr(DeleteChars(e.Message, #10#13), 'ERROR_TEXT')))));
      end;
    end
    else
      dmOtto.Notify(aMessageId,
        '[LINE_NO]. Сумма [AMOUNT_BYR] BYR, [AMOUNT_EUR] EUR. Неизвестная заявка [BAR_CODE]',
        'E',
        Strings2Attr(sl, 'BAR_CODE=7;AMOUNT_BYR=5;AMOUNT_EUR=6',
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
        For LineNo:= 1 to Lines.Count - 1 do
        begin
          if CopyFront4(Lines[LineNo][1], ';') <> '' then
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

procedure ProcessPaymentBaltPost(aMessageId: Integer; aTransaction: TpFIBTransaction);
var
  aXml: TGvXml;
begin
  aXml:= TGvXml.Create('MESSAGE');
  try
    ParsePayment(aMessageId, aXml.Root, aTransaction);
  finally
    aXml.Free;
  end;
end;


end.
