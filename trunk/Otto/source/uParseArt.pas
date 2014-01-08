unit uParseArt;

interface

uses
  GvXml, FIBDatabase, pFIBDatabase;

procedure ProcessInfoArt(aMessageId: Integer; aTransaction: TpFIBTransaction);

implementation

uses
  Classes, SysUtils, GvStr, udmOtto, Variants, GvXmlUtils,
  Dialogs, Controls, GvFile, GvVariant;

const
  Cols = 26;
  Dividers : array[0..Cols] of Byte =
    (  0,  10,  13,  16,  23,  32,  39,  46,  56,  61,
      71,  90,  95,  98, 101, 107, 118, 127, 131, 144,
     153, 156, 164, 168, 173, 188, 203);

procedure ParseArtLine(aMessageId, LineNo: Integer; aLine: string;
  ndProduct, ndOrders: TGvXmlNode; aTransaction: TpFIBTransaction);
var
  OrderId: variant;
  sl: TStringList;
  ndOrder, ndOrderItem, ndOrderItems: TGvXmlNode;
  NewStatusSign: variant;
  StateSign, Dimension: Variant;
  StateId: Variant;
  StatusName, MessageClass: Variant;
  NewDeliveryMessage, OrderCode: string;
  i: Integer;
begin
  sl:= TStringList.Create;
  try
    for i:= 1 to Cols do
      sl.Add(Trim(Copy(aLine, Dividers[i-1], Dividers[i]-Dividers[i-1])));

    OrderId:= dmOtto.DetectOrderId(ndProduct, sl[6], aTransaction);
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

      Dimension:= dmOtto.Recode('ORDERITEM', 'DIMENSION', sl[11]);

      ndOrderItem:= ndOrderItems.Find('ORDERITEM', 'AUFTRAG_ID;ORDERITEM_INDEX;ARTICLE_CODE;DIMENSION',
        [sl[7], sl[8], sl[9], VarArrayOf([Dimension, sl[11]])]);
      if ndOrderItem <> nil then
      begin
        if not ndOrderItem.HasAttribute('WEIGHT') then
        begin
          ndOrderItem['WEIGHT']:= Trunc(ToNumber(sl[16])*1000);
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID], Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Обновлен вес.',
            'I',
            XmlAttrs2Attr(ndOrder, 'ORDER_CODE;',
            XmlAttrs2Attr(ndOrderItem, 'AUFTRAG_ID;ORDERITEM_INDEX;ARTICLE_CODE;DIMENSION',
            Value2Attr(LineNo, 'LINE_NO'))));
        end;
        //
        StateSign := dmOtto.Recode('ORDERITEM', 'ART_STATE', sl[1]+sl[2]);
        if StateSign <> sl[1]+sl[2] then
          ndOrderItem['NEW.STATE_SIGN']:= StateSign;
        StateSign := dmOtto.Recode('ORDERITEM', 'ART_STATUS', sl[1]+sl[2]);
        if StateSign = sl[1]+sl[2] then
        begin
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID], Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Неизвестная комбинация ART_STATUS = [ART_STATUS],[ART_STATE].',
            'E',
            XmlAttrs2Attr(ndOrder, 'ORDER_CODE',
            XmlAttrs2Attr(ndOrderItem, 'AUFTRAG_ID;ORDERITEM_INDEX;ARTICLE_CODE;DIMENSION;STATUS_SIGN',
            Strings2Attr(sl, 'ART_STATUS=1;ART_STATE=2',
            Value2Attr(LineNo, 'LINE_NO')))));
          Exit;
        end;

        if Not ndOrderItem.Attr['STATUS_SIGN'].ValueIn([StateSign]) then
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID], Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Расходжение статусов [STATUS_SIGN]<>[ART_STATE_SIGN].',
            'W',
            XmlAttrs2Attr(ndOrder, 'ORDER_CODE',
            XmlAttrs2Attr(ndOrderItem, 'AUFTRAG_ID;ORDERITEM_INDEX;ARTICLE_CODE;DIMENSION;STATUS_SIGN',
            Value2Attr(StateSign, 'ART_STATE_SIGN',
            Value2Attr(LineNo, 'LINE_NO')))));

        if not ndOrderItem.HasAttribute('NREGWG') then
          ndOrderItem['NREGWG']:= sl[19];
        if not ndOrderItem.HasAttribute('NRRETCODE') then
          ndOrderItem['NRRETCODE']:= sl[17];
        if not ndOrderItem.HasAttribute('DESCRIPTION') then
          ndOrderItem['DESCRIPTION']:= Trim(sl[10]);
        if ndOrderItem.State = stChanged then
        try
          dmOtto.ActionExecute(aTransaction, ndOrderItem);
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID], Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Ok.',
            'I',
            XmlAttrs2Attr(ndOrder, 'ORDER_CODE;',
            XmlAttrs2Attr(ndOrderItem, 'AUFTRAG_ID;ORDERITEM_INDEX;ARTICLE_CODE;DIMENSION',
            Value2Attr(LineNo, 'LINE_NO'))));
        except
          on E: Exception do
            dmOtto.Notify(aMessageId,
              '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID], Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Ошибка ([ERROR_TEXT])',
              'E',
              XmlAttrs2Attr(ndOrderItem, 'AUFTAG_ID;ORDERITEM_INDEX;ARTICLE_CODE;DIMENSION',
              XmlAttrs2Attr(ndOrder, 'ORDER_CODE',
              Value2Attr(LineNo, 'LINE_NO',
              Value2Attr(E.Message, 'ERROR_TEXT')))));
        end
      end
      else
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID], Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Позиция не найдена в заявке.',
            'E',
            Strings2Attr(sl, 'AUFTAG_ID=7;ORDERITEM_INDEX=8;ARTICLE_CODE=9;DIMENSION=11',
            XmlAttrs2Attr(ndOrder, 'ORDER_CODE;CLIENT_ID;ORDER_ID=ID',
            Value2Attr(LineNo, 'LINE_NO'))));
    end
    else
      dmOtto.Notify(aMessageId,
        '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID], Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Неизвестная заявка.',
        'E',
        Strings2Attr(sl, 'ORDER_CODE=6;AUFTAG_ID=7;ORDERITEM_INDEX=8;ARTICLE_CODE=9;DIMENSION=11',
        Value2Attr(LineNo, 'LINE_NO')));
  finally
    sl.Free;
  end;
