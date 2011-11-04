unit uParseProtocol;

interface

uses
  NativeXml, FIBDatabase, pFIBDatabase;

procedure ProcessProtocol(aMessageId: Integer; aTransaction: TpFIBTransaction);

implementation

uses
  Classes, SysUtils, GvStr, udmOtto, pFIBStoredProc, Variants, GvNativeXml,
  Dialogs, Controls, StrUtils;

procedure ParseProtocolLine100(aMessageId, LineNo, DealId: Integer;
  sl: TStringList; ndOrders: TXmlNode; aTransaction: TpFIBTransaction);
var
  ClientId: variant;
  OrderCode: widestring;
  ndOrder, ndClient: TXmlNode;
  StatusSign, StatusName: Variant;
begin
  ClientId:= aTransaction.DefaultDatabase.QueryValue(
    'select c.client_id '+
    'from clients c '+
    'where client_id =:client_id',
    0, [sl[1]], aTransaction);
  if ClientId <> null then
  begin
//      dmOtto.ActionExecute(aTransaction, ndOrder, DealId, 'ACCEPTED');
    dmOtto.Notify(aMessageId,
      '[LINE_NO]. ������ [CLIENT_ID]. [RESOLUTION]',
      'I',
      Value2Vars(LineNo, 'LINE_NO',
      Strings2Vars(sl, 'CLIENT_ID=1;RESOLUTION=13')));
  end
  else
    dmOtto.Notify(aMessageId,
      '[LINE_NO]. ������ [CLIENT_ID] �� ������.',
      'E',
      Value2Vars(LineNo, 'LINE_NO',
      Strings2Vars(sl, 'CLIENT_ID=1')));
end;

procedure ParseProtocolLine200(aMessageId, LineNo, DealId: Integer;
  sl: TStringList; ndOrders: TXmlNode; aTransaction: TpFIBTransaction);
var
  ClientId, OrderId: Variant;
  ndOrder, ndOrderItems, ndOrderItem: TXmlNode;
  StateSign, StateId, StatusName: variant;
  NewDeliveryMessage, Dimension: string;
