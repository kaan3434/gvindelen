{$I DacDemo.inc}

unit MasterDetail;

interface

uses
  Classes, SysUtils,
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  Menus, ImgList, StdCtrls, ComCtrls, Buttons, ExtCtrls, Graphics,
  Controls, Forms, Dialogs, DBCtrls, Grids, DBGrids, IbDacVcl,
{$IFNDEF VER130}
  Variants,
{$ENDIF}
{$IFDEF FPC}
  LResources,
{$ENDIF}
  DB, {$IFNDEF FPC}MemDS{$ELSE}MemDataSet{$ENDIF},
  DBAccess, IBC, DemoFrame;
  
type
  TMasterDetailFrame = class(TDemoFrame)
    DBGrid: TDBGrid;
    ToolBar: TPanel;
    Splitter1: TSplitter;
    ToolBar1: TPanel;
    DBGrid1: TDBGrid;
    dsDetail: TDataSource;
    dsMaster: TDataSource;
    Panel1: TPanel;
    DBNavigator1: TDBNavigator;
    Panel2: TPanel;
    btOpen: TSpeedButton;
    btClose: TSpeedButton;
    DBNavigator: TDBNavigator;
    quMaster: TIBCQuery;
    quDetail: TIBCQuery;
    rbSQL: TRadioButton;
    quDetailDEPTNO_CALCULATED: TIntegerField;
    quMasterDEPTNO_CALCULATED: TIntegerField;
    Panel3: TPanel;
    Panel6: TPanel;
    cbCacheCalcFields: TCheckBox;
    rbSimpleFields: TRadioButton;
    rbCalcFields: TRadioButton;
    Panel7: TPanel;
    cbLocalMasterDetail: TCheckBox;
    quMasterDEPTNO: TIntegerField;
    quMasterDNAME: TStringField;
    quMasterLOC: TStringField;
    quDetailEMPNO: TIntegerField;
    quDetailENAME: TStringField;
    quDetailJOB: TStringField;
    quDetailMGR: TIntegerField;
    quDetailSAL: TIntegerField;
    quDetailCOMM: TIntegerField;
    quDetailDEPTNO: TIntegerField;
    quDetailHIREDATE: TDateTimeField;
    procedure btOpenClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure rbLinkTypeClick(Sender: TObject);
    procedure cbCacheCalcFieldsClick(Sender: TObject);
    procedure quCalcFields(DataSet: TDataSet);
    procedure cbLocalMasterDetailClick(Sender: TObject);
  private
    { Private declarations }
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

procedure TMasterDetailFrame.btOpenClick(Sender: TObject);
begin
  quMaster.Open;
  quDetail.Open;
end;

procedure TMasterDetailFrame.btCloseClick(Sender: TObject);
begin
  quMaster.Close;
  quDetail.Close;
end;

procedure TMasterDetailFrame.SetDebug(Value: boolean);
begin
  quMaster.Debug:= Value;
  quDetail.Debug := Value;
end;

procedure TMasterDetailFrame.Initialize;
begin
  quMaster.Connection := TIBCConnection(Connection);
  quDetail.Connection := TIBCConnection(Connection);
  rbLinkTypeClick(nil);
end;

procedure TMasterDetailFrame.rbLinkTypeClick(Sender: TObject);
var
  OldActive: boolean;
begin
  OldActive := quMaster.Active;
  if OldActive then
    btCloseClick(nil);
  cbCacheCalcFields.Enabled := Sender = rbCalcFields;

  if rbSQL.Checked then begin
    quDetail.SQL.Text := 'SELECT * FROM Emp WHERE DeptNo = :DeptNo';
    quDetail.DetailFields := '';
    quDetail.MasterFields := '';
    quMaster.FieldByName('DEPTNO_CALCULATED').Visible := False;
    quDetail.FieldByName('DEPTNO_CALCULATED').Visible := False;
    cbLocalMasterDetail.Checked := False;
    cbLocalMasterDetail.Enabled := False;
    cbCacheCalcFields.Enabled := False;
  end
  else
  if rbSimpleFields.Checked then begin
    quDetail.SQL.Text := 'SELECT * FROM Emp';
    quDetail.DetailFields := 'DEPTNO';
    quDetail.MasterFields := 'DEPTNO';
    quMaster.FieldByName('DEPTNO_CALCULATED').Visible := False;
    quDetail.FieldByName('DEPTNO_CALCULATED').Visible := False;
    cbLocalMasterDetail.Enabled := True;
    cbCacheCalcFields.Enabled := False;
  end
  else begin
    quDetail.SQL.Text := 'SELECT * FROM Emp';
    quDetail.DetailFields := 'DEPTNO_CALCULATED';
    quDetail.MasterFields := 'DEPTNO_CALCULATED';
    quMaster.FieldByName('DEPTNO_CALCULATED').Visible := True;
    quDetail.FieldByName('DEPTNO_CALCULATED').Visible := True;
    cbLocalMasterDetail.Enabled := True;
    cbLocalMasterDetail.Checked := True;
    cbCacheCalcFields.Enabled := True;
  end;

  cbCacheCalcFieldsClick(nil);
  if OldActive then
    btOpenClick(nil);
end;

procedure TMasterDetailFrame.cbCacheCalcFieldsClick(Sender: TObject);
var
  OldActive: boolean;
begin
  OldActive := quMaster.Active;
  if OldActive then
    btCloseClick(nil);
  quMaster.Options.CacheCalcFields := cbCacheCalcFields.Checked and cbCacheCalcFields.Enabled;
  quDetail.Options.CacheCalcFields := quMaster.Options.CacheCalcFields;
  if OldActive then
    btOpenClick(nil);
end;

procedure TMasterDetailFrame.quCalcFields(DataSet: TDataSet);
begin
  DataSet.FieldByName('DEPTNO_CALCULATED').AsInteger :=
    DataSet.FieldByName('DEPTNO').AsInteger * 2;
end;

procedure TMasterDetailFrame.cbLocalMasterDetailClick(Sender: TObject);
begin
  try
    quDetail.Options.LocalMasterDetail := cbLocalMasterDetail.Checked;
  except
    cbLocalMasterDetail.Checked := quDetail.Options.LocalMasterDetail;
    raise;
  end;
end;

{$IFDEF FPC}
initialization
  {$i MasterDetail.lrs}
{$ENDIF}

end.
