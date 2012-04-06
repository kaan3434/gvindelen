{$I DacDemo.inc}

unit DB_Key;

interface

uses
  Classes, SysUtils,
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  Menus, ImgList, StdCtrls, ComCtrls, Buttons, ExtCtrls, Graphics,
  Controls, Forms, Dialogs, DBCtrls, Grids, DBGrids, IbDacVcl,
  DAScript, IBCScript, DemoFrame, DB, IBC, MemDS, DBAccess;

type
  TDB_KeyFrame = class(TDemoFrame)
    DBGrid: TDBGrid;
    DataSource: TDataSource;
    ToolBar: TPanel;
    btOpen: TSpeedButton;
    btClose: TSpeedButton;
    Panel1: TPanel;
    DBNavigator1: TDBNavigator;
    btRefreshRecord: TSpeedButton;
    IBCQuery: TIBCQuery;
    Label1: TLabel;
    Label2: TLabel;
    IBCQueryRDBDB_KEY: TIBCDbKeyField;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    IBCQueryTITLE: TStringField;
    IBCQueryVAL: TStringField;
    IBCQuerySTAMP_ADD: TDateTimeField;
    btAddRecord: TSpeedButton;
    procedure btOpenClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure btRefreshRecordClick(Sender: TObject);
    procedure IBCQueryAfterInsert(DataSet: TDataSet);
    procedure btAddRecordClick(Sender: TObject);
  private
    FCounter: integer;
  public
    procedure SetDebug(Value: boolean); override;
    procedure Initialize; override;
  end;

implementation

{$IFNDEF FPC}
{$IFDEF CLR}
{$R *.nfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}
{$ENDIF}

procedure TDB_KeyFrame.btOpenClick(Sender: TObject);
begin
  IBCQuery.Open;
  FCounter := IBCQuery.RecordCount;
  if FCounter = 0 then
    btAddRecordClick(nil);
end;

procedure TDB_KeyFrame.btCloseClick(Sender: TObject);
begin
  IBCQuery.Close;
end;

procedure TDB_KeyFrame.btRefreshRecordClick(Sender: TObject);
begin
  IBCQuery.RefreshRecord;
end;

procedure TDB_KeyFrame.IBCQueryAfterInsert(DataSet: TDataSet);
begin
  Inc(FCounter);
  IBCQuery.FieldByName('STAMP_ADD').AsDateTime := Now;
  IBCQuery.FieldByName('TITLE').AsString := 'Record' + IntToStr(FCounter);
  IBCQuery.FieldByName('VAL').AsString := 'Value' + IntToStr(FCounter);
end;

procedure TDB_KeyFrame.Initialize;
begin
  IBCQuery.Connection := TIBCConnection(Connection);
end;

procedure TDB_KeyFrame.SetDebug(Value: boolean);
begin
  IBCQuery.Debug := Value;
end;

procedure TDB_KeyFrame.btAddRecordClick(Sender: TObject);
begin
  IBCQuery.Append;
  IBCQuery.Post;  
end;

end.
