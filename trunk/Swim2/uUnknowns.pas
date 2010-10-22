unit uUnknowns;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uBaseForm, DB, FIBDataSet, pFIBDataSet, ImgList, TB2Item,
  ActnList, ComCtrls, ExtCtrls, GvCollapsePanel, GridsEh, DBGridEh,
  DBCtrls, TBX, TB2Dock, TB2Toolbar, StdCtrls, TBXDkPanels;

type
  TfrmUnknowns = class(TfrmBaseForm)
    tsAGamers: TTabSheet;
    gridAGamers: TDBGridEh;
    tblAGamers: TpFIBDataSet;
    dsAGamers: TDataSource;
    dsHistoryByTournir: TDataSource;
    tblHistoryByTournir: TpFIBDataSet;
    TBXDock1: TTBXDock;
    TBXToolbar1: TTBXToolbar;
    TBControlItem2: TTBControlItem;
    TBXItem1: TTBXItem;
    eAGamerName: TEdit;
    DetailActionList: TActionList;
    actAddAGamer: TAction;
    actAddASubGamer1: TAction;
    actAddASubGamer2: TAction;
    tblAGamers1: TpFIBDataSet;
    dsAGamers1: TDataSource;
    dsAGamers2: TDataSource;
    tblAGamers2: TpFIBDataSet;
    tsAGamers1: TTabSheet;
    TBXDock2: TTBXDock;
    TBXToolbar2: TTBXToolbar;
    TBControlItem3: TTBControlItem;
    TBXItem2: TTBXItem;
    eASubGamer1Name: TEdit;
    gridAGamers1: TDBGridEh;
    tsAGamers2: TTabSheet;
    TBXDock3: TTBXDock;
    TBXToolbar3: TTBXToolbar;
    TBControlItem4: TTBControlItem;
    TBXItem3: TTBXItem;
    eASubGamer2Name: TEdit;
    gridAGamers2: TDBGridEh;
    tsEvents: TTabSheet;
    gridBEvents: TDBGridEh;
    tblBEvents: TpFIBDataSet;
    dsBEvents: TDataSource;
    tblHistoryByGamer: TpFIBDataSet;
    dsHistoryByGamer: TDataSource;
    Splitter2: TSplitter;
    TBXItem4: TTBXItem;
    actEditAGamers: TAction;
    cbTemporary: TTBXItem;
    tblACountrys: TpFIBDataSet;
    dsACountrys: TDataSource;
    Panel1: TPanel;
    gridHistoryByGamer: TDBGridEh;
    Splitter3: TSplitter;
    tblBGamerByAGamer: TpFIBDataSet;
    dsBGamerByAGamer: TDataSource;
    pnlHistory: TTBXDockablePanel;
    gridHistoryByTournir: TDBGridEh;
    TBXVisibilityToggleItem1: TTBXVisibilityToggleItem;
    gridBGamerByAGamer: TDBGridEh;
    procedure gridAGamersApplyFilter(Sender: TObject);
    procedure eAGamerNameChange(Sender: TObject);
    procedure gridAGamersDblClick(Sender: TObject);
    procedure actAddASubGamer1Execute(Sender: TObject);
    procedure actAddASubGamer2Execute(Sender: TObject);
    procedure eASubGamer1NameChange(Sender: TObject);
    procedure eASubGamer2NameChange(Sender: TObject);
    procedure gridAGamers1DblClick(Sender: TObject);
    procedure gridAGamers2DblClick(Sender: TObject);
    procedure f(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure gridHistoryByTournirDblClick(Sender: TObject);
    procedure gridMainDblClick(Sender: TObject);
    procedure actAddAGamerExecute(Sender: TObject);
    procedure gridHistoryByTournirKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure actEditAGamersExecute(Sender: TObject);
    procedure gridBEventsDblClick(Sender: TObject);
    procedure tblMainAfterScroll(DataSet: TDataSet);
    procedure gridAGamersTitleBtnClick(Sender: TObject; ACol: Integer;
      Column: TColumnEh);
    procedure gridBGamerByAGamerKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    FilterCountrySign: String[3];
    procedure SetAGamer(AGamerId: Integer);
  protected
    procedure OpenDataSets; override;
    procedure CloseDataSets; override;
  public
    { Public declarations }
  end;

var
  frmUnknowns: TfrmUnknowns;

implementation

uses dm;

{$R *.dfm}

{ TfrmUnknowns }

procedure TfrmUnknowns.CloseDataSets;
begin
  tblBEvents.Close;
  tblAGamers2.Close;
  tblAGamers1.Close;
  tblHistoryByTournir.Close;
  tblHistoryByGamer.Close;
  tblAGamers.Close;
  tblACountrys.Close;
  tblBGamerByAGamer.Close;
  inherited;
end;

procedure TfrmUnknowns.OpenDataSets;
begin
  inherited;
  tblAGamers.Open;
  tblHistoryByTournir.Open;
  tblHistoryByGamer.Open;
  tblAGamers1.Open;
  tblAGamers2.Open;
  tblBEvents.Open;
  tblACountrys.Open;
  tblBGamerByAGamer.Open;
end;

procedure TfrmUnknowns.gridAGamersApplyFilter(Sender: TObject);
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
      if Column.STFilter.ListField = 'ACOUNTRY_NM' then
        fValue:= Column.STFilter.ListSource.DataSet.Lookup('ACOUNTRY_NM', fValue, 'ACOUNTRY_SGN');
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

procedure TfrmUnknowns.eAGamerNameChange(Sender: TObject);
begin
  FindNearest(tblAGamers, 'AGamer_Nm', eAGamerName.Text);
end;

procedure TfrmUnknowns.SetAGamer(AGamerId: Integer);
begin
  dmSwim.AppendBGamer(AGamerId, tblMain['Booker_Id'], tblMain['ATournir_Id'], tblMain['Gamer_Nm'], cbTemporary.Checked);
  tblMain.Refresh;
  cbTemporary.Checked:= false;
  eAGamerName.Text:= '';
  tblAGamers.Locate('AGamer_Id', AGamerId, []);
end;

procedure TfrmUnknowns.gridAGamersDblClick(Sender: TObject);
begin
  eAGamerName.Text:= tblAGamers['AGamer_Nm'];
end;

procedure TfrmUnknowns.f(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_Return then
  begin
    if eAGamerName.Text = tblAGamers['AGamer_Nm'] then
      SetAGamer(tblAGamers['AGamer_Id'])
    else
      eAGamerName.Text:= tblAGamers['AGamer_Nm'];
  end
  else
  if Key = vk_Escape then
    tblMain.Next;
end;

procedure TfrmUnknowns.gridMainDblClick(Sender: TObject);
begin
  inherited;
  eAGamerName.Text:= tblMain['Gamer_Nm'];
end;

procedure TfrmUnknowns.gridHistoryByTournirDblClick(Sender: TObject);
begin
  if tblHistoryByTournir['AGamer_Nm']<>null then
    SetAGamer(tblHistoryByTournir['AGamer_Id']);
end;

procedure TfrmUnknowns.actAddASubGamer1Execute(Sender: TObject);
var
  ASubGamer1Id: Integer;
  ASubGamer1Name: String;
begin
  if tblMain['ASubSport1_Id'] <> null then
  begin
    ASubGamer1Name:= dmSwim.NormalizeAGamerName(eASubGamer1Name.Text, 'ANY');
    dmSwim.AppendAGamer(tblMain['ASubSport1_Id'], ASubGamer1Name, 'ANY', ASubGamer1Id);
    tblAGamers1.Refresh;
    tblAGamers1.Locate('AGamer_Id', ASubGamer1Id, []);
    pcDetail.ActivePage:= tsAGamers2;
  end;
end;

procedure TfrmUnknowns.actAddASubGamer2Execute(Sender: TObject);
var
  ASubGamer2Id: Integer;
  ASubGamer2Name: String;
begin
  if tblMain['ASubSport2_Id'] <> null then
  begin
    ASubGamer2Name:= dmSwim.NormalizeAGamerName(eASubGamer2Name.Text, 'ANY');
    dmSwim.AppendAGamer(tblMain['ASubSport2_Id'], ASubGamer2Name, 'ANY', ASubGamer2Id);
    tblAGamers2.Refresh;
    tblAGamers2.Locate('AGamer_Id', ASubGamer2Id, []);
    eAGamerName.Text:= Format('%s / %s', [eASubGamer1Name.Text, eASubGamer2Name.Text]);
    pcDetail.ActivePage:= tsAGamers;
  end
end;

procedure TfrmUnknowns.gridAGamers1DblClick(Sender: TObject);
begin
  eASubGamer1Name.Text:= tblAGamers1['AGamer_Nm'];
  pcDetail.ActivePage:= tsAGamers2;
end;

procedure TfrmUnknowns.gridAGamers2DblClick(Sender: TObject);
begin
  eASubGamer2Name.Text:= tblAGamers2['AGamer_Nm'];
  eAGamerName.Text:= Format('%s / %s', [eASubGamer1Name.Text, eASubGamer2Name.Text]);
  pcDetail.ActivePage:= tsAGamers;
end;

procedure TfrmUnknowns.eASubGamer1NameChange(Sender: TObject);
begin
  tblAGamers1.Locate('AGamer_Nm', eASubGamer1Name.Text, [loPartialKey, loCaseInsensitive]);
end;

procedure TfrmUnknowns.eASubGamer2NameChange(Sender: TObject);
begin
  tblAGamers2.Locate('AGamer_Nm', eASubGamer2Name.Text, [loPartialKey, loCaseInsensitive]);
end;


procedure TfrmUnknowns.actAddAGamerExecute(Sender: TObject);
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
  tblAGamers.Refresh;
  tblAGamers.Locate('AGamer_Id', AGamerId, []);
  eAGamerName.Text:= '';
  dmSwim.AppendBGamer(AGamerId, tblMain['Booker_Id'], tblMain['ATournir_Id'], tblMain['Gamer_Nm'], cbTemporary.Checked);
  cbTemporary.Checked:= false;
  tblMain.Refresh;
  eASubGamer1Name.Text:= '';
  eASubGamer2Name.Text:= '';
  tblAGamers.Locate('AGamer_Id', AGamerId, []);
end;

procedure TfrmUnknowns.gridHistoryByTournirKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_Return then
    SetAGamer(tblHistoryByTournir['AGamer_Id'])
  else
  if Key = vk_Escape then
    tblMain.Next;
end;

procedure TfrmUnknowns.actEditAGamersExecute(Sender: TObject);
begin
  with gridAGamers do
  begin
    ReadOnly:= Not actEditAGamers.Checked;
    if ReadOnly then
      Options:= Options + [dgRowSelect, dgAlwaysShowSelection]-[dgEditing]
    else
      Options:= Options - [dgRowSelect, dgAlwaysShowSelection]+[dgEditing];
  end;
end;

procedure TfrmUnknowns.gridBEventsDblClick(Sender: TObject);
begin
  if gridBEvents.SelectedField.FieldName = 'AGAMER1_NM' then
    SetAGamer(tblBEvents['AGamer1_Id'])
  else
  if gridBEvents.SelectedField.FieldName = 'AGAMER2_NM' then
    SetAGamer(tblBEvents['AGamer2_Id']);
end;

procedure TfrmUnknowns.tblMainAfterScroll(DataSet: TDataSet);
begin
  if tblBEvents.Active then
    if Not tblBEvents.Locate('Gamer1_Nm', DataSet['Gamer_Nm'], []) then
      tblBEvents.Locate('Gamer2_Nm', DataSet['Gamer_Nm'], []);
end;

procedure TfrmUnknowns.gridAGamersTitleBtnClick(Sender: TObject;
  ACol: Integer; Column: TColumnEh);
begin
  if Column.FieldName = 'COUNTRY_SGN' then
    if Column.STFilter.ListField = 'ACOUNTRY_NM' then
      Column.STFilter.ListField:= 'ACOUNTRY_SGN'
    else
      Column.STFilter.ListField:= 'ACOUNTRY_NM';
end;

procedure TfrmUnknowns.gridBGamerByAGamerKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
  if (Key = vk_Delete) and (Shift = [ssCtrl]) then
  begin
    dmSwim.DeleteBGamer(tblBGamerByAGamer['BGamer_Id']);
    tblBGamerByAGamer.Close;
    tblBGamerByAGamer.Open;
  end;
end;

end.
