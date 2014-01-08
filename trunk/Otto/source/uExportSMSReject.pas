unit uExportSMSReject;

interface
uses
  Classes, GvXml, FIBDatabase, pFIBDatabase;

procedure ExportSMS(aTransaction: TpFIBTransaction);

implementation
uses
  GvXmlUtils, udmOtto, GvStr, SysUtils, GvFile, Dialogs;

function ExportNotify(aTransaction: TpFIBTransaction;
  ndClient: TGvXmlNode; ClientNotifyId: Integer): string;
var
  ndNotify: TGvXmlNode;
begin
  ndNotify:= ndClient.AddChild('CLIENTNOTIFY');
  dmOtto.ObjectGet(ndNotify, ClientNotifyId, aTransaction);
  Result:= ndNotify['NOTIFY_TEXT'];
  ndNotify['NEW.STATUS_SIGN']:= 'SENT';
  dmOtto.ActionExecute(aTransaction, 'CLIENTNOTIFY_SEND', ndNotify);
end;

function ExportClient(aTransaction: TpFIBTransaction;
  ndClients: TGvXmlNode; ClientId: Integer): string;
var
  ndClient: TGvXmlNode;
  NotifiesList: String;
  ClientNotifyId: Variant;
begin
  Result:= '';
  ndClient:= ndClients.AddChild('CLIENT');
  dmOtto.ObjectGet(ndClient, ClientId, aTransaction);
  Result:= ndClient['MOBILE_PHONE'];

  NotifiesList:= aTransaction.DefaultDatabase.QueryValue(
    'select list(distinct cn.clientnotify_id) '+
    'from clientnotifies cn '+
    ' inner join statuses s on (s.status_id = cn.status_id and s.status_sign = ''NEW'') '+
    'where cn.deliverytype_sign = ''SMS'' '+
    '  and cn.client_id = :client_id',
    0, [ClientId], aTransaction);
  while NotifiesList <> '' do
  begin
    ClientNotifyId:= TakeFront5(NotifiesList, ',');
    Result:= Result + ';' + ExportNotify(aTransaction, ndClient, ClientNotifyId);
  end;
  Result:= Translit(Result)+#13#10;
end;

procedure ExportSMS(aTransaction: TpFIBTransaction);
var
  ndClients: TGvXmlNode;
  ClientList, FileName: string;
  ClientId: variant;
  SmsText: string;
  Xml: TGvXml;
begin
  SmsText:= '';
  aTransaction.StartTransaction;
  try
    xml:= TGvXml.Create('CLIENTTS');
    try
      ndClients:= Xml.Root;
      ClientList:= aTransaction.DefaultDatabase.QueryValue(
        'select list(distinct cn.client_id) '+
        'from clientnotifies cn '+
        ' inner join statuses s on (s.status_id = cn.status_id and s.status_sign = ''NEW'') '+
        'where cn.deliverytype_sign = ''SMS''',
        0, aTransaction);
      while ClientList <> '' do
      begin
        ClientId := TakeFront5(ClientList, ',');
        SmsText:= SmsText + ExportClient(aTransaction, ndClients, ClientId);
      end;
      if ndClients.NodeCount > 0 then
      begin
        ForceDirectories(Path['SMSReject']);
        FileName:= GetNextFileName(Format('%sSMSReject_%s_%%u.txt',
                   [Path['SMSReject'], FormatDateTime('YYYYMMDD', Date)]), 1);
        SaveStringAsFile(SmsText, FileName);
        dmOtto.CreateAlert('Отправка SMS', Format('Сформирован файл %s', [ExtractFileName(FileName)]), mtInformation, 10000);
      end;
      dmOtto.ExportCommitRequest(ndClients, aTransaction);
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
