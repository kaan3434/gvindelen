unit GvXmlUtils;

interface

uses
   Classes, GvXml, DB, Variants;

type
  TAppendMode = (amReplace, amAppend, amMerge);

function ExpandMapping(aNode: TGvXmlNode; aMapping: String = '*'): String; overload;


procedure BatchMoveFields(aDestDataSet: TDataSet; aSrcNode: TGvXmlNode;
  aMapping: String); overload;
procedure BatchMoveFields(aDestNode: TGvXmlNode; aSrcDataSet: TDataSet;
  aMapping: String); overload;
procedure BatchMoveFields(aDestNode, aSrcNode: TGvXmlNode;
  aMapping: String); overload;
procedure BatchMoveFields(aDestBuffer: PChar; aSrcNode: TGvXmlNode;
  aFieldDefs: TFieldDefs); overload;
procedure BatchMoveFields(aDestNode: TGvXmlNode; aSrcBuffer: PChar;
  aFieldDefs: TFieldDefs); overload;

procedure BatchMove(aDestNode: TGvXmlNode; aSrcDataSet: TDataSet;
  aRowNodeName: String; aMapping: String; aAppendMode: TAppendMode = amReplace); overload;
procedure BatchMove(aDestDataSet: TDataSet; aSrcNode: TGvXmlNode;
  aRowNodeName: String; aMapping: String; aAppendMode: TAppendMode = amReplace); overload;
procedure BatchMove(aDestNode, aSrcNode: TGvXmlNode;
  aRowNodeName: String; aMapping: String; aAppendMode: TAppendMode = amReplace); overload;

function DataSet2Attr(aSrcDataSet: TDataSet; aFieldNames: string; aDestNode: TGvXmlNode = nil): TGvXmlNode;
function XmlAttrs2Attr(aSrcNode: TGvXmlNode; aAttrNames: string; aDestNode: TGvXmlNode = nil): TGvXmlNode;
function Strings2Attr(aSrcStrings: TStrings; aAttrNames: string; aDestNode: TGvXmlNode = nil): TGvXmlNode;
function Value2Attr(aValue: Variant; aAttrName: string; aDestNode: TGvXmlNode = nil): TGvXmlNode;


implementation

uses
  GvStr, SysUtils;

procedure ExtractMapPair(var oMapping, oFldDest, oFldSrc: String);
begin
  oFldSrc:= TakeFront5(oMapping, ';');
  oFldDest:= TakeFront5(oFldSrc, '=');
  if oFldSrc = '' then oFldSrc:= oFldDest;
end;

function ExpandMapping(aNode: TGvXmlNode; aMapping: String = '*'): String;
var
  sl: TStringList;
  Attr: TGvXmlAttribute;
  AttrName: String;
  idxAsterix: integer;
{$IFNDEF VER230}
  i: Integer;
{$ENDIF}
begin
  sl:= TStringList.Create;
  try
    sl.Delimiter:= ';';
    sl.DelimitedText:= aMapping;
    sl.CaseSensitive:= false;
    idxAsterix:= sl.IndexOf('*');
    if idxAsterix >= 0 then
    begin
      sl.Delete(idxAsterix);
{$IFDEF VER230}
      for Attr in aNode.Attributes do
      begin
{$ELSE}
      for i:= 0 to aNode.Attributes.count-1 do
      begin
        Attr:= aNode.Attributes[i];
{$ENDIF}
        if (sl.IndexOfName(Attr.Name) < 0) and (sl.IndexOf(Attr.Name) < 0) then
          sl.Add(Attr.Name);
      end;
    end;
    Result:= sl.DelimitedText;
  finally
    sl.Free;
  end;
end;

procedure BatchMoveFields(aDestDataSet: TDataSet; aSrcNode: TGvXmlNode;
  aMapping: String);
var
  FldSrc, FldDest: string;
  AttrSrc: TGvXmlAttribute;
begin
  while aMapping <> '' do
  begin
    ExtractMapPair(aMapping, FldDest, FldSrc);
    if FldSrc[1] = '"' then
      aDestDataSet[FldDest]:= CopyBetween(FldSrc, '"', '"')
    else
    begin
      AttrSrc:= aSrcNode.Attr[FldSrc];
      if AttrSrc = nil then
        aDestDataSet[FldDest]:= null
      else
        aDestDataSet[FldDest]:= AttrSrc.AsString;
    end;
  end;