begin
  ClientId:= sl[1];
  OrderId:= aTransaction.DefaultDatabase.QueryValue(
    'select o.order_id '+
    'from orders o '+
    'where o.order_code like ''_''||:order_code and o.client_id = :client_id',
    0, [FilterString(sl[2], '0123456789'), ClientId], aTransaction);
  if OrderId <> null then
  begin
    ndOrder:= ndOrders.NodeByAttributeValue('ORDER', 'ID', OrderId);
    if ndOrder = nil then
    begin
      ndOrder:= ndOrders.NodeNew('ORDER');
      ndOrderItems:= ndOrder.NodeNew('ORDERITEMS');
      dmOtto.ObjectGet(ndOrder, OrderId, aTransaction);
      dmOtto.OrderItemsGet(ndOrderItems, OrderId, aTransaction);
    end;

    if XmlAttrIn(ndOrder, 'STATUS_SIGN', 'ACCEPTREQUEST') then
      ndOrder.ValueAsBool:= True;

    Dimension:= dmOtto.Recode('ARTICLE', 'DIMENSION', sl[6]);

    ndOrderItem:= ChildByAttributes(ndOrder.NodeByName('ORDERITEMS'), 'ORDERITEM_INDEX;ARTICLE_CODE;DIMENSION',
      ['', sl[5], Dimension]);

    if ndOrderItem <> nil then
    begin
      if XmlAttrIn(ndOrderItem, 'STATUS_SIGN', 'ACCEPTREQUEST') then
      begin
        SetXmlAttr(ndOrderItem, 'ORDERITEM_INDEX', sl[4]);
        SetXmlAttrAsMoney(ndOrderItem, 'PRICE_EUR', sl[8]);

        if GetXmlAttrAsMoney(ndOrderItem, 'PRICE_EUR') <> GetXmlAttrAsMoney(ndOrderItem, 'COST_EUR') then
        begin
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. ������ [CLIENT_ID]. ������ [ORDER_CODE]. ������� [ORDERITEM_INDEX]. ������� [ARTICLE_CODE], ������ [DIMENSION]. ������� ���� [COST_EUR] => [PRICE_EUR].',
            IfThen(GetXmlAttrValue(ndOrderItem, 'MAGAZINE_ID') = 1, 'W', 'E'),
            XmlAttrs2Vars(ndOrderItem, 'ORDERITEM_INDEX;ORDERITEM_ID=ID;ORDER_ID;ARTICLE_CODE;DIMENSION;PRICE_EUR;COST_EUR',
            XmlAttrs2Vars(ndOrder, 'CLIENT_ID;ORDER_CODE',
            Value2Vars(LineNo, 'LINE_NO'))));
        end;

        StateSign:= dmOtto.Recode('ARTICLE', 'DELIVERY_CODE_TIME', sl[9]+sl[10]);
        if StateSign = sl[9]+sl[10] then
        begin
          StateId:= GetXmlAttrValue(ndOrderItem, 'STATE_ID');
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. ������ [CLIENT_ID]. ������ [ORDER_CODE]. ������� [ORDERITEM_INDEX]. ������� [ARTICLE_CODE], ������ [DIMENSION]. ����������� ���������� DeliveryCode = [DELIVERY_CODE], DeliveryTime = [DELIVERY_TIME]',
            'E',
            XmlAttrs2Vars(ndOrderItem, 'ORDERITEM_INDEX;ORDERITEM_ID=ID;ORDER_ID;ARTICLE_CODE;DIMENSION',
            XmlAttrs2Vars(ndOrder, 'ORDER_CODE;CLIENT_ID',
            Value2Vars(LineNo, 'LINE_NO',
            Strings2Vars(sl, 'DELIVERY_CODE=9;DELIVERY_TIME=10')))));
        end
        else
          StateId:= dmOtto.GetStatusBySign('ARTICLE', StateSign);
        NewDeliveryMessage:= dmOtto.Recode('ARTICLE', 'DELIVERY_MESSAGE', sl[11]);
        if NewDeliveryMessage <> sl[11] then
          StateId:= dmOtto.GetStatusBySign('ARTICLE', NewDeliveryMessage);
        SetXmlAttr(ndOrderItem, 'STATE_ID', StateId);

        if Pos(',AVAILABLE,', dmOtto.GetFlagListById(StateId)) = 0 then
          SetXmlAttr(ndOrderItem, 'NEW.STATUS_SIGN', 'REJECTED')
        else
          SetXmlAttr(ndOrderItem, 'NEW.STATUS_SIGN', 'ACCEPTED');

        try
          StatusName:= aTransaction.DefaultDatabase.QueryValue(
            'select status_name from statuses where object_sign=''ORDERITEM'' and status_sign = :status_sign',
            0, [GetXmlAttrValue(ndOrderItem, 'NEW.STATUS_SIGN')]);
          ndOrderItem.ValueAsBool:= True;
          dmOtto.ActionExecute(aTransaction, ndOrderItem, DealId);
          dmOtto.Notify(aMessageId,
            '[LINE_NO]. ������ [CLIENT_ID]. ������ [ORDER_CODE]. ������� [ORDERITEM_INDEX]. ������� [ARTICLE_CODE], ������ [DIMENSION]. [NEW.STATUS_NAME].',
            'I',
            Strings2Vars(sl, 'ORDERITEM_INDEX=4;ARTICLE_CODE=5;DIMENSION=6',
            XmlAttrs2Vars(ndOrder, 'ORDER_CODE;CLIENT_ID',
            Value2Vars(LineNo, 'LINE_NO',
            Value2Vars(StatusName, 'NEW.STATUS_NAME')))));
        except
          on E: Exception do
            dmOtto.Notify(aMessageId,
              '[LINE_NO]. ������ [CLIENT_ID]. ������ [ORDER_CODE]. ������� [ORDERITEM_INDEX]. ������� [ARTICLE_CODE], ������ [DIMENSION]. ������ ([ERROR_TEXT])',
              'E',
              XmlAttrs2Vars(ndOrderItem, 'ORDERITEM_INDEX;ORDERITEM_ID=ID;ORDER_ID;ARTICLE_CODE;DIMENSION',
              XmlAttrs2Vars(ndOrder, 'ORDER_CODE;CLIENT_ID',
              Value2Vars(LineNo, 'LINE_NO',
              Value2Vars(E.Message, 'ERROR_TEXT')))));
        end;
      end
      else
      begin
        StatusName:= aTransaction.DefaultDatabase.QueryValue(
          'select status_name from statuses where status_id = :status_id',
          0, [GetXmlAttrValue(ndOrder, 'STATUS_ID')]);
        dmOtto.Notify(aMessageId,
          '[LINE_NO]. ������ [CLIENT_ID]. ������ [ORDER_CODE]. ������� [ORDERITEM_INDEX]. ������� [ARTICLE_CODE], ������ [DIMENSION]. ������� � ������� "[STATUS_NAME]".',
          'W',
          Strings2Vars(sl, 'ORDERITEM_INDEX=4;ARTICLE_CODE=5;DIMENSION=6',
          XmlAttrs2Vars(ndOrder, 'ORDER_CODE;CLIENT_ID',
          Value2Vars(LineNo, 'LINE_NO',
          Value2Vars(StatusName, 'STATUS_NAME')))));
      end
    end
    else
      dmOtto.Notify(aMessageId,
          '[LINE_NO]. ������ [CLIENT_ID]. ������ [ORDER_CODE]. ������� [ORDERITEM_INDEX]. ������� [ARTICLE_CODE], ������ [DIMENSION]. ������� �� ������� � ������ [ORDER_CODE].',
          'E', Strings2Vars(sl, 'ORDERITEM_INDEX=4;ARTICLE_CODE=5;DIMENSION=6',
               XmlAttrs2Vars(ndOrder, 'ORDER_CODE;ORDER_ID=ID;CLIENT_ID',
               Value2Vars(LineNo, 'LINE_NO'))));
  end
  else
    dmOtto.Notify(aMessageId,
      '[LINE_NO]. ������ [CLIENT_ID]. ������� [ORDERITEM_INDEX]. ������� [ARTICLE_CODE], ������ [DIMENSION]. ����������� ������ [OTTO_ORDER_CODE].',
      'E',
      Strings2Vars(sl, 'CLIENT_ID=1;ORDERITEM_INDEX=4;ARTICLE_CODE=5;DIMENSION=6;OTTO_ORDER_CODE=2',
      Value2Vars(LineNo, 'LINE_NO')));
