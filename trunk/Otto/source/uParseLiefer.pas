unit uParseLiefer;

interface

uses
  NativeXml, FIBDatabase, pFIBDatabase;

procedure ProcessLiefer(aMessageId: Integer; aTransaction: TpFIBTransaction);

implementation

uses
  Classes, SysUtils, GvStr, udmOtto, pFIBStoredProc, Variants, GvNativeXml,
  Dialogs, Controls, StrUtils;

procedure ParseLieferLine(aMessageId, LineNo: Integer; aLine: string; ndOrders: TXmlNode; aTransaction: TpFIBTransaction);
var
  OrderId: variant;
  sl: TStringList;
  ndOrder, ndOrderItem: TXmlNode;
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
      dmOtto.ObjectGet(ndOrder, OrderId, aTransaction);
      // если ауфтрак еще не присвоен, сохраняем его на заявке
      if GetXmlAttrValue(ndOrder, 'AUFTRAG_ID') <> sl[3] then
      begin
        SetXmlAttr(ndOrder, 'AUFTRAG_ID', sl[3]);
        dmOtto.ActionExecute(aTransaction, ndOrder);
        dmOtto.ObjectGet(ndOrder, OrderId, aTransaction);
      end;

      Dimension:= dmOtto.Recode('ARTICLE', 'DIMENSION', sl[6]);

      dmOtto.OrderItemsGet(ndOrder.NodeNew('ORDERITEMS'), OrderId, aTransaction);
      ndOrderItem:= ChildByAttributes(ndOrder.NodeByName('ORDERITEMS'),
        'ARTICLE_CODE;DIMENSION;ORDERITEM_INDEX',
        [sl[5], VarArrayOf([Dimension, sl[6]]), sl[4]]);
      if ndOrderItem = nil then
        ndOrderItem:= ChildByAttributes(ndOrder.NodeByName('ORDERITEMS'),
          'ARTICLE_CODE;DIMENSION;ORDERITEM_INDEX;STATUS_SIGN',
          [sl[5], VarArrayOf([Dimension, sl[6]]), '', VarArrayOf(['ACCEPTREQUEST','ACCEPTED','BUNDLING'])]);
      if ndOrderItem <> nil then
      begin
        ndOrderItem.ValueAsBool:= true;
        if GetXmlAttrValue(ndOrderItem, 'ORDERITEM_INDEX') = null then
          SetXmlAttr(ndOrderItem, 'ORDERITEM_INDEX', sl[4]);

        SetXmlAttrAsMoney(ndOrderItem, 'NEW.PRICE_EUR', sl[9]);

        if GetXmlAttrAsMoney(ndOrderItem, 'NEW.PRICE_EUR') <> GetXmlAttrAsMoney(ndOrderItem, 'PRICE_EUR') then
        begin
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Заявка [ORDER_CODE]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Измнена цена [PRICE_EUR] => [NEW.PRICE_EUR].',
            'W',
            XmlAttrs2Vars(ndOrderItem, 'ORDERITEM_ID=ID;ORDERITEM_INDEX;ORDER_ID;ARTICLE_CODE;DIMENSION;PRICE_EUR;NEW.PRICE_EUR',
            XmlAttrs2Vars(ndOrder, 'ORDER_CODE',
            Value2Vars(LineNo, 'LINE_NO'))));
          SetXmlAttrAsMoney(ndOrderItem, 'PRICE_EUR', sl[9]);
          SetXmlAttrAsMoney(ndOrderItem, 'COST_EUR', GetXmlAttrValue(ndOrderItem, 'PRICE_EUR')*getXmlAttrValue(ndOrderItem, 'AMOUNT'));
        end;

        StateSign:= dmOtto.Recode('ORDERITEM', 'DELIVERY_CODE_TIME', sl[10]);
        if StateSign = sl[10] then
        begin
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Заявка [ORDER_CODE]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Неизвестный DeliveryCode = [DELIVERY_CODE]',
            'E',
            XmlAttrs2Vars(ndOrderItem, 'ORDERITEM_ID=ID;ORDERITEM_INDEX;ORDER_ID;ARTICLE_CODE;DIMENSION',
            XmlAttrs2Vars(ndOrder, 'ORDER_CODE;CLIENT_ID',
            Value2Vars(LineNo, 'LINE_NO',
            Strings2Vars(sl, 'DELIVERY_CODE=10')))))
        end
        else
        if Pos(','+StateSign+',', ',ANULLED,REJECTED,') <> 0 then
        begin
          SetXmlAttr(ndOrderItem, 'NEW.STATUS_SIGN', StateSign);
          MessageClass:= 'W';
        end
        else
        begin
          SetXmlAttr(ndOrderItem, 'NEW.STATE_SIGN', StateSign);
          if sl[12] <> '00000000000000' then
          begin
            SetXmlAttr(ndOrderItem, 'NEW.STATUS_SIGN', 'BUNDLING');
            MessageClass:= 'I';
          end
          else
            MessageClass:= 'W';
        end;

        NewDeliveryMessage:= dmOtto.Recode('ORDERITEM', 'DELIVERY_MESSAGE_RUS', sl[11]);
        StatusName:= aTransaction.DefaultDatabase.QueryValue(
          'select status_name from statuses where object_sign=''ORDERITEM'' and status_sign = :status_sign',
          0, [GetXmlAttrValue(ndOrderItem, 'STATUS_SIGN')]);
        try
          ndOrderItem.ValueAsBool:= True;
          dmOtto.ActionExecute(aTransaction, ndOrderItem);
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Заявка [ORDER_CODE]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. [STATUS_NAME] ([DELIVERY_MESSAGE_RUS])',
            MessageClass,
            XmlAttrs2Vars(ndOrderItem, 'ORDERITEM_ID=ID;ORDERITEM_INDEX;ORDER_ID;ARTICLE_CODE;DIMENSION',
            XmlAttrs2Vars(ndOrder, 'ORDER_CODE;CLIENT_ID',
            Value2Vars(NewDeliveryMessage, 'DELIVERY_MESSAGE_RUS',
            Value2Vars(LineNo, 'LINE_NO',
            Value2Vars(StatusName, 'STATUS_NAME'))))));
        except
          on E: Exception do
            dmOtto.Notify(aMessageId,
              '[LINE_NO]. Заявка [ORDER_CODE]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Ошибка ([ERROR_TEXT])',
              'E',
              XmlAttrs2Vars(ndOrderItem, 'ORDERITEM_ID=ID;ORDERITEM_INDEX;ORDER_ID;ARTICLE_CODE;DIMENSION',
              XmlAttrs2Vars(ndOrder, 'ORDER_CODE;CLIENT_ID',
              Value2Vars(LineNo, 'LINE_NO',
              Value2Vars(Trim(E.Message), 'ERROR_TEXT')))));
        end;
      end
      else
        dmOtto.Notify(aMessageId,
          '[LINE_NO]. Заявка [ORDER_CODE]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Позиция не найдена в заявке [ORDER_CODE].',
          'E',
          Strings2Vars(sl, 'ORDERITEM_INDEX=4;ARTICLE_CODE=5;DIMENSION=6',
          XmlAttrs2Vars(ndOrder, 'ORDER_CODE;CLIENT_ID;ORDER_ID=ID',
          Value2Vars(LineNo, 'LINE_NO'))));
    end
    else
      dmOtto.Notify(aMessageId,
        '[LINE_NO]. Заявка [ORDER_CODE]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Неизвестная заявка [OTTO_ORDER_CODE].',
        'E',
        Strings2Vars(sl, 'CLIENT_ID=1;ORDER_CODE=2;ORDERITEM_INDEX=4;ARTICLE_CODE=5;DIMENSION=6;OTTO_ORDER_CODE=2',
        Value2Vars(LineNo, 'LINE_NO')));
  finally
    sl.Free;
  end;
end;

procedure ParseLiefer(aMessageId: Integer; ndOrders: TXmlNode; aTransaction: TpFIBTransaction);
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
      dmOtto.InitProgress(Lines.Count, Format('Ообработка файла %s ...', [MessageFileName]));
      For LineNo:= 0 to Lines.Count - 1 do
      begin
        ParseLieferLine(aMessageId, LineNo, Lines[LineNo], ndOrders, aTransaction);
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
      'Конец обработки файла: [FILE_NAME]', 'I',
      Value2Vars(MessageFileName, 'FILE_NAME'));
    Lines.Free;
  end;
end;

procedure ProcessLiefer(aMessageId: Integer; aTransaction: TpFIBTransaction);
var
  aXml: TNativeXml;
begin
  aXml:= TNativeXml.CreateName('MESSAGE');
  SetXmlAttr(aXml.Root, 'MESSAGE_ID', aMessageId);
  try
    if not aTransaction.Active then
      aTransaction.StartTransaction;
    try
      ParseLiefer(aMessageId, aXml.Root, aTransaction);
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
