{$I DacDemo.inc}

unit Sql;

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
  CRTypes, CRFunctions, DB, {$IFNDEF FPC}MemDS{$ELSE}MemDataSet{$ENDIF},
  MemUtils, DBAccess, IBC, DemoFrame, DAScript, IBCScript, ParamType, IbDacDemoForm;

type
  TSqlFrame = class(TDemoFrame)
    meSQL: TMemo;
    IBCSQL: TIBCSQL;
    ToolBar: TPanel;
    btExecute: TSpeedButton;
    btParType: TSpeedButton;
    btExecuteNext: TSpeedButton;
    btCreateProcCall: TSpeedButton;
    meResult: TMemo;
    Splitter1: TSplitter;
    edStoredProcNames: TComboBox;
    btPrepare: TSpeedButton;
    btUnprepare: TSpeedButton;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    procedure btExecuteClick(Sender: TObject);
    procedure btParTypeClick(Sender: TObject);
    procedure btExecuteNextClick(Sender: TObject);
    procedure btCreateProcCallClick(Sender: TObject);
    procedure meSQLExit(Sender: TObject);
    procedure btPrepareClick(Sender: TObject);
    procedure btUnprepareClick(Sender: TObject);
    procedure edStoredProcNamesChange(Sender: TObject);
    procedure edStoredProcNamesDropDown(Sender: TObject);

  private
    FParamTypeForm: TParamTypeForm;
    Procedure ShowState;
  public
    procedure Initialize; override;
    procedure SetDebug(Value: boolean); override;

    destructor Destroy; override;
  end;

var
  fmSql: TSqlFrame;

implementation

{$IFNDEF FPC}
{$IFDEF CLR}
{$R *.nfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}
{$ENDIF}

procedure TSqlFrame.ShowState;
var
  St:string;

  procedure AddSt(S:string);
  begin
    if St <> '' then
      St := St + ', ';
    St := St + S;
  end;

begin
  St := '';

  if IBCSQL.Prepared then begin
    AddSt('Prepared');
  end;

  IbDacForm.StatusBar.Panels[1].Text := St;

  meSQL.Lines.Text := IBCSQL.SQL.Text;
end;

procedure TSqlFrame.btExecuteClick(Sender: TObject);
var
  s: string;
begin
  IBCSQL.Text := meSQL.Lines.Text;
  IBCSQL.Execute;
  s := 'Rows affected: ' + IntToStr(IBCSQL.RowsAffected);
  if not IBCSQL.Prepared then
    s := s + '  (You should prepare query explicitly to get correct affected rows count.)';
  meResult.Lines.Add(s);
end;

procedure TSqlFrame.btParTypeClick(Sender: TObject);
begin
  FParamTypeForm.ShowModal;
end;

procedure TSqlFrame.btExecuteNextClick(Sender: TObject);
var
  i: integer;
begin
  IBCSql.Text := 'select DEPTNO from DEPT';
  IBCSql.Prepare;
// We should create out Params that corresponds to selected fields
// manually after explicit preparation in the same order as the fields
  with TParam(IBCSql.Params.Add) do begin
    ParamType := ptOutPut;
    DataType := ftInteger;
    Name := 'DEPTNO';
  end;
  IBCSql.Execute;
  meSQL.Lines.Text := 'select DEPTNO from DEPT';
  meResult.Lines.Clear;
  i := 1;
  while IBCSql.ExecuteNext do begin
    meResult.Lines.Add(format('Iteration: %d  Parameter DEPTNO:  %s',
      [i, IBCSql.ParamByName('DEPTNO').AsString]));
    inc(i);
  end;
  meResult.Lines.Add('');
  IBCSql.UnPrepare;
end;

procedure TSqlFrame.btCreateProcCallClick(Sender: TObject);
var
  i: integer;
  s: string;
begin
  try
    IBCSQL.CreateProcCall(edStoredProcNames.Text);
    meResult.Lines.Text := IBCSQL.SQL.Text;
    meResult.Lines.Add('Parameters: ');
    for i := 0 to IBCSQL.Params.Count - 1 do begin
      s := '  ' + IBCSql.Params[i].Name + ': ';;
      case IBCSQL.Params[i].DataType of
        ftString: s := s + 'String';
        ftInteger: s := s + 'Integer';
        ftFloat: s := s + 'Float';
        ftDate: s := s + 'Date';
      else
        s := s + '< Other >';
      end;
      case IBCSQL.Params[i].ParamType of
        ptUnknown: s := s + ' (Unknown)';
        ptInput: s := s + ' (Input)';
        ptOutput: s := s + ' (Output)';
        ptInputOutput: s := s + ' (InputOutput)';
        ptResult: s := s + ' (Result)';
      end;
      meResult.Lines.Add(s);
    end;
  finally
    meResult.Lines.Add('');
    ShowState;
  end;
end;

procedure TSqlFrame.meSQLExit(Sender: TObject);
begin
  IBCSQL.Text := meSQL.Lines.Text;
end;

procedure TSqlFrame.btPrepareClick(Sender: TObject);
begin
  try
    IBCSQL.Text := meSQL.Lines.Text;
    IBCSQL.Prepare;
  finally
    ShowState;
  end;
end;

procedure TSqlFrame.btUnprepareClick(Sender: TObject);
begin
  try
    IBCSQL.UnPrepare;
  finally
    ShowState;
  end;
end;

procedure TSqlFrame.edStoredProcNamesChange(Sender: TObject);
begin
  ShowState;
end;

procedure TSqlFrame.edStoredProcNamesDropDown(Sender: TObject);
var
  SpName: String;
  List: _TStringList;
begin
  SpName := edStoredProcNames.Text;
  List := _TStringList.Create;
  try
    Connection.GetStoredProcNames(List);
    AssignStrings(List, edStoredProcNames.Items);
  finally
    List.Free;
  end;
  edStoredProcNames.ItemIndex := edStoredProcNames.Items.IndexOf(SpName);
end;

procedure TSqlFrame.Initialize;
begin
  IBCSQL.Connection := TIBCConnection(Connection);
  
  FParamTypeForm := TParamTypeForm.Create(nil);
  FParamTypeForm.Params := IBCSQL.Params;
  meSQL.Lines.Text := IBCSQL.SQL.Text;
  edStoredProcNames.Items.Add('SEL_FROM_EMP');
  edStoredProcNames.ItemIndex := 0;
  edStoredProcNamesChange(self)
end;

procedure TSqlFrame.SetDebug(Value: boolean);
begin
  IBCSQL.Debug := Value;
end;

destructor TSqlFrame.Destroy;
begin
  FParamTypeForm.Free;
  inherited;
end;

{$IFDEF FPC}
initialization
  {$i Sql.lrs}
{$ENDIF}

end.




