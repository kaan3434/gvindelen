unit uParseProtocol;

interface

uses
  GvXml, FIBDatabase, pFIBDatabase;

procedure ProcessProtocol(aMessageId: Integer; aTransaction: TpFIBTransaction);

implementation

uses
  Classes, SysUtils, GvStr, udmOtto, Variants, GvXmlUtils,
  Dialogs, Controls, StrUtils;

procedure ParseProtocolLine100(aMessageId, LineNo, DealId: Integer;
  sl: TStringList; ndProduct, ndOrders: TGvXmlNode;
  aTransaction: TpFIBTransaction; aLine: String);
var
  OrderId, DealerId: variant;
  ndOrder, ndOrderItems: TGvXmlNode;
  StatusSign, StatusName: Variant;
begin
  OrderId:= dmOtto.DetectOrderId(ndProduct, sl[1], aTransaction);
  if OrderId <> null then
  begin
    ndOrder:= ndOrders.AddChild('ORDER');
    dmOtto.ObjectGet(ndOrder, OrderId, aTransaction);
    ndOrderItems:= ndOrder.AddChild('ORDERITEMS');
    dmOtto.OrderItemsGet(ndOrderItems, OrderId, aTransaction);
    dmOtto.Notify(aMessageId,
      '[LINE_NO]. Заявка [ORDER_CODE]. [RESOLUTION]',
      'I',
      Value2Attr(LineNo, 'LINE_NO',
      XmlAttrs2Attr(ndOrder, 'ORDER_CODE',
      Strings2Attr(sl, 'RESOLUTION=13'))));
  end
  else
  begin
    DealerId:= dmOtto.IsDealerOrder(ndProduct, sl[1], aTransaction);
    if DealerId <> null then
    begin
      dmOtto.Notify(aMessageId,
        '[LINE_NO]. Заявка [ORDER_CODE]. Заявка дилера [DEALER_ID]',
        'I',
        Value2Attr(LineNo, 'LINE_NO',
        Value2Attr(DealerId, 'DEALER_ID',
        Value2Attr(dmOtto.DetectOrderCode(ndProduct, sl[1]), 'ORDER_CODE'))));
      dmOtto.DealerNotify(aMessageId, DealerId, aLine, aTransaction);
    end
    else
      dmOtto.Notify(aMessageId,
        '[LINE_NO]. Заявка [ORDER_CODE] не найдена.',
        'E',
        Value2Attr(LineNo, 'LINE_NO',
        Value2Attr(dmOtto.DetectOrderCode(ndProduct, sl[1]), 'ORDER_CODE')));
  end;
end;

procedure ParseProtocolLine200(aMessageId, LineNo, DealId: Integer;
  sl: TStringList; ndProduct, ndOrders: TGvXmlNode;
  aTransaction: TpFIBTransaction; aLine: string);
var
  OrderId, DealerId, OrderItemId: Variant;
  ndOrder, ndOrderItems, ndOrderItem: TGvXmlNode;
  StatusSign, StateSign, StateId, StatusName: variant;
  MsgType, DeliveryMessageRus, Dimension: string;
  DeltaPriceEur: variant;
