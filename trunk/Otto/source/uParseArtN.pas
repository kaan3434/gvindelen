unit uParseArtN;

interface

uses
  NativeXml, FIBDatabase, pFIBDatabase;

procedure ProcessArtN(aMessageId: Integer; aTransaction: TpFIBTransaction);

implementation

uses
  Classes, SysUtils, GvStr, udmOtto, Variants, GvNativeXml,
  Dialogs, Controls, GvFile, GvVariant;

procedure ParseArtNLine(aMessageId, LineNo: Integer; aLine: string; ndOrders: TXmlNode; aTransaction: TpFIBTransaction);
var
  OrderId: variant;
  sl: TStringList;
  ndOrder, ndOrderItem, ndOrderItems: TXmlNode;
  NewStatusSign: variant;
  StateSign, Dimension: Variant;
  StateId: Variant;
  StatusName, MessageClass: Variant;
  NewDeliveryMessage, OrderCode: string;
begin
  sl:= TStringList.Create;
  try
    sl.Delimiter:= ';';
    sl.DelimitedText:= '"'+ReplaceAll(aLine, ';', '";"')+'"';

    OrderCode:= FillFront(FilterString(Trim(sl[5]), '0123456789'), 5, '0');
    OrderId:= aTransaction.DefaultDatabase.QueryValue(
      'select order_id from orders where order_code like ''_''||:order_code',
      0, [OrderCode], aTransaction);
    if OrderId<>null then
    begin
      ndOrder:= ndOrders.NodeByAttributeValue('ORDER', 'ID', OrderId);

      if ndOrder = nil then
      begin
        ndOrder:= ndOrders.NodeNew('ORDER');
        dmOtto.ObjectGet(ndOrder, OrderId, aTransaction);
        dmOtto.OrderItemsGet(ndOrder.NodeNew('ORDERITEMS'), OrderId, aTransaction);
      end;
      ndOrderItems:= ndOrder.NodeFindOrCreate('ORDERITEMS');

      Dimension:= dmOtto.Recode('ARTICLE', 'DIMENSION', sl[11]);

      ndOrderItem:= ndOrderItems.NodeByAttributeValue('ORDERITEM', 'ORDERITEM_INDEX', sl[8]);
      if ndOrderItem = nil then
        ndOrderItem:= ChildByAttributes(ndOrder.NodeByName('ORDERITEMS'),
          'ARTICLE_CODE;DIMENSION;ORDERITEM_INDEX',
          [sl[9], VarArrayOf([Dimension, sl[11]]), '']);
      if ndOrderItem <> nil then
      try
        SetXmlAttr(ndOrderItem, 'ORDERITEM_INDEX', sl[8]);
        if GetXmlAttrValue(ndOrderItem, 'WEIGHT') = null then
        begin
          SetXmlAttr(ndOrderItem, 'WEIGHT', Trunc(ToNumber(sl[16])*1000));
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Заявка [ORDER_CODE]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Обновлен вес.',
            'I',
            XmlAttrs2Vars(ndOrder, 'ORDER_CODE;',
            XmlAttrs2Vars(ndOrderItem, 'ORDERITEM_INDEX;ARTICLE_CODE;DIMENSION',
            Value2Vars(LineNo, 'LINE_NO'))));
        end;

        if GetXmlAttrValue(ndOrder, 'AUFTRAG_ID') = null then
          SetXmlAttr(ndOrder, 'AUFTRAG_ID', sl[7]);

        dmOtto.ActionExecute(aTransaction, ndOrderItem);
        dmOtto.Notify(aMessageId,
          '[LINE_NO]. Заявка [ORDER_CODE]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Ok.',
          'I',
          XmlAttrs2Vars(ndOrder, 'ORDER_CODE;',
          XmlAttrs2Vars(ndOrderItem, 'ORDERITEM_INDEX;ARTICLE_CODE;DIMENSION',
          Value2Vars(LineNo, 'LINE_NO'))));
      except
        on E: Exception do
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Заявка [ORDER_CODE]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Ошибка ([ERROR_TEXT])',
            'E',
            XmlAttrs2Vars(ndOrderItem, 'ORDERITEM_ID=ID;ORDERITEM_INDEX;ORDER_ID;ARTICLE_CODE;DIMENSION',
            XmlAttrs2Vars(ndOrder, 'ORDER_CODE',
            Value2Vars(LineNo, 'LINE_NO',
            Value2Vars(E.Message, 'ERROR_TEXT')))));
      end
      else
        dmOtto.Notify(aMessageId,
          '[LINE_NO]. Заявка [ORDER_CODE]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Позиция не найдена в заявке.',
          'E',
          Strings2Vars(sl, 'ORDERITEM_INDEX=8;ARTICLE_CODE=9;DIMENSION=11',
          XmlAttrs2Vars(ndOrder, 'ORDER_CODE;CLIENT_ID;ORDER_ID=ID',
          Value2Vars(LineNo, 'LINE_NO'))));
    end
    else
      dmOtto.Notify(aMessageId,
        '[LINE_NO]. Заявка [ORDER_CODE]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Неизвестная заявка.',
        'E',
        Strings2Vars(sl, 'ORDER_CODE=6;ORDERITEM_INDEX=8;ARTICLE_CODE=9;DIMENSION=11',
        Value2Vars(LineNo, 'LINE_NO')));
  finally
    sl.Free;
  end;
end;

procedure ParseArtN(aMessageId: Integer; ndMessage: TXmlNode; aTransaction: TpFIBTransaction);
var
  LineNo: Integer;
  Lines: TStringList;
  MessageFileName: variant;
  ndOrder, ndOrderItems: TXmlNode;
  St: string;
begin
  dmOtto.ClearNotify(aMessageId);
  MessageFileName:= dmOtto.dbOtto.QueryValue(
    'select m.file_name from messages m where m.message_id = :message_id', 0,
    [aMessageId]);
  dmOtto.Notify(aMessageId,
    'Начало обработки файла: [FILE_NAME]', 'I',
    Value2Vars(MessageFileName, 'FILE_NAME'));
  // загружаем файл
  Lines:= TStringList.Create;
  try
    if FileExists(Path['Messages.In']+MessageFileName) then
    begin
      St:= LoadFileAsString(Path['Messages.In']+MessageFileName);
      St:= ReplaceAll(St, '     ', ' ');
      St:= ReplaceAll(St, '    ', ' ');
      St:= ReplaceAll(St, '   ', ' ');
      St:= ReplaceAll(St, '  ', ' ');
      St:= ReplaceAll(St, ' ;', ';');
      St:= ReplaceAll(St, '; ', ';');
      St:= ReplaceAll(St, #10' ', #10);
      Lines.Text:= ReplaceAll(St, #13#13#10, #13#10);
      dmOtto.InitProgress(Lines.Count, Format('Ообработка файла %s ...', [MessageFileName]));
      For LineNo:= 1 to Lines.Count - 1 do
      begin
        ParseArtNLine(aMessageId, LineNo, Lines[LineNo], ndMessage, aTransaction);
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
      'Конец обработки файла: [FILE_NAME]', 'I',
      Value2Vars(MessageFileName, 'FILE_NAME'));
    Lines.Free;
  end;
end;

procedure ProcessArtN(aMessageId: Integer; aTransaction: TpFIBTransaction);
var
  aXml: TNativeXml;
begin
  aXml:= TNativeXml.CreateName('MESSAGE');
  SetXmlAttr(aXml.Root, 'MESSAGE_ID', aMessageId);
  try
    if not aTransaction.Active then
      aTransaction.StartTransaction;
    try
      ParseArtN(aMessageId, aXml.Root, aTransaction);
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
