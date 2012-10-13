unit uSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, GvXml;

type
  TForm2 = class(TForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TApplicationSettings = class(TGvXml)
  private
    FChanged: Boolean;
    FFileName: String;
    function GetPath(Name: string): string;
    procedure SetPath(Name: string; const Value: string);
  protected
    procedure Build;
  public
    constructor Create; overload; override;
    constructor Create(aFileName: string = ''); overload; virtual;
    procedure SaveToFile(const aFileName: String); overload; override;
    procedure Save; overload; virtual;
    function SelfPath: string;
    property Changed: Boolean read FChanged;
    property Path[Name: string]: string read GetPath write SetPath;
    property FileName: string read FFileName;
  end;

  TScanSettings = class(TApplicationSettings)
  private
    FBookers: TGvXmlNode;
    FScaners: TGvXmlNode;
    FServices: TGvXmlNode;
    FCurrencies: TGvXmlNode;
    FProxies: TGvXmlNode;
    function GetProxy: TGvXmlNode;
  public
    constructor Create; override;
    function DefaultService: TGvXmlNode;
    function RandomService: TGvXmlNode;
    function CurrencyStep(aValuteSign: string): Extended;
    property Services: TGvXmlNode read FServices;
    property Scaners: TGvXmlNode read FScaners;
    property Bookers: TGvXmlNode read FBookers;
    property Currencies: TGvXmlNode read FCurrencies;
    property Proxy: TGvXmlNode read GetProxy;
  end;

var
  Form2: TForm2;
  Settings: TScanSettings;

implementation

{$R *.dfm}
uses
  GvFile, GvXmlUtils;

{ TSettings }

constructor TApplicationSettings.Create;
begin
  Create(SelfPath+'settings.xml');
end;

procedure TApplicationSettings.Build;
begin
  FChanged:= true;
  Root.NodeName:= 'Settings';
end;

constructor TApplicationSettings.Create(aFileName: string);
begin
  inherited Create;
  FFileName:= aFileName;
  if FileExists(FFileName) then
    LoadFromFile(aFileName)
  else
    Build;
end;

function TApplicationSettings.GetPath(Name: string): string;
var
  Node: TGvXmlNode;
begin
  Node:= Root.FindOrCreate('Path').Find(Name);
  if Assigned(Node) then
    result:= Node.Text
  else
  begin
    Result:= SelfPath+Name+'\';
    SetPath(Name, Result);
  end;
end;

procedure TApplicationSettings.Save;
begin
  inherited SaveToFile(FFileName);
  FChanged:= false;
end;

procedure TApplicationSettings.SaveToFile(const aFileName: String);
begin
  inherited SaveToFile(aFileName);

end;

function TApplicationSettings.SelfPath: string;
begin
  result:= ExtractFilePath(ParamStr(0));
end;

procedure TApplicationSettings.SetPath(Name: string; const Value: string);
var
  Node: TGvXmlNode;
begin
  Node:=  Root.FindOrCreate('Path').FindOrCreate(Name);
  if Node.Text <> Value then
  begin
    Node.Text:= Value;
    FChanged:= true;
  end;
end;

{ TScanSettings }

constructor TScanSettings.Create;
var
  xml: TGvXml;
  st: String;
begin
  inherited;
  xml:= TGvXml.Create(Self.Path['Offline']+'Bookers.xml');
  try
    FBookers:= Root.FindOrCreate('Bookers');
    BatchMove(FBookers, xml.Root.Find('Bookers'), 'Booker', 'Id;*', amMerge);
    FScaners:= Root.FindOrCreate('Scaners');
    FServices:= Root.FindOrCreate('Services');
    FCurrencies:= Root.FindOrCreate('Currencies');
    FProxies:= Root.FindOrCreate('Proxies');
  finally
    xml.Free;
  end;
end;

function TScanSettings.CurrencyStep(aValuteSign: string): Extended;
begin
  result:= FCurrencies.Find('Currency', 'ValuteSign', aValuteSign).Attr['Step'].AsFloatDef(1);
end;

function TScanSettings.DefaultService: TGvXmlNode;
var
  DefaultServiceId: String;
begin
  DefaultServiceId:= FServices.Attr['Default'].AsStringDef('0');
  Result:= FServices.Find('Service', 'Id', DefaultServiceId);
  if Not Assigned(Result) then
  begin
    Result:= FServices.AddChild('Service');
    Result['Default']:= DefaultServiceId;
    Result['Url']:= 'http://localhost:8080/soap/ScanBooker.php';
  end;
end;

function TScanSettings.GetProxy: TGvXmlNode;
begin
  Result:= FProxies.Find('Proxy', 'Id', GetUserFromWindows);
end;

function TScanSettings.RandomService: TGvXmlNode;
var
  Idx: integer;
begin
  Idx:= FServices.ChildNodes.Count;
  if Idx<=1 then
    Result:= DefaultService
  else
    Result:= FServices.ChildNodes[Random(Idx)];
end;

initialization
  Settings:= TScanSettings.Create;
finalization
  if Settings.Changed then
    Settings.Save;
  Settings.Free;
end.
