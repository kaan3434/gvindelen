unit GvWebScript;

interface

uses
  SysUtils, Classes, Controls, ExtCtrls, ShDocVw, GvVars, NativeXML, ComCtrls,
  Forms, MSHTML, ActiveX, IdHTTP, IdSSLOpenSSL, IdComponent, IdCookieManager;

type
  TWebScriptStopAction = (saNone, saEndWait, saStopScript);

  TOnUserCmdForDocument = procedure(Sender: TObject; ScriptNode: TXmlNode; HtmlDocument: IHTMLDocument2; Vars: TVarList) of object;
  TOnUserCmdForElement = procedure(Sender: TObject; ScriptNode: TXmlNode; HtmlElement: IHTMLElement; Vars: TVarList) of object;

  TGvWebScript = class(TComponent)
  private
    { Private declarations }
    FWaitDocument: String;
    FWaitHref: String;
    FScript: TNativeXML;
    FScriptRoot: TXmlNode;
    FWebBrowser: TWebBrowser;
    FScriptFileName: TFileName;
    FGotoLabelName: String;
    FStatusBar: TStatusBar;
    FProgressBar: TProgressBar;
    FOnUserCmdForDocument: TOnUserCmdForDocument;
    FOnUserCmdForElement: TOnUserCmdForElement;
    FProxyHost: string;
    FProxyPort: Word;
    procedure DocumentComplete(Sender: TObject; const pDisp: IDispatch;
      var URL: OleVariant);
    procedure SetWebBrowser(const Value: TWebBrowser);
    procedure ProcessSleep(ScriptNode: TXmlNode);
    procedure Process_Download(ScriptNode: TXmlNode);
    procedure Process_Load(ScriptNode: TXmlNode);
    procedure Process_MassDownload(ScriptNode: TxmlNode);
    procedure Process_ShowComment(ScriptNode: TXmlNode);
    function Process_Include(ScriptNode: TXmlNode): Boolean;
    function ApplyVars(St: String): String;
    function RunScriptNode(ScriptNode: TXmlNode; StartIndex: Integer = 0): String;
  protected
    { Protected declarations }
    FDownloadComplete: Boolean;
    procedure RunScript(EntryName: String='');
    procedure ExtractHostPage(URL: String; var Host, Page: String);
    procedure SaveElement(ScriptNode: TXmlNode; Element: IHTMLElement);
    procedure SetVarValue(ScriptNode: TXmlNode);
    function  FindElement(ScriptNode: TXmlNode; Element: IHTMLElement; var Index: Integer): IHTMLElement;
    function  ProcessIf(ScriptNode: TXmlNode): Boolean;
    function  GetFrameByName(HTMLDocument: IHTMLDocument2; aFrameName: string): IHTMLDocument2;
    procedure ProcessElement(ScriptNode: TXmlNode; Element: IHTMLElement);
    procedure ProcessDocument(ScriptNode: TXmlNode; HTMLDocument: IHTMLDocument2);
    procedure ProcessWait;

    function RunEvent(EventName, Html: String): String;
  public
    { Public declarations }
    Vars: TVarList;
    StopAction: TWebScriptStopAction;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Run(EntryName: String='');
    property ndScript: TXmlNode read FScriptRoot;
  published
    { Published declarations }
    property WebBrowser: TWebBrowser read FWebBrowser write SetWebBrowser;
    property ScriptFileName: TFileName read FScriptFileName write FScriptFileName;
    property StatusBar: TStatusBar read FStatusBar write FStatusBar;
    property ProgressBar: TProgressBar read FProgressBar write FProgressBar;
    property ProxyHost: string read FProxyHost write FProxyHost;
    property ProxyPort: Word read FProxyPort write FProxyPort;
    property OnUserCmdForDocument: TOnUserCmdForDocument read FOnUserCmdForDocument write FOnUserCmdForDocument;
    property OnUserCmdForElement: TOnUserCmdForElement read FOnUserCmdForElement write FOnUserCmdForElement;
  end;

procedure Register;

implementation

uses
  GvFile, GvStr, Dialogs, Variants, Math, GvHtmlScript, DateUtils, IdURI,
  IdCookie;

const
  ampCR = '&CR;';
  ampLF = '&LF;';

procedure Register;
begin
  RegisterComponents('Gvindelen', [TGvWebScript]);
