unit uTeachGamers;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DBGridEhGrouping, GridsEh, DBGridEh,
  TB2Dock, SpTBXDkPanels, SpTBXItem, SpTBXControls, Data.DB, FIBDataSet,
  pFIBDataSet, FIBDatabase, pFIBDatabase, DBLookupEh, Vcl.StdCtrls, Vcl.Mask,
  DBCtrlsEh, Vcl.ActnList;

type
  TfrmTeachGamers = class(TForm)
    SpTBXSplitter1: TSpTBXSplitter;
    SpTBXPanel1: TSpTBXPanel;
    SpTBXDockablePanel2: TSpTBXDockablePanel;
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
    DBGridEh2: TDBGridEh;
    Label1: TLabel;
    edGamerName: TDBEditEh;
    Label5: TLabel;
    lcbCountry: TDBLookupComboboxEh;
    SpTBXButton1: TSpTBXButton;
    ActionList: TActionList;
    actAGamerAdd: TAction;
    actAGamerLink: TAction;
    actFillEditForm: TAction;
    qryCountries: TpFIBDataSet;
    dsCountry: TDataSource;
    procedure actFillEditFormExecute(Sender: TObject);
    procedure trnWriteAfterEnd(EndingTR: TFIBTransaction;
      Action: TTransactionAction; Force: Boolean);
    procedure trnReadAfterStart(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTeachGamers: TfrmTeachGamers;

implementation

{$R *.dfm}

uses uDmFormMain;

procedure TfrmTeachGamers.actFillEditFormExecute(Sender: TObject);
begin
  with gridBGamers.DataSource do
  begin
    if DataSet.Eof then exit;
    edGamerName.Text:= qryBGamers['Gamer_Name'];
    lcbCountry.Value:= qryBGamers['Country_Sign'];
  end;
end;

procedure TfrmTeachGamers.FormCreate(Sender: TObject);
begin
  trnRead.StartTransaction;
end;

procedure TfrmTeachGamers.FormDestroy(Sender: TObject);
begin
  trnRead.Rollback;
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
