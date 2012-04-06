{$I DacDemo.inc}

unit CachedUpdates;

interface

uses
  Classes, SysUtils,
{$IFNDEF WIN32_64}
  Types,
{$ENDIF}
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
  TCachedUpdatesFrame = class(TDemoFrame)
    DataSource: TDataSource;
    IBCQuery: TIBCQuery;
    IBCQueryDEPTNO: TIntegerField;
    IBCQueryDNAME: TStringField;
    IBCQueryLOC: TStringField;
    IBCQueryStatus: TStringField;
    UpdTransaction: TIBCTransaction;
    DBGrid: TDBGrid;
    ToolBar: TPanel;
    Panel8: TPanel;
    RefreshRecord: TSpeedButton;
    btClose: TSpeedButton;
    btOpen: TSpeedButton;
    DBNavigator: TDBNavigator;
    Panel10: TPanel;
    cbCachedUpdates: TCheckBox;
    cbCustomUpdate: TCheckBox;
    Panel6: TPanel;
    Label1: TLabel;
    cbDeleted: TCheckBox;
    cbInserted: TCheckBox;
    cbModified: TCheckBox;
    cbUnmodified: TCheckBox;
    Panel1: TPanel;
    Label2: TLabel;
    Panel3: TPanel;
    btApply: TSpeedButton;
    btCommit: TSpeedButton;
    btCancel: TSpeedButton;
    btRevertRecord: TSpeedButton;
    Panel4: TPanel;
    Label3: TLabel;
    Panel5: TPanel;
    btStartTrans: TSpeedButton;
    btCommitTrans: TSpeedButton;
    btRollBackTrans: TSpeedButton;
    Panel2: TPanel;
    cbAutoCommit: TCheckBox;
    procedure btOpenClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure btApplyClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure btStartTransClick(Sender: TObject);
    procedure btCommitTransClick(Sender: TObject);
    procedure btRollbackTransClick(Sender: TObject);
    procedure cbCachedUpdatesClick(Sender: TObject);
    procedure IBCQueryUpdateError(DataSet: TDataSet; E: EDatabaseError;
      UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure IBCQueryUpdateRecord(DataSet: TDataSet;
      UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure cbCustomUpdateClick(Sender: TObject);
    procedure IBCQueryCalcFields(DataSet: TDataSet);
    procedure btCommitClick(Sender: TObject);
    procedure cbUnmodifiedClick(Sender: TObject);
    procedure cbModifiedClick(Sender: TObject);
    procedure cbInsertedClick(Sender: TObject);
    procedure cbDeletedClick(Sender: TObject);
    procedure DataSourceDataChange(Sender: TObject; Field: TField);
    procedure DataSourceStateChange(Sender: TObject);
    procedure DBGridDrawDataCell(Sender: TObject; const Rect: TRect;
      Field: TField; State: TGridDrawState);
    procedure btRevertRecordClick(Sender: TObject);
    procedure RefreshRecordClick(Sender: TObject);
    procedure cbAutoCommitClick(Sender: TObject);
  private
    { Private declarations }
    procedure ShowTrans;
    procedure ShowPending;
    procedure ShowUpdateRecordTypes;
  public
    procedure Initialize; override;
    procedure SetDebug(Value: boolean); override;
    destructor Destroy; override;
  end;

var
  fmCachedUpdates: TCachedUpdatesFrame;

implementation

uses
  UpdateAction, IbDacDemoForm;

{$IFNDEF FPC}
{$IFDEF CLR}
{$R *.nfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}
{$ENDIF}

procedure TCachedUpdatesFrame.ShowTrans;
begin
  if UpdTransaction.Active then
    IbDacForm.StatusBar.Panels[2].Text := 'UpdateTransaction is Active'
  else
    IbDacForm.StatusBar.Panels[2].Text := '';
end;

procedure TCachedUpdatesFrame.ShowPending;
begin
  if IBCQuery.UpdatesPending then
    IbDacForm.StatusBar.Panels[1].Text := 'Updates Pending'
  else
    IbDacForm.StatusBar.Panels[1].Text := '';
end;

procedure TCachedUpdatesFrame.ShowUpdateRecordTypes;
begin
  if IBCQuery.CachedUpdates then begin
    cbUnmodified.Enabled := true;
    cbModified.Enabled := true;
    cbInserted.Enabled := true;
    cbDeleted.Enabled := true;
    cbUnmodified.Checked := rtUnmodified in IBCQuery.UpdateRecordTypes;
    cbModified.Checked := rtModified in IBCQuery.UpdateRecordTypes;
    cbInserted.Checked := rtInserted in IBCQuery.UpdateRecordTypes;
    cbDeleted.Checked := rtDeleted in IBCQuery.UpdateRecordTypes;
  end
  else begin
    cbUnmodified.Enabled := false;
    cbModified.Enabled := false;
    cbInserted.Enabled := false;
    cbDeleted.Enabled := false;
  end;
end;

procedure TCachedUpdatesFrame.btOpenClick(Sender: TObject);
begin
  IBCQuery.Open;
end;

procedure TCachedUpdatesFrame.btCloseClick(Sender: TObject);
begin
  IBCQuery.Close;
end;

procedure TCachedUpdatesFrame.btApplyClick(Sender: TObject);
begin
  IBCQuery.ApplyUpdates;
  ShowPending;
end;

procedure TCachedUpdatesFrame.btCommitClick(Sender: TObject);
begin
  IBCQuery.CommitUpdates;
  ShowPending;
end;

procedure TCachedUpdatesFrame.btCancelClick(Sender: TObject);
begin
  IBCQuery.CancelUpdates;
  ShowPending;
end;

procedure TCachedUpdatesFrame.btStartTransClick(Sender: TObject);
begin
  UpdTransaction.StartTransaction;
  ShowTrans;
end;

procedure TCachedUpdatesFrame.btCommitTransClick(Sender: TObject);
begin
  UpdTransaction.Commit;
  ShowTrans;
end;

procedure TCachedUpdatesFrame.btRollbackTransClick(Sender: TObject);
begin
  UpdTransaction.Rollback;
  ShowTrans;
end;

procedure TCachedUpdatesFrame.cbCachedUpdatesClick(Sender: TObject);
begin
  try
    IBCQuery.CachedUpdates := cbCachedUpdates.Checked;
  finally
    cbCachedUpdates.Checked := IBCQuery.CachedUpdates;
    ShowUpdateRecordTypes;
  end;
end;

procedure TCachedUpdatesFrame.IBCQueryUpdateError(DataSet: TDataSet; E: EDatabaseError;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  UpdateActionForm.rgAction.ItemIndex := Ord(UpdateAction);
  UpdateActionForm.rgKind.ItemIndex := Ord(UpdateKind);
  UpdateActionForm.lbField.Caption := string(DataSet.Fields[0].Value);
  UpdateActionForm.lbMessage.Caption := E.Message;
  UpdateActionForm.ShowModal;
  UpdateAction:= TUpdateAction(UpdateActionForm.rgAction.ItemIndex);
end;

procedure TCachedUpdatesFrame.IBCQueryUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  UpdateActionForm.rgAction.ItemIndex := Ord(UpdateAction);
  UpdateActionForm.rgKind.ItemIndex := Ord(UpdateKind);
  UpdateActionForm.lbField.Caption := string(DataSet.Fields[0].NewValue);
  UpdateActionForm.lbMessage.Caption := '';
  UpdateActionForm.ShowModal;
  UpdateAction := TUpdateAction(UpdateActionForm.rgAction.ItemIndex);
end;

procedure TCachedUpdatesFrame.cbCustomUpdateClick(Sender: TObject);
begin
  if cbCustomUpdate.Checked then
    IBCQuery.OnUpdateRecord := IBCQueryUpdateRecord
  else
    IBCQuery.OnUpdateRecord := nil;
end;

procedure TCachedUpdatesFrame.IBCQueryCalcFields(DataSet: TDataSet);
var
  St:string;
begin
  case Ord(TIBCQuery(DataSet).UpdateStatus) of
    0: St := 'Unmodified';
    1: St := 'Modified';
    2: St := 'Inserted';
    3: St := 'Deleted';
  end;
  DataSet.FieldByName('Status').AsString := St;
end;

procedure TCachedUpdatesFrame.cbUnmodifiedClick(Sender: TObject);
begin
  try
    if cbUnmodified.Checked then
      IBCQuery.UpdateRecordTypes := IBCQuery.UpdateRecordTypes + [rtUnmodified]
    else
      IBCQuery.UpdateRecordTypes := IBCQuery.UpdateRecordTypes - [rtUnmodified];
  finally
    cbUnmodified.Checked := rtUnmodified in IBCQuery.UpdateRecordTypes;
  end;
end;

procedure TCachedUpdatesFrame.cbModifiedClick(Sender: TObject);
begin
  if cbModified.Checked then
    IBCQuery.UpdateRecordTypes := IBCQuery.UpdateRecordTypes + [rtModified]
  else
    IBCQuery.UpdateRecordTypes := IBCQuery.UpdateRecordTypes - [rtModified];
end;

procedure TCachedUpdatesFrame.cbInsertedClick(Sender: TObject);
begin
  if cbInserted.Checked then
    IBCQuery.UpdateRecordTypes := IBCQuery.UpdateRecordTypes + [rtInserted]
  else
    IBCQuery.UpdateRecordTypes := IBCQuery.UpdateRecordTypes - [rtInserted]
end;

procedure TCachedUpdatesFrame.cbDeletedClick(Sender: TObject);
begin
  if cbDeleted.Checked then
    IBCQuery.UpdateRecordTypes := IBCQuery.UpdateRecordTypes + [rtDeleted]
  else
    IBCQuery.UpdateRecordTypes := IBCQuery.UpdateRecordTypes - [rtDeleted];
end;

procedure TCachedUpdatesFrame.DataSourceStateChange(Sender: TObject);
begin
  ShowPending;
  IbDacForm.StatusBar.Panels[3].Text := 'Record ' + IntToStr(IBCQuery.RecNo) + ' of ' + IntToStr(IBCQuery.RecordCount) ;
end;

procedure TCachedUpdatesFrame.DataSourceDataChange(Sender: TObject; Field: TField);
begin
  DataSourceStateChange(nil);
end;

procedure TCachedUpdatesFrame.DBGridDrawDataCell(Sender: TObject; const Rect: TRect;
  Field: TField; State: TGridDrawState);
begin
{$IFNDEF FPC}
  if IBCQuery.UpdateResult in [uaFail,uaSkip] then
    TDBGrid(Sender).Canvas.Brush.Color := clRed
  else
    if IBCQuery.UpdateStatus <> usUnmodified then
      TDBGrid(Sender).Canvas.Brush.Color := clYellow;

  TDBGrid(Sender).DefaultDrawDataCell(Rect, Field, State);
{$ENDIF}
end;

procedure TCachedUpdatesFrame.btRevertRecordClick(Sender: TObject);
begin
  IBCQuery.RevertRecord;
  ShowPending;
end;

procedure TCachedUpdatesFrame.RefreshRecordClick(Sender: TObject);
begin
  IBCQuery.RefreshRecord;
end;

procedure TCachedUpdatesFrame.cbAutoCommitClick(Sender: TObject);
begin
  IBCQuery.AutoCommit := cbAutoCommit.Checked;
end;

procedure TCachedUpdatesFrame.Initialize;
begin
  IBCQuery.Connection := TIBCConnection(Connection);
  UpdTransaction.DefaultConnection := TIBCConnection(Connection);

  UpdateActionForm := TUpdateActionForm.Create(nil);
  cbCachedUpdates.Checked := IBCQuery.CachedUpdates;
  cbAutoCommit.Checked := IBCQuery.AutoCommit;
  ShowUpdateRecordTypes;
end;

destructor TCachedUpdatesFrame.Destroy;
begin
  FreeAndNil(UpdateActionForm);
  inherited;
end;

procedure TCachedUpdatesFrame.SetDebug(Value: boolean);
begin
  IBCQuery.Debug := Value;
end;

{$IFDEF FPC}
initialization
  {$i CachedUpdates.lrs}
{$ENDIF}

end.
