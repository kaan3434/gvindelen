unit uTeachTournirs;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DBGridEhGrouping, ToolCtrlsEh,
  FIBDatabase, pFIBDatabase, GridsEh, DBGridEh, Vcl.StdCtrls, Data.DB,
  FIBDataSet, pFIBDataSet, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Mask, DBCtrlsEh,
  DBLookupEh, TB2Dock, SpTBXItem, SpTBXDkPanels, SpTBXEditors, SpTBXControls,
  Vcl.ActnList, FIBQuery, pFIBQuery, pFIBStoredProc, Vcl.Menus;

type
  TfrmTeachTournirs = class(TForm)
    GroupBox1: TGroupBox;
    gridBTournirs: TDBGridEh;
    trnWrite: TpFIBTransaction;
    qryBTournirs: TpFIBDataSet;
    dsBTournirs: TDataSource;
    qryASports: TpFIBDataSet;
    qryATournirs: TpFIBDataSet;
    qryCountries: TpFIBDataSet;
    dsASports: TDataSource;
    dsATournirs: TDataSource;
    dsCountries: TDataSource;
    Splitter1: TSplitter;
    SpTBXDockablePanel1: TSpTBXDockablePanel;
    Panel1: TPanel;
    SpTBXMultiDock2: TSpTBXMultiDock;
    Label4: TLabel;
    SpTBXButton1: TSpTBXButton;
    ActionList: TActionList;
    actATournirNew: TAction;
    actBTournirIgnore: TAction;
    actBTournirLink: TAction;
    actFillEditForm: TAction;
    SpTBXDockablePanel2: TSpTBXDockablePanel;
    gridATournirs: TDBGridEh;
    trnRead: TpFIBTransaction;
    spTempSignle: TpFIBStoredProc;
    spTemp: TpFIBStoredProc;
    Label1: TLabel;
    edTournirName: TDBEditEh;
    Label2: TLabel;
    edTournirMask: TDBEditEh;
    Label3: TLabel;
    lcbASport: TDBLookupComboboxEh;
    Label5: TLabel;
    lcbCountry: TDBLookupComboboxEh;
    Label6: TLabel;
    edTournirLevel: TDBNumberEditEh;
    cbSwapable: TCheckBox;
    cbIgnore: TCheckBox;
    actBTournirMaskAdd: TAction;
    SpTBXButton2: TSpTBXButton;
    actBTournirPostpone: TAction;
    SpTBXButton3: TSpTBXButton;
    procedure actFillEditFormExecute(Sender: TObject);
    procedure lcbASportChange(Sender: TObject);
    procedure lcbCountryChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure trnReadAfterStart(Sender: TObject);
    procedure actATournirNewExecute(Sender: TObject);
    procedure trnWriteAfterEnd(EndingTR: TFIBTransaction;
      Action: TTransactionAction; Force: Boolean);
    procedure qryBTournirsAfterScroll(DataSet: TDataSet);
    procedure gridATournirsDblClick(Sender: TObject);
    procedure actBTournirLinkExecute(Sender: TObject);
    procedure actBTournirMaskAddExecute(Sender: TObject);
    procedure actBTournirMaskAddUpdate(Sender: TObject);
    procedure actATournirNewUpdate(Sender: TObject);
    procedure actBTournirPostponeExecute(Sender: TObject);
    procedure edTournirLevelChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTeachTournirs: TfrmTeachTournirs;

implementation

{$R *.dfm}

uses
  uDmFormMain, GvVariant;

procedure TfrmTeachTournirs.actATournirNewExecute(Sender: TObject);
var
  bm: TBookmark;
begin
  bm:= qryBTournirs.GetBookmark;
  try
    with spTempSignle do
    begin
      StoredProcName:= 'BTOURNIR_TEACH';
      Params.ClearValues;
      Params.ParamByName('i_btournir_id').Value := qryBTournirs['BTournir_Id'];
      Params.ParamByName('i_ignore_flg').Value := cbIgnore.Checked;
      Params.ParamByName('i_atournir_name').AsString := edTournirName.Text;
      Params.ParamByName('i_tournir_lvl').Value:= edTournirLevel.Value;
      Params.ParamByName('i_asport_id').Value:= lcbASport.Value;
      Params.ParamByName('i_country_sign').Value := lcbCountry.Value;
      Params.ParamByName('i_swapable').Value:= cbSwapable.Checked;
      ExecProc;
    end;
  finally
    qryBTournirs.GotoBookmark(bm);
    qryBTournirs.FreeBookmark(bm);
  end;
end;

procedure TfrmTeachTournirs.actATournirNewUpdate(Sender: TObject);
begin
  actATournirNew.Enabled:= edTournirMask.Text = '';
end;

procedure TfrmTeachTournirs.actBTournirLinkExecute(Sender: TObject);
var
  bm: TBookmark;
begin
  bm:= qryBTournirs.GetBookmark;
  try
    with spTempSignle do
    begin
      StoredProcName:= 'BTOURNIR_LINK';
      Params.ClearValues;
      Params.ParamByName('i_btournir_id').Value := qryBTournirs['BTournir_Id'];
      Params.ParamByName('i_atournir_id').Value := qryATournirs['ATournir_Id'];
      ExecProc;
    end;
  finally
    qryBTournirs.GotoBookmark(bm);
    qryBTournirs.FreeBookmark(bm);
  end;
end;

procedure TfrmTeachTournirs.actBTournirMaskAddExecute(Sender: TObject);
var
  bm: TBookmark;
