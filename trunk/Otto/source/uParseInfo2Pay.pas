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
  ndOrders: TXmlNode; aOnDate: TDateTime; aTransaction: TpFIBTransaction);
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

    OrderId:= aTransaction.DefaultDatabase.QueryValue(
      'select order_id from orders where order_code like ''_''||:order_code',
      0, [FilterString(sl[2], '0123456789')], aTransaction);
    if OrderId<>null then
    begin
      ndOrder:= ndOrders.NodeNew('ORDER');
      ndOrderItems:= ndOrder.NodeFindOrCreate('ORDERITEMS');
      dmOtto.ObjectGet(ndOrder, OrderId, aTransaction);
      SetXmlAttr(ndOrder, 'BYR2EUR', dmOtto.SettingGet(aTransaction, 'BYR2EUR', aOnDate));
      SetXmlAttr(ndOrder, 'PACKLIST_NO', sl[1]);
      // если ауфтрак еще не присвоен, сохраняем его на заявке
      if GetXmlAttrValue(ndOrder, 'AUFTRAG_ID') <> sl[6] then
        SetXmlAttr(ndOrder, 'AUFTRAG_ID', sl[6]);
      dmOtto.ActionExecute(aTransaction, ndOrder, 'PREPACKED');
      dmOtto.ObjectGet(ndOrder, OrderId, aTransaction);

      Dimension:= dmOtto.Recode('ARTICLE', 'DIMENSION', sl[9]);

      dmOtto.OrderItemsGet(ndOrderItems, OrderId, aTransaction);
      ndOrderItem:= ChildByAttributes(ndOrder.NodeByName('ORDERITEMS'),
        'ARTICLE_CODE;DIMENSION;ORDERITEM_INDEX',
        [sl[8], VarArrayOf([Dimension, sl[9]]), sl[7]]);
      if ndOrderItem = nil then
        ndOrderItem:= ChildByAttributes(ndOrder.NodeByName('ORDERITEMS'),
          'ARTICLE_CODE;DIMENSION;ORDERITEM_INDEX;STATUS_SIGN',
          [sl[8], VarArrayOf([Dimension, sl[9]]), '', VarArrayOf(['ACCEPTREQUEST','ACCEPTED','BUNDLING'])]);
      if ndOrderItem <> nil then
      begin
        OrderItemId:= GetXmlAttrValue(ndOrderItem, 'ID');
        if GetXmlAttrValue(ndOrderItem, 'ORDERITEM_INDEX') = null then
          SetXmlAttr(ndOrderItem, 'ORDERITEM_INDEX', sl[7]);

        SetXmlAttrAsMoney(ndOrderItem, 'PRICE_EUR', sl[3]);

        if GetXmlAttrAsMoney(ndOrderItem, 'PRICE_EUR') <> GetXmlAttrAsMoney(ndOrderItem, 'COST_EUR') then
        begin
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Заявка [ORDER_CODE]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Измнена цена [COST_EUR] => [PRICE_EUR].',
            'W',
            XmlAttrs2Vars(ndOrderItem, 'ORDERITEM_ID=ID;ORDERITEM_INDEX;ORDER_ID;ARTICLE_CODE;DIMENSION;PRICE_EUR;COST_EUR',
            XmlAttrs2Vars(ndOrder, 'ORDER_CODE',
            Value2Vars(LineNo, 'LINE_NO'))));
          SetXmlAttrAsMoney(ndOrderItem, 'COST_EUR', GetXmlAttrValue(ndOrderItem, 'PRICE_EUR')*getXmlAttrValue(ndOrderItem, 'AMOUNT'));
        end;

        SetXmlAttr(ndOrderItem, 'NEW.STATUS_SIGN', 'PREPACKED');

        try
          ndOrderItem.ValueAsBool:= True;
          dmOtto.ActionExecute(aTransaction, ndOrderItem);
          dmOtto.ObjectGet(ndOrderItem, OrderItemId, aTransaction);
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Заявка [ORDER_CODE]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. [STATUS_NAME]',
            'I',
            XmlAttrs2Vars(ndOrderItem, 'ORDERITEM_ID=ID;ORDERITEM_INDEX;ORDER_ID;ARTICLE_CODE;DIMENSION;STATUS_NAME',
            XmlAttrs2Vars(ndOrder, 'ORDER_CODE;CLIENT_ID',
            Value2Vars(LineNo, 'LINE_NO'))));
        except
          on E: Exception do
            dmOtto.Notify(aMessageId,
              '[LINE_NO]. Заявка [ORDER_CODE]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Ошибка ([ERROR_TEXT])',
              'E',
              XmlAttrs2Vars(ndOrderItem, 'ORDERITEM_ID=ID;ORDERITEM_INDEX;ORDER_ID;ARTICLE_CODE;DIMENSION',
              XmlAttrs2Vars(ndOrder, 'ORDER_CODE;CLIENT_ID',
              Value2Vars(LineNo, 'LINE_NO',
              Value2Vars(E.Message, 'ERROR_TEXT')))));
        end;
      end
      else
        dmOtto.Notify(aMessageId,
          '[LINE_NO]. Заявка [ORDER_CODE]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Позиция не найдена в заявке [ORDER_CODE].',
          'E',
          Strings2Vars(sl, 'ORDERITEM_INDEX=7;ARTICLE_CODE=8;DIMENSION=9',
          XmlAttrs2Vars(ndOrder, 'ORDER_CODE;CLIENT_ID;ORDER_ID=ID',
          Value2Vars(LineNo, 'LINE_NO'))));
    end
    else
      dmOtto.Notify(aMessageId,
        '[LINE_NO]. Заявка [ORDER_CODE]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Неизвестная заявка [ORDER_CODE].',
        'E',
        Strings2Vars(sl, 'ORDER_CODE=2;ORDERITEM_INDEX=7;ARTICLE_CODE=8;DIMENSION=9',
        Value2Vars(LineNo, 'LINE_NO')));
  finally
    sl.Free;
  end;
