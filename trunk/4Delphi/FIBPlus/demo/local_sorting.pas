unit local_sorting;

interface

uses
  common,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Grids, DBGrids, ExtCtrls, Db, FIBDataSet, pFIBDataSet;

type

  TOrderStringList = class(TStringList)
  protected
    function GetAscending(Index: Integer): Boolean;
    procedure SetAscending (Index: Integer; Value: Boolean);
  public
    property Ascending[Index: Integer]: Boolean read GetAscending write SetAscending;
  end;

  TfrmLocalSorting = class(TForm)
    dbgCountry: TDBGrid;
    btnClose: TBitBtn;
    Label1: TLabel;
    dtCountry: TpFIBDataSet;
    dtCountryID: TFIBIntegerField;
    dtCountryNAME: TFIBStringField;
    dtCountryCAPITAL: TFIBStringField;
    dtCountryCONTINENT: TFIBStringField;
    dtCountryAREA: TFIBFloatField;
    dtCountryPOPULATION: TFIBFloatField;
    dsCountry: TDataSource;
    btnDeleteFieldFromSort: TButton;
    dtCountryCOMPUTED_FIELD: TFloatField;
    Label2: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btnDeleteFieldFromSortClick(Sender: TObject);
    procedure dtCountryCalcFields(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure dbgCountryTitleClick(Column: TColumn);
  private
    { Private declarations }
    SortFields: TOrderStringList;
    procedure DoSort;
  public
    { Public declarations }
  end;

var
  frmLocalSorting: TfrmLocalSorting;

implementation

uses dm_main;

{$R *.DFM}

{ TOrderStringList }

function TOrderStringList.GetAscending(Index: Integer): boolean;
begin
  Result := boolean(integer(Objects[Index]));
end;

procedure TOrderStringList.SetAscending(Index: Integer; Value: boolean);
begin
  Objects[Index] := pointer(integer(Value));
end;

{ TfrmLocalSorting }
procedure TfrmLocalSorting.FormCreate(Sender: TObject);
begin
  SortFields := TOrderStringList.Create;
end;

procedure TfrmLocalSorting.FormShow(Sender: TObject);
begin
  dtCountry.Open;
end;

procedure TfrmLocalSorting.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  dtCountry.Close;
end;

procedure TfrmLocalSorting.FormDestroy(Sender: TObject);
begin
  SortFields.Free;
end;

procedure TfrmLocalSorting.DoSort;
var
  Orders: array of Boolean;
  Index: Integer;
begin
// TpFIBDataset
//procedure DoSortEx(Fields: array of integer; Ordering: array of Boolean); overload;
//procedure DoSortEx(Fields: TStrings; Ordering: array of Boolean); overload;

  if SortFields.Count = 0 then
  begin
    dtCountry.CloseOpen(false);
    Exit;
  end;

  SetLength(Orders, SortFields.Count);

  for Index := 0 to Pred(SortFields.Count) do
     Orders[Index] := SortFields.Ascending[Index];

  dtCountry.DoSortEx(SortFields, Orders);
end;

procedure TfrmLocalSorting.btnDeleteFieldFromSortClick(Sender: TObject);
var
  aField: string;
  aFieldIndex: integer;
begin
  aField := dbgCountry.SelectedField.FieldName;
  aFieldIndex := SortFields.IndexOf(aField);

  if aFieldIndex <> -1 then begin
    SortFields.Delete(aFieldIndex);
    dbgCountry.SelectedField.DisplayLabel := aField;
    DoSort;
  end;
end;

procedure TfrmLocalSorting.dtCountryCalcFields(DataSet: TDataSet);
begin
  with DataSet do
    FieldByName('COMPUTED_FIELD').Value :=
      FieldByName('POPULATION').Value /
      FieldByName('AREA').Value;
end;

procedure TfrmLocalSorting.dbgCountryTitleClick(Column: TColumn);
const
  OrderStr: array [boolean] of string = (' [Desc]', ' [Asc]');
var
  aField: string;
  aFieldIndex: Integer;
begin
  aField := Column.FieldName;
  aFieldIndex := SortFields.IndexOf(aField);

  if aFieldIndex = -1 then
  begin
    SortFields.Add(aField);
    SortFields.Ascending[SortFields.Count - 1] := True;
    Column.Field.DisplayLabel := Column.Field.FieldName + OrderStr[True];
  end
  else
  begin
    SortFields.Ascending[aFieldIndex] := not SortFields.Ascending[aFieldIndex];

    Column.Field.DisplayLabel := Column.Field.FieldName +
       OrderStr[SortFields.Ascending[aFieldIndex]];
  end;
  DoSort;
end;

end.
