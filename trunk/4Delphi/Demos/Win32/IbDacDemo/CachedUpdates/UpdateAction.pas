{$I DacDemo.inc}

unit UpdateAction;

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
  DB, DBAccess, IBC, DemoFrame;
    
type
  TUpdateActionForm = class(TForm)
    rgAction: TRadioGroup;
    btOk: TButton;
    Label1: TLabel;
    lbMessage: TLabel;
    rgKind: TRadioGroup;
    Label2: TLabel;
    lbField: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  UpdateActionForm: TUpdateActionForm;

implementation

{$IFNDEF FPC}
{$IFDEF CLR}
{$R *.nfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}
{$ENDIF}

{$IFDEF FPC}
initialization
  {$i UpdateAction.lrs}
{$ENDIF}

end.
