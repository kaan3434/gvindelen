unit uEstdClasses;

interface
uses
  NativeXML;

type
  TBaseClass = class(System.TObject)
  private
    FChanged: Boolean;
    procedure SetChanged(const Value: Boolean);
  protected
    property IsChanged: Boolean read FChanged write SetChanged;
    procedure Put;
    procedure Get;
  public
    procedure Save;
    procedure LoadFromXML(XMLNode: TXmlNode); virtual; abstract;
  end;

  TEstdKEI = class(TBaseClass)
  private
    FCode: Integer;
    FName: WideString;
    FMasterCode: Integer;
  public
    property Code: Integer read FCode write FCode;
    property Name: WideString read FName write FName;
    property MasterCode: Integer read FMasterCode write FMasterCode;
    procedure LoadFromXML(XMLNode: TXmlNode); virtual;
  end;

  TEstdObject = class(TBaseClass)
  private
    FId: Integer;
    FObjLabel: WideString;
    FObjCode: WideString;
    FObjName: WideString;
    FObjGost: WideString;
    FObjKEI: integer;
  public
    procedure LoadFromXML(XMLNode: TXmlNode); virtual;
    property ObjLabel: WideString read FObjLabel write FObjLabel;
    property ObjName: WideString read FObjName write FObjName;
  end;

  TEstdDocument = class(TESTDObject)
  end;

implementation

{ TBaseClass }

procedure TBaseClass.get;
begin

end;

procedure TBaseClass.put;
begin

end;

procedure TBaseClass.Save;
begin
  try
    put;
    FChanged:= false;
  except
  end;
end;

procedure TBaseClass.setChanged(const Value: Boolean);
begin
  FChanged := FChanged or Value;
end;

{ TEstdObject }

procedure TEstdObject.LoadFromXML(XMLNode: TXmlNode);
begin
  FObjLabel:= XMLNode.FindNode('Label').ValueAsWidestring;
  FObjName:= XMLNode.FindNode('Name').ValueAsWidestring;
  FObjCode:= XMLNode.FindNode('Code').ValueAsWidestring;
  FObjGost:= XMLNode.FindNode('GOST').ValueAsWidestring;
  FObjKEI:= XMLNode.FindNode('KEI').ValueAsInteger;
end;

{ TEstdKEI }

procedure TEstdKEI.LoadFromXML(XMLNode: TXmlNode);
begin
  FCode:= XMLNode.FindNode('Code').ValueAsInteger;
  FName:= XMLNode.FindNode('Name').ValueAsWidestring;
  FMasterCode:= XMLNode.FindNode('MasterKEI').ValueAsInteger;
end;

end.
