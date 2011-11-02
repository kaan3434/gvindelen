unit uSetByr2Eur;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrlsEh, FIBDatabase, pFIBDatabase;

type
  TFormSetByr2Eur = class(TForm)
    edtByr2Eur: TDBNumberEditEh;
    btnOk: TButton;
    btnCancel: TButton;
    lbl1: TLabel;
    trnWrite: TpFIBTransaction;
    procedure FormCreate(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSetByr2Eur: TFormSetByr2Eur;

implementation

uses
  udmOtto;

{$R *.dfm}

procedure TFormSetByr2Eur.FormCreate(Sender: TObject);
begin
  lbl1.Caption:= Format('Укажите курс на %s', [FormatDateTime('DD.MM.YYYY', Date)]);
  trnWrite.StartTransaction;
  edtByr2Eur.Value:= dmOtto.SettingGet(trnWrite, 'BYR2EUR');
end;

procedure TFormSetByr2Eur.btnOkClick(Sender: TObject);
var
  SettingId: Integer;
begin
  SettingId:= trnWrite.DefaultDatabase.QueryValue(
    'select o_setting_id from setting_set(:setting_sign, :value)',
    0, ['BYR2EUR', edtByr2Eur.Text], trnWrite);
  trnWrite.Commit;
end;

procedure TFormSetByr2Eur.btnCancelClick(Sender: TObject);
begin
  trnWrite.Rollback;
end;

end.
