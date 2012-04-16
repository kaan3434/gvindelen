unit uDlgPayment;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Mask, DBCtrlsEh, ActnList;

type
  TDlgManualPayment = class(TForm)
    btnOk: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    lblAmountEur: TLabel;
    edtAmountEur: TDBNumberEditEh;
    edtByr2Eur: TDBNumberEditEh;
    lblByr2Eur: TLabel;
    actDialog: TActionList;
    actOk: TAction;
    memAnnotate: TMemo;
    lblAnnotate: TLabel;
    procedure actOkUpdate(Sender: TObject);
    procedure actOkExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DlgManualPayment: TDlgManualPayment;

implementation

{$R *.dfm}

uses
  GvVariant;

procedure TDlgManualPayment.actOkUpdate(Sender: TObject);
begin
  actOk.Enabled:= IsNotNull(edtAmountEur.Value) and IsNotNull(edtByr2Eur.Value);
end;

procedure TDlgManualPayment.actOkExecute(Sender: TObject);
begin
  ModalResult:= mrOk;
end;

end.
