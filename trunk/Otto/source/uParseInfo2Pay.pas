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
      SetXmlAttr(ndorder, 'INVOICE_DT_0', aOnDate);
      SetXmlAttr(ndOrder, 'BYR2EUR', dmOtto.SettingGet(aTransaction, 'BYR2EUR', aOnDate));
      SetXmlAttr(ndOrder, 'PACKLIST_NO', sl[1]);
      dmOtto.ActionExecute(aTransaction, ndOrder, 'PREPACKED');
      dmOtto.ObjectGet(ndOrder, OrderId, aTransaction);

      Dimension:= dmOtto.Recode('ARTICLE', 'DIMENSION', sl[9]);

      dmOtto.OrderItemsGet(ndOrderItems, OrderId, aTransaction);
      ndOrderItem:= ChildByAttributes(ndOrderItems, 'AUFTRAG_ID;ORDERITEM_INDEX',
        [sl[6], sl[7]]);
      if ndOrderItem <> nil then
      begin
        OrderItemId:= GetXmlAttrValue(ndOrderItem, 'ID');
        if GetXmlAttrValue(ndOrderItem, 'ORDERITEM_INDEX') = null then
          SetXmlAttr(ndOrderItem, 'ORDERITEM_INDEX', sl[7]);
        MergeXmlAttr(ndOrderItem, 'AUFTRAG_ID', sl[6]);

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
              Value2Vars(E.Message, 'ERROR_TEXT')))));
        end;
      end
      else
        dmOtto.Notify(aMessageId,
          '[LINE_NO]. Заявка [ORDER_CODE]. Auftrag [AUFTRAG_ID]. Позиция [ORDERITEM_INDEX]. Артикул [ARTICLE_CODE], Размер [DIMENSION]. Позиция не найдена в заявке [ORDER_CODE].',
          'E',
          Strings2Vars(sl, 'AUFTRAG_ID=6;ORDERITEM_INDEX=7;ARTICLE_CODE=8;DIMENSION=9',
          XmlAttrs2Vars(ndOrder, 'ORDER_CODE',
          Value2Vars(LineNo, 'LINE_NO'))));
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

procedure ParseInfo2Pay(aMessageId: Integer; ndOrders: TXmlNode;
  aTransaction: TpFIBTransaction);
var
  LineNo, ErrorCount: Integer;
  NeedCommit: Boolean;
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
    ErrorCount:= aTransaction.DefaultDatabase.QueryValue(
      'select count(n.notify_id) from notifies n where n.notify_class = ''E'' and n.message_id = :message_id',
      0, [aMessageId], aTransaction);
    dmOtto.MessageRelease(aTransaction, aMessageId);
    NeedCommit:= ErrorCount = 0;
    if not NeedCommit then
      NeedCommit:= MessageDlg(Format('При обработке файла было получено %u ошибок. Принять вносимые изменения с ошибками?',[ErrorCount]), mtConfirmation, mbYesNoCancel, 0) = mrYes;
    if NeedCommit then
    begin
      dmOtto.MessageSuccess(aTransaction, aMessageId);
      aTransaction.Commit;
    end
    else
      aTransaction.Rollback;
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
