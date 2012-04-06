{$I DacDemo.inc}

unit LongStrings;

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
  TLongStringsFrame = class(TDemoFrame)
    DataSource: TDataSource;
    ToolBar: TPanel;
    DBNavigator: TDBNavigator;
    meComments: TDBMemo;
    Splitter1: TSplitter;
    btLoad: TSpeedButton;
    btSave: TSpeedButton;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    cbLongStrings: TCheckBox;
    btClear: TSpeedButton;
    IBCQuery: TIBCQuery;
    btOpen: TSpeedButton;
    btClose: TSpeedButton;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    DBGrid1: TDBGrid;
    procedure btOpenClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure btLoadClick(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
    procedure cbLongStringsClick(Sender: TObject);
    procedure btClearClick(Sender: TObject);
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

procedure TLongStringsFrame.btOpenClick(Sender: TObject);
begin
  IBCQuery.Open;
end;

procedure TLongStringsFrame.btCloseClick(Sender: TObject);
begin
  IBCQuery.Close;
end;

procedure TLongStringsFrame.btLoadClick(Sender: TObject);
var
  List: TStringList;
begin
  if IBCQuery.Active and OpenDialog.Execute then begin
    if IBCQuery.State = dsBrowse then
      IBCQuery.Edit;

    if IBCQuery.FieldByName('Val') is TBlobField then
      TBlobField(IBCQuery.FieldByName('Val')).LoadFromFile(OpenDialog.FileName)
    else begin
      List := TStringList.Create;
      try
        List.LoadFromFile(OpenDialog.FileName);
        IBCQuery.FieldByName('Val').AsString := List.Text;
      finally
        List.Free;
      end;
    end;
  end;
end;

procedure TLongStringsFrame.btSaveClick(Sender: TObject);
var
  List: TStringList;
begin
  if not IBCQuery.EOF and SaveDialog.Execute then
    if IBCQuery.FieldByName('Val') is TBlobField then
      TBlobField(IBCQuery.FieldByName('Val')).SaveToFile(SaveDialog.FileName)
    else begin
      List := TStringList.Create;
      try
        List.Text := IBCQuery.FieldByName('Val').AsString;
        List.SaveToFile(SaveDialog.FileName);
      finally
        List.Free;
      end;
    end;
end;

procedure TLongStringsFrame.cbLongStringsClick(Sender: TObject);
var
  OldActive: boolean;
begin
  OldActive := IBCQuery.Active;
  IBCQuery.Active := False;
  IBCQuery.Options.LongStrings := cbLongStrings.Checked;
  IBCQuery.Active := OldActive;
end;

procedure TLongStringsFrame.btClearClick(Sender: TObject);
begin
  if IBCQuery.Active then begin
    if IBCQuery.State = dsBrowse then
      IBCQuery.Edit;
    IBCQuery.FieldByName('Val').AsString := '';
  end;
end;

procedure TLongStringsFrame.Initialize;
begin
  IBCQuery.Connection := TIBCConnection(Connection);
  IBCQuery.Options.LongStrings := cbLongStrings.Checked;
end;

procedure TLongStringsFrame.SetDebug(Value: boolean);
begin
  IBCQuery.Debug := Value;
end;

{$IFDEF FPC}
initialization
  {$i LongStrings.lrs}
{$ENDIF}

end.
