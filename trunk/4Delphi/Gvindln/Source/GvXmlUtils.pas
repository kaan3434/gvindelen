unit GvXmlUtils;

interface

uses
  GvXml, DB;

procedure BatchMoveFields(aDestNode: TGvXmlNode; aSrcDataSet: TDataSet;
  aMapping: String);

implementation

uses
  GvStr, SysUtils.Excetions;

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
      if FieldSrc.DataType in [ftFloat] then
        SetXmlAttrAsFloat(aDestNode, FldDest, FieldSrc.Value, aMandatory)
      else
        SetXmlAttr(aDestNode, FldDest, FieldSrc.Value, aMandatory);
    end;
  end;
end;

end.
