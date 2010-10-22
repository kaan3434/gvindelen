unit uEvents;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uBaseForm, Provider, pFIBClientDataSet, DB, DBClient, ImgList,
  TB2Item, ActnList, ComCtrls, ExtCtrls, GridsEh, DBGridEh, DBCtrls, TBX,
  TB2Dock, TB2Toolbar, FIBDataSet, pFIBDataSet, GvCollapsePanel;

type
  TfrmEvents = class(TfrmBaseForm)
    tsTournirs: TTabSheet;
    cdsTournirs: TpFIBClientDataSet;
    dspTournirs: TpFIBDataSetProvider;
    dsTournirs: TDataSource;
    gridTournirs: TDBGridEh;
    cdsTournirsTOURNIR_ID: TIntegerField;
    cdsTournirsBOOKER_ID: TSmallintField;
    cdsTournirsBOOKER_NM: TStringField;
    cdsTournirsBSPORT_ID: TIntegerField;
    cdsTournirsTOURNIR_NM: TStringField;
    cdsTournirsASPORT_ID: TIntegerField;
    cdsTournirsASPORT_NM: TStringField;
    cdsTournirsCOUNTRY_SGN: TStringField;
    cdsTournirsUSED_DT: TDateField;
    cdsTournirsIGNORE_FLG: TSmallintField;
    tsEvents: TTabSheet;
    DBGridEh1: TDBGridEh;
    cdsSubEvents: TpFIBClientDataSet;
    tsAGamers: TTabSheet;
    dspSubEvents: TpFIBDataSetProvider;
    dsSubEvents: TDataSource;
    DBGridEh2: TDBGridEh;
    actAGamer1: TAction;
    actAGamer2: TAction;
    cdsAGamers: TpFIBClientDataSet;
    dspAGamers: TpFIBDataSetProvider;
    procedure gridMainGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
  private
    { Private declarations }
  protected
    procedure OpenDataSets; override;
    procedure CloseDataSets; override;
  public
    { Public declarations }
  end;

var
  frmEvents: TfrmEvents;

implementation

uses dm, GvColor;

{$R *.dfm}

procedure TfrmEvents.CloseDataSets;
begin
  cdsTournirs.Close;
  inherited;
end;

procedure TfrmEvents.OpenDataSets;
begin
  inherited;
  cdsTournirs.Open;
end;

procedure TfrmEvents.gridMainGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if Column.FieldName = 'AGAMER1_NM' then
  begin
    if Column.Field.DataSet['AGamer1_Id'] = null then
      Background:= Light75(clRed);
  end
  else
  if Column.FieldName = 'AGAMER2_NM' then
  begin
    if Column.Field.DataSet['AGamer2_Id'] = null then
      Background:= Light75(clRed);
  end;
end;

end.
