unit GvXml;

interface

{$I Gvindln.inc}

uses
  Classes, Contnrs,
  {$IFDEF D_XE2}
  Generics.Defaults, Generics.Collections,
  {$ENDIF}
  Variants, SysUtils;

type
  TGvXmlNodeList = class;
  TGvXml = class;
  TGvXmlNode = class;
  TGvNodeState = (stNone, stChanged, stSelected);
  TGvNodeStateSet = Set of TGvNodeState;

  EAttrNotExists = class(Exception);

  ENodeException = class(Exception);
  ENodeNotExists = class(ENodeException);

  TGvXmlAttribute = class(TObject)
  private
    FNameSpace: String;
    FName: String; // Attribute name
    FValue: String;
    FOwner: TGvXmlNode;
    function GetAsBoolean: Boolean;
    function GetAsDateTime: TDateTime;
    function GetAsInteger: Integer;
    function GetAsFloat: Double;
    procedure SetAsInteger(const aValue: Integer);
    procedure SetAsBoolean(const aValue: Boolean);
    procedure SetAsDateTime(const aValue: TDateTime);
    procedure SetAsFloat(const aValue: Double);
    procedure SetAsVariant(const aValue: Variant);
    function GetAsVariant: variant;
    function GetFullName: String;
    procedure SetName(const Value: String);
    procedure SetFullName(const Value: String);
    function GetAsMoney: Currency;
    procedure SetAsMoney(const Value: Currency);
    function GetAsString: String;
    procedure SetAsString(const Value: String);
  public
    constructor Create(AOwner: TGvXmlNode);
    function AsIntegerDef(DefaultValue: Integer): Integer;
    function AsStringDef(DefaultValue: String): String;
    function AsBooleanDef(DefaultValue: Boolean): Boolean;
    function AsDateTimeDef(DefaultValue: TDateTime): TDateTime;
    function AsFloatDef(DefaultValue: Double): Double;
    function AsMoneyDef(DefaultValue: Currency): Currency;
    function ValueIn(aAttrValues: array of Variant): Boolean;
    property Name: String read FName write SetName;
    property FullName: String read GetFullName write SetFullName;
    property AsString: String read GetAsString write SetAsString;
    property AsInteger: Integer read GetAsInteger write SetAsInteger;
    property AsBoolean: Boolean read GetAsBoolean write SetAsBoolean;
    property AsDateTime: TDateTime read GetAsDateTime write SetAsDateTime;
    property AsFloat: Double read GetAsFloat write SetAsFloat;
    property AsMoney: Currency read GetAsMoney write SetAsMoney;
    property Value: variant read GetAsVariant write SetAsVariant;
  end;

  TGvXmlAttributeList = class(TObjectList)
  private
    function GetAttrByIndex(aIndex: Integer): TGvXmlAttribute;
  public
    function Find(aAttrName: String): TGvXmlAttribute;
    property Items[aIndex: Integer]: TGvXmlAttribute read GetAttrByIndex; default;
  end;

  TGvXmlNode = class(TObject)
  private
    FAttributes: TGvXmlAttributeList;
    FNodeName: String;
    FStates: TGvNodeStateSet;
    FChanged: boolean;
    FValue: String; // Node text
    function GetAttrValue(const aAttrName: String): variant;
    function GetAttrValueOrSet(const aAttrName, aAttrValue: String): Variant;
    procedure SetAttrValue(const aAttrName: String; aValue: variant);
    function GetAttribute(const aAttrName: String): TGvXmlAttribute;
    function AttributeAdd(const aAttrName: string; const aAttrValue: string): TGvXmlAttribute; overload;
    function AttributeAdd(const aAttrName: String; const aAttrValue: Variant): TGvXmlAttribute; overload;
    function GetFullNodeName: String;
    procedure SetNodeName(const Value: String);
    procedure SetFullNodeName(const Value: String);
    function GetNodeByIndex(const aIndex: Integer): TGvXmlNode;
    function GetAttrOrChildValue(const Name: String): Variant;
    procedure SetAttrOrChildValue(const aName: String; const aValue: Variant);
    function GetAttrValueDef(const aAttrName: String;
      aValueDef: variant): Variant;
    function GetAsString: String;
    function GetAsVariant: Variant;
    procedure SetAsString(const aValue: String);
    procedure SetAsVariant(const aValue: Variant);
  protected
    procedure ReadFromString(aLine: string; aLen: Integer; var aIdx: integer);
  public
    Document: TGvXml;
    Parent: TGvXmlNode; // NIL only for Root-Node
    NameSpace: String;
    ChildNodes: TGvXmlNodeList; // Child nodes, never NIL
    EndTerminator: Char;
    constructor Create(aNodeName: string); overload;
    constructor Create; overload; virtual;
    destructor Destroy; override;
    procedure Clear;
    function Find(aNodeName: String): TGvXmlNode; overload;
    function Find(aNodeName, aAttrName: String): TGvXmlNode; overload;
    function Find(aNodeName, aAttrName, aAttrValue: String): TGvXmlNode; overload;
    function Find(aNodeName, aAttrNames: string; aAttrValues: array of Variant): TGvXmlNode; overload;
    // Find or Create a childnode by its name
    function FindOrCreate(aNodeName: String): TGvXmlNode; overload;
    function FindOrCreate(aNodeName, aAttrName: String): TGvXmlNode; overload;
    function FindOrCreate(aNodeName, aAttrName: String; aAttrValue: variant): TGvXmlNode; overload;
    // Return a list of childodes with given Name/Attribute
    function FindNodes(aNodeName: String; aStates: TGvNodeStateSet = []): TGvXmlNodeList; virtual;
    // Returns True if the Attribute exits
    function HasAttribute(const aNodeName: String): Boolean; virtual;
    // Add a child node and return it
    function AddChild(const aNodeName: String; aValue: String = ''): TGvXmlNode; virtual;
    function SetText(aValue: String): TGvXmlNode; virtual;
    function Attribute(const aAttrName: String;
      const aAttrValue: variant): TGvXmlNode; virtual;
    procedure ReadAttributes(Tag: string; var IsEmpty: Boolean);
    procedure LoadFromString(aStr: string);
    function WriteToString(aReadable: Boolean = false; aLevel: integer = 0): string;
    procedure ImportAttrs(aStringList: TStringList);
    procedure ExportAttrs(aStringList: TStringList);
    function NodeCount: Integer;
    procedure DeleteChildsByState(aNodeName: String; aStates: TGvNodeStateSet);
    procedure ChangeChildsState(aNodeName: String; aStates: TGvNodeStateSet; aNewState: TGvNodeState);
    function IndexInParent: integer;
    procedure Assign(const aXmlNode: TGvXmlNode);
    procedure AttrDelete(const aAttribute: TGvXmlAttribute);
    function NodeByPath(aXPath: String): TGvXmlNode;
    function HasState(const aState: TGvNodeState): boolean;
    procedure SetState(const aState: TGvNodeState);
    procedure ClearState(const aState: TGvNodeState);
    procedure MarkChanged;

    property Attributes: TGvXmlAttributeList read FAttributes;
    property AttrOrChildValue[const Name: String]: Variant read GetAttrOrChildValue write SetAttrOrChildValue; default;
    property AttrValue[const aAttrName: String]: Variant read GetAttrValue
      write SetAttrValue;
    property AttrValueDef[const aAttrName: String; aAttrValueDef: variant]: Variant read GetAttrValueDef;
    property NodeName: String read FNodeName write SetNodeName;
    property FullNodeName: String read GetFullNodeName write SetFullNodeName;
    property Attr[const aAttrName: string]: TGvXmlAttribute read GetAttribute;
    property Nodes[const aIndex: Integer]: TGvXmlNode read GetNodeByIndex;
    property States: TGvNodeStateSet read FStates;
    property Changed: Boolean read FChanged;
    property AsString: String read GetAsString write SetAsString;
    property Value: Variant read GetAsVariant write SetAsVariant;
  end;