end;

procedure ParseArt(aMessageId: Integer; ndMessage: TGvXmlNode; aTransaction: TpFIBTransaction);
var
  LineNo: Integer;
  Lines: TStringList;
  MessageFileName: variant;
  ndProduct, ndOrders: TGvXmlNode;
  Partner_Number: string;
begin
  dmOtto.ClearNotify(aMessageId);
  aTransaction.StartTransaction;
  try
    dmOtto.ObjectGet(ndMessage, aMessageId, aTransaction);
    ndProduct:= ndMessage.FindOrCreate('PRODUCT');
    dmOtto.ObjectGet(ndProduct, dmOtto.DetectProductId(ndMessage, aTransaction), aTransaction);
    Partner_Number := ndProduct['PARTNER_NUMBER'];
    ndOrders:= ndMessage.FindOrCreate('ORDERS');

    MessageFileName:= ndMessage['FILE_NAME'];
    dmOtto.Notify(aMessageId,
      'Начало обработки файла: [FILE_NAME]', '',
      Value2Attr(MessageFileName, 'FILE_NAME'));
    Lines:= TStringList.Create;
    try
      if FileExists(Path['Messages.In']+MessageFileName) then
      begin
        Lines.Text:= LoadFileAsString(Path['Messages.In']+MessageFileName);
        dmOtto.InitProgress(Lines.Count, Format('Ообработка файла %s ...', [MessageFileName]));
        For LineNo:= 0 to Lines.Count - 1 do
        begin
          if trim(Copy(Lines[LineNo], 1, 9)) = Partner_Number then
            ParseArtLine(aMessageId, LineNo, Lines[LineNo], ndProduct, ndOrders, aTransaction);
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

procedure ProcessInfoArt(aMessageId: Integer; aTransaction: TpFIBTransaction);
var
  aXml: TGvXml;
begin
  aXml:= TGvXml.Create('MESSAGE');
  try
    ParseArt(aMessageId, aXml.Root, aTransaction);
  finally
    aXml.Free;
  end;
end;


end.
