library request_xml;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  FastMM4,
  GvStr,
  IdHTTP,
  GvFile,
  NativeXml,
  SysUtils,
  Classes;

{$R *.res}
{$E plg}

function PluginName: WideString; stdcall;
begin
  Result:= 'REQUEST_XML';
end;

function FillParams(st: string; aNode: TXmlNode): string;
var
  i: Integer;
begin
  result:= st;
  For i:= 0 to aNode.AttributeCount - 1  do
    Result:= ReplaceAll(Result, '['+aNode.AttributeName[i]+']', aNode.AttributeValue[i]);
end;

procedure FillProxy(HTTP: TIdHttp);
var
  sl: TStringList;
begin
  Sl:= TStringList.Create;
  try
    try
      sl.Text:= ReadIniSection(ProjectIniFileName, 'Proxy_'+GetUserFromWindows);
      if sl.Text <> '' then
      begin
        HTTP.ProxyParams.ProxyServer:= Sl.Values['Host'];
        HTTP.ProxyParams.ProxyPort:= StrToInt(sl.Values['Port']);
      end;
    except
    end;
  finally
    sl.Free;
  end;
end;

function HttpRequest(URL, RootNodeName: string): WideString;
var
  Http: TIdHTTP;
  Html, St: string;
begin
  Http:= TIdHTTP.Create;
  try
    FillProxy(Http);
    Html:= Http.Get(Url);
  finally
    Http.Free;
  end;
  Result:= CopyBE(Html, '<'+RootNodeName, '</'+RootNodeName+'>');
  if Result = '' then
    Result:= CopyBE(Html, '<'+RootNodeName, '/>');
end;

procedure Execute(URL, RootNodeName:WideString; var aParams: WideString); stdcall;
Var
  Xml: TNativeXml;
begin
  Xml:= TNativeXml.Create;
  try
    Xml.ReadFromString(aParams);
    Url:= FillParams(Url, Xml.Root);
    aParams:= HttpRequest(URL, RootNodeName);
  finally
    Xml.Free;
  end;
end;

exports
  PluginName, Execute;
end.

