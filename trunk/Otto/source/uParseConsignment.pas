unit uParseConsignment;

interface

uses
  GvXml, FIBDatabase, pFIBDatabase;

procedure ProcessConsignment(aMessageId: Integer; aTransaction: TpFIBTransaction);

implementation

uses
  Classes, SysUtils, GvStr, udmOtto, Variants, GvXmlUtils,
  Dialogs, Controls, DateUtils;

procedure ParseConsignmentLine100(aMessageId, LineNo: Integer; sl: TStringList;
  ndProduct, ndOrders: TGvXmlNode; aTransaction: TpFIBTransaction; aLine: string);
var
  DealerId: variant;
begin
  ndOrders['PACKLIST_NO']:= sl[1];
  ndOrders['PALETTE_NO']:= sl[3];
  ndOrders['PACKLIST_DT']:= sl[4];
  // транслируем заголовок на всех дилеров
  dmOtto.AllDealersNotify(aMessageId, aLine, aTransaction);
end;

procedure ParseConsignmentLine200(aMessageId, LineNo: Integer; sl: TStringList;
  ndProduct, ndOrders: TGvXmlNode; aTransaction: TpFIBTransaction; aLine: string);
var
  ndOrder, ndOrderItems, ndOrderItem: TGvXmlNode;
  OrderId, DealerId, NewStatusSign, StatusId, StatusName, OrderItemId: variant;
  NewDeliveryMessage: string;
  Dimension: string;
begin
  OrderId:= dmOtto.DetectOrderId(ndProduct, sl[2], aTransaction);
  if OrderId<>null then
  begin
    ndOrder:= ndOrders.Find('ORDER', 'ID', OrderId);
    if ndOrder = nil then
    begin
      ndOrder:= ndOrders.AddChild('ORDER');
      ndOrderItems:= ndOrder.AddChild('ORDERITEMS');
      dmOtto.ObjectGet(ndOrder, OrderId, aTransaction);
      dmOtto.OrderItemsGet(ndOrderItems, OrderId, aTransaction);
    end
    else
      ndOrderItems:= ndOrder.Find('ORDERITEMS');

    Dimension:= dmOtto.Recode('ORDERITEM', 'DIMENSION', sl[5]);

    ndOrderItem:= ndOrderItems.Find('ORDERITEM', 'ARTICLE_CODE;DIMENSION;STATUS_SIGN',
      [sl[4], VarArrayOf([Dimension, sl[5]]), VarArrayOf(['BUNDLING', 'ACCEPTREQUEST', 'ACCEPTED', 'PREPACKED'])]);
    if ndOrderItem <> nil then
    begin
      OrderItemId:= ndOrderItem['ID'];
      ndOrderItem['DESCRIPTION']:= sl[6];
      ndOrderItem['NREGWG']:= sl[9];
      ndOrderItem['NRRETCODE']:= sl[10];
      ndOrderItem['NEW.STATUS_SIGN']:= 'PACKED';
      try
        dmOtto.ActionExecute(aTransaction, ndOrderItem);
        dmOtto.ObjectGet(ndOrderItem, OrderItemId, aTransaction);
        dmOtto.Notify(aMessageId,
          '[LINE_NO]. Заявка [ORDER_CODE], Артикул [ARTICLE_CODE], Размер [DIMENSION]. Палетта [PALETTE_NO]. Пакет [PACKET_NO]. [STATUS_NAME]',
          'I',
          XmlAttrs2Attr(ndOrder, 'ORDER_CODE',
          XmlAttrs2Attr(ndOrders,'PALETTE_NO',
          XmlAttrs2Attr(ndOrderItem, 'ORDERITEM_ID=ID;ORDER_ID;ARTICLE_CODE;DIMENSION;STATUS_NAME',
          Strings2Attr(sl, 'PACKET_NO=1',
          Value2Attr(LineNo, 'LINE_NO'))))));
      except
        on E: Exception do
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Заявка [ORDER_CODE], Артикул [ARTICLE_CODE], Размер [DIMENSION]. Ошибка ([ERROR_TEXT])',
            'E',
            XmlAttrs2Attr(ndOrder, 'ORDER_CODE',
            XmlAttrs2Attr(ndOrderItem, 'ORDERITEM_ID=ID;ORDER_ID;ARTICLE_CODE;DIMENSION',
            Value2Attr(LineNo, 'LINE_NO',
            Value2Attr(E.Message, 'ERROR_TEXT')))));
      end;
    end
    else
      dmOtto.Notify(aMessageId,
        '[LINE_NO]. Заявка [ORDER_CODE], Артикул [ARTICLE_CODE], Размер [DIMENSION]. Позиция не найдена в заявке.',
        'E', Strings2Attr(sl, 'ARTICLE_CODE=4;DIMENSION=5',
             XmlAttrs2Attr(ndOrder, 'ORDER_CODE;ORDER_ID=ID',
             Value2Attr(LineNo, 'LINE_NO'))));
  end
  else
  begin
    DealerId:= dmOtto.IsDealerOrder(ndProduct, sl[2], aTransaction);
    if DealerId <> null then
    begin
      dmOtto.Notify(aMessageId,
        '[LINE_NO]. Заявка [ORDER_CODE], Артикул [ARTICLE_CODE], Размер [DIMENSION]. Заявка дилера [DEALER_ID].',
        'I',
        Strings2Attr(sl, 'ARTICLE_CODE=4;DIMENSION=5;ORDER_CODE=3',
        Value2Attr(LineNo, 'LINE_NO',
        Value2Attr(DealerId, 'DEALER_ID',
        Value2Attr(dmOtto.DetectOrderCode(ndProduct, sl[2]), 'ORDER_CODE')))));
      dmOtto.DealerNotify(aMessageId, DealerId, aLine, aTransaction);
    end
    else
      dmOtto.Notify(aMessageId,
        '[LINE_NO]. Заявка [ORDER_CODE], Артикул [ARTICLE_CODE], Размер [DIMENSION]. Неизвестная заявка.',
        'E',
        Strings2Attr(sl, 'ARTICLE_CODE=4;DIMENSION=5;ORDER_CODE=3',
        Value2Attr(LineNo, 'LINE_NO')));
  end;
