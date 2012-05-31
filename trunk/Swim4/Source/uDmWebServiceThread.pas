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
    spBetAdd: TpFIBStoredProc;
  private
    procedure ExportQueryValues(aQuery: TpFIBQuery; aNode: TGvXmlNode);
    { Private declarations }
  public
    { Public declarations }
    procedure SportDetect(aNode: TGvXmlNode);
    procedure TournirDetect(aNode: TGvXmlNode);
    procedure EventDetect(aNode: TGvXmlNode);
    procedure BetAdd(aBEventId: integer; aPeriod, aKind, aSubject, aGamer, aValue, aModifier: String;
      aKoef: Single);
  end;

implementation

{$R *.dfm}

uses
  GvStr, GvVariant;

{ TdmSwimThread }

procedure TdmSwimThread.BetAdd(aBEventId: integer; aPeriod, aKind, aSubject, aGamer, aValue,
  aModifier: String; aKoef: Single);
begin
  try
    trnWrite.SetSavePoint('PutBet');
    with spBetAdd do
    begin
      Params.ClearValues;
      Params.ParamByName('I_BEVENT_ID').AsInteger:= aBEventId;
      Params.ParamByName('I_PERIOD').Value:= aPeriod;
      Params.ParamByName('I_KIND').Value:= aKind;
      Params.ParamByName('I_SUBJECT').Value:= aSubject;
      Params.ParamByName('I_GAMER').Value:= NullIf(aGamer, '');
      Params.ParamByName('I_MODIFIER').Value:= aModifier;
      Params.ParamByName('I_VALUE').Value:= NullIf(aValue, '');
      Params.ParamByName('I_KOEF').Value:= aKoef;
      ExecProc;
    end
  except
    on E:Exception do
    begin
      ShowMessage(E.Message + ' Period='+aPeriod+', Kind='+aKind+
        ', Subject='+aSubject+', Gamer='+aGamer+', Modifier='+
        aModifier+', Value='+aValue);
      trnWrite.RollBackToSavePoint('PutBet');
      raise;
    end;
  end;
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
      'select be.* from bevent_add(:btournir_id, :event_dtm, :bgamer1_name, :bgamer2_name, :scan_id) bep '+
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
      'select bs.* from bsport_add(:bsport_name, :booker_id) bsp '+
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
      'from btournir_add(:btournir_name, :bsport_id, :tournir_region) btp '+
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
