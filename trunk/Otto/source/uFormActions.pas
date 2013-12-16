unit uFormActions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, uFrameParams, DBGridEhGrouping, ToolCtrlsEh,
  DBGridEhToolCtrls, DB, GridsEh, DBAxisGridsEh, DBGridEh, FIBDataSet,
  pFIBDataSet, uFrameCriterias, TB2Dock, TB2Toolbar, TBX;

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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmActionCodeSetup: TfrmActionCodeSetup;

implementation

{$R *.dfm}

end.
