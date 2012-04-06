{$I DacDemo.inc}

unit Loader;

interface

uses
{$IFNDEF VER130}
  Variants,
{$ENDIF}
  Classes, SysUtils,
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF}
  Graphics, Controls, Forms, Dialogs, Buttons,
  Grids, DBGrids, StdCtrls, ExtCtrls, DBCtrls,
{$IFDEF CLR}
   System.ComponentModel,
{$ENDIF}
{$IFDEF FPC}
  LResources,
{$ENDIF}
  Db, DBAccess, Fetch,
  DALoader, IBCLoader, IBC, DemoFrame, IbDacDemoForm,
  {$IFNDEF FPC}MemDS{$ELSE}MemDataSet{$ENDIF};

type
  TLoaderFrame = class(TDemoFrame)
    DataSource: TDataSource;
    Query: TIBCQuery;
    IBCLoader: TIBCLoader;
    Panel2: TPanel;
    ToolBar: TPanel;
    btOpen: TSpeedButton;
    btClose: TSpeedButton;
    btLoad: TSpeedButton;
    btDeleteAll: TSpeedButton;
    DBNavigator: TDBNavigator;
    Panel1: TPanel;
    Label1: TLabel;
    edRows: TEdit;
    DBGrid: TDBGrid;
    Panel3: TPanel;
    rgEvent: TRadioGroup;
    procedure btOpenClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure btLoadClick(Sender: TObject);
    procedure btDeleteAllClick(Sender: TObject);
    procedure QueryAfterOpen(DataSet: TDataSet);
    procedure QueryBeforeClose(DataSet: TDataSet);
    procedure PutData(Sender: TDALoader);
    procedure rgEventClick(Sender: TObject);
    procedure QueryBeforeFetch(DataSet: TCustomDADataSet;
      var Cancel: Boolean);
    procedure QueryAfterFetch(DataSet: TCustomDADataSet);
    procedure IBCLoaderGetColumnData(Sender: TObject; Column: TDAColumn;
      Row: Integer; var Value: Variant; var IsEOF: Boolean);
  private
    { Private declarations }
  public
    PMInterval: integer;
    Count: integer;
    destructor Destroy; override;

    // Demo management
    procedure Initialize; override;
    procedure SetDebug(Value: boolean); override;
  end;

implementation

{$IFNDEF FPC}
{$IFDEF CLR}
{$R *.nfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}
{$ENDIF}

destructor TLoaderFrame.Destroy;
begin
  FreeAndNil(FetchForm);
  inherited;
end;

procedure TLoaderFrame.btOpenClick(Sender: TObject);
begin
  Query.Open;
end;

procedure TLoaderFrame.btCloseClick(Sender: TObject);
begin
  Query.Close;
end;

procedure TLoaderFrame.btLoadClick(Sender: TObject);
{$IFNDEF UNIX}
var
  Start, Finish, Freq: Integer;
{$ENDIF}
begin
{$IFNDEF UNIX}
  Start := GetTickCount;
{$ENDIF}
  FetchForm.Show;
  Count := StrToInt(edRows.Text);
  FetchForm.ProgressBar.Max := Count;
  FetchForm.CancelLoad := False;
  try
    IBCLoader.Load;  // loading rows
  finally
    FetchForm.Hide;
  {$IFNDEF UNIX}
    Finish := GetTickCount;
    Freq := 1000;
    IbDacForm.StatusBar.Panels[2].Text := 'Time: ' + FloatToStr(Round((Finish - Start) / Freq * 100) / 100) + ' sec.';
  {$ENDIF}
    if Query.Active then
      Query.Refresh;
  end;
end;

procedure TLoaderFrame.IBCLoaderGetColumnData(Sender: TObject;
  Column: TDAColumn; Row: Integer; var Value: Variant; var IsEOF: Boolean);