end;

{ TGvWebScript }

constructor TGvWebScript.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FScript:= TNativeXml.CreateName('Root');
  FScriptRoot:= FScript.Root;
  Vars:= TVarList.Create;
end;

destructor TGvWebScript.Destroy;
begin
  Vars.Free;
  FScript.Free;
  inherited Destroy;
end;

function TGvWebScript.ApplyVars(St: String): String;
var
  i: Integer;
  VarName: String;
begin
  For i:= 0 to Vars.Count-1 do
  begin
    VarName:= Vars.Names[i];
    St:= ReplaceAll(St, '['+VarName+']', Vars[VarName]);
  end;
  result:= St;
end;

procedure TGvWebScript.Run(EntryName: String='');
var
  St: String;
  OldStatusMessage: String;
  OldStatusSimplePanel: Boolean;
begin
  if assigned(FStatusBar) then
  begin
    OldStatusMessage:= FStatusBar.SimpleText;
    OldStatusSimplePanel:= FStatusBar.SimplePanel;
    FStatusBar.SimplePanel:= true;
  end;
  St:= LoadFileAsString(ScriptFileName);
  FScript.ReadFromString(ApplyVars(St));
  FScriptRoot:= FScript.Root;
  StopAction:= saNone;
  RunScript(EntryName);
  if Assigned(FStatusBar) then
  begin
    FStatusBar.SimplePanel:= OldStatusSimplePanel;
    FStatusBar.SimpleText:= OldStatusMessage;
  end;
end;

function TGvWebScript.FindElement(ScriptNode: TXmlNode; Element: IHTMLElement; var Index: Integer): IHTMLElement;
var
  Tags: IHTMLElementCollection; // all tags in document body
  Tag: IHTMLElement;            // a tag in document body
  Input: IHTMLInputElement;
  I, A, Idx, FoundedIdx: Integer;  // loops thru tags in document body
  St, html: String;
  Founded: Boolean;
  Attributes: TVarList;
  AttName, AttValue: String;
  Element2: IHTMLElement2;
begin
  Result := nil;
  Element2:= Element as IHTMLElement2;
  // Get all tags in body element ('*' => any tag name)
  Tags := Element2.getElementsByTagName(ScriptNode.ReadAttributeString('TAG', '*'));
 // Scan through all tags in body
  Attributes:= TVarList.Create;
  Idx:= Index;
  FoundedIdx:= 0;
  try
    for I := Idx to Pred(Tags.length) do
    begin
      Tag := Tags.item(I, EmptyParam) as IHTMLElement;
      try
        Html:= Tag.outerHTML;
        St:= Trim(CopyFront4(Html, '>'));
        TakeFront4(St, ' >');
        While St<>'' do
        begin
          AttName:= TakeAttName(St);
          AttValue:= TakeAttValue(St);
          Attributes[AttName]:= AttValue;
        end;
        Founded:= true;
        For A:= 0 to ScriptNode.AttributeCount - 1 do
        begin
          AttName:= UpperCase(ScriptNode.AttributeName[A]);
          AttValue:= ScriptNode.ReadAttributeString(AttName);
          if (AttName = 'TAG') or
             (AttName = 'OPTIONAL') or
             (AttName='FOUNDEDINDEX') or
             (AttName='OFFSET') then
          else
          if AttName = 'INDEX' then
            Founded:= ScriptNode.ReadAttributeInteger(AttName)=i
          else
          if AttName = 'TEXT' then
            Founded:= Tag.innerText=AttValue
          else
          if AttName = 'CHECKED' then
          begin
            input:= Tag as IHTMLInputElement;
            Founded:= input.Checked = StrToBool(AttValue);
          end
          else
            Founded:= Attributes[AttName] = AttValue;
          if Founded = false then break;
        end;
        if Founded = false then continue;

      finally
        Inc(Index);
        Attributes.Clear;
      end;
      if Founded then
      begin
        Inc(FoundedIdx);
        if FoundedIdx<>ScriptNode.ReadAttributeInteger('FoundedIndex',1) then
          continue;
        Result := Tag;
        if ScriptNode.ReadAttributeInteger('Offset')<>0 then
          Result:= Tags.item(I+ScriptNode.ReadAttributeInteger('Offset'), EmptyParam) as IHTMLElement;

        Break;
      end;
    end;
  finally
    Attributes.Free;
  end;
