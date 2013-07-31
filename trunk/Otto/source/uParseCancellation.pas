unit uParseCancellation;

interface

uses
  NativeXml, FIBDatabase, pFIBDatabase;

procedure ProcessCancellation(aMessageId: Integer; aTransaction: TpFIBTransaction);

implementation

uses
  Classes, SysUtils, GvStr, udmOtto, Variants, GvNativeXml,
  Dialogs, Controls, StrUtils;

procedure ParseCancelLine(aMessageId, LineNo: Integer; aLine: string;
  ndProduct, ndOrders: TXmlNode; aTransaction: TpFIBTransaction);
var
  Dimension: string;
  OrderId, OrderItemId, DealerId: variant;
  sl: TStringList;
  ndOrder, ndOrderItems, ndOrderItem: TXmlNode;
  NewStatusSign: variant;
  StateId: Variant;
  StatusName, MessageClass: Variant;
  NewDeliveryMessage: string;
begin
  sl:= TStringList.Create;
  try
    sl.Delimiter:= ';';
    sl.DelimitedText:= '"'+ReplaceAll(aLine, ';', '";"')+'"';

    OrderId:= dmOtto.DetectOrderId(ndProduct, sl[1], aTransaction);
    if OrderId<>null then
    begin
      ndOrder:= ndOrders.NodeByAttributeValue('ORDER', 'ID', OrderId, true);
      if ndOrder = nil then
      begin
        ndOrder:= ndOrders.NodeNew('ORDER');
        ndOrderItems:= ndOrder.NodeNew('ORDERITEMS');
        dmOtto.ObjectGet(ndOrder, OrderId, aTransaction);
        dmOtto.OrderItemsGet(ndOrderItems, OrderId, aTransaction);
      end
      else
        ndOrderItems:= ndOrder.NodeByName('ORDERITEMS');

      sl[6]:= SkipLeadingZero(sl[6]);
      sl[4]:= SkipLeadingZero(sl[4]);

      Dimension:= dmOtto.Recode('ORDERITEM', 'DIMENSION', sl[6]);

      ndOrderItem:= ChildByAttributes(ndOrderItems, 'AUFTRAG_ID;ORDERITEM_INDEX;ARTICLE_CODE;DIMENSION',
        [sl[3], sl[4], sl[5], VarArrayOf([Dimension, sl[6]])]);
      if ndOrderItem <> nil then
      begin
        OrderItemId:= GetXmlAttr(ndOrderItem, 'ID');
        ndOrderItem.ValueAsBool:= true;

        NewStatusSign:= dmOtto.Recode('ORDERITEM', 'CANCEL_MESSAGE', sl[11]);
        if NewStatusSign = sl[11] then
        begin
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Неизвестный DeliveryCode = [CANCEL_MESSAGE]',
            'E',
            XmlAttrs2Vars(ndOrderItem, 'AUFTRAG_ID;ORDERITEM_INDEX;ARTICLE_CODE;DIMENSION',
            XmlAttrs2Vars(ndOrder, 'ORDER_CODE',
            Value2Vars(LineNo, 'LINE_NO',
            Strings2Vars(sl, 'CANCEL_MESSAGE=11')))));
        end;
        SetXmlAttr(ndOrderItem, 'NEW.STATUS_SIGN', NewStatusSign);

        if IsWordPresent('CREDIT', GetXmlAttrValue(ndOrderItem, 'STATUS_FLAG_LIST'), ',') then
        try
          dmOtto.ActionExecute(aTransaction, ndOrderItem);
          dmOtto.ObjectGet(ndOrderItem, OrderItemId, aTransaction);
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. [STATUS_NAME]',
            'I',
            XmlAttrs2Vars(ndOrderItem, 'AUFTRAG_ID;ORDERITEM_INDEX;ARTICLE_CODE;DIMENSION;STATUS_NAME',
            XmlAttrs2Vars(ndOrder, 'ORDER_CODE',
            Value2Vars(LineNo, 'LINE_NO'))));
        except
          on E: Exception do
            dmOtto.Notify(aMessageId,
              '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Ошибка ([ERROR_TEXT])',
              'E',
              XmlAttrs2Vars(ndOrderItem, 'AUFTRAG_ID;ORDERITEM_INDEX;ARTICLE_CODE;DIMENSION',
              XmlAttrs2Vars(ndOrder, 'ORDER_CODE',
              Value2Vars(LineNo, 'LINE_NO',
              Value2Vars(E.Message, 'ERROR_TEXT')))));
        end
        else
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Уже в статусе [STATUS_NAME]',
            IfThen(NewStatusSign='ANULLED', 'W', 'I'),
            XmlAttrs2Vars(ndOrderItem, 'AUFTRAG_ID;ORDERITEM_INDEX;ARTICLE_CODE;DIMENSION;STATUS_NAME',
            XmlAttrs2Vars(ndOrder, 'ORDER_CODE',
            Value2Vars(LineNo, 'LINE_NO'))));
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
    begin
      DealerId:= dmOtto.IsDealerOrder(ndProduct, sl[1], aTransaction);
      if DealerId <> null then
      begin
        dmOtto.Notify(aMessageId,
          '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Заявка дилера [DEALER_ID].',
          'I',
          Strings2Vars(sl, 'AUFTRAG_ID=3;ORDERITEM_INDEX=4;ARTICLE_CODE=5;DIMENSION=6',
          Value2Vars(LineNo, 'LINE_NO',
          Value2Vars(DealerId, 'DEALER_ID',
          Value2Vars(dmOtto.DetectOrderCode(ndProduct, sl[1]), 'ORDER_CODE')))));
        dmOtto.DealerNotify(aMessageId, DealerId, aLine, aTransaction);
      end
      else
        dmOtto.Notify(aMessageId,
          '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Неизвестная заявка [ORDER_CODE].',
          'E',
          Strings2Vars(sl, 'ORDER_CODE=1;AUFTRAG_ID=3;ORDERITEM_INDEX=4;ARTICLE_CODE=5;DIMENSION=6',
          Value2Vars(LineNo, 'LINE_NO')));
    end;
  finally
    sl.Free;
  end;
end;

procedure ParseCancellation(aMessageId: Integer; ndMessage: TXmlNode; aTransaction: TpFIBTransaction);
var
  LineNo: Integer;
  Lines: TStringList;
  MessageFileName: variant;
  ndProduct, ndOrders: TXmlNode;
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
          ParseCancelLine(aMessageId, LineNo+1, Lines[LineNo], ndProduct, ndOrders, aTransaction);
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
    dmOtto.ShowProtocol
    (aTransaction, aMessageId);
    dmOtto.MessageCommit(aTransaction, aMessageId);
  except
    aTransaction.Rollback;
  end;
end;

procedure ProcessCancellation(aMessageId: Integer; aTransaction: TpFIBTransaction);
var
  aXml: TNativeXml;
begin
  dmOtto.SilentMode:= true;
  aXml:= TNativeXml.CreateName('MESSAGE');
  try
    ParseCancellation(aMessageId, aXml.Root, aTransaction);
  finally
    dmOtto.SilentMode:= false;
    aXml.Free;
  end;
end;


end.
