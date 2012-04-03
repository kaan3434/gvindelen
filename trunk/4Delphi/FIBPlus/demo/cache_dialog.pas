unit cache_dialog;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, StdCtrls, ExtCtrls, Db, FIBDataSet, pFIBDataSet;

type
  TfrmCacheDialog = class(TForm)
    Bevel1: TBevel;
    btnOK: TButton;
    btnCancel: TButton;
    DBGrid5: TDBGrid;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    DBGrid6: TDBGrid;
    dtSource: TpFIBDataSet;
    dsSource: TDataSource;
    dtTarget: TpFIBDataSet;
    dsTarget: TDataSource;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
    procedure MoveOneRecord(LeftToRigth: Boolean);
    procedure MoveAllRecords(LeftToRigth: Boolean);
  public
    { Public declarations }
  end;

var
  frmCacheDialog: TfrmCacheDialog;

implementation

uses dm_main;

{$R *.DFM}

procedure TfrmCacheDialog.MoveOneRecord(LeftToRigth: Boolean);
begin
  with dmMain do
  begin
    if LeftToRigth then
    begin
      if (dtSource.Active) and (not dtSource.IsEmpty) then
      begin
        // as example CacheRefresh CacheRefreshByArrMap()
        dtTarget.CacheRefreshByArrMap(dtSource, frkInsert, ['ID'], ['ID']);
        dtSource.CacheDelete;
      end;
    end
    else
    begin
      if (dtTarget.Active) and (not dtTarget.IsEmpty) then
      begin
//        dtSource.CacheRefreshByArrMap(dtTarget, frkInsert, ['ID'], ['ID']);
        //as example CacheRefresh()
        dtSource.CacheRefresh(dtTarget, frkInsert, nil);
        dtTarget.CacheDelete;
      end;
    end;
  end;
end;

procedure TfrmCacheDialog.MoveAllRecords(LeftToRigth: Boolean);
var
  DataSet: TpFIBDataSet;
begin
  with dmMain do
  begin
    if LeftToRigth then DataSet := dtSource else DataSet := dtTarget;

    with DataSet do
    begin
      try
        DisableControls;
        First;
        while not Eof do MoveOneRecord(LeftToRigth);
      finally
        EnableControls;
      end;
    end;
  end;
end;


procedure TfrmCacheDialog.Button1Click(Sender: TObject);
begin
  MoveOneRecord(True);
end;

procedure TfrmCacheDialog.Button2Click(Sender: TObject);
begin
  MoveOneRecord(False);
end;

procedure TfrmCacheDialog.Button3Click(Sender: TObject);
begin
  MoveAllRecords(True);
end;

procedure TfrmCacheDialog.Button4Click(Sender: TObject);
begin
  MoveAllRecords(False);
end;

end.
