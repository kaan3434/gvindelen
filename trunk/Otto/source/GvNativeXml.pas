unit GvNativeXml;

interface

uses
  NativeXml, Variants, SysUtils, DB, DBCtrlsEh, Classes;

type
  EMandatoryAttributeError = class(Exception);
  TCopyMode = (cmAppend, cmReplace, cmMerge);

function AttrExists(aNode: TXmlNode; aAttributeName: string): Boolean;

procedure SetXmlAttr(aNode: TXmlNode; aAttributeName: string; aValue: Variant; isRequired: Boolean = false);
procedure SetXmlAttrDef(aNode: TXmlNode; aAttributeName: string; aValue, aDefValue: Variant);
procedure SetXmlAttrAsFloat(aNode: TXmlNode; aAttributeName: string; aValue: Variant; isRequired: Boolean = false);
procedure SetXmlAttrAsMoney(aNode: TXmlNode; aAttributeName: string; aValue: Variant);
procedure MergeXmlAttr(aNode: TXmlNode; aAttributeName: string; aValue: Variant);
procedure DelXmlAttr(aNode: TXmlNode; aAttributeName: string);

function AttrsAsString(aNode: TXmlNode): string;

function GetXmlAttr(aNode: TXmlNode; aAttributeName: string;
  aPrefix: string = ''; aPostfix: string = ''): string;

function GetXmlAttrValue(aNode: TXmlNode; aAttributeName: string;
  aDefaultValue: Variant): variant; overload;
function GetXmlAttrValue(aNode: TXmlNode; aAttributeName: string): variant; overload;

function GetXmlAttrAsMoney(aNode: TXmlNode; aAttributeName: string;
  aDefaultValue: string = '0.00'): variant;

function XmlAttrIn(aNode: TXmlNode; aAttributeName, Values: string): Boolean;

function ToFloat(aStr: string): Double;


procedure BatchMoveFields2(aDestDataSet, aSrcDataSet: TDataSet; aMapping: string); overload;
procedure BatchMoveFields2(aDestNode: TXmlNode; aSrcDataSet: TDataSet; aMapping: string;
  aMandatory: Boolean = false); overload;
procedure BatchMoveFields2(aDestDataSet: TDataSet; aSrcNode: TXmlNode; aMapping: string); overload;
procedure BatchMoveFields2(aDestNode, aSrcNode: TXmlNode; aMapping: string); overload;

procedure BatchMoveXMLNodes2Dataset(aDestDataSet: TDataSet; aSrcListNode: TXmlNode;
  aMapping: string; aMode:TCopyMode; aShowProgress: Boolean = false);


procedure Combo2XmlAttr(aCombo: TDBComboBoxEh; aNode: TXmlNode;
  aAttrNameKey, aAttrNameValue: string);
procedure XmlAttr2Combo(aCombo: TDBComboBoxEh; aNode: TXmlNode;
  aAttrNameKey, aAttrNameValue: string; aDefaultValue: string = '');

function DetectCaption(aNode : TXmlNode; aCaption: String): string;

function ChildByAttributes(aRootNode: TXmlNode; aAttrNames: string; aValues: array of Variant): TXmlNode;

function XmlAttrs2Vars(aNode: TXmlNode; aAttrNames: string; aVars: string = ''): string;
function Strings2Vars(aStrings: TStrings; aAttrNames: string; aVars: string = ''): string;
function Value2Vars(aValue: Variant; aAttrName: string; aVars: string =''): string;

implementation

uses
  GvStr, JvProgressDialog, Dialogs, GvVars, GvDtTm;

function AttrExists(aNode: TXmlNode; aAttributeName: string): Boolean;
begin
  Result:= aNode.AttributeIndexByname(aAttributeName) >= 0;
end;

function DetectCaption(aNode : TXmlNode; aCaption: String): string;
begin
  if AttrExists(aNode, 'ID') then
    Result:= GetXmlAttr(aNode, 'ID', aCaption+' [ID = ', ']')
  else
    Result:= aCaption+'[�����]';
