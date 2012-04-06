{$I DacDemo.inc}

unit ConnectDialog;

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
  DBAccess, IBC, DemoFrame, InheritedConnectForm, MyConnectForm;

type
  TConnectDialogFrame = class(TDemoFrame)
    ToolBar: TPanel;
    btOpen: TSpeedButton;
    btClose: TSpeedButton;
    DBNavigator: TDBNavigator;
    DataSource: TDataSource;
    DBGrid: TDBGrid;
    rbDefault: TRadioButton;
    rbMy: TRadioButton;
    rbInherited: TRadioButton;
    IBCQuery: TIBCQuery;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    procedure btOpenClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure rbDefaultClick(Sender: TObject);
    procedure rbMyClick(Sender: TObject);
    procedure rbInheritedClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Initialize; override;
    destructor Destroy; override;
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

destructor TConnectDialogFrame.Destroy;
begin
  IbDacForm.IBCConnectDialog.DialogClass:= '';
  inherited;
end;

procedure TConnectDialogFrame.btOpenClick(Sender: TObject);
begin
  IBCQuery.Open;
end;

procedure TConnectDialogFrame.btCloseClick(Sender: TObject);
begin
  IBCQuery.Close;
end;

procedure TConnectDialogFrame.rbDefaultClick(Sender: TObject);
begin
  IbDacForm.IBCConnectDialog.DialogClass:= '';
end;

procedure TConnectDialogFrame.rbMyClick(Sender: TObject);
begin
  IbDacForm.IBCConnectDialog.DialogClass:= 'TfmMyConnect';
end;

procedure TConnectDialogFrame.rbInheritedClick(Sender: TObject);
begin
  IbDacForm.IBCConnectDialog.DialogClass:= 'TfmInheritedConnect';
end;

procedure TConnectDialogFrame.Initialize;
begin
  IBCQuery.Connection := TIBCConnection(Connection);
end;

{$IFDEF FPC}
initialization
  {$i ConnectDialog.lrs}
{$ENDIF}

end.
