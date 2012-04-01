unit dm;

interface

uses
  SysUtils, Classes, DB, ADODB, IdBaseComponent, IdComponent, Controls,
  IdTCPConnection, IdTCPClient, IdHTTP, GvVars, NativeXML, Variants,
  DBCtrlsEh, MemTableDataEh, MemTableEh, DataDriverEh, Dialogs, ComCtrls,
  GvStr, ExtCtrls, FIBDatabase, pFIBDatabase, FIBQuery, pFIBQuery,
  FIBDataSet, pFIBDataSet, pFIBStoredProc, Provider, pFIBClientDataSet,
  DBClient, FIBSQLMonitor;


type
  TdmSwim = class(TDataModule)
    Database: TpFIBDatabase;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function LoadComboBoxFromStream(Combo: TDBComboBoxEh;
      AbsSport_Id, Country_Id: Integer; Sex_Id: String): Boolean;
    procedure WriteComboBoxToStream(Combo: TDBComboBoxEh;
      AbsSport_Id, Country_Id: Integer; Sex_Id: String);
    procedure OpenAGamersTable(ASportId: Integer; CountrySign: String);

    function PutEvent(sl: TStringList): Integer; overload;
    function PutEvent: Integer; overload;

    procedure RecognizeTournirs;
    function  NormalizeAGamerName(AGamerName, CountrySign: String): String;
    function GetBookerName(BookerId: Integer): String;
  end;

var
  dmSwim: TdmSwim;
  Path: TvarList;
  vlRestore: TVarList;


{  nnSport='Sport';
    attBookmaker_Id='Bookmaker_Id'; attAbsSport_Id='AbsSport_Id';
    attSport_Name='Sport'; attSport_Id='Sport_Id';
    attTournir_Id='Tournir_Id'; attSex='Sex'; attCountry_Id='Country_Id';
    attAction='Action';
  nnHtml='Html';
   nnEvents='Events';
    nnEvent='Event';
     nnDate='Date';
       attId= 'Id';
     nnBets='Bets';
      nnBet='Bet'; attType='Type'; attWays='Ways'; attValue='Value';
}


procedure FindNearest(DataSet: TDataSet; FieldName, Value: String);

implementation

uses
  GvFile, DateUtils, Math, uSwimCommon;

{$R *.dfm}

procedure TdmSwim.DataModuleCreate(Sender: TObject);
begin
{  if FileExists(Path['BackUp']) then
  begin
    if FileDateToDateTime(FileAge(Path['BackUp']))-1 > vlRestore.AsDateTime['DateOfBackup'] then
    begin
      RestoreDatabase;
    end;
  end;}
  with Database do
  begin
    if Connected then Close;
    DBName:= Path['Data']+'swim.fdb';
    ConnectParams.UserName:= 'sysdba';
    ConnectParams.Password:= 'masterkey';
    ConnectParams.CharSet:= 'CYRL';
//    ConnectParams.RoleName:= 'admin';
    Connected:= true;
  end;
end;

procedure TdmSwim.DataModuleDestroy(Sender: TObject);
begin
  vlRestore.SaveSectionToIniFile(ProjectIniFileName, 'Restore');
end;



function TdmSwim.LoadComboBoxFromStream(Combo: TDBComboBoxEh;
  AbsSport_Id, Country_Id: Integer; Sex_Id: String): Boolean;
var
  FName: String;
  FStream: TFileStream;
begin
  FName:= Path['Cache']+Format('%2.2u_%3.3u_%1s.cache', [AbsSport_Id, Country_Id, Sex_Id]);
  result:= FileExists(FName);
  if result then
  begin
    FStream:= TFileStream.Create(FName, fmOpenRead);
    try
      Combo.ItemIndex:= -1;
      Combo.Items.Text:= ReadStringFromStream(FStream);
      Combo.KeyItems.Text:= ReadStringFromStream(FStream);
      Combo.ItemIndex:= -1;
    finally
      FStream.Free;
    end;
  end;
end;

procedure TdmSwim.WriteComboBoxToStream(Combo: TDBComboBoxEh;
  AbsSport_Id, Country_Id: Integer; Sex_Id: String);
var
  FName: String;
  FStream: TFileStream;
begin
  FName:= Path['Cache']+Format('%2.2u_%3.3u_%1s.cache', [AbsSport_Id, Country_Id, Sex_Id]);
  if FileExists(FName) then
    DeleteFile(FName);
  FStream:= TFileStream.Create(FName, fmCreate);
  try
    WriteStringToStream(FStream, Combo.Items.Text);
    WriteStringToStream(FStream, Combo.KeyItems.Text);
  finally
    FStream.Free;
  end;
