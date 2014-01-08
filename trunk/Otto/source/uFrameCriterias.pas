unit uFrameCriterias;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, GridsEh,
  DBAxisGridsEh, DBGridEh, TB2Dock, TB2Toolbar, TBX, DB, FIBDataSet,
  pFIBDataSet, TB2Item, ActnList, GvClipboard;

type
  TFrameCriterias = class(TFrame)
    dckTop: TTBXDock;
    tb1: TTBXToolbar;
    grdCriterias: TDBGridEh;
    dsCriterias: TDataSource;
    actCriterias: TActionList;
    actNew: TAction;
    actEdit: TAction;
    actDelete: TAction;
    actCopy: TAction;
    actPaste: TAction;
    actClear: TAction;
    btnNew: TTBXItem;
    btnEdit: TTBXItem;
    btnDelete: TTBXItem;
    tbsep1: TTBXSeparatorItem;
    btnCopy: TTBXItem;
    btnPaste: TTBXItem;
    btnClear: TTBXItem;
    procedure actNewExecute(Sender: TObject);
    procedure actEditUpdate(Sender: TObject);
    procedure actEditExecute(Sender: TObject);
    procedure actDeleteUpdate(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actClearExecute(Sender: TObject);
    procedure actClearUpdate(Sender: TObject);
    procedure actCopyUpdate(Sender: TObject);
    procedure actCopyExecute(Sender: TObject);
    procedure actPasteExecute(Sender: TObject);
    procedure actPasteUpdate(Sender: TObject);
    procedure actNewUpdate(Sender: TObject);
  private
    FClipboard: TGvDataSetClipboard;
  public
    ObjectId: Variant;
    function GetClipboard: TGvDataSetClipboard;
    property Clipboard: TGvDataSetClipboard read GetClipboard;
  end;

implementation

uses
  uFormCriteriaEdit, GvVariant;

{$R *.dfm}

const
  cClipboardName = 'Criterias';

procedure TFrameCriterias.actNewExecute(Sender: TObject);
begin
  FormCriteriaEdit.DataSet := dsCriterias.DataSet;
  dsCriterias.DataSet.Append;
  FormCriteriaEdit.ObjectId := ObjectId;
  if FormCriteriaEdit.ShowModal = mrOk then
    dsCriterias.DataSet.Post
  else
    dsCriterias.DataSet.Cancel;
end;

procedure TFrameCriterias.actEditUpdate(Sender: TObject);
begin
  actEdit.Enabled := not dsCriterias.DataSet.Eof;
end;

procedure TFrameCriterias.actEditExecute(Sender: TObject);
begin
  FormCriteriaEdit.DataSet := dsCriterias.DataSet;
  dsCriterias.DataSet.Edit;
  FormCriteriaEdit.ObjectId := ObjectId;
  if FormCriteriaEdit.ShowModal = mrOk then
    dsCriterias.DataSet.Post
  else
    dsCriterias.DataSet.Cancel;
end;

procedure TFrameCriterias.actDeleteUpdate(Sender: TObject);
begin
  actDelete.Enabled := not dsCriterias.DataSet.Eof;
end;

procedure TFrameCriterias.actDeleteExecute(Sender: TObject);
begin
  if MessageDlg('Удалить критерий?', mtConfirmation, mbOKCancel, 0) = mrOk then
    dsCriterias.DataSet.Delete;
end;

procedure TFrameCriterias.actClearExecute(Sender: TObject);
begin
  Clipboard.Clear;
end;

procedure TFrameCriterias.actClearUpdate(Sender: TObject);
begin
  actClear.Enabled := Clipboard.Size > 0;
end;

procedure TFrameCriterias.actCopyUpdate(Sender: TObject);
begin
  actCopy.Enabled := not dsCriterias.DataSet.Eof;
end;

procedure TFrameCriterias.actCopyExecute(Sender: TObject);
begin
  Clipboard.Copy(dsCriterias.DataSet, 'PARAM_NAME,PARAM_VALUE1,PARAM_VALUE2,PARAM_KIND,PARAM_ACTION');
end;

procedure TFrameCriterias.actPasteExecute(Sender: TObject);
begin
  Clipboard.Paste(dsCriterias.DataSet);
  while Clipboard.Position < Clipboard.Size do
    Clipboard.PasteNext(dsCriterias.DataSet);
end;

procedure TFrameCriterias.actPasteUpdate(Sender: TObject);
begin
  actPaste.Enabled := Clipboard.Size > 0;
end;

function TFrameCriterias.GetClipboard: TGvDataSetClipboard;
var
  Clip: TGvClipboardItem;
begin
  if FClipboard = nil then
  begin
    Clip := GvClipboards.GetClipboard(cClipboardName);
    if Clip <> nil then
      if Clip.ClassName = 'TGvDataSetClipboard' then
        FClipboard := TGvDataSetClipboard(Clip);
  end;
  if FClipboard = nil then
  begin
    FClipboard := TGvDataSetClipboard.Create(cClipboardName);
  end;
  Result := FClipboard;
end;

procedure TFrameCriterias.actNewUpdate(Sender: TObject);
begin
  actNew.Enabled := IsNotNull(ObjectId);
end;

end.

