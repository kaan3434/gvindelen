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
    procedure ExportQryValues(aQuery: TpFIBQuery; aNode: TGvXmlNode);
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

{ TdmSwimThread }

procedure TdmSwimThread.EventDetect(aNode: TGvXmlNode);
begin

end;

procedure TdmSwimThread.ExportQryValues(aQuery: TpFIBQuery; aNode: TGvXmlNode);
var
  i: Integer;
begin
  for i:= 0 to aQuery.FieldCount-1 do
    aNode.Attr[aQuery.Fields[i].Name].SetValue(aQuery.Fields[i].Value);
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
      'select * from bsports '+
      'where bsport_name = :sport_title '+
      '  and booker_id = :booker_id';
    for i:= 0 to ParamCount-1 do
    begin
      PrmName:= ParamName(i);
      Params.ParamByName(PrmName).AsString:= aNode[PrmName];
    end;
    ExecQuery;
    ExportQryValues(qryTemp, aNode);
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