end;


procedure BatchMoveFields(aDestNode: TGvXmlNode; aSrcDataSet: TDataSet;
  aMapping: String);
var
  FldSrc, FldDest: string;
  FieldSrc: TField;
begin
  while aMapping <> '' do
  begin
    ExtractMapPair(aMapping, FldDest, FldSrc);
    if FldSrc[1] = '"' then
      aDestNode.Attr[FldDest].AsString:= CopyBetween(FldSrc, '"', '"')
    else
    begin
      FieldSrc:= aSrcDataSet.FieldByName(FldSrc);
      if FieldSrc = nil then
        raise Exception.CreateFmt('Field "%s" not found in source', [FldSrc])
      else
        aDestNode.Attr[FldDest].Value:= FieldSrc.Value;
    end;
  end;
end;

procedure BatchMoveFields(aDestNode, aSrcNode: TGvXmlNode; aMapping: String);
var
  FldSrc, FldDest: string;
  AttrSrc: TGvXmlAttribute;
begin
  aMapping:= ExpandMapping(aSrcNode, aMapping);
  while aMapping <> '' do
  begin
    ExtractMapPair(aMapping, FldDest, FldSrc);
    if FldSrc[1] = '"' then
      aDestNode.Attr[FldDest].AsString:= CopyBetween(FldSrc, '"', '"')
    else
    begin
      AttrSrc:= aSrcNode.Attr[FldSrc];
      if AttrSrc = nil then
//        raise Exception.CreateFmt('Field "%s" not found in source', [FldSrc])
      else
        aDestNode[FldDest]:= AttrSrc.AsString;
    end;
  end;
end;

procedure BatchMoveFields(aDestBuffer: PChar; aSrcNode: TGvXmlNode;
  aFieldDefs: TFieldDefs);
var
  i: Integer;
  FieldDef: TFieldDef;
  ofs, len: Word;
