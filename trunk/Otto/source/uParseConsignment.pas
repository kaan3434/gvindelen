unit uParseConsignment;

interface

uses
  NativeXml, FIBDatabase, pFIBDatabase;

procedure ProcessConsignment(aMessageId: Integer; aTransaction: TpFIBTransaction);

implementation

uses
  Classes, SysUtils, GvStr, udmOtto, Variants, GvNativeXml,
  Dialogs, Controls;

procedure ParseConsignmentLine100(aMessageId, LineNo: Integer;
  sl: TStringList; ndOrders: TXmlNode; aTransaction: TpFIBTransaction);
begin
  SetXmlAttr(ndOrders, 'PACKLIST_NO', sl[1]);
  SetXmlAttr(ndOrders, 'PALETTE_NO', sl[3]);
  SetXmlAttr(ndOrders, 'PACKLIST_DT', sl[4]);
  ndOrders.Document.XmlFormat:= xfReadable;
  ndOrders.Document.SaveToFile('order.xml');
end;

procedure ParseConsignmentLine200(aMessageId, LineNo: Integer;
  sl: TStringList; ndOrders: TXmlNode; aTransaction: TpFIBTransaction);
var
  ndOrder, ndOrderItem: TXmlNode;
  OrderId, NewStatusSign, StatusId, StatusName, OrderItemId: variant;
  NewDeliveryMessage: string;
  Dimension: string;
begin
  OrderId:= aTransaction.DefaultDatabase.QueryValue(
    'select order_id from orders where order_code like ''_''||:order_code',
    0, [FillFront(sl[2], 5, '0')], aTransaction);
  if OrderId<>null then
  begin
    ndOrder:= ndOrders.NodeByAttributeValue('ORDER', 'ID', OrderId);
    if ndOrder = nil then
    begin
      ndOrder:= ndOrders.NodeNew('ORDER');
      dmOtto.ObjectGet(ndOrder, OrderId, aTransaction);
      dmOtto.OrderItemsGet(ndOrder.NodeNew('ORDERITEMS'), OrderId, aTransaction);
    end;

    Dimension:= dmOtto.Recode('ARTICLE', 'DIMENSION', sl[5]);

    ndOrderItem:= ChildByAttributes(ndOrder.NodeByName('ORDERITEMS'),
      'ARTICLE_CODE;DIMENSION;STATUS_SIGN',
      [sl[4], VarArrayOf([Dimension, sl[5]]), VarArrayOf(['BUNDLING', 'ACCEPTREQUEST', 'ACCEPTED'])]);
    if ndOrderItem <> nil then
    begin
      OrderItemId:= GetXmlAttrValue(ndOrderItem, 'ID');
      SetXmlAttr(ndOrderItem, 'DESCRIPTION', sl[6]);
      SetXmlAttr(ndOrderItem, 'NREGWG', sl[9]);
      SetXmlAttr(ndOrderItem, 'NEW.STATUS_SIGN', 'PACKED');
      try
        dmOtto.ActionExecute(aTransaction, ndOrderItem);
        dmOtto.ObjectGet(ndOrderItem, OrderItemId, aTransaction);
        dmOtto.Notify(aMessageId,
          '[LINE_NO]. Заявка [ORDER_CODE], Артикул [ARTICLE_CODE], Размер [DIMENSION]. Палетта [PALETTE_NO]. Пакет [PACKET_NO]. [STATUS_NAME]',
          'I',
          XmlAttrs2Vars(ndOrder, 'ORDER_CODE',
          XmlAttrs2Vars(ndOrders,'PALETTE_NO',
          XmlAttrs2Vars(ndOrderItem, 'ORDERITEM_ID=ID;ORDER_ID;ARTICLE_CODE;DIMENSION;STATUS_NAME',
          Strings2Vars(sl, 'PACKET_NO=1',
          Value2Vars(LineNo, 'LINE_NO'))))));
      except
        on E: Exception do
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Заявка [ORDER_CODE], Артикул [ARTICLE_CODE], Размер [DIMENSION]. Ошибка ([ERROR_TEXT])',
            'E',
            XmlAttrs2Vars(ndOrder, 'ORDER_CODE',
            XmlAttrs2Vars(ndOrderItem, 'ORDERITEM_ID=ID;ORDER_ID;ARTICLE_CODE;DIMENSION',
            Value2Vars(LineNo, 'LINE_NO',
            Value2Vars(E.Message, 'ERROR_TEXT')))));
      end;
    end
    else
      dmOtto.Notify(aMessageId,
        '[LINE_NO]. Заявка [ORDER_CODE], Артикул [ARTICLE_CODE], Размер [DIMENSION]. Позиция не найдена в заявке.',
        'E', Strings2Vars(sl, 'ARTICLE_CODE=4;DIMENSION=5',
             XmlAttrs2Vars(ndOrder, 'ORDER_CODE;ORDER_ID=ID',
             Value2Vars(LineNo, 'LINE_NO'))));
  end
  else
    dmOtto.Notify(aMessageId,
      '[LINE_NO]. Заявка [ORDER_CODE], Артикул [ARTICLE_CODE], Размер [DIMENSION]. Неизвестная заявка.',
      'E',
      Strings2Vars(sl, 'ARTICLE_CODE=4;DIMENSION=5;ORDER_CODE=3',
      Value2Vars(LineNo, 'LINE_NO')));
