unit main_dll;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, DBCtrls, Grids, DBGrids, Db;

type
  TfrmMain = class(TForm)
    btnClose: TBitBtn;
    dbgCountry: TDBGrid;
    dbnCountry: TDBNavigator;
    procedure dbnCountryClick(Sender: TObject; Button: TNavigateBtn);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);
    procedure dbgCountryDblClick(Sender: TObject);
  private
    { Private declarations }
    function EditRecord(DataSet: TDataSet; EditFormClass: TFormClass): Integer;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses datamod_dll, edit_country;

{$R *.DFM}

function TfrmMain.EditRecord(DataSet: TDataSet; EditFormClass: TFormClass): Integer;
var
  TempForm: TForm;
begin
  TempForm := nil;

  with DataSet do
  begin
    if not (State in [dsInsert, dsEdit]) then Exit;
    try
      TempForm := EditFormClass.Create(Application);

      if State = dsInsert then TempForm.Caption := 'Insert new record';
      if State = dsEdit then TempForm.Caption := 'Edit current record';

      Result := TempForm.ShowModal;
      if Result = mrOk then Post else Cancel;

    finally
      TempForm.Free;
    end;
  end;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  dmMain.dtCountry.Open;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  dmMain.dtCountry.Close;
end;

procedure TfrmMain.dbnCountryClick(Sender: TObject; Button: TNavigateBtn);
begin
  EditRecord(dmMain.dtCountry, TfrmEditCountry);
end;

procedure TfrmMain.dbgCountryDblClick(Sender: TObject);
begin
  dbnCountry.BtnClick(nbEdit);
end;

procedure TfrmMain.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.