begin
  if sl[0] = '-1' then
  begin
    sl.DelimitedText:= CopyBetween(sl.DelimitedText, '[', ']');
    sl.Insert(1, sl[1]);
    sl[3]:= '';
    sl[4]:= '';
    sl[9]:= '9';
  end;

  OrderId:= dmOtto.DetectOrderId(ndProduct, sl[1], aTransaction);
  if OrderId <> null then
  begin
    ndOrder:= ndOrders.Find('ORDER', 'ID', OrderId);
    if ndOrder = nil then
    begin
      ndOrder:= ndOrders.AddChild('ORDER');
      ndOrderItems:= ndOrder.AddChild('ORDERITEMS');
      dmOtto.ObjectGet(ndOrder, OrderId, aTransaction);
      dmOtto.OrderItemsGet(ndOrderItems, OrderId, aTransaction);
    end
    else
      ndOrderItems:= ndOrder.Find('ORDERITEMS');

    Dimension:= dmOtto.Recode('ORDERITEM', 'DIMENSION', sl[6]);

    ndOrderItem:= ndOrderItems.Find('ORDERITEM', 'ARTICLE_CODE;DIMENSION;STATUS_SIGN',
      [sl[5], VarArrayOf([Dimension, sl[6]]), VarArrayOf(['ACCEPTREQUEST', 'APPROVED'])]);
    if ndOrderItem <> nil then
    begin
      OrderItemId:= ndOrderItem['ID'];
      ndOrderItem['DIMENSION'] := Dimension;
      ndOrderItem['AUFTRAG_ID']:= sl[3];
      ndOrderItem['ORDERITEM_INDEX']:= sl[4];

      // получаем новое статус
      StateSign:= dmOtto.Recode('ORDERITEM', 'DELIVERY_CODE_TIME', sl[9]+sl[10]);
      if StateSign = sl[9]+sl[10] then
      begin
        StateSign:= dmOtto.Recode('ORDERITEM', 'DELIVERY_MESSAGE', sl[11]);
        if StateSign = sl[11] then
        begin
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Неизвестная комбинация DeliveryCode = [DELIVERY_CODE], DeliveryTime = [DELIVERY_TIME]',
            'E',
            XmlAttrs2Attr(ndOrderItem, 'AUFTRAG_ID;ORDERITEM_INDEX;ORDER_ID;ARTICLE_CODE;DIMENSION',
            XmlAttrs2Attr(ndOrder, 'ORDER_CODE',
            Value2Attr(LineNo, 'LINE_NO',
            Strings2Attr(sl, 'DELIVERY_CODE=9;DELIVERY_TIME=10')))));
        end;
      end;

      if IsWordPresent('AVAILABLE', dmOtto.GetFlagListBySign(StateSign),',') then
      // позиция принята
      begin
        StatusSign:= 'ACCEPTED';

        // сверяем цены
        ndOrderItem['PRICE_EUR']:= StrToCurr(sl[8]);
        DeltaPriceEur:= ndOrderItem.Attr['PRICE_EUR'].AsMoney - ndOrderItem.Attr['COST_EUR'].AsMoney;
        if DeltaPriceEur <> 0 then
        begin
          if DeltaPriceEur < 0 then
            MsgType := 'W'
          else
            MsgType := 'E';
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Измнена цена [COST_EUR] => [PRICE_EUR].',
            MsgType,
            XmlAttrs2Attr(ndOrderItem, 'AUFTRAG_ID;ORDERITEM_INDEX;ARTICLE_CODE;DIMENSION;PRICE_EUR;COST_EUR',
            XmlAttrs2Attr(ndOrder, 'ORDER_CODE',
            Value2Attr(LineNo, 'LINE_NO'))));
          ndOrderItem.Attr['COST_EUR'].AsMoney:= ndOrderItem.Attr['PRICE_EUR'].AsMoney*ndOrderItem['AMOUNT'];
        end;
      end
      else
        StatusSign:= 'REJECTED';

      DeliveryMessageRus:= dmOtto.Recode('ORDERITEM', 'DELIVERY_MESSAGE_RUS', sl[11]);
      try
        ndOrderItem.State:= stChanged;
        dmOtto.ActionExecute(aTransaction, ndOrderItem, StatusSign);
        dmOtto.ObjectGet(ndOrderItem, OrderItemId, aTransaction);
        dmOtto.Notify(aMessageId,
          '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. [STATUS_NAME] ([DELIVERY_MESSAGE_RUS]).',
          'I',
          XmlAttrs2Attr(ndOrder, 'ORDER_CODE',
          XmlAttrs2Attr(ndOrderItem, 'AUFTRAG_ID;ORDERITEM_INDEX;ARTICLE_CODE;DIMENSION;STATUS_NAME',
          Value2Attr(DeliveryMessageRus, 'DELIVERY_MESSAGE_RUS',
          Value2Attr(LineNo, 'LINE_NO')))));
      except
        on E: Exception do
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Ошибка ([ERROR_TEXT])',
            'E',
            XmlAttrs2Attr(ndOrderItem, 'AUFTRAG_ID;ORDERITEM_INDEX;ARTICLE_CODE;DIMENSION',
            XmlAttrs2Attr(ndOrder, 'ORDER_CODE',
            Value2Attr(LineNo, 'LINE_NO',
            Value2Attr(E.Message, 'ERROR_TEXT')))));
      end;
    end
    else
      dmOtto.Notify(aMessageId,
          '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Позиция не найдена в заявке.',
          'E', Strings2Attr(sl, 'AUFTRAG_ID=3;ORDERITEM_INDEX=4;ARTICLE_CODE=5;DIMENSION=6',
               XmlAttrs2Attr(ndOrder, 'ORDER_CODE;ORDER_ID=ID',
               Value2Attr(LineNo, 'LINE_NO'))));
  end
  else
  begin
    DealerId:= dmOtto.IsDealerOrder(ndProduct, sl[1], aTransaction);
    if DealerId <> null then
    begin
      dmOtto.Notify(aMessageId,
        '[LINE_NO]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Заявка [ORDER_CODE] дилера [DEALER_ID]',
        'I',
        Strings2Attr(sl, 'AUFTRAG_ID=3;ORDERITEM_INDEX=4;ARTICLE_CODE=5;DIMENSION=6',
        Value2Attr(LineNo, 'LINE_NO',
        Value2Attr(DealerId, 'DEALER_ID',
        Value2Attr(dmOtto.DetectOrderCode(ndProduct, sl[1]), 'ORDER_CODE')))));
      dmOtto.DealerNotify(aMessageId, DealerId, aLine, aTransaction);
    end
    else
      dmOtto.Notify(aMessageId,
        '[LINE_NO]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Неизвестная заявка [ORDER_CODE].',
        'E',
        Strings2Attr(sl, 'AUFTRAG_ID=3;ORDERITEM_INDEX=4;ARTICLE_CODE=5;DIMENSION=6;ORDER_CODE=1',
        Value2Attr(LineNo, 'LINE_NO')));
  end;
