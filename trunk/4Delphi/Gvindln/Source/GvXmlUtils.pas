unit GvXmlUtils;

interface

uses
  GvXml, DB;

type
  TAppendMode = (amReplace, amAppend, amMerge);

function ExpandMapping(aNode: TGvXmlNode; aMapping: String = '*'): String; overload;


procedure BatchMoveFields(aDestNode: TGvXmlNode; aSrcDataSet: TDataSet;
  aMapping: String); overload;

procedure BatchMoveFields(aDestNode, aSrcNode: TGvXmlNode; aMapping: String); overload;

procedure BatchMove(aDestNode: TGvXmlNode; aSrcDataSet: TDataSet;
  aRowNodeName: String; aMapping: String; aAppendMode: TAppendMode = amReplace); overload;

procedure BatchMove(aDestNode, aSrcNode: TGvXmlNode;
  aRowNodeName: String; aMapping: String; aAppendMode: TAppendMode = amReplace); overload;

implementation

uses
  Classes, GvStr, SysUtils;

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
      for Attr in aNode.Attributes do
        if (sl.IndexOfName(Attr.Name) < 0) and (sl.IndexOf(Attr.Name) < 0) then
          sl.Add(Attr.Name);
    end;
    Result:= sl.DelimitedText;
  finally
    sl.Free;
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

procedure BatchMove(aDestNode, aSrcNode: TGvXmlNode; aRowNodeName: String;
  aMapping: String; aAppendMode: TAppendMode);
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
  for Node in aSrcNode.ChildNodes do
  begin
    if aAppendMode = amAppend then
      ndDest:= aDestNode.AddChild(aRowNodeName)
    else
      ndDest:= aDestNode.FindOrCreate(aRowNodeName, FldDest, Node[FldSrc]);
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


end.