end;

procedure ParseInfo2Pay(aMessageId: Integer; ndOrders: TXmlNode;
  aTransaction: TpFIBTransaction);
var
  LineNo: Integer;
  Lines: TStringList;
  MessageFileName: variant;
  ndOrder, ndOrderItems: TXmlNode;
  DayNo: Variant;
begin
  dmOtto.ClearNotify(aMessageId);
  MessageFileName:= dmOtto.dbOtto.QueryValue(
    'select m.file_name from messages m where m.message_id = :message_id', 0,
    [aMessageId]);
  DayNo:= CopyBack4(ExtractFileNameOnly(MessageFileName), '_');
  dmOtto.Notify(aMessageId,
    'Начало обработки файла: [FILE_NAME]', '',
    Value2Vars(MessageFileName, 'FILE_NAME'));
  // загружаем файл
  if not aTransaction.Active then
    aTransaction.StartTransaction;
  try
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
            ParseInfo2PayLine(aMessageId, LineNo, Lines[LineNo], ndOrders, DateOfYear(DayNo), aTransaction);
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
    dmOtto.MessageRelease(aTransaction, aMessageId);
    dmOtto.MessageSuccess(aTransaction, aMessageId);
    aTransaction.Commit;
  except
    aTransaction.Rollback;
  end;
end;

procedure ProcessInfo2Pay(aMessageId: Integer; aTransaction: TpFIBTransaction);
var
  aXml: TNativeXml;
begin
  aXml:= TNativeXml.CreateName('MESSAGE');
  SetXmlAttr(aXml.Root, 'MESSAGE_ID', aMessageId);
  try
    ParseInfo2Pay(aMessageId, aXml.Root, aTransaction);
    dmOtto.ShowProtocol(aTransaction, aMessageId);
  finally
    aXml.Free;
  end;
end;


end.
