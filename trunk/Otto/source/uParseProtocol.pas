unit uParseProtocol;

interface

uses
  NativeXml, FIBDatabase, pFIBDatabase;

procedure ProcessProtocol(aMessageId: Integer; aTransaction: TpFIBTransaction);

implementation

uses
  Classes, SysUtils, GvStr, udmOtto, Variants, GvNativeXml,
  Dialogs, Controls, StrUtils;

procedure ParseProtocolLine100(aMessageId, LineNo, DealId: Integer;
  sl: TStringList; ndOrders: TXmlNode; aTransaction: TpFIBTransaction);
var
  OrderId: variant;
  OrderCode: widestring;
  ndOrder, ndClient: TXmlNode;
  StatusSign, StatusName: Variant;
begin
  OrderCode:= FillFront(sl[1],5, '0');
  OrderId:= aTransaction.DefaultDatabase.QueryValue(
    'select o.order_id from orders o where order_code like ''_''||:order_code',
    0, [OrderCode], aTransaction);
  if OrderId <> null then
  begin
    dmOtto.Notify(aMessageId,
      '[LINE_NO]. Заявка [ORDER_CODE]. [RESOLUTION]',
      'I',
      Value2Vars(LineNo, 'LINE_NO',
      Strings2Vars(sl, 'ORDER_CODE=1;RESOLUTION=13')));
  end
  else
    dmOtto.Notify(aMessageId,
      '[LINE_NO]. Заявка [ORDER_CODE] не найдена.',
      'E',
      Value2Vars(LineNo, 'LINE_NO',
      Strings2Vars(sl, 'ORDER_CODE=1')));
end;

procedure ParseProtocolLine200(aMessageId, LineNo, DealId: Integer;
  sl: TStringList; ndOrders: TXmlNode; aTransaction: TpFIBTransaction);
var
  OrderId: Variant;
  ndOrder, ndOrderItems, ndOrderItem: TXmlNode;
  StateSign, StateId, StatusName: variant;
  NewDeliveryMessage, Dimension: string;
