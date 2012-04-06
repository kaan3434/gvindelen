//////////////////////////////////////////////////
//  InterBase Data Access Components
//  Copyright © 1998-2011 Devart. All right reserved.
//  IBCTransaction Editor
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I IbDac.inc}

unit IBCTransactionEditor;
{$ENDIF}

interface

uses
  SysUtils, Classes,
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF}
  Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, Buttons,
{$IFDEF FPC}
  LResources,
{$ENDIF}
  IBC, CREditor, DaDesignUtils;

type
  TIBCTransactionEditorForm = class(TCREditorForm)
    TopPanel: TPanel;
    edIsolationLevel: TComboBox;
    lbTransactionKind: TLabel;
    pnlClient: TPanel;
    gbParams: TGroupBox;
    meParams: TMemo;
    procedure meParamsChange(Sender: TObject);
    procedure edIsolationLevelChange(Sender: TObject);
  protected
    FTransaction: TIBCTransaction;
    FInInit: boolean;
    function GetComponent: TComponent; override;
    procedure SetComponent(Value: TComponent); override;
    procedure DoInit; override;
    procedure DoSave; override;
    procedure DoActivate; override;
  public
    property Transaction: TIBCTransaction read FTransaction write FTransaction;
  end;

var
  IBCTransactionEditorForm: TIBCTransactionEditorForm;

implementation

{$IFNDEF FPC}
{$R IBCTransactionEditor.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF}

uses
  IBCClasses, TypInfo;

type
  TParamConst = 0..7;
  TParamConsts = set of TParamConst;

const

  ParamConstNames: array[TParamConst] of string = (
    'concurrency',
    'nowait',
    'read_committed',
    'rec_version',
    'read',
    'write',
    'consistency',
    'read'
  );

  ILConsts: array[iblSnapshot..iblReadOnlyTableStability] of TParamConsts = (
    [0, 1],
    [1, 2, 3],
    [1, 2, 3, 4],
    [5, 6],
    [6, 7]
  );

{ TIBCTransactionEditorForm }

function TIBCTransactionEditorForm.GetComponent: TComponent;
begin
  Result := FTransaction;
end;

procedure TIBCTransactionEditorForm.SetComponent(Value: TComponent);
begin
  FTransaction := Value as TIBCTransaction;
end;

procedure TIBCTransactionEditorForm.DoInit;
var
  i: integer;
begin
  FInInit := True;

  inherited;

  for i := Integer(iblSnapshot) to Integer(iblCustom) do
    edIsolationLevel.Items.Add(GetEnumName(TypeInfo(TIBCIsolationLevel), i));

  if FTransaction.Owner <> nil then
    if FTransaction.Owner is TIBCConnection then
      Caption := FTransaction.Owner.Name + '.DefaultTransaction'
    else
      Caption := FTransaction.Owner.Name + '.' + FTransaction.Name
  else
    Caption := FTransaction.Name;

  if FTransaction.IsolationLevel = iblCustom then
    meParams.Text := FTransaction.Params.Text;
  edIsolationLevel.ItemIndex := Integer(FTransaction.IsolationLevel);
  edIsolationLevelChange(nil);

  FInInit  := False;
end;

procedure TIBCTransactionEditorForm.DoSave;
var
  ParamsChanged,
  IsolationLevelChanged: boolean;
begin
  inherited;
  ParamsChanged := (FTransaction.Params.Text <> meParams.Text) and (TIBCIsolationLevel(edIsolationLevel.ItemIndex) = iblCustom);
  IsolationLevelChanged := Integer(FTransaction.IsolationLevel) <> edIsolationLevel.ItemIndex;
  if ParamsChanged or IsolationLevelChanged then begin
    FTransaction.Active := False;
    if IsolationLevelChanged then begin
      FTransaction.IsolationLevel := TIBCIsolationLevel(edIsolationLevel.ItemIndex);
      if FTransaction.IsolationLevel <> iblCustom then
        FTransaction.Params.Clear;
    end;
    if ParamsChanged then
      FTransaction.Params.Text := meParams.Text;
  end;
end;

procedure TIBCTransactionEditorForm.edIsolationLevelChange(
  Sender: TObject);
var
  i: integer;
  NeedConsts: TParamConsts;
begin
  Modified := Modified or not FInInit;
  meParams.ReadOnly := edIsolationLevel.ItemIndex <> edIsolationLevel.Items.Count - 1;
  if not meParams.ReadOnly then
    meParams.Color := clWindow
  else begin
    meParams.Color := clBtnFace;

    meParams.Lines.BeginUpdate;
    NeedConsts := ILConsts[TIBCIsolationLevel(edIsolationLevel.ItemIndex)];
    meParams.Clear;
    for i := 0 to High(TParamConst) do
      if i in NeedConsts then
        meParams.Lines.Add(ParamConstNames[i]);
    meParams.Lines.EndUpdate;
  end;
end;

procedure TIBCTransactionEditorForm.DoActivate;
begin
  inherited;

  if InitialProperty = 'Params' then begin
    if meParams.Enabled then
      meParams.SetFocus
  end
  else
  if InitialProperty <> '' then
    Assert(False, InitialProperty);
end;

procedure TIBCTransactionEditorForm.meParamsChange(Sender: TObject);
begin
  Modified := Modified or not FInInit and meParams.Enabled;
end;

end.