end;




procedure TdmSwim.OpenAGamersTable(ASportId: Integer; CountrySign: String);
begin
{  if    tblAGamers.Active
    and (ASportId = FAGamersSportId)
    and (CountrySign = FAGamersCountrySign) then Exit;
  if tblAGamers.Active then tblAGamers.Close;
  tblAGamers.SelectSQL.Text:= Format(
    'SELECT AGamer_Id, AGamer_Nm '+
    'FROM AGamers '+
    'WHERE ASport_Id = %u ',
    [ASportId]);
  if trim(CountrySign) <> '' then
    tblAGamers.SelectSQL.Add(Format(
      'AND Country_Sgn = %s', [QuotedStr(CountrySign)]));
  tblAGamers.SelectSQL.Append(
    'ORDER BY AGamer_Nm');
  tblAGamers.Open;}
end;





procedure TdmSwim.RecognizeTournirs;
begin
  Database.Execute('execute procedure recognize_tournirs');
end;


function TdmSwim.NormalizeAGamerName(AGamerName,
  CountrySign: String): String;
begin
  result:= DeleteDoubleSpace(AGamerName);
  result:= ReplaceAll(result, '.', '. ');
  result:= ReplaceAll(result, ',', ', ');
  result:= ReplaceAll(result, ' ,', ', ');
  result:= DeleteDoubleSpace(result);
  result:= trim(result);
  if (CountrySign<>'ANY') And
     (Pos('('+CountrySign+')', result)=0) then
  begin
    result:= result + ' ('+CountrySign+')';
  end;
end;

function TdmSwim.PutEvent(sl: TStringList): Integer;
var
  i: integer;
  st: String;
begin
{  with spPutEvent do
  begin
    StoredProcName:= UpperCase('Put_EventBets');
    Params.ClearValues;
    ParamByName('i_BTournir_Id').AsInteger:= StrToInt(sl.Values['BTournir_Id']);
    ParamByName('i_Event_DTm').AsDateTime:= StrToDateTime(sl.Values['Event_DTm']);
    ParamByName('i_BGamer1_Nm').AsString:= sl.Values['BGamer1_Nm'];
    ParamByName('i_BGamer2_Nm').AsString:= sl.Values['BGamer2_Nm'];
    for i:= 0 to 9 do
    begin
      st:= Trim(sl.Values[Format('k_%u', [i])]);
      if  st<> '' then
      begin
        ParamByName(Format('i_s_%u', [i])).AsString:=  sl.Values[Format('s_%u', [i])];
        ParamByName(Format('i_v_%u', [i])).AsString:=  sl.Values[Format('v_%u', [i])];
        ParamByName(Format('i_k_%u', [i])).AsString:=  sl.Values[Format('k_%u', [i])];
      end
      else
      begin
        ParamByName(Format('i_s_%u', [i])).Value:= null;
        ParamByName(Format('i_v_%u', [i])).Value:= null;
        ParamByName(Format('i_k_%u', [i])).Value:= null;
      end;
    end;
    ExecProc;
  end;
}
end;

function TdmSwim.PutEvent: Integer;
begin
  result:= -1;
//  spPutEvent.ExecProc;
end;

procedure FindNearest(DataSet: TDataSet; FieldName: String;
  Value: String);
begin
  while Value <> '' do
  begin
    if DataSet.Locate(FieldName, Value, [loCaseInsensitive, loPartialKey]) then
      exit;
    Value:= Copy(Value, 1, Length(Value)-1);
  end;
end;



function TdmSwim.GetBookerName(BookerId: Integer): String;
begin
  result:= Database.QueryValue('select Booker_NM from Bookers where Booker_ID = :BookerId', 0, [BookerId]);
end;

initialization
  Path:= TVarList.Create;
  Path.LoadSectionFromIniFile(ProjectIniFileName, 'Path');
  Path.Text:= StringReplace(Path.Text, '=.\', '='+ExtractFilePath(ParamStr(0)),[rfReplaceAll]);
  Path['Self']:= ExtractFilePath(ParamStr(0));
  vlRestore:= TVarList.Create;
  vlRestore.LoadSectionFromIniFile(ProjectIniFileName, 'Restore');
finalization
  vlRestore.Free;
  Path.Free;
end.
