unit GvXml;

interface

uses
  Classes, Generics.Defaults, Generics.Collections, Variants;

type
  TGvXmlNodeList = class;
  TGvXml = class;

  TGvXmlAttribute = class(TObject)
  private
    FValue: String;
    function GetAsBoolean: Boolean;
    function GetAsDateTime: TDateTime;
    function GetAsInteger: Integer;
    function GetAsFloat: Double;
    procedure SetAsInteger(const Value: Integer);
    procedure SetAsBoolean(const Value: Boolean);
    procedure SetAsDateTime(const Value: TDateTime);
    procedure SetAsFloat(const Value: Double);
  public
    Name: String; // Attribute name
    procedure SetValue(Value: Variant);
    function AsIntegerDef(DefaultValue: Integer): Integer;
    function AsStringDef(DefaultValue: String): String;
    function AsBooleanDef(DefaultValue: Boolean): Boolean;
    function AsDateTimeDef(DefaultValue: TDateTime): TDateTime;
    function AsFloatDef(DefaultValue: Double): Double;
    property AsString: String read FValue write FValue;
    property AsInteger: Integer read GetAsInteger write SetAsInteger;
    property AsBoolean: Boolean read GetAsBoolean write SetAsBoolean;
    property AsDateTime: TDateTime read GetAsDateTime write SetAsDateTime;
    property AsFloat: Double read GetAsFloat write SetAsFloat;
  end;

  TGvXmlAttributeList = class(TObjectList<TGvXmlAttribute>)
  public
    // Find an Attribute by Name (not case sensitive)
    function Find(aAttrName: String): TGvXmlAttribute;
  end;

  TGvXmlNode = class(TObject)
  private
    FAttributes: TGvXmlAttributeList;
    function GetAttrValue(const AttrName: String): variant;
    procedure SetAttrValue(const AttrName: String; Value: variant);
    function GetAttribute(const aAttrName: String): TGvXmlAttribute;
    function AttributeAdd(const aAttrName: String): TGvXmlAttribute;
  protected
    procedure ReadFromString(aLine: string; aLen: Integer; var aIdx: integer);
  public
    Document: TGvXml;
    Parent: TGvXmlNode; // NIL only for Root-Node
    NodeName: String; // Node name
    Text: WideString; // Node text
    ChildNodes: TGvXmlNodeList; // Child nodes, never NIL
    EndTerminator: Char;
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Clear;
    function Find(aNodeName: String): TGvXmlNode; overload;
    function Find(aNodeName, aAttrName: String): TGvXmlNode; overload;
    function Find(aNodeName, aAttrName, aAttrValue: String): TGvXmlNode; overload;
    // Find or Create a childnode by its name
    function FindOrCreate(aNodeName: String): TGvXmlNode; overload;
    function FindOrCreate(aNodeName, aAttrName: String): TGvXmlNode; overload;
    function FindOrCreate(aNodeName, aAttrName: String; aAttrValue: variant): TGvXmlNode; overload;
    // Return a list of childodes with given Name/Attribute
    function FindNodes(aNodeName: String): TGvXmlNodeList; virtual;
    // Returns True if the Attribute exits
    function HasAttribute(const aNodeName: String): Boolean; virtual;
    // Add a child node and return it
    function AddChild(const aNodeName: String): TGvXmlNode; virtual;
    function SetText(aValue: String): TGvXmlNode; virtual;
    function Attribute(const aAttrName: String;
      const aAttrValue: variant): TGvXmlNode; virtual;
    procedure ReadAttributes(Tag: string; var IsEmpty: Boolean);
    procedure LoadFromString(aStr: string);
    function WriteToString(aReadable: Boolean = false; aLevel: integer = 0): string;
    procedure ImportAttrs(aStringList: TStringList);
    procedure ExportAttrs(aStringList: TStringList);
    property AttributeValue[const aAttrName: String]: Variant read GetAttrValue
      write SetAttrValue; default;
    property Attr[const aAttrName: string]: TGvXmlAttribute read GetAttribute;
  end;

  TGvXmlNodeList = class(TObjectList<TGvXmlNode>);

  TGvXml = class(TObject)
  private
    procedure Parse(Line: string);
  public
    Root: TGvXmlNode; // There is only one Root Node
    Header: TGvXmlNode; // XML declarations are stored in here as Attributes
    constructor Create; overload; virtual;
    constructor Create(const aFileName: string); overload; virtual;
    destructor Destroy; override;
    procedure Clear; virtual;
    // Load XML from a file
    procedure LoadFromFile(const aFileName: String); virtual;
    // Load XML for a stream
    procedure LoadFromStream(const aStream: TStream); virtual;
    // Encoding is specified in Header-Node
    procedure SaveToStream(const aStream: TStream); virtual;
    procedure SaveToFile(const aFileName: String); virtual;
  end;

