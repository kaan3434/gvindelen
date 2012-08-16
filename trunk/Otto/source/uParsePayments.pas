unit uParsePayments;

interface

uses
  NativeXml, FIBDatabase, pFIBDatabase;

procedure ProcessPayment(aMessageId: Integer; aTransaction: TpFIBTransaction);

implementation

uses
  Classes, SysUtils, GvStr, udmOtto, Variants, GvNativeXml,
  Dialogs, Controls, GvDtTm;

procedure ParsePaymentLine(aMessageId, LineNo: Integer; aLine: string;
  ndOrders: TXmlNode; aTransaction: TpFIBTransaction);
var
  sl: TStringList;
  PayDate: TDateTime;
  PaymentId, OrderId, CostByr, CostEur: Variant;
  Xml: TNativeXml;
  ndOrder, ndAccount, ndOrderMoneys, ndOrderMoney: TXmlNode;
begin
  ndOrder:= ndOrders.NodeNew('ORDER');
  ndAccount:= ndOrder.NodeNew('ACCOUNT');
  ndOrderMoneys:= ndOrder.NodeNew('ORDERMONEYS');
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
      dmOtto.ObjectGet(ndAccount, GetXmlAttrValue(ndOrder, 'ACCOUNT_ID'), aTransaction);
      dmOtto.OrderMoneysGet(ndOrderMoneys, OrderId, aTransaction);

      PayDate:= DateTimeStrEval('DD.MM.YYYY', sl[0]);

      CostByr:= aTransaction.DefaultDatabase.QueryValue(
        'select cost_byr '+
        'from v_order_summary os '+
        'where os.order_id = :order_id',
        0, [OrderId], aTransaction);
      CostEur:= aTransaction.DefaultDatabase.QueryValue(
        'select cost_eur '+
        'from v_order_summary os '+
        'where os.order_id = :order_id',
        0, [OrderId], aTransaction);

      SetXmlAttrAsMoney(ndOrder, 'COST_BYR', CostByr);
      SetXmlAttrAsMoney(ndOrder, 'COST_EUR', CostEur);
      SetXmlAttrAsMoney(ndAccount, 'AMOUNT_BYR', sl[1]);

      ndOrderMoneys:= ndOrderMoneys.NodeByAttributeValue('ORDERMONEY', 'AMOUNT_BYR', sl[1], false);
      if ndOrderMoney <> nil then
      begin
        dmOtto.Notify(aMessageId,
          '[LINE_NO]. Повторное зачисление суммы [AMOUNT_BYR] BYR на заявку [ORDER_CODE] c задолженностью [COST_BYR]',
          'E',
          XmlAttrs2Vars(ndOrder, 'ORDER_CODE;COST_BYR',
          XmlAttrs2Vars(ndAccount, 'AMOUNT_BYR',
          Value2Vars(LineNo, 'LINE_NO'))));
        Exit;
      end;

      if not FlagPresent('PAYINABLE', ndOrder, 'STATUS_FLAG_LIST') then
      begin
        dmOtto.Notify(aMessageId,
          '[LINE_NO]. Попытка зачисления суммы [AMOUNT_BYR] BYR на заявку [ORDER_CODE] в статусе [STATUS_NAME]',
          'W',
          XmlAttrs2Vars(ndOrder, 'ORDER_CODE;STATUS_NAME',
          XmlAttrs2Vars(ndAccount, 'AMOUNT_BYR',
          Value2Vars(LineNo, 'LINE_NO'))));
      end;

      if GetXmlAttrAsMoney(ndOrder, 'COST_BYR') <> GetXmlAttrAsMoney(ndAccount, 'AMOUNT_BYR') then
      begin
        dmOtto.Notify(aMessageId,
          '[LINE_NO]. Попытка зачисления суммы [AMOUNT_BYR] BYR на заявку [ORDER_CODE] c задолженностью [COST_BYR]',
          'W',
          XmlAttrs2Vars(ndOrder, 'ORDER_CODE;COST_BYR',
          XmlAttrs2Vars(ndAccount, 'AMOUNT_BYR',
          Value2Vars(LineNo, 'LINE_NO'))));
      end;

      try
        dmOtto.ActionExecute(aTransaction, 'ACCOUNT', 'ACCOUNT_PAYMENTIN',
          XmlAttrs2Vars(ndAccount, 'ID;AMOUNT_BYR',
          XmlAttrs2Vars(ndOrder, 'ORDER_ID=ID')));
        dmOtto.ObjectGet(ndOrder, OrderId, aTransaction);

        dmOtto.Notify(aMessageId,
          '[LINE_NO]. Сумма [AMOUNT_BYR] BYR зачислена на заявку [ORDER_CODE]. Статус заявки - [STATUS_NAME]',
          'I',
          XmlAttrs2Vars(ndOrder, 'ORDER_CODE;STATUS_NAME',
          Strings2Vars(sl, 'AMOUNT_BYR=1',
          Value2Vars(LineNo, 'LINE_NO'))));
      except
        on E: Exception do
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Сумма [AMOUNT_BYR] BYR. Заявка [ORDER_CODE]. [ERROR_TEXT]',
            'E',
            XmlAttrs2Vars(ndOrder, 'ORDER_CODE',
            XmlAttrs2Vars(ndAccount, 'AMOUNT_BYR',
            Value2Vars(LineNo, 'LINE_NO',
            Value2Vars(DeleteChars(e.Message, #10#13), 'ERROR_TEXT')))));
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
  end;
end;

procedure ParsePayment(aMessageId: Integer; ndMessage: TXmlNode; aTransaction: TpFIBTransaction);
var
  LineNo: Integer;
  Lines: TStringList;
  MessageFileName: variant;
  ndOrders: TXmlNode;
begin
  dmOtto.ClearNotify(aMessageId);
  aTransaction.StartTransaction;
  try
    dmOtto.ObjectGet(ndMessage, aMessageId, aTransaction);
    ndOrders:= ndMessage.NodeFindOrCreate('ORDERS');

    MessageFileName:= GetXmlAttrValue(ndMessage, 'FILE_NAME');
    dmOtto.Notify(aMessageId,
      'Начало обработки файла: [FILE_NAME]', '',
      Value2Vars(MessageFileName, 'FILE_NAME'));

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
        Value2Vars(MessageFileName, 'FILE_NAME'));

    dmOtto.Notify(aMessageId,
      'Конец обработки файла: [FILE_NAME]', '',
      Value2Vars(MessageFileName, 'FILE_NAME'));
    dmOtto.ShowProtocol(aTransaction, aMessageId);
    dmOtto.MessageCommit(aTransaction, aMessageId);
  except
    aTransaction.Rollback;
  end
end;

procedure ProcessPayment(aMessageId: Integer; aTransaction: TpFIBTransaction);
var
  aXml: TNativeXml;
begin
  aXml:= TNativeXml.CreateName('MESSAGE');
  try
    ParsePayment(aMessageId, aXml.Root, aTransaction);
  finally
    aXml.Free;
  end;
end;


end.
