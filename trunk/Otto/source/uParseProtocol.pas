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
  sl: TStringList; ndProduct, ndOrders: TXmlNode; aTransaction: TpFIBTransaction);
var
  OrderId: variant;
  ndOrder, ndOrderItems: TXmlNode;
  StatusSign, StatusName: Variant;
begin
  OrderId:= dmOtto.DetectOrderId(ndProduct, sl[1], aTransaction);
  if OrderId <> null then
  begin
    ndOrder:= ndOrders.NodeNew('ORDER');
    dmOtto.ObjectGet(ndOrder, OrderId, aTransaction);
    ndOrderItems:= ndOrder.NodeNew('ORDERITEMS');
    dmOtto.OrderItemsGet(ndOrderItems, OrderId, aTransaction);
    dmOtto.Notify(aMessageId,
      '[LINE_NO]. Заявка [ORDER_CODE]. [RESOLUTION]',
      'I',
      Value2Vars(LineNo, 'LINE_NO',
      XmlAttrs2Vars(ndOrder, 'ORDER_CODE',
      Strings2Vars(sl, 'RESOLUTION=13'))));
  end
  else
    dmOtto.Notify(aMessageId,
      '[LINE_NO]. Заявка [ORDER_CODE] не найдена.',
      'E',
      Value2Vars(LineNo, 'LINE_NO',
      Value2Vars(dmOtto.DetectOrderCode(ndProduct, sl[1]), 'ORDER_CODE')));
end;

procedure ParseProtocolLine200(aMessageId, LineNo, DealId: Integer;
  sl: TStringList; ndProduct, ndOrders: TXmlNode; aTransaction: TpFIBTransaction);
var
  OrderId, OrderItemId: Variant;
  ndOrder, ndOrderItems, ndOrderItem: TXmlNode;
  StatusSign, StateSign, StateId, StatusName: variant;
  DeliveryMessageRus, Dimension: string;