{$IFDEF D_XE2}
  TGvXmlNodeList = class(TObjectList<TGvXmlNode>);
{$ELSE}
  TGvXmlNodeList = class(TObjectList)
  private
    function GetItemByIndex(aIndex: Integer): TGvXmlNode;
  public
    property Items[aIndex: integer]: TGvXmlNode read GetItemByIndex; default;
  end;
{$ENDIF}

  TGvXml = class(TObject)
  private
    procedure Parse(Line: string);
  public
    Root: TGvXmlNode; // There is only one Root Node
    Header: TGvXmlNode; // XML declarations are stored in here as Attributes
    constructor Create; overload; virtual;
    constructor Create(const aRootNodeName: string; const aFileName: string = ''); overload; virtual;
    constructor CreateFromFile(const aFileName: string); virtual;
    destructor Destroy; override;
    procedure Clear; virtual;
    procedure LoadFromFile(const aFileName: String); virtual;
    procedure LoadFromStream(const aStream: TStream); virtual;
    procedure LoadFromString(const aText: string); virtual;
    // Encoding is specified in Header-Node
    function SaveToString: string; virtual;
    procedure SaveToStream(const aStream: TStream); virtual;
    procedure SaveToFile(const aFileName: String); virtual;
    procedure Assign(const aXml: TGvXml);
    function Changed: boolean;
  end;

  TGvXmlStorage = class(TComponent)
  private
    FXml: TGvXml;
    function GetAsText: String;
    procedure SetAsText(const Value: String);
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear; virtual;
    procedure LoadFromFile(const aFileName: String); virtual;
    procedure LoadFromStream(const aStream: TStream); virtual;
    procedure LoadFromString(const aText: string); virtual;
    procedure SaveToStream(const aStream: TStream); virtual;
    procedure SaveToFile(const aFileName: String); virtual;
    procedure Assign(const aXml: TGvXml);
    property Xml: TGvXml read FXml;
  published
    property Text: String read GetAsText write SetAsText;
  end;

