unit cachexxx;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  jpeg, ExtCtrls, StdCtrls, ComCtrls, Grids, DBGrids, Buttons, Db,
  FIBDataSet, pFIBDataSet, Spin;

type
  TfrmCachexxx = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet4: TTabSheet;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    btnOpen: TButton;
    btnInsert: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    Label1: TLabel;
    Label2: TLabel;
    btnRefresh: TButton;
    btnCloseOpen: TButton;
    Label3: TLabel;
    DBGrid3: TDBGrid;
    Label4: TLabel;
    DBGrid4: TDBGrid;
    btnDialog: TButton;
    Label5: TLabel;
    DBGrid5: TDBGrid;
    Label6: TLabel;
    DBGrid6: TDBGrid;
    btnClone: TButton;
    btnClose: TBitBtn;
    dtSource1: TpFIBDataSet;
    dsSource1: TDataSource;
    dtTarget1: TpFIBDataSet;
    dsTarget1: TDataSource;
    dtSource2: TpFIBDataSet;
    dtTarget2: TpFIBDataSet;
    dsSource2: TDataSource;
    dsTarget2: TDataSource;
    dtSource3: TpFIBDataSet;
    dtTarget3: TpFIBDataSet;
    dsSource3: TDataSource;
    dsTarget3: TDataSource;
    SpinEdit1: TSpinEdit;
    Label7: TLabel;
    TabSheet3: TTabSheet;
    Label8: TLabel;
    DBGrid7: TDBGrid;
    Label9: TLabel;
    DBGrid8: TDBGrid;
    Button1: TButton;
    dtSource4: TpFIBDataSet;
    dsSource4: TDataSource;
    dtTarget4: TpFIBDataSet;
    dsTarget4: TDataSource;
    dtTarget4CONTINENT: TFIBStringField;
    dtTarget4SUM_: TFIBIntegerField;
    dtTarget4AVG_: TFIBIntegerField;
    dtSource4ID: TFIBIntegerField;
    dtSource4CAPITAL: TFIBStringField;
    dtSource4CONTINENT: TFIBStringField;
    dtSource4AREA: TFIBFloatField;
    dtSource4POPULATION: TFIBFloatField;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    procedure btnOpenClick(Sender: TObject);
    procedure btnInsertClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnCloseOpenClick(Sender: TObject);
    procedure btnDialogClick(Sender: TObject);
    procedure btnCloneClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
    function LocalFunction(AName: string; AVG: Boolean): Double;
  public
    { Public declarations }
  end;

var
  frmCachexxx: TfrmCachexxx;

implementation

uses dm_main, cache_dialog;

{$R *.DFM}

function TfrmCachexxx.LocalFunction(AName: string; AVG: Boolean): Double;
var
  i, j: Integer;
begin
  i := 0;
  j := 0;  
  Result := 0;

  with dtSource4 do
  begin
    try
      DisableControls;
      i := FieldByName('ID').AsInteger;
      First;

      while not Eof do
      begin
        if FieldByName('CONTINENT').AsString = AName then
        begin
          Result := Result + FieldByName('AREA').AsFloat;
          Inc(j);
        end;
        Next;
      end;

      if AVG then Result := Result / j;

    finally
      Locate('ID', i, []);
      EnableControls;
    end;
  end;
end;

