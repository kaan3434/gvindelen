unit uBaseNSIForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBGridEhGrouping, DB, FIBDataSet, pFIBDataSet, GridsEh,
  DBGridEh, StdCtrls, JvExStdCtrls, JvGroupBox, ExtCtrls, JvExExtCtrls,
  JvExtComponent, JvPanel, TB2Dock, TB2Toolbar, TBX, ComCtrls, ActnList,
  ImgList, PngImageList, TB2Item, FIBDatabase, pFIBDatabase;

type
  TBaseNSIForm = class(TForm)
    StatusBar: TStatusBar;
    dckTop: TTBXDock;
    pnlMain: TJvPanel;
    grBoxMain: TJvGroupBox;
    grdMain: TDBGridEh;
    qryMain: TpFIBDataSet;
    dsMain: TDataSource;
    actListMain: TActionList;
    imgListMain: TPngImageList;
    actEdit: TAction;
    actCommit: TAction;
    actRollback: TAction;
    actWizard: TAction;
    trnNSI: TpFIBTransaction;
    procedure actEditExecute(Sender: TObject);
    procedure actListMainUpdate(Action: TBasicAction;
      var Handled: Boolean);
    procedure actCommitExecute(Sender: TObject);
    procedure actRollbackExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  udmOtto;

{$R *.dfm}

procedure TBaseNSIForm.actEditExecute(Sender: TObject);
begin
  trnNSI.StartTransaction;
  dsMain.AutoEdit:= True;
end;

procedure TBaseNSIForm.actListMainUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  actEdit.Enabled:= not trnNSI.Active;
  actCommit.Enabled:= trnNSI.Active;
  actRollback.Enabled:= trnNSI.Active;
end;

procedure TBaseNSIForm.actCommitExecute(Sender: TObject);
begin
  trnNSI.Commit;
end;

procedure TBaseNSIForm.actRollbackExecute(Sender: TObject);
begin
  trnNSI.Rollback;
end;

procedure TBaseNSIForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:= caFree;
end;

end.
