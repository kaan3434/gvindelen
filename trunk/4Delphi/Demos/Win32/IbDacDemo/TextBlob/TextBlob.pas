{$I DacDemo.inc}

unit TextBlob;

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
  DBAccess, IBC, DemoFrame, DAScript, IBCScript;

type
  TTextBlobFrame = class(TDemoFrame)
    DBGrid: TDBGrid;
    btOpen: TSpeedButton;
    DBNavigator: TDBNavigator;
    btClose: TSpeedButton;
    meComments: TDBMemo;
    Panel1: TPanel;
    btCopyRecord: TSpeedButton;
    btCopyRecord1: TSpeedButton;
    btCopyRecord2: TSpeedButton;
    Splitter1: TSplitter;
    ToolBar1: TPanel;
    btLoad: TSpeedButton;
    btSave: TSpeedButton;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    btClear: TSpeedButton;
    cbDefBlobRead: TCheckBox;
    cbCacheBlobs: TCheckBox;
    cbStreamedBlobs: TCheckBox;
    IBCQuery: TIBCQuery;
    quInsertRecord: TIBCQuery;
    quCopyRecord: TIBCQuery;
    DataSource: TDataSource;
    spSelectRecord: TIBCStoredProc;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Label1: TLabel;
    lbBlobProps: TLabel;
    procedure btOpenClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure btCopyRecordClick(Sender: TObject);
    procedure btCopyRecord1Click(Sender: TObject);
    procedure btCopyRecord2Click(Sender: TObject);
    procedure btLoadClick(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
    procedure btLoad1Click(Sender: TObject);
    procedure btClearClick(Sender: TObject);
    procedure cbDefBlobReadClick(Sender: TObject);
    procedure cbCacheBlobsClick(Sender: TObject);
    procedure cbStreamedBlobsClick(Sender: TObject);
    procedure IBCQueryAfterScroll(DataSet: TDataSet);
    procedure IBCQueryAfterClose(DataSet: TDataSet);
  public
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

procedure TTextBlobFrame.btOpenClick(Sender: TObject);
begin
  if not IBCQuery.Options.CacheBlobs and (not IBCQuery.Options.DeferredBlobRead or
  not IBCQuery.Options.StreamedBlobs) then
    MessageDlg('It is not recomended to use non-cached BLOBS without' + #10#13 +
      'DeferredBlobRead and StreamedBlobs options',  mtInformation, [mbOk], 0);
  IBCQuery.Open;
end;

procedure TTextBlobFrame.btCloseClick(Sender: TObject);
begin
  IBCQuery.Close;
end;

procedure TTextBlobFrame.btCopyRecordClick(Sender: TObject);
begin
  if not IBCQuery.EOF then begin
    quInsertRecord.ParamByName('Code').AsInteger := Random(10000);
    quInsertRecord.ParamByName('Title').AsString :=
      IBCQuery.FieldByName('Title').AsString;
    quInsertRecord.ParamByName('Val').DataType := ftBlob;
    quInsertRecord.ParamByName('Val').AsIbBlob := IBCQuery.GetBlob('Val');
    quInsertRecord.Execute;

    IBCQuery.Refresh;
  end;
end;

procedure TTextBlobFrame.btCopyRecord1Click(Sender: TObject);
begin
  if not IBCQuery.EOF then begin
    spSelectRecord.StoredProcName := 'IBDAC_SEL_FROM_TEXT_BLOB';
    spSelectRecord.PrepareSQL;
    spSelectRecord.ParamByName('Code').AsInteger :=
      IBCQuery.FieldByName('Code').AsInteger;
    spSelectRecord.Execute;

    quInsertRecord.ParamByName('Code').AsInteger := Random(10000);
    quInsertRecord.ParamByName('Title').AsString :=
      spSelectRecord.ParamByName('Title').AsString;
    quInsertRecord.ParamByName('Val').DataType := ftBlob;
    quInsertRecord.ParamByName('Val').AsIbBlob  :=
      spSelectRecord.ParamByName('Val').AsIbBlob;

    quInsertRecord.Execute;

    IBCQuery.Refresh;
  end;
end;

procedure TTextBlobFrame.btCopyRecord2Click(Sender: TObject);
begin
  if not IBCQuery.EOF then begin
    quCopyRecord.ParamByName('Code').AsString :=
      IBCQuery.FieldByName('Code').AsString;
    quCopyRecord.MacroByName('CodeNew').Value := IntToStr(Random(10000));
    quCopyRecord.Execute;
    IBCQuery.Refresh;
  end;
end;

procedure TTextBlobFrame.btLoadClick(Sender: TObject);
begin
  if IBCQuery.Active and OpenDialog.Execute then begin
    if IBCQuery.State = dsBrowse then
      IBCQuery.Edit;
    TBlobField(IBCQuery.FieldByName('Val')).LoadFromFile(OpenDialog.FileName);
  end;
end;

procedure TTextBlobFrame.btLoad1Click(Sender: TObject);
var
  Stream: TStream;
  BlobStream: TStream;
begin
  if IBCQuery.Active and OpenDialog.Execute then begin
    if IBCQuery.State = dsBrowse then
      IBCQuery.Edit;

    Stream := nil;
    BlobStream := nil;
    try
      Stream := TFileStream.Create(OpenDialog.FileName, fmOpenRead);
      BlobStream := IBCQuery.CreateBlobStream(
        IBCQuery.FieldByName('Val'), bmWrite);

      BlobStream.CopyFrom(Stream, 0);
    finally
      BlobStream.Free;
      Stream.Free;
    end;
  end;
end;

procedure TTextBlobFrame.btSaveClick(Sender: TObject);
begin
  if not IBCQuery.EOF and SaveDialog.Execute then
    TBlobField(IBCQuery.FieldByName('Val')).SaveToFile(SaveDialog.FileName);
end;

procedure TTextBlobFrame.btClearClick(Sender: TObject);
begin
  if IBCQuery.Active then begin
    if IBCQuery.State = dsBrowse then
      IBCQuery.Edit;
    IBCQuery.FieldByName('Val').AsString := '';
  end;
end;

procedure TTextBlobFrame.cbDefBlobReadClick(Sender: TObject);
begin
  IBCQuery.Options.DeferredBlobRead := cbDefBlobRead.Checked;
end;

procedure TTextBlobFrame.cbCacheBlobsClick(Sender: TObject);
begin
  try
    IBCQuery.Options.CacheBlobs := cbCacheBlobs.Checked;
  except
    cbCacheBlobs.Checked := IBCQuery.Options.CacheBlobs;
  end;
end;

procedure TTextBlobFrame.cbStreamedBlobsClick(Sender: TObject);
begin
  try
    IBCQuery.Options.StreamedBlobs := cbStreamedBlobs.Checked;
    spSelectRecord.Options.StreamedBlobs := cbStreamedBlobs.Checked;
    quInsertRecord.Options.StreamedBlobs := cbStreamedBlobs.Checked;
    quCopyRecord.Options.StreamedBlobs := cbStreamedBlobs.Checked;
  except
    cbStreamedBlobs.Checked := IBCQuery.Options.StreamedBlobs;
  end;
end;

procedure TTextBlobFrame.Initialize;
begin
  spSelectRecord.Connection := TIBCConnection(Connection);
  quInsertRecord.Connection := TIBCConnection(Connection);
  quCopyRecord.Connection := TIBCConnection(Connection);
  IBCQuery.Connection := TIBCConnection(Connection);
  
  cbDefBlobRead.Checked := IBCQuery.Options.DeferredBlobRead;
  cbCacheBlobs.Checked := IBCQuery.Options.CacheBlobs;
  Randomize;
end;

procedure TTextBlobFrame.SetDebug(Value: boolean);
begin
  spSelectRecord.Debug := Value;
  quInsertRecord.Debug := Value;
  quCopyRecord.Debug := Value;
  IBCQuery.Debug := Value;
end;

procedure TTextBlobFrame.IBCQueryAfterScroll(DataSet: TDataSet);

  function BoolToStr(B: boolean): string;
  begin
    if B then
      Result := 'True'
    else
      Result := 'False';
  end;

const
  SubTypeNames: array [0..8] of string = ('UNTYPED', 'TEXT', 'BLR', 'ACL',
    'RANGES', 'SUMMARY', 'FORMAT', 'TRANSACTION_DESCRIPTION', 'EXTERNAL_FILE_DESCRIPTION');

begin
  if IBCQuery.GetBlob('VAL') <> nil then begin
    lbBlobProps.Visible := True;
    with IBCQuery.GetBlob('VAL') do
      lbBlobProps.Caption := 'Cached = ' + BoolToStr(Cached) +
        '; Streamed = ' + BoolToStr(Streamed) +
      {$IFDEF HAVE_COMPRESS}
        '; Compressed = ' + BoolToStr(Compressed) +
      {$ENDIF}
        '; LengthBlob = ' + IntToStr(LengthBlob) +
        '; SubType = ' + SubTypeNames[SubType] +
        '; IsUnicode = ' + BoolToStr(IsUnicode) +
        '; CharsetID = ' + IntToStr(CharsetID);
  end
  else
    lbBlobProps.Visible := False;
end;

procedure TTextBlobFrame.IBCQueryAfterClose(DataSet: TDataSet);
begin
  lbBlobProps.Visible := False;
end;

{$IFDEF FPC}
initialization
  {$i TextBlob.lrs}
{$ENDIF}

end.
