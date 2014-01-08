unit uFrameParams;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, TB2Item, TBX,
  ActnList, TB2Dock, TB2Toolbar, GridsEh, DBAxisGridsEh, DBGridEh, DB,
  FIBDataSet, pFIBDataSet, GvClipboard, ImgList, PngImageList;

type
  TFrameParams = class(TFrame)
    grdParams: TDBGridEh;
    dckParams: TTBXDock;
    tbParams: TTBXToolbar;
    btnNew: TTBXItem;
    btnCopy: TTBXItem;
    btnPaste: TTBXItem;
    btnDelete: TTBXItem;
    actParams: TActionList;
    actNew: TAction;
    actDelete: TAction;
    actEdit: TAction;
    actCopy: TAction;
    actPaste: TAction;
    actClear: TAction;
    btnEdit: TTBXItem;
    btnClear: TTBXItem;
    tbsepseparator: TTBXSeparatorItem;
    dsParams: TDataSource;
    imgListParams: TPngImageList;
    procedure actNewExecute(Sender: TObject);
    procedure actEditExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actEditUpdate(Sender: TObject);
    procedure actDeleteUpdate(Sender: TObject);
    procedure actClearExecute(Sender: TObject);
    procedure actClearUpdate(Sender: TObject);
    procedure actCopyExecute(Sender: TObject);
    procedure actCopyUpdate(Sender: TObject);
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
  uFormParamEdit, GvVariant;

{$R *.dfm}

const
  cClipboardName = 'Params';

procedure TFrameParams.actNewExecute(Sender: TObject);
begin
  FormParamEdit.DataSet := dsParams.DataSet;
  dsParams.DataSet.Append;
  FormParamEdit.ObjectId := ObjectId;
  if FormParamEdit.ShowModal = mrOk then
    dsParams.DataSet.Post
  else
    dsParams.DataSet.Cancel;
end;

procedure TFrameParams.actEditExecute(Sender: TObject);
begin
  FormParamEdit.DataSet := dsParams.DataSet;
  dsParams.DataSet.Edit;
  FormParamEdit.ObjectId := ObjectId;
  if FormParamEdit.ShowModal = mrOk then
    dsParams.DataSet.Post
  else
    dsParams.DataSet.Cancel;
end;

procedure TFrameParams.actDeleteExecute(Sender: TObject);
begin
  if MessageDlg('Удалить параметр?', mtConfirmation, mbOKCancel, 0) = mrOk then
    dsParams.DataSet.Delete;
end;

procedure TFrameParams.actEditUpdate(Sender: TObject);
begin
  actEdit.Enabled := not dsParams.DataSet.Eof;
end;

procedure TFrameParams.actDeleteUpdate(Sender: TObject);
begin
  actDelete.Enabled := not dsParams.DataSet.Eof;
end;

procedure TFrameParams.actClearExecute(Sender: TObject);
begin
  Clipboard.Clear;
end;

procedure TFrameParams.actClearUpdate(Sender: TObject);
begin
  actClear.Enabled := Clipboard.Size > 0;
end;

function TFrameParams.GetClipboard: TGvDataSetClipboard;
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

procedure TFrameParams.actCopyExecute(Sender: TObject);
begin
  Clipboard.Copy(dsParams.DataSet, 'PARAM_NAME,PARAM_VALUE,PARAM_KIND');
end;

procedure TFrameParams.actCopyUpdate(Sender: TObject);
begin
  actCopy.Enabled := not dsParams.DataSet.Eof;
end;

procedure TFrameParams.actPasteExecute(Sender: TObject);
begin
  Clipboard.Paste(dsParams.DataSet);
  while Clipboard.Position < Clipboard.Size do
    Clipboard.PasteNext(dsParams.DataSet);
end;

procedure TFrameParams.actPasteUpdate(Sender: TObject);
begin
  actPaste.Enabled := Clipboard.Size > 0;
end;

procedure TFrameParams.actNewUpdate(Sender: TObject);
begin
  actNew.Enabled := IsNotNull(ObjectId);
end;

end.

