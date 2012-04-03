unit simple;

interface

uses
  common,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Grids, DBGrids, ExtCtrls, Db, FIBDataSet, pFIBDataSet;

type
  TfrmSimple = class(TForm)
    dbgCountry: TDBGrid;
    btnClose: TBitBtn;
    btnInsert: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnRefresh: TButton;
    btnFullRefresh: TButton;
    Label1: TLabel;
    dtCountry: TpFIBDataSet;
    dtCountryID: TFIBIntegerField;
    dtCountryNAME: TFIBStringField;
    dtCountryCAPITAL: TFIBStringField;
    dtCountryCONTINENT: TFIBStringField;
    dtCountryAREA: TFIBFloatField;
    dtCountryPOPULATION: TFIBFloatField;
    dsCountry: TDataSource;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnInsertClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnFullRefreshClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    function EditRecord(DataSet: TDataSet; EditFormClass: TFormClass): Integer;
  public
    { Public declarations }
  end;

var
  frmSimple: TfrmSimple;

implementation

uses dm_main, edit_country;

{$R *.DFM}

procedure TfrmSimple.FormShow(Sender: TObject);
begin
  dtCountry.Open;
end;

procedure TfrmSimple.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  dtCountry.Close;
end;

function TfrmSimple.EditRecord(DataSet: TDataSet; EditFormClass: TFormClass): Integer;
var
  TempForm: TForm;
begin
  TempForm := nil;

  with DataSet do
  begin
    if not (State in [dsInsert, dsEdit]) then Exit;
    try
      TempForm := EditFormClass.Create(Application);

      if State = dsInsert then TempForm.Caption := INSERT_RECORD;
      if State = dsEdit then TempForm.Caption := EDIT_RECORD;

      Result := TempForm.ShowModal;
      if Result = mrOk then Post else Cancel;

    finally
      TempForm.Free;
    end;
  end;
end;

procedure TfrmSimple.btnInsertClick(Sender: TObject);
begin
  dtCountry.Insert;
  EditRecord(dtCountry, TfrmEditCountry);
end;

procedure TfrmSimple.btnEditClick(Sender: TObject);
begin
  dtCountry.Edit;
  EditRecord(dtCountry, TfrmEditCountry);
end;

procedure TfrmSimple.btnDeleteClick(Sender: TObject);
begin
  if MsgConfirmation('Delete current record?') then dtCountry.Delete;
end;

procedure TfrmSimple.btnRefreshClick(Sender: TObject);
begin
  dtCountry.Refresh; {Refresh ONE record}
end;

procedure TfrmSimple.btnFullRefreshClick(Sender: TObject);
begin
  dtCountry.FullRefresh; {CloseOpen() + Locate()}
end;

end.
