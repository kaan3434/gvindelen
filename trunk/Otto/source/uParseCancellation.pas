unit uParseCancellation;

interface

uses
  NativeXml, FIBDatabase, pFIBDatabase;

procedure ProcessCancellation(aMessageId: Integer; aTransaction: TpFIBTransaction);

implementation

uses
  Classes, SysUtils, GvStr, udmOtto, pFIBStoredProc, Variants, GvNativeXml,
  Dialogs, Controls, StrUtils;

procedure ParseCancelLine(aMessageId, LineNo: Integer; aLine: string; ndOrders: TXmlNode; aTransaction: TpFIBTransaction);
var
  Dimension: string;
  OrderId, OrderItemId: variant;
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

    OrderId:= aTransaction.DefaultDatabase.QueryValue(
      'select order_id from orders where order_code like ''_''||:order_code',
      0, [FilterString(sl[1], '0123456789')], aTransaction);
    if OrderId<>null then
    begin
      ndOrder:= ndOrders.NodeByAttributeValue('ORDER', 'ID', OrderId);
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

      Dimension:= dmOtto.Recode('ARTICLE', 'DIMENSION', sl[6]);

      ndOrderItem:= ChildByAttributes(ndOrderItems, 'ARTICLE_CODE;DIMENSION;ORDERITEM_INDEX',
        [sl[5], VarArrayOf([sl[6], Dimension]), sl[4]]);
      if ndOrderItem = nil then
        ndOrderItem:= ChildByAttributes(ndOrderItems, 'ARTICLE_CODE;DIMENSION;ORDERITEM_INDEX',
        [sl[5], VarArrayOf([sl[6], Dimension]), '']);
      if ndOrderItem <> nil then
      begin
        OrderItemId:= GetXmlAttr(ndOrderItem, 'ID');
        ndOrderItem.ValueAsBool:= true;
        SetXmlAttr(ndOrderItem, 'ORDERITEM_INDEX', sl[4]);
        if GetXmlAttrValue(ndOrderItem, 'DIMENSION') <> Dimension then
          SetXmlAttr(ndOrderItem, 'DIMENSION', Dimension);

        NewStatusSign:= dmOtto.Recode('ORDERITEM', 'CANCEL_MESSAGE', sl[11]);
        if NewStatusSign = sl[11] then
        begin
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Заявка [ORDER_CODE]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Неизвестный DeliveryCode = [CANCEL_CODE]',
            'E',
            XmlAttrs2Vars(ndOrderItem, 'ORDERITEM_INDEX;ARTICLE_CODE;DIMENSION',
            XmlAttrs2Vars(ndOrder, 'ORDER_CODE',
            Value2Vars(LineNo, 'LINE_NO',
            Strings2Vars(sl, 'CANCEL_MESSAGE=11')))))
        end;
        SetXmlAttr(ndOrderItem, 'NEW.STATUS_SIGN', NewStatusSign);

        StatusName:= aTransaction.DefaultDatabase.QueryValue(
          'select status_name from statuses where object_sign=''ORDERITEM'' and status_sign = :status_sign',
          0, [NewStatusSign]);
        try
          dmOtto.ActionExecute(aTransaction, ndOrderItem);
          dmOtto.ObjectGet(ndOrderItem, OrderItemId, aTransaction);
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Заявка [ORDER_CODE]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. [STATUS_NAME]',
            IfThen(NewStatusSign='ANULLED', 'W', 'I'),
            XmlAttrs2Vars(ndOrderItem, 'ORDERITEM_INDEX;ARTICLE_CODE;DIMENSION',
            XmlAttrs2Vars(ndOrder, 'ORDER_CODE',
            Value2Vars(LineNo, 'LINE_NO',
            Value2Vars(StatusName, 'STATUS_NAME')))));
        except
          on E: Exception do
            dmOtto.Notify(aMessageId,
              '[LINE_NO]. Заявка [ORDER_CODE]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Ошибка ([ERROR_TEXT])',
              'E',
              XmlAttrs2Vars(ndOrderItem, 'ORDERITEM_INDEX;ARTICLE_CODE;DIMENSION',
              XmlAttrs2Vars(ndOrder, 'ORDER_CODE',
              Value2Vars(LineNo, 'LINE_NO',
              Value2Vars(E.Message, 'ERROR_TEXT')))));
        end;
      end
      else
        dmOtto.Notify(aMessageId,
          '[LINE_NO]. Заявка [ORDER_CODE]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Позиция не найдена в заявке [ORDER_CODE].',
          'E',
          Strings2Vars(sl, 'ORDERITEM_INDEX=4;ARTICLE_CODE=5;DIMENSION=6',
          XmlAttrs2Vars(ndOrder, 'ORDER_CODE',
          Value2Vars(LineNo, 'LINE_NO'))));
    end
    else
      dmOtto.Notify(aMessageId,
        '[LINE_NO]. Заявка [ORDER_CODE]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Неизвестная заявка [ORDER_CODE].',
        'E',
        Strings2Vars(sl, 'ORDER_CODE=1;ORDERITEM_INDEX=4;ARTICLE_CODE=5;DIMENSION=6',
        Value2Vars(LineNo, 'LINE_NO')));
  finally
    sl.Free;
  end;
end;

procedure ParseCancellation(aMessageId: Integer; ndOrders: TXmlNode; aTransaction: TpFIBTransaction);
var
  LineNo: Integer;
  Lines: TStringList;
  MessageFileName: variant;
  ndOrder, ndOrderItems: TXmlNode;
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
      Lines.LoadFromFile(Path['Messages.In']+MessageFileName);
      For LineNo:= 0 to Lines.Count - 1 do
        ParseCancelLine(aMessageId, LineNo, Lines[LineNo], ndOrders, aTransaction);
    end
    else
      dmOtto.Notify(aMessageId,
        'Файл [FILE_NAME] не найден.', 'E',
        Value2Vars(MessageFileName, 'FILE_NAME'));
  finally
    Lines.Free;
  end;
  dmOtto.Notify(aMessageId,
    'Конец обработки файла: [FILE_NAME]', 'I',
    Value2Vars(MessageFileName, 'FILE_NAME'));
end;

procedure ProcessCancellation(aMessageId: Integer; aTransaction: TpFIBTransaction);
var
  aXml: TNativeXml;
begin
  aXml:= TNativeXml.CreateName('MESSAGE');
  SetXmlAttr(aXml.Root, 'MESSAGE_ID', aMessageId);
  try
    if not aTransaction.Active then
      aTransaction.StartTransaction;
    try
      ParseCancellation(aMessageId, aXml.Root, aTransaction);
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
