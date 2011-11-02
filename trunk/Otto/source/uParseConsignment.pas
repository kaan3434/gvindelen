unit uParseConsignment;

interface

uses
  NativeXml, FIBDatabase, pFIBDatabase;

procedure ProcessConsignment(aMessageId: Integer; aTransaction: TpFIBTransaction);

implementation

uses
  Classes, SysUtils, GvStr, udmOtto, pFIBStoredProc, Variants, GvNativeXml,
  Dialogs, Controls, StrUtils;

procedure ParseConsignmentLine100(aMessageId, LineNo, DealId: Integer;
  sl: TStringList; ndOrders: TXmlNode; aTransaction: TpFIBTransaction);
begin
  SetXmlAttr(ndOrders, 'INVOICE_NO', sl[1]);
  SetXmlAttr(ndOrders, 'PALETTE_NO', sl[3]);
end;

procedure ParseConsignmentLine200(aMessageId, LineNo, DealId: Integer;
  sl: TStringList; ndOrders: TXmlNode; aTransaction: TpFIBTransaction);
var
  OrderCode: WideString;
  ndOrder, ndOrderItem: TXmlNode;
  OrderId, NewStatusSign, StatusId, StatusName: variant;
  NewDeliveryMessage: string;
  Dimension: string;
begin
  OrderCode:= 'С'+sl[3];
  OrderId:= aTransaction.DefaultDatabase.QueryValue(
    'select order_id from orders where order_code = :order_code',
    0, [OrderCode], aTransaction);
  if OrderId<>null then
  begin
    ndOrder:= ndOrders.NodeByAttributeValue('ORDER', 'ID', OrderId);
    if ndOrder = nil then
    begin
      ndOrder:= ndOrders.NodeNew('ORDER');
      dmOtto.ObjectGet(ndOrder, OrderId, aTransaction);
      dmOtto.OrderItemsGet(ndOrder.NodeNew('ORDERITEMS'), OrderId, aTransaction);
      SetXmlAttr(ndOrder, 'OTTO_ORDER_CODE', sl[3]);
      BatchMoveFields2(ndOrder, ndOrders, 'INVOICE_NO;PALETTE_NO;PACKET_NO');
    end;
    Dimension:= dmOtto.Recode('ARTICLE', 'DIMENSION', sl[5]);
    StatusId:= dmOtto.GetStatusBySign('ORDERITEM', 'BUNDLING');

    ndOrderItem:= ChildByAttributes(ndOrder.NodeByName('ORDERITEMS'), 'ARTICLE_CODE;DIMENSION;STATUS_ID', [sl[4], Dimension, StatusId]);
    if ndOrderItem <> nil then
    begin
      SetXmlAttr(ndOrderItem, 'DESCRIPTION', sl[6]);
      SetXmlAttr(ndOrderItem, 'NREGWG', sl[9]);
      SetXmlAttr(ndOrderItem, 'STATUS_SIGN', 'PACKED');
      StatusName:= aTransaction.DefaultDatabase.QueryValue(
        'select status_name from statuses where object_sign=''ORDERITEM'' and status_sign = :status_sign',
        0, [GetXmlAttrValue(ndOrderItem, 'STATUS_SIGN')]);
      try
        dmOtto.ActionExecute(aTransaction, ndOrderItem, DealId);
        dmOtto.Notify(aMessageId,
           '[LINE_NO]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. [STATUS_NAME]',
           'I',
           XmlAttrs2Vars(ndOrderItem, 'ORDERITEM_ID=ID;ORDER_ID;ARTICLE_CODE;DIMENSION',
           Value2Vars(LineNo, 'LINE_NO',
           Value2Vars(StatusName, 'STATUS_NAME'))));
      except
        on E: Exception do
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Ошибка ([ERROR_TEXT])',
            'E',
            XmlAttrs2Vars(ndOrderItem, 'ORDERITEM_ID=ID;ORDER_ID;ARTICLE_CODE;DIMENSION',
            Value2Vars(LineNo, 'LINE_NO',
            Value2Vars(E.Message, 'ERROR_TEXT'))));
      end;
    end
    else
      dmOtto.Notify(aMessageId,
        '[LINE_NO]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Позиция не найдена в заявке [ORDER_CODE].',
        'E', Strings2Vars(sl, 'ARTICLE_CODE=4;DIMENSION=5',
             XmlAttrs2Vars(ndOrder, 'ORDER_CODE;ORDER_ID=ID',
             Value2Vars(LineNo, 'LINE_NO'))));
  end
  else
    dmOtto.Notify(aMessageId,
      '[LINE_NO]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Неизвестная заявка [OTTO_ORDER_CODE].',
      'E',
      Strings2Vars(sl, 'ARTICLE_CODE=4;DIMENSION=5;OTTO_ORDER_CODE=3',
      Value2Vars(LineNo, 'LINE_NO')));
