unit uExportDealerData;

interface
uses
  Classes, SysUtils, FIBDatabase, pFIBDatabase;

procedure ExportDealerData(aTransaction: TpFIBTransaction);

implementation

uses
  NativeXml, GvNativeXml, udmOtto, GvStr, GvFile, GvDtTm, DateUtils, Dialogs;

function ExportMessageLine(aTransaction: TpFIBTransaction; ndMessage: TXmlNode;
  aNotifyId: integer): string;
var
  ndNotify : TXmlNode;
begin
  ndNotify:= ndMessage.NodeNew('DEALERNOTIFY');
  dmOtto.ObjectGet(ndNotify, aNotifyId, aTransaction);
  result:= GetXmlAttr(ndNotify, 'NOTIFY_TEXT');
  dmOtto.ActionExecute(aTransaction, 'DEALERNOTIFY_UPLOAD', ndNotify);
end;

procedure ExportMessage(aTransaction: TpFIBTransaction; ndDealer, ndMessages: TXmlNode;
  aMessageId: integer);
var
  ndMessage: TXmlNode;
  NotifyList, St, FilePath: string;
  NotifyId : variant;
  sl : TStringList;
begin
  ndMessage:= ndMessages.NodeNew('MESSAGE');
  dmOtto.ObjectGet(ndMessage, aMessageId, aTransaction);
  sl:= TStringList.Create;
  try
    NotifyList:= aTransaction.DefaultDatabase.QueryValueAsStr(
      'select list(dealernotify_id) '+
      'from (select dn.dealernotify_id '+
      '        from dealernotifies dn '+
      '        where dn.message_id = :message_id '+
      '          and dn.dealer_id = :dealer_id '+
      '        order by dn.dealernotify_id)',
      0, [aMessageId, GetXmlAttrValue(ndDealer, 'ID')]);
    while NotifyList <> '' do
    begin
      NotifyId:= TakeFront5(NotifyList, ',');
      sl.Add(St);
    end;
    FilePath:= Path['Dealers']+GetXmlAttr(ndDealer, 'ID')+'\In\';
    ForceDirectories(FilePath);
    sl.SaveToFile(FilePath+GetXmlAttr(ndMessage, 'FILE_NAME'));
  finally
    sl.Free;
  end;
end;

procedure ExportDealer(aTransaction: TpFIBTransaction; ndDealers: TXmlNode;
  aDealerId: integer);
var
  ndDealer, ndMessages: TXmlNode;
  MessageList: string;
  MessageId: Variant;
begin
  ndDealer:= ndDealers.NodeNew('DEALER');
  SetXmlAttr(ndDealer, 'ID', aDealerId);
  ndMessages:= ndDealer.NodeNew('MESSAGES');
  MessageList:= aTransaction.DefaultDatabase.QueryValue(
    'select list(distinct dn.message_id) '+
    'from dealernotifies dn '+
    '  inner join flags2statuses s2f on (s2f.status_id = dn.status_id and s2f.flag_sign = ''NEW'') '+
    'where dn.dealer_id = :dealer_id',
    0, [aDealerId], aTransaction);
  while MessageList <> '' do
  begin
    MessageId:= TakeFront5(MessageList, ',');
    ExportMessage(aTransaction, ndDealer, ndMessages, MessageId);
  end;
end;

procedure ExportDealerData(aTransaction: TpFIBTransaction);
var
  Xml: TNativeXml;
  ndDealers: TXmlNode;
  DealerId: Variant;
  DealerList: string;
begin
  aTransaction.StartTransaction;
  try
    xml:= TNativeXml.CreateName('DEALERS');
    try
      ndDealers:= Xml.Root;
      DealerList:= aTransaction.DefaultDatabase.QueryValue(
        'select list(distinct dn.dealer_id) '+
        'from dealernotifies dn '+
        '  inner join flags2statuses s2f on (s2f.status_id = dn.status_id and s2f.flag_sign = ''NEW'')',
         0, aTransaction);
      while DealerList <> '' do
      begin
        DealerId:= TakeFront5(DealerList, ',');
        ExportDealer(aTransaction, ndDealers, DealerId);
      end;
      dmOtto.ExportCommitRequest(ndDealers, aTransaction);
    finally
      Xml.Free;
    end;
  except
    on E: Exception do
    begin
      aTransaction.Rollback;
      ShowMessage('Ошибка при формировании файлов: '+e.Message);
    end;
  end;

end;

end.
