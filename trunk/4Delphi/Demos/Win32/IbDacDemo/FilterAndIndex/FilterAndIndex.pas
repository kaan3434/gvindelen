{$I DacDemo.inc}

unit FilterAndIndex;

interface

uses
  Classes, SysUtils,
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  Menus, ImgList, StdCtrls, ComCtrls, Buttons, ExtCtrls, Graphics,
  Controls, Forms, Dialogs, DBCtrls, Grids, DBGrids, IbDacVcl,
{$IFNDEF VER130}
  Variants,
{$ENDIF}
{$IFDEF FPC}
  LResources,
{$ENDIF}
  DB, {$IFNDEF FPC}MemDS{$ELSE}MemDataSet{$ENDIF},
  DBAccess, IBC, DemoFrame;

type
  TFilterAndIndexFrame = class(TDemoFrame)
    Query: TIBCQuery;
    DBGrid: TDBGrid;
    DataSource: TDataSource;
    Panel4: TPanel;
    ToolBar: TPanel;
    btClose: TSpeedButton;
    btOpen: TSpeedButton;
    DBNavigator1: TDBNavigator;
    Panel3: TPanel;
    Query2: TIBCQuery;
    LookupQuery: TIBCQuery;
    Query2EMPNO: TIntegerField;
    Query2ENAME: TStringField;
    Query2JOB: TStringField;
    Query2MGR: TIntegerField;
    Query2DEPTNO: TIntegerField;
    LookupQueryDEPTNO: TIntegerField;
    LookupQueryDNAME: TStringField;
    LookupQueryLOC: TStringField;
    Query2CALCULATED: TIntegerField;
    Query2LOOKUP: TStringField;
    Label1: TLabel;
    lbIndexFieldNames: TLabel;
    Panel5: TPanel;
    Panel2: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    lbFields: TListBox;
    cbCalcFields: TCheckBox;
    cbFilter: TCheckBox;
    edFilter: TEdit;
    Panel1: TPanel;
    cbCacheCalcFields: TCheckBox;
    cbIndex: TCheckBox;
    Panel6: TPanel;
    Panle3: TPanel;
    Query2SAL: TIntegerField;
    Query2COMM: TIntegerField;
    Query2HIREDATE: TDateTimeField;
    procedure btOpenClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure Query2CalcFields(DataSet: TDataSet);
    procedure cbFilterClick(Sender: TObject);
    procedure cbCalcFieldsClick(Sender: TObject);
    procedure cbIndexClick(Sender: TObject);
    procedure lbFieldsClick(Sender: TObject);
    procedure cbCacheCalcFieldsClick(Sender: TObject);
    procedure edFilterExit(Sender: TObject);
  private
    FOldActive: boolean;
    FFilterFilterNames: TStringList;
    procedure BeginChange;
    procedure EndChange;
  public
    procedure Initialize; override;
    procedure SetDebug(Value: boolean); override;
    destructor Destroy; override;
  end;

implementation

{$IFNDEF FPC}
{$IFDEF CLR}
{$R *.nfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}
{$ENDIF}

procedure TFilterAndIndexFrame.btOpenClick(Sender: TObject);
var
  i: integer;
begin
  if DataSource.DataSet.Active then
    Exit;
  lbFields.Items.Clear;
  lbFieldsClick(nil);
  cbFilterClick(nil);
  DataSource.DataSet.Open;
  for i := 0 to DataSource.DataSet.FieldCount - 1 do
    lbFields.Items.Add(DataSource.DataSet.Fields[i].FieldName);
end;

procedure TFilterAndIndexFrame.btCloseClick(Sender: TObject);
begin
  DataSource.DataSet.Close;
end;

procedure TFilterAndIndexFrame.SetDebug(Value: boolean);
begin
  Query.Debug := Value;
  Query2.Debug := Value;
end;

procedure TFilterAndIndexFrame.Query2CalcFields(DataSet: TDataSet);
begin
  Query2CALCULATED.AsInteger := Query2EMPNO.AsInteger * 2;
end;

procedure TFilterAndIndexFrame.BeginChange;
begin
  FOldActive := DataSource.DataSet.Active;
  if FOldActive then
    btCloseClick(nil);
end;

procedure TFilterAndIndexFrame.EndChange;
begin
  if FOldActive then
    btOpenClick(nil);
end;

procedure TFilterAndIndexFrame.cbFilterClick(Sender: TObject);
begin
  DataSource.DataSet.Filtered := cbFilter.Checked;
  DataSource.DataSet.Filter := edFilter.Text;
end;

procedure TFilterAndIndexFrame.cbCalcFieldsClick(Sender: TObject);
begin
  BeginChange;
  if cbCalcFields.Checked then
    DataSource.DataSet := Query2
  else
    DataSource.DataSet := Query;
  EndChange;
end;

procedure TFilterAndIndexFrame.cbIndexClick(Sender: TObject);
begin
  if cbIndex.Checked then
    TIBCQuery(DataSource.DataSet).IndexFieldNames := lbIndexFieldNames.Caption
  else
    TIBCQuery(DataSource.DataSet).IndexFieldNames := ''
end;

procedure TFilterAndIndexFrame.lbFieldsClick(Sender: TObject);
var
  i, k: integer;
  s: string;
begin
  i := 0;
  while i < FFilterFilterNames.Count do begin
    k := lbFields.Items.IndexOf(FFilterFilterNames[i]);
    if (k < 0) or not lbFields.Selected[k] then
      FFilterFilterNames.Delete(i)
    else
      Inc(i);
  end;
  for i := 0 to lbFields.Items.Count - 1 do
    if lbFields.Selected[i] and
      (FFilterFilterNames.IndexOf(lbFields.Items[i]) < 0) then
      FFilterFilterNames.Add(lbFields.Items[i]);

  s := '';
  for i := 0 to FFilterFilterNames.Count - 1 do begin
    if s <> '' then
      s := s + ', ';
    s := s + FFilterFilterNames[i];
  end;
  lbIndexFieldNames.Caption := s;

  cbIndexClick(nil);
end;

procedure TFilterAndIndexFrame.cbCacheCalcFieldsClick(Sender: TObject);
begin
  BeginChange;
  TIBCQuery(DataSource.DataSet).Options.CacheCalcFields := cbCacheCalcFields.Checked;
  EndChange;
end;

procedure TFilterAndIndexFrame.edFilterExit(Sender: TObject);
begin
  cbFilterClick(nil);
end;

procedure TFilterAndIndexFrame.Initialize;
begin
  Query.Connection := TIBCConnection(Connection);
  Query2.Connection := TIBCConnection(Connection);
  LookupQuery.Connection := TIBCConnection(Connection);
  
  FFilterFilterNames := TStringList.Create;
end;

destructor TFilterAndIndexFrame.Destroy;
begin
  FFilterFilterNames.Free;
  inherited;
end;

{$IFDEF FPC}
initialization
  {$i FilterAndIndex.lrs}
{$ENDIF}

end.
