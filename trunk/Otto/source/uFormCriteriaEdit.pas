unit uFormCriteriaEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrlsEh, FIBDatabase, pFIBDatabase, DB;

type
  TFormCriteriaEdit = class(TForm)
    lblParamName: TLabel;
    cbParamName: TDBComboBoxEh;
    mmoParamValue: TMemo;
    lblParamValue: TLabel;
    lblParamKind: TLabel;
    btnOk: TButton;
    btnCancel: TButton;
    cbParamKind: TDBComboBoxEh;
    lblAction: TLabel;
    cbParamAction: TDBComboBoxEh;
    edParamValue2: TDBEditEh;
    lblParamValue2: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    ObjectId: Variant;
    trnWrite: TpFIBTransaction;
    DataSet: TDataSet;
  end;

var
  FormCriteriaEdit: TFormCriteriaEdit;

implementation

uses
  udmOtto, GvVariant;

{$R *.dfm}

procedure TFormCriteriaEdit.FormActivate(Sender: TObject);
begin
  if cbParamKind.KeyItems.Count = 0 then
  begin
    dmOtto.FillComboStrings(cbParamKind.KeyItems, cbParamKind.Items,
      'select pk.datatype_sign, pk.datatype_sign||'' - ''||pk.datatype_name from paramdatatypes pk',
      trnWrite);
  end;
  if cbParamAction.KeyItems.Count = 0 then
  begin
    dmOtto.FillComboStrings(cbParamKind.KeyItems, cbParamKind.Items,
      'select distinct pk.param_action, pk.param_action from paramactions pk order by 1',
      trnWrite);
  end;

  dmOtto.FillComboStrings(cbParamName.KeyItems, cbParamName.Items, Format(
    'select a.attr_sign, a.attr_sign ' +
    'from attrs a ' +
    '  inner join ActionCodes ac on (ac.object_sign = a.object_sign) ' +
    'where ac.action_code = %u', [ObjectId]),
    trnWrite);
  cbParamName.KeyItems.Clear;
end;

procedure TFormCriteriaEdit.btnOkClick(Sender: TObject);
begin
  if DataSet['OBJECT_ID'] = null then
    DataSet['OBJECT_ID'] := ObjectId;
  DataSet['PARAM_NAME'] := cbParamName.Text;
  DataSet['PARAM_VALUE1'] := mmoParamValue.Lines.Text;
  DataSet['PARAM_VALUE2'] := NullIf(edParamValue2.Text, '');
  DataSet['PARAM_KIND'] := cbParamKind.KeyItems[cbParamKind.ItemIndex];
  DataSet['PARAM_ACTION'] := cbParamAction.KeyItems[cbParamAction.ItemIndex];
end;

end.

