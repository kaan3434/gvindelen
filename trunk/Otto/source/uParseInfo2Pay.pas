unit uParseInfo2Pay;

interface

uses
  NativeXml, FIBDatabase, pFIBDatabase;

procedure ProcessInfo2Pay(aMessageId: Integer; aTransaction: TpFIBTransaction);

implementation

uses
  Classes, SysUtils, GvStr, udmOtto, Variants, GvNativeXml,
  Dialogs, Controls, GvFile, GvDtTm;

procedure ParseInfo2PayLine(aMessageId, LineNo: Integer; aLine: string;
  ndProduct, ndOrders: TXmlNode; aOnDate: TDateTime; aTransaction: TpFIBTransaction);
var
  OrderId, OrderItemId: variant;
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
      ndOrder:= ndOrders.NodeByAttributeValue('ORDER', 'ID', OrderId, false);
      if ndOrder = nil then
      begin
        ndOrder:= ndOrders.NodeNew('ORDER');
        ndOrderItems:= ndOrder.NodeNew('ORDERITEMS');
        dmOtto.ObjectGet(ndOrder, OrderId, aTransaction);
        SetXmlAttr(ndorder, 'INVOICE_DT_0', aOnDate);
        SetXmlAttr(ndOrder, 'BYR2EUR', dmOtto.SettingGet(aTransaction, 'BYR2EUR', aOnDate+1));
        SetXmlAttr(ndOrder, 'PACKLIST_NO', sl[1]);
        SetXmlAttr(ndOrder, 'NEW.STATE_SIGN', 'NULL');
        dmOtto.ActionExecute(aTransaction, ndOrder, 'PREPACKED');
        dmOtto.ObjectGet(ndOrder, OrderId, aTransaction);
        dmOtto.OrderItemsGet(ndOrderItems, OrderId, aTransaction);
      end
      else
        ndOrderItems:= ndOrder.NodeFindOrCreate('ORDERITEMS');

      Dimension:= dmOtto.Recode('ARTICLE', 'DIMENSION', sl[9]);

      ndOrderItem:= ChildByAttributes(ndOrderItems, 'AUFTRAG_ID;ORDERITEM_INDEX;ARTICLE_CODE;DIMENSION',
                    [sl[6], sl[7], sl[8], VarArrayOf([Dimension, sl[9]])]);
      if ndOrderItem = nil then
        ndOrderItem:= ChildByAttributes(ndOrderItems, 'ORDERITEM_INDEX;ARTICLE_CODE;DIMENSION;STATUS_SIGN',
                      [sl[7], sl[8], VarArrayOf([Dimension, sl[9]]), VarArrayOf(['ACCEPTED','BUNDLING','PREPACK','CANCELREQUEST'])]);
      if ndOrderItem <> nil then
      begin
        OrderItemId:= GetXmlAttrValue(ndOrderItem, 'ID');

        SetXmlAttrAsMoney(ndOrderItem, 'PRICE_EUR', sl[3]);
        if GetXmlAttrAsMoney(ndOrderItem, 'PRICE_EUR') <> GetXmlAttrAsMoney(ndOrderItem, 'COST_EUR') then
        begin
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Измнена цена [COST_EUR] => [PRICE_EUR].',
            'W',
            XmlAttrs2Vars(ndOrderItem, 'AUFTRAG_ID;ORDERITEM_INDEX;ARTICLE_CODE;DIMENSION;PRICE_EUR;COST_EUR',
            XmlAttrs2Vars(ndOrder, 'ORDER_CODE',
            Value2Vars(LineNo, 'LINE_NO'))));
          SetXmlAttrAsMoney(ndOrderItem, 'COST_EUR', GetXmlAttrValue(ndOrderItem, 'PRICE_EUR')*getXmlAttrValue(ndOrderItem, 'AMOUNT'));
        end;

        try
          ndOrderItem.ValueAsBool:= True;
          dmOtto.ActionExecute(aTransaction, ndOrderItem, 'PREPACKED');
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
              Value2Vars(DeleteChars(E.Message, #10#13), 'ERROR_TEXT')))));
        end;
      end
      else
        dmOtto.Notify(aMessageId,
          '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Позиция не найдена в заявке [ORDER_CODE].',
          'E',
          Strings2Vars(sl, 'AUFTRAG_ID=6;ORDERITEM_INDEX=7;ARTICLE_CODE=8',
          Value2Vars(Dimension, 'DIMENSION',
          XmlAttrs2Vars(ndOrder, 'ORDER_CODE',
          Value2Vars(LineNo, 'LINE_NO')))));
    end
    else
      dmOtto.Notify(aMessageId,
        '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Неизвестная заявка [ORDER_CODE].',
        'E',
        Strings2Vars(sl, 'ORDER_CODE=2;AUFTRAG_ID=6;ORDERITEM_INDEX=7;ARTICLE_CODE=8;DIMENSION=9',
        Value2Vars(LineNo, 'LINE_NO')));
  finally
    sl.Free;
  end;
end;

procedure ParseInfo2Pay(aMessageId: Integer; ndMessage: TXmlNode;
  aTransaction: TpFIBTransaction);
var
  LineNo, ErrorCount: Integer;
  NeedCommit: Boolean;
  Lines: TStringList;
  MessageFileName: String;
  ndProduct, ndOrders, ndOrder, ndOrderItems: TXmlNode;
  OnDate: TDateTime;
begin
  dmOtto.ClearNotify(aMessageId);
  aTransaction.StartTransaction;
  try
    dmOtto.ObjectGet(ndMessage, aMessageId, aTransaction);
    ndProduct:= ndMessage.NodeFindOrCreate('PRODUCT');
    dmOtto.ObjectGet(ndProduct, dmOtto.DetectProductId(ndMessage, aTransaction), aTransaction);
    ndOrders:= ndMessage.NodeFindOrCreate('ORDERS');

    MessageFileName:= GetXmlAttrValue(ndMessage, 'FILE_NAME');
    OnDate:= DateOfYear(GetXmlAttrValue(ndMessage, 'DAYNO'));
    dmOtto.Notify(aMessageId,
      'Начало обработки файла: [FILE_NAME]', '',
      Value2Vars(MessageFileName, 'FILE_NAME'));

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
  end;
end;

procedure ProcessInfo2Pay(aMessageId: Integer; aTransaction: TpFIBTransaction);
var
  aXml: TNativeXml;
begin
  aXml:= TNativeXml.CreateName('MESSAGE');
  try
    ParseInfo2Pay(aMessageId, aXml.Root, aTransaction);
  finally
    aXml.Free;
  end;
end;


end.
