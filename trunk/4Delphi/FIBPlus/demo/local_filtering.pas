unit local_filtering;

interface

uses
  common,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Grids, DBGrids, ExtCtrls, Db, FIBDataSet, pFIBDataSet;

type
  TfrmLocalFiltering = class(TForm)
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
    edtFilter: TEdit;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure dtCountryFilterRecord(DataSet: TDataSet;
      var Accept: Boolean);
    procedure edtFilterChange(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
  private
    { Private declarations }
    function FilterRecord(const FilterStr: string; DataSet: TDataSet): Boolean;
    procedure StartFilter(DataSet: TDataSet);
    procedure CancelFilter(DataSet: TDataSet);
  public
    { Public declarations }
  end;

var
  frmLocalFiltering: TfrmLocalFiltering;

implementation

uses dm_main;

{$R *.DFM}

procedure TfrmLocalFiltering.FormShow(Sender: TObject);
begin
  dtCountry.Open;
end;

procedure TfrmLocalFiltering.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  dtCountry.Close;
end;

function TfrmLocalFiltering.FilterRecord(const FilterStr: string; DataSet: TDataSet): Boolean;
var
  FieldValue: string;

  function PosCI(const Substr, Str: string): Integer;
  begin
    Result := Pos(AnsiUpperCase(Substr), AnsiUpperCase(Str));
  end;
  
begin
  if RadioButton1.Checked then FieldValue := DataSet.FieldByName('NAME').AsString;
  if RadioButton2.Checked then FieldValue := DataSet.FieldByName('CAPITAL').AsString;
  Result := PosCI(FilterStr, FieldValue) > 0;
end;

procedure TfrmLocalFiltering.StartFilter(DataSet: TDataSet);
begin
  DataSet.Filtered := True;
end;

procedure TfrmLocalFiltering.CancelFilter(DataSet: TDataSet);
begin
  DataSet.Filtered := False;
end;

procedure TfrmLocalFiltering.dtCountryFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  Accept := FilterRecord(edtFilter.Text, DataSet);
end;

procedure TfrmLocalFiltering.edtFilterChange(Sender: TObject);
begin
  if Length((Sender as TEdit).Text) <> 0 then
    StartFilter(dtCountry)
  else
    CancelFilter(dtCountry);
end;

procedure TfrmLocalFiltering.RadioButton1Click(Sender: TObject);
begin
  if Length(edtFilter.Text) <> 0 then
  begin
    CancelFilter(dtCountry);
    StartFilter(dtCountry);
  end;
end;

end.