begin
  IsEOF := Row > Count;
  case Column.Index of
    0: Value := Row;
    1: Value := Random*100;
    2: Value := 'abc01234567890123456789';
    3: Value := Date;
  else
    Value := Null;
  end;

  FetchForm.ProgressBar.Position := Row;

  if PMInterval = 100 then begin   // 100 fields per time
    Application.ProcessMessages;
    if FetchForm.CancelLoad then begin
      MessageDlg('Loading was cancelled by user.' + #13#10
        + 'Sucessfully loaded '+ IntToStr(Row - 1) + ' rows.', mtInformation, [mbOK], 0);
      IsEof := True;
    end;
  end
    else
      inc(PMInterval);
end;

procedure TLoaderFrame.PutData(Sender: TDALoader);
var
  i: integer;
begin
  PMInterval := 0;

  for i := 1 to Count do begin
    Sender.PutColumnData(0, i, i);
    Sender.PutColumnData('DBL', i, Random*100);
    Sender.PutColumnData(2, i, 'abc01234567890123456789');
    Sender.PutColumnData(3, i, Date);

    FetchForm.ProgressBar.Position := i;
    if PMInterval = 100 then begin // 100 records per time
      PMInterval := 0;
      Application.ProcessMessages;
      if FetchForm.CancelLoad then begin
        MessageDlg('Loading was cancelled by user.' + #13#10
          + 'Sucessfully loaded '+ IntToStr(i) + ' rows.', mtInformation, [mbOK], 0);
        Abort;
      end;
    end
    else
      inc(PMInterval);
  end;
end;

procedure TLoaderFrame.btDeleteAllClick(Sender: TObject);
begin
  Query.Connection.ExecSQL('DELETE FROM IBDAC_Loaded', []);
  if Query.Active then
    Query.Refresh;
end;

procedure TLoaderFrame.QueryAfterOpen(DataSet: TDataSet);
begin
  IBDACForm.StatusBar.Panels[1].Text := 'Count: ' + IntToStr(DataSet.RecordCount);
end;

procedure TLoaderFrame.QueryBeforeClose(DataSet: TDataSet);
begin
  IBDACForm.StatusBar.Panels[1].Text := '';
end;

procedure TLoaderFrame.rgEventClick(Sender: TObject);
begin
  if rgEvent.ItemIndex = 0 then begin
    IBCLoader.OnGetColumnData := IBCLoaderGetColumnData;
    IBCLoader.OnPutData := nil;
  end
  else begin
    IBCLoader.OnGetColumnData := nil;
    IBCLoader.OnPutData := PutData;
  end
end;

procedure TLoaderFrame.QueryBeforeFetch(DataSet: TCustomDADataSet;
  var Cancel: Boolean);
begin
  if DataSet.FetchingAll then begin
    FetchForm.Show;
    Application.ProcessMessages;
    Cancel := not FetchForm.Visible;

    if Cancel then
      IBDACForm.StatusBar.Panels[1].Text := 'RecordCount: ' + IntToStr(DataSet.RecordCount);
  end;
end;

procedure TLoaderFrame.QueryAfterFetch(DataSet: TCustomDADataSet);
begin
  if not DataSet.FetchingAll then begin
    FetchForm.Close;
    Application.ProcessMessages;

    IBDACForm.StatusBar.Panels[1].Text := 'RecordCount: ' + IntToStr(DataSet.RecordCount);
  end;
end;

// Demo management
procedure TLoaderFrame.Initialize;
begin
  inherited;
  Query.Connection := Connection as TIBCConnection;
  IBCLoader.Connection := Connection as TIBCConnection;

  if FetchForm = nil then
    FetchForm := TFetchForm.Create(IBDACForm);
  rgEvent.ItemIndex := 1;
end;

procedure TLoaderFrame.SetDebug(Value: boolean);
begin
  Query.Debug := Value;
end;

{$IFDEF FPC}
initialization
  {$i Loader.lrs}
{$ENDIF}
end.
