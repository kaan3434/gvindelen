{$I DacDemo.inc}

unit Fetch;

interface

uses
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF}
  Graphics, Controls, Forms, Dialogs, Buttons,
  DBCtrls, ExtCtrls, Grids, DBGrids, StdCtrls, ToolWin, ComCtrls,
{$IFDEF CLR}
  System.ComponentModel,
{$ENDIF}
{$IFDEF FPC}
  LResources, LCLType,
{$ENDIF}
  SysUtils, Classes;

type
  TFetchForm = class(TForm)
    Label1: TLabel;
    Panel1: TPanel;
    btCancel: TSpeedButton;
    ProgressBar: TProgressBar;
    procedure btCancelClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    CancelLoad: boolean;
  end;

var
  FetchForm: TFetchForm;

implementation

{$IFNDEF FPC}
{$IFDEF CLR}
{$R *.nfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}
{$ENDIF}

procedure TFetchForm.btCancelClick(Sender: TObject);
begin
  CancelLoad := True;
  Hide;
end;

procedure TFetchForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

procedure TFetchForm.FormShow(Sender: TObject);
begin
  ProgressBar.Position := 0;
end;

{$IFDEF FPC}
initialization
  {$i Fetch.lrs}
{$ENDIF}
end.
