unit Main;

interface

{$IFNDEF UNIX}
{$IFNDEF POSIX}
{$DEFINE MSWINDOWS}
{$ENDIF}
{$ENDIF}
uses
  SysUtils, Classes,
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  Messages, Graphics, Controls, Forms, Dialogs,
  DBCtrls, ExtCtrls, Grids, DBGrids, StdCtrls, ToolWin, ComCtrls,
  IBC, Db, MemDS, DBAccess, IBCIP, Wwdatsrc, wwSpeedButton,
  wwDBNavigator, wwclearpanel, Buttons, Wwdbigrd, Wwdbgrid;

type
  TfmMain = class(TForm)
    wwDBGrid1: TwwDBGrid;
    IBCConnection1: TIBCConnection;
    wwDataSource1: TwwDataSource;
    wwIBCQuery: TwwIBCQuery;
    wwDBGrid1IButton: TwwIButton;
    wwIBCQueryDEPTNO: TIntegerField;
    wwIBCQueryDNAME: TStringField;
    wwIBCQueryLOC: TStringField;
    ToolBar: TPanel;
    btOpen: TButton;
    btClose: TButton;
    wwDBNavigator1: TwwDBNavigator;
    wwDBNavigator1First: TwwNavButton;
    wwDBNavigator1PriorPage: TwwNavButton;
    wwDBNavigator1Prior: TwwNavButton;
    wwDBNavigator1Next: TwwNavButton;
    wwDBNavigator1NextPage: TwwNavButton;
    wwDBNavigator1Last: TwwNavButton;
    wwDBNavigator1Insert: TwwNavButton;
    wwDBNavigator1Delete: TwwNavButton;
    wwDBNavigator1Edit: TwwNavButton;
    wwDBNavigator1Post: TwwNavButton;
    wwDBNavigator1Cancel: TwwNavButton;
    wwDBNavigator1Refresh: TwwNavButton;
    wwDBNavigator1SaveBookmark: TwwNavButton;
    wwDBNavigator1RestoreBookmark: TwwNavButton;
    procedure btOpenClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

{$R *.DFM}

procedure TfmMain.btOpenClick(Sender: TObject);
begin
  wwIBCQuery.Open;  
end;

procedure TfmMain.btCloseClick(Sender: TObject);
begin
  wwIBCQuery.Close;
end;

end.
