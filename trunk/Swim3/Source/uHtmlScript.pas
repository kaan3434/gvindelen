unit uHtmlScript;

interface

function RunHtmlScript(Html, FileName: String): String;

implementation
uses
  NativeXML, GvinStr, GvinFile, SysUtils;

const
  ampCR = '&CR;';
  ampLF = '&LF;';

function Process_Script(ScriptNode: TXMLNode; Html: String): String; forward;

function Process_ControlChar(St: String): String;
begin
  result:= St;
  result:= ReplaceAll(result, ampCR, #$0D, true);
  result:= ReplaceAll(result, ampLF, #$0A, true);
end;

function Process_Delete(ScriptNode: TXmlNode; Html: string): String;
var
  StartSt, EndSt: String;
  CaseSensitive: Boolean;
begin
  CaseSensitive:= ScriptNode.ReadAttributeInteger('CaseSensitive',0)=0;
  StartSt:= Process_ControlChar(ScriptNode.ReadAttributeString('Start'));
  EndSt:= Process_ControlChar(ScriptNode.ReadAttributeString('End'));
  if EndSt <> '' then
    result:= ReplaceBeforeString(html, EndSt, '', CaseSensitive)
  else
  if StartSt <> '' then
    result:= ReplaceAfterString(html, StartSt, '', CaseSensitive)

end;

function Process_DeleteAll(ScriptNode: TXmlNode; Html: string): String;
Var
  StartSt, EndSt, TextSt, ContainSt: String;
  CaseSensitive: Boolean;
begin
  CaseSensitive:= ScriptNode.ReadAttributeInteger('CaseSensitive',0)=0;
  StartSt:= Process_ControlChar(ScriptNode.ReadAttributeString('Start'));
  EndSt:= Process_ControlChar(ScriptNode.ReadAttributeString('End'));
  TextSt:= Process_ControlChar(ScriptNode.ReadAttributeString('Text'));
  ContainSt:= Process_ControlChar(ScriptNode.ReadAttributeString('Contain'));
  if TextSt <> '' then
    result:= DeleteAll(Html, TextSt, CaseSensitive)
  else
  if ContainSt <> '' then
    result:= DeleteAllBE(Html, StartSt, ContainSt, EndSt, CaseSensitive)
  else
  if (StartSt <> '') and (EndSt <> '') then
    result:= DeleteAllBE(Html, StartSt, EndSt, CaseSensitive);
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
  StartSt, EndSt, TextSt, ContainSt, NewSt: String;
  CaseSensitive: Boolean;
begin
  CaseSensitive:= ScriptNode.ReadAttributeInteger('CaseSensitive',0)=0;
  StartSt:= Process_ControlChar(ScriptNode.ReadAttributeString('Start'));
  EndSt:= Process_ControlChar(ScriptNode.ReadAttributeString('End'));
  TextSt:= Process_ControlChar(ScriptNode.ReadAttributeString('Text'));
  NewSt:= Process_ControlChar(ScriptNode.ReadAttributeString('New'));
  ContainSt:= Process_ControlChar(ScriptNode.ReadAttributeString('Contain'));
  if ContainSt <> '' then
    result:= ReplaceAllBE(Html, StartSt, ContainSt, EndSt, NewSt, CaseSensitive)
  else
  if StartSt <> '' then
    result:= ReplaceAllBE(Html, StartSt, EndSt, NewSt, CaseSensitive)
  else
  if TextSt <> '' then
    result:= ReplaceAll(Html, TextSt, NewSt, CaseSensitive)
end;

function Process_ForEach(ScriptNode: TXmlNode; Html: string): String;
var
  FoundedSt, NewSt: String;
  StB, StC, StC1, StC2, StC3, StE: String;
  CaseSensitive: Boolean;
  PS, PE, LR, LSt, LStN, LStF: Integer;
function FindSt(St: String; var Pos: Integer): String;
begin
  result:= CopyBE(St, StB, StC1, StC2, StC3, StE, Pos, CaseSensitive)
end;
begin
  CaseSensitive:= ScriptNode.ReadAttributeInteger('CaseSensitive',0)=0;
  StB:= ScriptNode.ReadAttributeString('Start');
  StE:= ScriptNode.ReadAttributeString('End');
  StC:= ScriptNode.ReadAttributeString('Contain');
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

function Process_ExtractTags(ScriptNode: TXMLNode; Html: String): String;
var
  FoundedSt, NewSt: String;
  StB, StC, StC1, StC2, StC3, StE: String;
  CaseSensitive: Boolean;
  PS, PE, LR, LSt, LStN, LStF: Integer;
function FindSt(St: String; var Pos: Integer): String;
begin
  result:= CopyBE(St, StB, StC1, StC2, StC3, StE, Pos, CaseSensitive)
end;
begin
  CaseSensitive:= ScriptNode.ReadAttributeInteger('CaseSensitive',0)=0;
  StB:= ScriptNode.ReadAttributeString('Start');
  StE:= ScriptNode.ReadAttributeString('End');
  StC:= ScriptNode.ReadAttributeString('Contain');
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
    Move(html[ps],result[lr+1], LStF);
    inc(lr, LStF);
    inc(PS, LStF);
    FoundedSt:= FindSt(Html, PS);
    LStF:= Length(FoundedSt);
  end;
  SetLength(result, lr);
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
      if Name = 'WHILEEXISTS' then
        Html:= Process_WhileExists(ChildNode, Html)
      else
      if Name = 'FOREACH' then
        Html:= Process_ForEach(ChildNode, Html)
      else
      if Name = 'DELETE' then
        Html:= Process_Delete(ChildNode, Html)
      else
      if Name = 'DELETEALL' then
        Html:= Process_DeleteAll(ChildNode, Html)
      else
      if Name = 'DELETEALLATTRIBUTE' then
        Html:= Process_DeleteAllAttribute(ChildNode, Html)
      else
      if Name = 'REPLACEALL' then
        Html:= Process_ReplaceAll(ChildNode, Html)
      else
      if Name = 'EXTRACTTAGS' then
        Html:= Process_ExtractTags(ChildNode, Html);
    end;
  finally
    result:= Html;
  end;
end;

function RunHtmlScript(Html, FileName: String): String;
var
  Script: TNativeXML;
begin
  Script:= TNativeXml.Create;
  Script.LoadFromFile(FileName);
  try
    result:= Process_Script(Script.Root, Html);
  finally
    Script.Free;
  end;
end;


end.
