{$I DacDemo.inc}

unit BlobPictures;

interface

uses
  Classes, SysUtils,
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  Menus, ImgList, StdCtrls, ComCtrls, Buttons, ExtCtrls, Graphics,
  Controls, Forms, Dialogs, DBCtrls, Grids, DBGrids, ExtDlgs, IbDacVcl,
{$IFNDEF VER130}
  Variants,
{$ENDIF}
  DB, DBAccess, IBC, DemoFrame, MemDS, DAScript, IBCScript, MemData;

type
  TBlobPicturesFrame = class(TDemoFrame)
    DBGrid1: TDBGrid;
    DBImage: TDBImage;
    ToolBar: TPanel;
    btOpen: TSpeedButton;
    btClose: TSpeedButton;
    DBNavigator: TDBNavigator;
    Splitter1: TSplitter;
    btLoad: TSpeedButton;
    btSave: TSpeedButton;
    btClear: TSpeedButton;
    btAddRecord: TSpeedButton;
    cbDefBlobRead: TCheckBox;
    IBCStoredProc: TIBCStoredProc;
    DataSource: TDataSource;
    IBCQuery: TIBCQuery;
    cbCacheBlobs: TCheckBox;
    cbStreamedBlobs: TCheckBox;
    cbxCompression: TComboBox;
    IBCQueryID: TIntegerField;
    IBCQueryTITLE: TStringField;
    IBCQueryPIC: TBlobField;
    IBCQuerySize: TIntegerField;
    IBCQueryCompressedSize: TIntegerField;
    IBCQueryServerSize: TIntegerField;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Label1: TLabel;
    lbBlobProps: TLabel;
    procedure btLoadClick(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
    procedure btOpenClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure btClearClick(Sender: TObject);
    procedure btAddRecordClick(Sender: TObject);
    procedure cbDefBlobReadClick(Sender: TObject);
    procedure cbCacheBlobsClick(Sender: TObject);
    procedure cbStreamedBlobsClick(Sender: TObject);
    procedure cbxCompressionChange(Sender: TObject);
    procedure IBCQueryCalcFields(DataSet: TDataSet);
    procedure IBCQueryAfterScroll(DataSet: TDataSet);
    procedure IBCQueryAfterClose(DataSet: TDataSet);
  private
    procedure SetCompressionType;
    procedure GetCompressionType;
  public
    procedure Initialize; override;
    procedure SetDebug(Value: boolean); override;
  end;


implementation

uses IbDacDemoForm;

{$IFNDEF FPC}
{$IFDEF CLR}
{$R *.nfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}
{$ENDIF}

procedure TBlobPicturesFrame.SetCompressionType;
begin
{$IFDEF HAVE_COMPRESS}
  case cbxCompression.ItemIndex of
    0: begin
      IBCQuery.Options.CompressBlobMode := cbNone;
      IBCStoredProc.Options.CompressBlobMode := cbNone;
    end;
    1: begin
      IBCQuery.Options.CompressBlobMode := cbClient;
      IBCStoredProc.Options.CompressBlobMode := cbClient;
    end;
    2: begin
      IBCQuery.Options.CompressBlobMode := cbServer;
      IBCStoredProc.Options.CompressBlobMode := cbServer;
    end;
    3: begin
      IBCQuery.Options.CompressBlobMode := cbClientServer;
      IBCStoredProc.Options.CompressBlobMode := cbClientServer;
    end;
  end;
{$ENDIF}
end;

procedure TBlobPicturesFrame.GetCompressionType;
begin
{$IFDEF HAVE_COMPRESS}
  case IBCQuery.Options.CompressBlobMode of
    cbNone: cbxCompression.ItemIndex := 0;
    cbClient: cbxCompression.ItemIndex := 1;
    cbServer: cbxCompression.ItemIndex := 2;
    cbClientServer: cbxCompression.ItemIndex := 3;
  end;
{$ENDIF}
end;

procedure TBlobPicturesFrame.btOpenClick(Sender: TObject);
begin
  if not IBCQuery.Options.CacheBlobs and (not IBCQuery.Options.DeferredBlobRead or
  not IBCQuery.Options.StreamedBlobs) then
    MessageDlg('It is not recomended to use non-cached BLOBS without' + #10#13 +
      'DeferredBlobRead and StreamedBlobs options',  mtInformation, [mbOk], 0);
  IBCQuery.Open;
end;

procedure TBlobPicturesFrame.btCloseClick(Sender: TObject);
begin
  IBCQuery.Close;
end;

procedure TBlobPicturesFrame.btLoadClick(Sender: TObject);
begin
{$IFDEF UNIX}
  with TOpenDialog.Create(nil) do
{$ELSE}
  with TOpenPictureDialog.Create(nil) do
{$ENDIF}
    try
      InitialDir := '.\BlobPictures\';
      if IBCQuery.Active and Execute then begin
        if IBCQuery.State = dsBrowse then
          IBCQuery.Edit;
        IbDacForm.StatusBar.Panels[0].Text := '';
      TBlobField(IBCQuery.FieldByName('Pic')).LoadFromFile(FileName);
      end;
    finally
      Free;
    end;
end;

procedure TBlobPicturesFrame.btSaveClick(Sender: TObject);
begin
{$IFDEF UNIX}
  with TSaveDialog.Create(nil) do
{$ELSE}
  with TSavePictureDialog.Create(nil) do
{$ENDIF}
    try
      InitialDir := '.\BlobPictures\';
      if not IBCQuery.EOF and Execute then

        TBlobField(IBCQuery.FieldByName('Pic')).SaveToFile(FileName);
    finally
      Free;
    end;
end;

procedure TBlobPicturesFrame.btClearClick(Sender: TObject);
begin
  if IBCQuery.State = dsBrowse then
    IBCQuery.Edit;
  TBlobField(IBCQuery.FieldByName('Pic')).Clear;
end;

procedure TBlobPicturesFrame.btAddRecordClick(Sender: TObject);
begin
{$IFDEF UNIX}
  with TOpenDialog.Create(nil) do
{$ELSE}
  with TOpenPictureDialog.Create(nil) do
{$ENDIF}
    try
      InitialDir := '.\BlobPictures\';
      if Execute then begin
        with IBCStoredProc do begin
          StoredProcName := 'IBDAC_BLOB_INSERT';
          PrepareSQL;  // receive parameters

          Randomize;
          ParamByName('p_ID').AsInteger := Random(1000);
          ParamByName('p_Title').AsString := ExtractFileName(FileName);

          ParamByName('p_Pic').ParamType := ptInput;  // to transfer Lob data to InterBase
          ParamByName('p_Pic').AsIbBlob.LoadFromFile(FileName);
          Execute;
        end;
        IBCQuery.Refresh;
      end;
    finally
      Free;
    end;
end;

procedure TBlobPicturesFrame.cbDefBlobReadClick(Sender: TObject);
begin
  IBCQuery.Options.DeferredBLobRead := cbDefBlobRead.Checked;
end;

procedure TBlobPicturesFrame.cbCacheBlobsClick(Sender: TObject);
begin
  try
    IBCQuery.Options.CacheBlobs := cbCacheBlobs.Checked;
  except
    cbCacheBlobs.Checked := IBCQuery.Options.CacheBlobs;
  end;
end;

procedure TBlobPicturesFrame.cbStreamedBlobsClick(Sender: TObject);
begin
  IBCQuery.Options.StreamedBlobs := cbStreamedBlobs.Checked;
  IBCStoredProc.Options.StreamedBlobs := cbStreamedBlobs.Checked;
end;

procedure TBlobPicturesFrame.cbxCompressionChange(Sender: TObject);
begin
  try
    SetCompressionType;
  except
    GetCompressionType;
    raise;
  end;
end;

procedure TBlobPicturesFrame.IBCQueryCalcFields(DataSet: TDataSet);
begin
  with TIBCQuery(DataSet) do begin
    FieldByName('Size').AsInteger := TBlobField(IBCQuery.FieldByName('Pic')).BlobSize;
    FieldByName('ServerSize').AsInteger := IBCQuery.GetBlob('Pic').LengthBlob;
{$IFDEF HAVE_COMPRESS}
    if GetBlob('Pic').Compressed then
      FieldByName('CompressedSize').AsInteger := GetBlob('Pic').CompressedSize
    else
{$ENDIF}
      FieldByName('CompressedSize').AsString := '';
  end;
end;

procedure TBlobPicturesFrame.Initialize;
begin
  IBCQuery.Connection := TIBCConnection(Connection);
  IBCStoredProc.Connection := TIBCConnection(Connection);

{$IFNDEF HAVE_COMPRESS}
  cbxCompression.Enabled := False;
{$ENDIF}
  cbStreamedBlobs.Checked := IBCQuery.Options.StreamedBlobs;
  cbDefBlobRead.Checked := IBCQuery.Options.DeferredBlobRead;
  cbCacheBlobs.Checked := IBCQuery.Options.CacheBlobs;
  GetCompressionType;
end;

procedure TBlobPicturesFrame.SetDebug(Value: boolean);
begin
  IBCQuery.Debug := Value;
  IBCStoredProc.Debug := Value;
end;

procedure TBlobPicturesFrame.IBCQueryAfterScroll(DataSet: TDataSet);

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
  if IBCQuery.GetBlob('Pic') <> nil then begin
    lbBlobProps.Visible := True;
    with IBCQuery.GetBlob('Pic') do
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

procedure TBlobPicturesFrame.IBCQueryAfterClose(DataSet: TDataSet);
begin
  lbBlobProps.Visible := False;
end;

end.



