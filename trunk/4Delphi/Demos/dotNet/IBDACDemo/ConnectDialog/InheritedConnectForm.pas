{$I DacDemo.inc}

unit InheritedConnectForm;

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
  DB, DBAccess, IBC, DemoFrame, IBCConnectForm;

type
  TfmInheritedConnect = class(TIBCConnectForm)
    lbRole: TLabel;
    edRole: TEdit;
  private
  protected
    procedure DoInit; override;
    procedure DoConnect; override;

  public

    { Public declarations }
  end;

var
  fmInheritedConnect: TfmInheritedConnect;

implementation

{$IFNDEF FPC}
{$IFDEF CLR}
{$R *.nfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}
{$ENDIF}

procedure TfmInheritedConnect.DoInit;
begin
  inherited;
  lbRole.Caption := 'Role';
end;

procedure TfmInheritedConnect.DoConnect;
begin
  TIBCConnection(ConnectDialog.Connection).Options.Role := edRole.Text;
  inherited;
end;


initialization
{$IFDEF FPC}
{$i InheritedConnectForm.lrs}
{$ENDIF}

  if GetClass('TfmInheritedConnect') = nil then
    Classes.RegisterClass(TfmInheritedConnect);
end.
