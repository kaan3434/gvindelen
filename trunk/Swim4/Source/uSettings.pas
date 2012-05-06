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
    constructor Create(aFileName: string); overload; virtual;
    procedure SaveToFile; virtual;
    function SelfPath: string;
    property Changed: Boolean read FChanged;
    property Path[Name: string]: string read GetPath write SetPath;
    property FileName: string read FFileName;
  end;

  TScanSettings = class(TApplicationSettings)
  private
    FBookers: TGvXmlNode;
    FScaner: TGvXmlNode;
    function GetNeedScan(BookerId: Integer): Boolean;
    procedure SetNeedScan(BookerId: Integer; const Value: Boolean);
  public
    constructor Create; override;
    property Bookers: TGvXmlNode read FBookers;
    property Scaner[BookerId: Integer]: Boolean read GetNeedScan write SetNeedScan;
  end;

var
  Form2: TForm2;
  Settings: TScanSettings;

implementation

{$R *.dfm}

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

procedure TApplicationSettings.SaveToFile;
begin
  inherited SaveToFile(FFileName);
  FChanged:= false;
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
    FBookers.LoadFromString(xml.Root.Find('Bookers').WriteToString);
  finally
    xml.Free;
  end;
end;

function TScanSettings.GetNeedScan(BookerId: Integer): Boolean;
var
  Node: TGvXmlNode;
begin
  Node:= Root.FindOrCreate('Scaner').FindOrCreate('Booker', 'Id', BookerId);
  if Not Node.HasAttribute('NeedScan') then
  begin
    FChanged:= true;
    Node['NeedScan']:= false;
  end;
  Result:= Node['NeedScan']
end;

procedure TScanSettings.SetNeedScan(BookerId: Integer; const Value: Boolean);
begin
  Root.FindOrCreate('Scaner').FindOrCreate('Booker', 'Id', BookerId)['NeedScan']:= Value;
  FChanged:= true;
end;

initialization
  Settings:= TScanSettings.Create;
finalization
  if Settings.Changed then
    Settings.SaveToFile;
  Settings.Free;
end.
