unit uParseConsignment;

interface

uses
  NativeXml, FIBDatabase, pFIBDatabase;

procedure ProcessConsignment(aMessageId: Integer; aTransaction: TpFIBTransaction);

implementation

uses
  Classes, SysUtils, GvStr, udmOtto, Variants, GvNativeXml,
  Dialogs, Controls, DateUtils;

procedure ParseConsignmentLine100(aMessageId, LineNo: Integer; sl: TStringList;
  ndProduct, ndOrders: TXmlNode; aTransaction: TpFIBTransaction);
begin
  SetXmlAttr(ndOrders, 'PACKLIST_NO', sl[1]);
  SetXmlAttr(ndOrders, 'PALETTE_NO', sl[3]);
  SetXmlAttr(ndOrders, 'PACKLIST_DT', sl[4]);
  ndOrders.Document.XmlFormat:= xfReadable;
  ndOrders.Document.SaveToFile('order.xml');
end;

procedure ParseConsignmentLine200(aMessageId, LineNo: Integer; sl: TStringList;
  ndProduct, ndOrders: TXmlNode; aTransaction: TpFIBTransaction);
var
  ndOrder, ndOrderItems, ndOrderItem: TXmlNode;
  OrderId, NewStatusSign, StatusId, StatusName, OrderItemId: variant;
  NewDeliveryMessage: string;
  Dimension: string;
begin
  OrderId:= dmOtto.DetectOrderId(ndProduct, sl[2], aTransaction);
  if OrderId<>null then
  begin
    ndOrder:= ndOrders.NodeByAttributeValue('ORDER', 'ID', OrderId, false);
    if ndOrder = nil then
    begin
      ndOrder:= ndOrders.NodeNew('ORDER');
      ndOrderItems:= ndOrder.NodeNew('ORDERITEMS');
      dmOtto.ObjectGet(ndOrder, OrderId, aTransaction);
      dmOtto.OrderItemsGet(ndOrderItems, OrderId, aTransaction);
    end
    else
      ndOrderItems:= ndOrder.NodeByName('ORDERITEMS');

    Dimension:= dmOtto.Recode('ARTICLE', 'DIMENSION', sl[5]);

    ndOrderItem:= ChildByAttributes(ndOrderItems, 'ARTICLE_CODE;DIMENSION;STATUS_SIGN',
      [sl[4], VarArrayOf([Dimension, sl[5]]), VarArrayOf(['BUNDLING', 'ACCEPTREQUEST', 'ACCEPTED', 'PREPACKED'])]);
    if ndOrderItem <> nil then
    begin
      OrderItemId:= GetXmlAttrValue(ndOrderItem, 'ID');
      SetXmlAttr(ndOrderItem, 'DESCRIPTION', sl[6]);
      SetXmlAttr(ndOrderItem, 'NREGWG', sl[9]);
      SetXmlAttr(ndOrderItem, 'NRRETCODE', sl[10]);
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

procedure ParseConsignmentLine300(aMessageId, LineNo: Integer; sl: TStringList;
  ndProduct, ndOrders: TXmlNode; aTransaction: TpFIBTransaction);
var
  OrderId: Variant;
  ndOrder: TXmlNode;
  BarCode: String;
begin
  OrderId:= dmOtto.DetectOrderId(ndProduct, sl[2], aTransaction);
  if OrderId<>null then
  begin
    ndOrder:= ndOrders.NodeByAttributeValue('ORDER', 'ID', OrderId, false);
    if ndOrder <> nil then
    begin
      SetXmlAttr(ndOrder, 'WEIGHT', sl[6]);
      SetXmlAttrAsMoney(ndOrder, 'ITEMSCOST_EUR', sl[3]);
      SetXmlAttr(ndOrder, 'NEW.STATUS_SIGN', 'PACKED');
      BatchMoveFields2(ndOrder, ndOrders, 'PACKLIST_NO;PACKLIST_DT;PALETTE_NO');
      SetXmlAttr(ndOrder, 'PACKET_NO', sl[1]);
      BarCode:= aTransaction.DefaultDatabase.QueryValue(
        'select o_barcode from barcode_gen(:order_id, :packlist_no)',
        0, [OrderId, GetXmlAttrValue(ndOrder, 'PACKLIST_NO')], aTransaction);
      SetXmlAttr(ndOrder, 'BAR_CODE', BarCode);

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

procedure ParseConsignmentLine400(aMessageId, LineNo: Integer; sl: TStringList;
  ndProduct, ndOrders: TXmlNode; aTransaction: TpFIBTransaction);
begin
   dmOtto.Notify(aMessageId,
     '[LINE_NO]',
     'I',
     Value2Vars(LineNo, 'LINE_NO'));
end;

procedure ParseConsignmentLine(aMessageId, LineNo: Integer; aLine: string;
  ndProduct, ndOrders: TXmlNode; aTransaction: TpFIBTransaction);
var
  sl: TStringList;
begin
  sl:= TStringList.Create;
  try
    sl.Delimiter:= ';';
    sl.DelimitedText:= '"'+ReplaceAll(aLine, ';', '";"')+'"';
    if sl[0] = '100' then
      ParseConsignmentLine100(aMessageId, LineNo, sl, ndProduct, ndOrders, aTransaction)
    else
    if sl[0] = '200' then
      ParseConsignmentLine200(aMessageId, LineNo, sl, ndProduct, ndOrders, aTransaction)
    else
    if sl[0] = '300' then
      ParseConsignmentLine300(aMessageId, LineNo, sl, ndProduct, ndOrders, aTransaction)
    else
    if sl[0] = '400' then
      ParseConsignmentLine400(aMessageId, LineNo, sl, ndProduct, ndOrders, aTransaction);
  finally
    sl.Free;
  end;
end;

procedure ParseConsignment(aMessageId: Integer; ndMessage: TXmlNode; aTransaction: TpFIBTransaction);
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
          ParseConsignmentLine(aMessageId, LineNo, Lines[LineNo], ndProduct, ndOrders, aTransaction);
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
  end
end;

procedure ProcessConsignment(aMessageId: Integer; aTransaction: TpFIBTransaction);
var
  aXml: TNativeXml;
begin
  aXml:= TNativeXml.CreateName('MESSAGE');
  try
    ParseConsignment(aMessageId, aXml.Root, aTransaction);
  finally
    aXml.Free;
  end;
end;


end.
