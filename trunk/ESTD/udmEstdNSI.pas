unit udmEstdNSI;

interface

uses
  SysUtils, Classes, MemTableDataEh, Db, MemTableEh;
  
type
  TdmEstdNSI = class(TDataModule)
    memKEIGroups: TMemTableEh;
    memKEIs: TMemTableEh;
    fldiKEIGroups_groupkei_code: TIntegerField;
    wsfldKEIGroups_groupkei_name: TWideStringField;
    dsKEIGroups: TDataSource;
    dsKEIs: TDataSource;
    fldiKEIs_kei: TIntegerField;
    fldiKEIs_groupkei_code: TIntegerField;
    wsfldKEIs_kei_name: TWideStringField;
    wsfldKEIs_kei_short: TWideStringField;
    fldiKEIs_master_kei: TIntegerField;
    wsfldKEIs_groupkei_name: TWideStringField;
    memObjTypes: TMemTableEh;
    wsfldObjTypes_objtype_name: TWideStringField;
    dsObjTypes: TDataSource;
    wsfldObjTypes_objtype: TWideStringField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmEstdNSI: TdmEstdNSI;

implementation

uses
  uEstdInterfaces;

{$R *.dfm}

procedure TdmEstdNSI.DataModuleCreate(Sender: TObject);
begin
  with EstdNSIDataModule do
  begin
    LoadKEIGroups(memKEIGroups);
    LoadKEIs(memKEIs);
    LoadObjTypes(memObjTypes);
  end;
end;

end.
 