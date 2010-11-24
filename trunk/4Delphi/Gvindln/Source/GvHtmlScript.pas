unit GvHtmlScript;

interface

uses
  SysUtils, Classes, NativeXml, Dialogs, GvVars;

function Run_HtmlScript(Root: TXmlNode; SubScriptName, Html: String; Vars: TVarList): String;

implementation

uses
  GvStr, GvFile, GvHtml, IdUri;

const
  ampCR = '&CR;';
  ampLF = '&LF;';

function Run_HtmlScript(Root: TXmlNode; SubScriptName, Html: String; Vars: TVarList): String;
var
  Stack: TNativeXML;

function Process_Script(ScriptNode: TXMLNode; Html: String): String; forward;


function Process_ControlChar(St: String): String;
begin
  result:= St;
  result:= ReplaceAll(result, ampCR, #$0D, true);
  result:= ReplaceAll(result, ampLF, #$0A, true);
end;

procedure Simple_Store(Name, Html: String);
var
  ndItem: TXmlNode;
begin
  ndItem:= Stack.Root.NodeByAttributeValue('Item', 'Name', Name, false);
  if ndItem = nil then
  begin
    ndItem:= Stack.Root.NodeNew('Item');
    ndItem.WriteAttributeString('Name', Name);
  end;
  ndItem.ValueAsString:= Html;
end;

function Process_Delete(ScriptNode: TXmlNode; Html: string): String;
var
  StartSt, EndSt: String;
  CaseSensitive: Boolean;
begin
  CaseSensitive:= ScriptNode.ReadAttributeBool('CaseSensitive');
  StartSt:= Process_ControlChar(ScriptNode.ReadAttributeString('Start'));
  EndSt:= Process_ControlChar(ScriptNode.ReadAttributeString('End'));
  if StartSt = '' then
    result:= ReplaceBeforeString(html, EndSt, '', CaseSensitive)
  else
  if EndSt = '' then
    result:= ReplaceAfterString(html, StartSt, '', CaseSensitive)
  else
    result:= Html;
end;

function Process_DeleteAll(ScriptNode: TXmlNode; Html: string): String;
Var
  StartSt, EndSt, TextSt, Contain1St, Contain2St, Contain3St: String;
  CaseSensitive: Boolean;
begin
  CaseSensitive:= ScriptNode.ReadAttributeBool('CaseSensitive');
  StartSt:= Process_ControlChar(ScriptNode.ReadAttributeString('Start'));
  EndSt:= Process_ControlChar(ScriptNode.ReadAttributeString('End'));
  TextSt:= Process_ControlChar(ScriptNode.ReadAttributeString('Text'));
  Contain1St:= Process_ControlChar(ScriptNode.ReadAttributeString('Contain1'));
  Contain2St:= Process_ControlChar(ScriptNode.ReadAttributeString('Contain2'));
  Contain2St:= Process_ControlChar(ScriptNode.ReadAttributeString('Contain2'));
  if TextSt <> '' then
    result:= DeleteAll(Html, TextSt, CaseSensitive)
  else
    result:= DeleteAllBE(Html, StartSt, Contain1St, Contain2St, Contain3St, EndSt, CaseSensitive)
end;

function Process_DeleteAllAttribute(ScriptNode: TXmlNode; Html: string): String;
var
  AttName, AttValue: string;
begin
  AttName:= ScriptNode.ReadAttributeString('Name');
  AttValue:= ScriptNode.ReadAttributeString('Value');
  if AttName = '' then
    result:= Html
  else
  begin
    if AttValue <>'' then
      result:= DeleteAllAttributeWithValue(Html, AttName, AttValue)
    else
      result:= DeleteAllAttribute(Html, AttName);
  end;
end;

function Process_ReplaceAll(ScriptNode: TXmlNode; Html: string): String;
var
  StartSt, EndSt, TextSt, Contain1St, Contain2St, Contain3St, NewSt: String;
  CaseSensitive: Boolean;
begin
  CaseSensitive:= ScriptNode.ReadAttributeBool('CaseSensitive');
  StartSt:= Process_ControlChar(ScriptNode.ReadAttributeString('Start'));
  EndSt:= Process_ControlChar(ScriptNode.ReadAttributeString('End'));
  TextSt:= Process_ControlChar(ScriptNode.ReadAttributeString('Text'));
  NewSt:= Process_ControlChar(ScriptNode.ReadAttributeString('New'));
  Contain1St:= Process_ControlChar(ScriptNode.ReadAttributeString('Contain1'));
  Contain2St:= Process_ControlChar(ScriptNode.ReadAttributeString('Contain2'));
  Contain3St:= Process_ControlChar(ScriptNode.ReadAttributeString('Contain3'));
  if TextSt<>'' then
    result:= ReplaceAll(Html, TextSt, NewSt, CaseSensitive)
  else
    result:= ReplaceAllBE(Html, StartSt, Contain1St, Contain2St, Contain3St, EndSt, NewSt, CaseSensitive)
end;

function Process_ForEach(ScriptNode: TXmlNode; Html: string): String;
var
  FoundedSt, NewSt: String;
  StB, StC1, StC2, StC3, StE: String;
  CaseSensitive: Boolean;
  PS, PE, LR, LSt, LStN, LStF: Integer;
function FindSt(St: String; var Pos: Integer): String;
begin
  result:= CopyBE(St, StB, StC1, StC2, StC3, StE, Pos, CaseSensitive)
end;
begin
  CaseSensitive:= ScriptNode.ReadAttributeBool('CaseSensitive');
  StB:= ScriptNode.ReadAttributeString('Start');
  StE:= ScriptNode.ReadAttributeString('End');
  StC1:= ScriptNode.ReadAttributeString('Contain1');
  StC2:= ScriptNode.ReadAttributeString('Contain2');
  StC3:= ScriptNode.ReadAttributeString('Contain3');
  Result:= '';
  lr:= 0;
  PE:= 0;
  PS:= 1;
  LSt:= Length(Html);
  SetLength(result, LSt);
  FillChar(result[1], LSt, 0);
  FoundedSt:= FindSt(Html, PS);
  LStF:= Length(FoundedSt);
  while LStF<>0 do
  begin
    NewSt:= Process_Script(ScriptNode, FoundedSt);
    LStN:= Length(NewSt);
    Move(html[pe+1],result[lr+1], (ps-1)-pe);
    inc(lr, (ps-1)-pe);
    Move(NewSt[1], result[lr+1], LStN);
    inc(lr, LStN);
    inc(PS, LStF);
    pe:= ps-1;
    FoundedSt:= FindSt(Html, PS);
    LStF:= Length(FoundedSt);
  end;
  Move(Html[pe+1], result[lr+1], LSt-pe);
  inc(lr, LSt-pe);
  SetLength(result, lr);
end;

function Process_WhileExists(ScriptNode: TXmlNode; Html: string): String;
begin
  Result:= '';
  repeat
    result:= Process_ForEach(ScriptNode, html);
    if result<>html then
    begin
      html:= result;
      result:= '';
    end
  until html=result;
end;

function Process_TakeBetween(ScriptNode: TXmlNode; Html: String): String;
var
  StB, StE, StC1, StC2, StC3, StoreName: String;
  CaseSensitive: Boolean;
begin
  CaseSensitive:= ScriptNode.ReadAttributeBool('CaseSensitive');
  StB:= ScriptNode.ReadAttributeString('Start');
  StE:= ScriptNode.ReadAttributeString('End');
  StC1:= ScriptNode.ReadAttributeString('Contain1');
  StC2:= ScriptNode.ReadAttributeString('Contain2');
  StC3:= ScriptNode.ReadAttributeString('Contain3');
  StoreName:= ScriptNode.ReadAttributeString('StoreName');
  if StoreName<>'' then
  begin
    Simple_Store(StoreName, CopyBetween(Html, StB, StC1, StC2, StC3, StE, CaseSensitive));
    result:= Html;
  end
  else
    result:= CopyBetween(Html, StB, StC1, StC2, StC3, StE, CaseSensitive);
end;

function Process_TakeBeginEnd(ScriptNode: TXmlNode; Html: String): String;
var
  StB, StE, StC1, StC2, StC3, StoreName: String;
  CaseSensitive: Boolean;
begin
  CaseSensitive:= ScriptNode.ReadAttributeBool('CaseSensitive');
  StB:= ScriptNode.ReadAttributeString('Start');
  StE:= ScriptNode.ReadAttributeString('End');
  StC1:= ScriptNode.ReadAttributeString('Contain1');
  StC2:= ScriptNode.ReadAttributeString('Contain2');
  StC3:= ScriptNode.ReadAttributeString('Contain3');
  StoreName:= ScriptNode.ReadAttributeString('StoreName');
  if StoreName<>'' then
  begin
    Simple_Store(StoreName, CopyBE(Html, StB, StC1, StC2, StC3, StE, CaseSensitive));
    result:= Html;
  end
  else
  if (StB=StE) or
     (StB=StC1) or (StB=StC2) or (StB=StC3) or
     (StE=StC1) or (StE=StC2) or (StE=StC3) then
    result:= CopyBSE(Html, StB, StC1, StC2, StC3, StE, CaseSensitive)
  else
    result:= CopyBE(Html, StB, StC1, StC2, StC3, StE, CaseSensitive);
end;

procedure Process_Store(ScriptNode: TXMLNode; Html: String);
begin
  Simple_Store(ScriptNode.ReadAttributeString('Name'), Html);
end;

function Process_Restore(ScriptNode: TXMLNode; Html: String): String;
var
  ndItem: TXmlNode;
  Action, Separator: String;
begin
  ndItem:= Stack.Root.NodeByAttributeValue('Item', 'Name', ScriptNode.ReadAttributeString('Name'), false);
  Separator:= ScriptNode.ReadAttributeString('Separator');
  if ndItem = nil then
    Result:= Html
  else
  begin
    Action:= UpperCase(ScriptNode.ReadAttributeString('Action', 'Replace'));
    if Action = 'BEFORE' then
      Result:= ndItem.ValueAsString + Separator + Html
    else
    if Action = 'AFTER' then
      Result:= Html + Separator + ndItem.ValueAsString
    else
      Result:= ndItem.ValueAsString;
  end;
end;

procedure Process_SetVarValue(ScriptNode: TXMLNode; Html: String);
begin
  Vars[ScriptNode.ReadAttributeString('Name')]:= Html;
end;

procedure Process_Save(ScriptNode: TXMLNode; Html: String);
begin
  if ScriptNode.ReadAttributeString('Devider')<>'' then
    if Html <> '' then Html:= Html + ScriptNode.ReadAttributeString('Devider');
  SaveStringAsFile(Html, ScriptNode.ReadAttributeString('FileName'),
                   ScriptNode.ReadAttributeBool('Append'));
end;

function Process_ExtractTag(ScriptNode: TXMLNode; Html: String): String;
var
  Number: Integer;
  SNumber, TagName: String;
  StB, StE, StC1, StC2, StC3, StoreName: String;
  CaseSensitive: Boolean;
begin
  TagName:= ScriptNode.ReadAttributeString('Name');
  Number:= 0;
  result:= '';
  CaseSensitive:= ScriptNode.ReadAttributeBool('CaseSensitive');
  StC1:= ScriptNode.ReadAttributeString('Contain1');
  StC2:= ScriptNode.ReadAttributeString('Contain2');
  StC3:= ScriptNode.ReadAttributeString('Contain3');
  StoreName:= ScriptNode.ReadAttributeString('StoreName');
  repeat
    Inc(Number);
    SNumber:= Format(#9'TagNo="%s%u"',[TagName, Number]);
    StB:= LowerCase('<'+TagName+SNumber);
    StE:= '</'+TagName+SNumber+'>';
    result:= CopyBE(Html, StB, StC1, StC2, StC3, StE, CaseSensitive);
    if result<>'' then
    begin
      if StoreName<>'' then
      begin
        Simple_Store(StoreName, result);
        result:= Html;
      end;
      Exit;
    end;
  until Pos(StB, AnsiLowerCase(Html))=0;
end;

function Process_ExtratcHashPairs(ScriptNode: TXMLNode; Html: String): String;
function GetValue(Var Html: String; AttName, StSeparator: String): String;
var
  StB, StE: String;
begin
  StB:= AttName+'='+StSeparator;
  if StSeparator = '' then
    StE:= ' '
  else
    StE:= StSeparator;
  result:= TakeBE(Html, StB, StE);
  result:= CopyBetween(result, StB, StE);
end;
var
  St, Name, Value, StB, StE, StN, StV, Separator: String;

begin
  result:= '';
  StB:= ScriptNode.ReadAttributeString('Start');
  StE:= ScriptNode.ReadAttributeString('End');
  StN:= ScriptNode.ReadAttributeString('Name');
  StV:= ScriptNode.ReadAttributeString('Value');
  Separator:= ScriptNode.ReadAttributeString('Separator', #$D#$A);
  repeat
    St:= TakeBE(Html, StB, StN, StE);
    if St='' then break;
    St:= CopyBetween(St, StB, StE);
    Name:= GetValue(St, StN, '"')+
           GetValue(St, StN, '''')+
           GetValue(St, StN, '');
    Value:= GetValue(St, StV, '"')+
            GetValue(St, StV, '''')+
            GetValue(St, StV, '');
    result:= result+Name+'='+Value+Separator;
  until false;
end;

function Process_AppendText(ScriptNode: TXMLNode; Html: String): String;
Var
  Action, Value: String;
begin
  Value:= ScriptNode.ReadAttributeString('Text');
  Action:= UpperCase(ScriptNode.ReadAttributeString('Action', 'After'));
  if Action = 'BEFORE' then
    Result:= Value + Html
  else
    Result:= Html + Value
end;

function Process_ExpandHref(ScriptNode: TXMLNode; Html: String): String;
var
  StB, StE, StC1, StC2, StC3, AttName: String;
  CaseSensitive: Boolean;
  i, PSlash, PQuest: Integer;
  AURI, HURI: TIdUri;
  sl: TStringList;
  UPath, URL, St: String;
begin
  result:= Html;
  URL:= Vars[ScriptNode.ReadAttributeString('VarName')];
  if URL = '' then Exit;
  CaseSensitive:= ScriptNode.ReadAttributeBool('CaseSensitive');
  StB:= ScriptNode.ReadAttributeString('Start');
  StE:= ScriptNode.ReadAttributeString('End');
  StC1:= ScriptNode.ReadAttributeString('Contain1');
  StC2:= ScriptNode.ReadAttributeString('Contain2');
  StC3:= ScriptNode.ReadAttributeString('Contain3');
  AttName:= ScriptNode.ReadAttributeString('AttName');
  AURI:= TIdUri.Create(URL);
  sl:= TStringList.Create;
  try
    St:= CopyAllBE(result, StB, StC1, StC2, StC3, StE, CaseSensitive, #$D#$A);
    sl.Text:= CopyAllBE(St, AttName+'="', '"', false, #$D#$A);
    For i:= 0 to sl.Count-1 do
    begin
      St:= CopyBetween(sl[i], '="', '"');
      if St='' then continue;
      PSlash:= Pos('/', St);
      PQuest:= Pos('?', St);
      if PQuest = PSlash then
        St:= '/'+St
      else
      if (PQuest>0) and ((PSlash=0) or (PSlash>PQuest)) then
        St:= '/'+St;
      HURI:= TIdURI.Create(St);
      try
        if HURI.Protocol='' then
        begin
          HURI.Protocol:= AURI.Protocol;
          HURI.Host:= AURI.Host;
          HURI.Port:= AURI.Port;
          UPath:= HURI.Path;
          if (CopyFront3(UPath, '/')='./') or
             (CopyFront3(UPath, '/')='/') then
            TakeFront3(UPath, '/');
          HURI.Path:= AURI.Path+UPath;
          UPath:= AttName+'="'+HURI.GetFullURI+'"';
          result:= ReplaceAll(result, sl[i], UPath);
        end;
      finally
        HURI.Free;
      end;
    end;
  finally
    sl.Free;
    AURI.Free;
  end;
end;

function Process_Script(ScriptNode: TXMLNode; Html: String): String;
var
  i: Integer;
  Name: String;
  ChildNode: TXmlNode;
begin
  try
    For i:= 0 to ScriptNode.NodeCount-1 do
    begin
      ChildNode:= ScriptNode.Nodes[i];
      Name:= UpperCase(ChildNode.Name);
      if Name = 'DELETEALL' then
        Html:= Process_DeleteAll(ChildNode, Html)
      else
      if Name = 'REPLACEALL' then
        Html:= Process_ReplaceAll(ChildNode, Html)
      else
      if Name = 'DELETEALLATTRIBUTE' then
        Html:= Process_DeleteAllAttribute(ChildNode, Html)
      else
      if Name = 'EXECUTE' then
        if ChildNode.ReadAttributeString('Copy')='' then
          Html:= Run_HtmlScript(Root, ChildNode.ReadAttributeString('Name'), Html, Vars)
        else
          Run_HtmlScript(Root, ChildNode.ReadAttributeString('Name'), Html, Vars)
      else
      if Name = 'TAKEBETWEEN' then
        Html:= Process_TakeBetween(ChildNode, Html)
      else
      if Name = 'TAKEBEGINEND' then
        Html:= Process_TakeBeginEnd(ChildNode, Html)
      else
      if Name = 'WHILEEXISTS' then
        Html:= Process_WhileExists(ChildNode, Html)
      else
      if Name = 'FOREACH' then
        Html:= Process_ForEach(ChildNode, Html)
      else
      if Name = 'DELETE' then
        Html:= Process_Delete(ChildNode, Html)
      else
      if Name = 'STORE' then
        Process_Store(ChildNode, Html)
      else
      if Name = 'RESTORE' then
        Html:= Process_Restore(ChildNode, Html)
      else
      if Name = 'SETVARVALUE' then
        Process_SetVarValue(ChildNode, Html)
      else
      if Name = 'SAVE' then
        Process_Save(ChildNode, Html)
      else
      if Name = 'NUMBERINGTAG' then
        Html:= NumberingTag(Html, ChildNode.ReadAttributeString('Name'))
      else
      if Name = 'EXTRACTTAG' then
        Html:= Process_ExtractTag(ChildNode, Html)
      else
      if Name = 'EXTRACTHASHPAIRS' then
        Html:= Process_ExtratcHashPairs(ChildNode, Html)
      else
      if Name = 'EXTRACTTAGS' then
        Html:= CopyAllBE(Html, ChildNode.ReadAttributeString('Start'),
                               ChildNode.ReadAttributeString('Contain1'),
                               ChildNode.ReadAttributeString('Contain2'),
                               ChildNode.ReadAttributeString('Contain3'),
                               ChildNode.ReadAttributeString('End'),
                               ChildNode.ReadAttributeBool('CaseSensitive'),
                               ChildNode.ReadAttributeString('Separator'))
      else
      if Name = 'APPENDTEXT' then
        Html:= Process_AppendText(ChildNode, Html)
      else
      if Name = 'EXPANDHREF' then
        Html:= Process_ExpandHref(ChildNode, Html)
//      SaveStringAsFile(Html, 'D:\swim\xxx.html');
    end;
  finally
    result:= Html;
  end;
end;

var
  ScriptNode: TXmlNode;
begin
  result:= Html;
  while Root.Parent<> nil do
    Root:= Root.Parent;
  if SubScriptName = '' then
    ScriptNode:= Root
  else
    ScriptNode:= Root.NodeByAttributeValue('Event', 'Name', SubScriptName, true);
  if ScriptNode<>nil then
  begin
    Stack:= TNativeXML.CreateName('Stack');
    try
      Result:= Process_Script(ScriptNode, Html);
    finally
      Stack.Free;
    end;
  end;
end;

end.
