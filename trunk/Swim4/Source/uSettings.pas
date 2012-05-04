unit uSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Options, Xml.VerySimple;

type
  TForm2 = class(TForm)
    Options: TOptions;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TApplicationSettings = class(TVerySimpleXml)
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
//    property
  end;

var
  Form2: TForm2;
  Settings: TApplicationSettings;

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
begin
  try
    result:= Root.Find('Path').Find(Name).Text;
  except
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
  Node: TXmlNode;
begin
  Node:=  Root.FindOrCreate('Path').FindOrCreate(Name);
  if Node.Text <> Value then
  begin
    Node.Text:= Value;
    FChanged:= true;
  end;
end;

initialization
  Settings:= TApplicationSettings.Create;
finalization
  if Settings.Changed then
    Settings.SaveToFile;
  Settings.Free;
end.
