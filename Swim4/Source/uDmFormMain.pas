unit uDmFormMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uDmSwim, FIBDatabase, pFIBDatabase,
  FIBQuery, pFIBQuery, pFIBStoredProc, GvXml, Data.DB, FIBDataSet, pFIBDataSet,
  pFIBErrorHandler;

type
  TdmFormMain = class(TdmSwim)
    qrySwimEvents: TpFIBDataSet;
    qryTemp: TpFIBDataSet;
    qryBookers: TpFIBDataSet;
    qrySwimItems: TpFIBDataSet;
    dsSwimItems: TDataSource;
    dsSwimEvents: TDataSource;
    spCalcMoneyMax: TpFIBStoredProc;
    procedure DataModuleCreate(Sender: TObject);
    procedure trnReadAfterStart(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure MakeSportsRequests;
    procedure ScanerOnOff(aBookerId: Integer; aChecked: Boolean);
    procedure Query2Xml(aXmlNode: TGvXmlNode; aSelectSQL, aRowNodeName, aMapping: string);
    procedure Bookers2Xml(aXmlNode: TGvXmlNode);
    procedure calcSwimMin(aValuteSign: String; aAmount: Integer);
    procedure calcSwimMax(aValuteSign: String; aAmount: Integer);
    procedure setBet1(aSwimId: integer; aValuteSign: String; aAmount, aDelta: Double);
    procedure setBet2(aSwimId: integer; aValuteSign: String; aAmount, aDelta: Double);
  end;

implementation

{$R *.dfm}

uses
  GvVars, GvXmlUtils, GvStr, GvMath;

{ TdmFormMain }

procedure TdmFormMain.Bookers2Xml(aXmlNode: TGvXmlNode);
begin
  Query2Xml(aXmlNode, 'select booker_id, booker_sign, booker_name from bookers order by booker_id',
    'Booker', 'Booker_Id;Booker_Sign;Booker_Title=Booker_Name');
end;

procedure TdmFormMain.calcSwimMax(aValuteSign: String; aAmount: Integer);
begin
  trnWrite.StartTransaction;
  try
    with spTemp do
    begin
      StoredProcName:= 'SWIM_MONEY_MAX';
      Params.ClearValues;
      Params.ParamByName('I_VALUTE_SIGN').AsString := CoalesceStr(aValuteSign, 'MNY');
      Params.ParamByName('I_AMOUNT').AsInteger := aAmount;
      ExecProc;
    end;
    trnWrite.Commit;
  except
    on E:Exception do
    begin
      trnWrite.Rollback;
      ShowMessage(e.Message);
    end;
  end;
end;

procedure TdmFormMain.calcSwimMin(aValuteSign: String; aAmount: Integer);
begin
  trnWrite.StartTransaction;
  try
    with spTemp do
    begin
      StoredProcName:= 'SWIM_MONEY_MIN';
      Params.ClearValues;
      Params.ParamByName('I_VALUTE_SIGN').AsString := CoalesceStr(aValuteSign, 'MNY');
      Params.ParamByName('I_AMOUNT').AsInteger := aAmount;
      ExecProc;
    end;
    trnWrite.Commit;
  except
    on E:Exception do
    begin
      trnWrite.Rollback;
      ShowMessage(e.Message);
    end;
  end;
end;

procedure TdmFormMain.DataModuleCreate(Sender: TObject);
begin
  inherited;
  trnRead.StartTransaction;
end;

procedure TdmFormMain.MakeSportsRequests;
var
  ndBooker: TGvXmlNode;
  ScanId : integer;
begin
  ndBooker:= TGvXmlNode.Create;
  ndBooker.NodeName:= 'getSport';
  try
    trnWrite.StartTransaction;
    try
      qryTemp.SelectSQL.Text:= 'select * from bookers b where b.scan_flg = 1';
      qryTemp.Open;
      try
        while not qryTemp.Eof do
        begin
          ndBooker['Booker_Sign']:= qryTemp['Booker_Sign'];
          ndBooker['Booker_Id']:= qryTemp['Booker_Id'];
          ndBooker['Booker_Title']:= qryTemp['Booker_Name'];
          ScanId := dbSwim.QueryValue('select o_scan_id from scan_new(:i_booker_id)',
                    0, [qryTemp['Booker_Id']], trnWrite);
          RequestAdd(ScanId, 'getSports', ndBooker.WriteToString);
          qryTemp.Next;
        end;
      finally
        qryTemp.Close;
      end;
      trnWrite.Commit;
    except
      trnWrite.Rollback;
    end;
  finally
    ndBooker.Free;
  end;
end;

procedure TdmFormMain.Query2Xml(aXmlNode: TGvXmlNode; aSelectSQL, aRowNodeName,
  aMapping: string);
begin
  qryTemp.SelectSQL.Text:= aSelectSQL;
  qryTemp.Open;
  try
    BatchMove(aXmlNode, qryTemp, aRowNodeName, aMapping, amMerge);
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

procedure TdmFormMain.setBet1(aSwimId: integer; aValuteSign: String; aAmount, aDelta: Double);
var
  vAmount: Extended;
begin
  vAmount:= RoundPrecision(aAmount, abs(aDelta));
  if aAmount = vAmount then
    vAmount:= aAmount + aDelta;

  trnWrite.StartTransaction;
  try
    with spTemp do
    begin
      StoredProcName := 'SWIM_MONEY_1';
      Params.ClearValues;
      Params.ParamByName('I_SWIM_ID').AsInteger:= aSwimId;
      Params.ParamByName('I_VALUTE_SIGN').AsString := aValuteSign;
      Params.ParamByName('I_AMOUNT').AsFloat := vAmount;
      ExecProc;
    end;
    trnWrite.Commit;
  Except
    trnWrite.Rollback;
  end;
end;

procedure TdmFormMain.setBet2(aSwimId: integer; aValuteSign: String; aAmount, aDelta: Double);
var
  vAmount: Extended;
begin
  vAmount:= RoundPrecision(aAmount, abs(aDelta));
  if aAmount = vAmount then
    vAmount:= aAmount + aDelta;

  trnWrite.StartTransaction;
  try
    with spTemp do
    begin
      StoredProcName := 'SWIM_MONEY_2';
      Params.ClearValues;
      Params.ParamByName('I_SWIM_ID').AsInteger:= aSwimId;
      Params.ParamByName('I_VALUTE_SIGN').AsString := aValuteSign;
      Params.ParamByName('I_AMOUNT').AsFloat := vAmount;
      ExecProc;
    end;
    trnWrite.Commit;
  Except
    trnWrite.Rollback;
  end;
end;

procedure TdmFormMain.trnReadAfterStart(Sender: TObject);
begin
  inherited;
  qrySwimEvents.Open;
  qrySwimItems.Open;
end;

end.
