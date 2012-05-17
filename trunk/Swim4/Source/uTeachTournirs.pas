unit uTeachTournirs;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DBGridEhGrouping, ToolCtrlsEh,
  FIBDatabase, pFIBDatabase, GridsEh, DBGridEh, Vcl.StdCtrls, Data.DB,
  FIBDataSet, pFIBDataSet, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Mask, DBCtrlsEh,
  DBLookupEh, TB2Dock, SpTBXItem, SpTBXDkPanels, SpTBXEditors, SpTBXControls,
  Vcl.ActnList;

type
  TForm3 = class(TForm)
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
    lcbASport: TDBLookupComboboxEh;
    lcbCountry: TDBLookupComboboxEh;
    edTournirLevel: TDBNumberEditEh;
    cbSwapable: TCheckBox;
    Panel1: TPanel;
    SpTBXMultiDock2: TSpTBXMultiDock;
    edTournirName: TDBEditEh;
    edTournirMask: TDBEditEh;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    SpTBXButton1: TSpTBXButton;
    ActionList: TActionList;
    actATournirNew: TAction;
    actBTournirIgnore: TAction;
    actBTournirLink: TAction;
    actFillEditForm: TAction;
    cbIgnore: TCheckBox;
    SpTBXDockablePanel2: TSpTBXDockablePanel;
    gridATournirs: TDBGridEh;
    trnRead: TpFIBTransaction;
    procedure actFillEditFormExecute(Sender: TObject);
    procedure lcbASportChange(Sender: TObject);
    procedure lcbCountryChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure trnReadAfterStart(Sender: TObject);
    procedure gridBTournirsDblClick(Sender: TObject);
    procedure actATournirNewExecute(Sender: TObject);
    procedure trnWriteAfterEnd(EndingTR: TFIBTransaction;
      Action: TTransactionAction; Force: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

uses
  uDmFormMain, GvVariant;

procedure TForm3.actATournirNewExecute(Sender: TObject);
var
  ATournir_Id: Variant;
begin
  trnWrite.StartTransaction;
  try
    ATournir_Id:= trnWrite.DefaultDatabase.QueryValue(
      'select o_atournir_id from btournir_teach'+
      '(:i_btournir_id, :i_atournir_id, :i_ignore_flg, '+
      ':i_atournir_name, :i_tournir_lvl, :i_btournir_mask, '+
      ':i_asport_id, :i_country_sign, :i_swapable)',
      0, [qryBTournirs['BTournir_Id'], qryBTournirs['ATournir_Id'], cbIgnore.Checked,
      edTournirName.Text, edTournirLevel.Value, NullIf(trim(edTournirMask.Text), ''),
      lcbASport.Value, lcbCountry.Value, cbSwapable.Checked], trnWrite);
    trnWrite.Commit;
  finally
    trnWrite.Rollback;
  end;
end;

procedure TForm3.actFillEditFormExecute(Sender: TObject);
begin
  with gridBTournirs.DataSource do
  begin
    if DataSet['ATournir_Id'] = null then
    begin
      edTournirName.Text:= DataSet['BTournir_Name'];
      lcbASport.Value:= DataSet['ASport_Id'];
      lcbCountry.Value:= 'ANY';
    end
    else
    begin
      edTournirName.Text:= DataSet['ATournir_Name'];
      edTournirMask.Text:= DataSet['BTournir_Mask'];
      lcbASport.Value:= DataSet['ASport_Id'];
      lcbCountry.Value:= DataSet['Country_Sign'];
      cbSwapable.Checked:= Dataset['Swapable'];
      cbIgnore.Checked:= DataSet['Ignore_Flg'];
    end;
  end;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  trnRead.StartTransaction;
end;

procedure TForm3.FormDestroy(Sender: TObject);
begin
  trnRead.Rollback;
end;

procedure TForm3.gridBTournirsDblClick(Sender: TObject);
begin
  actFillEditForm.Execute;
end;

procedure TForm3.lcbASportChange(Sender: TObject);
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

procedure TForm3.lcbCountryChange(Sender: TObject);
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

procedure TForm3.trnReadAfterStart(Sender: TObject);
begin
  qryBTournirs.Open;
  qryASports.Open;
  qryATournirs.Open;
  qryCountries.Open;
end;

procedure TForm3.trnWriteAfterEnd(EndingTR: TFIBTransaction;
  Action: TTransactionAction; Force: Boolean);
begin
  trnRead.Commit;
  trnRead.StartTransaction;
end;

end.