end;

procedure ParseConsignmentLine300(aMessageId, LineNo: Integer; sl: TStringList;
  ndProduct, ndOrders: TGvXmlNode; aTransaction: TpFIBTransaction; aLine: string);
var
  OrderId, DealerId: Variant;
  ndOrder: TGvXmlNode;
  BarCode: String;
begin
  OrderId:= dmOtto.DetectOrderId(ndProduct, sl[2], aTransaction);
  if OrderId<>null then
  begin
    ndOrder:= ndOrders.Find('ORDER', 'ID', OrderId);
    if ndOrder <> nil then
    begin
      ndOrder['WEIGHT']:= sl[6];
      ndOrder['ITEMSCOST_EUR']:= StrToCurr(sl[3]);
      ndOrder['NEW.STATUS_SIGN']:= 'PACKED';
      BatchMoveFields(ndOrder, ndOrders, 'PACKLIST_NO;PACKLIST_DT;PALETTE_NO');
      ndOrder['PACKET_NO']:= sl[1];
      BarCode:= aTransaction.DefaultDatabase.QueryValue(
        'select o_barcode from barcode_gen(:order_id, :packlist_no)',
        0, [OrderId, ndOrder['PACKLIST_NO']], aTransaction);
      ndOrder['BAR_CODE']:= BarCode;

      try
        dmOtto.ActionExecute(aTransaction, ndOrder);
        dmOtto.ObjectGet(ndOrder, OrderId, aTransaction);
        dmOtto.Notify(aMessageId,
          '[LINE_NO]. Заявка [ORDER_CODE], Вес [WEIGHT], Стоимость [ITEMSCOST_EUR], Пакет [PACKET_NO], Bar Code [BAR_CODE]. [STATUS_NAME]',
          'I',
          XmlAttrs2Attr(ndOrder, 'ORDER_CODE;WEIGHT;ITEMSCOST_EUR;PACKET_NO;BAR_CODE;STATUS_NAME',
          Value2Attr(LineNo, 'LINE_NO')));
      except
        on E: Exception do
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Заявка [ORDER_CODE], Ошибка ([ERROR_TEXT])',
            'E',
            XmlAttrs2Attr(ndOrder, 'ORDER_CODE',
            Value2Attr(LineNo, 'LINE_NO',
            Value2Attr(E.Message, 'ERROR_TEXT'))));
      end;
    end;
  end
  else
  begin
    DealerId:= dmOtto.IsDealerOrder(ndProduct, sl[2], aTransaction);
    if DealerId <> null then
    begin
      dmOtto.Notify(aMessageId,
        '[LINE_NO]. Заявка [ORDER_CODE]. Заявка дилера [DEALER_ID].',
        'I',
        Value2Attr(LineNo, 'LINE_NO',
        Value2Attr(DealerId, 'DEALER_ID',
        Value2Attr(dmOtto.DetectOrderCode(ndProduct, sl[2]), 'ORDER_CODE'))));
      dmOtto.DealerNotify(aMessageId, DealerId, aLine, aTransaction);
    end;
  end;
