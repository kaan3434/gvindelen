unit uDmWebServiceThread;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uDmSwim, FIBDatabase, pFIBDatabase,
  FIBQuery, pFIBQuery, pFIBStoredProc, GvXml;

type
  TdmSwimThread = class(TdmSwim)
    spRequestBusyNext: TpFIBStoredProc;
    qryTemp: TpFIBQuery;
  private
    procedure ExportQueryValues(aQuery: TpFIBQuery; aNode: TGvXmlNode);
    { Private declarations }
  public
    { Public declarations }
    procedure SportDetect(aNode: TGvXmlNode);
    procedure TournirDetect(aNode: TGvXmlNode);
    procedure EventDetect(aNode: TGvXmlNode);
    procedure BetDetect(aPeriod, aKind, aSubject, aGamer, aValue, aModifier: String;
      aKoef: Single; isSwapper: Boolean);
  end;

implementation

{$R *.dfm}

uses
  GvStr;

{ TdmSwimThread }

procedure TdmSwimThread.BetDetect(aPeriod, aKind, aSubject, aGamer, aValue,
  aModifier: String; aKoef: Single; isSwapper: Boolean);
begin

end;

procedure TdmSwimThread.EventDetect(aNode: TGvXmlNode);
var
  i: integer;
  PrmName, Value: String;
begin
  with qryTemp do
  begin
    Params.ClearValues;
    SQL.Text:=
      'select be.* from bevent_add(:btournir_id, :event_dtm, :gamer1_name, :gamer2_name, :scan_id) bep '+
      ' inner join bevents be on (be.bevent_id = bep.o_bevent_id)';
    for i:= 0 to ParamCount-1 do
    begin
      PrmName:= ParamName(i);
      Value:= aNode.Attr[PrmName].Value;
      Params.ParamByName(PrmName).AsString:= Value;
    end;
    ExecQuery;
    ExportQueryValues(qryTemp, aNode);
    Close;
  end;
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
    aNode.Attr[AName].Value:= aQuery.Fields[i].Value;
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
var
  i: Integer;
  PrmName: String;
begin
  with qryTemp do
  begin
    Params.ClearValues;
    SQL.Text:=
      'select bt.btournir_id, bt.atournir_id, bt.ignore_flg '+
      'from btournir_add(:tournir_title, :bsport_id, :tournir_region) btp '+
      'inner join btournirs bt on (bt.btournir_id = btp.o_btournir_id)';
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

end.
