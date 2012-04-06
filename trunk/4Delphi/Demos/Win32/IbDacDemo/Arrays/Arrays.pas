{$I DacDemo.inc}

unit Arrays;

interface

uses
  Classes, SysUtils,
{$IFNDEF MSWINDOWS}
  Windows,
{$ENDIF}
  Menus, ImgList, StdCtrls, ComCtrls, Buttons, ExtCtrls, Graphics,
  Controls, Forms, Dialogs, DBCtrls, Grids, DBGrids, IbDacVcl,
{$IFNDEF VER130}
  Variants,
{$ENDIF}
  DB, DBAccess, IBC, DemoFrame, DAScript, IBCScript, MemDS, IBCArray;

type
  TArraysFrame = class(TDemoFrame)
    DBGrid: TDBGrid;
    DataSource: TDataSource;
    ToolBar: TPanel;
    btOpen: TSpeedButton;
    btClose: TSpeedButton;
    IBCQuery: TIBCQuery;
    DBNavigator1: TDBNavigator;
    cbObjectView: TCheckBox;
    cbCacheArrays: TCheckBox;
    cbDeferredArrayRead: TCheckBox;
    cbComplexArrayFields: TCheckBox;
    btAddRecord: TSpeedButton;
    btUpdateRecord: TSpeedButton;
    IBCSQL: TIBCSQL;
    btUpdateSlice: TSpeedButton;
    Panel5: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    procedure btOpenClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure btAddRecordClick(Sender: TObject);
    procedure btUpdateRecordClick(Sender: TObject);
    procedure btUpdateSliceClick(Sender: TObject);
    procedure cbObjectViewClick(Sender: TObject);
    procedure cbCacheArraysClick(Sender: TObject);
    procedure cbDeferredArrayReadClick(Sender: TObject);
    procedure cbComplexArrayFieldsClick(Sender: TObject);
  private
    procedure AddRecord;
  public
    procedure Initialize; override;
    procedure SetDebug(Value: boolean); override;
  end;

implementation

{$IFNDEF FPC}
{$IFDEF CLR}
{$R *.nfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}
{$ENDIF}

procedure TArraysFrame.AddRecord;
var
  Arr: TIBCArray;
  Low1, High1, Low2, High2, Low3, High3, i, j, k: integer;
  VarArr: variant;
begin
  IBCQuery.Append;

  // INTEGER [1:5]
  Arr := IBCQuery.GetArray('INT_ARR1');
  Low1 := Arr.ArrayLowBound[0];
  High1 := Arr.ArrayHighBound[0];
  for i := Low1 to High1 do
    Arr.SetItemAsInteger([i], i);

  // CHAR(10) [1:4, 1:3]
  Arr := IBCQuery.GetArray('CHAR_ARR2');
  Low1 := Arr.ArrayLowBound[0];
  High1 := Arr.ArrayHighBound[0];
  Low2 := Arr.ArrayLowBound[1];
  High2 := Arr.ArrayHighBound[1];
  VarArr := VarArrayCreate([Low1, High1, Low2, High2], varVariant);
  for i := Low1 to High1 do
    for j := Low2 to High2 do
      VarArr[i, j] := 'Str ' + IntToStr(i) + IntToStr(j);
  Arr.Items := VarArr;

  // INTEGER [1:4, 1:2, 1:3]
  Arr := IBCQuery.GetArray('INT_ARR3');
  Low1 := Arr.ArrayLowBound[0];
  High1 := Arr.ArrayHighBound[0];
  Low2 := Arr.ArrayLowBound[1];
  High2 := Arr.ArrayHighBound[1];
  Low3 := Arr.ArrayLowBound[2];
  High3 := Arr.ArrayHighBound[2];
  for i := Low1 to High1 do
    for j := Low2 to High2 do
      for k := Low3 to High3 do
    Arr.SetItemValue([i, j, k], Random(100));

  IBCQuery.Post;
end;

procedure TArraysFrame.btOpenClick(Sender: TObject);
begin
  IBCQuery.Open;
  if IBCQuery.RecordCount = 0 then
    AddRecord;
end;

procedure TArraysFrame.btCloseClick(Sender: TObject);
begin
  IBCQuery.Close;
end;

