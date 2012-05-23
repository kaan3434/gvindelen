unit uTeachGamers;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DBGridEhGrouping, GridsEh, DBGridEh,
  TB2Dock, SpTBXDkPanels, SpTBXItem, SpTBXControls, Data.DB, FIBDataSet,
  pFIBDataSet, FIBDatabase, pFIBDatabase, DBLookupEh, Vcl.StdCtrls, Vcl.Mask,
  DBCtrlsEh, Vcl.ActnList, ToolCtrlsEh, FIBQuery, pFIBQuery, pFIBStoredProc,
  TB2Toolbar, TB2Item, SpTBXEditors;

type
  TfrmTeachGamers = class(TForm)
    SpTBXSplitter1: TSpTBXSplitter;
    SpTBXPanel1: TSpTBXPanel;
    SpTBXSplitter2: TSpTBXSplitter;
    SpTBXDockablePanel3: TSpTBXDockablePanel;
    SpTBXMultiDock1: TSpTBXMultiDock;
    gridBGamers: TDBGridEh;
    dsBGamers: TDataSource;
    dsAGamers: TDataSource;
    trnWrite: TpFIBTransaction;
    trnRead: TpFIBTransaction;
    qryBGamers: TpFIBDataSet;
    qryAGamers: TpFIBDataSet;
    gridAGamers: TDBGridEh;
    ActionList: TActionList;
    actAGamerAdd: TAction;
    actAGamerLink: TAction;
    actFillEditForm: TAction;
    qryCountries: TpFIBDataSet;
    dsCountry: TDataSource;
    spTempSignle: TpFIBStoredProc;
    spTemp: TpFIBStoredProc;
    SpTBXToolbar1: TSpTBXToolbar;
    actFilterByTournir: TAction;
    TBControlItem1: TTBControlItem;
    edAGamerName: TDBEditEh;
    TBControlItem2: TTBControlItem;
    lcbCountry: TDBLookupComboboxEh;
    SpTBXLabelItem1: TSpTBXLabelItem;
    SpTBXLabelItem2: TSpTBXLabelItem;
    SpTBXItem1: TSpTBXItem;
    cbGamerOnTournir: TSpTBXItem;
    cbTemporary: TSpTBXItem;
    SpTBXSeparatorItem1: TSpTBXSeparatorItem;
    actAppendCountry: TAction;
    procedure actFillEditFormExecute(Sender: TObject);
    procedure trnWriteAfterEnd(EndingTR: TFIBTransaction;
      Action: TTransactionAction; Force: Boolean);
    procedure trnReadAfterStart(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actAGamerAddExecute(Sender: TObject);
    procedure qryBGamersAfterScroll(DataSet: TDataSet);
    procedure cbGamerOnTournirClick(Sender: TObject);
    procedure gridAGamersDblClick(Sender: TObject);
    procedure actAGamerLinkExecute(Sender: TObject);
    procedure actAppendCountryExecute(Sender: TObject);
    procedure actAppendCountryUpdate(Sender: TObject);
    procedure lcbCountryChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTeachGamers: TfrmTeachGamers;

implementation

{$R *.dfm}

uses
  uDmFormMain, GvVariant;

procedure TfrmTeachGamers.actAGamerAddExecute(Sender: TObject);
var
  bm: TBookmark;
begin
  bm:= qryBGamers.GetBookmark;
  try
    with spTempSignle do
    begin
      StoredProcName:= 'BGAMER_TEACH';
      Params.ClearValues;
      Params.ParamByName('i_bevent_id').Value := qryBGamers['BEvent_Id'];
      Params.ParamByName('i_bgamer_name').Value := qryBGamers['Gamer_Name'];
      Params.ParamByName('i_agamer_name').AsString := edAGamerName.Text;
      Params.ParamByName('i_country_sign').Value := lcbCountry.Value;
      Params.ParamByName('i_temporary_flg').Value:= cbTemporary.Checked;
      ExecProc;
    end;
  finally
    qryBGamers.GotoBookmark(bm);
    qryBGamers.FreeBookmark(bm);
  end;
end;

procedure TfrmTeachGamers.actAGamerLinkExecute(Sender: TObject);
var
  bm: TBookmark;
begin
  bm:= qryBGamers.GetBookmark;
  try
    with spTempSignle do
    begin
      StoredProcName:= 'BGAMER_LINK';
      Params.ClearValues;
      Params.ParamByName('i_bevent_id').Value := qryBGamers['BEvent_Id'];
      Params.ParamByName('i_bgamer_name').Value := qryBGamers['Gamer_Name'];
      Params.ParamByName('i_agamer_id').Value := qryAGamers['AGamer_Id'];
      Params.ParamByName('i_temporary_flg').Value:= cbTemporary.Checked;
      ExecProc;
    end;
  finally
    qryBGamers.GotoBookmark(bm);
    qryBGamers.FreeBookmark(bm);
  end;
end;

procedure TfrmTeachGamers.actAppendCountryExecute(Sender: TObject);
begin
  edAGamerName.Text:= Format('%s (%s)', [edAGamerName.Text, lcbCountry.Value]);
end;

procedure TfrmTeachGamers.actAppendCountryUpdate(Sender: TObject);
begin
  actAppendCountry.Enabled:= Pos(lcbCountry.Value, edAGamerName.Text) = 0;
end;

procedure TfrmTeachGamers.actFillEditFormExecute(Sender: TObject);
begin
  with gridBGamers.DataSource do
  begin
    if DataSet.Eof then exit;
    edAGamerName.Text:= qryBGamers['Gamer_Name'];
    lcbCountry.Value:= qryBGamers['Country_Sign'];
    qryAGamers.DisableControls;
    try
      qryAGamers.Params.ParamByName('ASport_Id').Value := qryBGamers['ASport_Id'];
      qryAGamers.Params.ParamByName('Country_Sign').Value := qryBGamers['Country_Sign'];
      if cbGamerOnTournir.Checked then
        qryAGamers.Params.ParamByName('ATournir_Id').Value := qryBGamers['ATournir_Id']
      else
        qryAGamers.Params.ParamByName('ATournir_Id').Value := null;
      qryAGamers.CloseOpen(true);
      qryAGamers.First;
      while not qryAGamers.Eof and
            (qryAGamers['AGamer_Name']< edAGamerName.Text) do
        qryAGamers.Next;
    finally
      qryAGamers.EnableControls;
    end;
  end;
end;

procedure TfrmTeachGamers.cbGamerOnTournirClick(Sender: TObject);
begin
  actFillEditForm.Execute;
end;

procedure TfrmTeachGamers.FormCreate(Sender: TObject);
begin
  trnRead.StartTransaction;
end;

procedure TfrmTeachGamers.FormDestroy(Sender: TObject);
begin
  trnRead.Rollback;
end;

procedure TfrmTeachGamers.gridAGamersDblClick(Sender: TObject);
begin
  actAGamerLink.Execute;
end;

procedure TfrmTeachGamers.lcbCountryChange(Sender: TObject);
begin
  qryAGamers.DisableControls;
  try
    qryAGamers.Params.ParamByName('Country_Sign').Value:= lcbCountry.Value;
    qryAGamers.CloseOpen(true);
  finally
    qryAGamers.EnableControls;
  end;
end;

procedure TfrmTeachGamers.qryBGamersAfterScroll(DataSet: TDataSet);
begin
  actFillEditForm.Execute;
end;

procedure TfrmTeachGamers.trnReadAfterStart(Sender: TObject);
begin
  qryBGamers.DisableControls;
  try
    qryBGamers.Open;
    qryAGamers.Open;
    qryCountries.Open;
  finally
    qryBGamers.EnableControls;
    actFillEditForm.Execute;
  end;
end;

procedure TfrmTeachGamers.trnWriteAfterEnd(EndingTR: TFIBTransaction;
  Action: TTransactionAction; Force: Boolean);
begin
  trnRead.Rollback;
  trnRead.StartTransaction;
end;

end.
