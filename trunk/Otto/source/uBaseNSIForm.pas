unit uBaseNSIForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, FIBDataSet, pFIBDataSet, GridsEh,
  DBGridEh, StdCtrls, JvExStdCtrls, JvGroupBox, ExtCtrls, JvExExtCtrls,
  JvExtComponent, JvPanel, TB2Dock, TB2Toolbar, TBX, ComCtrls, ActnList,
  ImgList, PngImageList, TB2Item, FIBDatabase, pFIBDatabase,
  DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DBAxisGridsEh;

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
    trnRead: TpFIBTransaction;
    tlBarNsiActions: TTBXToolbar;
    trnWrite: TpFIBTransaction;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure trnReadBeforeEnd(EndingTR: TFIBTransaction;
      Action: TTransactionAction; Force: Boolean);
    procedure trnReadAfterStart(Sender: TObject);
  private
    { Private declarations }
    FBookmark: TBookmark;
  public
    { Public declarations }
  end;

implementation

uses
  udmOtto;

{$R *.dfm}

procedure TBaseNSIForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:= caFree;
end;

procedure TBaseNSIForm.trnReadBeforeEnd(EndingTR: TFIBTransaction;
  Action: TTransactionAction; Force: Boolean);
begin
  FBookmark:= qryMain.GetBookMark;
  qryMain.DisableControls;
  qryMain.Close;
end;

procedure TBaseNSIForm.trnReadAfterStart(Sender: TObject);
begin
  qryMain.Open;
  if Assigned(FBookmark) then
  begin
    qryMain.GotoBookmark(FBookmark);
    qryMain.FreeBookmark(FBookmark);
    FBookmark:= nil;
    qryMain.EnableControls;
  end;
end;

end.