end;

procedure ParseProtocolLine(aMessageId, LineNo, DealId: Integer; aLine: string;
  ndProduct, ndOrders: TGvXmlNode; aTransaction: TpFIBTransaction);
var
  sl: TStringList;
begin
  sl:= TStringList.Create;
  try
    try
      sl.Delimiter:= ';';
      sl.DelimitedText:= '"'+ReplaceAll(aLine, ';', '";"')+'"';
      if sl[2] = '100' then
        ParseProtocolLine100(aMessageId, LineNo, DealId, sl, ndProduct, ndOrders, aTransaction, aLine)
      else
        ParseProtocolLine200(aMessageId, LineNo, DealId, sl, ndProduct, ndOrders, aTransaction, aLine);
    except
      on E: Exception do
      dmOtto.Notify(aMessageId,
        '[LINE_NO]. [ERROR_TEXT]',
        'E',
        Value2Attr(LineNo, 'LINE_NO',
        Value2Attr(DeleteChars(e.Message, #10#13), 'ERROR_TEXT')));
    end;
  finally
    sl.Free;
  end;
end;

procedure ParseProtocol(aMessageId: Integer; ndMessage: TGvXmlNode; aTransaction: TpFIBTransaction);
var
  LineNo, DealId, n: Integer;
  Lines: TStringList;
  MessageFileName: string;
  OrderId: Integer;
  ndProduct, ndOrders, ndOrder, ndOrderItems: TGvXmlNode;
begin
  ndMessage['ID']:= aMessageId;
  dmOtto.ClearNotify(aMessageId);
  aTransaction.StartTransaction;
  try
    dmOtto.ObjectGet(ndMessage, aMessageId, aTransaction);
    ndProduct:= ndMessage.FindOrCreate('PRODUCT');
    dmOtto.ObjectGet(ndProduct, dmOtto.DetectProductId(ndMessage, aTransaction), aTransaction);
    ndOrders:= ndMessage.FindOrCreate('ORDERS');

    MessageFileName:= ndMessage['FILE_NAME'];
    dmOtto.Notify(aMessageId, 'Начало обработки файла: [FILE_NAME]', '',
      Value2Attr(MessageFileName, 'FILE_NAME'));

    Lines:= TStringList.Create;
    try
      if FileExists(Path['Messages.In']+MessageFileName) then
      begin
        Lines.LoadFromFile(Path['Messages.In']+MessageFileName);
        dmOtto.InitProgress(Lines.Count*2, Format('Обработка файла %s ...', [MessageFileName]));
        For LineNo:= 0 to Lines.Count - 1 do
        begin
          ParseProtocolLine(aMessageId, LineNo+1, DealId, Lines[LineNo], ndProduct, ndOrders, aTransaction);
          dmOtto.StepProgress;
        end;

        For n:= 0 to ndOrders.ChildNodes.Count - 1 do
        begin
          ndOrder:= ndOrders.ChildNodes[n];
          OrderId:= ndOrder['ID'];
          dmOtto.ObjectGet(ndOrder, OrderId, aTransaction);
          if ndOrder.Attr['STATUS_SIGN'].ValueIn(['ACCEPTREQUEST']) then
          begin
            ndOrder['NEW.STATUS_SIGN']:= 'ACCEPTED';
            dmOtto.ActionExecute(aTransaction, ndOrder);
          end;
          dmOtto.StepProgress;
        end;
      end
      else
        dmOtto.Notify(aMessageId,
          'Файл [FILE_NAME] не найден.', 'E',
          Value2Attr(MessageFileName, 'FILE_NAME'));
    finally
      dmOtto.InitProgress;
      dmOtto.Notify(aMessageId,
        'Конец обработки файла: [FILE_NAME]', '',
        Value2Attr(MessageFileName, 'FILE_NAME'));
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
  aXml: TGvXml;
begin
  aXml:= TGvXml.Create('MESSAGE');
  try
    ParseProtocol(aMessageId, aXml.Root, aTransaction);
  finally
    aXml.Free;
  end;
end;


end.
