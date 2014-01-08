unit uParseInfo2Pay;

interface

uses
  GvXml, FIBDatabase, pFIBDatabase;

procedure ProcessInfo2Pay(aMessageId: Integer; aTransaction: TpFIBTransaction);

implementation

uses
  Classes, SysUtils, GvStr, udmOtto, Variants, GvXmlUtils,
  Dialogs, Controls, GvFile, GvDtTm;

procedure ParseInfo2PayLine(aMessageId, LineNo: Integer; aLine: string;
  ndProduct, ndOrders: TGvXmlNode; aOnDate: TDateTime; aTransaction: TpFIBTransaction);
var
  OrderId, OrderItemId, DealerId: variant;
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
        ndorder['INVOICE_DT_0']:= aOnDate;
        ndOrder['BYR2EUR']:= StrToCurr(dmOtto.SettingGet(aTransaction, 'BYR2EUR', aOnDate+1));
        ndOrder['PACKLIST_NO']:= sl[1];
        ndOrder['NEW.STATE_SIGN']:= null;
        dmOtto.ActionExecute(aTransaction, ndOrder, 'PREPACKED');
        dmOtto.ObjectGet(ndOrder, OrderId, aTransaction);
        dmOtto.OrderItemsGet(ndOrderItems, OrderId, aTransaction);
      end
      else
        ndOrderItems:= ndOrder.FindOrCreate('ORDERITEMS');

      Dimension:= dmOtto.Recode('ORDERITEM', 'DIMENSION', sl[9]);

      ndOrderItem:= ndOrderItems.Find('ORDERITEM', 'AUFTRAG_ID;ORDERITEM_INDEX;ARTICLE_CODE;DIMENSION',
                    [sl[6], sl[7], sl[8], VarArrayOf([Dimension, sl[9]])]);
      if ndOrderItem = nil then
        ndOrderItem:= ndOrderItems.Find('ORDERITEM', 'ORDERITEM_INDEX;ARTICLE_CODE;DIMENSION;STATUS_SIGN',
                      [sl[7], sl[8], VarArrayOf([Dimension, sl[9]]), VarArrayOf(['ACCEPTED','BUNDLING','PREPACK','CANCELREQUEST'])]);
      if ndOrderItem <> nil then
      begin
        OrderItemId:= ndOrderItem['ID'];

        ndOrderItem['PRICE_EUR']:= StrToCurr(sl[3]);
        if ndOrderItem['PRICE_EUR'] <> ndOrderItem['COST_EUR'] then
        begin
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Измнена цена [COST_EUR] => [PRICE_EUR].',
            'W',
            XmlAttrs2Attr(ndOrderItem, 'AUFTRAG_ID;ORDERITEM_INDEX;ARTICLE_CODE;DIMENSION;PRICE_EUR;COST_EUR',
            XmlAttrs2Attr(ndOrder, 'ORDER_CODE',
            Value2Attr(LineNo, 'LINE_NO'))));
          ndOrderItem.Attr['COST_EUR'].AsMoney:=  ndOrderItem.Attr['PRICE_EUR'].AsMoney*ndOrderItem['AMOUNT'];
        end;

        try
          dmOtto.ActionExecute(aTransaction, ndOrderItem, 'PREPACKED');
          dmOtto.ObjectGet(ndOrderItem, OrderItemId, aTransaction);
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. [STATUS_NAME]',
            'I',
            XmlAttrs2Attr(ndOrderItem, 'AUFTRAG_ID;ORDERITEM_INDEX;ARTICLE_CODE;DIMENSION;STATUS_NAME',
            XmlAttrs2Attr(ndOrder, 'ORDER_CODE',
            Value2Attr(LineNo, 'LINE_NO'))));
        except
          on E: Exception do
            dmOtto.Notify(aMessageId,
              '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Ошибка ([ERROR_TEXT])',
              'E',
              XmlAttrs2Attr(ndOrderItem, 'AUFTRAG_ID;ORDERITEM_INDEX;ARTICLE_CODE;DIMENSION',
              XmlAttrs2Attr(ndOrder, 'ORDER_CODE',
              Value2Attr(LineNo, 'LINE_NO',
              Value2Attr(DeleteChars(E.Message, #10#13), 'ERROR_TEXT')))));
        end;
      end
      else
        dmOtto.Notify(aMessageId,
          '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Позиция не найдена в заявке [ORDER_CODE].',
          'E',
          Strings2Attr(sl, 'AUFTRAG_ID=6;ORDERITEM_INDEX=7;ARTICLE_CODE=8',
          Value2Attr(Dimension, 'DIMENSION',
          XmlAttrs2Attr(ndOrder, 'ORDER_CODE',
          Value2Attr(LineNo, 'LINE_NO')))));
    end
    else
    begin
      DealerId:= dmOtto.IsDealerOrder(ndProduct, sl[2], aTransaction);
      if DealerId <> null then
      begin
        dmOtto.Notify(aMessageId,
          '[LINE_NO]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Заявка дилера [DEALER_ID]',
          'I',
          Strings2Attr(sl, 'AUFTRAG_ID=6;ORDERITEM_INDEX=7;ARTICLE_CODE=8;DIMENSION=9',
          Value2Attr(LineNo, 'LINE_NO',
          Value2Attr(DealerId, 'DEALER_ID',
          Value2Attr(dmOtto.DetectOrderCode(ndProduct, sl[2]), 'ORDER_CODE')))));
        dmOtto.DealerNotify(aMessageId, DealerId, aLine, aTransaction);
      end
      else
        dmOtto.Notify(aMessageId,
          '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Неизвестная заявка [ORDER_CODE].',
          'E',
          Strings2Attr(sl, 'ORDER_CODE=2;AUFTRAG_ID=6;ORDERITEM_INDEX=7;ARTICLE_CODE=8;DIMENSION=9',
          Value2Attr(LineNo, 'LINE_NO')));
      end;
  finally
    sl.Free;
  end;
end;

procedure ParseInfo2Pay(aMessageId: Integer; ndMessage: TGvXmlNode;
  aTransaction: TpFIBTransaction);
var
  LineNo, ErrorCount: Integer;
  NeedCommit: Boolean;
  Lines: TStringList;
  MessageFileName: String;
  ndProduct, ndOrders, ndOrder, ndOrderItems: TGvXmlNode;
  OnDate: TDateTime;
begin
  dmOtto.ClearNotify(aMessageId);
  aTransaction.StartTransaction;
  try
    dmOtto.ObjectGet(ndMessage, aMessageId, aTransaction);
    ndProduct:= ndMessage.FindOrCreate('PRODUCT');
    dmOtto.ObjectGet(ndProduct, dmOtto.DetectProductId(ndMessage, aTransaction), aTransaction);
    ndOrders:= ndMessage.FindOrCreate('ORDERS');

    MessageFileName:= ndMessage['FILE_NAME'];
    OnDate:= DateOfYear(ndMessage['DAYNO']);
    dmOtto.Notify(aMessageId,
      'Начало обработки файла: [FILE_NAME]', '',
      Value2Attr(MessageFileName, 'FILE_NAME'));

    Lines:= TStringList.Create;
    try
      if FileExists(Path['Messages.In']+MessageFileName) then
      begin
        Lines.LoadFromFile(Path['Messages.In']+MessageFileName);
        Lines.Text:= ReplaceAll(Lines.Text, #13#13#10, #13#10);
        dmOtto.InitProgress(Lines.Count, Format('Обработка файла %s ...', [MessageFileName]));
        For LineNo:= 0 to Lines.Count - 1 do
        begin
          if Lines[LineNo] <> '' then
            ParseInfo2PayLine(aMessageId, LineNo, Lines[LineNo], ndProduct, ndOrders, OnDate, aTransaction);
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
  end;
end;

procedure ProcessInfo2Pay(aMessageId: Integer; aTransaction: TpFIBTransaction);
var
  aXml: TGvXml;
begin
  dmOtto.SilentMode:= true;
  aXml:= TGvXml.Create('MESSAGE');
  try
    ParseInfo2Pay(aMessageId, aXml.Root, aTransaction);
  finally
    aXml.Free;
    dmOtto.SilentMode:= false;
  end;

end;


end.
