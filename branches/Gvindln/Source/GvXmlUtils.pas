unit GvXmlUtils;

interface

uses
  GvXml, DB;


procedure BatchMoveFields(aDestNode: TGvXmlNode; aSrcDataSet: TDataSet;
  aMapping: String);

procedure BatchMove(aDestNode: TGvXmlNode; aSrcDataSet: TDataSet;
  aRowNodeName: String; aMapping: String);

implementation

uses
  GvStr, SysUtils;


procedure BatchMoveFields(aDestNode: TGvXmlNode; aSrcDataSet: TDataSet;
  aMapping: String);
var
  FldSrc, FldDest: string;
  FieldSrc: TField;
begin
  while aMapping <> '' do
  begin
    FldSrc:= TakeFront5(aMapping, ';');
    FldDest:= TakeFront5(FldSrc, '=');
    if FldSrc = '' then FldSrc:= FldDest;
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


procedure BatchMove(aDestNode: TGvXmlNode; aSrcDataSet: TDataSet;
  aRowNodeName: String; aMapping: String);
begin
  aSrcDataSet.DisableControls;
  try
    aSrcDataSet.First;
    while not aSrcDataSet.Eof do
    begin
      BatchMoveFields(aDestNode.AddChild(aRowNodeName), aSrcDataSet, aMapping);
      aSrcDataSet.Next;
    end;
  finally
    aSrcDataSet.EnableControls;
  end;
end;

end.