end;

function CalcControlChar(St: string): Char;
var
  k: Integer;
begin
  k:= 11 - (8*StrToInt(st[1]) + 6*StrToInt(st[2]) + 4*StrToInt(st[3]) +
            2*StrToInt(st[4]) + 3*StrToInt(st[5]) + 5*StrToInt(st[6]) +
            9*StrToInt(st[7]) + 7*StrToInt(st[8])) mod 11;
  case k of
    10 : Result:= '0';
    11 : Result:= '5';
  else
    Result:= IntToStr(k)[1];
  end;
end;

function GetBarCode(ndOrder: TXmlNode): string;
var
  Body: string;
begin
  Body:= CopyLast(GetXmlAttr(ndOrder, 'PACKLIST_NO'), 3) +
         CopyLast(GetXmlAttr(ndOrder, 'ORDER_CODE'), 5);
  Result:= 'CZ'+Body+CalcControlChar(Body)+'LT';
end;

procedure ParseConsignmentLine300(aMessageId, LineNo: Integer;
  sl: TStringList; ndOrders: TXmlNode; aTransaction: TpFIBTransaction);
var
  OrderId: Variant;
  ndOrder: TXmlNode;
begin
  OrderId:= aTransaction.DefaultDatabase.QueryValue(
    'select order_id from orders where order_code like ''_''||:order_code',
    0, [FillFront(sl[2], 5, '0')], aTransaction);
  if OrderId<>null then
  begin
    ndOrder:= ndOrders.NodeByAttributeValue('ORDER', 'ID', OrderId);
    if ndOrder <> nil then
    begin
      SetXmlAttr(ndOrder, 'WEIGHT', sl[6]);
      SetXmlAttrAsMoney(ndOrder, 'ITEMSCOST_EUR', sl[3]);
      SetXmlAttr(ndOrder, 'NEW.STATUS_SIGN', 'PACKED');
      BatchMoveFields2(ndOrder, ndOrders, 'PACKLIST_NO;PACKLIST_DT;PALETTE_NO');
      SetXmlAttr(ndOrder, 'PACKET_NO', sl[1]);
      SetXmlAttr(ndOrder, 'BAR_CODE', GetBarCode(ndOrder));
      ndOrder.Document.XmlFormat:= xfReadable;
      ndOrder.Document.SaveToFile('order.xml');
      try
        dmOtto.ActionExecute(aTransaction, ndOrder);
        dmOtto.ObjectGet(ndOrder, OrderId, aTransaction);
        dmOtto.Notify(aMessageId,
          '[LINE_NO]. Заявка [ORDER_CODE], Вес [WEIGHT], Стоимость [ITEMSCOST_EUR], Пакет [PACKET_NO], Bar Code [BAR_CODE]. [STATUS_NAME]',
          'I',
          XmlAttrs2Vars(ndOrder, 'ORDER_CODE;WEIGHT;ITEMSCOST_EUR;PACKET_NO;BAR_CODE;STATUS_NAME',
          Value2Vars(LineNo, 'LINE_NO')));
      except
        on E: Exception do
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Заявка [ORDER_CODE], Ошибка ([ERROR_TEXT])',
            'E',
            XmlAttrs2Vars(ndOrder, 'ORDER_CODE',
            Value2Vars(LineNo, 'LINE_NO',
            Value2Vars(E.Message, 'ERROR_TEXT'))));
      end;
    end;
  end;