end;

procedure ParseConsignmentLine300(aMessageId, LineNo, DealId: Integer;
  sl: TStringList; ndOrders: TXmlNode; aTransaction: TpFIBTransaction);
var
  ndOrder: TXmlNode;
begin
  ndOrder:= ndOrders.NodeByAttributeValue('ORDER', 'PACKET_NO', sl[1]);
  if ndOrder<>nil then
  begin
    SetXmlAttr(ndOrder, 'WEIGHT', sl[6]);
  end;
end;

procedure ParseConsignmentLine400(aMessageId, LineNo, DealId: Integer;
  sl: TStringList; ndOrders: TXmlNode; aTransaction: TpFIBTransaction);
begin

end;

procedure ParseConsignmentLine(aMessageId, LineNo, DealId: Integer; aLine: string; ndOrders: TXmlNode; aTransaction: TpFIBTransaction);
var
  sl: TStringList;
begin
  sl:= TStringList.Create;
  try
    sl.Delimiter:= ';';
    sl.DelimitedText:= '"'+ReplaceAll(aLine, ';', '";"')+'"';
    if sl[0] = '100' then
      ParseConsignmentLine100(aMessageId, LineNo, DealId, sl, ndOrders, aTransaction)
    else
    if sl[0] = '200' then
      ParseConsignmentLine200(aMessageId, LineNo, DealId, sl, ndOrders, aTransaction)
    else
    if sl[0] = '300' then
      ParseConsignmentLine300(aMessageId, LineNo, DealId, sl, ndOrders, aTransaction)
    else
    if sl[0] = '400' then
      ParseConsignmentLine400(aMessageId, LineNo, DealId, sl, ndOrders, aTransaction);
  finally
    sl.Free;
  end;
end;

procedure ParseConsignment(aMessageId: Integer; ndOrders: TXmlNode; aTransaction: TpFIBTransaction);
var
  LineNo, DealId: Integer;
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
    DealId:= dmOtto.CreateDeal(aTransaction);
    Lines:= TStringList.Create;
    try
      Lines.LoadFromFile(Path['Messages.In']+MessageFileName);
      ndOrder:= ndOrders.NodeNew('ORDER');
      For LineNo:= 0 to Lines.Count - 1 do
        ParseConsignmentLine(aMessageId, LineNo, DealId, Lines[LineNo], ndOrders, aTransaction);
    finally
      Lines.Free;
    end;
    dmOtto.Notify(aMessageId,
      'Конец обработки файла: [FILE_NAME]', 'I',
      Value2Vars(MessageFileName, 'FILE_NAME'));
    try
      dmOtto.ActionExecute(aTransaction, 'EVENT', '',
        Value2Vars('FORM_PROTOCOL', 'EVENT_SIGN',
        Value2Vars(aMessageId, 'OBJECT_ID')), DealId);
    except
      on E: Exception do
        dmOtto.Notify(aMessageId,
          'Содание события FORM_PROTOCOL. Ошибка ([ERROR_TEXT])',
          'E',
          Value2Vars(E.Message, 'ERROR_TEXT'));
    end;

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
