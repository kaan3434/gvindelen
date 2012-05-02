unit uDmSwim;

interface

uses
  System.SysUtils, System.Classes, pFIBDatabase, FIBDatabase, IBDatabase,
  Data.DB, IBCustomDataSet, IBQuery, FIBDataSet, pFIBDataSet;

type
  TdmSwim = class(TDataModule)
    dbSwim: TpFIBDatabase;
    trnRead: TpFIBTransaction;
    trnWrite: TpFIBTransaction;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
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

end.
