unit GvSoapClient;

interface

uses
  IdHTTP, Classes, GvXml, Dialogs;

type
  TGvSoapClient = class(TGvXml)
  private
    FIdHttp: TIdHttp;
    FExternalIdHttp: boolean;
    FSoapRequest: TGvXmlNode;
    FRequest: TGvXmlNode;
    FSoapResponse: TGvXmlNode;
    FResponse : TGvXmlNode;
    FProxyServer: String;
    FProxyPort: word;
    function GetRequestMethod: String;
    procedure SetRequestMethod(const Value: String);
    procedure SetIdHttp(const Value: TIdHttp);
    procedure CreateIdHttp;
  public
    constructor Create; overload;virtual;
    constructor Create(aProxyHost: string; aProxyPort: word); overload;virtual;
    procedure Clear;
    procedure Execute(const aURL: String);
    property IdHttp: TIdHttp read FIdHttp write SetIdHttp;
    property Request: TGvXmlNode read FRequest;
    property Method: String read GetRequestMethod write SetRequestMethod;
    property Response: TGvXmlNode read FResponse;
  end;


implementation

uses
  GvFile, GvStr;

{ TGvSoapClient }

procedure TGvSoapClient.Clear;
begin
  Root.Clear;
  Root.NodeName:= 'Soap';
  FSoapRequest:= Root.AddChild('SoapRequest').AddChild('soapenv:Envelope').
       Attribute('xmlns:soapenv', 'http://schemas.xmlsoap.org/soap/envelope/').
       Attribute('xmlns:exam', 'http://example.com/');
  FRequest:= FSoapRequest.AddChild('soapenv:Header').Parent.
        AddChild('soapenv:Body').
          AddChild('exam:');
end;

constructor TGvSoapClient.Create;
begin
  inherited;
  FExternalIdHttp:= false;
  Clear;
end;

constructor TGvSoapClient.Create(aProxyHost: string; aProxyPort: word);
begin
  Create;
  if aProxyHost <> '' then
  begin
    FProxyServer:= aProxyHost;
    FProxyPort:= aProxyPort;
  end;
end;

procedure TGvSoapClient.CreateIdHttp;
begin
  FIdHttp:= TIdHttp.Create(nil);
  FIdHttp.Request.ContentType:= 'text/xml;charset=UTF-8';
  FIdHttp.Request.AcceptEncoding:= 'deflate';
  FIdHttp.Request.Accept:= 'text/xml;charset=UTF-8';
end;

procedure TGvSoapClient.Execute(const aURL: String);
var
  stmRequest, stmResponse: TStringStream;
  strmResponse: TStream;
  Str: String;
  stHeader, stBodyNode, stBody: string;
  i: Integer;
begin
  Root['Url']:= aURL;
  stmRequest:= TStringStream.Create(UTF8Encode(FSoapRequest.WriteToString(true)));
  try
    if FIdHttp = nil then CreateIdHttp;
    if FProxyServer <> '' then
    begin
      FIdHttp.ProxyParams.ProxyServer:= FProxyServer;
      FidHttp.ProxyParams.ProxyPort:= FProxyPort;
    end;
    try
      Str:= FIdHTTP.Post(aURL, stmRequest);
      if Str = '' then
      begin
        SaveToFile('d:\soap.xml');
        ShowMessage('Empty Resposnse');
      end;
    except
      FIdHttp.Request.RawHeaders.SaveToFile('d:\request.txt');
      stmRequest.SaveToFile('d:\request.xml');
    end;
    stHeader:= CopyBe(Str, '<?', '?>');
    if Pos('UTF-8',stHeader) > 0 then
      Str:= UTF8Decode(Str);
    stBodyNode:= CopyBe(Str, '<', 'envelope', '>');
    stBodyNode:= CopyBetween(stBodyNode, '<', ' ');
    stBody:= CopyBE(Str, '<'+stBodyNode+' ', '</'+stBodyNode+'>');
    FSoapResponse:= Root.FindOrCreate('SoapResponse').AddChild('Response');
    FSoapResponse.LoadFromString(stBody);
    FResponse:= FSoapResponse.ChildNodes[0].ChildNodes[0].ChildNodes[0];
  finally
    if not FExternalIdHttp then
    begin
      FIdHttp.Free;
      IdHttp:= nil;
    end;
    stmRequest.Free;
  end;
end;

function TGvSoapClient.GetRequestMethod: String;
begin
  Result:= FRequest.NodeName;
end;

procedure TGvSoapClient.SetIdHttp(const Value: TIdHttp);
begin
  FIdHttp := Value;
  FExternalIdHttp:= Value <> nil;
end;

procedure TGvSoapClient.SetRequestMethod(const Value: String);
begin
  FRequest.NodeName:= Value;
end;

end.
