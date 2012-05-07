unit uDmSwim;

interface

uses
  System.SysUtils, System.Classes, pFIBDatabase, FIBDatabase, IBDatabase,
  Data.DB, IBCustomDataSet, IBQuery, FIBDataSet, pFIBDataSet, FIBQuery,
  pFIBQuery, pFIBStoredProc;

type
  TdmSwim = class(TDataModule)
    dbSwim: TpFIBDatabase;
    trnRead: TpFIBTransaction;
    trnWrite: TpFIBTransaction;
    spRequestAdd: TpFIBStoredProc;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure RequestAdd(aScanId: Integer; aActionSign, aParts: String);
  end;

var
  dmSwim: TdmSwim;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

procedure TdmSwim.DataModuleCreate(Sender: TObject);
begin
  dbSwim.Connected:= true;
end;

procedure TdmSwim.RequestAdd(aScanId: Integer; aActionSign, aParts: String);
begin
  with spRequestAdd do
  begin
    Params.ParamByName('I_SCAN_ID').AsInteger := aScanId;
    Params.ParamByName('I_ACTION_SIGN').AsString := aActionSign;
    Params.ParamByName('I_PARTS').AsString:= aParts;
    ExecProc;
  end;
end;

end.
