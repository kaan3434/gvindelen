unit uParseLiefer;

interface

uses
  GvXml, FIBDatabase, pFIBDatabase;

procedure ProcessLiefer(aMessageId: Integer; aTransaction: TpFIBTransaction);

implementation

uses
  Classes, SysUtils, GvStr, udmOtto, pFIBStoredProc, Variants, GvXmlUtils,
  Dialogs, Controls, StrUtils;

procedure ParseLieferLine(aMessageId, LineNo: Integer; aLine: string;
  ndProduct, ndOrders: TGvXmlNode; aTransaction: TpFIBTransaction);
var
  OrderId, DealerId: variant;
  sl: TStringList;
  ndOrder, ndOrderItems, ndOrderItem: TGvXmlNode;
  NewStatusSign: variant;
  StateSign: Variant;
  StatusName, MessageClass: Variant;
  NewDeliveryMessage, Dimension: string;
begin
  sl:= TStringList.Create;
  try
    sl.Delimiter:= ';';
    sl.DelimitedText:= '"'+ReplaceAll(aLine, ';', '";"')+'"';

    OrderId:= dmOtto.DetectOrderId(ndProduct, sl[2], aTransaction);
    if OrderId<>null then
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
      if sl[4]<>'' then
        sl[4]:= IntToStr(StrToInt(sl[4]));

      Dimension:= dmOtto.Recode('ORDERITEM', 'DIMENSION', sl[6]);

      ndOrderItem:= ndOrderItems.Find('ORDERITEM', 'AUFTRAG_ID;ORDERITEM_INDEX;ARTICLE_CODE;DIMENSION',
        [sl[3], sl[4], sl[5], VarArrayOf([Dimension, sl[6]])]);
      if ndOrderItem = nil then
        ndOrderItem:= ndOrderItems.Find('ORDERITEM', 'ARTICLE_CODE;DIMENSION;ORDERITEM_INDEX;STATUS_SIGN',
          [sl[5], VarArrayOf([Dimension, sl[6]]), '', VarArrayOf(['ACCEPTREQUEST','ACCEPTED','BUNDLING'])]);
      if ndOrderItem <> nil then
      begin
        ndOrderItem['ORDERITEM_INDEX']:= sl[4];
        ndOrderItem['NEW.PRICE_EUR']:= StrToCurr(sl[9]);
        if ndOrderItem.Attr['NEW.PRICE_EUR'].AsMoney <> ndOrderItem.Attr['PRICE_EUR'].AsMoney then
        begin
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Измнена цена [PRICE_EUR] => [NEW.PRICE_EUR].',
            'W',
            XmlAttrs2Attr(ndOrderItem, 'AUFTRAG_ID;ORDERITEM_INDEX;ARTICLE_CODE;DIMENSION;PRICE_EUR;NEW.PRICE_EUR',
            XmlAttrs2Attr(ndOrder, 'ORDER_CODE',
            Value2Attr(LineNo, 'LINE_NO'))));
          ndOrderItem['PRICE_EUR']:= StrToCurr(sl[9]);
          ndOrderItem.Attr['COST_EUR'].AsMoney:= ndOrderItem.Attr['PRICE_EUR'].AsMoney*ndOrderItem['AMOUNT'];
        end;

        StateSign:= dmOtto.Recode('ORDERITEM', 'DELIVERY_CODE_TIME', sl[10]);
        if StateSign = sl[10] then
        begin
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Неизвестный DeliveryCode = [DELIVERY_CODE]',
            'E',
            XmlAttrs2Attr(ndOrderItem, 'AUFTRAG_ID;ORDERITEM_INDEX;ARTICLE_CODE;DIMENSION',
            XmlAttrs2Attr(ndOrder, 'ORDER_CODE',
            Value2Attr(LineNo, 'LINE_NO',
            Strings2Attr(sl, 'DELIVERY_CODE=10')))))
        end
        else
        if IsWordPresent(StateSign, 'ANULLED,REJECTED', ',') then
        begin
          ndOrderItem['NEW.STATUS_SIGN']:= StateSign;
          MessageClass:= 'W';
        end
        else
        begin
          ndOrderItem['NEW.STATE_SIGN']:= StateSign;
          if sl[12] <> '00000000000000' then
          begin
            ndOrderItem['NRRETCODE']:= sl[12];
            ndOrderItem['NEW.STATUS_SIGN']:= 'BUNDLING';
            MessageClass:= 'I';
          end
          else
            MessageClass:= 'W';
        end;

        NewDeliveryMessage:= dmOtto.Recode('ORDERITEM', 'DELIVERY_MESSAGE_RUS', sl[11]);
        try
          dmOtto.ActionExecute(aTransaction, ndOrderItem);
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. [STATUS_NAME] ([DELIVERY_MESSAGE_RUS])',
            MessageClass,
            XmlAttrs2Attr(ndOrderItem, 'AUFTRAG_ID;ORDERITEM_INDEX;ORDER_ID;ARTICLE_CODE;DIMENSION;STATUS_NAME',
            XmlAttrs2Attr(ndOrder, 'ORDER_CODE',
            Value2Attr(NewDeliveryMessage, 'DELIVERY_MESSAGE_RUS',
            Value2Attr(LineNo, 'LINE_NO')))));
        except
          on E: Exception do
            dmOtto.Notify(aMessageId,
              '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Ошибка ([ERROR_TEXT])',
              'E',
              XmlAttrs2Attr(ndOrderItem, 'AUFTRAG_ID;ORDERITEM_INDEX;ORDER_ID;ARTICLE_CODE;DIMENSION',
              XmlAttrs2Attr(ndOrder, 'ORDER_CODE',
              Value2Attr(LineNo, 'LINE_NO',
              Value2Attr(DeleteChars(e.Message, #10#13), 'ERROR_TEXT')))));
        end;
      end
      else
        dmOtto.Notify(aMessageId,
          '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Позиция не найдена в заявке [ORDER_CODE].',
          'E',
          Strings2Attr(sl, 'AUFTRAG_ID=3;ORDERITEM_INDEX=4;ARTICLE_CODE=5;DIMENSION=6',
          XmlAttrs2Attr(ndOrder, 'ORDER_CODE',
          Value2Attr(LineNo, 'LINE_NO'))));
    end
    else
    begin
      DealerId:= dmOtto.IsDealerOrder(ndProduct, sl[1], aTransaction);
      if DealerId <> null then
      begin
        dmOtto.Notify(aMessageId,
          '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Заявка дилера [DEALER_ID].',
          'I',
          Strings2Attr(sl, 'AUFTRAG_ID=3;ORDERITEM_INDEX=4;ARTICLE_CODE=5;DIMENSION=6',
          Value2Attr(LineNo, 'LINE_NO',
          Value2Attr(DealerId, 'DEALER_ID',
          Value2Attr(dmOtto.DetectOrderCode(ndProduct, sl[1]), 'ORDER_CODE')))));
        dmOtto.DealerNotify(aMessageId, DealerId, aLine, aTransaction);
      end
      else
        dmOtto.Notify(aMessageId,
          '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Неизвестная заявка [OTTO_ORDER_CODE].',
          'E',
          Strings2Attr(sl, 'ORDER_CODE=2;AUFTRAG_ID=3;ORDERITEM_INDEX=4;ARTICLE_CODE=5;DIMENSION=6;OTTO_ORDER_CODE=2',
          Value2Attr(LineNo, 'LINE_NO')));
    end;
  finally
    sl.Free;
  end;
end;

procedure ParseLiefer(aMessageId: Integer; ndMessage: TGvXmlNode; aTransaction: TpFIBTransaction);
var
  LineNo: Integer;
  Lines: TStringList;
  MessageFileName: variant;
  ndProduct, ndOrders, ndOrder, ndOrderItems: TGvXmlNode;
begin
  dmOtto.ClearNotify(aMessageId);
  aTransaction.StartTransaction;
  try
    dmOtto.ObjectGet(ndMessage, aMessageId, aTransaction);
    ndProduct:= ndMessage.FindOrCreate('PRODUCT');
    dmOtto.ObjectGet(ndProduct, dmOtto.DetectProductId(ndMessage, aTransaction), aTransaction);
    ndOrders:= ndMessage.FindOrCreate('ORDERS');

    MessageFileName:= ndMessage['FILE_NAME'];
    dmOtto.Notify(aMessageId,
      'Начало обработки файла: [FILE_NAME]', '',
      Value2Attr(MessageFileName, 'FILE_NAME'));
    Lines:= TStringList.Create;
    try
      if FileExists(Path['Messages.In']+MessageFileName) then
      begin
        Lines.LoadFromFile(Path['Messages.In']+MessageFileName);
        dmOtto.InitProgress(Lines.Count, Format('Обработка файла %s ...', [MessageFileName]));
        For LineNo:= 0 to Lines.Count - 1 do
        begin
          ParseLieferLine(aMessageId, LineNo, Lines[LineNo], ndProduct, ndOrders, aTransaction);
          dmOtto.StepProgress;
        end
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

procedure ProcessLiefer(aMessageId: Integer; aTransaction: TpFIBTransaction);
var
  aXml: TGvXml;
begin
  dmOtto.SilentMode:= True;
  aXml:= TGvXml.Create('MESSAGE');
  try
    ParseLiefer(aMessageId, aXml.Root, aTransaction);
  finally
    dmOtto.SilentMode:= false;
    aXml.Free;
  end;
end;


end.