end;

procedure ParseConsignmentLine400(aMessageId, LineNo: Integer; sl: TStringList;
  ndProduct, ndOrders: TGvXmlNode; aTransaction: TpFIBTransaction; aLine: string);
begin
   dmOtto.Notify(aMessageId,
     '[LINE_NO]',
     'I',
     Value2Attr(LineNo, 'LINE_NO'));
   dmOtto.AllDealersNotify(aMessageId, aLine, aTransaction);
end;

procedure ParseConsignmentLine(aMessageId, LineNo: Integer; aLine: string;
  ndProduct, ndOrders: TGvXmlNode; aTransaction: TpFIBTransaction);
var
  sl: TStringList;
begin
  sl:= TStringList.Create;
  try
    sl.Delimiter:= ';';
    sl.DelimitedText:= '"'+ReplaceAll(aLine, ';', '";"')+'"';
    if sl[0] = '100' then
      ParseConsignmentLine100(aMessageId, LineNo, sl, ndProduct, ndOrders, aTransaction, aLine)
    else
    if sl[0] = '200' then
      ParseConsignmentLine200(aMessageId, LineNo, sl, ndProduct, ndOrders, aTransaction, aLine)
    else
    if sl[0] = '300' then
      ParseConsignmentLine300(aMessageId, LineNo, sl, ndProduct, ndOrders, aTransaction, aLine)
    else
    if sl[0] = '400' then
      ParseConsignmentLine400(aMessageId, LineNo, sl, ndProduct, ndOrders, aTransaction, aLine);
  finally
    sl.Free;
  end;
end;

procedure ParseConsignment(aMessageId: Integer; ndMessage: TGvXmlNode; aTransaction: TpFIBTransaction);
var
  LineNo: Integer;
  Lines: TStringList;
  MessageFileName: variant;
  ndProduct, ndOrders: TGvXmlNode;
begin
  dmOtto.ClearNotify(aMessageId);
  aTransaction.StartTransaction;
  try
    dmOtto.ObjectGet(ndMessage, aMessageId, aTransaction);
    ndProduct:= ndMessage.FindOrCreate('PRODUCT');
    dmOtto.ObjectGet(ndProduct, dmOtto.DetectProductId(ndMessage, aTransaction), aTransaction);
    ndOrders:= ndMessage.FindOrCreate('ORDERS');

    MessageFileName:= ndMessage['FILE_NAME'];
    dmOtto.Notify(aMessageId,
      'Начало обработки файла: [FILE_NAME]', '',
      Value2Attr(MessageFileName, 'FILE_NAME'));

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
  end
end;

procedure ProcessConsignment(aMessageId: Integer; aTransaction: TpFIBTransaction);
var
  aXml: TGvXml;
begin
  aXml:= TGvXml.Create('MESSAGE');
  try
    ParseConsignment(aMessageId, aXml.Root, aTransaction);
  finally
    aXml.Free;
  end;
end;


end.