begin
  OrderId:= aTransaction.DefaultDatabase.QueryValue(
    'select o.order_id from orders o where order_code like ''_''||:order_code',
    0, [FillFront(sl[1],5, '0')], aTransaction);
  if OrderId <> null then
  begin
    ndOrder:= ndOrders.NodeByAttributeValue('ORDER', 'ID', OrderId);
    if ndOrder = nil then
    begin
      ndOrder:= ndOrders.NodeNew('ORDER');
      ndOrderItems:= ndOrder.NodeNew('ORDERITEMS');
      dmOtto.ObjectGet(ndOrder, OrderId, aTransaction);
      dmOtto.OrderItemsGet(ndOrderItems, OrderId, aTransaction);
    end;

    Dimension:= dmOtto.Recode('ARTICLE', 'DIMENSION', sl[6]);

    ndOrderItem:= ChildByAttributes(ndOrder.NodeByName('ORDERITEMS'), 'ARTICLE_CODE;DIMENSION;STATUS_SIGN',
      [sl[5], Dimension, 'ACCEPTREQUEST']);
    if ndOrderItem = nil then
      ndOrderItem:= ChildByAttributes(ndOrder.NodeByName('ORDERITEMS'), 'ARTICLE_CODE;DIMENSION;STATUS_SIGN',
        [sl[5], sl[6], 'ACCEPTREQUEST']);

    if ndOrderItem <> nil then
    begin
      SetXmlAttr(ndOrderItem, 'DIMENSION', Dimension);
      ndOrder.ValueAsBool:= True;
      SetXmlAttrAsMoney(ndOrderItem, 'PRICE_EUR', sl[8]);
      SetXmlAttr(ndOrderItem, 'ORDERITEM_INDEX', sl[4]);

      // если ауфтрак еще не присвоен, сохраняем его на заявке
      if GetXmlAttrValue(ndOrder, 'AUFTRAG_ID') <> sl[3] then
      begin
        SetXmlAttr(ndOrder, 'AUFTRAG_ID', sl[3]);
        dmOtto.ActionExecute(aTransaction, ndOrder);
        dmOtto.ObjectGet(ndOrder, OrderId, aTransaction);
      end;

      if GetXmlAttrAsMoney(ndOrderItem, 'PRICE_EUR') <> GetXmlAttrAsMoney(ndOrderItem, 'COST_EUR') then
      begin
        dmOtto.Notify(aMessageId,
          '[LINE_NO]. Заявка [ORDER_CODE]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Измнена цена [COST_EUR] => [PRICE_EUR].',
          IfThen(GetXmlAttrValue(ndOrderItem, 'MAGAZINE_ID') = 1, 'W', 'E'),
          XmlAttrs2Vars(ndOrderItem, 'ORDERITEM_ID=ID;ORDERITEM_INDEX;ORDER_ID;ARTICLE_CODE;DIMENSION;PRICE_EUR;COST_EUR',
          XmlAttrs2Vars(ndOrder, 'ORDER_CODE',
          Value2Vars(LineNo, 'LINE_NO'))));
        SetXmlAttrAsMoney(ndOrderItem, 'COST_EUR', GetXmlAttrValue(ndOrderItem, 'PRICE_EUR')*getXmlAttrValue(ndOrderItem, 'AMOUNT'));
      end;

      StateSign:= dmOtto.Recode('ORDERITEM', 'DELIVERY_CODE_TIME', sl[9]+sl[10]);
      if StateSign = sl[9]+sl[10] then
      begin
        StateId:= GetXmlAttrValue(ndOrderItem, 'STATE_ID');
        dmOtto.Notify(aMessageId,
          '[LINE_NO]. Заявка [ORDER_CODE]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Неизвестная комбинация DeliveryCode = [DELIVERY_CODE], DeliveryTime = [DELIVERY_TIME]',
          'E',
          XmlAttrs2Vars(ndOrderItem, 'ORDERITEM_ID=ID;ORDERITEM_INDEX;ORDER_ID;ARTICLE_CODE;DIMENSION',
          XmlAttrs2Vars(ndOrder, 'ORDER_CODE',
          Value2Vars(LineNo, 'LINE_NO',
          Strings2Vars(sl, 'DELIVERY_CODE=9;DELIVERY_TIME=10')))));
      end
      else
        StateId:= dmOtto.GetStatusBySign('ORDERITEM', StateSign);
      NewDeliveryMessage:= dmOtto.Recode('ORDERITEM', 'DELIVERY_MESSAGE', sl[11]);
      if NewDeliveryMessage <> sl[11] then
        StateId:= dmOtto.GetStatusBySign('ORDERITEM', NewDeliveryMessage);

      NewDeliveryMessage:= dmOtto.Recode('ORDERITEM', 'DELIVERY_MESSAGE_RUS', sl[11]);
      if Pos(',AVAILABLE,', dmOtto.GetFlagListById(StateId)) = 0 then
      begin
        SetXmlAttr(ndOrderItem, 'STATE_ID', null);
        SetXmlAttr(ndOrderItem, 'NEW.STATUS_SIGN', 'REJECTED')
      end
      else
      begin
        SetXmlAttr(ndOrderItem, 'NEW.STATUS_SIGN', 'ACCEPTED');
        SetXmlAttr(ndOrderItem, 'STATE_ID', StateId);
      end;

      try
        StatusName:= aTransaction.DefaultDatabase.QueryValue(
          'select status_name from statuses where object_sign=''ORDERITEM'' and status_sign = :status_sign',
          0, [GetXmlAttrValue(ndOrderItem, 'NEW.STATUS_SIGN')]);
        ndOrderItem.ValueAsBool:= True;
        dmOtto.ActionExecute(aTransaction, ndOrderItem);
        dmOtto.Notify(aMessageId,
          '[LINE_NO]. Заявка [ORDER_CODE]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. [NEW.STATUS_NAME] ([DELIVERY_MESSAGE_RUS]).',
          'I',
          XmlAttrs2Vars(ndOrder, 'ORDER_CODE',
          XmlAttrs2Vars(ndOrderItem, 'ORDERITEM_ID=ID;ORDERITEM_INDEX;ORDER_ID;ARTICLE_CODE;DIMENSION',
          Value2Vars(NewDeliveryMessage, 'DELIVERY_MESSAGE_RUS',
          Value2Vars(LineNo, 'LINE_NO',
          Value2Vars(StatusName, 'NEW.STATUS_NAME'))))));
      except
        on E: Exception do
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Заявка [ORDER_CODE]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Ошибка ([ERROR_TEXT])',
            'E',
            XmlAttrs2Vars(ndOrderItem, 'ORDERITEM_ID=ID;ORDERITEM_INDEX;ORDER_ID;ARTICLE_CODE;DIMENSION',
            XmlAttrs2Vars(ndOrder, 'ORDER_CODE',
            Value2Vars(LineNo, 'LINE_NO',
            Value2Vars(E.Message, 'ERROR_TEXT')))));
      end;
    end
    else
      dmOtto.Notify(aMessageId,
          '[LINE_NO]. Заявка [ORDER_CODE]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Позиция не найдена в заявке.',
          'E', Strings2Vars(sl, 'ORDERITEM_INDEX=4;ARTICLE_CODE=5;DIMENSION=6',
               XmlAttrs2Vars(ndOrder, 'ORDER_CODE;ORDER_ID=ID',
               Value2Vars(LineNo, 'LINE_NO'))));
  end
  else
    dmOtto.Notify(aMessageId,
      '[LINE_NO]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Неизвестная заявка [ORDER_CODE].',
      'E',
      Strings2Vars(sl, 'ORDERITEM_INDEX=4;ARTICLE_CODE=5;DIMENSION=6;ORDER_CODE=1',
      Value2Vars(LineNo, 'LINE_NO')));
