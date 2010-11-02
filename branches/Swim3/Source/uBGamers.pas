unit uBGamers;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uBaseForm, DB, Provider, pFIBClientDataSet, DBClient, ImgList,
  TB2Item, ActnList, ComCtrls, ExtCtrls, GridsEh, DBGridEh, DBCtrls, TBX,
  TB2Dock, TB2Toolbar, TB2ExtItems, TBXExtItems, StdCtrls,
  FIBDataSet, pFIBDataSet;

type
  TfrmBGamers = class(TfrmBaseForm)
    dsAGamers: TDataSource;
    DetailActionList: TActionList;
    actAddAGamer: TAction;
    dsHistory: TDataSource;
    tsAGamers: TTabSheet;
    tsHistory: TTabSheet;
    gridHistory: TDBGridEh;
    TBXDock1: TTBXDock;
    TBXToolbar1: TTBXToolbar;
    eAGamerName: TEdit;
    TBControlItem2: TTBControlItem;
    TBXItem1: TTBXItem;
    gridAGamers: TDBGridEh;
    tsAGamer1: TTabSheet;
    tsAGamer2: TTabSheet;
    dsAGamers1: TDataSource;
    dsAGamers2: TDataSource;
    gridAGamers1: TDBGridEh;
    gridAGamers2: TDBGridEh;
    TBXDock2: TTBXDock;
    TBXToolbar2: TTBXToolbar;
    eASubGamer1Name: TEdit;
    TBControlItem3: TTBControlItem;
    TBXItem2: TTBXItem;
    actAddASubGamer1: TAction;
    actAddASubGamer2: TAction;
    TBXDock3: TTBXDock;
    TBXToolbar3: TTBXToolbar;
    TBControlItem4: TTBControlItem;
    TBXItem3: TTBXItem;
    eASubGamer2Name: TEdit;
    tblAGamers: TpFIBDataSet;
    tblAHistory: TpFIBDataSet;
    tblAGamers1: TpFIBDataSet;
    tblAGamers2: TpFIBDataSet;
    procedure actAddAGamerUpdate(Sender: TObject);
    procedure actAddAGamerExecute(Sender: TObject);
    procedure gridAGamersApplyFilter(Sender: TObject);
    procedure eAGamerNameChange(Sender: TObject);
    procedure gridAGamersDblClick(Sender: TObject);
    procedure gridAGamersKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure gridMainDblClick(Sender: TObject);
    procedure gridHistoryDblClick(Sender: TObject);
    procedure gridAGamersTitleBtnClick(Sender: TObject; ACol: Integer;
      Column: TColumnEh);
    procedure actAddASubGamer1Execute(Sender: TObject);
    procedure actAddASubGamer2Execute(Sender: TObject);
    procedure gridAGamers1DblClick(Sender: TObject);
    procedure gridAGamers2DblClick(Sender: TObject);
    procedure eASubGamer1NameChange(Sender: TObject);
    procedure eASubGamer2NameChange(Sender: TObject);
  private
    { Private declarations }
    FilterCountrySign: String[3];
    ASubSport1Id: Variant;
    ASubSport2Id: Variant;
    procedure SetAGamer(AGamerId: Integer);
  protected
    procedure OpenDataSets; override;
    procedure CloseDataSets; override;
  public
    { Public declarations }
  end;

var
  frmBGamers: TfrmBGamers;

implementation

uses dm;

{$R *.dfm}

procedure TfrmBGamers.CloseDataSets;
begin
  tblAHistory.Close;
  tblAGamers2.Close;
  tblAGamers1.Close;
  tblAGamers.Close;
  inherited;
end;

procedure TfrmBGamers.OpenDataSets;
begin
  inherited;
  tblAGamers.Open;
  tblAGamers1.Open;
  tblAGamers2.Open;
  tblAHistory.Open;
end;

procedure TfrmBGamers.actAddAGamerUpdate(Sender: TObject);
begin
  actAddAGamer.Enabled:= trim(eAGamerName.Text)<>'';
end;

procedure TfrmBGamers.actAddAGamerExecute(Sender: TObject);
var
  AGamerId: Integer;
  AGamerName, lCountrySign: String;
begin
  lCountrySign:= FilterCountrySign;
  if lCountrySign = '' then
    lCountrySign := tblMain['Country_Sgn'];
  if (lCountrySign = 'ANY') and (tblMain['Country_Flg'] = 1) then exit;
  AGamerName:= dmSwim.NormalizeAGamerName(eAGamerName.Text, lCountrySign);
  dmSwim.AppendAGamer(tblMain['ASport_Id'], AGamerName, lCountrySign,
                      AGamerId);
  if tblMain.State = dsBrowse then
    tblMain.Edit;
  tblMain['AGamer_Id']:= AGamerId;
  tblMain.Post;
  tblMain.Refresh;
//  cdsMain.Locate('AGamer_Id', AGamerId, []);
  tblAGamers.Refresh;
  tblAGamers.Locate('AGamer_Id', AGamerId, []);
  eAGamerName.Text:= '';
  eASubGamer1Name.Text:= '';
  eASubGamer2Name.Text:= '';