begin
  OrderId:= dmOtto.DetectOrderId(ndProduct, sl[1], aTransaction);
  if OrderId <> null then
  begin
    ndOrder:= ndOrders.NodeByAttributeValue('ORDER', 'ID', OrderId, False);
    if ndOrder = nil then
    begin
      ndOrder:= ndOrders.NodeNew('ORDER');
      ndOrderItems:= ndOrder.NodeNew('ORDERITEMS');
      dmOtto.ObjectGet(ndOrder, OrderId, aTransaction);
      dmOtto.OrderItemsGet(ndOrderItems, OrderId, aTransaction);
    end
    else
      ndOrderItems:= ndOrder.NodeByName('ORDERITEMS');

    Dimension:= dmOtto.Recode('ARTICLE', 'DIMENSION', sl[6]);

    ndOrderItem:= ChildByAttributes(ndOrderItems, 'ARTICLE_CODE;DIMENSION;STATUS_SIGN',
      [sl[5], VarArrayOf([Dimension, sl[6]]), VarArrayOf(['ACCEPTREQUEST', 'APPROVED'])]);
    if ndOrderItem <> nil then
    begin
      OrderItemId:= GetXmlAttrValue(ndOrderItem, 'ID');
      SetXmlAttr(ndOrderItem, 'DIMENSION', Dimension);
      SetXmlAttr(ndOrderItem, 'AUFTRAG_ID', sl[3]);
      SetXmlAttr(ndOrderItem, 'ORDERITEM_INDEX', sl[4]);

      SetXmlAttrAsMoney(ndOrderItem, 'PRICE_EUR', sl[8]);
      if GetXmlAttrAsMoney(ndOrderItem, 'PRICE_EUR') <> GetXmlAttrAsMoney(ndOrderItem, 'COST_EUR') then
      begin
        dmOtto.Notify(aMessageId,
          '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Измнена цена [COST_EUR] => [PRICE_EUR].',
          IfThen(GetXmlAttrValue(ndOrderItem, 'MAGAZINE_ID') = 1, 'W', 'E'),
          XmlAttrs2Vars(ndOrderItem, 'AUFTRAG_ID;ORDERITEM_INDEX;ARTICLE_CODE;DIMENSION;PRICE_EUR;COST_EUR',
          XmlAttrs2Vars(ndOrder, 'ORDER_CODE',
          Value2Vars(LineNo, 'LINE_NO'))));
        SetXmlAttrAsMoney(ndOrderItem, 'COST_EUR', GetXmlAttrValue(ndOrderItem, 'PRICE_EUR')*getXmlAttrValue(ndOrderItem, 'AMOUNT'));
      end;

      StateSign:= dmOtto.Recode('ORDERITEM', 'DELIVERY_CODE_TIME', sl[9]+sl[10]);
      if StateSign = sl[9]+sl[10] then
      begin
        StateSign:= dmOtto.Recode('ORDERITEM', 'DELIVERY_MESSAGE', sl[11]);
        if StateSign = sl[11] then
        begin
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Неизвестная комбинация DeliveryCode = [DELIVERY_CODE], DeliveryTime = [DELIVERY_TIME]',
            'E',
            XmlAttrs2Vars(ndOrderItem, 'AUFTRAG_ID;ORDERITEM_INDEX;ORDER_ID;ARTICLE_CODE;DIMENSION',
            XmlAttrs2Vars(ndOrder, 'ORDER_CODE',
            Value2Vars(LineNo, 'LINE_NO',
            Strings2Vars(sl, 'DELIVERY_CODE=9;DELIVERY_TIME=10')))));
        end;
      end;

      if IsWordPresent('AVAILABLE', dmOtto.GetFlagListBySign(StateSign),',') then
        StatusSign:= 'ACCEPTED'
      else
        StatusSign:= 'REJECTED';

      DeliveryMessageRus:= dmOtto.Recode('ORDERITEM', 'DELIVERY_MESSAGE_RUS', sl[11]);
      try
        ndOrderItem.ValueAsBool:= True;
        dmOtto.ActionExecute(aTransaction, ndOrderItem, StatusSign);
        dmOtto.ObjectGet(ndOrderItem, OrderItemId, aTransaction);
        dmOtto.Notify(aMessageId,
          '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. [STATUS_NAME] ([DELIVERY_MESSAGE_RUS]).',
          'I',
          XmlAttrs2Vars(ndOrder, 'ORDER_CODE',
          XmlAttrs2Vars(ndOrderItem, 'AUFTRAG_ID;ORDERITEM_INDEX;ARTICLE_CODE;DIMENSION;STATUS_NAME',
          Value2Vars(DeliveryMessageRus, 'DELIVERY_MESSAGE_RUS',
          Value2Vars(LineNo, 'LINE_NO')))));
      except
        on E: Exception do
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Ошибка ([ERROR_TEXT])',
            'E',
            XmlAttrs2Vars(ndOrderItem, 'AUFTRAG_ID;ORDERITEM_INDEX;ARTICLE_CODE;DIMENSION',
            XmlAttrs2Vars(ndOrder, 'ORDER_CODE',
            Value2Vars(LineNo, 'LINE_NO',
            Value2Vars(E.Message, 'ERROR_TEXT')))));
      end;
    end
    else
      dmOtto.Notify(aMessageId,
          '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Позиция не найдена в заявке.',
          'E', Strings2Vars(sl, 'AUFTRAG_ID=3;ORDERITEM_INDEX=4;ARTICLE_CODE=5;DIMENSION=6',
               XmlAttrs2Vars(ndOrder, 'ORDER_CODE;ORDER_ID=ID',
               Value2Vars(LineNo, 'LINE_NO'))));
  end
  else
    dmOtto.Notify(aMessageId,
      '[LINE_NO]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Неизвестная заявка [ORDER_CODE].',
      'E',
      Strings2Vars(sl, 'AUFTRAG_ID=3;ORDERITEM_INDEX=4;ARTICLE_CODE=5;DIMENSION=6;ORDER_CODE=1',
      Value2Vars(LineNo, 'LINE_NO')));
end;

procedure ParseProtocolLine(aMessageId, LineNo, DealId: Integer; aLine: string;
  ndProduct, ndOrders: TXmlNode; aTransaction: TpFIBTransaction);
