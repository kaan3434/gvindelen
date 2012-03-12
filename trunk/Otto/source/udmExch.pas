unit udmExch;

interface

uses
  SysUtils, Classes, FIBDatabase, pFIBDatabase, GvVars;

type
  TdmExch = class(TDataModule)
    dbOtto: TpFIBDatabase;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmExch: TdmExch;
  Path: TVarList;

implementation

{$R *.dfm}

initialization
  Path:= TVarList.Create;
  Path.LoadSectionFromIniFile(ExtractFilePath(ParamStr(0))+'ppz2.ini', 'PATH');
  Path.Text:= ReplaceAll(Path.Text, '=.\', '='+ExtractFilePath(ParamStr(0)));
finalization
  Path.Free;
end.
