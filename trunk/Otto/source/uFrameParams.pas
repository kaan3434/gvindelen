unit uFrameParams;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, TB2Item, TBX,
  ActnList, TB2Dock, TB2Toolbar, GridsEh, DBAxisGridsEh, DBGridEh, DB,
  FIBDataSet, pFIBDataSet;

type
  TFrame2 = class(TFrame)
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
    procedure actNewExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  uFormParamEdit;

{$R *.dfm}

procedure TFrame2.actNewExecute(Sender: TObject);
begin
  frmParamEdit.DataSet:= dsParams.DataSet;
  dsParams.DataSet.Append;
  frmParamEdit.ObjectId:= dsParams.DataSet.DataSource.DataSet.Tag;
  if frmParamEdit.ShowModal = mrOk then
    dsParams.DataSet.Post
  else
    dsParams.DataSet.Cancel;
end;

end.
