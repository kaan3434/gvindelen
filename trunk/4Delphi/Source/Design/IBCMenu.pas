//////////////////////////////////////////////////
//  InterBase Data Access Components
//  Copyright © 2001-2011 Devart. All right reserved.
//  IBDAC IDE Menu
//////////////////////////////////////////////////

{$IFNDEF CLR}
{$I IbDac.inc}

unit IBCMenu;
{$ENDIF}
interface

uses
  DAMenu, Windows;

type
  TIBCMenu = class (TDAProductMenu)
  private
    procedure HomePageItemClick(Sender: TDAMenuClickSender{$IFDEF CLR}; E: EventArgs{$ENDIF});
    procedure IbDacPageItemClick(Sender: TDAMenuClickSender{$IFDEF CLR}; E: EventArgs{$ENDIF});
    procedure AboutItemClick(Sender: TDAMenuClickSender{$IFDEF CLR}; E: EventArgs{$ENDIF});    
    procedure DBMonitorItemClick(Sender: TDAMenuClickSender{$IFDEF CLR}; E: EventArgs{$ENDIF});
    procedure DBMonitorPageItemClick(Sender: TDAMenuClickSender{$IFDEF CLR}; E: EventArgs{$ENDIF});
  public
    constructor Create;
    function AddItems(Instance: HINST): boolean; override;    
  end;

var
  Menu: TIBCMenu;

implementation

uses
{$IFDEF CLR}
  WinUtils,
{$ENDIF}
  SysUtils, Forms, ShellApi, IBCAbout, DBMonitorClient,
  HelpUtils;

resourcestring
  sCRMenuName = 'DevartMenuIbDac';
  sIBDACMenu = '&IBDAC';
  sHelpItemCaption = 'IBDAC Help';
  sHelpItemName = 'CRIbDacHelpItem';
  sHomePageCaption = 'Devart Home Page';
  sHomePageName = 'CRIbDacHomePageItem';
  sFAQCaption = 'IBDAC FAQ';
  sFAQName = 'CRIbDacFAQItem';
  sIbDacPageCaption = 'IBDAC Home Page';
  sIbDacPageName = 'CRIbDacPageItem';
  sAboutItemCaption = 'About IBDAC...';
{$IFDEF CLR}
  sAboutItemName = 'CRIbDacAboutItemCLR';
{$ELSE}
  sAboutItemName = 'CRIbDacAboutItemWin32';
{$ENDIF}
  sDBMonitorItemCaption = 'DBMonitor';
  sDBMonitorItemName = 'IbDacDBMonitorItem';
  sDBMonitorPageCaption = 'Download DBMonitor';
  sDBMonitorPageName = 'IbDacDBMonitorPageItem';

{ TIBCMenu }

constructor TIBCMenu.Create;
begin
  inherited Create(sCRMenuName, sAboutItemCaption, sAboutItemName,
    sIBDACMenu);
  FAboutClickEvent := AboutItemClick;
end;

function TIBCMenu.AddItems(Instance: HINST): boolean;
begin
  Result := inherited AddItems(Instance);
  if not Result then
    Exit;

  with SubMenu do begin
    if HasMonitor then
      Add(sDBMonitorItemCaption, sDBMonitorItemName, DBMonitorItemClick);

    AddWizards;
    AddSeparator;

    AddFAQ(sFAQCaption, sFAQName, 'IbDac');
    AddHelp(sHelpItemCaption, sHelpItemName, 'IbDac', True);
    AddSeparator;

    Add(sHomePageCaption, sHomePageName, HomePageItemClick);
    Add(sIbDacPageCaption, sIbDacPageName, IbDacPageItemClick);
    Add(sDBMonitorPageCaption, sDBMonitorPageName, DBMonitorPageItemClick);
    AddSeparator;
    AddAbout;
  end;
end;

procedure TIBCMenu.HomePageItemClick(Sender: TDAMenuClickSender{$IFDEF CLR}; E: EventArgs{$ENDIF});
begin
  OpenUrl('http://www.devart.com');
end;

procedure TIBCMenu.IbDacPageItemClick(Sender: TDAMenuClickSender{$IFDEF CLR}; E: EventArgs{$ENDIF});
begin
  OpenUrl('http://www.devart.com/ibdac');
end;

procedure TIBCMenu.AboutItemClick(Sender: TDAMenuClickSender{$IFDEF CLR}; E: EventArgs{$ENDIF});
begin
  ShowAbout;
end;

procedure TIBCMenu.DBMonitorItemClick(Sender: TDAMenuClickSender{$IFDEF CLR}; E: EventArgs{$ENDIF});
begin
  ShellExecute(0, 'open',
  {$IFDEF CLR}
    WhereMonitor,
  {$ELSE}
    PChar(WhereMonitor),
  {$ENDIF}
    '', '', SW_SHOW);
end;

procedure TIBCMenu.DBMonitorPageItemClick(Sender: TDAMenuClickSender{$IFDEF CLR}; E: EventArgs{$ENDIF});
begin
  OpenUrl('http://www.devart.com/dbmonitor/dbmon3.exe');
end;

initialization
  Menu := TIBCMenu.Create;
finalization
  Menu.Free;
end.