procedure TArraysFrame.btAddRecordClick(Sender: TObject);
begin
  AddRecord;
end;

procedure TArraysFrame.btUpdateRecordClick(Sender: TObject);
var
  Arr: TIBCArray;
  Low1, High1, i: integer;
begin
  Arr := TIBCArray.Create(IBCSQL.Connection.Handle, IBCSQL.Transaction.Handle,
    'IBDAC_ARRAYS', 'INT_ARR1');
  try
    Arr.Cached := cbCacheArrays.Checked; //Controls applied changes behaviour.
    Arr.GetArrayInfo;                    //Here we read array dimension and type info
    Arr.CreateTemporaryArray;
    Low1 := Arr.ArrayLowBound[0];
    High1 := Arr.ArrayHighBound[0];
    for i := Low1 to High1 do
      Arr.SetItemAsInteger([i], 100 + i); //In case of Cached = False
                                          //each update directly Applied to the server temporary array
    IBCSQL.ParamByName('ID').AsInteger := IBCQuery.FieldByName('ID').AsInteger;
    IBCSQL.ParamByName('ARR1').AsArray := Arr;
  finally
    Arr.Free;
  end;

  Arr := IBCSQL.ParamByName('ARR2').AsArray;
  Arr.DbHandle := IBCSQL.Connection.Handle;
  Arr.TrHandle := IBCSQL.Transaction.Handle;
  Arr.TableName := 'IBDAC_ARRAYS';
  Arr.ColumnName := 'CHAR_ARR2';
  Arr.GetArrayInfo;
  Arr.CreateTemporaryArray;
  IBCSQL.ParamByName('ARR2').AsString :=
    '((''AA'';''BB'';''CC''),(''DD'';''EE'';''FF''),(''GG'';''HH'';''II''),(''JJ'';''KK'';''LL''))';

  IBCSQL.Execute;
  IBCQuery.RefreshRecord;
end;

procedure TArraysFrame.btUpdateSliceClick(Sender: TObject);
var
  Arr: TIBCArray;
  i, j: integer;
  VarArr: variant;
begin
  IBCQuery.Edit;

  // INTEGER [1:4, 1:2, 1:3]
  Arr := IBCQuery.GetArray('INT_ARR3');
  VarArr := Arr.GetItemsSlice([1, 3, 1, 2, 1, 1]);
  for i := 1 to 3 do
    for j := 1 to 2 do
      VarArr[i, j, 1] := -1;
  Arr.SetItemsSlice(VarArr);

  IBCQuery.Post;
end;

procedure TArraysFrame.SetDebug(Value: boolean);
begin
  IBCQuery.Debug := Value;
  IBCSQL.Debug := Value;
end;

procedure TArraysFrame.cbObjectViewClick(Sender: TObject);
begin
  try
    IBCQuery.ObjectView := cbObjectView.Checked;
  except
    cbObjectView.Checked := IBCQuery.ObjectView;
    raise;
  end;
end;

procedure TArraysFrame.cbCacheArraysClick(Sender: TObject);
begin
  try
    IBCQuery.Options.CacheArrays := cbCacheArrays.Checked;
  except
    cbCacheArrays.Checked := IBCQuery.Options.CacheArrays;
    raise;
  end;
end;

procedure TArraysFrame.cbDeferredArrayReadClick(Sender: TObject);
begin
  IBCQuery.Options.DeferredArrayRead := cbDeferredArrayRead.Checked;
end;

procedure TArraysFrame.cbComplexArrayFieldsClick(Sender: TObject);
begin
  try
    IBCQuery.Options.ComplexArrayFields := cbComplexArrayFields.Checked;
  except
    cbComplexArrayFields.Checked := IBCQuery.Options.ComplexArrayFields;
    raise;
  end;
end;

procedure TArraysFrame.Initialize;
begin
  IBCQuery.Connection := TIBCConnection(connection);
  IBCSQL.Connection := TIBCConnection(connection);

  IBCQuery.ObjectView := cbObjectView.Checked;
  IBCQuery.Options.ComplexArrayFields := cbComplexArrayFields.Checked;
  IBCQuery.Options.CacheArrays := cbCacheArrays.Checked;
  IBCQuery.Options.DeferredArrayRead := cbDeferredArrayRead.Checked;
end;

end.
