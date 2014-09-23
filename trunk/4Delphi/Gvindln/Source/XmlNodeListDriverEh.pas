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
  Dialogs, Variants;

procedure Register;
begin
  RegisterComponents('Gvindelen', [TXmlNodeListDriverEh]);
end;

{ TXmlNodeListDriverEh }

function TXmlNodeListDriverEh.ReadData(MemTableData: TMemTableDataEh;
  Count: Integer): Integer;
var
  Rec: TMemoryRecordEh;
  AProviderEOF: Boolean;
begin
  Result := 0;
  if ProviderEOF = True then Exit;
  while Count <> 0 do
  begin
    Rec := MemTableData.RecordsList.NewRecord;
    try
      if Assigned(OnReadRecord) then
        OnReadRecord(Self, MemTableData, Rec, AProviderEOF)
      else
        DefaultReadRecord(MemTableData, Rec, AProviderEOF);
    except
      Rec.Free;
      raise;
    end;
    ProviderEOF := AProviderEOF;
    if ProviderEOF then
      Rec.Free
    else
      MemTableData.RecordsList.FetchRecord(Rec);

    Inc(Result);
    if ProviderEOF then Exit;
    Dec(Count);
  end;
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
