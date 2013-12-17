unit uFormActions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, uFrameParams, DBGridEhGrouping, ToolCtrlsEh,
  DBGridEhToolCtrls, DB, GridsEh, DBAxisGridsEh, DBGridEh, FIBDataSet,
  pFIBDataSet, uFrameCriterias, TB2Dock, TB2Toolbar, TBX, FIBDatabase,
  pFIBDatabase, ComCtrls, JvExComCtrls, JvDBTreeView;

type
  TfrmActionCodeSetup = class(TForm)
    pnl1: TPanel;
    pnl3: TPanel;
    spl1: TSplitter;
    spl2: TSplitter;
    pnl4: TPanel;
    pnl5: TPanel;
    spl3: TSplitter;
    frmParamActionTree: TFrame2;
    spl4: TSplitter;
    grdActionTree: TDBGridEh;
    dsActionTree: TDataSource;
    dsActionCodes: TDataSource;
    grdActionCodes: TDBGridEh;
    qryActionCodes: TpFIBDataSet;
    qryActionTree: TpFIBDataSet;
    qryActionCodeParams: TpFIBDataSet;
    spl5: TSplitter;
    frmParamActionCode: TFrame2;
    frmCritActionCode: TFrame1;
    dckActionTree: TTBXDock;
    tbActionTree: TTBXToolbar;
    dckActionCode: TTBXDock;
    tbActionCodes: TTBXToolbar;
    frmCritActionTree: TFrame1;
    qryActionCodeCrit: TpFIBDataSet;
    qryActionTreeCrit: TpFIBDataSet;
    qryActionTreeParams: TpFIBDataSet;
    trnWrite: TpFIBTransaction;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure qryActionCodesAfterScroll(DataSet: TDataSet);
    procedure qryActionTreeAfterScroll(DataSet: TDataSet);
    procedure grdActionTreeDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmActionCodeSetup: TfrmActionCodeSetup;

implementation

uses
  uFormParamEdit;

{$R *.dfm}

procedure TfrmActionCodeSetup.FormCreate(Sender: TObject);
begin
  trnWrite.StartTransaction;
  frmParamEdit:= TfrmParamEdit.Create(Self);
  frmParamEdit.trnWrite:= trnWrite;
end;

procedure TfrmActionCodeSetup.FormDestroy(Sender: TObject);
begin
  FreeAndNil(frmParamEdit);
  trnWrite.Rollback;
end;

procedure TfrmActionCodeSetup.FormActivate(Sender: TObject);
begin
  qryActionCodes.Open;
  qryActionTree2.Open;
end;

procedure TfrmActionCodeSetup.FormDeactivate(Sender: TObject);
begin
  qryActionTreeCrit.Close;
  qryActionTreeParams.Close;
  qryActionTree.Close;
  qryActionCodeCrit.Close;
  qryActionCodeParams.Close;
  qryActionCodes.Close;
end;

procedure TfrmActionCodeSetup.qryActionCodesAfterScroll(DataSet: TDataSet);
begin
  DataSet.Tag:= DataSet['Action_Code'];
end;

procedure TfrmActionCodeSetup.qryActionTreeAfterScroll(DataSet: TDataSet);
begin
  DataSet.Tag:= DataSet['actiontreeitem_id'];
end;

procedure TfrmActionCodeSetup.grdActionTreeDblClick(Sender: TObject);
begin
  qryActionCodes.Locate('Action_Code', qryActionTree['Child_Code'], []);
end;

end.