end;

function TGvWebScript.GetFrameByName(HTMLDocument: IHTMLDocument2; aFrameName: string): IHTMLDocument2;
var
  searchdoc : IHTMLDocument2; // temporarily holds the resulting page
  FoundIt : boolean; // Flag if we found the right Frame

  // This is the inner recursive portion of the function
function Enum(AHTMLDocument:IHTMLDocument2; aFrameName:string):boolean;
var
   OleContainer: IOleContainer;
   EnumUnknown: IEnumUnknown;
   Unknown: IUnknown;
   Fetched: LongInt;
   WebBrowser: IWebBrowser;
   FBase     : IHTMLFrameBase;
begin
   Result:=True;
   if not Assigned(AHtmlDocument) then Exit;
   if not Supports(AHtmlDocument, IOleContainer, OleContainer) then Exit;
   if Failed(OleContainer.EnumObjects(OLECONTF_EMBEDDINGS, EnumUnknown)) then
   Exit;

   while (EnumUnknown.Next(1, Unknown, @Fetched)=S_OK) do
   begin
     if Supports(Unknown, IHTMLFrameBase,FBase) then
     begin
       // Here we ask if we have the right Frame
       if LowerCase(FBase.name) = LowerCase(aFrameName) then
       begin
         if Supports(Unknown, IWebBrowser, WebBrowser) then
         begin
           searchdoc := (WebBrowser.Document as IHTMLDocument2);
           FoundIt:=true;
           exit;
         end;
       end;
     end;
     if NOT (FoundIt) then
     begin
       if Supports(Unknown, IWebBrowser, WebBrowser) then
       begin
         Result:=Enum((WebBrowser.Document as IHtmlDocument2),aFrameName);
         if not Result then Exit;
       end;
     end else exit;
   end;
end;

begin
  FoundIt := false;
  result := nil; // just in case
  Enum(HTMLDocument, aFrameName);
  if FoundIt then
    result := searchdoc
  else
    result := nil;
end;

procedure TGvWebScript.SaveElement(ScriptNode: TXmlNode; Element: IHTMLElement);
var
  Html: String;
begin
  if Element = nil then exit;
  if ScriptNode.ReadAttributeInteger('Outer') = 1 then
    Html:= Element.outerHTML
  else
    Html:= Element.innerHTML;
  if ScriptNode.ReadAttributeInteger('UTF8ToAnsi',0) = 1 then
    html:= GvUtf8ToAnsi(Html);
  Html:= RunEvent(ScriptNode.ReadAttributeString('Event'), Html);
  SaveStringAsFile(Html, ScriptNode.ReadAttributeString('FileName'),
                   ScriptNode.ReadAttributeBool('Append'));
end;

procedure TGvWebScript.SetVarValue(ScriptNode: TXmlNode);
var
  VarName: String;
begin
  VarName:= ScriptNode.ReadAttributeString('Name');
  if ScriptNode.ReadAttributeString('Inc')<>'' then
    Vars.AsInteger[VarName]:= Vars.AsInteger[VarName] + ScriptNode.ReadAttributeInteger('Inc')
  else
  if ScriptNode.ReadAttributeString('VarValue')<>'' then
    Vars[VarName]:= Vars[ScriptNode.ReadAttributeString('VarValue')]
  else
    Vars[VarName]:= ScriptNode.ReadAttributeString('Value');
end;

function TGvWebScript.ProcessIf(ScriptNode: TXmlNode): Boolean;
var
  VarName, VarValue, Action: String;
begin
  VarName:= ScriptNode.ReadAttributeString('Name');
  if ScriptNode.ReadAttributeString('VarValue')<>'' then
    VarValue:= ScriptNode.ReadAttributeString('VarValue')
  else
    VarValue:= ScriptNode.ReadAttributeString('Value');
  Action:= ScriptNode.ReadAttributeString('Action', 'EQ');
  if Action = 'SEQ' then
    result:= Vars[VarName] = VarValue
  else
  if Action = 'SNE' then
    result:= Vars[VarName] <> VarValue
  else
  if Action = 'EQ' then
    result:= Vars.AsInteger[VarName] = StrToInt(VarValue)
  else
  if Action = 'LT' then
    result:= Vars.AsInteger[VarName] < StrToInt(VarValue)
  else
  if Action = 'LE' then
    result:= Vars.AsInteger[VarName] <= StrToInt(VarValue)
  else
  if Action = 'GE' then
    result:= Vars.AsInteger[VarName] >= StrToInt(VarValue)
  else
  if Action = 'GT' then
    result:= Vars.AsInteger[VarName] > StrToInt(VarValue)
  else
  if Action = 'NE' then
    result:= Vars.AsInteger[VarName] <> StrToInt(VarValue);
