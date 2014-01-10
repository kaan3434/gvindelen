unit XmlNodeListDriverEh;

interface

uses
  SysUtils, Classes, DataDriverEh, MemTableDataEh, GvXml;

type
  TXmlNodeListDriverEh = class(TDataSetDriverEh)
  private
    FXmlStorage: TGvXmlStorage;
    FXPath: String;
    FRowNodeName: String;
    procedure SetXmlStorage(const Value: TGvXmlStorage);
    procedure SetXPath(const Value: String);
    procedure SetRowNodeName(const Value: String);
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
    function ReadData(MemTableData: TMemTableDataEh; Count: Integer): Integer; override;
  published
    { Published declarations }
    property RowNodeName: String read FRowNodeName write SetRowNodeName;
    property XPath: String read FXPath write SetXPath;
    property XmlStorage: TGvXmlStorage read FXmlStorage write SetXmlStorage;
  end;

procedure Register;

implementation

uses
  Dialogs;

procedure Register;
begin
  RegisterComponents('Gvindelen', [TXmlNodeListDriverEh]);
end;

{ TXmlNodeListDriverEh }

function TXmlNodeListDriverEh.ReadData(MemTableData: TMemTableDataEh;
  Count: Integer): Integer;
var
  i: Integer;
begin
  for i:= 0 to Count-1 do;
//    ShowMessage(IntToStr(i));
end;

procedure TXmlNodeListDriverEh.SetRowNodeName(const Value: String);
begin
  FRowNodeName := Value;
end;

procedure TXmlNodeListDriverEh.SetXmlStorage(const Value: TGvXmlStorage);
begin
  FXmlStorage := Value;
end;

procedure TXmlNodeListDriverEh.SetXPath(const Value: String);
begin
  FXPath := Value;
end;

end.