var
  sl: TStringList;
begin
  sl:= TStringList.Create;
  try
    try
      sl.Delimiter:= ';';
      sl.DelimitedText:= '"'+ReplaceAll(aLine, ';', '";"')+'"';
      if sl[2] = '100' then
        ParseProtocolLine100(aMessageId, LineNo, DealId, sl, ndProduct, ndOrders, aTransaction)
      else
        ParseProtocolLine200(aMessageId, LineNo, DealId, sl, ndProduct, ndOrders, aTransaction);
    except
      on E: Exception do
      dmOtto.Notify(aMessageId,
        '[LINE_NO]. [ERROR_TEXT]',
        'E',
        Value2Vars(LineNo, 'LINE_NO',
        Value2Vars(DeleteChars(e.Message, #10#13), 'ERROR_TEXT')));
    end;
  finally
    sl.Free;
  end;
end;

procedure ParseProtocol(aMessageId: Integer; ndMessage: TXmlNode; aTransaction: TpFIBTransaction);
var
  LineNo, DealId, n: Integer;
  Lines: TStringList;
  MessageFileName: string;
  ndProduct, ndOrders, ndOrder, ndOrderItems: TXmlNode;
begin
  dmOtto.ClearNotify(aMessageId);
  if not aTransaction.Active then
    aTransaction.StartTransaction;
  try
    dmOtto.ObjectGet(ndMessage, aMessageId, aTransaction);
    ndProduct:= ndMessage.NodeFindOrCreate('PRODUCT');
    dmOtto.ObjectGet(ndProduct, dmOtto.DetectProductId(ndMessage, aTransaction), aTransaction);
    ndOrders:= ndMessage.NodeFindOrCreate('ORDERS');

    MessageFileName:= GetXmlAttrValue(ndMessage, 'FILE_NAME');
    dmOtto.Notify(aMessageId, 'Начало обработки файла: [FILE_NAME]', '',
      Value2Vars(MessageFileName, 'FILE_NAME'));

    Lines:= TStringList.Create;
    try
      if FileExists(Path['Messages.In']+MessageFileName) then
      begin
        Lines.LoadFromFile(Path['Messages.In']+MessageFileName);
        ndOrder:= ndOrders.NodeNew('ORDER');
        dmOtto.InitProgress(Lines.Count*2, Format('Обработка файла %s ...', [MessageFileName]));
        For LineNo:= 0 to Lines.Count - 1 do
        begin
          ParseProtocolLine(aMessageId, LineNo+1, DealId, Lines[LineNo], ndProduct, ndOrders, aTransaction);
          dmOtto.StepProgress;
        end;

        For n:= 0 to ndOrders.NodeCount - 1 do
        begin
          ndOrder:= ndOrders[n];
          if XmlAttrIn(ndOrder, 'STATUS_SIGN', 'ACCEPTREQUEST') then
            dmOtto.ActionExecute(aTransaction, ndOrder, 'ACCEPTED');
          dmOtto.StepProgress;
        end;
      end
      else
        dmOtto.Notify(aMessageId,
          'Файл [FILE_NAME] не найден.', 'E',
          Value2Vars(MessageFileName, 'FILE_NAME'));
    finally
      dmOtto.InitProgress;
      dmOtto.Notify(aMessageId,
        'Конец обработки файла: [FILE_NAME]', '',
        Value2Vars(MessageFileName, 'FILE_NAME'));
      Lines.Free;
    end;
    dmOtto.ShowProtocol(aTransaction, aMessageId);
    dmOtto.MessageCommit(aTransaction, aMessageId);
  except
    aTransaction.Rollback;
  end
end;

procedure ProcessProtocol(aMessageId: Integer; aTransaction: TpFIBTransaction);
var
  aXml: TNativeXml;
begin
  aXml:= TNativeXml.CreateName('MESSAGE');
  try
    ParseProtocol(aMessageId, aXml.Root, aTransaction);
  finally
    aXml.Free;
  end;
end;


end.