end;

procedure TGvWebScript.ProcessElement(ScriptNode: TXmlNode; Element: IHTMLElement);
var
  ChildNode: TXmlNode;
  SubElement: IHTMLElement;
  Element2: IHTMLElement2;
  SelElement: IHTMLSelectElement;
  InpElement: IHTMLInputElement;
  Name: String;
  i, Idx: Integer;
begin
  Element2:= Element as IHTMLElement2;
  For i:= 0 to ScriptNode.NodeCount-1 do
  begin
    ChildNode:= ScriptNode[i];
    Name:= UpperCase(ChildNode.Name);
    if Name = 'WAIT' then
      Sleep(ChildNode.ReadAttributeInteger('Value', 1000))
    else
    if Name = 'FINDELEMENT' then
    begin
      Idx:= 0;
      SubElement:= FindElement(ChildNode, Element, Idx);
      if Assigned(SubElement) then
        ProcessElement(ChildNode, SubElement)
      else
      if ChildNode.ReadAttributeInteger('Optional', 0) = 0 then
        ShowMessage('Element Not Found');
    end
    else
    if Name = 'CLICK' then
    begin
      FDownloadComplete:= ChildNode.AttributeCount=0;
      FWaitDocument:= ChildNode.ReadAttributeString('WaitName');
      Element.click;
      Sleep(500);
      ProcessWait;
    end
    else
    if Name = 'INPUT' then
    begin
      InpElement:= Element as IHTMLInputElement;
      InpElement.value:= ChildNode.ValueAsString;
    end
    else
    if Name = 'SETOPTION' then
    begin
      SelElement:= Element as IHTMLSelectElement;
      if ChildNode.ReadAttributeString('Value')<>'' then
        SelElement.value:= ChildNode.ReadAttributeString('Value')
      else
      if ChildNode.ReadAttributeString('Index')<>'' then
        SelElement.selectedIndex:= ChildNode.ReadAttributeInteger('Index');
    end
    else
    if Name='SETATTRIBUTE' then
      Element.setAttribute(ChildNode.AttributeByName['AttName'],
                           ChildNode.AttributeByName['Value'], 0)
    else
    if Name = 'SAVE' then
      SaveElement(ChildNode, Element)
    else
    if Name = 'SETVARVALUE' then
      SetVarValue(ChildNode)
    else
    if Name = 'GOTO' then
      FGotoLabelName:= ChildNode.ReadAttributeString('Label')
    else
    if Assigned(FOnUserCmdForElement) then
      FOnUserCmdForElement(Self, ChildNode, Element, Vars);
    Application.ProcessMessages;
    if FGotoLabelName<>'' then Break;
  end;
end;

procedure TGvWebScript.ProcessDocument(ScriptNode: TXmlNode; HTMLDocument: IHTMLDocument2);
var
  ChildNode: TXmlNode;
  Element: IHTMLElement;
  Name: String;
  i, Idx: Integer;
begin
//  if HTMLDocument = nil then Exit;
  For i:= 0 to ScriptNode.NodeCount-1 do
  begin
    ChildNode:= ScriptNode[i];
    Name:= UpperCase(ChildNode.Name);
    if Name = 'FRAME' then
      ProcessDocument(ChildNode, GetFrameByName(HTMLDocument, ChildNode.ReadAttributeString('Name')))
    else
    if Name = 'SAVE' then
      SaveElement(ChildNode, HTMLDocument.body)
    else
    if Name = 'SETVARVALUE' then
      SetVarValue(ChildNode)
    else
    if Name = 'IF' then
    begin
      if ProcessIf(ChildNode) then
        ProcessDocument(ChildNode, HTMLDocument);
    end
    else
    if Name = 'FINDELEMENT' then
    begin
      Idx:= 0;
      Element:= FindElement(ChildNode, HTMLDocument.Body, Idx);
      if Assigned(Element) then
        ProcessElement(ChildNode, Element)
      else
      if ChildNode.ReadAttributeInteger('Optional', 0) = 0 then
        ShowMessage('Element Not Found');
      //
    end
    else
    if Name = 'GOTO' then
      FGotoLabelName:= ChildNode.ReadAttributeString('Label')
    else
    if Assigned(FOnUserCmdForDocument) then
      FOnUserCmdForDocument(Self, ChildNode, IHTMLDocument2(WebBrowser.Document), Vars);
    Application.ProcessMessages;
    if FGotoLabelName<>'' then Break;
  end;
