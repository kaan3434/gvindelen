unit local_search;

interface

uses
  common,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, DBGrids, Buttons, Db, ExtCtrls, FIBDataSet, pFIBDataSet;

type
  TfrmLocalSearch = class(TForm)
    btnClose: TBitBtn;
    dbgCustomer: TDBGrid;
    edtSearch: TEdit;
    Label1: TLabel;
    Timer1: TTimer;
    Label2: TLabel;
    dtLocate: TpFIBDataSet;
    dtLocateID: TFIBIntegerField;
    dtLocateNAME: TFIBStringField;
    dtLocateADDRESS_1: TFIBStringField;
    dtLocateADDRESS_2: TFIBStringField;
    dtLocateCITY: TFIBStringField;
    dtLocateSTATE: TFIBStringField;
    dtLocateZIP: TFIBStringField;
    dtLocateCOUNTRY: TFIBStringField;
    dtLocatePHONE: TFIBStringField;
    dtLocateFAX: TFIBStringField;
    dtLocateTAX_RATE: TFIBFloatField;
    dtLocateCONTACT: TFIBStringField;
    dtLocateLAST_INVOICE_DATE: TDateTimeField;
    dsLocate: TDataSource;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtSearchChange(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgCustomerKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FSearchText: string;
    FTimeSearchText: string;
    procedure LocateRecord(const FindStr: string);
    procedure CancelLocate;
  public
    { Public declarations }
  end;

var
  frmLocalSearch: TfrmLocalSearch;
  SearchTickCount: Integer = 0;
  
implementation

uses dm_main;

{$R *.DFM}

procedure TfrmLocalSearch.FormCreate(Sender: TObject);
begin
  FSearchText := '';
  FTimeSearchText := '';
end;

procedure TfrmLocalSearch.FormShow(Sender: TObject);
begin
  dtLocate.Open;
end;

procedure TfrmLocalSearch.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  dtLocate.Close;
end;

procedure TfrmLocalSearch.LocateRecord(const FindStr: string);
var
  SeekBack, SeekNext : Boolean;
  CurruntValue: string;
begin
  SeekBack := False;
  SeekNext := False;

  if FindStr = '' then
  begin
    FSearchText := '';
    Exit;
  end;

  with dtLocate do
  begin
    if IsEmpty then Exit;

    if FSearchText = '' then
    begin
      SeekBack := not Bof;
      SeekNext := Bof;
      FSearchText := FindStr;
    end
    else
    begin
      CurruntValue := AnsiUpperCase(FieldByName('NAME').AsString);
      SeekBack := CurruntValue > AnsiUpperCase(FindStr);
      SeekNext := CurruntValue < AnsiUpperCase(FindStr);
      FSearchText := FindStr;
    end;

    if SeekBack then
      Locate('NAME', FSearchText, [loCaseInsensitive, loPartialKey]);

    if SeekNext then
      LocateNext('NAME', FSearchText, [loCaseInsensitive, loPartialKey]);
  end;
end;

procedure TfrmLocalSearch.CancelLocate;
begin
  edtSearch.Text := '';
  FTimeSearchText := '';
  with dbgCustomer do if CanFocus then SetFocus;
end;

procedure TfrmLocalSearch.edtSearchChange(Sender: TObject);
begin
  Timer1.Enabled := False;
  Timer1.Enabled := True;
  if edtSearch.Focused then FTimeSearchText := '';
end;

procedure TfrmLocalSearch.Timer1Timer(Sender: TObject);
begin
  try
    LocateRecord(edtSearch.Text);
  finally
    Timer1.Enabled := False;
  end;
end;

procedure TfrmLocalSearch.edtSearchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_UP, VK_PRIOR: begin
                       dtLocate.Prior;
                       with dbgCustomer do if CanFocus then SetFocus;
                     end;
    VK_DOWN, VK_NEXT: begin
                        dtLocate.Next;
                        with dbgCustomer do if CanFocus then SetFocus;
                      end;
  end;
end;

procedure TfrmLocalSearch.dbgCustomerKeyPress(Sender: TObject;
  var Key: Char);
begin
  case Key of
    #8: begin
          if ActiveControl = dbgCustomer then
            CancelLocate
          else
          begin
            if (GetTickCount - SearchTickCount > SEARCH_DELAY) then
              FTimeSearchText := ''
            else
            begin
              FTimeSearchText := Copy(FTimeSearchText, 1, Length(FTimeSearchText) - 1);
              SearchTickCount := GetTickCount;
              if Length(FTimeSearchText) > 0 then edtSearch.Text := FTimeSearchText;
            end;
          end;
        end;
    #13: ;
    #27: ;
    #32..#255: begin
                 if (GetTickCount - SearchTickCount > SEARCH_DELAY) then FTimeSearchText := '';
                 FTimeSearchText := FTimeSearchText + Key;
                 SearchTickCount := GetTickCount;
                 if Length(FTimeSearchText) > 0 then edtSearch.Text := FTimeSearchText;
               end;
  end;
end;

end.
