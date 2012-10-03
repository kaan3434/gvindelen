unit GvSoapClient;

interface

uses
  IdHTTP, Classes, GvXml, Dialogs;

function GetData(aURL: String; aRequest: TGvXmlNode; HTTP: TIdHttp): String;


implementation

function GetData(aURL: String; aRequest: TGvXmlNode; HTTP: TIdHttp): String;
var
  Soap: TGvXml;
  XmlRequest: TGvXmlNode;
//  HTTP: TIdHTTP;
  Strm: TStringStream;
  StrResponse: String;
  i: Integer;
begin
  Soap:= TGvXml.Create;
  Soap.Root.NodeName:= 'soapenv:Envelope';
  try
    XmlRequest:= Soap.Root.
          Attribute('xmlns:soapenv', 'http://schemas.xmlsoap.org/soap/envelope/').
          Attribute('xmlns:exam', 'http://example.com/').
        AddChild('soapenv:Header').Parent.
          AddChild('soapenv:Body').
            AddChild('exam:'+aRequest.NodeName);
    XmlRequest.LoadFromString(aRequest.WriteToString);
    XmlRequest.NodeName:= 'exam:'+aRequest.NodeName;
//    HTTP:= TIdHTTP.Create(nil);
    Strm:= TStringStream.Create(Soap.Root.WriteToString);
    try
      HTTP.Request.ContentType:= 'text/xml;charset=UTF-8';
      HTTP.Request.AcceptEncoding:= 'gzip,deflate';
      HTTP.Request.Accept:= 'text/xml;charset=UTF-8';
      HTTP.Request.CustomHeaders.Values['SOAPAction']:= '';
      HTTP.Request.RawHeaders.SaveToFile('d:\Request.txt');
      StrResponse:= HTTP.Post(aURL, Strm);
    finally
      Strm.Free;
//      Http.Free;
    end;
  finally
    Soap.Free;
  end;
end;

end.