end;

procedure TGvWebScript.ProcessSleep(ScriptNode: TXmlNode);
var
  EndWait: TDateTime;
begin
  EndWait:= IncSecond(Now, ScriptNode.ReadAttributeInteger('Second'));
  While Now < EndWait do
  begin
    Sleep(25);
    if StatusBar <> nil then
      StatusBar.SimpleText:= Format('Wait: %d', [SecondOf(EndWait-Now)]);
    Application.ProcessMessages;
  end;
end;

procedure TGvWebScript.Process_Download(ScriptNode: TXmlNode);
var
  HTTP: TIdHTTP;
  i, idx: Integer;
  Html, CmdName, PrmName, PrmValue, LURL, Referer,
  CookieFName, CookName, CookValue, St: String;
  LURI: TIdURI;
  Cookie: TIdCookieManager;
  SSL: IdSSLOpenSSL.TIdSSLIOHandlerSocketOpenSSL;
  ChildNode: TXmlNode;
  slParams, slCookie, slNewCookie, slHeader: TStringList;
  HtmlStream: TStringStream;
begin
  LURI:= TIdURI.Create(ScriptNode.ReadAttributeString('Href'));
  slCookie:= TStringList.Create;
  slNewCookie:= TStringList.Create;
  slParams:= TStringList.Create;
  slHeader:= TStringList.Create;
  slParams.Delimiter:= '&';
  slParams.QuoteChar:= ' ';
  slParams.DelimitedText:= LURI.Params;
  slParams.Text:= LURI.URLDecode(slParams.Text);
  try
    For i:= 0 to ScriptNode.NodeCount - 1 do
    begin
      ChildNode:= ScriptNode.Nodes[i];
      CmdName:= UpperCase(ChildNode.Name);
      if CmdName = 'PARAMADD' then
      begin
        if ChildNode.ReadAttributeString('VarValue')<>'' then
          PrmValue:= Vars[ChildNode.ReadAttributeString('VarValue')]
        else
        if ChildNode.ReadAttributeString('ValueFromFile')<>'' then
          PrmValue:= LoadFileAsString(ChildNode.ReadAttributeString('ValueFromFile'))
        else
          PrmValue:= ChildNode.ReadAttributeString('Value');
        slParams.Add(Format('%s=%s', [ChildNode.ReadAttributeString('Name'), PrmValue]));
      end
      else
      if CmdName = 'PARAMDEL' then
      begin
        idx:= slParams.IndexOfName(ChildNode.ReadAttributeString('Name'));
        if idx>=0 then
          slParams.Delete(idx);
      end
      else
      if CmdName = 'PARAMLOAD' then
        slParams.LoadFromFile(ChildNode.ReadAttributeString('FileName'))
      else
      if CmdName = 'SETPARAMVALUE' then
      begin
        idx:= ChildNode.ReadAttributeInteger('Index');
        PrmName:= CopyFront4(slParams[idx], '=');
        if ChildNode.ReadAttributeString('VarValue')<>'' then
          PrmValue:= Vars[ChildNode.ReadAttributeString('VarValue')]
        else
          PrmValue:= ChildNode.ReadAttributeString('Value');
        slParams[idx]:= Format('%s=%s', [PrmName, PrmValue]);
      end
      else
      if CmdName = 'COOKIES' then
      begin
        CookieFName:= ChildNode.ReadAttributeString('FileName');
        if Not FileExists(CookieFName) then
        begin
          slCookie.LoadFromFile(ChildNode.ReadAttributeString('Default'));
          slCookie.SaveToFile(CookieFName);
        end
        else
          slCookie.LoadFromFile(CookieFName);
      end
      else
      if CmdName = 'COOKIEADD' then
      begin
        CookieFName:= ChildNode.ReadAttributeString('FileName');
        if FileExists(CookieFName) then
        begin
          st:= LoadFileAsString(CookieFName);
          if St<>'' then
            slCookie.Add(St);
        end;
      end
      else
      if CmdName = 'COOKIEDEL' then
      begin
        PrmName:= ChildNode.ReadAttributeString('Name');
        idx:= slCookie.IndexOfName(prmName);
        if idx >= 0 then
        begin
          slCookie.Delete(idx);
          slCookie.SaveToFile(CookieFName);
        end;
      end
      else
      if CmdName = 'REFERER' then
      begin
        if ChildNode.ReadAttributeString('VarValue')<>'' then
          Referer:= Vars[ChildNode.ReadAttributeString('VarValue')]
        else
          Referer:= ChildNode.ReadAttributeString('Value');
      end
      else
      if CmdName = 'HEADERADD' then
      begin
        PrmName:= ChildNode.ReadAttributeString('Name');
        PrmValue:= ChildNode.ReadAttributeString('Value');
        slHeader.Values[PrmName]:= PrmValue;
      end;
    end;
    LURI.Params:= LURI.ParamsEncode(slParams.DelimitedText);
    HTTP:= TIdHTTP.Create(nil);
    HTTP.ProxyParams.ProxyServer:= FProxyHost;
    HTTP.ProxyParams.ProxyPort:= FProxyPort;
    HTTP.HandleRedirects:= true;
    Cookie:= TIdCookieManager.Create(HTTP);
    HTTP.CookieManager:= Cookie;
    HTTP.AllowCookies:= true;
    HTTP.Request.Referer:= Referer;
    SSL:= TIdSSLIOHandlerSocketOpenSSL.Create(HTTP);
    HTTP.IOHandler:= SSL;
    For i:= 0 to slHeader.Count-1 do
      HTTP.Request.RawHeaders.Values[slHeader.Names[i]]:= slHeader.ValueFromIndex[i];
    For i:= 0 to slCookie.Count-1 do
      Cookie.AddServerCookie(slCookie[i], LURI);
    HtmlStream:= TStringStream.Create('');
    try
      if UpperCase(ScriptNode.ReadAttributeString('Method', 'GET')) = 'POST' then
      begin
       LURL:= CopyFront4(LURI.GetFullURI, '?');
       HTTP.Post(LURL, slParams, HtmlStream);
      end
      else
      begin
        LURL:= LURI.GetFullURI;
        HTTP.Get(LURL, HtmlStream);
      end;
      HTTP.Response.RawHeaders.Extract('Set-Cookie', slNewCookie);
      if slNewCookie.Count <> 0 then
      begin
        For i:= 0 to slNewCookie.Count-1 do
        begin
          CookValue:= CopyFront4(slNewCookie[i], ';');
          CookName:= TakeFront5(CookValue, '=');
          slCookie.Values[CookName]:= CookValue;
        end;
        if CookieFName<>'' then
          slCookie.SaveToFile(CookieFName);
      end;
      HtmlStream.Seek(0, 0);
      html:= HtmlStream.DataString;
      if ScriptNode.ReadAttributeInteger('UTF8ToAnsi',0) = 1 then
        html:= Utf8ToAnsi(Html);
      if ScriptNode.ReadAttributeString('Event')<>'' then
        Html:= Run_HtmlScript(ndScript,
                              ScriptNode.ReadAttributeString('Event'), Html,
                              Vars);
      SaveStringAsFile(Html, ScriptNode.ReadAttributeString('FileName'),
                             ScriptNode.ReadAttributeInteger('Append')=1);
    finally
      FreeAndNil(HtmlStream);
      FreeAndNil(SSL);
      FreeAndNil(Cookie);
      FreeAndNil(HTTP);
    end;
  finally
    FreeAndNil(LURI);
    FreeAndNil(slHeader);
    FreeAndNil(slParams);
    FreeAndNil(slNewCookie);
    FreeAndNil(slCookie);
  end;