end;

procedure SetXmlAttr(aNode: TXmlNode; aAttributeName: string; aValue: Variant; isRequired: Boolean = false);
var
  BeforeAttrs: string;
begin
  BeforeAttrs:= CopyBE(Trim(aNode.WriteToString), '<', '>');
  if VarIsNull(aValue) then
    if isRequired then
      raise EMandatoryAttributeError.CreateFmt('�� ��������� ������������ �������� %s', [aAttributeName])
    else
      aNode.AttributeDelete(aNode.AttributeIndexByname(aAttributeName))
  else
  if (VarType(aValue) and VarTypeMask) = varDate then
    aNode.WriteAttributeDateTime(aAttributeName, aValue)
  else
  if (VarType(aValue) and VarTypeMask) = varString then
  begin
    if aValue <> '' then
      aNode.WriteAttributeString(aAttributeName, aValue);
  end
  else
    aNode.WriteAttributeString(aAttributeName, aValue);
  if BeforeAttrs <> CopyBE(Trim(aNode.WriteToString), '<', '>') then
    aNode.ValueAsBool:= True;
end;

function ToFloat(aStr: string): Double;
begin
  if DecimalSeparator = ',' then
    result:= StrToFloat(ReplaceAll(aStr, '.', DecimalSeparator))
  else
    result:= StrToFloat(ReplaceAll(aStr, ',', DecimalSeparator));
end;

procedure SetXmlAttrAsMoney(aNode: TXmlNode; aAttributeName: string; aValue: Variant);
var
  BeforeAttrs: string;
begin
  BeforeAttrs:= CopyBE(Trim(aNode.WriteToString), '<', '>');
  if Not VarIsNull(aValue) then
    aNode.WriteAttributeString(aAttributeName, Format('%3.2f', [ToFloat(aValue)]));
  if BeforeAttrs <> CopyBE(Trim(aNode.WriteToString), '<', '>') then
    aNode.ValueAsBool:= True;
end;

procedure SetXmlAttrAsFloat(aNode: TXmlNode; aAttributeName: string; aValue: Variant; isRequired: Boolean = false);
var
  BeforeAttrs: string;
begin
  BeforeAttrs:= CopyBE(Trim(aNode.WriteToString), '<', '>');
  if VarIsNull(aValue) then
    if isRequired then
      raise EMandatoryAttributeError.CreateFmt('�� ��������� ������������ �������� %s', [aAttributeName])
    else
      aNode.AttributeDelete(aNode.AttributeIndexByname(aAttributeName))
  else
    aNode.WriteAttributeFloat(aAttributeName, ToFloat(aValue));
  if BeforeAttrs <> CopyBE(Trim(aNode.WriteToString), '<', '>') then
    aNode.ValueAsBool:= True;
end;

procedure SetXmlAttrDef(aNode: TXmlNode; aAttributeName: string; aValue, aDefValue: Variant);
var
  BeforeAttrs: string;
begin
  BeforeAttrs:= CopyBE(Trim(aNode.WriteToString), '<', '>');
  if VarIsNull(aValue) then aValue:= aDefValue;
  if VarIsNull(aValue) then
    aNode.AttributeDelete(aNode.AttributeIndexByname(aAttributeName))
  else
  if (VarType(aValue) and VarTypeMask) = varDate then
    aNode.WriteAttributeDateTime(aAttributeName, aValue)
  else
    aNode.WriteAttributeString(aAttributeName, aValue);
  if BeforeAttrs <> CopyBE(Trim(aNode.WriteToString), '<', '>') then
    aNode.ValueAsBool:= True;
end;

procedure MergeXmlAttr(aNode: TXmlNode; aAttributeName: string; aValue: Variant);
begin
  SetXmlAttrDef(aNode, aAttributeName, aValue, aNode.ReadAttributeString(aAttributeName));
end;