procedure TfrmCachexxx.FormShow(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 0;

  dtSource1.Open;
  dtSource2.Open;
  dtSource3.Open;
  dtSource4.Open;

  dtTarget4.CacheOpen;
  dtTarget4.CacheInsert([0, 1, 2],['South America', 0, 0]);
  dtTarget4.CacheInsert([0, 1, 2],['North America', 0, 0]);
  dtTarget4.DoSortEx([0], [True]);
  dtTarget4.First;
end;

procedure TfrmCachexxx.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  dtSource1.Close;
  dtSource2.Close;
  dtSource3.Close;
  dtSource4.Open;
  dtTarget1.Close;
  dtTarget2.Close;
  dtTarget3.Close;
  dtTarget4.Close;  
end;

procedure TfrmCachexxx.btnOpenClick(Sender: TObject);
begin
  if not dtTarget1.Active then dtTarget1.CacheOpen;

  btnInsert.Enabled := dtTarget1.Active;
  btnEdit.Enabled   := dtTarget1.Active;
  btnRefresh.Enabled := dtTarget1.Active;
  btnDelete.Enabled := dtTarget1.Active;
  btnCloseOpen.Enabled := dtTarget1.Active;
end;

procedure TfrmCachexxx.btnInsertClick(Sender: TObject);
begin
//  dtTarget1.CacheInsert(dtSource1.Fields[0].AsInteger);
  dtTarget1.CacheInsert(SpinEdit1.Value);
  //as example
  //dtTarget1.CacheInsert(5);
  dtTarget1.Refresh;
//  dtSource1.Next;
end;

procedure TfrmCachexxx.btnEditClick(Sender: TObject);
begin
  if not dtTarget1.IsEmpty then
  begin
    dtTarget1.Refresh;
    dtTarget1.CacheEdit([1], [dtTarget1.FieldByName('NAME').AsString + ' was Edited' ]);
  end;
end;

procedure TfrmCachexxx.btnDeleteClick(Sender: TObject);
begin
  if not dtTarget1.IsEmpty then dtTarget1.CacheDelete;
end;

procedure TfrmCachexxx.btnRefreshClick(Sender: TObject);
begin
  dtTarget1.CacheRefresh(dtSource1, frkInsert, nil);
  dtSource1.Next;
end;

procedure TfrmCachexxx.btnCloseOpenClick(Sender: TObject);
begin
  dtTarget1.Close;
  dtTarget1.CacheOpen;
  dtSource1.First;
end;

procedure TfrmCachexxx.btnDialogClick(Sender: TObject);
begin
  try
    frmCacheDialog := TfrmCacheDialog.Create(Application);
    with frmCacheDialog do
    begin
      dtSource.Open;
      dtTarget.CacheOpen;
      if ShowModal = mrOK then
      begin
        dtTarget2.Close;
        dtTarget2.CacheOpen;

        try
          dtTarget.First;
          dtTarget.DisableControls;
          while not dtTarget.Eof do
          begin
            dtTarget2.CacheRefresh(dtTarget, frkInsert, nil);
            // as example CacheInsert()
//          dtTarget2.CacheInsert(dtTarget3.Fields[0].AsInteger);
//          dtTarget2.Refresh;
            dtTarget.Next;
          end;
        finally
          dtTarget.EnableControls;
          dtTarget.Close;
          dtSource.Close;
        end;
      end;
    end;
  finally
    frmCacheDialog.Free;
  end;
end;

procedure TfrmCachexxx.btnCloneClick(Sender: TObject);
begin
  try
    dtSource3.DisableControls;
    dtSource3.First;
    dtSource3.FetchAll;

    dtTarget3.OpenAsClone(dtSource3);

  finally
    dtSource3.EnableControls;
  end;
end;

procedure TfrmCachexxx.Button1Click(Sender: TObject);
begin
  dtTarget4.Locate('CONTINENT', 'South America', []);
  dtTarget4.CacheEdit([1], [LocalFunction('South America', False)]);
end;

procedure TfrmCachexxx.Button2Click(Sender: TObject);
begin
  dtTarget4.Locate('CONTINENT', 'South America', []);
  dtTarget4.CacheEdit([2], [LocalFunction('South America', True)]);
end;

procedure TfrmCachexxx.Button3Click(Sender: TObject);
begin
  dtTarget4.Locate('CONTINENT', 'North America', []);
  dtTarget4.CacheEdit([1], [LocalFunction('North America', False)]);
end;

procedure TfrmCachexxx.Button4Click(Sender: TObject);
begin
  dtTarget4.Locate('CONTINENT', 'North America', []);
  dtTarget4.CacheEdit([2], [LocalFunction('North America', True)]);
end;

procedure TfrmCachexxx.Button5Click(Sender: TObject);
begin
  dtTarget4.Close;
  dtTarget4.CacheOpen;
  dtTarget4.CacheInsert([0, 1, 2],['South America', 0, 0]);
  dtTarget4.CacheInsert([0, 1, 2],['North America', 0, 0]);
  dtTarget4.DoSortEx([0], [True]);
  dtTarget4.First;
end;

end.