implementation

uses
  SysUtils, StrUtils, GvStr;

{ TGvXml }

procedure SkipSpaces(aStr: String; aLen: Integer; var aIdx: Integer);
begin
  while (aIdx<aLen) and (Pos(aStr[aIdx], ' '#9#13#10)>0) do Inc(aIdx);
end;

function Copy_3(St: WideString; KeyChars: WideString; aLen: Integer;
  var aIdx: Integer): WideString;
var
  P: Integer;
begin
  P:= aIdx;
  While (aIdx<=aLen) and (Pos(St[aIdx], KeyChars)=0) do inc(aIdx);
  While (aIdx<=aLen) and (Pos(St[aIdx], KeyChars)>0) do inc(aIdx);
  result:= Copy(St, P, aIdx-P);
end;

function Copy_4(St: WideString; KeyChars: WideString; aLen: Integer;
  var aIdx: Integer): WideString;
var
  P: Integer;
begin
  P:= aIdx;
  While (aIdx<=aLen) and (Pos(St[aIdx], KeyChars)=0) do inc(aIdx);
  result:= Copy(St, P, aIdx-P);
end;

function Copy_5(St: WideString; KeyChar: WideString; aLen: Integer;
  var aIdx: Integer): WideString;
var
  P: Integer;
begin
  P:= aIdx;
  While (aIdx<=aLen) and (Pos(St[aIdx], KeyChar)=0) do inc(aIdx);
  result:= Copy(St, P, aIdx-P);
  While (aIdx<=aLen) and (Pos(St[aIdx], KeyChar)>0) do inc(aIdx);
end;

procedure TGvXml.Clear;
begin
  Root.Free;
  Header.Free;
  Root := TGvXmlNode.Create;
  Root.Document:= self;
  Header := TGvXmlNode.Create;
  Header.Document:= self;
  Header.NodeName := '?xml'; // Default XML Header
  Header['version'] := '1.0'; // Default XML Version
  Header.EndTerminator:= '?';
end;

constructor TGvXml.Create;
begin
  inherited;
  Clear;
end;

constructor TGvXml.Create(const aFileName: string);
begin
  Create;
  if FileExists(aFileName) then
    LoadFromFile(aFileName);
end;

destructor TGvXml.Destroy;
begin
  Root.Free;
  Header.Free;
  inherited;
end;

procedure TGvXml.LoadFromFile(const aFileName: String);
var
  Lines: TStringList;
begin
  Clear;
  Lines:= TStringList.Create;
  try
    Lines.LoadFromFile(aFileName);
    Parse(Lines.Text);
  finally
    Lines.Free;
  end;
end;

procedure TGvXml.LoadFromStream(const aStream: TStream);
var
  Lines: TStringList;
begin
  Clear;
  Lines:= TStringList.Create;
  try
    Lines.LoadFromStream(aStream);
    Parse(Lines.Text);
  finally
    Lines.Free;
  end;
end;

procedure TGvXml.Parse(Line: string);
var
  Idx, Len, P: integer;
  HeaderStr: string;
  IsEmpty: Boolean;
begin
  Idx:= 1;
  Len:= Length(Line);
  SkipSpaces(Line, Len, Idx);
  if Line[Idx+1] = '?' then
  begin
    Inc(Idx, 2);
    HeaderStr:= '<?'+Copy_5(Line, '?>', Len, Idx)+'>';
    Header.ReadAttributes(HeaderStr, IsEmpty);
  end;
  Copy_4(Line, '<', Len, Idx);
  if Line[idx] = '<' then
    Root.ReadFromString(Line, Len, Idx);
end;

procedure TGvXml.SaveToFile(const aFileName: String);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(aFileName, fmCreate);
  SaveToStream(Stream);
  Stream.Free;
end;

procedure TGvXml.SaveToStream(const aStream: TStream);
var
  Encoding: TEncoding;
  Lines: TStringList;
begin
  Encoding := TEncoding.Default;
  if lowercase(Header['encoding']) = 'utf-8' then
    Encoding := TEncoding.UTF8;
  Lines:= TStringList.Create;
  try
    Lines.Add(Header.WriteToString(True));
    Lines.Add(Root.WriteToString(True));
    Lines.SaveToStream(aStream, Encoding);
  finally
    Lines.Free;
  end;
end;

{ TGvXmlNode }

function TGvXmlNode.AddChild(const aNodeName: String): TGvXmlNode;
begin
  Result := TGvXmlNode.Create;
  Result.NodeName := aNodeName;
  Result.Parent := Self;
  Result.Document:= Document;
  ChildNodes.Add(Result);
end;

procedure TGvXmlNode.Clear;
begin
  ChildNodes.Clear;
  FAttributes.Clear;
end;

constructor TGvXmlNode.Create;
begin
  ChildNodes := TGvXmlNodeList.Create;
  Parent := NIL;
  FAttributes := TGvXmlAttributeList.Create;
  EndTerminator:= '/';
end;

destructor TGvXmlNode.Destroy;
begin
  FAttributes.Free;
  ChildNodes.Free;
  inherited;
end;

procedure TGvXmlNode.ExportAttrs(aStringList: TStringList);
var
  Att: TGvXmlAttribute;
begin
  for Att in FAttributes do
    aStringList.Values[Att.Name]:= Att.FValue;
end;

function TGvXmlNode.Find(aNodeName: String): TGvXmlNode;
var
  Node: TGvXmlNode;
begin
  Result := NIL;
  for Node in ChildNodes do
    if lowercase(Node.NodeName) = lowercase(aNodeName) then
    begin
      Result := Node;
      Break;
    end;
end;

function TGvXmlNode.Find(aNodeName, aAttrName, aAttrValue: String): TGvXmlNode;
var
  Node: TGvXmlNode;
begin
  Result := NIL;
  for Node in ChildNodes do
    if (lowercase(Node.NodeName) = lowercase(aNodeName)) and
       (Node.HasAttribute(aAttrName)) and
       (Node[aAttrName] = aAttrValue) then
    begin
      Result := Node;
      Break;
    end;
end;

function TGvXmlNode.Find(aNodeName, aAttrName: String): TGvXmlNode;
var
  Node: TGvXmlNode;
begin
  Result := NIL;
  for Node in ChildNodes do
    if (lowercase(Node.NodeName) = lowercase(aNodeName)) and
       (Node.HasAttribute(aAttrName)) then
    begin
      Result := Node;
      Break;
    end;
end;

function TGvXmlNode.FindNodes(aNodeName: String): TGvXmlNodeList;
var
  Node: TGvXmlNode;
begin
  Result := TGvXmlNodeList.Create(False);
  for Node in ChildNodes do
    if (lowercase(Node.NodeName) = lowercase(aNodeName)) then
      Result.Add(Node);
end;

function TGvXmlNode.FindOrCreate(aNodeName, aAttrName: String): TGvXmlNode;
begin
  Result:= Find(aNodeName, aAttrName);
  if Result = nil then
    Result:= AddChild(aNodeName);
end;

function TGvXmlNode.FindOrCreate(aNodeName, aAttrName: String; aAttrValue: variant): TGvXmlNode;
begin
  Result:= Find(aNodeName, aAttrName, aAttrValue);
  if Result = nil then
    Result:= AddChild(aNodeName).Attribute(aAttrName, aAttrValue);
end;

function TGvXmlNode.FindOrCreate(aNodeName: String): TGvXmlNode;
begin
  Result:= Find(aNodeName);
  if Result = nil then
    Result:= AddChild(aNodeName);
end;

function TGvXmlNode.GetAttribute(const aAttrName: string): TGvXmlAttribute;
begin
  Result:= FAttributes.Find(aAttrName);
  if Not assigned(Result) then
    Result:= AttributeAdd(aAttrName);
end;

function TGvXmlNode.GetAttrValue(const AttrName: String): Variant;
var
  Attribute: TGvXmlAttribute;
begin
  Attribute := FAttributes.Find(AttrName);
  if assigned(Attribute) then
    Result := Attribute.AsString
  else
    Result := '';
end;

function TGvXmlNode.HasAttribute(const aNodeName: String): Boolean;
begin
  Result := assigned(FAttributes.Find(aNodeName));
end;

procedure TGvXmlNode.ImportAttrs(aStringList: TStringList);
var
  i: Integer;
begin
  for i := 0 to aStringList.Count-1 do
    AttributeValue[aStringList.Names[i]]:= aStringList.ValueFromIndex[i];
end;

procedure TGvXmlNode.LoadFromString(aStr: string);
var
  Len, Idx: integer;
begin
  Len:= Length(aStr);
  Idx:= 1;
  ReadFromString(aStr, Len, Idx);
end;

procedure TGvXmlNode.ReadAttributes(Tag: string; var isEmpty: Boolean);
var
  idx, j, ii, p, Len: integer;
  AttrName, AttrValue: String;
begin
  isEmpty:= false;
  idx:= 2;
  Len:= Length(Tag);
  NodeName:= Copy_4(Tag, ' >/'#9#10#13, Len, idx);
  SkipSpaces(Tag, Len, idx);
  while idx < Len do
  begin
    if (Tag[idx]='/') or (Tag[idx] = '>') then
    begin
      IsEmpty:= Tag[idx] = '/';
      Exit;
    end;
    AttrName:= Copy_5(Tag, '= ', Len, idx);
    inc(idx);
    Attr[AttrName].AsString:= Copy_5(Tag, '"', Len, idx);
    SkipSpaces(Tag, Len, idx);
  end;
end;

procedure TGvXmlNode.ReadFromString(aLine: string; aLen: integer; var aIdx: integer);
var
  j: integer;
  IsEmpty: Boolean;
  Len: Integer;
  Tag: String;
  Node: TGvXmlNode;
begin
  Clear;
  SkipSpaces(aLine, aLen, aIdx);
  if aLine[aIdx] <> '<' then
    raise Exception.CreateFmt('Error Parsing Xml at Offset %u', [aIdx]);
  if aLine[aIdx+1] = '!' then // This Node is Comment
  begin
    NodeName:= '';
    Inc(aIdx, 4);
    j:= PosEx('-->', aLine, aIdx);
    Text:= Copy(aLine, aIdx, j-aIdx);
    aIdx:= j+3;
  end
  else
  begin
    Tag:= Copy_3(aLine, '>', aLen, aIdx);
    ReadAttributes(Tag, IsEmpty);
    if IsEmpty then Exit;
    SkipSpaces(aLine, aLen, aIdx);
    Tag:= Copy_4(aLine, '<', aLen, aIdx);
    Text:= SkipBack(Tag, ' '#9#10#13);
    repeat
      if (aLine[aIdx+1] = '/') then
      begin
        Tag:= Copy_3(aLine, '>', aLen, aIdx);
        j:= 3;
        Tag:= Copy_4(Tag, ' >', Length(Tag), j);
        if LowerCase(Tag) = LowerCase(NodeName) then
          Exit
        else
          raise Exception.CreateFmt('Error Parsing Xml at Offset %u', [aIdx]);
      end;
      Node:= AddChild('');
      Node.ReadFromString(aLine, aLen, aIdx);
      SkipSpaces(aLine, aLen, aIdx);
    until aIdx >= aLen;
  end;
end;

function TGvXmlNode.AttributeAdd(const aAttrName: String): TGvXmlAttribute;
begin
  Result:= TGvXmlAttribute.Create;
  Result.Name:= aAttrName;
  FAttributes.Add(Result);
end;

function TGvXmlNode.Attribute(const aAttrName: String; const aAttrValue: Variant): TGvXmlNode;
var
  Att: TGvXmlAttribute;
begin
  Att:= FAttributes.Find(aAttrName); // Search for given name
  if not assigned(Att) then // If attribute is not found, create one
    Att:= AttributeAdd(aAttrName);
  Att.SetValue(aAttrValue);
  Result := Self;
end;

procedure TGvXmlNode.SetAttrValue(const AttrName: String; Value: variant);
begin
  Attribute(AttrName, Value);
end;

function TGvXmlNode.SetText(aValue: String): TGvXmlNode;
begin
  Text := aValue;
  Result := Self;
end;

function TGvXmlNode.WriteToString(aReadable: Boolean = false; aLevel: integer = 0): string;
var
  Lines: TStringList;
  Attribute: TGvXmlAttribute;
  Child: TGvXmlNode;
function Ident: string;
begin
  if aReadable then
    Result:= StringOfChar(' ', aLevel*2)
  else
    Result:= '';
end;

function EOL: string;
begin
  if aReadable then
    Result:= #13#10
  else
    Result:= '';
end;

begin
  if NodeName='' then
    Result:= Ident+'<!--'+Text+'-->'
  else
  begin
    Result:= Ident + '<'+NodeName;
    for Attribute in FAttributes do
      Result:= Result + ' '+Attribute.Name+'="'+Attribute.AsString+'"';
    if (Text = '') and (ChildNodes.Count = 0) then
      Result:= Result + EndTerminator+'>'+EOL
    else
    if (Text <> '') and (ChildNodes.Count = 0) then
      Result:= Result +'>'+Text+'</'+NodeName+'>'+EOL
    else
    begin
      Result:= Result +'>'+Text+EOL;
      for Child in ChildNodes do
         Result:= Result+Child.WriteToString(aReadable, aLevel+1);
      Result:= Result + Ident+'</'+NodeName+'>'+EOL;
    end;
  end;
end;

{ TGvXmlAttributeList }

function TGvXmlAttributeList.Find(aAttrName: String): TGvXmlAttribute;
var
  Attribute: TGvXmlAttribute;
begin
  Result := NIL;
  for Attribute in Self do
    if lowercase(Attribute.Name) = lowercase(aAttrName) then
    begin
      Result := Attribute;
      Break;
    end;
end;

{ TGvXmlAttribute }

function TGvXmlAttribute.AsBooleanDef(DefaultValue: Boolean): Boolean;
begin
  if FValue = '' then
  begin
    AsBoolean:= DefaultValue;
    Result:= DefaultValue;
  end
  else
    Result:= GetAsBoolean;
end;

function TGvXmlAttribute.AsDateTimeDef(DefaultValue: TDateTime): TDateTime;
begin
  if FValue = '' then
  begin
    AsDateTime:= DefaultValue;
    Result:= DefaultValue;
  end
  else
    Result:= GetAsDateTime;
end;

function TGvXmlAttribute.AsFloatDef(DefaultValue: Double): Double;
begin
  if FValue = '' then
  begin
    AsFloat:= DefaultValue;
    Result:= DefaultValue;
  end
  else
    Result:= GetAsFloat;
end;

function TGvXmlAttribute.AsIntegerDef(DefaultValue: Integer): Integer;
begin
  if FValue = '' then
  begin
    AsInteger:= DefaultValue;
    Result:= DefaultValue;
  end
  else
    Result:= GetAsInteger;
end;

function TGvXmlAttribute.AsStringDef(DefaultValue: String): String;
begin
  if FValue = '' then
  begin
    FValue:= DefaultValue;
    Result:= DefaultValue;
  end
  else
    Result:= FValue;
end;

function TGvXmlAttribute.GetAsBoolean: Boolean;
begin
  Result:= FValue <> '0';
end;

function TGvXmlAttribute.GetAsDateTime: TDateTime;
var
  AYear, AMonth, ADay, AHour, AMin, ASec, AMSec: word;
begin
  AYear  := StrToInt(copy(FValue, 1, 4));
  AMonth := StrToInt(copy(FValue, 6, 2));
  ADay   := StrToInt(copy(FValue, 9, 2));
  if Length(FValue) > 16 then
  begin
    AHour := StrToInt(copy(FVAlue, 12, 2));
    AMin  := StrToInt(copy(FVAlue, 15, 2));
    ASec  := StrToIntDef(copy(FValue, 18, 2), 0); // They might be omitted, so default to 0
    AMSec := StrToIntDef(copy(FValue, 21, 3), 0); // They might be omitted, so default to 0
  end else
  begin
    AHour := 0;
    AMin  := 0;
    ASec  := 0;
    AMSec := 0;
  end;
  Result :=
    EncodeDate(AYear, AMonth, ADay) +
    EncodeTime(AHour, AMin, ASec, AMSec);
end;

function TGvXmlAttribute.GetAsFloat: Double;
begin
  Result:= StrToFloat(FValue);
end;

function TGvXmlAttribute.GetAsInteger: Integer;
begin
  Result:= StrToInt(FValue);
end;

procedure TGvXmlAttribute.SetAsBoolean(const Value: Boolean);
begin
  FValue:= IfThen(Value, '1', '0')
end;

procedure TGvXmlAttribute.SetAsDateTime(const Value: TDateTime);
begin
  FValue:= FormatDateTime('YYYY-MM-DDTHH:NN:SS', Value)
end;

procedure TGvXmlAttribute.SetAsFloat(const Value: Double);
begin
  FValue:= FloatToStrF(Value, ffGeneral, 5, 15);
end;

procedure TGvXmlAttribute.SetAsInteger(const Value: Integer);
begin
  FValue:= IntToStr(Value);
end;

procedure TGvXmlAttribute.SetValue(Value: Variant);
begin
  if VarType(Value) = varUString then
    FValue:= Value
  else
  if VarType(Value) = varString then
    FValue:= Value
  else
  if VarType(Value) = varDate then
    AsDateTime:= Value
  else
  if VarType(Value) in [varByte, varSmallInt, varInteger, varInt64] then
    AsInteger:= Value
  else
  if VarType(Value) = varBoolean then
    AsBoolean:= Value
  else
  if VarType(Value) in [varSingle, varDouble] then
    AsFloat:= Value;
end;

end.
