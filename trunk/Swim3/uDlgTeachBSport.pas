unit uDlgTeachBSport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBCtrlsEh, DB, ActnList, ExtCtrls,
  DBLookupEh, DBClient, Provider, DBCtrls, ComCtrls, DBGridEh, Mask;

type
  TDlgTeachBSport = class(TForm)
    lAbstractSport: TLabel;
    btnOk: TButton;
    ActionList: TActionList;
    actModifyBSport: TAction;
    lcbASports: TDBLookupComboboxEh;
    cdsBSports: TClientDataSet;
    cdsASports: TClientDataSet;
    dsASports: TDataSource;
    prvASports: TDataSetProvider;
    prvBSports: TDataSetProvider;
    Navigator: TDBNavigator;
    dsUBSports: TDataSource;
    dbeBookerName: TDBEdit;
    dbeBSportName: TDBEdit;
    lblBookerName: TLabel;
    lblBSportName: TLabel;
    sb: TStatusBar;
    actShowASports: TAction;
    procedure FormActivate(Sender: TObject);
    procedure actModifyBSportUpdate(Sender: TObject);
    procedure actModifyBSportExecute(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure cdsBSportsAfterOpen(DataSet: TDataSet);
    procedure cdsBSportsAfterScroll(DataSet: TDataSet);
    procedure cdsBSportsBeforeOpen(DataSet: TDataSet);
    procedure actDeleteASportExecute(Sender: TObject);
  private
    { Private declarations }
    BookerId: Integer;
    BSportId: Integer;
    BSportName: String;
    ASportName: String;
    procedure UpdateIndicator;
  public
    { Public declarations }
    BSportFilter: String;
  end;

var
  DlgTeachBSport: TDlgTeachBSport;

implementation

uses uSwim, dm, ADODB, pFIBStoredProc;

{$R *.dfm}

procedure TDlgTeachBSport.FormActivate(Sender: TObject);
begin
  cdsASports.Open;
  cdsBSports.Open;
end;

procedure TDlgTeachBSport.actModifyBSportUpdate(Sender: TObject);
begin
//  actAddSport.Enabled:= lcbASports.;
end;

procedure TDlgTeachBSport.actModifyBSportExecute(Sender: TObject);
begin
  cdsBSports.ApplyUpdates(0);
  ModalResult:= mrOk;
end;

procedure TDlgTeachBSport.FormDeactivate(Sender: TObject);
begin
  cdsASports.Close;
  cdsBSports.Close;
  BSportFilter:= '';
end;

procedure TDlgTeachBSport.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  mr: Word;
begin
  if (cdsBSports.ChangeCount > 0) then
  begin
    mr:= MessageDlg('Сохранить данные?', mtConfirmation, mbYesNoCancel, 0);
    CanClose:= mr in [mrYes, mrNo];
    if mr = mrYes then
      cdsBSports.ApplyUpdates(0);
  end;
end;

procedure TDlgTeachBSport.cdsBSportsAfterOpen(DataSet: TDataSet);
begin
  UpdateIndicator;
end;

procedure TDlgTeachBSport.UpdateIndicator;
begin
  sb.SimpleText:= Format('%u/%u', [cdsBSports.RecNo, cdsBSports.RecordCount]);
end;

procedure TDlgTeachBSport.cdsBSportsAfterScroll(DataSet: TDataSet);
begin
  UpdateIndicator;
end;

procedure TDlgTeachBSport.cdsBSportsBeforeOpen(DataSet: TDataSet);
begin
  cdsBSports.Filter:= BSportFilter;
  if cdsBSports.Filter <> '' then
    cdsBSports.Filtered:= true;
end;

procedure TDlgTeachBSport.actDeleteASportExecute(Sender: TObject);
begin
  cdsASports.Locate('ASport_Id', lcbASports.Value,[]);
  cdsASports.Delete;
  cdsASports.ApplyUpdates(0);
end;

end.
