unit uBaseForm;

interface    
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Provider, pFIBClientDataSet, DB, DBClient, ImgList, TB2Item,
  ActnList, GridsEh, DBGridEh, TBX, ExtCtrls, DBCtrls, TB2Dock, TB2Toolbar,
  ComCtrls, FIBDataSet, pFIBDataSet, TBXDkPanels;

type
  TfrmBaseForm = class(TForm)
    TBXDockUp: TTBXDock;
    TBXToolbar: TTBXToolbar;
    DBNavigator: TDBNavigator;
    TBControlItem1: TTBControlItem;
    gridMain: TDBGridEh;
    ActionList: TActionList;
    TBImageList: TTBImageList;
    dsMain: TDataSource;
    actOk: TAction;
    btnSelect: TTBXItem;
    actCancel: TAction;
    btnCancel: TTBXItem;
    actClose: TAction;
    btnCLose: TTBXItem;
    Panel: TPanel;
    pcDetail: TPageControl;
    Splitter1: TSplitter;
    tblMain: TpFIBDataSet;
    dckRight: TTBXMultiDock;
    procedure ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure FormDeactivate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actCancelExecute(Sender: TObject);
    procedure gridMainGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure gridMainDblClick(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure gridMainApplyFilter(Sender: TObject);
    procedure gridMainTitleBtnClick(Sender: TObject; ACol: Integer;
      Column: TColumnEh);
  private
    function GetValue(St: String): Variant;
    { Private declarations }
  protected
    procedure OpenDataSets; virtual;
    procedure CloseDataSets; virtual;
  public
    { Public declarations }
    ReadOnly: Boolean;
    Filter: String;
    function ShowModalForState(State: TDataSetState): Integer;
  end;

var
  frmBaseForm: TfrmBaseForm;

implementation

uses
  dm, GvColor, Math;

{$R *.dfm}

{ TForm1 }

procedure TfrmBaseForm.ActionListUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  actOk.Enabled:= tblMain.State = dsBrowse;
end;

procedure TfrmBaseForm.CloseDataSets;
begin
  tblMain.Close;
end;

procedure TfrmBaseForm.OpenDataSets;
begin
  if Filter <> '' then
  begin
    tblMain.Filter:= Filter;
    tblMain.Filtered:= true;
  end;
  if ReadOnly then
    tblMain.AllowedUpdateKinds:= [];
  tblMain.Open;
end;

procedure TfrmBaseForm.FormDeactivate(Sender: TObject);
begin
  CloseDataSets;
end;

procedure TfrmBaseForm.FormActivate(Sender: TObject);
begin
  OpenDataSets;
end;

function TfrmBaseForm.GetValue(St: String): Variant;
var
  s1: String;
begin
  if St='NULL' then
    result:= null
  else
  begin
    s1:= Copy(St,2,Length(St)-2);
    if '"'+s1+'"' = St then
      result:= s1
    else
      result:= st;
  end
end;

procedure TfrmBaseForm.FormCreate(Sender: TObject);
begin
  ReadOnly:= true;
end;

procedure TfrmBaseForm.actCancelExecute(Sender: TObject);
begin
  ModalResult:= mrCancel;
end;

function TfrmBaseForm.ShowModalForState(State: TDataSetState): Integer;
begin
  actOk.Visible:= State in [dsEdit, dsInsert];
  actCancel.Visible:= actOk.Visible;
  actClose.Visible:= not actOk.Visible;
  result:= ShowModal;
end;

procedure TfrmBaseForm.gridMainGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
var
  Ignore_fld: TField;
begin
  if (Column.Field=nil) then exit;
  Ignore_Fld:= Column.Field.DataSet.FindField('Ignore_Flg');
  if Assigned(Ignore_Fld) and (Ignore_Fld.Value = 1) then
  begin
    AFont.Color:= clInactiveCaption;
  end;

  Background:= clWhite;
  if Column.Field.IsNull then
    Background:= Light75(clRed)
  else
  if TDBGridEh(Sender).ReadOnly or Column.ReadOnly or Column.Field.ReadOnly then
    Background:= clBtnFace;
end;

procedure TfrmBaseForm.gridMainDblClick(Sender: TObject);
begin
  if actOk.Visible then
    actOk.Execute;
end;

procedure TfrmBaseForm.actCloseExecute(Sender: TObject);
begin
  ModalResult:= mrCancel;
end;

procedure TfrmBaseForm.gridMainApplyFilter(Sender: TObject);
var
  CurFilter, fValue: String;
  i: Integer;
  Column: TColumnEh;
begin
  CurFilter:= Filter;
  if CurFilter = '' then CurFilter:= '1=1';
  For i:= 0 to gridMain.Columns.Count-1 do
  begin
    Column:= gridMain.Columns[i];
    if Column.STFilter.ExpressionStr<>'' then
    begin
      fValue:= Column.STFilter.ExpressionStr;
      if UpperCase(fValue) = 'NULL' then
        fValue:= 'IS NULL'
      else
      Case Column.Field.DataType of
        ftString: fValue:= ' LIKE '+QuotedStr(fValue+'%');
      else
        fValue:= '='+fValue;
      end;
      CurFilter := CurFilter + ' AND '+ Column.FieldName + fValue;
    end;
  end;
  tblMain.Filter:= CurFilter;
  tblMain.Filtered:= true;
  tblMain.Refresh;
end;

procedure TfrmBaseForm.gridMainTitleBtnClick(Sender: TObject;
  ACol: Integer; Column: TColumnEh);
begin
  gridMain.STFilter.Visible:= not gridMain.STFilter.Visible;
end;

end.
