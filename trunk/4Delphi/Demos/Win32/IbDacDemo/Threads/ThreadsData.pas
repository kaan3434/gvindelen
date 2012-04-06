{$I DacDemo.inc}

unit ThreadsData;

interface

uses
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  Menus, ImgList, StdCtrls, ComCtrls, Buttons, ExtCtrls, Graphics,
  Controls, Forms, Dialogs, DBCtrls, Grids, DBGrids,
  SysUtils, Classes, Db, MemDS, DBAccess, IBC;

type
  TThreadsDataModule = class(TDataModule)
    IBCConnection: TIBCConnection;
    IBCQuery: TIBCQuery;
    IBCSQL: TIBCSQL;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ThreadsDataModule: TThreadsDataModule;

implementation

{$IFNDEF FPC}
{$IFDEF CLR}
{$R *.nfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}
{$ENDIF}

end.
