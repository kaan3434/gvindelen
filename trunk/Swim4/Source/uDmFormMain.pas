unit uDmFormMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uDmSwim, FIBDatabase, pFIBDatabase,
  FIBQuery, pFIBQuery, pFIBStoredProc, GvXml, Data.DB, FIBDataSet, pFIBDataSet;

type
  TdmFormMain = class(TdmSwim)
    qrySwim: TpFIBDataSet;
    qryTemp: TpFIBDataSet;
    procedure DataModuleCreate(Sender: TObject);
    procedure trnReadAfterStart(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure MakeSportsRequests;
    procedure SportsRequestAdd(aBooker: TGvXmlNode);
    procedure ScanerOnOff(aBookerId: Integer; aChecked: Boolean);
  end;

implementation

{$R *.dfm}

uses
  GvVars;

{ TdmFormMain }

procedure TdmFormMain.DataModuleCreate(Sender: TObject);
begin
  inherited;
  trnRead.StartTransaction;
end;

procedure TdmFormMain.MakeSportsRequests;
begin
  qryTemp.SelectSQL.Text:= 'select * from bookers b where b.scan_flg = 1';
  qryTemp.Open;
  try
    while not qryTemp.Eof do
    begin
      a
      qryTemp.Next;
    end;
  finally
    qryTemp.Close;
  end;
end;

procedure TdmFormMain.ScanerOnOff(aBookerId: Integer; aChecked: Boolean);
begin
  trnWrite.StartTransaction;
  try
    with spTemp do
    begin
      StoredProcName := 'BOOKER_ONOFF_SCAN';
      Params.ClearValues;
      Params.ParamByName('I_BOOKER_ID').AsInteger := aBookerId;
      Params.ParamByName('I_ONOFF').AsInteger := Byte(aChecked);
      ExecProc;
    end;
    trnWrite.Commit;
  Except
    trnWrite.Rollback;
  end;
end;

procedure TdmFormMain.SportsRequestAdd(aBooker: TGvXmlNode);
var
  ScanId: Integer;
  Node: TGvXmlNode;
begin
  Node:= TGvXmlNode.Create;
  Node.NodeName:= 'getSport';
  try
    trnWrite.StartTransaction;
    try
      // получаем очередной Scan_id
      ScanId := dbSwim.QueryValue('select o_scan_id from scan_new(:i_booker_id)',
        0, [aBooker['Id']], trnWrite);
      Node['Booker_Sign']:= aBooker['Sign'];
      Node['Booker_Id']:= aBooker['Id'];
      Node['Booker_Title']:= aBooker['Title'];
      RequestAdd(ScanId, 'getSports', Node.WriteToString);
      trnWrite.Commit;
    except
      trnWrite.Rollback;
    end;
  finally
    Node.Free;
  end;
end;

procedure TdmFormMain.trnReadAfterStart(Sender: TObject);
begin
  inherited;
  qrySwim.Open;
end;

end.