end;

procedure ParseProtocolLine(aMessageId, LineNo, DealId: Integer; aLine: string; ndOrders: TXmlNode; aTransaction: TpFIBTransaction);
var
  sl: TStringList;
begin
  sl:= TStringList.Create;
  try
    try
      sl.Delimiter:= ';';
      sl.DelimitedText:= '"'+ReplaceAll(aLine, ';', '";"')+'"';
      if sl[2] = '100' then
        ParseProtocolLine100(aMessageId, LineNo, DealId, sl, ndOrders, aTransaction)
      else
        ParseProtocolLine200(aMessageId, LineNo, DealId, sl, ndOrders, aTransaction);
    except
      on E: Exception do
      dmOtto.Notify(aMessageId,
        '[LINE_NO]. [ERROR_TEXT]',
        'E',
        Value2Vars(LineNo, 'LINE_NO',
        Value2Vars(e.Message, 'ERROR_TEXT')));
    end;
  finally
    sl.Free;
  end;
end;

procedure ParseProtocol(aMessageId: Integer; ndOrders: TXmlNode; aTransaction: TpFIBTransaction);
var
  LineNo, DealId, n: Integer;
  Lines: TStringList;
  MessageFileName: variant;
  ndOrder, ndOrderItems: TXmlNode;
begin
  dmOtto.ClearNotify(aMessageId);
  MessageFileName:= dmOtto.dbOtto.QueryValue(
    'select m.file_name from messages m where m.message_id = :message_id', 0,
    [aMessageId]);
  dmOtto.Notify(aMessageId, '������ ��������� �����: [FILE_NAME]', 'I',
    Value2Vars(MessageFileName, 'FILE_NAME'));
  // ��������� ����
  DealId:= dmOtto.CreateDeal(aTransaction);
  Lines:= TStringList.Create;
  try
    Lines.LoadFromFile(Path['Messages.In']+MessageFileName);
    ndOrder:= ndOrders.NodeNew('ORDER');
    For LineNo:= 0 to Lines.Count - 1 do
      ParseProtocolLine(aMessageId, LineNo, DealId, Lines[LineNo], ndOrders, aTransaction);
    For n:= 0 to ndOrders.NodeCount - 1 do
    begin
      ndOrder:= ndOrders[n];
      if XmlAttrIn(ndOrder, 'STATUS_SIGN', 'ACCEPTREQUEST') then
        dmOtto.ActionExecute(aTransaction, ndOrder, 0, 'ACCEPTED');
    end;
  finally
    Lines.Free;
  end;
  dmOtto.Notify(aMessageId,
    '����� ��������� �����: [FILE_NAME]', 'I',
    Value2Vars(MessageFileName, 'FILE_NAME'));
//  try
//    dmOtto.ActionExecute(aTransaction, 'EVENT', '',
//      Value2Vars('FORM_PROTOCOL', 'EVENT_SIGN',
//      Value2Vars(aMessageId, 'OBJECT_ID')), DealId);
//  except
//    on E: Exception do
//      dmOtto.Notify(aMessageId,
//        '������� ������� FORM_PROTOCOL. ������ ([ERROR_TEXT])',
//        'E',
//        Value2Vars(E.Message, 'ERROR_TEXT'));
//  end;
end;

procedure ProcessProtocol(aMessageId: Integer; aTransaction: TpFIBTransaction);
var
  aXml: TNativeXml;
begin
  aXml:= TNativeXml.CreateName('MESSAGE');
  SetXmlAttr(aXml.Root, 'MESSAGE_ID', aMessageId);
  try
    if not aTransaction.Active then
      aTransaction.StartTransaction;
    try
      ParseProtocol(aMessageId, aXml.Root, aTransaction);
//      dmOtto.MessageRelease(aTransaction, aMessageId);
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