procedure Register;

implementation

uses
  StrUtils, GvStr;

procedure Register;
begin
  RegisterComponents('Gvindelen', [TGvXmlStorage]);
end;

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

function Escape(aValue: string): string;
begin
  Result:= aValue;
  if Result <> '' then
  begin
    Result:= ReplaceAll(Result, '&', '&amp;', true);
    Result:= ReplaceAll(Result, '"', '&quot;', true);
    Result:= ReplaceAll(Result, '''', '&apos;', true);
    Result:= ReplaceAll(Result, '<', '&lt;', true);
    Result:= ReplaceAll(Result, '>', '&gt;', true);
  end;
end;

function UnEscape(aValue: string): string;
begin
  Result:= aValue;
  if Result <> '' then
  begin
    Result:= ReplaceAll(Result, '&gt;', '>');
    Result:= ReplaceAll(Result, '&lt;', '<');
    Result:= ReplaceAll(Result, '&apos;', '''');
    Result:= ReplaceAll(Result, '&quot;', '"');
    Result:= ReplaceAll(Result, '&amp;', '&');
  end;
end;


function VariantToString(const Value: Variant): string;
var
  v_varType: integer;
begin
  v_VarType:= VarType(Value);
  case VarType(Value) of
{$IFDEF D_XE2}
    varUString:
      Result:= Value;
{$ENDIF}
    varString:
      Result:= Value;
    varDate:
      Result:= ReplaceAll(FormatDateTime('YYYY-MM-DD HH:NN:SS', TDateTime(Value)), ' ', 'T');
    varByte, varSmallInt, varInteger, varInt64:
      Result:= IntToStr(Integer(Value));
    varBoolean:
      Result:= IfThen(Boolean(Value), '1', '0');
    varSingle, varDouble:
      Result:= FloatToStrF(Value, ffGeneral, 5, 15);
    varCurrency:
      Result:= CurrToStr(Value);
    varNull:
      Result:= '';
  else
    raise Exception.CreateFmt('Unsupperted data type %s', [Value]);
  end;
end;



function TGvXml.Changed: boolean;
begin
  Result:= Root.Changed;
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
  Header.AttributeAdd('version','1.0');
  Header.EndTerminator:= '?';
end;

constructor TGvXml.Create;
begin
  inherited;
  Clear;
end;

constructor TGvXml.Create(const aRootNodeName: string; const aFileName: string = '');
begin
  Create;
  Root.NodeName:= aRootNodeName;
  if FileExists(aFileName) then
    LoadFromFile(aFileName);
end;

constructor TGvXml.CreateFromFile(const aFileName: string);
begin
  inherited Create;
  if FileExists(aFileName) then
    LoadFromFile(aFileName)
  else
    Clear;
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

procedure TGvXml.LoadFromString(const aText: string);
begin
  Clear;
  Parse(aText);
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
    Header.Clear;
    Inc(Idx, 2);
    HeaderStr:= '<?'+Copy_5(Line, '?>', Len, Idx)+'>';
    Header.ReadAttributes(HeaderStr, IsEmpty);
  end;
  Copy_4(Line, '<', Len, Idx);
  if Line[idx] = '<' then
  begin
    Root.Clear;
    Root.ReadFromString(Line, Len, Idx);
  end;
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
{$IFNDEF D_XE2}
type
  TEncoding = (eAsIs, eUTF8);
{$ENDIF}
var
  Encoding: TEncoding;
  Lines: TStringList;
begin
{$IFDEF D_XE2}
  try
    Encoding := TEncoding.Default;
    if lowercase(Header.GetAttrValueOrSet('encoding', 'utf-8')) = 'utf-8' then
      Encoding := TEncoding.UTF8;
  except
    Encoding := TEncoding.UTF8;
  end;
{$ELSE}
  try
    if lowercase(Header.AttrValue['encoding']) = 'utf-8' then
      Encoding := eUTF8;
  except
    Encoding := eUTF8;
  end;
{$ENDIF}
  Lines:= TStringList.Create;
  try
    Lines.Text:=Header.WriteToString(True)+Root.WriteToString(True);
{$IFDEF D_XE2}
    Lines.SaveToStream(aStream, Encoding);
{$ELSE}
    case Encoding of
      eUTF8: Lines.Text:= AnsiToUtf8(Lines.Text);
    end;
    Lines.SaveToStream(aStream);
{$ENDIF}
  finally
    Lines.Free;
  end;
end;

procedure TGvXml.Assign(const aXml: TGvXml);
begin
  Clear;
  LoadFromString(aXml.Root.WriteToString);
end;

function TGvXml.SaveToString: string;
var
  Lines: TStringList;
begin
  Lines:= TStringList.Create;
  try
    Lines.Add(Header.WriteToString(True));
    Lines.Add(Root.WriteToString(True));
    Result:= Lines.Text;
  finally
    Lines.Free;
  end;
end;

{ TGvXmlNode }

function TGvXmlNode.AddChild(const aNodeName: String; aValue: String = ''): TGvXmlNode;
begin
  Result := TGvXmlNode.Create(aNodeName);
  Result.Parent := Self;
  Result.Document:= Document;
  Result.AsString:= aValue;
  ChildNodes.Add(Result);
end;

procedure TGvXmlNode.ChangeChildsState(aNodeName: String;
  aStates: TGvNodeStateSet; aNewState: TGvNodeState);
var
  Node: TGvXmlNode;
  Nodes: TGvXmlNodeList;
  i: Integer;
begin
  Nodes := FindNodes(aNodeName, aStates);
  for i:= 0 to Nodes.Count - 1 do
  begin
    Node:= TGvXmlNode(Nodes[i]);
    Node.SetState(aNewState);
  end;
end;

function TGvXmlNode.IndexInParent: integer;
begin
  Result:= Parent.ChildNodes.IndexOf(Self);
end;

procedure TGvXmlNode.Clear;
begin
  ChildNodes.Clear;
  FAttributes.Clear;
end;

procedure TGvXmlNode.ClearState(const aState: TGvNodeState);
begin
  FStates:= FStates - [aState];
end;

procedure TGvXmlNode.Assign(const aXmlNode: TGvXmlNode);
var
  St: String;
  Idx: Integer;
begin
  Idx:= 1;
  St:= aXmlNode.WriteToString;
  Self.Clear;
  Self.ReadFromString(St, Length(St), Idx);
end;

constructor TGvXmlNode.Create(aNodeName: string);
begin
  ChildNodes := TGvXmlNodeList.Create(True);
  Parent := NIL;
  FAttributes := TGvXmlAttributeList.Create(True);
  EndTerminator:= '/';
  FNodeName:= aNodeName;
end;

constructor TGvXmlNode.Create;
begin
  Create('');
end;

procedure TGvXmlNode.DeleteChildsByState(aNodeName: String; aStates: TGvNodeStateSet);
var
  Node: TGvXmlNode;
  Nodes: TGvXmlNodeList;
  i: Integer;
begin
  Nodes := FindNodes(aNodeName, aStates);
  for i:= 0 to Nodes.Count - 1 do
  begin
    Node:= TGvXmlNode(Nodes[i]);;
    Node.Clear;
    ChildNodes.Delete(ChildNodes.IndexOf(Node));
  end;
end;

destructor TGvXmlNode.Destroy;
begin
  FAttributes.Free;
  ChildNodes.Free;
  inherited;
end;

procedure TGvXmlNode.AttrDelete(const aAttribute: TGvXmlAttribute);
begin
  Attributes.Delete(FAttributes.IndexOf(aAttribute));
end;

procedure TGvXmlNode.ExportAttrs(aStringList: TStringList);
var
  Att: TGvXmlAttribute;
  i: Integer;
begin
  for i:= 0 to FAttributes.count-1 do
  begin
    Att:= FAttributes[i];
    aStringList.Values[Att.Name]:= Att.FValue;
  end;
end;

function TGvXmlNode.Find(aNodeName: String): TGvXmlNode;
var
  Node: TGvXmlNode;
  i: Integer;
begin
  Result := NIL;
  for i:= 0 to ChildNodes.Count-1 do
  begin
    Node:= ChildNodes[i];
    if lowercase(Node.NodeName) = lowercase(aNodeName) then
    begin
      Result := Node;
      Exit;
    end
  end;
  raise ENodeNotExists.CreateFmt('Child %s Not Exists', [aNodeName]);
end;

function TGvXmlNode.Find(aNodeName, aAttrName, aAttrValue: String): TGvXmlNode;
var
  Node: TGvXmlNode;
  i: Integer;
begin
  Result := NIL;
  for i:= 0 to ChildNodes.Count - 1 do
  begin
    Node:= ChildNodes[i];
    if (lowercase(Node.NodeName) = lowercase(aNodeName)) and
       (Node.HasAttribute(aAttrName)) and
       (Node[aAttrName] = aAttrValue) then
    begin
      Result := Node;
      Exit;
    end;
  end;
  raise ENodeNotExists.CreateFmt('Child %s with attribute %s="%s" Not Exists', [aNodeName, aAttrName, aAttrValue]);
end;

function TGvXmlNode.Find(aNodeName, aAttrName: String): TGvXmlNode;
var
  Node: TGvXmlNode;
  i: Integer;
begin
  Result := NIL;
  for i:= 0 to ChildNodes.Count - 1 do
  begin
    Node:= ChildNodes[i];
    if (lowercase(Node.NodeName) = lowercase(aNodeName)) and
       (Node.HasAttribute(aAttrName)) then
    begin
      Result := Node;
      Exit;
    end;
  end;
  raise ENodeNotExists.CreateFmt('Child %s with attribute %s Not Exists', [aNodeName, aAttrName]);
end;

function TGvXmlNode.Find(aNodeName, aAttrNames: string; aAttrValues: array of Variant): TGvXmlNode;
var
  i, j, k: Integer;
  AttrNames: TStringList;
  Founded, AnyFounded: Boolean;
  Value: String;
  varArray: array of Variant;
begin
  AttrNames:= TStringList.Create;
  try
    AttrNames.Delimiter:= ';';
    AttrNames.DelimitedText:= '"'+ReplaceAll(aAttrNames, ';', '";"')+'"';
    For i:= 0 to ChildNodes.Count - 1 do
    begin
      Result:= ChildNodes[i];
      if Result.NodeName = aNodeName then
      begin
        Founded:= true;
        for j:= 0 to AttrNames.Count - 1 do
        begin
          Value:= Result[AttrNames[j]];
          if VarIsArray(aAttrValues[j]) then
          begin
            varArray:= aAttrValues[j];
            AnyFounded:= false;
            for k:= VarArrayLowBound(varArray, 1) to VarArrayHighBound(varArray, 1) do
            begin
              AnyFounded:= Value = varArray[k];
              if AnyFounded then break;
            end;
            Founded:= AnyFounded and Founded;
          end
          else
            Founded:=  Value = aAttrValues[j];
          if not Founded then Break;
        end;
        if Founded then Exit;
      end;
    end;
    raise ENodeNotExists.CreateFmt('Child %s not exists', [aNodeName]);
  finally
    AttrNames.Free;
  end;
end;


function TGvXmlNode.FindNodes(aNodeName: String;
  aStates: TGvNodeStateSet = []): TGvXmlNodeList;
var
  Node: TGvXmlNode;
  i: Integer;
begin
  Result := TGvXmlNodeList.Create(False);
  for i:= 0 to ChildNodes.count-1 do
  begin
    Node:= ChildNodes[i];
    if (lowercase(Node.NodeName) = lowercase(aNodeName)) and
       ((aStates = []) or (Node.States*aStates <> [])) then
      Result.Add(Node);
  end;
end;

function TGvXmlNode.FindOrCreate(aNodeName, aAttrName: String): TGvXmlNode;
begin
  try
    Result:= Find(aNodeName, aAttrName);
  except
    on E:ENodeNotExists do
      Result:= AddChild(aNodeName)
  end;
end;

function TGvXmlNode.FindOrCreate(aNodeName, aAttrName: String; aAttrValue: variant): TGvXmlNode;
begin
  try
    Result:= Find(aNodeName, aAttrName, aAttrValue);
  except
    on E:ENodeNotExists do
      Result:= AddChild(aNodeName).Attribute(aAttrName, aAttrValue);
  end;
end;

function TGvXmlNode.FindOrCreate(aNodeName: String): TGvXmlNode;
begin
  try
    Result:= Find(aNodeName);
  except
    on E:ENodeNotExists do
      Result:= AddChild(aNodeName);
  end;
end;

function TGvXmlNode.GetAsString: String;
begin
  Result:= FValue;
end;

function TGvXmlNode.GetAsVariant: Variant;
begin

end;

function TGvXmlNode.GetAttribute(const aAttrName: string): TGvXmlAttribute;
begin
  Result:= FAttributes.Find(aAttrName);
end;

function TGvXmlNode.GetAttrOrChildValue(const Name: String): Variant;
begin
  try
    result:= FAttributes.Find(Name).AsString;
  except
    on E: EAttrNotExists do
      try
        result:= Find(Name).Value;
      except
        on E: ENodeNotExists do
          Result:= varEmpty;
      end;
  end;
end;

function TGvXmlNode.GetAttrValue(const aAttrName: String): Variant;
begin
  try
    result:= FAttributes.Find(aAttrName).AsString;
  except
    on E: EAttrNotExists do
      Result := '';
  end;
end;

function TGvXmlNode.GetAttrValueDef(const aAttrName: String;
  aValueDef: variant): Variant;
begin
  try
    result:= FAttributes.Find(aAttrName).AsString;
  except
    on E: EAttrNotExists do
      Result := aValueDef;
  end;
end;

function TGvXmlNode.GetAttrValueOrSet(const aAttrName, aAttrValue: String): Variant;
begin
  try
    result:= FAttributes.Find(aAttrName).AsString;
  except
    on E: EAttrNotExists do
      begin
        SetAttrValue(aAttrName, aAttrValue);
        Result := aAttrValue;
      end;
  end;
end;


function TGvXmlNode.GetFullNodeName: String;
begin
  if NameSpace = '' then
    Result:= NodeName
  else
    Result:= NameSpace+':'+NodeName;
end;

function TGvXmlNode.HasAttribute(const aNodeName: String): Boolean;
begin
  Result := assigned(FAttributes.Find(aNodeName));
end;

function TGvXmlNode.HasState(const aState: TGvNodeState): boolean;
begin
  result:= FStates * [aState] <> [];
end;

procedure TGvXmlNode.ImportAttrs(aStringList: TStringList);
var
  i: Integer;
begin
  for i := 0 to aStringList.Count-1 do
    AttrValue[aStringList.Names[i]]:= aStringList.ValueFromIndex[i];
end;

procedure TGvXmlNode.LoadFromString(aStr: string);
var
  Len, Idx: integer;
begin
  Len:= Length(aStr);
  Idx:= 1;
  ReadFromString(aStr, Len, Idx);
end;

procedure TGvXmlNode.MarkChanged;
begin
  FChanged:= true;
  if Assigned(Parent) then
    if not Parent.Changed then
      Parent.MarkChanged;
end;

function TGvXmlNode.GetNodeByIndex(const aIndex: Integer): TGvXmlNode;
begin
  Result:= ChildNodes.Items[aIndex];
end;

function TGvXmlNode.NodeCount: Integer;
begin
  Result:= ChildNodes.Count;
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
    AttributeAdd(AttrName, UnEscape(Copy_5(Tag, '"', Len, idx)));
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
  Text: String;
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
    FValue:= Copy(aLine, aIdx, j-aIdx);
    aIdx:= j+3;
  end
  else
  begin
    Tag:= Copy_3(aLine, '>', aLen, aIdx);
    ReadAttributes(Tag, IsEmpty);
    if IsEmpty then Exit;
    SkipSpaces(aLine, aLen, aIdx);
    Tag:= Copy_4(aLine, '<', aLen, aIdx);
    FValue:= UnEscape(SkipBack(Tag, ' '#9#10#13));
    repeat
      if (aLine[aIdx+1] = '/') then
      begin
        Tag:= Copy_3(aLine, '>', aLen, aIdx);
        j:= 3;
        Tag:= Copy_4(Tag, ' >', Length(Tag), j);
        if LowerCase(Tag) = LowerCase(FullNodeName) then
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

function TGvXmlNode.AttributeAdd(const aAttrName: String; const aAttrValue: String): TGvXmlAttribute;
begin
  Result:= TGvXmlAttribute.Create(Self);
  Result.Name:= aAttrName;
  Result.AsString:= aAttrValue;
  FAttributes.Add(Result);
end;

function TGvXmlNode.AttributeAdd(const aAttrName: String; const aAttrValue: Variant): TGvXmlAttribute;
begin
  Result:= TGvXmlAttribute.Create(Self);
  Result.Name:= aAttrName;
  Result.Value:= aAttrValue;
  FAttributes.Add(Result);
end;

function TGvXmlNode.Attribute(const aAttrName: String; const aAttrValue: Variant): TGvXmlNode;
var
  Att: TGvXmlAttribute;
begin
  try
    Att:= FAttributes.Find(aAttrName); // Search for given name
    Att.Value:= aAttrValue;
  except
    on EAttrNotExists do
      Att:= AttributeAdd(aAttrName, aAttrValue);
  end;
  Result := Self;
end;

procedure TGvXmlNode.SetAsString(const aValue: String);
begin
  if FValue <> aValue then
    MarkChanged;
  FValue:= aValue;
end;

procedure TGvXmlNode.SetAsVariant(const aValue: Variant);
begin
  AsString:= VariantToString(aValue);
end;

procedure TGvXmlNode.SetAttrOrChildValue(const aName: String;
  const aValue: Variant);
var
  Child: TGvXmlNode;
  Attr: TGvXmlAttribute;
begin
  try
    Child:= Find(aName);
    Child.Value:= aValue;
  except
    on ENodeNotExists do
      SetAttrValue(aName, aValue);
  end;
end;

procedure TGvXmlNode.SetAttrValue(const aAttrName: String; aValue: variant);
begin
  Attribute(aAttrName, aValue);
end;

procedure TGvXmlNode.SetFullNodeName(const Value: String);
begin
  NameSpace:= Value;
  FNodeName:= TakeBack5(NameSpace, ':');
end;

procedure TGvXmlNode.SetNodeName(const Value: String);
begin
  if Pos(':', Value) > 0 then
    SetFullNodeName(Value)
  else
    FNodeName:= Value;
end;

procedure TGvXmlNode.SetState(const aState: TGvNodeState);
begin
  FStates:= FStates + [aState];
end;

function TGvXmlNode.SetText(aValue: String): TGvXmlNode;
begin
  AsString := aValue;
  Result := Self;
end;

function TGvXmlNode.WriteToString(aReadable: Boolean = false; aLevel: integer = 0): string;
var
  Lines: TStringList;
  Attribute: TGvXmlAttribute;
  Child: TGvXmlNode;
  i: Integer;
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
    Result:= Ident+'<!--'+FValue+'-->'
  else
  begin
    Result:= Ident + '<' + FullNodeName;
    for i:= 0 to FAttributes.count-1 do
    begin
      Attribute:= FAttributes[i];
      Result:= Result + ' '+Attribute.FullName+'="'+Escape(Attribute.AsString)+'"';
    end;
    if (FValue = '') and (ChildNodes.Count = 0) then
      Result:= Result + EndTerminator+'>'+EOL
    else
    if (FValue <> '') and (ChildNodes.Count = 0) then
      Result:= Result +'>'+Escape(FValue)+'</'+FullNodeName+'>'+EOL
    else
    begin
      Result:= Result +'>'+Escape(FValue)+EOL;
      for i:= 0 to ChildNodes.Count-1 do
      begin
        Child:= ChildNodes[i];
        Result:= Result+Child.WriteToString(aReadable, aLevel+1);
      end;
      Result:= Result + Ident+'</'+FullNodeName+'>'+EOL;
    end;
  end;
end;

function TGvXmlNode.NodeByPath(aXPath: String): TGvXmlNode;
var
  sl: TStringList;
  i: Integer;
begin
  sl:= TStringList.Create;
  try
    sl.Delimiter:= '/';
    sl.DelimitedText:= aXPath;
    Result:= Self;
    for i:= 0 to sl.Count-1 do
      if Trim(sl[i])<>'' then
        Result:= Find(Trim(sl[i]));
  finally
    sl.Free;
  end;
end;

{ TGvXmlAttributeList }

function TGvXmlAttributeList.GetAttrByIndex(aIndex: Integer): TGvXmlAttribute;
begin
  Result:= TGvXmlAttribute(inherited Items[aIndex]);
end;

function TGvXmlAttributeList.Find(aAttrName: String): TGvXmlAttribute;
var
  Attribute: TGvXmlAttribute;
  i: Integer;
begin
  Result := NIL;
  for i:= 0 to Self.count-1 do
  begin
    Attribute:= Self[i];
    if lowercase(Attribute.Name) = lowercase(aAttrName) then
    begin
      Result := Attribute;
      exit;
    end;
  end;
  raise EAttrNotExists.CreateFmt('Attribute %s not exists', [aAttrName]);
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

function TGvXmlAttribute.AsMoneyDef(DefaultValue: Currency): Currency;
begin
  if FValue = '' then
  begin
    AsMoney:= DefaultValue;
    Result:= DefaultValue;
  end
  else
    Result:= GetAsMoney;
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

constructor TGvXmlAttribute.Create(AOwner: TGvXmlNode);
begin
  inherited Create;
  FOwner:= AOwner;
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

function TGvXmlAttribute.GetAsMoney: Currency;
begin
  Result:= StrToCurr(FValue);
end;

function TGvXmlAttribute.GetAsString: String;
begin
  Result:= FValue;
end;

function TGvXmlAttribute.GetAsVariant: variant;
begin
  if FilterString(FValue, '-T:') = '--T::' then
    Result:= GetAsDateTime
  else
    Result:= FValue;
end;

function TGvXmlAttribute.GetFullName: String;
begin
  if FNameSpace = '' then
    Result:= FName
  else
    Result:= FNameSpace+':'+FName;
end;

procedure TGvXmlAttribute.SetAsBoolean(const aValue: Boolean);
begin
  SetAsVariant(aValue);
end;

procedure TGvXmlAttribute.SetAsDateTime(const aValue: TDateTime);
begin
  SetAsVariant(aValue);
end;

procedure TGvXmlAttribute.SetAsFloat(const aValue: Double);
begin
  setAsVariant(aValue);
end;

procedure TGvXmlAttribute.SetAsInteger(const aValue: Integer);
begin
  SetAsvariant(aValue);
end;

procedure TGvXmlAttribute.SetAsMoney(const Value: Currency);
begin
  SetAsString(CurrToStr(Value));
end;

procedure TGvXmlAttribute.SetAsString(const Value: String);
begin
  if Value <> FValue then
    FOwner.MarkChanged;
  FValue:= Value;
end;

procedure TGvXmlAttribute.SetAsVariant(const aValue: Variant);
begin
  AsString:= VariantToString(aValue);
end;

procedure TGvXmlAttribute.SetFullName(const Value: String);
begin
  FNameSpace:= Value;
  FName:= TakeBack5(FnameSpace, ':');
end;

procedure TGvXmlAttribute.SetName(const Value: String);
begin
  if Pos(':', Value) = 0 then
    FName := Value
  else
    FullName:= Value;
end;

function TGvXmlAttribute.ValueIn(aAttrValues: array of Variant): Boolean;
var
  V: Variant;
  k: Integer;
begin
  Result:= True;
  V:= GetAsVariant;
  for k:= Low(aAttrValues) to High(aAttrValues) do
    if V = aAttrValues[k] then
      Exit;
  Result:= False;
end;

{TGvXmlNodeList}

{ TGvXmlStorage }

constructor TGvXmlStorage.Create(aOwner: TComponent);
begin
  inherited;
  FXml:= TGvXml.Create;
end;

destructor TGvXmlStorage.Destroy;
begin
  FXml.Free;
  inherited;
end;

procedure TGvXmlStorage.Assign(const aXml: TGvXml);
begin
  FXml.Assign(aXml);
end;

procedure TGvXmlStorage.Clear;
begin
  FXml.Clear;
end;

function TGvXmlStorage.GetAsText: String;
begin
  Result := FXml.SaveToString;
end;

procedure TGvXmlStorage.LoadFromFile(const aFileName: String);
begin
  FXml.LoadFromFile(aFileName);
end;

procedure TGvXmlStorage.LoadFromStream(const aStream: TStream);
begin
  FXml.LoadFromStream(aStream);
end;

procedure TGvXmlStorage.LoadFromString(const aText: string);
begin
  FXml.LoadFromString(aText);
end;

procedure TGvXmlStorage.SaveToFile(const aFileName: String);
begin
  FXml.SaveToFile(aFileName);
end;

procedure TGvXmlStorage.SaveToStream(const aStream: TStream);
begin
  FXml.SaveToStream(aStream);
end;

procedure TGvXmlStorage.SetAsText(const Value: String);
begin
  FXml.LoadFromString(Value);
end;

end.

