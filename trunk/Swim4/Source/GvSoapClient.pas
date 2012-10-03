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
    function GetRequestMethod: String;
    procedure SetRequestMethod(const Value: String);
    procedure SetIdHttp(const Value: TIdHttp);
    procedure CreateIdHttp;
  public
    constructor Create; virtual;
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

procedure TGvSoapClient.CreateIdHttp;
begin
  FIdHttp:= TIdHttp.Create(nil);
  FIdHttp.Request.ContentType:= 'text/xml;charset=UTF-8';
  FIdHttp.Request.AcceptEncoding:= 'gzip,deflate';
  FIdHttp.Request.Accept:= 'text/xml;charset=UTF-8';
end;

procedure TGvSoapClient.Execute(const aURL: String);
var
  Strm: TStringStream;
  strmResponse: TStream;
  StrResponse: String;
  stHeader, stBodyNode, stBody: string;
  i: Integer;
begin
  Strm:= TStringStream.Create(FSoapRequest.WriteToString);
  try
    if FIdHttp = nil then CreateIdHttp;
    StrResponse:= FIdHTTP.Post(aURL, Strm);
    stHeader:= CopyBe(StrResponse, '<?', '?>');
    stBodyNode:= CopyBe(StrResponse, '<', 'envelope', '>');
    stBodyNode:= CopyBetween(stBodyNode, '<', ' ');
    stBody:= CopyBE(StrResponse, '<'+stBodyNode+' ', '</'+stBodyNode+'>');
    FSoapResponse:= Root.FindOrCreate('SoapResponse').AddChild('Response');
    FSoapResponse.LoadFromString(stBody);
    FResponse:= FSoapResponse.ChildNodes[0].ChildNodes[0].ChildNodes[0];
  finally
    if not FExternalIdHttp then
    begin
      FIdHttp.Free;
      IdHttp:= nil;
    end;
    Strm.Free;
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
