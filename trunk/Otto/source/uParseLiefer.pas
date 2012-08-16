unit uParseLiefer;

interface

uses
  NativeXml, FIBDatabase, pFIBDatabase;

procedure ProcessLiefer(aMessageId: Integer; aTransaction: TpFIBTransaction);

implementation

uses
  Classes, SysUtils, GvStr, udmOtto, pFIBStoredProc, Variants, GvNativeXml,
  Dialogs, Controls, StrUtils;

procedure ParseLieferLine(aMessageId, LineNo: Integer; aLine: string;
  ndProduct, ndOrders: TXmlNode; aTransaction: TpFIBTransaction);
var
  OrderId: variant;
  sl: TStringList;
  ndOrder, ndOrderItems, ndOrderItem: TXmlNode;
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

      ndOrderItem:= ChildByAttributes(ndOrderItems, 'AUFTRAG_ID;ORDERITEM_INDEX;ARTICLE_CODE;DIMENSION',
        [sl[3], sl[4], sl[5], VarArrayOf([Dimension, sl[6]])]);
      if ndOrderItem = nil then
        ndOrderItem:= ChildByAttributes(ndOrderItems, 'ARTICLE_CODE;DIMENSION;ORDERITEM_INDEX;STATUS_SIGN',
          [sl[5], VarArrayOf([Dimension, sl[6]]), '', VarArrayOf(['ACCEPTREQUEST','ACCEPTED','BUNDLING'])]);
      if ndOrderItem <> nil then
      begin
        ndOrderItem.ValueAsBool:= true;
        SetXmlAttr(ndOrderItem, 'ORDERITEM_INDEX', sl[4]);
        if GetXmlAttrValue(ndOrderItem, 'AUFTRAG_ID') <> sl[3] then
        begin
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Изменение Auftrag [AUFTRAG_ID] => [NEW.AUFTRAG_ID].',
            'W',
            XmlAttrs2Vars(ndOrderItem, 'AUFTRAG_ID;ORDERITEM_INDEX;ARTICLE_CODE;DIMENSION;PRICE_EUR;NEW.PRICE_EUR',
            XmlAttrs2Vars(ndOrder, 'ORDER_CODE',
            Value2Vars(LineNo, 'LINE_NO',
            Value2Vars(sl[3], 'NEW.AUFTAG_ID')))));
          MergeXmlAttr(ndOrderItem, 'AUFTRAG_ID', sl[3]);
        end;

        SetXmlAttrAsMoney(ndOrderItem, 'NEW.PRICE_EUR', sl[9]);
        if GetXmlAttrAsMoney(ndOrderItem, 'NEW.PRICE_EUR') <> GetXmlAttrAsMoney(ndOrderItem, 'PRICE_EUR') then
        begin
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Измнена цена [PRICE_EUR] => [NEW.PRICE_EUR].',
            'W',
            XmlAttrs2Vars(ndOrderItem, 'AUFTRAG_ID;ORDERITEM_INDEX;ARTICLE_CODE;DIMENSION;PRICE_EUR;NEW.PRICE_EUR',
            XmlAttrs2Vars(ndOrder, 'ORDER_CODE',
            Value2Vars(LineNo, 'LINE_NO'))));
          SetXmlAttrAsMoney(ndOrderItem, 'PRICE_EUR', sl[9]);
          SetXmlAttrAsMoney(ndOrderItem, 'COST_EUR', GetXmlAttrValue(ndOrderItem, 'PRICE_EUR')*getXmlAttrValue(ndOrderItem, 'AMOUNT'));
        end;

        StateSign:= dmOtto.Recode('ORDERITEM', 'DELIVERY_CODE_TIME', sl[10]);
        if StateSign = sl[10] then
        begin
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Неизвестный DeliveryCode = [DELIVERY_CODE]',
            'E',
            XmlAttrs2Vars(ndOrderItem, 'AUFTRAG_ID;ORDERITEM_INDEX;ARTICLE_CODE;DIMENSION',
            XmlAttrs2Vars(ndOrder, 'ORDER_CODE',
            Value2Vars(LineNo, 'LINE_NO',
            Strings2Vars(sl, 'DELIVERY_CODE=10')))))
        end
        else
        if IsWordPresent(StateSign, 'ANULLED,REJECTED', ',') then
        begin
          SetXmlAttr(ndOrderItem, 'NEW.STATUS_SIGN', StateSign);
          MessageClass:= 'W';
        end
        else
        begin
          SetXmlAttr(ndOrderItem, 'NEW.STATE_SIGN', StateSign);
          if sl[12] <> '00000000000000' then
          begin
            SetXmlAttr(ndOrderItem, 'NRRETCODE', sl[12]);
            SetXmlAttr(ndOrderItem, 'NEW.STATUS_SIGN', 'BUNDLING');
            MessageClass:= 'I';
          end
          else
            MessageClass:= 'W';
        end;

        NewDeliveryMessage:= dmOtto.Recode('ORDERITEM', 'DELIVERY_MESSAGE_RUS', sl[11]);
        try
          ndOrderItem.ValueAsBool:= True;
          dmOtto.ActionExecute(aTransaction, ndOrderItem);
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. [STATUS_NAME] ([DELIVERY_MESSAGE_RUS])',
            MessageClass,
            XmlAttrs2Vars(ndOrderItem, 'AUFTRAG_ID;ORDERITEM_INDEX;ORDER_ID;ARTICLE_CODE;DIMENSION;STATUS_NAME',
            XmlAttrs2Vars(ndOrder, 'ORDER_CODE',
            Value2Vars(NewDeliveryMessage, 'DELIVERY_MESSAGE_RUS',
            Value2Vars(LineNo, 'LINE_NO')))));
        except
          on E: Exception do
            dmOtto.Notify(aMessageId,
              '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Ошибка ([ERROR_TEXT])',
              'E',
              XmlAttrs2Vars(ndOrderItem, 'AUFTRAG_ID;ORDERITEM_INDEX;ORDER_ID;ARTICLE_CODE;DIMENSION',
              XmlAttrs2Vars(ndOrder, 'ORDER_CODE',
              Value2Vars(LineNo, 'LINE_NO',
              Value2Vars(DeleteChars(e.Message, #10#13), 'ERROR_TEXT')))));
        end;
      end
      else
        dmOtto.Notify(aMessageId,
          '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Позиция не найдена в заявке [ORDER_CODE].',
          'E',
          Strings2Vars(sl, 'AUFTRAG_ID=3;ORDERITEM_INDEX=4;ARTICLE_CODE=5;DIMENSION=6',
          XmlAttrs2Vars(ndOrder, 'ORDER_CODE',
          Value2Vars(LineNo, 'LINE_NO'))));
    end
    else
      dmOtto.Notify(aMessageId,
        '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Неизвестная заявка [OTTO_ORDER_CODE].',
        'E',
        Strings2Vars(sl, 'CLIENT_ID=1;ORDER_CODE=2;AUFTRAG_ID=3;ORDERITEM_INDEX=4;ARTICLE_CODE=5;DIMENSION=6;OTTO_ORDER_CODE=2',
        Value2Vars(LineNo, 'LINE_NO')));
  finally
    sl.Free;
  end;
end;

procedure ParseLiefer(aMessageId: Integer; ndMessage: TXmlNode; aTransaction: TpFIBTransaction);
var
  LineNo: Integer;
  Lines: TStringList;
  MessageFileName: variant;
  ndProduct, ndOrders, ndOrder, ndOrderItems: TXmlNode;
begin
  dmOtto.ClearNotify(aMessageId);
  aTransaction.StartTransaction;
  try
    dmOtto.ObjectGet(ndMessage, aMessageId, aTransaction);
    ndProduct:= ndMessage.NodeFindOrCreate('PRODUCT');
    dmOtto.ObjectGet(ndProduct, dmOtto.DetectProductId(ndMessage, aTransaction), aTransaction);
    ndOrders:= ndMessage.NodeFindOrCreate('ORDERS');

    MessageFileName:= GetXmlAttrValue(ndMessage, 'FILE_NAME');
    dmOtto.Notify(aMessageId,
      'Начало обработки файла: [FILE_NAME]', '',
      Value2Vars(MessageFileName, 'FILE_NAME'));
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

procedure ProcessLiefer(aMessageId: Integer; aTransaction: TpFIBTransaction);
var
  aXml: TNativeXml;
begin
  aXml:= TNativeXml.CreateName('MESSAGE');
  try
    ParseLiefer(aMessageId, aXml.Root, aTransaction);
  finally
    aXml.Free;
  end;
end;


end.