end;

procedure TfrmBGamers.gridAGamersApplyFilter(Sender: TObject);
var
  fValue: String;
  i: Integer;
  Column: TColumnEh;
begin
  For i:= 0 to gridAGamers.Columns.Count-1 do
  begin
    Column:= gridAGamers.Columns[i];
    fValue:= Column.STFilter.ExpressionStr;
    if Column.FieldName = 'COUNTRY_SGN' then
    begin
      fValue:= UpperCase(fValue);
      FilterCountrySign:= fValue;
      Column.STFilter.ExpressionStr:= fValue;
    end;
  end;
  with tblAGamers do
  begin
    if Active then Close;
    CancelConditions;
    Conditions.Clear;
    if FilterCountrySign<>'' then
      Conditions.AddCondition('by_Country',
        Format('Country_Sgn = ''%s''', [FilterCountrySign]), True);
    ApplyConditions;
    Open;
  end;
end;

procedure TfrmBGamers.eAGamerNameChange(Sender: TObject);
begin
  tblAGamers.Locate('AGamer_Nm', eAGamerName.Text, [loPartialKey, loCaseInsensitive]);
end;

procedure TfrmBGamers.gridAGamersDblClick(Sender: TObject);
begin
  if tblAGamers['AGamer_Nm']<>null then
    SetAGamer(tblAGamers['AGamer_Id']);
end;

procedure TfrmBGamers.SetAGamer(AGamerId: Integer);
begin
  tblMain.Edit;
  tblMain['AGamer_Id']:= AGamerId;
  tblMain.Post;
  tblMain.Refresh;
  eAGamerName.Text:= '';
end;

procedure TfrmBGamers.gridAGamersKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = vk_Return then
    SetAGamer(tblAGamers['AGamer_Id'])
  else
  if Key = vk_Escape then
    tblMain.Next;
end;

procedure TfrmBGamers.gridMainDblClick(Sender: TObject);
begin
  inherited;
  eAGamerName.Text:= tblMain['BGamer_Nm'];
end;

procedure TfrmBGamers.gridHistoryDblClick(Sender: TObject);
begin
  if tblAHistory['AGamer_Nm']<>null then
    SetAGamer(tblAHistory['AGamer_Id']);
end;

procedure TfrmBGamers.gridAGamersTitleBtnClick(Sender: TObject;
  ACol: Integer; Column: TColumnEh);
begin
  gridAGamers.STFilter.Visible:= not gridAGamers.STFilter.Visible;
end;

procedure TfrmBGamers.actAddASubGamer1Execute(Sender: TObject);
var
  ASubGamer1Id: Integer;
  ASubGamer1Name: String;
begin
  ASubGamer1Name:= dmSwim.NormalizeAGamerName(eASubGamer1Name.Text, 'ANY');
  dmSwim.AppendAGamer(ASubSport1Id, ASubGamer1Name, 'ANY', ASubGamer1Id);
  tblAGamers1.Refresh;
  tblAGamers1.Locate('AGamer_Id', ASubGamer1Id, []);
  pcDetail.ActivePage:= tsAGamer2;
end;

procedure TfrmBGamers.actAddASubGamer2Execute(Sender: TObject);
var
  ASubGamer2Id: Integer;
  ASubGamer2Name: String;
begin
  ASubGamer2Name:= dmSwim.NormalizeAGamerName(eASubGamer2Name.Text, 'ANY');
  dmSwim.AppendAGamer(ASubSport2Id, ASubGamer2Name, 'ANY', ASubGamer2Id);
  tblAGamers2.Refresh;
  tblAGamers2.Locate('AGamer_Id', ASubGamer2Id, []);
  eAGamerName.Text:= Format('%s / %s', [eASubGamer1Name.Text, eASubGamer2Name.Text]);
  pcDetail.ActivePage:= tsAGamers;
end;

procedure TfrmBGamers.gridAGamers1DblClick(Sender: TObject);
begin
  eASubGamer1Name.Text:= tblAGamers1['AGamer_Nm'];
  pcDetail.ActivePage:= tsAGamer2;
end;

procedure TfrmBGamers.gridAGamers2DblClick(Sender: TObject);
begin
  eASubGamer2Name.Text:= tblAGamers2['AGamer_Nm'];
  eAGamerName.Text:= Format('%s / %s', [eASubGamer1Name.Text, eASubGamer2Name.Text]);
  pcDetail.ActivePage:= tsAGamers;
end;

procedure TfrmBGamers.eASubGamer1NameChange(Sender: TObject);
begin
  tblAGamers1.Locate('AGamer_Nm', eASubGamer1Name.Text, [loPartialKey, loCaseInsensitive]);
end;

procedure TfrmBGamers.eASubGamer2NameChange(Sender: TObject);
begin
  tblAGamers2.Locate('AGamer_Nm', eASubGamer2Name.Text, [loPartialKey, loCaseInsensitive]);
end;

end.