function ChildByAttributes(aRootNode: TXmlNode; aAttrNames: string; aValues: array of Variant): TXmlNode;
var
  i, j: Integer;
  AttrNames: TStringList;
  Founded: Boolean;
  Value: String;
begin
  AttrNames:= TStringList.Create;
  try
    AttrNames.Delimiter:= ';';
    AttrNames.DelimitedText:= '"'+ReplaceAll(aAttrNames, ';', '";"')+'"';
    For i:= 0 to aRootNode.NodeCount - 1 do
    begin
      Result:= aRootNode[i];
      Founded:= true;
      for j:= 0 to AttrNames.Count - 1 do
      begin
        Value:= Result.ReadAttributeString(AttrNames[j], '');
        Founded:=  Value = aValues[j];
        if not Founded then Break;
      end;
      if Founded then Exit;
    end;
    Result:= nil;
  finally
    AttrNames.Free;
  end;
end;

function AttrsAsString(aNode: TXmlNode): string;
begin
  Result:= CopyBE(trim(aNode.WriteToString), '<', '>');
  TakeFront5(Result);
  TakeBack3(Result, '/>');
  Result:= ReplaceAll(Result, '="', '=~');
  Result:= ReplaceAll(Result, '" ', '"'#13#10);
  Result:= ReplaceAll(Result, '=~', '="');
end;

function GetXmlAttr(aNode: TXmlNode; aAttributeName: string;
  aPrefix: string = ''; aPostfix: string = ''): string;
begin
  if AttrExists(aNode, aAttributeName) then
    result:= aPrefix + aNode.ReadAttributeString(aAttributeName) + aPostfix
  else
    result:= '';
end;

function GetXmlAttrValue(aNode: TXmlNode; aAttributeName: string;
  aDefaultValue: variant): variant; overload;
var
  AttrValue: string;
  DtTm: TDateTime;
  Filtered: string;
begin
  if AttrExists(aNode, aAttributeName) then
  begin
    AttrValue:= aNode.ReadAttributeString(aAttributeName);
    Filtered:= FilterString(AttrValue, '/.-T::.Z');
    if Filtered = '--T::.Z' then
      result:= aNode.ReadAttributeDateTime(aAttributeName)
    else
    if (Filtered = '--::.') or (Filtered = '//::.') or (Filtered = '..::.') then
      Result:= DateTimeStrEval('YYYY.MM.DD HH:NN:SS.ZZZZ', AttrValue)
    else
      result:= aNode.ReadAttributeString(aAttributeName)
  end
  else
    Result:= aDefaultValue
end;

function GetXmlAttrValue(aNode: TXmlNode; aAttributeName: string): variant; overload;
begin
  Result:= GetXmlAttrValue(aNode, aAttributeName, null);
end;

function GetXmlAttrAsMoney(aNode: TXmlNode; aAttributeName: string;
  aDefaultValue: string = '0.00'): variant;
var
  AttrValue: string;
begin
  if AttrExists(aNode, aAttributeName) then
  begin
    aNode.ReadAttributeString(aAttributeName, aDefaultValue)
  end
  else
  if aDefaultValue <> '' then
    Result:= aDefaultValue
  else
    result:= null;
end;

function XmlAttrIn(aNode: TXmlNode; aAttributeName, Values: string): Boolean;
begin
  Result:= Pos(','+GetXmlAttr(aNode, aAttributeName)+',', ','+Values+',') > 0;
end;

procedure DelXmlAttr(aNode: TXmlNode; aAttributeName: string);
var
  idx: Integer;
begin
  idx:= aNode.AttributeIndexByname(aAttributeName);
  if idx >= 0 then
    aNode.AttributeDelete(idx);
end;

procedure BatchMoveFields2(aDestDataSet, aSrcDataSet: TDataSet; aMapping: string); overload;
var
  FldSrc, FldDest: string;
  FieldDest, FieldSrc: TField;
begin
  while aMapping <> '' do
  begin
    FldSrc:= TakeFront5(aMapping, ';');
    FldDest:= TakeFront5(FldSrc, '=');
    if FldSrc = '' then FldSrc:= FldDest;
    FieldDest:= aDestDataSet.FieldByName(FldDest);
    if FieldDest = nil then
      raise Exception.CreateFmt('Field "%s" not found in destignation', [FldDest])
    else
    if FldSrc[1] = '"' then
      FieldDest.AsString:= CopyBetween(FldSrc, '"', '"')
    else
    begin
      FieldSrc:= aSrcDataSet.FieldByName(FldSrc);
      if FieldSrc = nil then
        raise Exception.CreateFmt('Field "%s" not found in source', [FldSrc])
      else
        FieldDest.Value:= FieldSrc.Value;
    end;
  end;
end;

procedure BatchMoveFields2(aDestDataSet: TDataSet; aSrcNode: TXmlNode; aMapping: string); overload;
var
  FldSrc, FldDest: string;
  FieldDest, FieldSrc: TField;
begin
  while aMapping <> '' do
  begin
    FldSrc:= TakeFront5(aMapping, ';');
    FldDest:= TakeFront5(FldSrc, '=');
    if FldSrc = '' then FldSrc:= FldDest;
    FieldDest:= aDestDataSet.FieldByName(FldDest);
    if FieldDest = nil then
      raise Exception.CreateFmt('Field "%s" not found in destignation', [FldDest])
    else
    if FldSrc[1] = '"' then
      FieldDest.AsString:= CopyBetween(FldSrc, '"', '"')
    else
    if AttrExists(aSrcNode, FldSrc) then
    begin
      if FieldDest.DataType = ftFloat then
        FieldDest.Value:= ToFloat(GetXmlAttrValue(aSrcNode, FldSrc))
      else
        FieldDest.Value:= GetXmlAttrValue(aSrcNode, FldSrc);
    end
    else
      FieldDest.Value:= null;
  end;
end;

procedure BatchMoveFields2(aDestNode: TXmlNode; aSrcDataSet: TDataSet; aMapping: string;
  aMandatory:boolean = false); overload;
var
  FldSrc, FldDest: string;
  FieldDest, FieldSrc: TField;
begin
  while aMapping <> '' do
  begin
    FldSrc:= TakeFront5(aMapping, ';');
    FldDest:= TakeFront5(FldSrc, '=');
    if FldSrc = '' then FldSrc:= FldDest;
    if FldSrc[1] = '"' then
      SetXmlAttr(aDestNode, FldDest, CopyBetween(FldSrc, '"', '"'))
    else
    begin
      FieldSrc:= aSrcDataSet.FieldByName(FldSrc);
      if FieldSrc = nil then
        raise Exception.CreateFmt('Field "%s" not found in source', [FldSrc])
      else
        SetXmlAttr(aDestNode, FldDest, FieldSrc.Value, aMandatory);
    end;
  end;
end;

procedure BatchMoveFields2(aDestNode, aSrcNode: TXmlNode; aMapping: string); overload;
var
  FldSrc, FldDest: string;
  DestIdx: Integer;
begin
  while aMapping <> '' do
  begin
    FldSrc:= TakeFront5(aMapping, ';');
    FldDest:= TakeFront5(FldSrc, '=');
    if FldSrc = '' then FldSrc:= FldDest;
    if FldSrc[1] = '"' then
      SetXmlAttr(aDestNode, FldDest, CopyBetween(FldSrc, '"', '"'))
    else
    if AttrExists(aSrcNode, FldSrc) then
      SetXmlAttr(aDestNode, FldDest, aSrcNode.ReadAttributeString(FldSrc))
    else
      DelXmlAttr(aDestNode, FldDest);
  end;
end;

procedure BatchMoveXMLNodes2Dataset(aDestDataSet: TDataSet; aSrcListNode: TXmlNode; 
  aMapping: string; aMode:TCopyMode; aShowProgress: Boolean = false);
var
  slFrom, slTo: TStringList;
  i, f: Integer;
  aProgress: TJvProgressDialog;
begin
  case aMode of
    cmReplace:
    begin
      aDestDataSet.First;
      while not aDestDataSet.Eof do aDestDataSet.Delete;
    end;
  end;

  aProgress:= TJvProgressDialog.Create(nil);
  try
    if aShowProgress then
    begin
      aProgress.InitValues(0, aSrcListNode.NodeCount, 200, 0, '������ ������', '');
      aProgress.ShowCancel := False;
      aProgress.Show;
    end;

    for i:= 0 to aSrcListNode.NodeCount - 1 do
    begin
      aDestDataSet.Append;
      BatchMoveFields2(aDestDataSet, aSrcListNode[i], aMapping);
      if aShowProgress and (i mod 10 = 0) then
        aProgress.Position:= i;
    end;
    if aDestDataSet.State <> dsBrowse then
      aDestDataSet.Post;
    if aShowProgress then
      aProgress.Hide;
  finally
    aProgress.Free;
  end;
end;

procedure Combo2XmlAttr(aCombo: TDBComboBoxEh; aNode: TXmlNode;
  aAttrNameKey, aAttrNameValue: string);
var
  ii: Integer;
begin
  ii:= aCombo.ItemIndex;
  if ii = -1 then
  begin
    SetXmlAttr(aNode, aAttrNameKey, null);
    SetXmlAttr(aNode, aAttrNameValue, null);
  end
  else
  begin
    SetXmlAttr(aNode, aAttrNameKey, aCombo.KeyItems[ii]);
    SetXmlAttr(aNode, aAttrNameValue, aCombo.Items[ii]);
  end;
end;

procedure XmlAttr2Combo(aCombo: TDBComboBoxEh; aNode: TXmlNode;
  aAttrNameKey, aAttrNameValue: string; aDefaultValue: string = '');
var
  Value: Variant;
begin
  if AttrExists(aNode, aAttrNameKey) then
    aCombo.ItemIndex:= aCombo.KeyItems.IndexOf(aNode.ReadAttributeString((aAttrNameKey)));
  if aCombo.ItemIndex = -1 then
  begin
    Value:= GetXmlAttrValue(aNode, aAttrNameValue, aDefaultValue);
    if not VarIsNull(Value) then
      aCombo.Text:= Value;
  end;
end;

function XmlAttrs2Vars(aNode: TXmlNode; aAttrNames: string; aVars: string = ''): string;
var
  Vars: TVarList;
  AttrFrom, NameTo: string;
begin
  Vars:= TVarList.Create;
  try
    Vars.Text:= aVars;
    While aAttrNames <> '' do
    begin
      AttrFrom:= TakeFront5(aAttrNames,' ;,');
      if Pos('=', AttrFrom) = 0 then
        NameTo:= AttrFrom
      else
        NameTo:= TakeFront5(AttrFrom, '=');
      if AttrExists(aNode, AttrFrom) then
        Vars[NameTo]:= aNode.ReadAttributeString(AttrFrom);
    end;
    Result:= Vars.Text;
  finally
    Vars.Free;
  end;
end;

function Strings2Vars(aStrings: TStrings; aAttrNames: string; aVars: string = ''): string;
var
  Vars: TVarList;
  NameTo: string;
  Index: Integer;
begin
  Vars:= TVarList.Create;
  try
    Vars.Text:= aVars;
    While aAttrNames <> '' do
    begin
      NameTo:= TakeFront5(aAttrNames,' ;,');
      Index:= StrToInt(TakeBack5(NameTo, '='));
      if Index < aStrings.Count then
        Vars[NameTo]:= aStrings[index];
    end;
    Result:= Vars.Text;
  finally
    Vars.Free;
  end;
end;

function Value2Vars(aValue: Variant; aAttrName: string; aVars: string =''): string;
var
  Vars: TVarList;
begin
  Vars:= TVarList.Create;
  try
    Vars.Text:= aVars;
    Vars[aAttrName]:= aValue;
    Result:= Vars.Text;
  finally
    Vars.Free;
  end;
end;

end.