end;

procedure TGvWebScript.Process_MassDownload(ScriptNode: TxmlNode);
var
  sl: TStringList;
  FName, href: String;
  i: Integer;
begin
  sl:= TStringList.Create;
  try
    FName:= ScriptNode.ReadAttributeString('FileName');
    if FName<>'' then
      sl.LoadFromFile(FName);
    For i:= 0 to sl.Count-1 do
    begin
      href:= trim(sl[i]);
      if href='' then continue;
      ScriptNode[0].WriteAttributeString('href', href);
      Process_Download(ScriptNode[0]);
    end;
  finally
    sl.Free;
  end;
end;

procedure TGvWebScript.Process_Load(ScriptNode: TXmlNode);
var
  Html: String;
begin
  Html:= LoadFileAsString(ScriptNode.ReadAttributeString('href'));
  if ScriptNode.ReadAttributeInteger('UTF8ToAnsi',0) = 1 then
    html:= Utf8ToAnsi(Html);
  if ScriptNode.ReadAttributeString('Event')<>'' then
    Html:= Run_HtmlScript(ndScript,
                          ScriptNode.ReadAttributeString('Event'), Html,
                          Vars);
  SaveStringAsFile(Html, ScriptNode.ReadAttributeString('FileName'),
                         ScriptNode.ReadAttributeInteger('Append')=1);
