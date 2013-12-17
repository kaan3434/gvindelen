unit uFormParamEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrlsEh, DB, FIBDataSet, pFIBDataSet,
  DBGridEh, DBLookupEh, FIBDatabase, pFIBDatabase;

type
  TfrmParamEdit = class(TForm)
    lblParamName: TLabel;
    lblParamValue: TLabel;
    mmoParamValue: TMemo;
    cbParamName: TDBComboBoxEh;
    cbParamKind: TDBComboBoxEh;
    lblParamKind: TLabel;
    btnOk: TButton;
    btnCancel: TButton;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ObjectId: Integer;
    trnWrite: TpFIBTransaction;
    DataSet: TDataSet;
  end;

var
  frmParamEdit: TfrmParamEdit;

implementation

uses
  udmOtto;

{$R *.dfm}

procedure TfrmParamEdit.FormActivate(Sender: TObject);
begin
  if cbParamKind.KeyItems.Count = 0 then
  begin
    dmOtto.FillComboStrings(cbParamKind.KeyItems, cbParamKind.Items,
      'select pk.param_kind, pk.param_kind||'' - ''||pk.paramkind_name from paramkinds pk',
      trnWrite);
  end;
  dmOtto.FillComboStrings(cbParamName.KeyItems, cbParamName.Items, Format(
    'select a.attr_sign, a.attr_sign '+
    'from attrs a '+
    '  inner join ActionCodes ac on (ac.object_sign = a.object_sign) '+
    'where ac.action_code = %u', [ObjectId]),
    trnWrite);
  cbParamName.KeyItems.Clear;
end;

end.
