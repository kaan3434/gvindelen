unit uDmWebServiceThread;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uDmSwim, FIBDatabase, pFIBDatabase,
  FIBQuery, pFIBQuery, pFIBStoredProc, GvXml;

type
  TdmSwimThread = class(TdmSwim)
    spRequestBusyNext: TpFIBStoredProc;
    spTemp: TpFIBStoredProc;
    qryTemp: TpFIBQuery;
  private
    procedure ExportQueryValues(aQuery: TpFIBQuery; aNode: TGvXmlNode);
    { Private declarations }
  public
    { Public declarations }
    procedure RequestCommit(aRequestId: Integer);
    procedure RequestRollback(aRequestId: Integer);
    procedure SportDetect(aNode: TGvXmlNode);
    procedure TournirDetect(aNode: TGvXmlNode);
    procedure EventDetect(aNode: TGvXmlNode);
  end;

implementation

{$R *.dfm}

uses
  GvStr;

{ TdmSwimThread }

procedure TdmSwimThread.EventDetect(aNode: TGvXmlNode);
begin

end;

procedure TdmSwimThread.ExportQueryValues(aQuery: TpFIBQuery; aNode: TGvXmlNode);
var
  i: Integer;
  AName: string;
begin
  for i:= 0 to aQuery.FieldCount-1 do
  begin
    AName:= aQuery.Fields[i].Name;
    AName:= UpCaseWord(AName, '_');
    aNode.Attr[AName].SetValue(aQuery.Fields[i].Value);
  end;
end;

procedure TdmSwimThread.SportDetect(aNode: TGvXmlNode);
var
  i: integer;
  PrmName: String;
begin
  with qryTemp do
  begin
    Params.ClearValues;
    SQL.Text:=
      'select bs.* from bsport_add(:sport_title, :booker_id) bsp '+
      ' inner join bsports bs on (bs.bsport_id = bsp.o_bsport_id)';
    for i:= 0 to ParamCount-1 do
    begin
      PrmName:= ParamName(i);
      Params.ParamByName(PrmName).AsString:= aNode[PrmName];
    end;
    ExecQuery;
    ExportQueryValues(qryTemp, aNode);
    Close;
  end;
end;

procedure TdmSwimThread.TournirDetect(aNode: TGvXmlNode);
begin

end;

procedure TdmSwimThread.RequestCommit(aRequestId: Integer);
begin
  spTemp.ExecProcedure('REQUEST_COMMIT', [aRequestId]);
end;

procedure TdmSwimThread.RequestRollback(aRequestId: Integer);
begin
  spTemp.ExecProcedure('REQUEST_ROLLBACK', [aRequestId]);
end;

end.