end;

procedure ParseConsignmentLine400(aMessageId, LineNo: Integer;
  sl: TStringList; ndOrders: TXmlNode; aTransaction: TpFIBTransaction);
begin

end;

procedure ParseConsignmentLine(aMessageId, LineNo: Integer; aLine: string; ndOrders: TXmlNode; aTransaction: TpFIBTransaction);
var
  sl: TStringList;
begin
  sl:= TStringList.Create;
  try
    sl.Delimiter:= ';';
    sl.DelimitedText:= '"'+ReplaceAll(aLine, ';', '";"')+'"';
    if sl[0] = '100' then
      ParseConsignmentLine100(aMessageId, LineNo, sl, ndOrders, aTransaction)
    else
    if sl[0] = '200' then
      ParseConsignmentLine200(aMessageId, LineNo, sl, ndOrders, aTransaction)
    else
    if sl[0] = '300' then
      ParseConsignmentLine300(aMessageId, LineNo, sl, ndOrders, aTransaction)
    else
    if sl[0] = '400' then
      ParseConsignmentLine400(aMessageId, LineNo, sl, ndOrders, aTransaction);
  finally
    sl.Free;
  end;
end;

procedure ParseConsignment(aMessageId: Integer; ndOrders: TXmlNode; aTransaction: TpFIBTransaction);
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
  if not aTransaction.Active then
    aTransaction.StartTransaction;
  try
    Lines:= TStringList.Create;
    try
      if FileExists(Path['Messages.In']+MessageFileName) then
      begin
        Lines.LoadFromFile(Path['Messages.In']+MessageFileName);
        For LineNo:= 0 to Lines.Count - 1 do
          ParseConsignmentLine(aMessageId, LineNo, Lines[LineNo], ndOrders, aTransaction);
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
    try
      dmOtto.ActionExecute(aTransaction, 'EVENT', '',
        Value2Vars('FORM_PROTOCOL', 'EVENT_SIGN',
        Value2Vars(aMessageId, 'OBJECT_ID')));
    except
      on E: Exception do
        dmOtto.Notify(aMessageId,
          'Содание события FORM_PROTOCOL. Ошибка ([ERROR_TEXT])',
          'E',
          Value2Vars(E.Message, 'ERROR_TEXT'));
    end;
    dmOtto.MessageRelease(aTransaction, aMessageId);
    dmOtto.MessageSuccess(aTransaction, aMessageId);
    aTransaction.Commit;
  except
    aTransaction.Rollback;
  end
end;

procedure ProcessConsignment(aMessageId: Integer; aTransaction: TpFIBTransaction);
var
  aXml: TNativeXml;
begin
  aXml:= TNativeXml.CreateName('MESSAGE');
  SetXmlAttr(aXml.Root, 'MESSAGE_ID', aMessageId);
  try
    ParseConsignment(aMessageId, aXml.Root, aTransaction);
  finally
    aXml.Free;
  end;
end;


end.