begin
  ofs:= 0;
  for i:= 0 to aFieldDefs.Count-1 do
  begin
    FieldDef:= aFieldDefs[i];
    case FieldDef.DataType of
      ftInteger:
        begin
          len:=4;
          if aSrcNode.HasAttribute(FieldDef.Name) then
          Move(aDestBuffer^, Integer(
        end;
    end;
  end;
end;
procedure BatchMoveFields(aDestNode: TGvXmlNode; aSrcBuffer: PChar;
  aFieldDefs: TFieldDefs);
begin

end;



procedure BatchMove(aDestNode: TGvXmlNode; aSrcDataSet: TDataSet;
  aRowNodeName: String; aMapping: String; aAppendMode: TAppendMode);
var
  ndDest: TGvXmlNode;
  St, FldSrc, FldDest: String;
  Node: TGvXmlNode;
begin
  if aAppendMode <> amAppend then
  begin
    St:= aMapping;
    ExtractMapPair(St, FldDest, FldSrc);
  end;
  if aAppendMode = amReplace then
    aDestNode.ChildNodes.Clear
  else
    aDestNode.ChangeChildsState(aRowNodeName, [stChanged], stNone);
  aSrcDataSet.DisableControls;
  try
    aSrcDataSet.First;
    while not aSrcDataSet.Eof do
    begin
      if aAppendMode = amAppend then
        ndDest:= aDestNode.AddChild(aRowNodeName)
      else
        ndDest:= aDestNode.FindOrCreate(aRowNodeName, FldDest, aSrcDataSet[FldSrc]);
      if ndDest.State = stNone then
      begin
        ndDest.State:= stChanged;
        BatchMoveFields(ndDest, aSrcDataSet, aMapping);
      end;
      aSrcDataSet.Next;
    end;
    if aAppendMode = amMerge then
      aDestNode.DeleteChildsByState(aRowNodeName, [stNone]);
    aDestNode.ChangeChildsState(aRowNodeName, [stChanged], stNone);
  finally
    aSrcDataSet.EnableControls;
  end;
end;

procedure BatchMove(aDestDataSet: TDataSet; aSrcNode: TGvXmlNode; aRowNodeName: String;
  aMapping: String; aAppendMode: TAppendMode);
var
  ndDest: TGvXmlNode;
  St, FldSrc, FldDest: String;
  Node: TGvXmlNode;
{$IFNDEF VER230}
  i: Integer;
{$ENDIF}
begin
  if aAppendMode <> amAppend then
  begin
    St:= aMapping;
    ExtractMapPair(St, FldDest, FldSrc);
  end;
  aDestDataSet.DisableControls;
  try
{$IFDEF VER230}
    for Node in aSrcNode.ChildNodes do
    begin
{$ELSE}
    for i:= 0 to aSrcNode.ChildNodes.Count-1 do
    begin
      Node:= aSrcNode.ChildNodes[i];
{$ENDIF}
      if aAppendMode = amAppend then
        aDestDataSet.Append
      else
        aDestDataSet.Edit;
      BatchMoveFields(aDestDataSet, Node, aMapping);
    end;
  finally
    aDestDataSet.EnableControls;
  end;
end;


procedure BatchMove(aDestNode, aSrcNode: TGvXmlNode;
  aRowNodeName: String; aMapping: String; aAppendMode: TAppendMode = amReplace); overload;
var
  ndDest: TGvXmlNode;
  St, FldSrc, FldDest: String;
  Node: TGvXmlNode;
{$IFNDEF VER230}
  i: Integer;
{$ENDIF}
begin
  if aAppendMode <> amAppend then
  begin
    St:= aMapping;
    ExtractMapPair(St, FldDest, FldSrc);
  end;
  if aAppendMode = amReplace then
    aDestNode.ChildNodes.Clear
  else
    aDestNode.ChangeChildsState(aRowNodeName, [stChanged], stNone);
{$IFDEF VER230}
  for Node in aSrcNode.ChildNodes do
  begin
{$ELSE}
  for i:= 0 to aSrcNode.ChildNodes.Count-1 do
  begin
    Node:= aSrcNode.ChildNodes[i];
{$ENDIF}
    if aAppendMode = amAppend then
      ndDest:= aDestNode.AddChild(aRowNodeName)
    else
      ndDest:= aDestNode.FindOrCreate(aRowNodeName, FldDest, Node.AttributeValue[FldDest]);
    if ndDest.State = stNone then
    begin
      ndDest.State:= stChanged;
      BatchMoveFields(ndDest, Node, aMapping);
    end;
  end;
  if aAppendMode = amMerge then
    aDestNode.DeleteChildsByState(aRowNodeName, [stNone]);
  aDestNode.ChangeChildsState(aRowNodeName, [stChanged], stNone);
end;


function DataSet2Attr(aSrcDataSet: TDataSet; aFieldNames: string; aDestNode: TGvXmlNode = nil): TGvXmlNode;
begin
  if aDestNode=nil then
    Result:= TGvXmlNode.Create
  else
    Result:= aDestNode;
  BatchMoveFields(Result, aSrcDataSet, aFieldNames);
end;

function XmlAttrs2Attr(aSrcNode: TGvXmlNode; aAttrNames: string; aDestNode: TGvXmlNode = nil): TGvXmlNode;
begin
  if aDestNode=nil then
    Result:= TGvXmlNode.Create
  else
    Result:= aDestNode;
  BatchMoveFields(Result, aSrcNode, aAttrNames);
end;

function Strings2Attr(aSrcStrings: TStrings; aAttrNames: string; aDestNode: TGvXmlNode = nil): TGvXmlNode;
var
  NameTo: string;
  Index: Integer;
begin
  if aDestNode=nil then
    Result:= TGvXmlNode.Create
  else
    Result:= aDestNode;
  While aAttrNames <> '' do
  begin
    NameTo:= TakeFront5(aAttrNames,' ;,');
    Index:= StrToInt(TakeBack5(NameTo, '='));
    if Index < aSrcStrings.Count then
      aDestNode.Attr[NameTo].AsString:= aSrcStrings[index];
  end;
end;

function Value2Attr(aValue: Variant; aAttrName: string; aDestNode: TGvXmlNode = nil): TGvXmlNode;
begin
  if aDestNode=nil then
    Result:= TGvXmlNode.Create
  else
    Result:= aDestNode;
  Result.Attr[aAttrName].Value:= aValue;
end;

end.
