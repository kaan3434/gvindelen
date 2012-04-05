unit uDmSwim;

interface

uses
  System.SysUtils, System.Classes, pFIBDatabase, FIBDatabase, IBDatabase,
  Data.DB, IBCustomDataSet, IBQuery;

type
  TDataModule1 = class(TDataModule)
    dbSwim: TIBDatabase;
    trnWrite: TIBTransaction;
    qrySwim: TIBQuery;
    dsSwim: TDataSource;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

procedure TDataModule1.DataModuleCreate(Sender: TObject);
begin
  dbSwim.Connected:= true;
end;

end.