begin
  bm:= qryBTournirs.GetBookmark;
  try
    with spTempSignle do
    begin
      StoredProcName:= 'BTOURNIR_MASK_ADD';
      Params.ClearValues;
      Params.ParamByName('i_bsport_id').Value := qryBTournirs['BSport_Id'];
      Params.ParamByName('i_ignore_flg').Value := cbIgnore.Checked;
      Params.ParamByName('i_tournir_lvl').Value:= edTournirLevel.Value;
      Params.ParamByName('i_asport_id').Value:= lcbASport.Value;
      Params.ParamByName('i_country_sign').Value := lcbCountry.Value;
      Params.ParamByName('i_swapable_flg').Value:= cbSwapable.Checked;
      Params.ParamByName('i_btournir_mask').Value:= NullIf(edTournirMask.Text, '');
      ExecProc;
    end;
  finally
    qryBTournirs.GotoBookmark(bm);
    qryBTournirs.FreeBookmark(bm);
  end;
end;

procedure TfrmTeachTournirs.actBTournirMaskAddUpdate(Sender: TObject);
begin
  actBTournirMaskAdd.Enabled:= edTournirMask.Text<>'';
end;

procedure TfrmTeachTournirs.actFillEditFormExecute(Sender: TObject);
begin
  with gridBTournirs.DataSource do
  begin
    if DataSet.Eof then exit;
    if DataSet['ATournir_Id'] = null then
    with spTemp do
    begin
      StoredProcName:= 'BTOURNIR_DETECT';
      Params.ClearValues;
      Params.ParamByName('i_btournir_id').Value:= qryBTournirs['BTournir_Id'];
      ExecProc;
      edTournirName.Text:= DataSet['BTournir_Name'];
      lcbASport.Value:= ParamValue('o_asport_id');
      lcbCountry.Value:= nvl(ParamValue('o_country_sign'), 'ANY');
      edTournirLevel.Value:= ParamValue('o_tournir_lvl');
      cbIgnore.Checked:= ParamValue('o_ignore_flg')='1';
      cbSwapable.Checked:= ParamValue('o_swapable_flg') = '1';
    end
    else
    begin
      edTournirName.Text:= DataSet['ATournir_Name'];
      lcbASport.Value:= DataSet['ASport_Id'];
      lcbCountry.Value:= DataSet['Country_Sign'];
      cbSwapable.Checked:= Dataset['Swapable'];
      cbIgnore.Checked:= DataSet['Ignore_Flg'];
    end;
    edTournirMask.Text:= '';
  end;
end;

procedure TfrmTeachTournirs.edTournirLevelChange(Sender: TObject);
begin
  if not trnRead.Active then exit;
  with qryATournirs do
  begin
    DisableControls;
    try
     Params.ParamByName('atournir_lvl').Value:= edTournirLevel.Value;
     CloseOpen(true);
    finally
      EnableControls;
    end;
  end;
end;

procedure TfrmTeachTournirs.actBTournirPostponeExecute(Sender: TObject);
var
  bm: TBookmark;
begin
  bm:= qryBTournirs.GetBookmark;
  try
    with spTempSignle do
    begin
      StoredProcName:= 'BTOURNIR_POSTPONE';
      Params.ClearValues;
      Params.ParamByName('i_btournir_id').Value := qryBTournirs['BTournir_Id'];
      Params.ParamByName('i_hour_cnt').Value := 24;
      ExecProc;
    end;
  finally
    qryBTournirs.GotoBookmark(bm);
    qryBTournirs.FreeBookmark(bm);
  end;
end;

procedure TfrmTeachTournirs.FormCreate(Sender: TObject);
begin
  trnRead.StartTransaction;
end;

procedure TfrmTeachTournirs.FormDestroy(Sender: TObject);
begin
  trnRead.Rollback;
end;

procedure TfrmTeachTournirs.gridATournirsDblClick(Sender: TObject);
begin
  actBTournirLink.Execute;
end;

procedure TfrmTeachTournirs.lcbASportChange(Sender: TObject);
begin
  if not trnRead.Active then exit;
  with qryATournirs do
  begin
    DisableControls;
    try
     Params.ParamByName('asport_id').Value:= lcbASport.Value;
     CloseOpen(true);
    finally
      EnableControls;
    end;
  end;
end;

procedure TfrmTeachTournirs.lcbCountryChange(Sender: TObject);
begin
  if not trnRead.Active then exit;
  with qryATournirs do
  begin
    DisableControls;
    try
     Params.ParamByName('region_sign').Value:= lcbCountry.Value;
     CloseOpen(true);
    finally
      EnableControls;
    end;
  end;
end;

procedure TfrmTeachTournirs.qryBTournirsAfterScroll(DataSet: TDataSet);
begin
  if not DataSet.ControlsDisabled then
    actFillEditForm.Execute;
end;

procedure TfrmTeachTournirs.trnReadAfterStart(Sender: TObject);
begin
  qryBTournirs.DisableControls;
  try
    qryBTournirs.Open;
    qryASports.Open;
    qryATournirs.Open;
    qryCountries.Open;
  finally
    qryBTournirs.EnableControls;
    actFillEditForm.Execute;
  end;
end;

procedure TfrmTeachTournirs.trnWriteAfterEnd(EndingTR: TFIBTransaction;
  Action: TTransactionAction; Force: Boolean);
begin
  trnRead.Rollback;
  trnRead.StartTransaction;
end;

end.
