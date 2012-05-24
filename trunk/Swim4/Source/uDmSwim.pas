unit uDmSwim;

interface

uses
  System.SysUtils, System.Classes, Messages, pFIBDatabase, FIBDatabase, IBDatabase,
  Data.DB, IBCustomDataSet, IBQuery, FIBDataSet, pFIBDataSet, FIBQuery,
  pFIBQuery, pFIBStoredProc;

const
  MY_QUEUESIZE = WM_USER + 1;

type
  TdmSwim = class(TDataModule)
    dbSwim: TpFIBDatabase;
    trnRead: TpFIBTransaction;
    trnWrite: TpFIBTransaction;
    spRequestAdd: TpFIBStoredProc;
    spTemp: TpFIBStoredProc;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure RequestAdd(aScanId: Integer; aActionSign, aParts: WideString);
    procedure RequestCommit(aRequestId: Integer);
    procedure RequestPostpone(aRequestId: Integer);
    procedure RequestsClean;
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

procedure TdmSwim.RequestAdd(aScanId: Integer; aActionSign, aParts: WideString);
begin
  with spRequestAdd do
  begin
    Params.ParamByName('I_SCAN_ID').AsInteger := aScanId;
    Params.ParamByName('I_ACTION_SIGN').AsString := aActionSign;
    Params.ParamByName('I_PARTS').AsWideString:= aParts;
    ExecProc;
  end;
end;

procedure TdmSwim.RequestCommit(aRequestId: Integer);
begin
  spTemp.ExecProcedure('REQUEST_COMMIT', [aRequestId]);
end;

procedure TdmSwim.RequestPostpone(aRequestId: Integer);
begin
  spTemp.ExecProcedure('REQUEST_POSTPONE', [aRequestId]);
end;

procedure TdmSwim.RequestsClean;
begin
  spTemp.ExecProcedure('REQUEST_CLEAN');
end;

end.
