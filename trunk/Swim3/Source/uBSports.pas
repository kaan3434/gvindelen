unit uBSports;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uBaseForm, Provider, pFIBClientDataSet, DB, DBClient, ImgList,
  TB2Item, ActnList, GridsEh, DBGridEh, ExtCtrls, DBCtrls, TBX, TB2Dock,
  TB2Toolbar, ComCtrls, FIBSQLMonitor, StdCtrls,
  FIBDataSet, pFIBDataSet, DBGridEhGrouping, TBXDkPanels;

type
  TfrmBSports = class(TfrmBaseForm)
    actSelectASports: TAction;
    dsASports: TDataSource;
    dsBTournirs: TDataSource;
    tsTournirs: TTabSheet;
    gridBTournirs: TDBGridEh;
    tsASports: TTabSheet;
    tblASports: TpFIBDataSet;
    gridASports: TDBGridEh;
    tblBTournirs: TpFIBDataSet;
    procedure actSelectASportsExecute(Sender: TObject);
    procedure gridASportsDblClick(Sender: TObject);
  protected
    procedure OpenDataSets; override;
    procedure CloseDataSets; override;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBSports: TfrmBSports;

implementation

uses dm, uASports;

{$R *.dfm}

{ TfrmBSports }

procedure TfrmBSports.actSelectASportsExecute(Sender: TObject);
var
  BSportId: variant;
begin
  BSportId:= tblMain['BSport_Id'];
  dmSwim.ModifyBSport(tblASports['ASport_Id'], tblMain['Booker_Id'],
                      tblMain['BSport_Nm'], BSportId);
  tblMain.Refresh;
end;

procedure TfrmBSports.CloseDataSets;
begin
  tblASports.Close;
  tblBTournirs.Close;
  inherited;
end;

procedure TfrmBSports.OpenDataSets;
begin
  inherited;
  tblASports.Open;
  tblBTournirs.Open;
end;

procedure TfrmBSports.gridASportsDblClick(Sender: TObject);
begin
  actSelectASportsExecute(Self);
end;

end.