end;

procedure TGvWebScript.Process_ShowComment(ScriptNode: TXmlNode);
begin
  if StatusBar=nil then exit;
  if StatusBar.SimplePanel then
    StatusBar.SimpleText:= ScriptNode.WriteToString;
end;

function TGvWebScript.Process_Include(ScriptNode: TXmlNode): Boolean;
var
  FName, St: String;
begin
{  FName:= ScriptNode.ReadAttributeString('Name');
  result:= FileExists(FName);
  if result then
  begin
    St:= LoadFileAsString(FName);
    St:= ApplyVars(St);
    try
      ScriptNode.ReadFromString(St);
    except
      result:= false;
    end;
  end;}
  result:= false;
end;

function TGvWebScript.RunScriptNode(ScriptNode: TXmlNode; StartIndex: Integer = 0): String;
var
  ChildNode: TXmlNode;
  CmdName, URL: String;
  i: Integer;
  Flags, TargetFrameName, PostData, Header: OleVariant;

begin
  i:= StartIndex;
  While i<=ScriptNode.NodeCount-1 do
  begin
    Application.ProcessMessages;
    ChildNode:= ScriptNode[i];
    CmdName:= UpperCase(ChildNode.Name);
    if CmdName = 'LABEL' then
    else
    if CmdName = 'NAVIGATE' then
    begin
      Flags:= navNoReadFromCache;
      URL:= ChildNode.ReadAttributeString('Href', 'about:blank');
      TargetFrameName:= ChildNode.ReadAttributeString('Target');
      Header:= ChildNode.ReadAttributeString('Header');
      FDownloadComplete:= false;
      FWaitDocument:= ChildNode.ReadAttributeString('WaitName');
      FWaitHref:= ChildNode.ReadAttributeString('WaitHref');
      FWebBrowser.Navigate(URL, Flags, TargetFrameName, PostData, Header);
      ProcessWait;
    end
    else
    if CmdName = 'DOCUMENT' then
      ProcessDocument(ChildNode, IHTMLDocument2(WebBrowser.Document))
    else
    if CmdName = 'SETVARVALUE' then
      SetVarValue(ChildNode)
    else
    if CmdName = 'IF' then
    begin
      if ProcessIf(ChildNode) then
      begin
        if WebBrowser = nil then
          ProcessDocument(ChildNode, nil)
        else
          ProcessDocument(ChildNode, IHTMLDocument2(WebBrowser.Document));
      end;
    end
    else
    if CmdName = 'GOTO' then
      FGotoLabelName:= ChildNode.ReadAttributeString('Label')
    else
    if CmdName = 'WHILE_DO' then
      while ProcessIf(ChildNode) do
        RunScriptNode(ChildNode)
    else
    if CmdName = 'DO_WHILE' then
      repeat
        RunScriptNode(ChildNode);
      until not ProcessIf(ChildNode)
    else
    if CmdName = 'LOOP' then
      RunScriptNode(ChildNode)
    else
    if CmdName = 'EXIT' then
    begin
      result:= 'EXIT';
      break;
    end
    else
    if CmdName = 'BREAK' then
      break
    else
    if CmdName = 'CONTINUE' then
    begin
      i:= 0;
      Continue;
    end
    else
    if CmdName = 'SLEEP' then
      ProcessSleep(ChildNode)
    else
    if CmdName = 'LOAD' then
      Process_Load(ChildNode)
    else
    if CmdName = 'DOWNLOAD' then
      Process_Download(ChildNode)
    else
    if CmdName = 'MASSDOWNLOAD' then
      Process_MassDownload(ChildNode)
    else
    if CmdName = 'COMMENT' then
      Process_ShowComment(ChildNode)
    else
    if CmdName = 'INCLUDE' then
    begin
      if Process_Include(ChildNode) then
        Continue;
    end
    else
    if Assigned(FOnUserCmdForDocument) then
    begin
      if Assigned(WebBrowser) then
        FOnUserCmdForDocument(Self, ChildNode, IHTMLDocument2(WebBrowser.Document), Vars)
      else
        FOnUserCmdForDocument(Self, ChildNode, nil, Vars)
    end;
    if StopAction = saStopScript then
      break;
    inc(i);
    if FGotoLabelName<>'' then
    begin
      ChildNode:= ScriptNode.NodeByAttributeValue('LABEL', 'Name', FGotoLabelName);
      if ChildNode<>nil then
      begin
        i:= ChildNode.IndexInParent;
        FGotoLabelName:= '';
      end;
    end;
  end;