end;

procedure ParseProtocolLine(aMessageId, LineNo, DealId: Integer; aLine: string; ndOrders: TXmlNode; aTransaction: TpFIBTransaction);
var
  sl: TStringList;
begin
  sl:= TStringList.Create;
  try
    try
      sl.Delimiter:= ';';
      sl.DelimitedText:= '"'+ReplaceAll(aLine, ';', '";"')+'"';
      if sl[2] = '100' then
        ParseProtocolLine100(aMessageId, LineNo, DealId, sl, ndOrders, aTransaction)
      else
        ParseProtocolLine200(aMessageId, LineNo, DealId, sl, ndOrders, aTransaction);
    except
      on E: Exception do
      dmOtto.Notify(aMessageId,
        '[LINE_NO]. [ERROR_TEXT]',
        'E',
        Value2Vars(LineNo, 'LINE_NO',
        Value2Vars(e.Message, 'ERROR_TEXT')));
    end;
  finally
    sl.Free;
  end;
end;

procedure ParseProtocol(aMessageId: Integer; ndOrders: TXmlNode; aTransaction: TpFIBTransaction);
var
  LineNo, DealId, n: Integer;
  Lines: TStringList;
  MessageFileName: variant;
  ndOrder, ndOrderItems: TXmlNode;
begin
  dmOtto.ClearNotify(aMessageId);
  MessageFileName:= dmOtto.dbOtto.QueryValue(
    'select m.file_name from messages m where m.message_id = :message_id', 0,
    [aMessageId]);
  dmOtto.Notify(aMessageId, 'Начало обработки файла: [FILE_NAME]', 'I',
    Value2Vars(MessageFileName, 'FILE_NAME'));
  // загружаем файл
  Lines:= TStringList.Create;
  try
    Lines.LoadFromFile(Path['Messages.In']+MessageFileName);
    ndOrder:= ndOrders.NodeNew('ORDER');
    dmOtto.InitProgress(Lines.Count, Format('Ообработка файла %s ...', [MessageFileName]));
    For LineNo:= 0 to Lines.Count - 1 do
      ParseProtocolLine(aMessageId, LineNo, DealId, Lines[LineNo], ndOrders, aTransaction);
    For n:= 0 to ndOrders.NodeCount - 1 do
    begin
      ndOrder:= ndOrders[n];
      if XmlAttrIn(ndOrder, 'STATUS_SIGN', 'ACCEPTREQUEST') then
        dmOtto.ActionExecute(aTransaction, ndOrder, 'ACCEPTED');
      dmOtto.StepProgress;
    end;
  finally
    dmOtto.InitProgress;
    dmOtto.Notify(aMessageId,
      'Конец обработки файла: [FILE_NAME]', 'I',
      Value2Vars(MessageFileName, 'FILE_NAME'));
    Lines.Free;
  end;
end;

procedure ProcessProtocol(aMessageId: Integer; aTransaction: TpFIBTransaction);
var
  aXml: TNativeXml;
begin
  aXml:= TNativeXml.CreateName('MESSAGE');
  SetXmlAttr(aXml.Root, 'MESSAGE_ID', aMessageId);
  try
    if not aTransaction.Active then
      aTransaction.StartTransaction;
    try
      ParseProtocol(aMessageId, aXml.Root, aTransaction);
      dmOtto.MessageRelease(aTransaction, aMessageId);
      dmOtto.MessageSuccess(aTransaction, aMessageId);
      aTransaction.Commit;
    except
      aTransaction.Rollback;
    end;
  finally
    aXml.Free;
  end;
end;


end.
