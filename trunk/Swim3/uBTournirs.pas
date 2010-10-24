unit uBTournirs;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uBaseForm, Provider, pFIBClientDataSet, DB, DBClient, ImgList,
  TB2Item, ActnList, GridsEh, DBGridEh, ExtCtrls, DBCtrls, TBX, TB2Dock,
  TB2Toolbar, ComCtrls, StdCtrls, Mask, DBCtrlsEh, DBLookupEh,
  FIBDataSet, pFIBDataSet, TBXDkPanels;

type
  TfrmBTournirs = class(TfrmBaseForm)
    dsCountrys: TDataSource;
    PartsAction: TActionList;
    actSporPart: TAction;
    actCountryPart: TAction;
    actIgnorePart: TAction;
    dsParts: TDataSource;
    dsASports: TDataSource;
    dsATournirs: TDataSource;
    actAppendATournir: TAction;
    actSetATournir: TAction;
    tsParts: TTabSheet;
    tsTournirs: TTabSheet;
    TBXDock1: TTBXDock;
    TBXToolbar1: TTBXToolbar;
    TBXItem1: TTBXItem;
    TBXItem2: TTBXItem;
    TBXItem3: TTBXItem;
    lcbASports: TDBLookupComboboxEh;
    TBControlItem2: TTBControlItem;
    lcbCountrys: TDBLookupComboboxEh;
    TBControlItem3: TTBControlItem;
    gridParts: TDBGridEh;
    TBXDock2: TTBXDock;
    TBXToolbar2: TTBXToolbar;
    eATournirName: TEdit;
    TBControlItem4: TTBControlItem;
    TBXItem4: TTBXItem;
    gridATournirs: TDBGridEh;
    tsBEvents: TTabSheet;
    gridBEvents: TDBGridEh;
    dsBEvents: TDataSource;
    dsHistory: TDataSource;
    Splitter2: TSplitter;
    gridHistory: TDBGridEh;
    tblParts: TpFIBDataSet;
    tblASports: TpFIBDataSet;
    tblCountrys: TpFIBDataSet;
    tblATournirs: TpFIBDataSet;
    tblHistory: TpFIBDataSet;
    tblBEvents: TpFIBDataSet;
    tsAEvents: TTabSheet;
    DBGridEh1: TDBGridEh;
    tblAEvents: TpFIBDataSet;
    dsAEvents: TDataSource;
    actEditATournir: TAction;
    TBXItem5: TTBXItem;
    TBXItem6: TTBXItem;
    actClearTournirHistory: TAction;
    actCloseTournir: TAction;
    TBXItem7: TTBXItem;
    cbTemporary: TTBXItem;
    procedure actSporPartUpdate(Sender: TObject);
    procedure actSporPartExecute(Sender: TObject);
    procedure actCountryPartUpdate(Sender: TObject);
    procedure actCountryPartExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure actAppendATournirUpdate(Sender: TObject);
    procedure actAppendATournirExecute(Sender: TObject);
    procedure actSetATournirExecute(Sender: TObject);
    procedure gridMainDblClick(Sender: TObject);
    procedure gridATournirsDblClick(Sender: TObject);
    procedure actIgnorePartExecute(Sender: TObject);
    procedure actEditATournirExecute(Sender: TObject);
    procedure actClearTournirHistoryExecute(Sender: TObject);
    procedure actCloseTournirExecute(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure OpenDataSets; override;
    procedure CloseDataSets; override;
  public
    { Public declarations }
  end;

var
  frmBTournirs: TfrmBTournirs;

implementation

uses dm, GvColor, uCountrys;

{$R *.dfm}

procedure TfrmBTournirs.CloseDataSets;
begin
  tblBEvents.Close;
  tblAEvents.Close;
  tblHistory.Close;
  tblATournirs.Close;
  tblASports.Close;
  tblCountrys.Close;
  tblParts.Close;
  inherited;
end;

procedure TfrmBTournirs.OpenDataSets;
begin
  inherited;
  tblParts.Open;
  tblCountrys.Open;
  tblASports.Open;
  tblATournirs.Open;
  tblHistory.Open;
  tblAEvents.Open;
  tblBEvents.Open;
end;

procedure TfrmBTournirs.actSporPartUpdate(Sender: TObject);
begin
  actSporPart.Enabled:= lcbASports.KeyValue<>null;
end;

procedure TfrmBTournirs.actSporPartExecute(Sender: TObject);
begin
  dmSwim.AppendSportPart(tblMain['ASport_Id'],
                         tblMain['Booker_Id'],
                         lcbASports.KeyValue,
                         tblParts['Part_UTxt']);
  tblMain.Refresh;
  lcbASports.KeyValue:= null;
end;

procedure TfrmBTournirs.actCountryPartUpdate(Sender: TObject);
begin
  actCountryPart.Enabled:= lcbCountrys.KeyValue<>null;
end;

procedure TfrmBTournirs.actCountryPartExecute(Sender: TObject);
begin
  dmSwim.AppendCountryPart(tblMain['ASport_Id'],
                           tblMain['Booker_Id'],
                           lcbCountrys.KeyValue,
                           tblParts['Part_UTxt']);
  tblMain.Refresh;
  lcbCountrys.KeyValue:= null;
end;

procedure TfrmBTournirs.FormActivate(Sender: TObject);
begin
  dmSwim.RecognizeTournirs;
  inherited;
end;

procedure TfrmBTournirs.actAppendATournirUpdate(Sender: TObject);
begin
  actAppendATournir.Enabled:= eATournirName.Text <> '';
end;

procedure TfrmBTournirs.actAppendATournirExecute(Sender: TObject);
var
  ATournirName: String;
  ATournirId: Integer;
begin
  ATournirName:= NormalizeName(eATournirName.Text);
  dmSwim.AppendATournir(tblMain['ASport_Id'], ATournirName,
         tblMain['Country_Sgn'], ATournirId);
  if tblMain.State = dsBrowse then
    tblMain.Edit;
  tblMain['ATournir_Id']:= ATournirId;
  tblMain.Post;
  if Not tblMain.Filtered then
    tblMain.Next;
//  cdsMain.Locate('ATournir_Id', ATournirId, []);
  tblATournirs.Close;
  tblATournirs.Open;
  tblATournirs.Locate('ATournir_Id', ATournirId, []);
  eATournirName.Text:= '';
end;

procedure TfrmBTournirs.actSetATournirExecute(Sender: TObject);
begin
  if tblMain.State = dsBrowse then
    tblMain.Edit;
  tblMain['ATournir_Id']:= tblATournirs['ATournir_Id'];
  if cbTemporary.Checked then
    tblMain['Temporary_Dt']:= Date;
  tblMain.Post;
  if Not tblMain.Filtered then
    tblMain.Next;
end;

procedure TfrmBTournirs.gridMainDblClick(Sender: TObject);
begin
  inherited;
  eATournirName.Text:= tblMain['BTournir_Nm'];
end;

procedure TfrmBTournirs.gridATournirsDblClick(Sender: TObject);
begin
  if tblATournirs['ATournir_Nm']<>null then
    actSetATournirExecute(Sender);
end;

procedure TfrmBTournirs.actIgnorePartExecute(Sender: TObject);
begin
  dmSwim.AppendIgnorePart(tblMain['ASport_Id'],
                          tblMain['Booker_Id'],
                          tblParts['Part_UTxt']);
  tblMain.Refresh;
  if Not tblMain.Filtered then
    tblMain.Next;
end;

procedure TfrmBTournirs.actEditATournirExecute(Sender: TObject);
begin
  with gridATournirs do
  begin
    ReadOnly:= Not actEditATournir.Checked;
    if ReadOnly then
      Options:= Options + [dgRowSelect, dgAlwaysShowSelection]-[dgEditing]
    else
      Options:= Options - [dgRowSelect, dgAlwaysShowSelection]+[dgEditing];
  end;
end;

procedure TfrmBTournirs.actClearTournirHistoryExecute(Sender: TObject);
begin
  dmSwim.ClearHistoryByTournir(tblATournirs['ATournir_Id']);
end;

procedure TfrmBTournirs.actCloseTournirExecute(Sender: TObject);
begin
  dmSwim.CloseATournir(tblATournirs['ATournir_Id']);
  tblATournirs.Refresh;
end;

end.