end;


procedure TGvWebScript.RunScript(EntryName: String='');
var
  RootNode, ChildNode: TXmlNode;
  CmdName, URL: String;
  i: Integer;
  Flags, TargetFrameName, PostData, Header: OleVariant;

begin
  RootNode:= FScript.Root;
  i:= 0;
  if EntryName<>'' then
  begin
    ChildNode:= RootNode.NodeByAttributeValue('LABEL', 'Name', EntryName);
    if ChildNode<>nil then
      i:= ChildNode.IndexInParent;
  end;
  RunScriptNode(RootNode, i);
end;

procedure TGvWebScript.ExtractHostPage(URL: String; var Host, Page: String);
begin
  Page:= CopyFront4(URL, '?');
  Host:= TakeFront3(Page, '/');
  Host:= Host + TakeFront3(Page, '/');
  if LastChar(Host)<>'/' then
    Host:= Host + '/';
  While Pos('/', Page) > 0 do
    Host:= Host + TakeFront3(Page, '/');
  if Page = '' then
    Page := 'index';
end;

procedure TGvWebScript.SetWebBrowser(const Value: TWebBrowser);
begin
  FWebBrowser := Value;
  FWebBrowser.OnDocumentComplete:= DocumentComplete;
end;

procedure TGvWebScript.ProcessWait;
var
  StartWait: TDateTime;
begin
  StartWait:= Now;
  While Not FDownloadComplete do
  begin
    Sleep(25);
    Application.ProcessMessages;
    if Assigned(FStatusBar) then
        FStatusBar.SimpleText:= 'Wait '+ FormatDateTime('HH:NN:SS', Now-StartWait);
    if StopAction = saEndWait then
      break;
    if StopAction = saStopScript then
      raise Exception.CreateFmt('Прервано пользователем', []);
  end;
  StopAction:= saNone;
end;

procedure TGvWebScript.DocumentComplete(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
var
  CurWebBrowser: IWebBrowser;
  Document: OleVariant;
  WindowName: String;
begin
  if FDownloadComplete then Exit;
  CurWebBrowser := pDisp as IWebBrowser;
  if CurWebBrowser.Parent = nil then
    FDownloadComplete:= true
  else
  if FWaitDocument <> '' then
  begin
    Document:= CurWebBrowser.Document;
    WindowName:= Document.ParentWindow.Name;
    FDownloadComplete:= FDownloadComplete or (UpperCase(FWaitDocument) = UpperCase(WindowName));
    if FDownloadComplete then
      FWaitDocument:= '';
  end
  else
  if FWaitHref <> '' then
  begin
    FDownloadComplete:= FDownloadComplete or (LowerCase(URL) = LowerCase(FWaitHref));
    if FDownloadComplete then
      FWaitHref:= '';
  end;
end;

function TGvWebScript.RunEvent(EventName, Html: String): String;
begin
  result:= Html;
  if (EventName = '') or (Html='') then Exit;
  result:= Run_HtmlScript(FScript.Root, EventName, Html, Vars);
end;

end.

