
//////////////////////////////////////////////////
//  InterBase Data Access Components
//  Copyright © 1998-2011 Devart. All right reserved.
//  IbDac About Window
//////////////////////////////////////////////////

{$I DacDemo.inc}

unit IbDacAbout;

interface
uses
  Classes, SysUtils,
{$IFDEF MSWINDOWS}
  Windows, ShellApi,
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
  TIbDacAboutForm = class(TForm)
    OKBtn: TButton;
    Image1: TImage;
    Label1: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lbMail: TLabel;
    lbWeb: TLabel;
    Label4: TLabel;
    Label10: TLabel;
    lbForum: TLabel;
    Bevel2: TBevel;
    procedure lbWebClick(Sender: TObject);
    procedure lbMailClick(Sender: TObject);
    procedure lbWebMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbMailMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbForumMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbForumClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure ShowAbout;

implementation

{$IFNDEF FPC}
{$IFDEF CLR}
{$R *.nfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}
{$ENDIF}

procedure ShowAbout;
begin
  with TIbDacAboutForm.Create(Application) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TIbDacAboutForm.lbWebClick(Sender: TObject);
begin
{$IFDEF MSWINDOWS}
  ShellExecute(0, 'open', {$IFDEF FPC}PChar{$ENDIF}('http://www.devart.com/ibdac'), '', '', SW_SHOW);
  lbWeb.Font.Color := $FF0000;
{$ENDIF}
end;

procedure TIbDacAboutForm.lbMailClick(Sender: TObject);
begin
{$IFDEF MSWINDOWS}
  ShellExecute(0, 'open', {$IFDEF FPC}PChar{$ENDIF}('mailto:ibdac@devart.com'), '', '', SW_SHOW);
  lbMail.Font.Color := $FF0000;
{$ENDIF}
end;

procedure TIbDacAboutForm.lbForumClick(Sender: TObject);
begin
{$IFDEF MSWINDOWS}
  ShellExecute(0, 'open', {$IFDEF FPC}PChar{$ENDIF}('www.devart.com/forums/viewforum.php?f=24'), '', '', SW_SHOW);
  lbWeb.Font.Color := $FF0000;
{$ENDIF}
end;

procedure TIbDacAboutForm.lbWebMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  lbWeb.Font.Color := $4080FF;
end;

procedure TIbDacAboutForm.lbMailMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  lbMail.Font.Color := $4080FF;
end;

procedure TIbDacAboutForm.lbForumMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lbForum.Font.Color := $4080FF;
end;

procedure TIbDacAboutForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  lbWeb.Font.Color := $FF0000;
  lbMail.Font.Color := $FF0000;
  lbForum.Font.Color := $FF0000;
end;

{$IFDEF FPC}
initialization
  {$i IbDacAbout.lrs}
{$ENDIF}

end.
